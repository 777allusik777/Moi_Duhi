@echo off
setlocal EnableExtensions

cd /d "%~dp0"

echo ==================================================
echo   Cleaning local npm dependencies
echo ==================================================
echo.

rem Stop active Node/NPM processes that may keep file handles locked.
call :stop_node_processes

call :remove_dir "%~dp0node_modules"
call :remove_dir "%~dp0frontend\node_modules"
call :remove_dir "%~dp0backend\node_modules"
call :remove_dir "%~dp0shared\node_modules"

call :remove_dir "%~dp0frontend\dist"
call :remove_dir "%~dp0backend\dist"
call :remove_dir "%~dp0shared\dist"
call :remove_dir "%~dp0frontend\node_modules\.vite"

call :remove_file "%~dp0package-lock.json"
call :remove_file "%~dp0frontend\package-lock.json"
call :remove_file "%~dp0backend\package-lock.json"
call :remove_file "%~dp0shared\package-lock.json"

if exist "%~dp0npm-cache" (
    echo Deleting npm cache folder
    rd /s /q "%~dp0npm-cache"
)

echo.
echo Dependencies and build cache removed.
echo Next start: run "npm install" or launch Start.bat.
echo.
exit /b 0

:stop_node_processes
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-CimInstance Win32_Process -Filter \"Name='node.exe' OR Name='npm.exe' OR Name='npm.cmd'\" -ErrorAction SilentlyContinue | ForEach-Object { try { $_.Terminate() | Out-Null } catch {} }"
for /L %%I in (1,1,10) do (
    powershell -NoProfile -ExecutionPolicy Bypass -Command "$p = Get-CimInstance Win32_Process -Filter \"Name='node.exe' OR Name='npm.exe' OR Name='npm.cmd'\" -ErrorAction SilentlyContinue; if (-not $p) { exit 0 } else { exit 1 }"
    if not errorlevel 1 goto :done_stop
    timeout /t 1 /nobreak >nul
)
:done_stop
exit /b 0

:remove_dir
if exist "%~1" (
    echo Deleting %~1
    rd /s /q "%~1"
    if exist "%~1" (
        echo Retrying delete with PowerShell: %~1
        powershell -NoProfile -ExecutionPolicy Bypass -Command "Remove-Item -LiteralPath '%~1' -Recurse -Force -ErrorAction Stop"
    )
)
exit /b 0

:remove_file
if exist "%~1" (
    echo Deleting %~1
    del /f /q "%~1"
    if exist "%~1" (
        powershell -NoProfile -ExecutionPolicy Bypass -Command "Remove-Item -LiteralPath '%~1' -Force -ErrorAction Stop"
    )
)
exit /b 0
