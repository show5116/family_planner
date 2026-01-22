# 6. 일정 관리 메뉴

## 상태
🟨 진행 중

---

## UI 구현
- ✅ 일정 탭 플레이스홀더 화면
- ✅ 월간 캘린더 뷰 (table_calendar)
- ⬜ 주간/일간 캘린더 뷰
- ⬜ 일정 목록 뷰
- ⬜ 일정 상세 화면
- ⬜ 일정 추가/수정 폼
- ⬜ 반복 일정 설정 UI

## 데이터 모델
- ✅ Task 통합 모델 (TaskModel) - API 스펙에 맞춰 일정/할일 통합
- ✅ 카테고리 모델 (CategoryModel)
- ✅ 반복 설정 모델 (RecurringModel, RecurringRuleDto)
- ✅ 알림 설정 모델 (TaskReminderDto, TaskReminderResponse)
- ✅ 우선순위/타입 enum (TaskPriority, TaskType)

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
- ✅ Task 목록 조회 API (GET /tasks)
- ✅ Task 상세 조회 API (GET /tasks/:id)
- ✅ Task 생성 API (POST /tasks)
- ✅ Task 수정 API (PUT /tasks/:id)
- ✅ Task 삭제 API (DELETE /tasks/:id)
- ✅ Task 완료 처리 API (PATCH /tasks/:id/complete)
- ✅ 카테고리 목록 조회 API (GET /tasks/categories)
- ✅ 반복 일정 일시정지/재개 API (PATCH /tasks/recurrings/:id/pause)
- ✅ 반복 일정 건너뛰기 API (POST /tasks/recurrings/:id/skip)

## 상태 관리
- ✅ Task Provider 구현 (월간 Task, 선택 날짜 Task)
- ✅ Task Management Provider (CRUD 작업)
- ✅ 카테고리 Provider

---

## 관련 파일
- `lib/features/main/calendar/screens/calendar_tab.dart` - 월간 캘린더 뷰 화면
- `lib/features/main/calendar/data/models/task_model.dart` - Task 통합 데이터 모델
- `lib/features/main/calendar/data/repositories/task_repository.dart` - Task Repository
- `lib/features/main/calendar/providers/task_provider.dart` - Task Provider

## 패키지
- `table_calendar` - 캘린더 UI

## 노트
- 백엔드 API는 일정(Schedule)과 할일(Todo)을 Task로 통합 관리
- 푸시 알림 기능은 Firebase Cloud Messaging 설정 필요
- D-Day 표시 기능 구현 완료 (daysUntilDue 활용)
