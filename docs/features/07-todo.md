# 7. ToDoList 메뉴

## 상태
🟨 진행 중

---

## UI 구현
- ✅ 할일 탭 플레이스홀더 화면
- ✅ 칸반 보드 뷰
- ✅ 리스트 뷰
- ✅ 할일 카드 컴포넌트
- ✅ 할일 상세 화면 (TaskFormScreen 재사용)
- ✅ 할일 추가/수정 폼 (TaskFormScreen 재사용)
- ✅ 드래그 앤 드롭 기능

## 데이터 모델
- ✅ 할일 모델 (TaskModel 재사용 - 캘린더와 통합)
- ✅ 할일 상태: 진행중/완료 (isCompleted 기반)
- ✅ 우선순위 Enum (긴급/높음/보통/낮음)

## 기능 구현
- ✅ 할일 내용 입력
- ✅ 완료 예정일 설정
- ✅ 우선순위 설정
- ✅ 공유 대상 설정 (그룹 선택)
- ✅ 칸반 보드 레이아웃
- ✅ 드래그 앤 드롭으로 상태 변경
- ✅ 리스트 뷰 전환
- ⬜ 할일 필터링 및 정렬
- ⬜ 완료된 할일 아카이브

## 할일 상태
- 진행 중 (isCompleted = false)
- 완료 (isCompleted = true)

> 참고: 백엔드 API에서 현재 등록/Drop/Hold 상태를 지원하지 않음
> 향후 API 확장 시 상태 추가 가능

## API 연동
- ✅ 할일 목록 조회 API (view: 'todo')
- ✅ 할일 추가 API
- ✅ 할일 수정/삭제 API
- ✅ 할일 상태 변경 API (toggleComplete)

## 상태 관리
- ✅ TodoTasks Provider 구현
- ✅ todoViewTypeProvider (칸반/리스트 전환)
- ✅ showCompletedTodosProvider (완료 항목 표시)
- ✅ todoFilterPriorityProvider (우선순위 필터)

---

## 구현 위치
- `lib/features/main/todo/presentation/screens/todo_tab.dart` - 메인 화면
- `lib/features/main/todo/presentation/widgets/todo_card.dart` - 칸반 카드
- `lib/features/main/todo/presentation/widgets/todo_kanban_column.dart` - 칸반 컬럼
- `lib/features/main/todo/presentation/widgets/todo_list_item.dart` - 리스트 아이템
- `lib/features/main/task/providers/task_provider.dart` - TodoTasks Provider

## 노트
- 캘린더와 동일한 Task API 사용 (view: 'todo' 파라미터로 구분)
- 드래그 앤 드롭: Flutter 기본 LongPressDraggable/DragTarget 사용
- 칸반 보드는 좌우 스크롤, 리스트 뷰는 섹션별 그룹핑
