# 14. 알림 (Notification)

## 상태
🟨 진행 중

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
- ✅ 알림 히스토리 화면 (전체 화면)
- ✅ 읽음/안 읽음 표시
- ✅ 무한 스크롤 (페이지네이션)
- ✅ 홈 화면 우측 상단 알림 팝업 카드
- ✅ 읽지 않은 알림 개수 뱃지
- ✅ 스와이프로 알림 삭제 (Dismissible)

## 데이터 모델
- ✅ NotificationModel (id, userId, category, title, body, data, isRead, sentAt, readAt)
- ✅ NotificationSettingsModel (카테고리별 enabled 플래그)
- ✅ NotificationCategory enum (schedule, todo, household, asset, childcare, group, system)
- ✅ 백엔드 API 응답 구조와 매핑 완료

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
- ✅ 백엔드 API 연동 완료 (설정 조회/수정)
- ✅ 테스트 알림 전송 기능 (관리자 전용)

## FCM 토큰 관리
- ✅ FCM 토큰 생성 및 Provider 관리
- ✅ 토큰 갱신 리스너 등록
- ✅ 플랫폼별 토큰 처리 (Android, iOS, Web)
- ✅ 로그인 시 토큰 백엔드 등록 (모든 로그인 방식)
- ✅ 로그아웃 시 토큰 백엔드 삭제
- ✅ 웹 개발 환경에서 FCM 토큰 없이도 정상 작동
- ⚠️ 웹 FCM은 프로덕션 배포 시 작동 (Service Worker + VAPID 키 필요)

## 알림 히스토리
- ✅ NotificationModel 정의
- ✅ Repository 구현 (백엔드 API 연동 완료)
- ✅ Provider 구현 (상태 관리)
- ✅ 알림 목록 조회 API 연동 (페이지네이션 지원)
- ✅ 알림 히스토리 화면 UI (전체 화면)
- ✅ 읽음 처리 API 연동
- ✅ 페이지네이션 구현 (무한 스크롤)
- ✅ 홈 화면 알림 팝업 (읽지 않은 알림 최대 5개)
- ✅ 읽지 않은 알림 개수 Provider
- ✅ 알림 삭제 기능 (스와이프)

## API 연동
- ✅ FCM 토큰 등록 (POST /notifications/token) - 로그인 시 자동 등록
- ✅ FCM 토큰 삭제 (DELETE /notifications/token/:token) - 로그아웃 시 자동 삭제
- ✅ 알림 설정 조회 (GET /notifications/settings)
- ✅ 알림 설정 수정 (PUT /notifications/settings)
- ✅ 알림 히스토리 조회 (GET /notifications) - 페이지네이션 지원
- ✅ 읽지 않은 알림 개수 (GET /notifications/unread-count)
- ✅ 알림 읽음 처리 (PUT /notifications/:id/read)
- ✅ 알림 삭제 (DELETE /notifications/:id)
- ✅ 테스트 알림 전송 (POST /notifications/test) - 관리자 전용

## 참고 문서
- [Firebase 설정 가이드](../FIREBASE_SETUP.md)
- [GitHub Secrets 설정 가이드](../GITHUB_SECRETS_SETUP.md)
- [백엔드 API 문서](../api/notifications.md)

---

## 현재 구현 상태

### ✅ 완료된 기능
1. **FCM 토큰 관리**
   - 로그인 시 자동 등록 (이메일, Google, Kakao, 자동 로그인 모두 지원)
   - 로그아웃 시 자동 삭제
   - 플랫폼별 토큰 처리 (web, android, ios)
   - 웹 개발 환경에서 토큰 없이도 정상 작동

2. **알림 설정**
   - 카테고리별 알림 on/off (7개 카테고리)
   - 백엔드 동기화
   - 테스트 알림 전송 (관리자 전용)

3. **알림 히스토리**
   - 전체 알림 목록 조회 (페이지네이션)
   - 읽음/읽지 않음 필터
   - 읽음 처리
   - 알림 삭제 (스와이프)
   - 무한 스크롤

4. **홈 화면 알림**
   - 우측 상단 알림 아이콘
   - 읽지 않은 알림 개수 뱃지
   - 알림 팝업 카드 (최대 5개)
   - 히스토리 화면으로 이동

### ⚠️ 제한 사항
- **웹 FCM**: 로컬 개발 환경에서는 작동하지 않음
  - Service Worker (`firebase-messaging-sw.js`) 설정 필요
  - VAPID 키가 .env에 설정되어야 함
  - 프로덕션 배포 시 정상 작동 예정

### 📋 남은 작업
1. **프로덕션 배포 준비**
   - [ ] firebase-messaging-sw.js에 실제 Firebase 설정 추가
   - [ ] .env에 FIREBASE_WEB_VAPID_KEY 설정
   - [ ] HTTPS 환경에서 테스트

2. **실제 푸시 알림 테스트**
   - [ ] Android/iOS에서 FCM 푸시 테스트
   - [ ] 웹 프로덕션 환경에서 푸시 테스트
   - [ ] 알림 클릭 시 화면 라우팅 테스트

3. **개선 사항**
   - [ ] 알림 클릭 시 관련 화면으로 자동 이동 (데이터 기반 라우팅)
   - [ ] 포그라운드 알림 UI/UX 개선
   - [ ] 알림 사운드 및 진동 커스터마이징
