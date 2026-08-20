# 루틴 일일 목표(비율제) — 백엔드 API 제안 문서

> **상태**: ✅ 구현 완료 (백엔드 2026-08-20, 프론트 2026-08-20)
> **작성일**: 2026-08-20
>
> 요청한 5개 항목이 모두 백엔드에 구현되었고 프론트 연동도 마쳤습니다. 최신 API 스펙은 `docs/api/routines.md`(자동 생성)를 참고하세요. 이 문서는 설계 배경과 결정 사항을 남기는 히스토리 문서입니다.
>
> **작성 배경**: 기존 루틴 통계는 "그날 수행 대상인 습관 전부를 체크해야 100%"인 구조였습니다. 습관을 15개 등록한 사용자가 매일 10개씩 꾸준히 수행해도 화면에는 항상 `67%` / `미달성`으로 표시되어, 실제로는 잘 지키고 있는데도 매일 실패 판정을 받았습니다. 습관 개수를 늘릴수록 달성률이 떨어지는 역설이 생겨 중도 포기로 이어지기 쉬웠습니다.
>
> 이를 해결하기 위해 **사용자가 "하루에 몇 개를 하면 성공인지"를 직접 정하는 일일 목표(daily goal)** 개념을 도입했습니다. 15개 중 10개가 목표라면 10개를 채운 날은 그날의 달성률이 100%가 되고, 연속 달성(스트릭)도 이어집니다.

---

## 확정된 설계 결정

| 항목 | 결정 | 배경 |
|---|---|---|
| **적용 범위** | **사용자 전체 1개** (그룹별 목표 없음) | 그룹별로 목표를 나누면 "오늘 성공했나?"를 한눈에 알 수 없음. 단일 목표라야 홈 화면에서 즉시 판단 가능 |
| **목표 기준** | **개수 고정** (비율 자동 환산 없음) | "하루 10개"로 고정. 습관을 20개로 늘려도 목표는 10개 그대로. 비율 고정(70%)이면 습관 추가가 곧 목표 상향이 되어, 새 습관을 만들기 꺼려지는 역효과가 생김 |

> ⚠️ 문서 제목의 "비율제"는 기획 초기 용어입니다. **저장·계산은 전부 "개수(count)" 기준**이며, 비율은 UI 표시용으로만 프론트에서 계산합니다.

---

## 열린 질문에 대한 최종 결정

1. **`routines/settings` 신규 엔드포인트**로 구현됨.
2. **`goalTotalDays`는 "진행 중인 기간은 오늘까지의 경과 일수"**로 확정(프론트 선호안 채택). 주 중간(수요일)에 조회했을 때 남은 4일이 미달성으로 잡혀 달성률이 반토막 나는 문제를 방지.
3. **과거 목표 변경 이력은 보존하는 쪽으로 결정됨** (프론트 선호안이었던 "현재 목표로 일괄 판정"과 다름). `overview` 응답의 `dailyGoalMode`/`dailyGoalCount`는 "조회 기간 마지막 날(`to`) 기준 유효했던" 값입니다.
   - ⚠️ **프론트 주의사항**: 통계 화면에서 목표 개수를 표시할 때는 `routineSettingsProvider`(현재 설정)가 아니라 **반드시 `RoutineOverview.dailyGoalCount`**를 써야 합니다. 그러지 않으면 과거 기간을 볼 때 그 시점의 목표가 아닌 현재 목표로 잘못 표시됩니다.
4. **`ALL` 모드에도 `daily-streak` 제공됨**. `todayTargetCount`가 ALL 모드면 그날 대상 습관 수로 채워지므로, 프론트는 모드 분기 없이 동일하게 표시할 수 있습니다.

---

## 구현된 API

### 1. `GET` / `PATCH` `routines/settings`

```prisma
enum RoutineDailyGoalMode { ALL, COUNT }
```

```json
// GET/PATCH 응답
{
  "dailyGoalMode": "COUNT",   // ALL | COUNT
  "dailyGoalCount": 10        // COUNT 모드일 때만 값 있음, ALL이면 null
}
```

`PATCH` 요청 본문은 두 필드 모두 옵션(부분 업데이트)입니다. **`ALL`로 바꿀 때 `dailyGoalCount`를 생략하면 서버가 기존 값을 유지**하므로, 다시 `COUNT`로 되돌릴 때 직전 목표가 복원됩니다(요청서에 넣었던 UX 제안이 반영됨).

### 2. `GET routines/stats/overview` 확장

기존 필드는 그대로 두고 아래가 추가됨:

```json
{
  "dailyGoalMode": "COUNT",
  "dailyGoalCount": 10,
  "goalAchievedDays": 5,       // 기간 내 목표 달성 일수
  "goalTotalDays": 7,          // 집계 대상 일수(대상 습관 0개인 날 제외, 진행 중인 기간은 오늘까지)
  "goalAchievementRate": 71    // goalAchievedDays / goalTotalDays
}
```

### 3. `heatmap` 배열에 `goalAchieved` 추가

```json
{ "date": "2026-08-17", "checkedCount": 11, "totalCount": 15, "goalAchieved": true }
```

대상 습관이 0개였던 날은 집계 대상이 아니므로 `null`.

### 4. `GET routines/stats/daily-streak`

습관 개별 스트릭(`routines/:id/stats/streak`)과 별개로, **일일 목표 달성 기준의 전체 스트릭**입니다.

```json
{
  "currentStreakDays": 12,
  "longestStreakDays": 34,
  "todayAchieved": true,
  "todayCheckedCount": 11,
  "todayTargetCount": 10,
  "recent14Days": {
    "achievedDays": 11,
    "exceededDays": 10,
    "totalDays": 14,
    "averageCheckedCount": 12
  }
}
```

- 오늘이 아직 미달성이어도 어제까지 연속 달성했다면 `currentStreakDays`는 유지됩니다(낮에 스트릭 0을 보고 그날을 포기하는 것을 방지).
- 대상 습관이 0개였던 날은 스트릭을 끊지 않고 건너뜁니다.

---

## 프론트 구현 내역

| 구성 요소 | 파일 |
|---|---|
| 모델 (`RoutineSettings`, `RoutineDailyStreak`, `RoutineRecent14Days`, `RoutineDailyGoalMode`) | `data/models/routine_model.dart` |
| 레포지토리 (`getSettings`, `updateSettings`, `getDailyStreak`, `UpdateRoutineSettingsDto`) | `data/repositories/routine_repository.dart` |
| Provider (`routineSettingsProvider`, `routineDailyStreakProvider`, `updateSettings`) | `providers/routine_provider.dart` |
| 목표 설정 화면 (모드 선택 + 개수 슬라이더) | `presentation/screens/routine_daily_goal_screen.dart` |
| 오늘의 목표 진행 바 (목표선 + 보너스 구간) | `presentation/widgets/routine_daily_goal_bar.dart` |
| 통계 화면 목표 달성률 카드 | `presentation/widgets/routine_goal_summary_card.dart` |
| 목표 상향/하향 제안 다이얼로그 + 판단 로직 + 쿨다운 | `presentation/widgets/routine_goal_suggestion_dialog.dart` |
| 라우트 `/routines/daily-goal` | `core/routes/app_routes.dart`, `core/routes/main_routes.dart` |

### UX 설계 의도

이 기능의 목적은 "달성률 숫자를 후하게 만드는 것"이 아니라 **사용자가 포기하지 않고 계속 쓰게 만드는 것**입니다. 그래서 다음 장치들을 넣었습니다.

- **목표는 개수로만 노출**: 내부 계산이 어떻든 UI에는 "15개 중 10개"로 표시. "67%가 목표"는 와닿지 않지만 "10개가 목표"는 즉시 이해됨.
- **COUNT 전환 시 기본값 80%**: 처음부터 100%를 요구하지 않음.
- **보너스 구간**: 목표를 채워도 바가 가득 차서 끝나지 않고, 초과분이 금색으로 표시됨 — 목표 달성 후에도 더 하고 싶게.
- **히트맵 목표 달성일 테두리**: 비율제에서는 "전부 채우지 않아도 성공한 날"이 생기는데, 색 농도만으로는 그날이 성공이었는지 알 수 없어 `goalAchieved` 기준 초록 테두리를 추가.
- **시스템이 먼저 목표 조정을 제안**: 최근 14일 중 10일 이상 초과 달성이면 상향 제안, 달성률 30% 미만이면 **하향 제안**. 하향 제안은 포기 방지 장치라 상향만큼 중요함. 거절해도 14일 뒤 다시 물음(`SharedPreferences` 쿨다운).
- **표본 부족 시 제안 안 함**: 집계 대상 일수가 7일 미만이면 판단하지 않음.
