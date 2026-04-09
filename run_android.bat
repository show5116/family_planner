@echo off
echo [1/2] Setting up adb reverse...
"%LOCALAPPDATA%\Android\Sdk\platform-tools\adb.exe" reverse tcp:3000 tcp:3000
if %errorlevel% neq 0 (
    echo Failed to set adb reverse. Make sure device is connected via USB.
    pause
    exit /b 1
)
echo [2/2] Running Flutter...
flutter run
