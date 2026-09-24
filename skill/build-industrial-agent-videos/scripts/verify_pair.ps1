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
    $html = Get-Content -Raw -Encoding UTF8 -LiteralPath $index
    $documents = @($html) + @([regex]::Matches($html, 'data-composition-src="([^"]+)"') | ForEach-Object {
        $path = Join-Path $root ($_.Groups[1].Value -replace '/', [IO.Path]::DirectorySeparatorChar)
        Assert-Workflow (Test-Path -LiteralPath $path -PathType Leaf) "missing sub-composition $path"
        Get-Content -Raw -Encoding UTF8 -LiteralPath $path
    })
    $rootTag = [regex]::Match($html, '<[^>]*data-composition-id="[^"]+"[^>]*>').Value
    Assert-Workflow ([bool]$rootTag) "composition root not found in $index"
    $allDocuments = $documents -join "`n"

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

    $manifestPath = Join-Path $root 'source-manifest.json'
    Assert-Workflow (Test-Path -LiteralPath $manifestPath -PathType Leaf) "missing playlist manifest $manifestPath"
    $manifest = Get-Content -Raw -Encoding UTF8 -LiteralPath $manifestPath | ConvertFrom-Json
    $playlist = @($manifest.videoPlaylist)
    $provenance = @($manifest.provenance)
    Assert-Workflow ($playlist.Count -gt 0 -and $provenance.Count -gt 0) "empty video playlist or provenance in $manifestPath"
    $videos = @([regex]::Matches($allDocuments, '<video\b[^>]*>') | ForEach-Object {
        $tag = $_.Value
        $source = Get-Attribute $tag 'src'
        Assert-Workflow ([bool]$source) "video source missing in $index"
        $path = Join-Path $root ($source -replace '/', [IO.Path]::DirectorySeparatorChar)
        Assert-Workflow (Test-Path -LiteralPath $path -PathType Leaf) "missing video asset $path"
        [pscustomobject]@{
            Tag = $tag
            Source = $source
            Path = $path
            Start = [double](Get-Attribute $tag 'data-start')
            Duration = [double](Get-Attribute $tag 'data-duration')
            Cycle = [int](Get-Attribute $tag 'data-cycle-index')
            SourceIndex = [int](Get-Attribute $tag 'data-source-index')
        }
    })
    Assert-Workflow ($videos.Count -eq $playlist.Count) "video tag count does not match videoPlaylist in $manifestPath"
    $cursor = 0.0
    for ($i = 0; $i -lt $playlist.Count; $i++) {
        $segment = $playlist[$i]
        $video = $videos[$i]
        $source = $provenance[[int]$segment.sourceIndex]
        Assert-Workflow ($null -ne $source) "playlist source index $($segment.sourceIndex) is missing in $manifestPath"
        Assert-Workflow ($video.Source -eq $source.path) "playlist source mismatch at segment $($i + 1)"
        Assert-Workflow ($video.Cycle -eq [int]$segment.cycle -and $video.SourceIndex -eq [int]$segment.sourceIndex) "playlist metadata mismatch at segment $($i + 1)"
        Assert-Workflow ([math]::Abs($video.Start - [double]$segment.start) -le 0.01 -and [math]::Abs($video.Duration - [double]$segment.duration) -le 0.01) "playlist timing mismatch at segment $($i + 1)"
        Assert-Workflow ([math]::Abs($video.Start - $cursor) -le 0.01) "video playlist has a gap or overlap at segment $($i + 1)"
        Assert-Workflow ($video.Duration -gt 0 -and $video.Duration -le ([double]$source.sourceDuration_s + 0.01)) "video segment exceeds its source duration at segment $($i + 1)"
        Assert-Workflow ((Get-Attribute $video.Tag 'data-media-start') -eq '0') "video media offset is not zero at segment $($i + 1)"
        Assert-Workflow ($video.Tag -notmatch '\sloop(?:\s|>|=)' -and $video.Tag -notmatch 'data-playback-rate\s*=') "video loop/rate override found at segment $($i + 1)"
        $cursor = $video.Start + $video.Duration
    }
    $images = @([regex]::Matches($allDocuments, '<img\b[^>]*>') | ForEach-Object {
        $source = Get-Attribute $_.Value 'src'
        if ($source) { $source }
    })
    Assert-Workflow (@($images | Where-Object { [IO.Path]::GetFileName($_) -ne 'company-logo.jpg' }).Count -eq 0) "static scene image found in $index"

    [pscustomobject]@{
        Root = $root
        Width = [int](Get-Attribute $rootTag 'data-width')
        Height = [int](Get-Attribute $rootTag 'data-height')
        Duration = [double](Get-Attribute $rootTag 'data-duration')
        Audio = $audio
        HasPlaybackRate = $allDocuments -match 'data-playback-rate\s*='
        Videos = $videos
        Playlist = $playlist
        Provenance = $provenance
        Images = $images
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
            if ($text -match 'CommandNotFoundException|The term .+ is not recognized') {
                Assert-Workflow $false "HyperFrames check command is unavailable in $Directory"
            }
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

Assert-Workflow ($landscape.Playlist.Count -gt 0 -and $landscape.Playlist.Count -eq $landscape.Videos.Count) 'landscape video playlist is empty or incomplete'
Assert-Workflow ($portrait.Playlist.Count -gt 0 -and $portrait.Playlist.Count -eq $portrait.Videos.Count) 'portrait video playlist is empty or incomplete'

foreach ($project in @($landscape, $portrait)) {
    $isLandscape = $project.Width -gt $project.Height
    foreach ($source in $project.Provenance) {
        $native = [int]$source.stream.width -gt [int]$source.stream.height
        Assert-Workflow ($native -eq $isLandscape) "playlist source aspect does not match project layout in $($project.Root)"
    }
    $firstCycle = @($project.Playlist | Where-Object { [int]$_.cycle -eq 0 })
    Assert-Workflow ($firstCycle.Count -eq $project.Provenance.Count) "first video cycle is incomplete in $($project.Root)"
    for ($i = 0; $i -lt $firstCycle.Count; $i++) {
        Assert-Workflow ([int]$firstCycle[$i].sourceIndex -eq $i -and [bool]$firstCycle[$i].fullSource) "first video cycle order is invalid in $($project.Root)"
    }
    $hasSecondCycle = @($project.Playlist | Where-Object { [int]$_.cycle -ge 1 }).Count -gt 0
    $firstCycleDuration = ($project.Provenance | Measure-Object -Property sourceDuration_s -Sum).Sum
    Assert-Workflow ($hasSecondCycle -or [math]::Abs(($project.Videos[-1].Start + $project.Videos[-1].Duration) - $firstCycleDuration) -le 0.02) "playlist does not finish the first cycle or restart it in $($project.Root)"
}

Assert-Workflow (-not @($landscape.Playlist | Where-Object { [int]$_.sourceIndex -lt 0 -or [int]$_.sourceIndex -ge $landscape.Provenance.Count }).Count) 'landscape playlist references an invalid source'
Assert-Workflow (-not @($portrait.Playlist | Where-Object { [int]$_.sourceIndex -lt 0 -or [int]$_.sourceIndex -ge $portrait.Provenance.Count }).Count) 'portrait playlist references an invalid source'

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
