@echo off
setlocal
set "PAGE=%~dp0index.html"
if not exist "%PAGE%" (
  echo Workflow page not found: %PAGE%
  pause
  exit /b 1
)
start "" "%PAGE%"
endlocal
