@echo off
title Kanban Board
cd /d "%~dp0"

where node >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Node.js is not installed or not in PATH.
    echo Download it from https://nodejs.org
    pause
    exit /b 1
)

if not exist "node_modules" (
    echo Installing dependencies...
    call npm install
    if %errorlevel% neq 0 (
        echo [ERROR] npm install failed.
        pause
        exit /b 1
    )
)

echo.
echo  Kanban Board is starting...
echo  Open http://localhost:5555 in your browser
echo.
echo  Press Ctrl+C to stop the server.
echo.

start "" "http://localhost:5555"
node server.js
pause
