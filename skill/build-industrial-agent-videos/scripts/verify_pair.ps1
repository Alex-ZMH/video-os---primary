param(
    [Parameter(Mandatory = $true)][string]$LandscapeDir,
    [Parameter(Mandatory = $true)][string]$PortraitDir,
    [ValidateRange(1, 10)][int]$Runs = 1,
    [string]$LandscapeVideo,
    [string]$PortraitVideo,
    [ValidateRange(0.01, 2.0)][double]$DurationTolerance = 0.15
)

$ErrorActionPreference = 'Stop'

function Assert-Workflow([bool]$Condition, [string]$Message) {
    if (-not $Condition) { throw "Workflow verification failed: $Message" }
}

function Get-Attribute([string]$Tag, [string]$Name) {
    $escaped = [regex]::Escape($Name)
    $match = [regex]::Match($Tag, "(?:^|\s)$escaped=`"([^`"]+)`"")
    if (-not $match.Success) { return $null }
    return $match.Groups[1].Value
}

function Get-ProjectInfo([string]$Directory) {
    $root = (Resolve-Path -LiteralPath $Directory).Path
    $index = Join-Path $root 'index.html'
    Assert-Workflow (Test-Path -LiteralPath $index -PathType Leaf) "missing $index"
    $html = Get-Content -Raw -LiteralPath $index
    $documents = @($html) + @([regex]::Matches($html, 'data-composition-src="([^"]+)"') | ForEach-Object {
        $path = Join-Path $root ($_.Groups[1].Value -replace '/', [IO.Path]::DirectorySeparatorChar)
        Assert-Workflow (Test-Path -LiteralPath $path -PathType Leaf) "missing sub-composition $path"
        Get-Content -Raw -LiteralPath $path
    })
    $rootTag = [regex]::Match($html, '<[^>]*data-composition-id="[^"]+"[^>]*>').Value
    Assert-Workflow ([bool]$rootTag) "composition root not found in $index"

    $audio = @([regex]::Matches($html, '<audio\b[^>]*>') | ForEach-Object {
        $source = Get-Attribute $_.Value 'src'
        Assert-Workflow ([bool]$source) "audio source missing in $index"
        $path = Join-Path $root ($source -replace '/', [IO.Path]::DirectorySeparatorChar)
        Assert-Workflow (Test-Path -LiteralPath $path -PathType Leaf) "missing audio asset $path"
        [pscustomobject]@{
            Name = [IO.Path]::GetFileName($source)
            Hash = (Get-FileHash -Algorithm SHA256 -LiteralPath $path).Hash
        }
    })

    [pscustomobject]@{
        Root = $root
        Width = [int](Get-Attribute $rootTag 'data-width')
        Height = [int](Get-Attribute $rootTag 'data-height')
        Duration = [double](Get-Attribute $rootTag 'data-duration')
        Audio = $audio
        HasPlaybackRate = $html -match 'data-playback-rate\s*='
        SceneImages = @($documents | ForEach-Object { [regex]::Matches($_, '<img\b[^>]*>') } | ForEach-Object {
            Get-Attribute $_.Value 'src'
        } | Where-Object { $_ -like 'assets/*' } | ForEach-Object {
            $source = $_
            $path = Join-Path $root ($source -replace '/', [IO.Path]::DirectorySeparatorChar)
            Assert-Workflow (Test-Path -LiteralPath $path -PathType Leaf) "missing scene asset $path"
            $size = & ffprobe -v error -select_streams v:0 -show_entries 'stream=width,height' -of json $path | ConvertFrom-Json
            Assert-Workflow ($LASTEXITCODE -eq 0 -and @($size.streams).Count -eq 1) "cannot read scene dimensions for $path"
            [pscustomobject]@{
                Name = [IO.Path]::GetFileName($source)
                Hash = (Get-FileHash -Algorithm SHA256 -LiteralPath $path).Hash
                Width = [int]$size.streams[0].width
                Height = [int]$size.streams[0].height
            }
        })
    }
}

function Invoke-HyperFramesCheck([string]$Directory, [int]$Run) {
    Push-Location $Directory
    try {
        for ($attempt = 1; $attempt -le 3; $attempt++) {
            $strictPreference = $ErrorActionPreference
            $ErrorActionPreference = 'Continue'
            $lines = @(& npm run check -- --no-browser-gpu --json 2>&1)
            $exitCode = $LASTEXITCODE
            $ErrorActionPreference = $strictPreference
            $text = $lines -join "`n"
            if ($exitCode -eq 0) { break }
            if ($text -notmatch 'ERR_UNSAFE_PORT' -or $attempt -eq 3) {
                Assert-Workflow $false "HyperFrames check run $Run failed in $Directory"
            }
        }
        $jsonStart = [regex]::Match($text, '(?m)^\{').Index
        Assert-Workflow ($jsonStart -ge 0) "HyperFrames check run $Run returned no JSON in $Directory"
        $result = $text.Substring($jsonStart) | ConvertFrom-Json
        Assert-Workflow ([bool]$result.ok) "HyperFrames check run $Run returned ok=false in $Directory"
    } finally {
        Pop-Location
    }
}

function Test-Video([string]$Path, [int]$Width, [int]$Height, [double]$Duration) {
    Assert-Workflow (Test-Path -LiteralPath $Path -PathType Leaf) "missing video $Path"
    Assert-Workflow ((Get-Item -LiteralPath $Path).Length -gt 0) "empty video $Path"
    $probe = (& ffprobe -v error -show_entries 'format=duration:stream=codec_type,codec_name,width,height,r_frame_rate,sample_rate,channels' -of json $Path) | ConvertFrom-Json
    Assert-Workflow ($LASTEXITCODE -eq 0) "ffprobe failed for $Path"
    $video = @($probe.streams | Where-Object codec_type -eq 'video')[0]
    $audio = @($probe.streams | Where-Object codec_type -eq 'audio')[0]
    Assert-Workflow ($null -ne $video -and $video.codec_name -eq 'h264') "expected H.264 video in $Path"
    Assert-Workflow ($video.width -eq $Width -and $video.height -eq $Height) "unexpected dimensions in $Path"
    Assert-Workflow ($video.r_frame_rate -eq '30/1') "expected 30 fps in $Path"
    Assert-Workflow ($null -ne $audio -and $audio.codec_name -eq 'aac') "expected AAC audio in $Path"
    Assert-Workflow ([math]::Abs(([double]$probe.format.duration) - $Duration) -le $DurationTolerance) "duration mismatch in $Path"
}

$landscape = Get-ProjectInfo $LandscapeDir
$portrait = Get-ProjectInfo $PortraitDir

Assert-Workflow ($landscape.Width -eq 1920 -and $landscape.Height -eq 1080) 'landscape project must be 1920x1080'
Assert-Workflow ($portrait.Width -eq 1080 -and $portrait.Height -eq 1920) 'portrait project must be 1080x1920'
Assert-Workflow ([math]::Abs($landscape.Duration - $portrait.Duration) -le 0.01) 'composition durations differ'
Assert-Workflow (-not $landscape.HasPlaybackRate -and -not $portrait.HasPlaybackRate) 'authored playback-rate override detected'
Assert-Workflow ($landscape.Audio.Count -gt 0 -and $landscape.Audio.Count -eq $portrait.Audio.Count) 'voice-track counts differ'

for ($i = 0; $i -lt $landscape.Audio.Count; $i++) {
    Assert-Workflow ($landscape.Audio[$i].Name -eq $portrait.Audio[$i].Name) "voice filename differs at track $($i + 1)"
    Assert-Workflow ($landscape.Audio[$i].Hash -eq $portrait.Audio[$i].Hash) "voice content differs at track $($i + 1)"
}

Assert-Workflow ($landscape.SceneImages.Count -gt 0 -and $landscape.SceneImages.Count -eq $portrait.SceneImages.Count) 'scene-image counts differ or are empty'
Assert-Workflow (-not @($landscape.SceneImages | Where-Object { $_.Width -le $_.Height }).Count) 'landscape project references a non-landscape scene asset'
Assert-Workflow (-not @($portrait.SceneImages | Where-Object { $_.Width -ge $_.Height }).Count) 'portrait project references a non-portrait scene asset'
$landscapeImageHashes = @($landscape.SceneImages | ForEach-Object Hash)
Assert-Workflow (-not @($portrait.SceneImages | Where-Object { $_.Hash -in $landscapeImageHashes }).Count) 'portrait project reuses a landscape scene asset'

for ($run = 1; $run -le $Runs; $run++) {
    Invoke-HyperFramesCheck $landscape.Root $run
    Invoke-HyperFramesCheck $portrait.Root $run
}

if ($LandscapeVideo) { Test-Video $LandscapeVideo 1920 1080 $landscape.Duration }
if ($PortraitVideo) { Test-Video $PortraitVideo 1080 1920 $portrait.Duration }

[pscustomobject]@{
    ok = $true
    runs = $Runs
    duration = $landscape.Duration
    voiceTracks = $landscape.Audio.Count
    landscapeVideoChecked = [bool]$LandscapeVideo
    portraitVideoChecked = [bool]$PortraitVideo
} | ConvertTo-Json
