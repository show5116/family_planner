@echo off
REM Windows용 환경변수 로드 및 실행 스크립트

REM .env 파일에서 환경변수 읽기
for /f "tokens=1,2 delims==" %%a in (.env) do (
    REM 주석 라인 제외
    echo %%a | findstr /b /c:"#" >nul
    if errorlevel 1 (
        set %%a=%%b
    )
)

REM Flutter 실행 (웹)
flutter run -d chrome --web-port=3001 ^
  --dart-define=GOOGLE_WEB_CLIENT_ID=%GOOGLE_WEB_CLIENT_ID% ^
  --dart-define=KAKAO_JS_APP_KEY=%KAKAO_JS_APP_KEY% ^
  --dart-define=EMAILJS_SERVICE_ID=%EMAILJS_SERVICE_ID% ^
  --dart-define=EMAILJS_PUBLIC_KEY=%EMAILJS_PUBLIC_KEY%
