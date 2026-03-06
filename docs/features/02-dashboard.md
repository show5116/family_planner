# 2. 메인화면 (대시보드)

## 상태
🟨 진행 중

---

## 기본 구조
- ✅ Bottom Navigation 5개 탭 구조
- ✅ 홈 탭 대시보드 레이아웃
- ✅ 인사말 섹션 (시간대별 메시지)
- ✅ 위젯 기반 커스터마이징 시스템
- ✅ 위젯 설정 화면 (활성화/비활성화, 드래그 순서 변경)
- ✅ 위젯 설정 저장 (SharedPreferences)

## 대시보드 위젯

### 오늘의 일정 (TodayScheduleWidget)
- ✅ UI 구현
- ✅ 실제 데이터 연동 (`dashboardTodayTasksProvider`)
  - 오늘 날짜 범위로 직접 API 조회 (탭 상태와 독립)
  - 카테고리 이모지/색상 표시, 시간 표시, 완료 취소선 처리
  - 캘린더 탭으로 이동 버튼

### 투자 지표 요약 (InvestmentSummaryWidget)
- ✅ UI 구현
- ✅ 실제 데이터 연동 (`bookmarkedIndicatorsProvider`)
  - 즐겨찾기 지표 목록, 스파크라인 차트

### 할일 요약 (TodoSummaryWidget)
- ✅ UI 구현
- ✅ 실제 데이터 연동 (`dashboardTodoTasksProvider`)
  - 할일 탭 UI 상태(필터/정렬/기간)와 완전 독립
  - 오늘 날짜 기준 할일 목록 조회
  - 체크박스로 완료 상태 토글 가능

### 자산 현황 (AssetSummaryWidget)
- ✅ UI 구현
- ✅ 실제 데이터 연동 (`dashboardAssetStatisticsProvider`)
  - 자산 탭 그룹 선택 상태(`assetSelectedGroupIdProvider`) 와 독립
  - 첫 번째 그룹 자동 선택하여 통계 조회
  - `byType` 기반 실제 자산 분포 바 차트

### 고정된 메모 (MemoSummaryWidget) — 신규
- ✅ UI 구현
- ✅ 실제 데이터 연동 (`dashboardMemosProvider` → `pinnedMemosProvider`)
  - 핀 고정된 메모만 표시 (`GET /memos/pinned`)
  - 체크리스트 타입: 완료 항목 수 표시
  - 일반 타입: 내용 미리보기 (마크다운 제거)
  - 핀 없을 때 안내 문구 표시
  - 기본값 비활성화 (위젯 설정에서 직접 켜야 함)

## 대시보드 전용 Provider
- ✅ `lib/features/home/providers/dashboard_provider.dart` 신규 생성
  - `dashboardTodayTasksProvider` — 오늘 일정 (그룹 상태 독립)
  - `dashboardTodoTasksProvider` — 오늘 할일 (탭 UI 상태 독립)
  - `dashboardAssetStatisticsProvider` — 자산 통계 (탭 그룹 상태 독립)
  - `dashboardMemosProvider` — 핀된 메모 (`pinnedMemosProvider` 위임)

## 남은 작업
- ⬜ 대시보드 전체 새로고침 (RefreshIndicator 각 위젯 연동)
- ⬜ 이번 달 지출 위젯
- ⬜ 육아 포인트 위젯
- ⬜ 가족 현황 위젯

---

## 관련 파일
- `lib/features/home/presentation/screens/dashboard_tab.dart`
- `lib/features/home/presentation/widgets/`
- `lib/features/home/providers/dashboard_provider.dart`
- `lib/core/models/dashboard_widget_settings.dart`
- `lib/features/settings/common/presentation/screens/home_widget_settings_screen.dart`
