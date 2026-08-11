@echo off
setlocal

cd /d "%~dp0"

echo ==================================================
echo   Project launcher
echo ==================================================
echo.

if not exist "package.json" (
    echo [ERROR] package.json not found in this folder.
    echo Please run this file from the HUB project root.
    pause
    exit /b 1
)

if not exist "node_modules" (
    echo Dependencies are missing.
    echo Running install script...
    call "%~dp0install-npm.bat"
    if errorlevel 1 (
        echo [ERROR] Install failed.
        pause
        exit /b 1
    )
)

echo Starting backend...
start "Backend" cmd /k "cd /d "%~dp0" && npm run dev:backend"

timeout /t 5 >nul

echo Starting frontend...
start "Frontend" cmd /k "cd /d "%~dp0" && npm run dev:frontend"

echo.
echo ==================================================
echo Project started successfully.
echo Backend: http://localhost:3000
echo Swagger: http://localhost:3000/api/docs
echo Frontend: http://localhost:5173
echo ==================================================
echo.
endlocal
