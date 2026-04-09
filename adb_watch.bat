@echo off
echo Watching for Android device connection...
echo Press Ctrl+C to stop.

set ADB="%LOCALAPPDATA%\Android\Sdk\platform-tools\adb.exe"
set LAST_STATE=disconnected

:loop
%ADB% devices 2>nul | findstr /r "device$" >nul
if %errorlevel% == 0 (
    if "%LAST_STATE%"=="disconnected" (
        echo Device connected! Setting adb reverse tcp:3000...
        %ADB% reverse tcp:3000 tcp:3000
        echo Done.
        set LAST_STATE=connected
    )
) else (
    if "%LAST_STATE%"=="connected" (
        echo Device disconnected.
        set LAST_STATE=disconnected
    )
)
timeout /t 2 /nobreak >nul
goto loop
