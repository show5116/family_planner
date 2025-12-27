# GitHub Secrets 설정 가이드

GitHub Actions에서 `.env` 파일을 안전하게 관리하기 위한 설정 가이드입니다.

## 📋 목차

1. [ENV_FILE Secret 추가](#env_file-secret-추가)
2. [Secret 값 준비](#secret-값-준비)
3. [검증](#검증)
4. [문제 해결](#문제-해결)

## ENV_FILE Secret 추가

### 1. GitHub Repository로 이동

```
https://github.com/YOUR_USERNAME/family_planner
```

### 2. Settings > Secrets and variables > Actions

1. Repository 페이지에서 **Settings** 탭 클릭
2. 왼쪽 사이드바에서 **Secrets and variables** > **Actions** 클릭
3. **New repository secret** 버튼 클릭

### 3. Secret 추가

- **Name**: `ENV_FILE`
- **Value**: 아래의 전체 .env 파일 내용 복사

## Secret 값 준비

현재 프로젝트의 `.env` 파일 전체 내용을 복사하세요:

```bash
# Windows (PowerShell)
Get-Content .env | Set-Clipboard

# Windows (Command Prompt)
type .env | clip

# macOS/Linux
cat .env | pbcopy  # macOS
cat .env | xclip -selection clipboard  # Linux
```

또는 `.env` 파일을 직접 열어서 내용 전체를 복사합니다.

### .env 파일 예시 구조

```env
# ========================================
# Environment Configuration
# ========================================
ENVIRONMENT=development

# ========================================
# API Configuration
# ========================================
API_BASE_URL_DEV=http://localhost:3000
API_BASE_URL_PROD=https://your-api.com

# ========================================
# OAuth - Google
# ========================================
GOOGLE_WEB_CLIENT_ID=your-google-client-id
GOOGLE_ANDROID_CLIENT_ID=
GOOGLE_IOS_CLIENT_ID=

# ========================================
# OAuth - Kakao
# ========================================
KAKAO_NATIVE_APP_KEY=
KAKAO_JAVASCRIPT_APP_KEY=your-kakao-key

# ========================================
# Firebase - Web
# ========================================
FIREBASE_WEB_API_KEY=your-firebase-web-api-key
FIREBASE_WEB_APP_ID=your-firebase-web-app-id
FIREBASE_WEB_MESSAGING_SENDER_ID=your-sender-id
FIREBASE_WEB_PROJECT_ID=your-project-id
FIREBASE_WEB_AUTH_DOMAIN=your-auth-domain
FIREBASE_WEB_STORAGE_BUCKET=your-storage-bucket
FIREBASE_WEB_VAPID_KEY=your-vapid-key

# ========================================
# Firebase - Android
# ========================================
FIREBASE_ANDROID_API_KEY=your-firebase-android-api-key
FIREBASE_ANDROID_APP_ID=your-android-app-id
FIREBASE_ANDROID_MESSAGING_SENDER_ID=your-sender-id
FIREBASE_ANDROID_PROJECT_ID=your-project-id
FIREBASE_ANDROID_STORAGE_BUCKET=your-storage-bucket

# ========================================
# Firebase - iOS
# ========================================
FIREBASE_IOS_API_KEY=your-firebase-ios-api-key
FIREBASE_IOS_APP_ID=your-ios-app-id
FIREBASE_IOS_MESSAGING_SENDER_ID=your-sender-id
FIREBASE_IOS_PROJECT_ID=your-project-id
FIREBASE_IOS_STORAGE_BUCKET=your-storage-bucket
FIREBASE_IOS_BUNDLE_ID=com.example.familyPlanner
```

## 워크플로우 동작 방식

GitHub Actions가 실행될 때 다음과 같이 동작합니다:

```yaml
- name: Create .env file
  run: |
    echo "${{ secrets.ENV_FILE }}" > .env
    echo "✅ .env file created"
```

1. `secrets.ENV_FILE`에서 환경 변수 내용을 가져옴
2. `.env` 파일을 생성하고 내용을 작성
3. 이후 단계에서 Flutter가 `.env` 파일을 읽어 사용

## 검증

### 1. GitHub Actions 워크플로우 확인

1. Repository 페이지에서 **Actions** 탭 클릭
2. 최근 워크플로우 실행 결과 확인
3. "Create .env file" 단계가 성공적으로 완료되었는지 확인

### 2. 로그 확인

워크플로우 실행 로그에서 다음 메시지를 확인:

```
✅ .env file created
```

### 3. 빌드 성공 확인

- "Install dependencies" 단계가 성공
- "Build web" 단계가 성공
- Firebase 관련 에러가 없어야 함

## 문제 해결

### 문제 1: ENV_FILE이 비어있음

**증상**: 워크플로우는 성공하지만 Firebase 초기화 실패

**해결**:
1. GitHub Secrets에서 ENV_FILE 값 확인
2. 모든 필수 환경 변수가 포함되어 있는지 확인
3. 복사/붙여넣기 시 앞뒤 공백이나 특수문자 확인

### 문제 2: 줄바꿈 문제

**증상**: .env 파일이 한 줄로 생성됨

**해결**:
GitHub Secret에 값을 붙여넣을 때 원본 .env 파일의 줄바꿈이 유지되는지 확인하세요.

### 문제 3: 특수문자 이스케이프

**증상**: 특정 값이 잘못 해석됨

**해결**:
`.env` 파일에서 특수문자(`, $, \, " 등)가 포함된 값은 확인이 필요할 수 있습니다. 현재 설정에서는 문제가 없어야 하지만, 만약 문제가 발생하면 값을 따옴표로 감싸세요.

```env
# 특수문자가 포함된 경우
SOME_KEY="value with special $characters"
```

## 보안 주의사항

### ⚠️ 절대 하지 말아야 할 것

1. ❌ `.env` 파일을 GitHub에 커밋하지 마세요
2. ❌ Secret 값을 코드나 이슈, PR 코멘트에 붙여넣지 마세요
3. ❌ Public 로그에 환경 변수 값이 노출되지 않도록 주의하세요

### ✅ 권장 사항

1. ✅ `.env`는 `.gitignore`에 포함되어 있음을 확인
2. ✅ GitHub Secrets는 repository admin만 접근 가능
3. ✅ 주기적으로 API 키를 갱신
4. ✅ 개발/프로덕션 환경별로 다른 키 사용

## 환경별 설정

### Development (개발 환경)

로컬 개발 시에는 `.env` 파일을 직접 사용:

```bash
# .env 파일이 있는지 확인
ls -la .env

# 없으면 .env.example을 복사
cp .env.example .env

# 실제 값으로 수정
nano .env  # 또는 VSCode 등의 에디터 사용
```

### Production (프로덕션 환경)

GitHub Actions를 통한 배포 시에는 GitHub Secrets 사용:

1. Repository Secrets에 `ENV_FILE` 설정
2. 워크플로우가 자동으로 `.env` 파일 생성
3. 빌드 및 배포 진행

## 추가 Secrets

필요에 따라 다른 Secrets도 추가할 수 있습니다:

- `NETLIFY_AUTH_TOKEN`: Netlify 인증 토큰
- `NETLIFY_SITE_ID`: Netlify 사이트 ID

이미 설정된 Secrets:
- ✅ `GITHUB_TOKEN`: 자동 제공됨
- ✅ `NETLIFY_AUTH_TOKEN`: 설정 필요
- ✅ `NETLIFY_SITE_ID`: 설정 필요
- ✅ `ENV_FILE`: 새로 추가됨

## 참고 자료

- [GitHub Secrets 공식 문서](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
- [Flutter 환경 변수 관리](https://pub.dev/packages/flutter_dotenv)
- [Firebase 보안 가이드](https://firebase.google.com/docs/projects/api-keys)
