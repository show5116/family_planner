# Family Planner 빌드 자동화
#
# iOS 업로드 전 필요한 환경변수 설정 (.env 파일 또는 export 명령어로):
#   APPLE_ID             - Apple 개발자 계정 이메일
#   APPLE_APP_PASSWORD   - 앱 전용 비밀번호 (appleid.apple.com → 보안 → 앱 전용 암호)

.PHONY: ios ios-build ios-upload android run-ios run-android run-web clean help

# ─── iOS ────────────────────────────────────────────────────────────────────

## 빌드 + TestFlight 업로드 (한 번에)
ios: ios-build ios-upload

## IPA 빌드만
ios-build:
	@echo ">>> iOS 빌드 시작..."
	flutter pub get
	flutter build ipa --release
	@echo ">>> 빌드 완료: build/ios/ipa/"

## TestFlight 업로드만 (이미 빌드된 IPA 사용)
ios-upload:
	@if [ -z "$(APPLE_ID)" ] || [ -z "$(APPLE_APP_PASSWORD)" ]; then \
		echo "오류: APPLE_ID, APPLE_APP_PASSWORD 환경변수를 설정하세요."; \
		echo "  export APPLE_ID=your@email.com"; \
		echo "  export APPLE_APP_PASSWORD=xxxx-xxxx-xxxx-xxxx"; \
		exit 1; \
	fi
	@IPA=$$(ls build/ios/ipa/*.ipa 2>/dev/null | head -1); \
	if [ -z "$$IPA" ]; then \
		echo "오류: IPA 파일이 없습니다. 먼저 'make ios-build'를 실행하세요."; \
		exit 1; \
	fi; \
	echo ">>> TestFlight 업로드 중: $$IPA"; \
	xcrun altool --upload-app -f "$$IPA" -t ios \
		-u "$(APPLE_ID)" -p "$(APPLE_APP_PASSWORD)"; \
	echo ">>> 업로드 완료!"

# ─── Android ────────────────────────────────────────────────────────────────

## Android AAB 빌드
android:
	@echo ">>> Android 빌드 시작..."
	flutter pub get
	flutter build appbundle --release
	@echo ">>> 빌드 완료: build/app/outputs/bundle/release/"

# ─── 개발 실행 ───────────────────────────────────────────────────────────────

## 웹 개발 서버 실행
run-web:
	flutter run -d chrome --web-port=3001 --dart-define=ENVIRONMENT=development

## iOS 시뮬레이터 실행
run-ios:
	flutter run --dart-define=ENVIRONMENT=development

## Android 에뮬레이터 실행
run-android:
	flutter run --dart-define=ENVIRONMENT=development

# ─── 기타 ───────────────────────────────────────────────────────────────────

## Flutter clean + pub get
clean:
	flutter clean
	flutter pub get

## 도움말
help:
	@echo ""
	@echo "사용 가능한 명령어:"
	@echo "  make ios              빌드 + TestFlight 업로드"
	@echo "  make ios-build        IPA 빌드만"
	@echo "  make ios-upload       업로드만 (빌드된 IPA 재사용)"
	@echo "  make android          Android AAB 빌드"
	@echo "  make run-web          웹 개발 서버"
	@echo "  make run-ios          iOS 실행"
	@echo "  make run-android      Android 실행"
	@echo "  make clean            flutter clean + pub get"
	@echo ""
	@echo "TestFlight 업로드 전 환경변수 필요:"
	@echo "  export APPLE_ID=your@email.com"
	@echo "  export APPLE_APP_PASSWORD=xxxx-xxxx-xxxx-xxxx"
	@echo ""
