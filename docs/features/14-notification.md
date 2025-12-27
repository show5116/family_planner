# 14. 알림 (Notification)

## 상태
🟨 진행 중 (프론트엔드 완료, 백엔드 API 대기)

---

## 핵심 개념
- Firebase Cloud Messaging (FCM)을 통한 푸시 알림
- 카테고리별 알림 on/off 설정 가능
- 포그라운드/백그라운드/종료 상태 모든 시나리오 지원
- 알림 클릭 시 해당 화면으로 자동 이동

## UI 구현
- ✅ 알림 설정 화면 (설정 메뉴 내)
- ✅ 권한 상태 표시 카드
- ✅ 카테고리별 알림 토글 (일정, 가계부, 할일, 자산, 육아, 그룹, 시스템)
- [ ] 알림 히스토리 화면 (백엔드 완료 후)
- [ ] 읽음/안 읽음 표시
- [ ] 무한 스크롤 (페이지네이션)

## 데이터 모델
- ✅ NotificationModel (id, title, body, type, timestamp, isRead, data)
- ✅ NotificationSettingsModel (카테고리별 enabled 플래그)
- ✅ NotificationType enum (schedule, todo, household, asset, childcare, group, system)

## Firebase 설정
- ✅ Firebase 프로젝트 설정 완료 (Android, iOS, Web)
- ✅ google-services.json 추가 (Android)
- ✅ GoogleService-Info.plist 추가 (iOS)
- ✅ VAPID Key 설정 (Web)
- ✅ 환경 변수로 Firebase 설정 관리 (.env)
- ✅ GitHub Actions에서 환경 변수 동적 생성

## 알림 수신 및 처리
- ✅ 포그라운드 알림 처리 (로컬 알림으로 표시)
- ✅ 백그라운드 알림 처리
- ✅ 알림 클릭 시 화면 라우팅
- ✅ FCM 토큰 관리 (등록, 갱신, 삭제)
- ✅ 백그라운드 메시지 핸들러 (Top-level 함수)

## 알림 설정 관리
- ✅ 알림 권한 요청 (iOS, Android, Web)
- ✅ 카테고리별 알림 활성화/비활성화
- ✅ 설정 로컬 저장 및 백엔드 동기화 준비
- [ ] 백엔드 API 연동 후 실시간 동기화

## FCM 토큰 관리
- ✅ FCM 토큰 생성 및 Provider 관리
- ✅ 토큰 갱신 리스너 등록
- ✅ 플랫폼별 토큰 처리 (Android, iOS, Web)
- [ ] 로그인 시 토큰 백엔드 등록
- [ ] 로그아웃 시 토큰 백엔드 삭제

## 알림 히스토리
- ✅ NotificationModel 정의
- ✅ Repository 구현 (API 연동 준비)
- ✅ Provider 구현 (상태 관리)
- [ ] 알림 목록 조회 API 연동
- [ ] 알림 히스토리 화면 UI
- [ ] 읽음 처리 API 연동
- [ ] 페이지네이션 구현

## API 연동 (백엔드 작업 필요)
- [ ] FCM 토큰 등록 (POST /api/notifications/token)
- [ ] FCM 토큰 삭제 (DELETE /api/notifications/token)
- [ ] 알림 설정 조회 (GET /api/notifications/settings)
- [ ] 알림 설정 수정 (PUT /api/notifications/settings)
- [ ] 알림 히스토리 조회 (GET /api/notifications)
- [ ] 알림 읽음 처리 (PUT /api/notifications/:id/read)
- [ ] 알림 삭제 (DELETE /api/notifications/:id)

## 백엔드 구현 필요 사항
- [ ] 데이터베이스 테이블 생성
  - fcm_tokens (user_id, token, device_type)
  - notification_settings (user_id, 카테고리별 enabled 플래그)
  - notifications (user_id, title, body, type, data, is_read, timestamp)
- [ ] Firebase Admin SDK 설정
- [ ] FCM 알림 전송 서비스 구현
- [ ] 각 기능별 알림 트리거 추가 (일정, 가계부, 할일 등)

## 참고 문서
- [Firebase 설정 가이드](../FIREBASE_SETUP.md)
- [GitHub Secrets 설정 가이드](../GITHUB_SECRETS_SETUP.md)
- [알림 구현 상세 가이드](../notification/implementation-guide.md)
- [알림 백엔드 연동 가이드](../notification/backend-integration.md)
