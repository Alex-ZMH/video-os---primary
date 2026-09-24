param([int]$Port = 3117)
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $root
node .\server.mjs --port=$Port
