# 23. 루틴(습관) 관리 🟨

## 상태
🟨 진행 중 (1차 구현 + 2차 UX 고도화 + 게이미피케이션(배지/랭킹보드/알림) 구현 완료)

---

## UI 구현
- ✅ 루틴 목록 화면 (오늘 체크 리스트, 드래그 순서 변경, 스와이프 삭제)
- ✅ 루틴 생성/수정 폼 (제목, 이모지, 색상, 주 목표 횟수, 시작일/종료일)
- ✅ 루틴 상세 화면 (히트맵/통계/공유 3탭)
- ✅ 히트맵 캘린더 탭 (월 단위 체크 여부 시각화)
- ✅ 통계 탭 (스트릭 카드 + 기간별 달성률 카드)
- ✅ 공유 그룹 관리 탭 (공유 추가/해제, 그룹원 현황 진입)
- ✅ 그룹원별 공유 루틴 현황 화면 (읽기 전용)
- ✅ 루틴 목록 화면에 "공유 루틴 볼 그룹 선택" 진입점 (내 그룹 선택 → 그룹원 현황 화면 이동, 내 루틴이 없어도 공유받은 그룹의 현황 확인 가능)
- ✅ 홈 대시보드 위젯 (오늘의 루틴 요약 + 인라인 체크 토글)
- ✅ 더보기 탭 / 하단 네비게이션 메뉴 노출
- ✅ 통계 탭 달성률 원형 게이지 (fl_chart, 달성률 구간별 success/warning/error 색상)
- ✅ 스트릭 카드 레이아웃 개선 (현재 연속 일수 하이라이트 승격)
- ✅ 히트맵 탭 주간 목표 달성 스트립 (최근 8주), 시작일 이전 날짜 비활성 표시
- ✅ 그룹원 카드 탭 시 루틴별 상세 바텀시트 드릴다운
- ✅ 체크 시 스트릭 갱신되면 축하 스낵바 + 체크 아이콘 bounce 애니메이션
- ✅ 빈 상태 UI 개선 (AppEmptyState 공용 위젯, CTA 버튼 포함)
- ✅ 내 배지 목록 화면 (전체 카탈로그 + 획득 여부/일자 표시)
- ✅ 루틴 상세 배지 탭 (해당 루틴 기준 획득 배지 목록, 4탭으로 확장: 히트맵/통계/배지/공유)
- ✅ 체크 시 신규 배지 획득하면 축하 다이얼로그 표시 (스트릭 축하 스낵바보다 우선)
- ✅ 그룹원 현황 화면에 루틴별 스트릭 배지(🔥N) 노출
- ✅ 그룹 랭킹보드 화면 (체크 횟수/달성률 기준, 주/월 토글, 그룹원 현황 화면에서 진입)
- ✅ 알림 설정에 루틴 카테고리 추가 (미체크 리마인드 시각 설정)
- ✅ 전 화면 공통 에러 상태(AppErrorState) 적용 — 재시도 버튼으로 즉시 재조회 가능
- ✅ 생성/수정 폼 유효성 검사 보강 (제목 100자 제한, 명확한 에러 메시지, 이모지 필드 도움말)
- ✅ 루틴 목록 화면 첫 진입 코치마크 (루틴 추가 버튼 안내, 1회만 노출)

## 데이터 모델
- ✅ 루틴 모델 (Routine) — title, emoji, color, frequencyType, targetCount, startDate, endDate, isActive, sortOrder, checkedToday
- ✅ 체크 로그 모델 (RoutineLog)
- ✅ 그룹 공유 모델 (RoutineShare)
- ✅ 반복 타입 (RoutineFrequencyType — 1차는 weeklyCount만 사용)
- ✅ 통계 응답 모델 (RoutineHeatmap, RoutineStreak, RoutineRate, RoutineSummaryItem)
- ✅ 그룹원별 루틴 목록 모델 (RoutineGroupMemberRoutines)
- ✅ 배지 모델 (RoutineBadge, UserRoutineBadge, BadgeCriteriaType) — RoutineLog에 newlyEarnedBadges 필드 추가
- ✅ 랭킹보드 모델 (RoutineLeaderboard, LeaderboardEntry, LeaderboardPeriod, LeaderboardMetric)

## 기능 구현
- ✅ 루틴 등록/수정/삭제 (soft delete, 체크 기록은 보존)
- ✅ 순서 일괄 변경 (드래그, 낙관적 반영 + 실패 시 롤백)
- ✅ 체크/체크취소 (낙관적 업데이트, 실패 시 목록 상태 롤백)
- ✅ 그룹 공유 추가/해제 (N:M)
- ✅ 그룹원별 공유 루틴 + 오늘/이번 주 진행 상황 조회
- ✅ 달력 히트맵 (월 이동 시 재조회)
- ✅ 스트릭 조회 (현재/최장, 일 단위 + 주 단위)
- ✅ 기간별 달성률 조회 (주/월 토글)
- ✅ 대시보드 위젯용 전체 루틴 요약 (오늘 체크 + 스트릭 + 이번 주 진행)
- ✅ 배지 카탈로그 조회 및 획득 여부 표시 (연속 7/30/100일, 연속 4/12/52주, 누적 50/200/500회 총 9종)
- ✅ 체크 시 신규 배지 자동 판정 (백엔드가 판정, 체크 응답에 결과 포함)
- ✅ 그룹 랭킹보드 조회 (공유한 루틴 소유자만 집계, 비공유자는 미노출)
- ✅ 루틴 알림 설정 (미체크 리마인드/배지 획득/주간 요약 — 발송 로직은 백엔드 담당)

## API 연동
- ✅ `POST /routines` — 루틴 생성
- ✅ `GET /routines` — 내 루틴 목록
- ✅ `GET /routines/:id` — 루틴 상세
- ✅ `PATCH /routines/:id` — 루틴 수정
- ✅ `DELETE /routines/:id` — 루틴 삭제 (soft delete)
- ✅ `PATCH /routines/sort-order` — 순서 일괄 변경
- ✅ `POST /routines/:id/check` — 체크
- ✅ `DELETE /routines/:id/check` — 체크 취소
- ✅ `POST /routines/:id/shares` — 그룹에 공유
- ✅ `DELETE /routines/:id/shares/:groupId` — 공유 해제
- ✅ `GET /routines/:id/shares` — 공유 그룹 목록
- ✅ `GET /routines/groups/:groupId/members` — 그룹원별 공유 루틴 조회
- ✅ `GET /routines/groups/:groupId/members/:userId` — 특정 그룹원 상세
- ✅ `GET /routines/:id/stats/heatmap` — 달력 히트맵
- ✅ `GET /routines/:id/stats/streak` — 스트릭
- ✅ `GET /routines/:id/stats/rate` — 기간별 달성률
- ✅ `GET /routines/stats/summary` — 대시보드 위젯용 요약
- ✅ `GET /routines/badges` — 전체 배지 카탈로그
- ✅ `GET /routines/me/badges` — 내가 획득한 통산 배지 목록
- ✅ `GET /routines/:id/badges` — 특정 루틴에서 획득한 배지 목록
- ✅ `GET /routines/groups/:groupId/leaderboard` — 그룹 랭킹보드
- ✅ `PUT /notifications/settings` (category: ROUTINE, routineReminderHour) — 루틴 알림 설정

## 상태 관리
- ✅ RoutineList Provider (@riverpod AsyncNotifier) — 목록 조회, 낙관적 체크/순서변경 반영
- ✅ RoutineDetail Provider (@riverpod AsyncNotifier, family: routineId)
- ✅ routineHeatmapProvider / routineStreakProvider / routineRateProvider (함수형 @riverpod, 파라미터 기반 자동 캐싱)
- ✅ RoutineShares Provider (@riverpod AsyncNotifier, family: routineId)
- ✅ routineGroupMembersProvider(groupId) (함수형 @riverpod)
- ✅ routineSummaryProvider (함수형 @riverpod, 대시보드 위젯용)
- ✅ RoutineManagementNotifier (StateNotifier) — 생성/수정/삭제/순서변경/체크토글/공유관리 통합, 체크 시 newlyEarnedBadges 반환
- ✅ routineBadgeCatalogProvider / routineMyBadgesProvider / routineBadgesProvider(routineId) (함수형 @riverpod)
- ✅ routineLeaderboardProvider(groupId, period, metric) (함수형 @riverpod)
- ✅ NotificationSettings Provider(기존) — routineEnabled/routineReminderHour 필드 확장

---

## 관련 파일
- 모델: `lib/features/main/routine/data/models/routine_model.dart`
- 레포지터리+DTO: `lib/features/main/routine/data/repositories/routine_repository.dart`
- 프로바이더: `lib/features/main/routine/providers/routine_provider.dart`
- 목록 화면: `lib/features/main/routine/presentation/screens/routine_list_screen.dart`
- 생성/수정 폼: `lib/features/main/routine/presentation/screens/routine_form_screen.dart`
- 상세 화면(셸): `lib/features/main/routine/presentation/screens/routine_detail_screen.dart`
- 히트맵 탭: `lib/features/main/routine/presentation/screens/routine_heatmap_tab.dart`
- 통계 탭: `lib/features/main/routine/presentation/screens/routine_stats_tab.dart`
- 공유 관리 탭: `lib/features/main/routine/presentation/screens/routine_share_tab.dart`
- 그룹원 현황 화면: `lib/features/main/routine/presentation/screens/routine_group_members_screen.dart`
- 배지 탭: `lib/features/main/routine/presentation/screens/routine_badges_tab.dart`
- 내 배지 목록 화면: `lib/features/main/routine/presentation/screens/routine_badges_screen.dart`
- 랭킹보드 화면: `lib/features/main/routine/presentation/screens/routine_leaderboard_screen.dart`
- 위젯: `lib/features/main/routine/presentation/widgets/` (routine_list_item, routine_heatmap_calendar, routine_streak_card, routine_rate_card, routine_share_group_tile, routine_weekly_strip, routine_badge_celebration_dialog)
- 홈 대시보드 위젯: `lib/features/home/presentation/widgets/routine_summary_widget.dart`
- 알림 설정: `lib/features/notification/data/models/notification_settings_model.dart`, `notification_settings_provider.dart`, `notification_settings_section.dart` (routineEnabled/routineReminderHour 확장)
- 백엔드 API 제안 문서(작성 시점 미구현이었으나 현재 배지/랭킹보드/알림 3종 모두 구현 완료): `docs/api-proposals/routine-gamification.md`
- 목록 온보딩: `lib/features/main/routine/presentation/screens/_routine_list_onboarding.dart`
- 유닛 테스트: `test/features/main/routine/routine_provider_test.dart` (체크 낙관적 업데이트/롤백, 체크취소, 스트릭 갱신 감지, 배지 전달 5건)

## 노트
- 1차 릴리스는 `frequencyType = WEEKLY_COUNT`(주 N회, 요일 무관)만 지원. `DAILY`/`DAYS_OF_WEEK`는 백엔드 스키마상 확장 여지만 마련됨.
- 체크/체크취소는 낙관적 업데이트로 목록의 `checkedToday`를 즉시 반영하고, 실패 시 서버 재조회로 롤백. 스트릭/달성률 등 파생 통계는 낙관적으로 계산하지 않고 체크 성공 후 해당 provider를 invalidate하여 재조회(계산 로직이 백엔드에 있어 프론트에서 재현하지 않음).
- 히트맵 캘린더는 신규 패키지 추가 없이 기존 `table_calendar`를 재사용해 GitHub 잔디 스타일로 렌더링.
- 그룹 공유는 조회 전용(그룹원은 서로의 루틴/현황을 볼 수만 있고 수정 권한은 없음, 체크는 본인만). 홈 위젯에는 API 특성상 그룹 필터를 두지 않음.
- 더보기 탭/하단 네비게이션 커스터마이징 시스템(`bottom_navigation_settings_provider.dart`)에 `routines` 메뉴로 등록됨 — 하단 네비게이션 슬롯 배치 또는 더보기 탭 메뉴, 홈 대시보드 위젯 총 3가지 경로로 진입 가능.
- 히트맵 강도(GitHub 잔디 스타일 그라데이션)는 "하루 1회 체크" 특성상 일별로는 본질적으로 이진이라 도입하지 않음 — 대신 최근 8주 "주간 목표 달성 여부" 스트립으로 강도 개념을 대체.
- 그룹원의 다른 사람 루틴 stats(heatmap/streak/rate) 접근 권한은 백엔드 확인 결과 `/routines/:id`와 동일하게 공유 그룹원에게 200으로 허용됨(문서 누락이었을 뿐, 백엔드에서 403 케이스 보강 완료) — 그룹원 현황 화면에 스트릭 배지(🔥N)를 정상 노출.
- 체크 시 스트릭 갱신 여부를 판단하기 위해 `RoutineManagementNotifier.toggleCheck`가 체크(해제 아님) 성공 시 `routineStreakProvider`를 즉시 재조회(`ref.refresh(...future)`)함 — 기존 invalidate-only 방식보다 응답이 소폭 느려질 수 있음.
- 배지 판정은 전적으로 백엔드가 수행(체크 시점에 즉시 판정). 프론트는 `checkRoutine` 응답의 `newlyEarnedBadges`를 그대로 신뢰해 축하 다이얼로그를 띄우며, 별도 판정 로직을 갖지 않음. 체크 취소해도 이미 획득한 배지는 회수되지 않음(백엔드 정책).
- 축하 UI 우선순위: 배지 획득 > 스트릭 갱신(둘 다 해당되면 배지 다이얼로그만 표시, 스트릭 스낵바는 생략) — 같은 체크 한 번에 두 축하가 동시에 뜨는 것을 방지.
- 랭킹보드는 그룹에 루틴을 공유한 사용자만 집계 대상(비공유 = 참여 안 함 의사표시로 존중, 백엔드 정책). checkCount/achievementRate 둘 다 응답에 항상 포함되므로 프론트에서 metric 토글 시 재조회 없이 정렬 기준만 바꿔도 되지만, 현재 구현은 provider 파라미터 변경으로 재조회하는 단순한 방식을 사용(캐싱 최적화는 후속 과제).
- 그룹원끼리 서로의 미체크를 알리는 알림은 이번 범위에 포함되지 않음(사회적 압박 우려로 백엔드에서 보류 결정).
- 에러 화면은 전부 `lib/shared/widgets/app_error_state.dart`의 `AppErrorState`(다른 기능에서 이미 쓰던 공용 위젯)로 통일 — 함수형 provider는 `ref.invalidate(...)`, AsyncNotifier는 각자의 `refresh()`를 재시도 콜백으로 연결.
- 프로젝트에 mocktail 등 mocking 패키지가 없어, provider 테스트는 `RoutineRepository`를 상속한 Fake 구현체로 `routineRepositoryProvider`를 오버라이드하는 방식을 사용. `RoutineRepository()` 기본 생성자가 `ApiClient.instance`(dotenv 기반 설정)를 초기화하므로, 테스트 `setUpAll`에서 `dotenv.testLoad(fileInput: '')`로 빈 환경을 미리 로드해야 함.
- 온보딩은 루틴 목록 화면(추가 버튼 대상)에만 단일 타겟으로 추가 — child_points처럼 가짜 데이터를 활용한 다단계 데모 온보딩은 이번 스코프에서 제외(실제 데이터가 있는 화면이라 데모 모드 없이도 핵심 개념 안내 목적은 충족).
