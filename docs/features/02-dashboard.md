# 2. 메인화면 (대시보드) ✅

## 상태
✅ 완료

---

## 기본 구조
- ✅ Bottom Navigation 5개 탭 구조
- ✅ 홈 탭 대시보드 레이아웃
- ✅ 인사말 섹션 — 사용자가 등록한 "오늘의 한마디" (문구가 없으면 시간대별 메시지로 폴백)
  - 기본 제공 팩 8종을 개별로 켜고 끄기 (총 172문구 × 4개 국어)
    - 나이대별 육아: 아기(0~12개월) 20 · 걸음마(1~3세) 24 · 유아(3~5세) 20 ·
      초등(6~12세) 20 · 청소년(13세~) 20
    - 연령 무관: 부모 마음 20 · 명언과 속담 24 · 응원 한마디 24
    - 출처: CDC Positive Parenting Tips, AAP HealthyChildren.org,
      아동권리보장원 긍정양육 129 원칙의 공개 가이드를 한 줄로 요약
    - 문구 본문은 ARB가 아니라 `lib/core/constants/greeting_presets/`의
      언어별 상수 파일에 둔다 (688개 문자열을 ARB에 넣으면 생성 코드가 과도하게 커짐)
  - 사용자가 직접 문구 등록 (최대 100개, 1건 200자)
  - 날짜를 시드로 뽑아 **하루 동안 같은 문구** 유지, 당겨서 새로고침하면 다음 문구
  - 설정 저장은 기기 로컬(SharedPreferences) — `GreetingSettings`
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

### 내 루틴 (RoutineSummaryWidget)
- ✅ 하나의 키(`routineSummary`)에 뷰 모드 2종 — 카드 헤더 아이콘으로 토글, 선택은 `routineViewMode`로 저장
- ✅ **오늘 뷰** (`routineDailyStreakProvider` + `routineListProvider(null)`)
  - 일일 목표 진행 링(`todayCheckedCount`/`todayTargetCount`) + 연속 달성 일수(🔥)
  - 미체크 → 현재 시간대(`timeFilter`) → 중요도 → 정렬순 우선순위로 최대 3개만 노출, 나머지는 "외 N개"
  - `recordType`이 BOOLEAN이 아니면 체크 전에 값 입력 다이얼로그(`showRoutineCheckValueDialog`) 호출
  - 일시정지(PAUSED)/종료(ENDED) 습관은 후보에서 제외
  - 18시 이후 목표 미달성 + 스트릭 보유 시 끊김 경고 문구 노출
  - 오늘 목표를 다 채우면 리스트 대신 축하 문구로 전환
- ✅ **이번 주 뷰** (`routineOverviewProvider(period: week)`)
  - 7칸 히트맵(일일 목표 달성 여부 기준, 오늘 테두리 강조, 미래일 흐리게)
  - 달성률 % + 일일 목표 달성 일수
  - 아직 못 받은 "연속 달성 N일" 배지까지 남은 일수 (배지 조회 실패 시 조용히 생략)

### 가족 루틴 보드 (RoutineFamilyWidget) — 신규
- ✅ 실제 데이터 연동 (`routineGroupMembersProvider` + `routineChallengesProvider`)
  - 그룹원별 오늘 진행률 바(활성 습관 기준 checked/total), 진행률 순 정렬
  - 오늘 기준 내 순위 표시 (`authProvider.userId`로 본인 식별)
  - 진행 중인 챌린지 1건 — **선택된 그룹이 아니라 내가 속한 모든 그룹**이 대상
    (`GET /routines/challenges/me`). 참여 중인 것 우선, 남은 일수(D-day)와 내 진행률.
    다른 그룹 챌린지면 그룹명을 함께 표시 — 마감 임박한 챌린지를 그룹 전환 없이 보기 위함
  - 그룹이 2개 이상이면 헤더에서 그룹 선택 (`routineFamilySelectedGroupId`로 저장)
  - 공유된 루틴이 없으면 빈 카드 대신 공유 설정 CTA
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

## 위젯 전체 목록 (13종)
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
| 내 루틴 | RoutineSummaryWidget | 오늘 ⇄ 이번 주 토글 (일일 목표 링 + 인라인 체크 / 주간 히트맵) |
| 가족 루틴 보드 | RoutineFamilyWidget | 그룹원별 오늘 진행률 + 진행 중인 챌린지 |

기본 표시: 날씨 · 오늘의 일정 · 내 루틴 · 가계 현황 · 투자 지표 요약 · 육아 포인트

## 공통 동작
- ✅ 대시보드 전체 새로고침 (RefreshIndicator — 알림 개수 재조회 + 오늘의 한마디 다음 문구)
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
- `lib/core/models/greeting_settings.dart`
- `lib/core/providers/greeting_settings_provider.dart`
- `lib/core/constants/greeting_presets.dart` (팩 라벨·아이콘·선택 로직)
- `lib/core/constants/greeting_presets/greeting_preset_{ko,en,ja,zh}.dart` (문구 데이터)
- `lib/features/settings/common/presentation/screens/greeting_settings_screen.dart`
- `lib/features/settings/common/presentation/screens/home_widget_settings_screen.dart`
