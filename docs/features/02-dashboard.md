# 2. 메인화면 (대시보드) ✅

## 상태
✅ 완료

---

## 기본 구조
- ✅ Bottom Navigation 5개 탭 구조
- ✅ 홈 탭 대시보드 레이아웃
- ✅ 인사말 섹션 (시간대별 메시지)
- ✅ 위젯 기반 커스터마이징 시스템
- ✅ 위젯 설정 화면 (활성화/비활성화, 드래그 순서 변경)
- ✅ 위젯 설정 저장 (SharedPreferences) — `DashboardWidgetSettings`
  - `widgetOrder`로 표시 위젯과 순서를 함께 관리
  - 위젯별 그룹 선택·보기 모드도 함께 저장

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
`lib/features/home/providers/dashboard_provider.dart` — 각 탭의 UI 상태와 **독립적으로**
조회해, 탭에서 필터를 바꿔도 대시보드가 흔들리지 않게 합니다. 5분 캐시(keepAlive + Timer).
- `dashboardTodayTasksProvider` — 오늘/금주/이번달 일정
- `dashboardTodoTasksProvider` — 할일
- `dashboardAssetStatisticsProvider` — 자산 통계
- `dashboardHouseholdStatisticsProvider` — 가계 통계
- `dashboardMemosProvider` — 핀된 메모
- `dashboardSavingsProvider` — 저금통 목표
- `dashboardWidgetSyncProvider` — OS 홈 위젯 데이터 동기화

## 위젯 전체 목록 (12종)
| 위젯 | 클래스 | 표시 내용 |
|---|---|---|
| 날씨 | WeatherWidget | 현재 위치 날씨·미세먼지 |
| 오늘의 일정 | TodayScheduleWidget | 오늘/금주/이번달 일정 |
| 할일 요약 | TodoSummaryWidget | 진행 중인 할일 |
| 가계 현황 | HouseholdSummaryWidget | 이번 달 입금·지출·잔액, 예산 달성률 |
| 투자 지표 요약 | InvestmentSummaryWidget | 즐겨찾기 지표 시세·등락 |
| 자산 요약 | AssetSummaryWidget | 총 자산과 수익률 |
| 메모 요약 | MemoSummaryWidget | 핀 고정 메모 |
| 육아 포인트 | ChildcareSummaryWidget | 자녀별 포인트 잔액 |
| 저금통 | SavingsSummaryWidget | 그룹별 적립 목표·달성률 |
| 유통기한 임박 | FridgeExpiryWidget | 냉장고 임박 식품 |
| 기념일 | AnniversarySummaryWidget | 다가오는 기념일과 D-day |
| 오늘의 루틴 | RoutineSummaryWidget | 오늘 해야 할 루틴 (인라인 체크) |

기본 표시: 날씨 · 오늘의 일정 · 가계 현황 · 투자 지표 요약 · 육아 포인트

## 공통 동작
- ✅ 대시보드 전체 새로고침 (RefreshIndicator — 알림 개수 재조회)
- ✅ 카드 탭 시 해당 메뉴로 이동, `전체보기` 버튼도 동일
- ✅ 그룹·기간 필터 (일정·할일·가계·자산·메모·육아·저금통·냉장고 위젯)
  - ScheduleFilterSheet — 기간(오늘/금주/이번달), 개인 일정 포함, 볼 그룹 선택
  - 선택한 조건은 위젯 설정에 저장되어 다음 실행에도 유지
- ✅ 무료 사용 시 위젯 사이에 배너 광고 삽입 (2번째 위젯 뒤)
- ✅ 2주 무료 체험 배너 (체험 기간에만 표시, 탭 시 구독 화면)
- ✅ 알림 종 아이콘 + 읽지 않은 개수 배지, 팝업 카드
- ✅ 앱바 더보기 메뉴 (AI 어시스턴트 / 튜토리얼 다시 보기 / 사용 가이드)
- ✅ 표시 중인 위젯이 없으면 안내 + 위젯 설정 이동 버튼
- ✅ OS 홈 화면 위젯 데이터 동기화 (dashboardWidgetSyncProvider)

---

## 관련 파일
- `lib/features/home/presentation/screens/dashboard_tab.dart`
- `lib/features/home/presentation/widgets/`
- `lib/features/home/providers/dashboard_provider.dart`
- `lib/core/models/dashboard_widget_settings.dart`
- `lib/features/settings/common/presentation/screens/home_widget_settings_screen.dart`
