# 1. 회원 가입 및 로그인

## 상태
🟨 진행 중

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
- ⬜ 애플 로그인 SDK 연동
- ✅ 소셜 로그인 클라이언트 로직 구현 (토큰 획득)
- ⚠️ 소셜 로그인 백엔드 API 연동 (임시 구현, 백엔드 개선 필요)
  - 현재: 웹 리다이렉트 방식의 callback URL 사용 (불완전)
  - 필요: POST /auth/google/token, POST /auth/kakao/token 엔드포인트
  - 상세 내용은 CLAUDE.md의 "소셜 로그인 API" 섹션 참조

## 상태 관리
- ✅ Auth Provider 구현 (AuthNotifier + AuthState)
- ✅ 로그인 상태 전역 관리 (isAuthenticated, user)
- ✅ 사용자 정보 관리 (AuthState.user)
- ✅ OAuth 콜백 처리 (웹 전용)
- ✅ 프로필 업데이트 시 상태 자동 갱신

---

## 관련 파일
- `lib/features/auth/screens/` - 인증 관련 화면들
- `lib/features/auth/providers/auth_provider.dart` - AuthNotifier, AuthState
- `lib/features/auth/services/auth_service.dart` - 인증 API 서비스
- `lib/features/auth/services/oauth_callback_handler.dart` - OAuth 콜백 처리
- `lib/core/services/secure_storage_service.dart` - 토큰 및 사용자 정보 저장

## 노트
- 소셜 로그인 백엔드 API가 완성되면 연동 필요
- 자세한 설정 방법은 [docs/SOCIAL_LOGIN_SETUP.md](../SOCIAL_LOGIN_SETUP.md) 참조
