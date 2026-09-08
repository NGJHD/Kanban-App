@echo off
setlocal
cd /d "%~dp0"

set "PORT=5555"
set "PID="

rem ---- The process listening on the board's port is the board. ----------------
for /f "tokens=5" %%p in ('netstat -ano -p TCP ^| findstr /r /c:"127.0.0.1:%PORT% .*LISTENING"') do set "PID=%%p"
if not defined PID goto not_running

rem ---- Never kill anything that is not Node. ----------------------------------
tasklist /FI "PID eq %PID%" /FI "IMAGENAME eq node.exe" /NH 2>nul | findstr /i "node.exe" >nul
if errorlevel 1 goto not_ours

taskkill /PID %PID% /F >nul 2>&1
if errorlevel 1 goto kill_failed
echo  Kanban Board stopped (PID %PID%).
timeout /t 2 /nobreak >nul 2>&1
exit /b 0

:not_running
echo  Kanban Board is not running.
timeout /t 2 /nobreak >nul 2>&1
exit /b 0

:not_ours
echo.
echo  [WARN] Something is listening on port %PORT% (PID %PID%), but it is not
echo         Node - so it is not the Kanban Board. Leaving it alone.
echo.
pause
exit /b 1

:kill_failed
echo.
echo  [ERROR] Could not stop PID %PID%. Try again from an elevated prompt.
echo.
pause
exit /b 1
