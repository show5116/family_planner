# OAuth 콜백 구현 가이드

백엔드의 OAuth 페이지를 브라우저로 열고, Universal Links/App Links를 통해 토큰을 받는 방식으로 구현되었습니다.

## 📋 구현 내용

### 1. 패키지 추가
- `url_launcher`: OAuth URL을 브라우저로 열기
- `app_links`: Deep Link (Universal Links/App Links) 처리
- `flutter_secure_storage`: 토큰 안전하게 저장

### 2. 구현된 기능

#### 🔐 보안 스토리지 서비스 (`secure_storage_service.dart`)
- `flutter_secure_storage`를 사용하여 토큰을 암호화하여 저장
- Access Token, Refresh Token 관리

#### 🔗 OAuth 콜백 핸들러 (`oauth_callback_handler.dart`)
- Universal Links (iOS) / App Links (Android) 수신
- 웹에서는 라우터가 직접 처리
- 토큰 추출 및 저장
- 스트림을 통해 AuthProvider에 알림

#### 🚀 OAuth URL 로그인 (`auth_service.dart`)
- `loginWithGoogleOAuth()`: 구글 OAuth 페이지를 브라우저로 열기
- `loginWithKakaoOAuth()`: 카카오 OAuth 페이지를 브라우저로 열기
- 웹: 같은 창에서 열기 (`LaunchMode.platformDefault`)
- 모바일: 외부 브라우저로 열기 (`LaunchMode.externalApplication`)

#### 📱 Deep Link 초기화 (`main.dart`)
- 앱 시작 시 `OAuthCallbackHandler().initDeepLinkListener()` 호출
- 모바일에서만 실행 (웹은 라우터가 처리)

#### 🌐 웹 OAuth 콜백 라우트 (`app_router.dart`)
- `/auth/callback?accessToken=xxx&refreshToken=xxx` 라우트 추가
- `OAuthCallbackScreen`으로 처리

## 🔧 OAuth 플로우

### 웹 (Web)

```
1. 사용자가 "Google로 계속하기" 클릭
2. loginWithGoogleOAuth() 실행
3. http://localhost:3000/auth/google 페이지가 같은 창에서 열림
4. 사용자가 Google 계정으로 로그인
5. 백엔드가 http://localhost:3001/auth/callback?accessToken=xxx&refreshToken=xxx로 리다이렉트
6. GoRouter의 /auth/callback 라우트가 처리
7. OAuthCallbackScreen에서 토큰 저장
8. AuthProvider가 스트림을 통해 인증 상태 업데이트
9. 자동으로 홈 화면으로 이동
```

### 모바일 (iOS & Android)

```
1. 사용자가 "Google로 계속하기" 클릭
2. loginWithGoogleOAuth() 실행
3. http://localhost:3000/auth/google 페이지가 외부 브라우저로 열림
4. 사용자가 Google 계정으로 로그인
5. 백엔드가 https://yourdomain.com/auth/callback?accessToken=xxx&refreshToken=xxx로 리다이렉트
6. Universal Links (iOS) 또는 App Links (Android)가 앱을 다시 열음
7. OAuthCallbackHandler의 Deep Link 리스너가 URI 수신
8. 토큰 추출 및 저장
9. AuthProvider가 스트림을 통해 인증 상태 업데이트
10. 자동으로 홈 화면으로 이동
```

## 📱 플랫폼별 설정

### iOS (Universal Links)

#### 1. `ios/Runner/Runner.entitlements` 파일
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.developer.associated-domains</key>
    <array>
        <string>applinks:yourdomain.com</string>
    </array>
</dict>
</plist>
```

#### 2. Xcode 설정
1. Xcode에서 프로젝트 열기: `ios/Runner.xcworkspace`
2. Runner 타겟 선택 → Signing & Capabilities
3. `+ Capability` 클릭 → `Associated Domains` 추가
4. `applinks:yourdomain.com` 입력

#### 3. 웹사이트에 `apple-app-site-association` 파일 배포
`https://yourdomain.com/.well-known/apple-app-site-association`:
```json
{
  "applinks": {
    "apps": [],
    "details": [
      {
        "appID": "TEAM_ID.com.example.family_planner",
        "paths": ["/auth/callback"]
      }
    ]
  }
}
```

### Android (App Links)

#### 1. `android/app/src/main/AndroidManifest.xml` 수정 완료
```xml
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data
        android:scheme="https"
        android:host="yourdomain.com"
        android:pathPrefix="/auth/callback" />
</intent-filter>
```

#### 2. 웹사이트에 `assetlinks.json` 파일 배포
`https://yourdomain.com/.well-known/assetlinks.json`:
```json
[
  {
    "relation": ["delegate_permission/common.handle_all_urls"],
    "target": {
      "namespace": "android_app",
      "package_name": "com.example.family_planner",
      "sha256_cert_fingerprints": [
        "SHA256_FINGERPRINT_FROM_KEYSTORE"
      ]
    }
  }
]
```

SHA256 지문 확인:
```bash
# 디버그 키스토어
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

# 릴리스 키스토어
keytool -list -v -keystore your-release-key.jks -alias your-key-alias
```

### 웹 (Web)

웹에서는 별도 설정 없이 GoRouter가 자동으로 `/auth/callback` 라우트를 처리합니다.

## 🚀 백엔드 설정

백엔드는 OAuth 인증 후 다음 URL로 리다이렉트해야 합니다:

```
{FRONTEND_URL}/auth/callback?accessToken={ACCESS_TOKEN}&refreshToken={REFRESH_TOKEN}
```

### 환경별 FRONTEND_URL

- **개발 (웹)**: `http://localhost:3001`
- **프로덕션 (웹)**: `https://yourdomain.com`
- **프로덕션 (모바일)**: `https://yourdomain.com` (Universal/App Links)

`lib/core/config/environment.dart`에 설정되어 있습니다.

## 🧪 테스트 방법

### 웹 테스트

```bash
# 1. 백엔드 실행 (포트 3000)
cd backend && npm run start:dev

# 2. Flutter 웹 실행 (포트 3001)
flutter run -d chrome --web-port=3001

# 3. 로그인 화면에서 "Google로 계속하기" 클릭
# 4. OAuth 페이지가 열리고 로그인 후 자동으로 앱으로 돌아옴
```

### 모바일 테스트 (개발 환경)

모바일에서는 `localhost`를 사용할 수 없으므로 `ngrok`를 사용하여 로컬 서버를 공개해야 합니다.

#### 1. ngrok 설치 및 실행
```bash
# ngrok 설치
# https://ngrok.com/download

# 백엔드를 공개 (포트 3000)
ngrok http 3000

# 출력 예시:
# Forwarding: https://abc123.ngrok.io -> http://localhost:3000
```

#### 2. 환경 설정 업데이트
`lib/core/config/environment.dart`:
```dart
static String get apiBaseUrl {
  switch (_currentEnvironment) {
    case Environment.development:
      return 'https://abc123.ngrok.io'; // ngrok URL
    // ...
  }
}

static String get frontendUrl {
  switch (_currentEnvironment) {
    case Environment.development:
      return 'https://def456.ngrok.io'; // 프론트엔드용 ngrok URL (앱 자체)
    // ...
  }
}
```

#### 3. AndroidManifest.xml 업데이트
```xml
<data
    android:scheme="https"
    android:host="def456.ngrok.io"
    android:pathPrefix="/auth/callback" />
```

#### 4. iOS Runner.entitlements 업데이트
```xml
<string>applinks:def456.ngrok.io</string>
```

#### 5. 앱 실행 및 테스트
```bash
# Android
flutter run -d <android-device-id>

# iOS
flutter run -d <ios-device-id>
```

## 📝 주의사항

### 1. 프로덕션 배포 시
- `yourdomain.com`을 실제 도메인으로 변경
- `apple-app-site-association` 및 `assetlinks.json` 파일을 웹사이트에 배포
- HTTPS 필수 (Universal/App Links는 HTTP 미지원)

### 2. 개발 중
- 웹: `localhost`만 사용하므로 추가 설정 불필요
- 모바일: `ngrok` 등을 사용하여 로컬 서버를 공개해야 함

### 3. 토큰 보안
- Access Token과 Refresh Token은 `flutter_secure_storage`로 암호화 저장
- Android: EncryptedSharedPreferences 사용
- iOS: Keychain 사용

### 4. 에러 처리
- OAuth 콜백에 토큰이 없으면 에러 화면 표시
- 네트워크 에러 시 SnackBar로 알림

## 🔍 디버깅

### Deep Link 테스트 (Android)
```bash
# adb로 Deep Link 시뮬레이션
adb shell am start -W -a android.intent.action.VIEW -d "https://yourdomain.com/auth/callback?accessToken=test&refreshToken=test" com.example.family_planner
```

### Deep Link 테스트 (iOS)
```bash
# xcrun으로 Deep Link 시뮬레이션
xcrun simctl openurl booted "https://yourdomain.com/auth/callback?accessToken=test&refreshToken=test"
```

### 로그 확인
```bash
# Flutter 로그
flutter logs

# Android 로그
adb logcat | grep flutter

# iOS 로그
xcrun simctl spawn booted log stream --predicate 'processImagePath contains "Runner"'
```

## 📚 참고 자료

- [Flutter URL Launcher](https://pub.dev/packages/url_launcher)
- [Flutter App Links](https://pub.dev/packages/app_links)
- [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage)
- [iOS Universal Links](https://developer.apple.com/ios/universal-links/)
- [Android App Links](https://developer.android.com/training/app-links)

## ✅ 완료된 작업

- [x] `url_launcher`, `app_links`, `flutter_secure_storage` 패키지 추가
- [x] `SecureStorageService` 구현 (토큰 암호화 저장)
- [x] `OAuthCallbackHandler` 구현 (Deep Link 처리)
- [x] `AuthService`에 OAuth URL 방식 로그인 메서드 추가
- [x] `AuthProvider`에 OAuth 콜백 스트림 구독 추가
- [x] `/auth/callback` 웹 라우트 및 화면 구현
- [x] 로그인 화면을 OAuth URL 방식으로 변경
- [x] `main.dart`에 Deep Link 리스너 초기화
- [x] iOS Universal Links 설정 (`Runner.entitlements`)
- [x] Android App Links 설정 (`AndroidManifest.xml`)
- [x] `frontendUrl` 환경 설정 추가

## 🎯 다음 단계

1. 실제 도메인 확보 후 설정 파일 업데이트
2. `apple-app-site-association` 파일 생성 및 배포
3. `assetlinks.json` 파일 생성 및 배포
4. 프로덕션 환경에서 테스트
