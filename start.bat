@echo off
setlocal
cd /d "%~dp0"

set "PORT=5555"
set "URL=http://127.0.0.1:%PORT%"
set "NODE=%~dp0runtime\node.exe"

rem ---- Already running? Just open the browser. -------------------------------
curl.exe -s -o NUL --max-time 2 "%URL%/api/data"
if not errorlevel 1 goto open

rem ---- Pick a Node runtime: bundled portable copy first, system Node second. --
if exist "%NODE%" goto node_ok
where node >nul 2>&1
if errorlevel 1 goto no_node
set "NODE=node"
:node_ok

rem ---- Dependencies ----------------------------------------------------------
if exist "%~dp0node_modules" goto deps_ok
if not "%NODE%"=="node" goto no_deps
echo Installing dependencies (first run only)...
call npm install --omit=dev
if errorlevel 1 goto npm_failed
:deps_ok

rem ---- Start the server hidden and detached. ---------------------------------
powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command "Start-Process -FilePath '%NODE%' -ArgumentList 'server.js' -WorkingDirectory '%~dp0' -WindowStyle Hidden"
if errorlevel 1 goto start_failed

rem ---- Wait for it to answer (up to ~15s), then open the browser. -------------
set /a tries=0
:wait
curl.exe -s -o NUL --max-time 1 "%URL%/api/data"
if not errorlevel 1 goto open
set /a tries+=1
if %tries% geq 15 goto no_response
timeout /t 1 /nobreak >nul 2>&1
goto wait

:open
start "" "%URL%"
exit /b 0

:no_node
echo.
echo  [ERROR] No Node runtime found.
echo.
echo  Either use the portable release (which bundles runtime\node.exe),
echo  or install Node.js from https://nodejs.org
echo.
pause
exit /b 1

:no_deps
echo.
echo  [ERROR] node_modules is missing from this portable copy.
echo  Re-extract the release zip - it should ship with dependencies included.
echo.
pause
exit /b 1

:npm_failed
echo.
echo  [ERROR] npm install failed. See the messages above.
echo.
pause
exit /b 1

:start_failed
echo.
echo  [ERROR] Could not start the server process.
echo.
pause
exit /b 1

:no_response
echo.
echo  [ERROR] The server did not respond on %URL% within 15 seconds.
echo.
echo  Run it in the foreground to see why:
echo      "%NODE%" server.js
echo.
pause
exit /b 1
