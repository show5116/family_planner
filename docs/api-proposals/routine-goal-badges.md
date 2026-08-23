# 배지 체계 개편 — 일일 목표 기준으로 전환 (3차)

> **상태**: ✅ 구현 완료 (백엔드·프론트 2026-08-23)
> **작성일**: 2026-08-23
> **선행 문서**: [routine-gamification.md](routine-gamification.md) (배지 1차 도입), [routine-daily-goal.md](routine-daily-goal.md) (일일 목표 1차), [routine-daily-goal-per-routine.md](routine-daily-goal-per-routine.md) (일일 목표 2차)

---

## 배경 — 습관별 배지의 한계

현재 배지 9종은 **습관 개별 단위**로 부여됩니다(`STREAK_DAYS` 7/30/100일, `STREAK_WEEKS` 4/12/52주, `TOTAL_CHECKS` 50/200/500회). `UserRoutineBadge`에 `routineId`/`routineTitle`이 붙고, `POST /routines/:id/check` 시 그 습관 기준으로 판정합니다.

여기에 세 가지 문제가 있습니다.

**1. 습관 수에 비례해 배지가 쏟아집니다.** 습관 15개 × 9종 = 최대 135개를 받을 수 있습니다. 배지가 흔해지면 보상으로서의 가치가 사라집니다.

**2. 습관을 종료하면 맥락이 사라집니다.** "아침 스트레칭 100일 연속" 배지를 받은 뒤 그 습관을 종료하면, 배지만 남고 무엇에 대한 성취인지 흐려집니다.

**3. 일일 목표 기능과 어긋납니다.** 1·2차 작업으로 "하루 N개 달성"이 이 앱의 핵심 성취 지표가 됐는데, 배지는 여전히 개별 습관만 봅니다. 사용자가 매일 목표를 달성해도 배지는 반응하지 않습니다.

## 방향 — 배지와 통계의 역할 분리

| | 대상 | 노출 위치 |
|---|---|---|
| **배지** | 일일 목표 달성 (전체 습관 합산) | 배지 화면 |
| **통계** | 습관 개별 성취 (연속 일/주/월) | 루틴 상세 통계 탭 |

배지는 "**나**의 성취", 통계는 "**이 습관**의 성취"로 나눕니다. 습관별 연속 기록은 없애는 게 아니라 배지에서 통계로 옮기는 것입니다.

> **출시 전 상태 확인 완료.** 실사용자 데이터가 없어 기존 배지 획득 이력을 삭제해도 영향이 없습니다. 마이그레이션 부담 없이 깔끔하게 교체합니다.

---

## 요청 사항

### 1. 기존 배지 9종 및 획득 이력 완전 삭제

- `RoutineBadge` 카탈로그에서 `STREAK_DAYS_*`, `STREAK_WEEKS_*`, `TOTAL_CHECKS_*` 9종 삭제
- `UserRoutineBadge` 획득 이력 전체 삭제
- `BadgeCriteriaType` enum에서 `STREAK_DAYS` / `STREAK_WEEKS` / `TOTAL_CHECKS` 제거

### 2. 일일 목표 기준 배지 12종 신설

```prisma
enum BadgeCriteriaType {
  GOAL_STREAK_DAYS   // 일일 목표 연속 달성 N일
  GOAL_TOTAL_DAYS    // 일일 목표 누적 달성 N일
  GOAL_PERFECT_WEEK  // 한 주(월~일) 7일 전부 달성한 횟수 N회
}
```

| code | criteriaType | criteriaValue | 제목(안) | 이모지(안) |
|---|---|---|---|---|
| `GOAL_STREAK_3` | `GOAL_STREAK_DAYS` | 3 | 3일 연속 달성 | 🌱 |
| `GOAL_STREAK_7` | `GOAL_STREAK_DAYS` | 7 | 7일 연속 달성 | 🔥 |
| `GOAL_STREAK_14` | `GOAL_STREAK_DAYS` | 14 | 2주 연속 달성 | 🔥 |
| `GOAL_STREAK_30` | `GOAL_STREAK_DAYS` | 30 | 30일 연속 달성 | 🔥🔥 |
| `GOAL_STREAK_100` | `GOAL_STREAK_DAYS` | 100 | 100일 연속 달성 | 🔥🔥🔥 |
| `GOAL_TOTAL_10` | `GOAL_TOTAL_DAYS` | 10 | 누적 10일 달성 | ⭐ |
| `GOAL_TOTAL_50` | `GOAL_TOTAL_DAYS` | 50 | 누적 50일 달성 | ⭐⭐ |
| `GOAL_TOTAL_100` | `GOAL_TOTAL_DAYS` | 100 | 누적 100일 달성 | ⭐⭐⭐ |
| `GOAL_TOTAL_365` | `GOAL_TOTAL_DAYS` | 365 | 누적 365일 달성 | 👑 |
| `GOAL_PERFECT_WEEK_1` | `GOAL_PERFECT_WEEK` | 1 | 완벽한 한 주 | 🏆 |
| `GOAL_PERFECT_WEEK_4` | `GOAL_PERFECT_WEEK` | 4 | 완벽한 4주 | 🏆🏆 |
| `GOAL_PERFECT_WEEK_12` | `GOAL_PERFECT_WEEK` | 12 | 완벽한 12주 | 🏆🏆🏆 |

**설계 의도 (조정 시 참고)**

- **연속 3일을 최소 단위로** 넣었습니다. 기존 최소가 7일이었는데, 습관 형성 초기에 첫 보상까지 일주일은 너무 멉니다. 시작 사흘 만에 받는 첫 배지가 초기 이탈을 크게 줄입니다.
- **누적(`GOAL_TOTAL_DAYS`)을 함께 둔 이유**는 연속이 한 번 끊겨도 보상받을 길을 남기기 위함입니다. 연속만 있으면 하루 실패했을 때 "이번 달은 글렀다"는 심리로 이어집니다.
- 제목/이모지는 제안일 뿐이니 백엔드·기획 판단으로 조정해도 됩니다.

### 3. 배지 판정 기준

기존에는 `POST /routines/:id/check` 시점에 그 습관 기준으로 판정했습니다. 이제는 **일일 목표 달성 여부가 바뀌는 시점**에 사용자 단위로 판정해야 합니다.

- 판정 데이터는 이미 `GET routines/stats/daily-streak`이 계산하고 있는 값과 동일합니다:
  - `GOAL_STREAK_DAYS` → `currentStreakDays`
  - `GOAL_TOTAL_DAYS` → 목표를 달성한 날의 누적 수 (신규 집계 필요)
  - `GOAL_PERFECT_WEEK` → 월~일 7일 모두 달성한 주의 누적 수 (신규 집계 필요)
- **`includeInDailyGoal = false`인 습관은 판정에서 제외**됩니다(2차 문서 규칙과 동일).
- `dailyGoalMode`가 `ALL`이든 `COUNT`든 "그날 목표를 달성했는가"만 보면 되므로 모드 분기는 불필요합니다.

**응답 필드는 기존 그대로 유지**해 주세요. `POST /routines/:id/check` 응답의 `newlyEarnedBadges`를 그대로 씁니다 — 체크 한 번으로 일일 목표가 달성되면서 배지가 나오는 흐름이라, 프론트의 축하 다이얼로그가 수정 없이 동작합니다.

> ⚠️ 다만 이제 배지는 사용자 단위이므로, 같은 체크로 **여러 습관에서 중복 부여되면 안 됩니다.** `UserRoutineBadge`의 unique 제약이 `(userId, badgeId, routineId)`인데 `routineId`가 null이 되므로, `(userId, badgeId)` 기준 유니크로 바꿔야 할 수 있습니다. 이 부분 확인 부탁드립니다.

### 4. `UserRoutineBadge.routineId` / `routineTitle` 처리

배지가 사용자 단위가 되면서 이 두 필드는 항상 null이 됩니다.

- **프론트 선호: 필드를 응답에서 제거**하고 `GET /routines/:id/badges`(루틴별 배지 조회) 엔드포인트도 삭제. 쓰이지 않는 필드가 남아 있으면 나중에 혼란을 만듭니다.
- 다만 제거가 번거로우면 null로 남겨두셔도 프론트는 동작합니다. 백엔드 판단에 맡기겠습니다.

### 5. `GET routines/:id/stats/streak`에 월 단위 지표 추가

습관별 성취를 배지에서 통계로 옮기므로, 통계 쪽을 보강해야 합니다.

현재 응답에 `currentStreakDays` / `longestStreakDays` / `currentStreakWeeks` / `longestStreakWeeks`가 있는데, **`frequencyType=MONTHLY`인 습관은 "주 단위 연속"이 의미가 없습니다.** 현재 프론트 화면에 무의미한 0이 표시되고 있습니다.

```json
{
  "routineId": "",
  "currentStreakWeeks": 0,
  "longestStreakWeeks": 0,
  "currentStreakDays": 0,
  "longestStreakDays": 0,

  // ▼ 신규 (frequencyType=MONTHLY 습관용)
  "currentStreakMonths": 0,   // 월 목표를 연속 달성한 개월 수 (number)
  "longestStreakMonths": 0,   // 최장 연속 달성 개월 수 (number)

  "thisWeekProgress": { "checked": 0, "target": 0 }
}
```

- MONTHLY가 아닌 습관은 0으로 내려주시면 됩니다(프론트에서 주기에 따라 표시할 지표를 고릅니다).
- 반대로 MONTHLY 습관의 `*Weeks` 값도 0이면 프론트가 자연스럽게 숨길 수 있습니다.

---

## 열린 질문에 대한 결정

1·2번(완벽한 주 정의, 누적 소급 집계)은 백엔드 구현으로 확정되었다. 문서상 별도 명시가 없으므로 서버 판정을 그대로 신뢰한다.
3번(설정 변경 시 배지 판정)은 **체크 시점만 처리**하는 것으로 결정됐다 — `PATCH routines/settings` 응답에 `newlyEarnedBadges`가 없다. 목표를 낮춰 즉시 달성 상태가 되어도 배지는 다음 체크 때 부여된다.

<details>
<summary>원본 질문 (참고용, 접기)</summary>

## 열린 질문

1. **`GOAL_PERFECT_WEEK`의 "완벽한 주" 정의**를 확인하고 싶습니다. 프론트 가정은 **월~일 7일 모두 일일 목표를 달성한 주**입니다. 다만 2차 문서에서 정한 규칙상 "대상 습관이 0개인 날"은 집계에서 제외되는데, 그런 날이 낀 주는 어떻게 볼까요?
   - **프론트 선호**: 집계 대상 일수가 7일 미만인 주는 완벽한 주로 치지 않는다(그래야 "7일 다 했다"는 의미가 유지됨).

2. **`GOAL_TOTAL_DAYS` 집계 시작 시점**입니다. 일일 목표 기능이 도입되기 전의 과거 기록도 소급해서 세나요, 아니면 기능 도입 이후부터 세나요?
   - **프론트 선호**: 소급 집계. 과거 데이터로도 계산 가능하다면 사용자가 기능 도입 즉시 배지를 몇 개 받게 되어 첫인상이 좋습니다. 계산 부담이 크면 도입 이후부터도 무방합니다.

3. **배지 판정 트리거**를 체크 시점(`POST /check`)만으로 충분한지 확인 부탁드립니다. 예를 들어 사용자가 일일 목표 개수를 **낮춰서** 이미 달성 상태가 되는 경우(`PATCH routines/settings`), 그 시점에도 배지 판정이 필요할 수 있습니다.
   - 이 경우까지 처리하려면 `PATCH routines/settings`와 `PATCH routines/daily-goal-inclusions` 응답에도 `newlyEarnedBadges`를 넣어야 합니다. 과한 것 같으면 체크 시점만 처리해도 프론트는 대응 가능합니다.

---

</details>

## 프론트 구현 내역

1. ✅ `BadgeCriteriaType` enum 교체 (`goalStreakDays` / `goalTotalDays` / `goalPerfectWeek`)
2. ✅ `UserRoutineBadge`에서 `routineId`/`routineTitle` 제거, 배지 탭 파일 삭제 및 상세 화면 탭 4개 → 3개
3. ✅ `RoutineStreakCard`에 `frequencyType` 전달 — MONTHLY 습관은 "연속 주" 대신 "연속 달"과 "이번 달 진행"을 표시
4. ✅ 배지 화면 상단에 "오늘의 목표를 달성하며 모은 배지예요" 안내 추가
5. ✅ l10n 4개 언어 키 추가(월 지표·배지 안내), 미사용 `routine_tab_badges` 제거
