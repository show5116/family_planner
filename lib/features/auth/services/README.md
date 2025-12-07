# 인증 서비스 아키텍처

이 문서는 리팩토링된 인증 서비스의 구조와 사용 방법을 설명합니다.

## 파일 구조

```
lib/features/auth/services/
├── auth_service.dart           # 메인 인증 서비스 (기본 인증 + 통합)
├── google_auth_service.dart    # Google Sign-In SDK 전용
├── kakao_auth_service.dart     # Kakao Flutter SDK 전용
├── oauth_web_service.dart      # OAuth URL 방식 공통 로직
├── oauth_callback_handler.dart # OAuth 콜백 처리 (웹)
├── oauth_popup_*.dart          # OAuth 팝업 처리 (웹)
└── README.md                   # 이 문서

lib/core/services/
└── secure_storage_service.dart # 보안 스토리지 (공통)
```

## 서비스 분리 이유

### 1. **auth_service.dart** (메인 인증 서비스)
- **역할**: 전체 인증 기능의 통합 인터페이스
- **담당**:
  - 이메일/비밀번호 로그인
  - 회원가입
  - 로그아웃
  - 토큰 관리 (검증, 갱신)
  - 이메일 인증
  - 비밀번호 재설정
  - 프로필 업데이트
  - 소셜 로그인 통합 (Google, Kakao)

### 2. **google_auth_service.dart** (Google 전용)
- **역할**: Google Sign-In SDK 관리
- **담당**:
  - Google Sign-In SDK 초기화
  - 로그인/로그아웃
  - Access Token 및 ID Token 획득
  - 자동 로그인 (Silent Sign-In)

### 3. **kakao_auth_service.dart** (Kakao 전용)
- **역할**: Kakao Flutter SDK 관리
- **담당**:
  - Kakao SDK 초기화
  - 카카오톡/카카오 계정 로그인
  - 로그아웃/연결 끊기
  - Access Token 획득
  - 사용자 정보 조회

### 4. **oauth_web_service.dart** (OAuth URL 방식 공통)
- **역할**: 웹 OAuth URL 방식 로그인 공통 로직
- **담당**:
  - 웹: 팝업 창으로 OAuth 페이지 열기
  - 모바일: 외부 브라우저로 OAuth 페이지 열기
  - Google/Kakao에서 공통으로 사용

## 플랫폼별 로그인 방식

### 웹 (Web)
```dart
// OAuth URL 방식 사용
await authService.loginWithGoogleOAuth(); // Google
await authService.loginWithKakaoOAuth();  // Kakao
```

**동작 방식:**
1. 팝업 창으로 백엔드 OAuth URL 열기
2. 백엔드가 Google/Kakao OAuth 페이지로 리다이렉트
3. 사용자 인증 완료 후 백엔드가 JWT 토큰 발급
4. 백엔드가 프론트엔드 콜백 URL로 리다이렉트 (토큰 포함)
5. `postMessage`로 부모 창에 토큰 전달

### 모바일 (Android/iOS)
```dart
// SDK 방식 사용
await authService.loginWithGoogle(); // Google
await authService.loginWithKakao();  // Kakao
```

**동작 방식:**
1. Google Sign-In SDK 또는 Kakao Flutter SDK로 로그인
2. SDK에서 Access Token / ID Token 획득
3. 백엔드에 토큰 전송하여 검증 요청
4. 백엔드가 JWT 토큰 발급
5. JWT 토큰을 로컬에 저장

## 사용 예제

### 기본 이메일/비밀번호 로그인
```dart
final authService = AuthService();

// 로그인
await authService.login(
  email: 'user@example.com',
  password: 'password123',
);

// 회원가입
await authService.register(
  email: 'user@example.com',
  password: 'password123',
  name: 'John Doe',
);

// 로그아웃
await authService.logout();
```

### 소셜 로그인 (플랫폼 자동 감지)
```dart
// AuthProvider에서 플랫폼 자동 분기
if (kIsWeb) {
  await authService.loginWithGoogleOAuth();
} else {
  await authService.loginWithGoogle();
}
```

### 프로필 업데이트
```dart
await authService.updateProfile(
  name: 'New Name',
  phoneNumber: '010-1234-5678',
  profileImage: 'https://example.com/avatar.jpg',
  currentPassword: 'oldpassword', // 비밀번호 변경 시 필수
  newPassword: 'newpassword',     // 비밀번호 변경 시 필수
);
```

## 공통 패턴 및 헬퍼 메서드

### 1. 토큰 저장 (`_saveTokens`)
```dart
Future<void> _saveTokens(Map<String, dynamic> data) async {
  if (data['accessToken'] != null) {
    await apiClient.saveAccessToken(data['accessToken'] as String);
  }
  if (data['refreshToken'] != null) {
    await apiClient.saveRefreshToken(data['refreshToken'] as String);
  }
}
```

**사용 위치:**
- `login()` - 이메일/비밀번호 로그인
- `refreshToken()` - 토큰 갱신
- `loginWithGoogle()` - Google SDK 로그인
- `loginWithKakao()` - Kakao SDK 로그인

### 2. 사용자 정보 저장 (`_saveUserInfoFromResponse`)
```dart
Future<void> _saveUserInfoFromResponse(Map<String, dynamic> data) async {
  final user = data['user'] ?? data; // 'user' 키가 있으면 사용, 없으면 최상위

  await _storage.saveUserInfo(
    email: user['email'],
    name: user['name'],
    phoneNumber: user['phoneNumber'],
    profileImage: user['profileImage'],
    isAdmin: user['isAdmin'],
    hasPassword: user['hasPassword'],
  );
}
```

**사용 위치:**
- `login()` - 이메일/비밀번호 로그인
- `loginWithGoogle()` - Google SDK 로그인
- `loginWithKakao()` - Kakao SDK 로그인
- `getUserInfo()` - OAuth 콜백 후 사용자 정보 조회
- `updateProfile()` - 프로필 업데이트

### 3. 소셜 로그인 정리 (`_cleanupSocialLogin`)
```dart
Future<void> _cleanupSocialLogin() async {
  await signOutGoogle();
  if (!kIsWeb) {
    await signOutKakao();
  }
}
```

**사용 위치:**
- `logout()` - 로그아웃 시 소셜 로그인 SDK도 함께 로그아웃

## 의존성

### auth_service.dart
```dart
import 'package:family_planner/features/auth/services/google_auth_service.dart';
import 'package:family_planner/features/auth/services/kakao_auth_service.dart';
import 'package:family_planner/features/auth/services/oauth_web_service.dart';
import 'package:family_planner/features/auth/services/oauth_callback_handler.dart';
import 'package:family_planner/core/services/secure_storage_service.dart';
```

### google_auth_service.dart
```dart
import 'package:google_sign_in/google_sign_in.dart';
```

### kakao_auth_service.dart
```dart
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
```

### oauth_web_service.dart
```dart
import 'package:url_launcher/url_launcher.dart';
import 'package:family_planner/features/auth/services/oauth_popup_helper.dart';
```

## 백엔드 API 요구사항

### 현재 임시 구현
모바일 SDK 로그인은 임시로 웹용 OAuth callback 엔드포인트를 사용 중입니다:
- Google: `GET /auth/google/callback?access_token=xxx`
- Kakao: `GET /auth/kakao/callback?access_token=xxx`

### 올바른 구현 (권장)
백엔드에 다음 엔드포인트를 추가하면 더 안전하고 명확합니다:

**Google:**
```
POST /auth/google/token
Request Body: { "accessToken": "...", "idToken": "..." }
Response: { "accessToken": "jwt", "refreshToken": "jwt", "user": {...} }
```

**Kakao:**
```
POST /auth/kakao/token
Request Body: { "accessToken": "..." }
Response: { "accessToken": "jwt", "refreshToken": "jwt", "user": {...} }
```

## 리팩토링 효과

### Before (단일 파일)
- **auth_service.dart**: 546줄
- Google Sign-In, Kakao SDK 코드가 모두 섞여 있음
- OAuth URL 방식이 Google/Kakao에서 중복됨
- 토큰 저장 로직이 여러 곳에서 반복됨

### After (분리된 구조)
- **auth_service.dart**: ~300줄 (기본 인증 + 통합)
- **google_auth_service.dart**: ~85줄 (Google 전용)
- **kakao_auth_service.dart**: ~82줄 (Kakao 전용)
- **oauth_web_service.dart**: ~79줄 (OAuth 공통)
- 각 서비스가 명확한 책임을 가짐
- 공통 로직이 헬퍼 메서드로 추출됨
- 코드 재사용성 및 유지보수성 향상

## 추가 개선 사항

1. ✅ **토큰 저장 공통화** - `_saveTokens()` 메서드로 통합
2. ✅ **OAuth URL 방식 공통화** - `OAuthWebService.login()` 사용
3. ✅ **소셜 로그인 SDK 분리** - 각각 독립적인 서비스로 분리
4. ✅ **로그아웃 로직 정리** - `_cleanupSocialLogin()` 메서드로 추출
5. ✅ **코드 섹션 구분** - 주석으로 명확하게 구분

## 참고 사항

- **웹 OAuth 콜백**: `oauth_callback_handler.dart`에서 처리
- **웹 OAuth 팝업**: `oauth_popup_web.dart`에서 처리
- **토큰 저장**: `api_client.dart` (Dio Interceptor)
- **사용자 정보 저장**: `secure_storage_service.dart` (Flutter Secure Storage)
