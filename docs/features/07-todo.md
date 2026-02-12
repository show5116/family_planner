# 7. ToDoList 메뉴

## 상태
🟨 진행 중

---

## UI 구현
- ✅ 할일 탭 메인 화면
- ✅ 칸반 보드 뷰 (데스크톱/태블릿 전용)
- ✅ 리스트 뷰
- ✅ 할일 카드 컴포넌트
- ✅ 할일 상세 화면 (TaskFormScreen 재사용)
- ✅ 할일 추가/수정 폼 (TaskFormScreen 재사용)
- ✅ 드래그 앤 드롭 기능 (칸반 보드)
- ✅ 주간 날짜 선택 바 (TodoWeekBar)
- ✅ 뷰 모드 전환 SegmentedButton ([날짜별 보기] / [모아 보기])
- ✅ 모아 보기 - 날짜 섹션별 그룹핑 리스트
- ✅ 상태 드롭다운 (PopupMenuButton - 6가지 상태)
- ✅ 완료 포함 체크박스

## 데이터 모델
- ✅ 할일 모델 (TaskModel 재사용 - 캘린더와 통합)
- ✅ TaskStatus Enum: PENDING, IN_PROGRESS, COMPLETED, HOLD, DROP, FAILED (백엔드 동기화)
- ✅ 우선순위 Enum (긴급/높음/보통/낮음)

## 기능 구현
- ✅ 할일 내용 입력
- ✅ 완료 예정일 설정 (날짜 범위 지원)
- ✅ 우선순위 설정
- ✅ 공유 대상 설정 (그룹 선택)
- ✅ 칸반 보드 레이아웃 (데스크톱/태블릿 전용, 좌우 스크롤)
- ✅ 드래그 앤 드롭으로 상태 변경
- ✅ 칸반/리스트 뷰 전환 (데스크톱만)
- ✅ 상태 드롭다운으로 6가지 상태 변경 (체크박스 대체)
- ✅ 날짜별 보기: 주간 바로 날짜 선택, 해당 날짜 할일만 표시
- ✅ 모아 보기: 전체 할일을 날짜 섹션별로 그룹핑 표시
- ✅ 완료 포함/숨김 필터
- ✅ 모바일 반응형 (모바일에서는 리스트 뷰만 사용, 칸반 숨김)
- ⬜ 할일 필터링 및 정렬 (우선순위/상태별)
- ⬜ 완료된 할일 아카이브

## 할일 상태 (TaskStatus)
- **PENDING** (대기중) - 아직 시작하지 않은 할일
- **IN_PROGRESS** (진행중) - 현재 진행 중인 할일
- **COMPLETED** (완료) - 완료된 할일
- **HOLD** (보류) - 일시 중단된 할일
- **DROP** (드롭) - 포기한 할일
- **FAILED** (실패) - 실패한 할일

## 뷰 모드
- **날짜별 보기**: 주간 바에서 날짜를 선택하여 해당 날짜의 할일만 표시
- **모아 보기**: 전체 할일을 아래 섹션별로 그룹핑하여 표시
  - 지난 할일 (Overdue)
  - 오늘 (Today)
  - 내일 (Tomorrow)
  - 이번 주 (This Week)
  - 다음 주 (Next Week)
  - 그 이후 (Later)
  - 기한 없음 (No Due Date)

## API 연동
- ✅ 할일 목록 조회 API (view: 'todo', 주간 날짜 범위)
- ✅ 모아 보기 전체 할일 조회 API (날짜 제한 없음)
- ✅ 할일 추가 API
- ✅ 할일 수정/삭제 API
- ✅ 할일 상태 변경 API (PATCH /tasks/:id/status)

## 상태 관리
- ✅ TodoTasks Provider (주간 날짜 범위 기반 조회)
- ✅ TodoOverviewTasks Provider (모아 보기용 전체 조회)
- ✅ todoViewModeProvider (날짜별 보기/모아 보기 전환)
- ✅ todoViewTypeProvider (칸반/리스트 전환)
- ✅ todoSelectedDateProvider (선택된 날짜)
- ✅ todoSelectedWeekStartProvider (주간 시작일)
- ✅ showCompletedTodosProvider (완료 항목 표시)
- ✅ todoFilterPriorityProvider (우선순위 필터)

---

## 구현 위치
- `lib/features/main/todo/presentation/screens/todo_tab.dart` - 메인 화면 (뷰 모드 전환, 모아 보기 포함)
- `lib/features/main/todo/presentation/widgets/todo_card.dart` - 칸반 카드
- `lib/features/main/todo/presentation/widgets/todo_kanban_column.dart` - 칸반 컬럼
- `lib/features/main/todo/presentation/widgets/todo_list_item.dart` - 리스트 아이템 (상태 드롭다운)
- `lib/features/main/todo/presentation/widgets/todo_week_bar.dart` - 주간 날짜 선택 바
- `lib/features/main/task/providers/task_provider.dart` - Provider (TodoTasks, TodoOverviewTasks 등)
- `lib/features/main/task/data/models/task_model.dart` - TaskStatus enum

## 노트
- 캘린더와 동일한 Task API 사용 (view: 'todo' 파라미터로 구분)
- 드래그 앤 드롭: Flutter 기본 LongPressDraggable/DragTarget 사용
- 칸반 보드는 데스크톱/태블릿 전용 (좌우 스크롤), 모바일에서는 리스트 뷰만 사용
- TaskStatus 6가지 상태는 백엔드 API와 완전히 동기화됨
- 모아 보기는 클라이언트 사이드에서 날짜 기준 섹션 분류
- 다국어 지원: 한/영/일 (모든 상태명, 섹션명, UI 텍스트)
