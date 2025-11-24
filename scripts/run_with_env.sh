#!/bin/bash
# macOS/Linux용 환경변수 로드 및 실행 스크립트

# .env 파일 존재 확인
if [ ! -f ".env" ]; then
    echo "Error: .env 파일이 없습니다."
    echo ".env.example을 복사하여 .env를 생성하고 실제 값을 입력하세요."
    exit 1
fi

# .env 파일에서 환경변수 읽기
export $(grep -v '^#' .env | xargs)

# Flutter 실행 (웹)
flutter run -d chrome --web-port=3001 \
  --dart-define=GOOGLE_WEB_CLIENT_ID=$GOOGLE_WEB_CLIENT_ID \
  --dart-define=KAKAO_JS_APP_KEY=$KAKAO_JS_APP_KEY \
  --dart-define=EMAILJS_SERVICE_ID=$EMAILJS_SERVICE_ID \
  --dart-define=EMAILJS_PUBLIC_KEY=$EMAILJS_PUBLIC_KEY
