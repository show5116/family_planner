# 6. 일정 관리 메뉴 ✅

## 상태
✅ 완료

---

## UI 구현

### 캘린더 뷰
- ✅ 월간 캘린더 (table_calendar, CalendarView)
- ✅ 주간 캘린더 (CalendarFormat.week)
- ✅ 주간 타임테이블 뷰 (WeekTimetableView — 일~토 × 24시간 그리드)
- ✅ 일간 뷰 (DayView)
- ✅ 연간 뷰 (YearView)
- ✅ 날짜별 일정 목록 (TaskListSection, TaskListItem)
- ✅ 그룹 선택기 (CalendarGroupSelector — 전체 그룹/개별 그룹/개인)
- ✅ 일정 검색 (CalendarSearchBar + CalendarSearchResults)
- ✅ 공휴일 표시
- ✅ 한국 캘린더 색상 컨벤션 — 일요일 빨강, 토요일 파랑

### 일정 등록·조회
- ✅ 일정 상세 화면 (TaskDetailScreen)
- ✅ 일정 추가/수정 폼 (TaskFormScreen) — 섹션 분리 구성
  - 타입(TaskTypeSection), 카테고리(CategorySection), 날짜·시간(DateTimeSection),
    우선순위(PrioritySection), 반복(RecurringSection), 알림(ReminderSection),
    참가자(ParticipantsSection), 그룹(GroupSelector), 제목·장소·메모(TextInputFields)
- ✅ 빠른 일정 추가 시트 (QuickTaskSheet — 날짜 셀에서 바로 등록)
- ✅ 장소 검색 (카카오 로컬 API) + 지도 바텀시트 (LocationMapView)
- ✅ 카테고리 관리 화면 (CategoryManagementScreen — CRUD, 그룹별 분리)

### 기념일
- ✅ 기념일 목록 화면 (AnniversaryListScreen)
- ✅ 기념일 상세 화면 (AnniversaryDetailScreen)
- ✅ 기념일 생성/수정 다이얼로그 (AnniversaryFormDialog)

---

## 데이터 모델
- ✅ Task 통합 모델 (TaskModel) — API 스펙에 맞춰 일정/할일 통합
- ✅ 카테고리 모델 (CategoryModel)
- ✅ 반복 설정 모델 (RecurringModel, RecurringRuleDto, RuleConfigDto)
- ✅ 알림 설정 모델 (TaskReminderDto, TaskReminderResponse)
- ✅ 장소 모델 (TaskLocation) — name만 필수, 주소·좌표는 선택
- ✅ 참가자 모델 (TaskParticipantModel, ParticipantUserModel)
- ✅ 기념일 모델 (AnniversaryModel, MilestoneConfig)
- ✅ 공휴일 모델 (HolidayModel)
- ✅ enum: TaskType(CALENDAR_ONLY/TODO_LINKED/TODO_ONLY), TaskStatus, TaskPriority,
  TaskReminderType(BEFORE_START/BEFORE_DUE), RecurringRuleType, RecurringGenerationType

---

## 기능 구현
- ✅ 일정 등록 (제목, 시간, 장소, 메모)
- ✅ 종일 일정 (allDay)
- ✅ 반복 일정 (매일/매주/매월/매년) + 주말·공휴일 건너뛰기(skipWeekends/skipHolidays)
- ✅ 반복 일정 일시정지·건너뛰기
- ✅ 그룹별 일정 관리 (개인 groupId=null / 그룹 선택)
- ✅ 마감일 설정 (시작일과 별도)
- ✅ 알림 설정 (5분/15분/30분/1시간/1일 전, 시작 전/마감 전 기준)
- ✅ 참가자 선택 (그룹 일정에서 멤버 지정)
- ✅ 푸시 알림 (FCM 연동 완료 — [14-notification.md](14-notification.md))
- ✅ 일정 검색 (제목·설명·장소)
- ✅ D-Day 표시 (daysUntilDue)

### 기념일 (Anniversary)
- ✅ 그룹별 기념일 등록 (이름, 날짜, 이모지)
- ✅ D-day 계산 — `daysSince`(당일 0) 기준 D+N 표시
  - 서버는 한국식 카운트 `dayCount`(당일 1일째)도 함께 내려주며, 앱은 현재 `daysSince`를 사용
- ✅ milestone Task 자동 생성 — 100일 단위(`every100Days`), 매년 주년(`everyYear`)
- ✅ 대시보드 기념일 위젯 연동 (표시할 기념일 직접 선택)

---

## API 연동
- ✅ Task 목록 조회 (GET /tasks) — view=calendar/todo, 그룹·카테고리·기간·검색 필터
- ✅ Task 상세 조회 (GET /tasks/:id)
- ✅ Task 생성 (POST /tasks)
- ✅ Task 수정 (PUT /tasks/:id)
- ✅ Task 상태 변경 (PATCH /tasks/:id/status)
- ✅ Task 삭제 (DELETE /tasks/:id)
- ✅ 공휴일 조회 (GET /tasks/holidays)
- ✅ 카테고리 목록·전체 조회 (GET /tasks/categories, /tasks/categories/all)
- ✅ 카테고리 생성·수정·삭제 (POST/PUT/DELETE /tasks/categories[/:id])
- ✅ 반복 일정 일시정지 (PATCH /tasks/recurrings/:id/pause)
- ✅ 반복 일정 건너뛰기 (POST /tasks/recurrings/:id/skip)
- ✅ 기념일 목록·상세 (GET /tasks/anniversaries[/:id])
- ✅ 기념일 생성·수정·삭제 (POST/PUT/DELETE /tasks/anniversaries[/:id])

---

## 상태 관리
- ✅ `task_provider.dart` — 월간/선택 날짜 Task 조회, CRUD
- ✅ `task_form_provider.dart` — 폼 상태 (freezed)
- ✅ `anniversary_provider.dart` — 기념일 목록, 전체 그룹 기념일
- ✅ `holiday_provider.dart` — 연·월별 공휴일, 날짜별 조회
- ✅ 그룹 선택 Provider (selectedGroupIdProvider)

---

## 구현 위치

### 캘린더 (`lib/features/main/calendar/`)
- `presentation/screens/calendar_tab.dart` — 일정 탭
- `presentation/widgets/calendar_view.dart` — 월/주 캘린더
- `presentation/widgets/week_timetable_view.dart` — 주간 타임테이블
- `presentation/widgets/day_view.dart`, `year_view.dart` — 일간·연간 뷰
- `presentation/widgets/calendar_search_bar.dart`, `calendar_search_results.dart` — 검색
- `presentation/widgets/quick_task_sheet.dart` — 빠른 등록
- `presentation/widgets/task_list_section.dart`, `task_list_item.dart` — 날짜별 목록

### Task 도메인 (`lib/features/main/task/`)
- `presentation/screens/task_form_screen.dart` + `task_form/` — 등록·수정 폼
- `presentation/screens/task_detail_screen.dart` — 상세
- `presentation/screens/category_management_screen.dart` + `category_management/`
- `presentation/screens/anniversary_list_screen.dart` + `anniversary/`
- `data/models/` — task_model, anniversary_model, holiday_model
- `data/repositories/` — task, anniversary, holiday
- `providers/` — task, task_form, anniversary, holiday

### 공통
- `lib/core/widgets/location_map_view.dart` — 장소 지도 바텀시트
- `lib/core/services/place_search_service.dart` — 카카오 장소 검색
- `lib/core/routes/main_routes.dart` — 라우트 등록

---

## API 문서
[docs/api/tasks.md](../api/tasks.md)

## 패키지
- `table_calendar` — 캘린더 UI
- `kakao_map_plugin` — 장소 지도 (모바일 전용, 웹은 외부 링크)

## 노트
- 백엔드는 일정(Schedule)과 할일(Todo)을 **Task로 통합** 관리합니다.
  `type`으로 구분: CALENDAR_ONLY(캘린더만), TODO_LINKED(양쪽), TODO_ONLY(할일만)
- 하단 네비게이션 탭은 Lazy Loading (방문 시에만 빌드)
- 그룹별 일정·카테고리 분리 관리: 개인(groupId=null) 또는 그룹 선택
- `TaskLocation`은 name만 필수입니다. 앱에서 장소를 고르면 주소·좌표가 모두 채워지지만,
  장소명만 있는 데이터도 들어올 수 있어 나머지는 nullable로 둡니다.
