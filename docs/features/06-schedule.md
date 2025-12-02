# 6. 일정 관리 메뉴

## 상태
⬜ 시작 안함

---

## UI 구현
- ✅ 일정 탭 플레이스홀더 화면
- ⬜ 월간 캘린더 뷰 (table_calendar)
- ⬜ 주간/일간 캘린더 뷰
- ⬜ 일정 목록 뷰
- ⬜ 일정 상세 화면
- ⬜ 일정 추가/수정 폼
- ⬜ 반복 일정 설정 UI

## 데이터 모델
- ⬜ 일정 모델 (Event)
- ⬜ 반복 일정 모델 (RecurringEvent)
- ⬜ 알림 설정 모델 (Notification)

## 기능 구현
- ⬜ 당일 일정 등록
- ⬜ 매년 반복 일정 등록
- ⬜ 일정 제목, 시간, 장소, 메모 입력
- ⬜ 공유 대상 설정 (본인/가족 전체/특정 인원)
- ⬜ 당일 오전 알람
- ⬜ 1시간 전 알람
- ⬜ 사용자 정의 시간 알람
- ⬜ 푸시 알림 지원
- ⬜ 일정 검색 기능
- ⬜ 일정 필터링 (내 일정/공유 일정)

## API 연동
- ⬜ 일정 목록 조회 API
- ⬜ 일정 추가 API
- ⬜ 일정 수정/삭제 API
- ⬜ 반복 일정 관리 API
- ⬜ 알림 설정 API

## 상태 관리
- ⬜ Calendar Provider 구현
- ⬜ Events Provider 구현
- ⬜ Notifications Provider 구현

---

## 관련 파일
- `lib/features/schedule/` (예정)

## 패키지
- `table_calendar` - 캘린더 UI

## 노트
- 푸시 알림 기능은 Firebase Cloud Messaging 설정 필요
