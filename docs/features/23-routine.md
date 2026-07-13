# 23. 루틴(습관) 관리 🟨

## 상태
🟨 진행 중 (1차 구현 완료)

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

## 데이터 모델
- ✅ 루틴 모델 (Routine) — title, emoji, color, frequencyType, targetCount, startDate, endDate, isActive, sortOrder, checkedToday
- ✅ 체크 로그 모델 (RoutineLog)
- ✅ 그룹 공유 모델 (RoutineShare)
- ✅ 반복 타입 (RoutineFrequencyType — 1차는 weeklyCount만 사용)
- ✅ 통계 응답 모델 (RoutineHeatmap, RoutineStreak, RoutineRate, RoutineSummaryItem)
- ✅ 그룹원별 루틴 목록 모델 (RoutineGroupMemberRoutines)

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

## 상태 관리
- ✅ RoutineList Provider (@riverpod AsyncNotifier) — 목록 조회, 낙관적 체크/순서변경 반영
- ✅ RoutineDetail Provider (@riverpod AsyncNotifier, family: routineId)
- ✅ routineHeatmapProvider / routineStreakProvider / routineRateProvider (함수형 @riverpod, 파라미터 기반 자동 캐싱)
- ✅ RoutineShares Provider (@riverpod AsyncNotifier, family: routineId)
- ✅ routineGroupMembersProvider(groupId) (함수형 @riverpod)
- ✅ routineSummaryProvider (함수형 @riverpod, 대시보드 위젯용)
- ✅ RoutineManagementNotifier (StateNotifier) — 생성/수정/삭제/순서변경/체크토글/공유관리 통합

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
- 위젯: `lib/features/main/routine/presentation/widgets/` (routine_list_item, routine_heatmap_calendar, routine_streak_card, routine_rate_card, routine_share_group_tile, routine_weekly_strip)
- 홈 대시보드 위젯: `lib/features/home/presentation/widgets/routine_summary_widget.dart`
- 백엔드 API 제안 문서(배지/랭킹보드/알림, 미구현): `docs/api-proposals/routine-gamification.md`

## 노트
- 1차 릴리스는 `frequencyType = WEEKLY_COUNT`(주 N회, 요일 무관)만 지원. `DAILY`/`DAYS_OF_WEEK`는 백엔드 스키마상 확장 여지만 마련됨.
- 체크/체크취소는 낙관적 업데이트로 목록의 `checkedToday`를 즉시 반영하고, 실패 시 서버 재조회로 롤백. 스트릭/달성률 등 파생 통계는 낙관적으로 계산하지 않고 체크 성공 후 해당 provider를 invalidate하여 재조회(계산 로직이 백엔드에 있어 프론트에서 재현하지 않음).
- 히트맵 캘린더는 신규 패키지 추가 없이 기존 `table_calendar`를 재사용해 GitHub 잔디 스타일로 렌더링.
- 그룹 공유는 조회 전용(그룹원은 서로의 루틴/현황을 볼 수만 있고 수정 권한은 없음, 체크는 본인만). 홈 위젯에는 API 특성상 그룹 필터를 두지 않음.
- 더보기 탭/하단 네비게이션 커스터마이징 시스템(`bottom_navigation_settings_provider.dart`)에 `routines` 메뉴로 등록됨 — 하단 네비게이션 슬롯 배치 또는 더보기 탭 메뉴, 홈 대시보드 위젯 총 3가지 경로로 진입 가능.
- 히트맵 강도(GitHub 잔디 스타일 그라데이션)는 "하루 1회 체크" 특성상 일별로는 본질적으로 이진이라 도입하지 않음 — 대신 최근 8주 "주간 목표 달성 여부" 스트립으로 강도 개념을 대체.
- 그룹원 화면에서 다른 사람의 스트릭/달성률(stats 엔드포인트)을 조회할 수 있는지는 백엔드 권한 정책이 문서상 확정되지 않아 이번 스코프에서 보류 — `docs/api-proposals/routine-gamification.md` 0번 항목으로 백엔드에 확인 요청.
- 체크 시 스트릭 갱신 여부를 판단하기 위해 `RoutineManagementNotifier.toggleCheck`가 체크(해제 아님) 성공 시 `routineStreakProvider`를 즉시 재조회(`ref.refresh(...future)`)함 — 기존 invalidate-only 방식보다 응답이 소폭 느려질 수 있음.
