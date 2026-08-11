@echo off
setlocal

cd /d "%~dp0"

echo ==================================================
echo   Local project start
echo ==================================================
echo.

if not exist "package.json" (
    echo [ERROR] package.json not found.
    echo Run the script from the project root folder.
    pause
    exit /b 1
)

if not exist "node_modules" (
    echo [ERROR] Dependencies are not installed.
    echo Run: npm install
    echo.
    pause
    exit /b 1
)

echo Stopping processes on ports 3000 and 5173...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\free-dev-ports.ps1"
if errorlevel 1 (
    echo.
    echo [ERROR] Failed to free ports 3000 and 5173.
    echo Close the running backend/frontend windows and try again.
    echo.
    pause
    exit /b 1
)

echo Cleaning Vite cache...
if exist "frontend\node_modules\.vite" (
    rmdir /s /q "frontend\node_modules\.vite" >nul 2>&1
)

echo [1/2] Starting backend...
start "Backend" cmd /k "cd /d %~dp0 && npm run dev:backend"

timeout /t 5 >nul

echo [2/2] Starting frontend...
start "Frontend" cmd /k "cd /d %~dp0 && npm run dev:frontend"

echo.
echo ==================================================
echo Project started successfully.
echo.
echo   Backend: http://localhost:3000
echo   Swagger: http://localhost:3000/api/docs
echo   Frontend: http://localhost:5173
echo.
echo Data is stored locally in the project folder: data\db.json and data\images\
echo Set DATA_DIR to change the storage directory before launch.
echo ==================================================
echo.
pause
endlocal