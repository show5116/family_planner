# 1. 회원 가입 및 로그인 ✅

## 상태
✅ 완료

---

## UI 구현
- ✅ 로그인 화면 레이아웃 및 반응형 디자인
- ✅ 이메일/비밀번호 입력 필드
- ✅ 소셜 로그인 버튼 UI (구글, 카카오, 애플)
- ✅ 회원가입 링크
- ✅ 회원가입 화면 UI
- ✅ 이메일 인증 화면 UI
- ✅ 비밀번호 찾기 화면 UI
- ✅ 비밀번호 찾기 링크 연결 (로그인 화면)
- ✅ 스플래시 화면 (SplashScreen) — 자동 로그인 판별 후 분기
- ✅ 소셜 로그인 약관 동의 화면 (SocialTermsScreen) — 최초 소셜 가입 시 약관 동의
- ✅ OAuth 콜백 화면 (OauthCallbackScreen) — 웹 소셜 로그인 리다이렉트 수신
- ✅ 이용약관 / 개인정보 처리방침 화면

## 인증 로직
- ✅ 이메일/비밀번호 로그인 구현
- ✅ 회원가입 API 연동
- ✅ 이메일 인증 API 연동 (POST /auth/verify-email, code 파라미터 사용)
- ✅ 인증 이메일 재전송 기능
- ✅ 로그인 API 연동
- ✅ RTR(Refresh Token Rotation) 방식 구현
  - ✅ AccessToken 관리 (SharedPreferences)
  - ✅ RefreshToken 자동 갱신 (401 에러 시 자동 갱신)
  - ✅ 토큰 만료 처리 (Interceptor에서 자동 처리)
- ✅ 로그인 상태 지속성 (SharedPreferences + 자동 로그인)
- ✅ 비밀번호 재설정 요청 API 연동
- ✅ 비밀번호 재설정 API 연동

## 소셜 로그인
- ✅ 구글 로그인 SDK 연동 (google_sign_in)
- ✅ 카카오 로그인 SDK 연동 (kakao_flutter_sdk)
- ✅ 애플 로그인 SDK 연동 (sign_in_with_apple)
- ✅ 소셜 로그인 클라이언트 로직 (토큰 획득)
- ✅ **네이티브**: `POST /auth/{google|kakao|apple}/mobile` — SDK 토큰을 서버에 전달
- ✅ **웹**: 팝업/리다이렉트 방식 (`GET /auth/{provider}` → `/auth/{provider}/callback`)
  - `oauth_popup_helper` / `oauth_web_service` — 웹·네이티브 조건부 import로 분기
- ✅ 최초 소셜 가입 시 약관 동의 (`POST /auth/social-signup`)

## 상태 관리
- ✅ Auth Provider 구현 (AuthNotifier + AuthState)
- ✅ 로그인 상태 전역 관리 (isAuthenticated, user)
- ✅ 사용자 정보 관리 (AuthState.user)
- ✅ OAuth 콜백 처리 (웹 전용)
- ✅ 프로필 업데이트 시 상태 자동 갱신

---

## API 연동
- ✅ `POST /auth/signup` · `POST /auth/login` · `POST /auth/logout`
- ✅ `POST /auth/refresh` — RTR 토큰 갱신
- ✅ `POST /auth/verify-email` · `POST /auth/resend-verification`
- ✅ `POST /auth/request-password-reset` · `POST /auth/reset-password`
- ✅ `GET /auth/me` — 내 정보 조회
- ✅ `PATCH /auth/update-profile` · `POST /auth/upload-profile-photo`
- ✅ `POST /auth/{google|kakao|apple}/mobile` — 네이티브 소셜 로그인
- ✅ `GET /auth/{google|kakao|apple}` + `/callback` — 웹 소셜 로그인
- ✅ `POST /auth/social-signup` — 소셜 최초 가입(약관 동의)
- ✅ `PUT /auth/location` — 위치 저장 (날씨 알림용)
- ✅ `DELETE /auth/me` — 계정 삭제 예약
- ✅ `POST /auth/me/cancel-delete` — 삭제 예약 취소
- ✅ `POST /auth/me/export` — 내 데이터 내보내기

---

## 관련 파일
- `lib/features/auth/presentation/screens/` — 로그인·회원가입·이메일 인증·비밀번호 찾기·
  스플래시·소셜 약관·OAuth 콜백·약관·개인정보 처리방침
- `lib/features/auth/presentation/widgets/` — auth_app_bar, auth_link_row, social_login_button
- `lib/features/auth/providers/auth_provider.dart` — AuthNotifier, AuthState
- `lib/features/auth/services/auth_service.dart` — 인증 API 서비스
- `lib/features/auth/services/{google|kakao|apple}_auth_service.dart` — SDK 래퍼
- `lib/features/auth/services/oauth_*` — 웹 팝업·콜백 처리 (조건부 import)
- `lib/core/services/secure_storage_service.dart` — 토큰 및 사용자 정보 저장

## API 문서
[docs/api/auth.md](../api/auth.md)

## 노트
- 소셜 로그인은 네이티브(SDK 토큰 → `/mobile`)와 웹(리다이렉트 → `/callback`)이
  서로 다른 경로를 씁니다. 조건부 import로 플랫폼별 구현을 분리했습니다.
- 계정 삭제는 즉시 삭제가 아니라 **7일 유예 예약**입니다
  ([12-settings.md](12-settings.md#계정-관리-프로필-화면-하단) 참조).
- 자세한 설정 방법은 [docs/setup/SOCIAL_LOGIN_SETUP.md](../setup/SOCIAL_LOGIN_SETUP.md) 참조
