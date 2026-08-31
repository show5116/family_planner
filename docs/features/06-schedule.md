# 6. 일정 관리 메뉴 ✅

## 상태
✅ 완료

---

## UI 구현
- ✅ 일정 탭 플레이스홀더 화면
- ✅ 월간 캘린더 뷰 (table_calendar)
- ✅ 주간/일간 캘린더 뷰
- ✅ 일정 목록 뷰
- ✅ 일정 상세 화면 (TaskFormScreen 수정 모드)
- ✅ 일정 추가/수정 폼 (TaskFormScreen)
- ✅ 반복 일정 설정 UI (RecurringRuleType 선택)
- ✅ 카테고리 관리 화면 (CRUD)
- ✅ 기념일 목록 화면 (AnniversaryListScreen)
- ✅ 기념일 상세 화면 (AnniversaryDetailScreen)
- ✅ 기념일 생성/수정 다이얼로그 (AnniversaryFormDialog)

## 데이터 모델
- ✅ Task 통합 모델 (TaskModel) - API 스펙에 맞춰 일정/할일 통합
- ✅ 카테고리 모델 (CategoryModel)
- ✅ 반복 설정 모델 (RecurringModel, RecurringRuleDto)
- ✅ 알림 설정 모델 (TaskReminderDto, TaskReminderResponse)
- ✅ 우선순위/타입 enum (TaskPriority, TaskType)
- ✅ 참가자 모델 (TaskParticipantModel, ParticipantUserModel)

## 기능 구현
- ✅ 당일 일정 등록
- ✅ 매년 반복 일정 등록 (매일/매주/매월/매년)
- ✅ 일정 제목, 시간, 장소, 메모 입력
- ✅ 그룹별 일정 관리 (개인/그룹 선택)
- ✅ 마감일 설정 (시작일과 별도로 설정 가능)
- ✅ 당일 오전 알람 (알림 설정 UI 구현)
- ✅ 1시간 전 알람 (알림 설정 UI 구현)
- ✅ 사용자 정의 시간 알람 (5분/15분/30분/1시간/1일 전)
- ✅ 참가자 선택 (그룹 일정에서 멤버 선택)
- ✅ 푸시 알림 지원 (FCM 연동 필요)
- ✅ 일정 검색 기능

### 기념일 (Anniversary)
- ✅ 그룹별 기념일 등록 (이름, 날짜, 이모지)
- ✅ D-day 계산 — `daysSince`(당일 0) 기준 D+N 표시
- ✅ milestone Task 자동 생성 — 100일 단위(`every100Days`), 매년 주년(`everyYear`)
- ✅ 대시보드 기념일 위젯 연동 (표시할 기념일 직접 선택)

## API 연동
- ✅ Task 목록 조회 API (GET /tasks)
- ✅ Task 상세 조회 API (GET /tasks/:id)
- ✅ Task 생성 API (POST /tasks)
- ✅ Task 수정 API (PUT /tasks/:id)
- ✅ Task 삭제 API (DELETE /tasks/:id)
- ✅ Task 완료 처리 API (PATCH /tasks/:id/complete)
- ✅ 기념일 목록 조회 (GET /tasks/anniversaries)
- ✅ 기념일 상세 조회 (GET /tasks/anniversaries/:id)
- ✅ 기념일 생성 (POST /tasks/anniversaries)
- ✅ 기념일 수정 (PUT /tasks/anniversaries/:id)
- ✅ 기념일 삭제 (DELETE /tasks/anniversaries/:id)
- ✅ 카테고리 목록 조회 API (GET /tasks/categories)
- ✅ 카테고리 생성 API (POST /tasks/categories)
- ✅ 카테고리 수정 API (PUT /tasks/categories/:id)
- ✅ 카테고리 삭제 API (DELETE /tasks/categories/:id)
- ✅ 반복 일정 일시정지/재개 API (PATCH /tasks/recurrings/:id/pause)
- ✅ 반복 일정 건너뛰기 API (POST /tasks/recurrings/:id/skip)

## 상태 관리
- ✅ Task Provider 구현 (월간 Task, 선택 날짜 Task)
- ✅ Task Management Provider (CRUD 작업)
- ✅ 카테고리 Provider
- ✅ Category Management Provider (CRUD 작업)
- ✅ 그룹 선택 Provider (selectedGroupIdProvider)

---

## 관련 파일
- `lib/features/main/calendar/screens/calendar_tab.dart` - 월간 캘린더 뷰 화면
- `lib/features/main/calendar/screens/task_form_screen.dart` - 일정 추가/수정 폼 화면
- `lib/features/main/calendar/screens/category_management_screen.dart` - 카테고리 관리 화면
- `lib/features/main/calendar/data/models/task_model.dart` - Task 통합 데이터 모델
- `lib/features/main/calendar/data/repositories/task_repository.dart` - Task Repository
- `lib/features/main/calendar/providers/task_provider.dart` - Task/Category Provider
- `lib/core/routes/main_routes.dart` - 일정 라우트 설정

## 패키지
- `table_calendar` - 캘린더 UI

## 노트
- 백엔드 API는 일정(Schedule)과 할일(Todo)을 Task로 통합 관리
- 푸시 알림 기능은 Firebase Cloud Messaging 설정 필요
- D-Day 표시 기능 구현 완료 (daysUntilDue 활용)
- 한국 캘린더 색상 컨벤션 적용: 일요일(빨간색), 토요일(파란색)
- 하단 네비게이션 탭 Lazy Loading 적용 (방문 시에만 빌드)
- 그룹별 일정/카테고리 분리 관리: 개인(groupId=null) 또는 그룹 선택 가능
- 그룹 일정에서 참가자 선택 가능 (participantIds로 그룹 멤버 지정)
