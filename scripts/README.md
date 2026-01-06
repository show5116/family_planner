# Scripts

이 디렉토리는 프로젝트 빌드 및 개발을 위한 유틸리티 스크립트를 포함합니다.

## 📜 스크립트 목록

### `generate_firebase_sw.dart`

`.env` 파일의 Firebase Web 설정을 읽어 `web/firebase-messaging-sw.js` 파일을 자동 생성합니다.

#### 사용 방법

```bash
# 스크립트 실행
dart scripts/generate_firebase_sw.dart
```

#### 동작 방식

1. 프로젝트 루트의 `.env` 파일을 읽습니다
2. Firebase Web 관련 환경 변수를 추출합니다:
   - `FIREBASE_WEB_API_KEY`
   - `FIREBASE_WEB_AUTH_DOMAIN`
   - `FIREBASE_WEB_PROJECT_ID`
   - `FIREBASE_WEB_STORAGE_BUCKET`
   - `FIREBASE_WEB_MESSAGING_SENDER_ID`
   - `FIREBASE_WEB_APP_ID`
3. 추출한 값으로 `web/firebase-messaging-sw.js` 파일을 생성합니다

#### 사용 시나리오

- **개발 시작 시**: `.env` 파일 설정 후 한 번 실행
- **환경 변수 변경 시**: Firebase 설정이 변경되면 다시 실행
- **CI/CD 파이프라인**: 빌드 전에 자동으로 실행 가능

#### 주의사항

⚠️ **생성된 `web/firebase-messaging-sw.js` 파일은 Git에 커밋하지 마세요!**
- 이 파일은 `.gitignore`에 추가되어 있습니다
- 민감한 Firebase API 키가 포함되어 있습니다
- 각 개발자와 CI/CD 환경에서 개별적으로 생성해야 합니다

#### 에러 해결

**`.env 파일을 찾을 수 없습니다`**
- 프로젝트 루트에 `.env` 파일이 있는지 확인하세요
- `.env.example`을 복사하여 `.env`를 생성하세요

**`필수 Firebase Web 설정이 없습니다`**
- `.env` 파일에 모든 Firebase Web 환경 변수가 설정되어 있는지 확인하세요
- Firebase Console에서 웹 앱 설정을 확인하세요

## 🔧 CI/CD 통합

### GitHub Actions 예시

```yaml
- name: Generate Firebase Service Worker
  run: dart scripts/generate_firebase_sw.dart

- name: Build Web
  run: flutter build web
```

### 로컬 빌드 스크립트

`package.json` 또는 `Makefile`에 추가:

```makefile
.PHONY: build-web
build-web:
	@echo "Generating Firebase Service Worker..."
	@dart scripts/generate_firebase_sw.dart
	@echo "Building Flutter Web..."
	@flutter build web
```

## 📝 새 스크립트 추가 시

1. 스크립트 파일을 `scripts/` 디렉토리에 추가
2. 파일 상단에 `#!/usr/bin/env dart` shebang 추가
3. 이 README에 사용법 문서 추가
4. 필요시 실행 권한 부여: `chmod +x scripts/your_script.dart`
