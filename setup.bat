@echo off
REM 🏥 GRACE CLINIC - WINDOWS STARTUP HELPER
REM Quick setup and launch for Windows

cls
echo.
echo ========================================
echo    GRACE CLINIC - STARTUP HELPER
echo ========================================
echo.

REM Check Node.js
echo Checking prerequisites...
where node >nul 2>nul
if %errorlevel% neq 0 (
    echo [X] Node.js not found
    echo    Please install from https://nodejs.org
    pause
    exit /b 1
)

for /f "tokens=*" %%i in ('node --version') do set NODE_VERSION=%%i
echo [OK] Node.js installed: %NODE_VERSION%

REM Check npm
where npm >nul 2>nul
if %errorlevel% neq 0 (
    echo [X] npm not found
    pause
    exit /b 1
)

for /f "tokens=*" %%i in ('npm --version') do set NPM_VERSION=%%i
echo [OK] npm installed: %NPM_VERSION%

REM Check MySQL
where mysql >nul 2>nul
if %errorlevel% neq 0 (
    echo [!] MySQL not found (optional - can use cloud MySQL)
) else (
    echo [OK] MySQL found
)

echo.
echo Setting up backend...
echo.

REM Check if server directory exists
if not exist server (
    echo [X] server/ directory not found!
    pause
    exit /b 1
)

REM Navigate to server directory
cd server

REM Check if package.json exists
if not exist package.json (
    echo [X] package.json not found in server/
    pause
    exit /b 1
)

REM Install dependencies
echo Installing Node.js dependencies...
call npm install

if %errorlevel% neq 0 (
    echo [X] Failed to install dependencies
    pause
    exit /b 1
)

echo [OK] Dependencies installed successfully

REM Check .env file
if not exist .env (
    echo [!] .env file not found
    if exist .env.example (
        echo Creating .env from .env.example...
        copy .env.example .env
        echo [OK] .env file created
        echo [IMPORTANT] Edit server\.env with your MySQL credentials!
    )
) else (
    echo [OK] .env file found
)

cls
echo.
echo ========================================
echo    Setup Complete!
echo ========================================
echo.
echo NEXT STEPS:
echo.
echo 1. Configure Database:
echo    - Edit server\.env with MySQL credentials
echo    - Run: mysql -u root -p ^< database\schema.sql
echo.
echo 2. Start Backend Server:
echo    - Open new terminal
echo    - cd server
echo    - npm start
echo    - Keep this terminal open
echo.
echo 3. Open Frontend:
echo    - Open client\index.html in browser
echo    - Or use VS Code Live Server extension
echo.
echo 4. Test Appointment Booking
echo.
echo 5. View Admin Dashboard:
echo    - Open admin\dashboard.html
echo.
echo Documentation:
echo    - QUICK_START.md - Fast setup guide
echo    - README.md - Complete documentation
echo    - API_DOCS.md - API reference
echo    - DEPLOYMENT.md - Customization guide
echo.
echo Deploy to Cloud:
echo    - See DEPLOYMENT.md for hosting options
echo.
echo ========================================
echo    Happy coding! 🎉
echo ========================================
echo.

pause
