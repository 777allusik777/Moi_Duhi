@echo off
setlocal

cd /d "%~dp0"

where node >nul 2>nul
if errorlevel 1 (
    echo [ERROR] Node.js is not installed or not available in PATH.
    echo Install Node.js LTS and try again.
    pause
    exit /b 1
)

where npm >nul 2>nul
if errorlevel 1 (
    echo [ERROR] npm is not installed or not available in PATH.
    echo Install Node.js LTS and try again.
    pause
    exit /b 1
)

echo ==================================================
echo   Installing project dependencies
echo ==================================================
echo.

npm install --no-fund --no-audit
if errorlevel 1 (
    echo.
    echo [ERROR] Dependency installation failed.
    pause
    exit /b 1
)

echo.
echo Dependencies installed successfully.
echo Next step: double-click Start.bat or run npm run dev:backend and npm run dev:frontend

echo.
endlocal
