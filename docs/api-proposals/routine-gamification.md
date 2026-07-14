# 루틴 게이미피케이션 & 확장 기능 — 백엔드 API 제안 문서

> ✅ **구현 완료 (2026-07-14 기준).** 아래 0~3번 항목 모두 백엔드에서 구현되었고, 프론트에서도 연동을 마쳤습니다. 이 문서는 애초에 사람이 작성한 제안서였으나, 구현이 끝난 지금은 설계 배경과 결정 사항을 기록한 히스토리 문서로 남깁니다. 최신 API 스펙은 `docs/api/routines.md`, `docs/api/notifications.md`(자동 생성)를 참고하세요.
>
> **작성 배경**: 루틴(습관 관리) 기능 1차 구현 완료 후 UX 강화를 검토하는 과정에서, 참고 서비스(마이루틴 등)와 비교했을 때 동기부여 장치(배지, 랭킹, 알림)가 전무하다는 점이 확인되었습니다. 당시 유일한 동기부여 신호는 홈 위젯의 `🔥 {currentStreakDays}` 텍스트와, 체크 시 스트릭이 갱신될 때 뜨는 축하 스낵바뿐이었습니다. 이 문서는 백엔드 확장이 필요한 3가지 항목(배지/랭킹보드/알림)의 API 설계 초안과, 즉시 확인이 필요했던 기존 API 권한 질문을 정리한 것입니다.

---

## 0. ✅ 답변 완료 — 기존 stats 엔드포인트의 그룹원 접근 권한

**결과: 200 (접근 허용).** `/routines/:id/stats/{heatmap,streak,rate}` 세 엔드포인트 모두 `/routines/:id`와 동일한 `findRoutineWithAccess()`를 재사용하므로 공유 그룹원은 200으로 조회 가능합니다. 문서 누락이었을 뿐이며, `docs/api/routines.md`에 403 케이스가 보강되었습니다. 프론트는 그룹원 현황 화면(`routine_group_members_screen.dart`)에 🔥 스트릭 배지를 노출하도록 구현했습니다.

<details>
<summary>원본 질문 (참고용, 접기)</summary>

`docs/api/routines.md` 기준 아래 3개 엔드포인트에는 `/routines/:id`(단건 조회)와 달리 403 케이스가 문서화되어 있지 않습니다.

- `GET /routines/:id/stats/heatmap`
- `GET /routines/:id/stats/streak`
- `GET /routines/:id/stats/rate`

`/routines/:id`는 "본인 또는 공유 그룹원" 접근이 명시(`docs/api/routines.md` 231행)되어 있는데, 위 3개 stats 엔드포인트도 동일 정책(공유 그룹원 접근 허용)인지 확인이 필요합니다.

**질문**: 그룹원 A가 같은 그룹에 공유된 사용자 B의 루틴 `routineId`에 대해 `GET /routines/{routineId}/stats/streak`를 호출하면 200으로 B의 스트릭이 반환되나요, 아니면 403인가요?

**이 답변에 따라 프론트 분기**:
- **200 (접근 허용)**: 그룹원 현황 화면에 각 루틴의 🔥 스트릭 배지를 추가.
- **403 (접근 차단)**: 스트릭 대신 "오늘 체크 완료 인원 / 전체 인원" 같은 집계 형태로 대체(이미 프론트가 가진 `checkedToday` 필드만으로 가능, 백엔드 변경 불필요).

</details>

---

## 1. ✅ 구현 완료 — 배지(Badge) 시스템

**실제 구현 결과**: 제안 스키마와 거의 동일하게 구현됨. 카탈로그 9종(연속 7/30/100일, 연속 4/12/52주, 누적 50/200/500회), `POST /routines/:id/check` 응답에 `newlyEarnedBadges` 필드 포함(제안한 "열린 질문 2"가 그대로 채택됨), 체크 취소해도 획득한 배지는 회수되지 않음. 프론트는 `RoutineBadge`/`UserRoutineBadge` 모델, `routineBadgeCatalogProvider`/`routineMyBadgesProvider`/`routineBadgesProvider`, 내 배지 목록 화면(`routine_badges_screen.dart`), 루틴 상세 배지 탭(`routine_badges_tab.dart`), 축하 다이얼로그(`routine_badge_celebration_dialog.dart`)를 구현.

### 목적 (원안)
연속 달성/누적 체크 등 마일스톤 달성 시 영구적으로 기록되는 보상 요소. 현재 스트릭은 조회 시점 스냅샷이라 "한때 30일을 달성했었다"는 이력이 남지 않음 — 배지는 이 이력을 영구 저장.

### 스키마 초안 (실제 구현과 거의 동일)

```prisma
model RoutineBadge {
  id            String   @id @default(uuid())
  code          String   @unique // 'STREAK_7DAYS', 'STREAK_30DAYS', 'TOTAL_100_CHECKS' 등
  title         String   @db.VarChar(50)
  description   String?  @db.VarChar(200)
  iconEmoji     String?  @db.VarChar(10)
  criteriaType  BadgeCriteriaType
  criteriaValue Int      // 기준값 (예: STREAK_DAYS 타입이면 7)
  createdAt     DateTime @default(now())

  earnedBy UserRoutineBadge[]

  @@map("routine_badges")
}

model UserRoutineBadge {
  id        String   @id @default(uuid())
  userId    String
  badgeId   String
  routineId String?  // 특정 루틴 기준으로 획득했다면 기록, 전체 통산이면 null
  earnedAt  DateTime @default(now())

  user  User         @relation(fields: [userId], references: [id], onDelete: Cascade)
  badge RoutineBadge @relation(fields: [badgeId], references: [id])

  @@unique([userId, badgeId, routineId])
  @@index([userId])
  @@map("user_routine_badges")
}

enum BadgeCriteriaType {
  STREAK_DAYS      // 연속 N일 체크
  STREAK_WEEKS      // 연속 N주 목표 달성
  TOTAL_CHECKS      // 누적 체크 N회
}
```

### 엔드포인트 제안

| Method | Endpoint | 설명 | 권한 |
|---|---|---|---|
| GET | `/routines/badges` | 전체 배지 카탈로그 조회 (마스터 데이터) | JWT |
| GET | `/routines/:id/badges` | 특정 루틴 기준으로 획득한 배지 목록 | JWT, Access |
| GET | `/users/me/routine-badges` | 내가 획득한 전체 배지 목록 (루틴 무관 통산 포함) | JWT |

### 열린 질문 (백엔드 검토 필요)
1. **판정 시점**: 체크(`POST /routines/:id/check`) 성공 직후 서버가 즉시 배지 조건을 계산해 부여하는 방식 vs 별도 배치(스케줄러)로 매일 계산하는 방식. 즉시 판정이 UX상 유리하지만 체크 API 응답 지연 요인이 될 수 있음.
2. **체크 API 응답에 신규 배지 포함 여부**: 즉시 판정이라면 `POST /routines/:id/check` 응답에 `newlyEarnedBadges: RoutineBadge[]` 필드를 추가해 프론트가 별도 조회 없이 축하 UI를 띄울 수 있게 하는 안 제안. (참고: 프론트는 이미 체크 성공 후 스트릭을 재조회해 축하 스낵바를 띄우는 로직이 있어, 이 필드가 추가되면 같은 흐름에 자연스럽게 결합 가능)
3. **배지 카탈로그 초기값**: 최소 제안 — `STREAK_7DAYS`(🔥 7일), `STREAK_30DAYS`(🔥🔥 30일), `STREAK_100DAYS`(🔥🔥🔥 100일), `TOTAL_50_CHECKS`, `TOTAL_200_CHECKS`. 구체적인 값/개수는 백엔드·기획 협의로 확정.

---

## 2. ✅ 구현 완료 — 그룹 랭킹보드 (리더보드)

**실제 구현 결과**: 제안한 엔드포인트/응답 형태 그대로 구현됨. `checkCount`, `achievementRate`가 항상 함께 응답에 포함되어 metric 토글 시 재조회 없이도 정렬 기준만 바꿀 수 있게 설계됨(다만 프론트는 아직 이 최적화를 활용하지 않고 provider 파라미터 변경 시 재조회하는 단순 구현). 집계 대상은 "그룹에 공유한 루틴 소유자만"(열린 질문 1의 옵트인 방식이 채택됨 — `RoutineShare`로 이미 공유 의사를 표현한 사람만 랭킹에 노출). 프론트는 `routine_leaderboard_screen.dart`로 구현, 그룹원 현황 화면에서 진입.

### 목적 (원안)
`docs/api/routines.md`의 "향후 고려" 섹션(203행)에 이미 "그룹 내 랭킹/경쟁(리더보드) API"가 `RoutineLog + RoutineShare` 조인만으로 스키마 변경 없이 확장 가능하다고 명시되어 있음 — 신규 테이블 없이 쿼리만 추가하면 되는 저비용 항목.

### 엔드포인트 제안

```
GET /routines/groups/:groupId/leaderboard?period=week&metric=checkCount
```

**Query Parameters**:
- `period`: `week` | `month` (집계 기간)
- `metric`: `checkCount`(기간 내 총 체크 횟수) | `achievementRate`(평균 달성률) — 정렬 기준

**Response 초안**:
```json
{
  "groupId": "uuid",
  "period": "week",
  "from": "2026-07-07",
  "to": "2026-07-13",
  "rankings": [
    {
      "rank": 1,
      "userId": "uuid",
      "userName": "string",
      "checkCount": 12,
      "achievementRate": 92
    }
  ]
}
```

### 열린 질문
1. **프라이버시**: 그룹원 전원이 자동으로 랭킹에 노출되는 방식 vs 개인이 옵트인해야 노출되는 방식. 강제 노출은 압박감을 줄 수 있어 옵트인 권장(기존 `RoutineShare`가 "루틴 단위 공유"이므로, 랭킹 노출 여부도 루틴 단위로 볼지 사용자 단위로 볼지 정책 필요).
2. **집계 대상**: 공유된 루틴만 집계할지, 그룹원의 비공유 루틴도 익명 집계에 포함할지.

---

## 3. ✅ 구현 완료 — 알림 / 리마인더

**실제 구현 결과**: 제안 1(NotificationCategory에 ROUTINE 추가, routineReminderHour 필드)이 그대로 채택됨. 트리거 3종(`ROUTINE_DAILY_REMINDER`, `ROUTINE_STREAK_MILESTONE`, `ROUTINE_WEEKLY_SUMMARY`, 주간 요약은 일요일 20시 발송)이 백엔드에서 자동 발송되도록 구현됨. 열린 질문 2(그룹원 간 미체크 알림)는 사회적 압박 우려로 이번엔 포함하지 않기로 결정. 프론트는 `NotificationSettingsModel`에 `routineEnabled`/`routineReminderHour` 필드를 추가하고 알림 설정 화면에 토글+시간선택 UI를 연동.

### 목적 (원안)
`docs/api/routines.md`의 "향후 고려" 섹션에 "이번 주 마감 임박 알림(스케줄러 기반)"이 1차 구현 범위 밖으로 명시되어 있었음. 기존 `notifications` 도메인(`docs/api/notifications.md`)이 이미 `NotificationCategory` 기반 구독 설정 시스템(`GET/PUT /notifications/settings`, `weatherAlertHour`처럼 카테고리 전용 필드 지원)을 갖추고 있어, 동일 패턴으로 확장하는 안을 제안합니다.

### 제안 1 — `NotificationCategory`에 `ROUTINE` 추가

기존 `WEATHER` 카테고리가 `weatherAlertHour`(0~23시) 같은 카테고리 전용 필드를 `PUT /notifications/settings`에서 받는 것과 동일한 패턴으로:

```json
// PUT /notifications/settings
{
  "category": "ROUTINE",
  "enabled": true,
  "routineReminderHour": 21 // ROUTINE 카테고리 전용: 미체크 루틴 리마인드 시각 (0~23시)
}
```

### 제안 2 — 알림 트리거 종류

| 트리거 코드 | 발송 조건 | 우선순위 |
|---|---|---|
| `ROUTINE_DAILY_REMINDER` | 설정한 시각까지 오늘 미체크 루틴이 있으면 발송 | 높음 (핵심 리텐션 기능) |
| `ROUTINE_STREAK_MILESTONE` | 배지 획득 시점(항목 1과 연동) | 중간 |
| `ROUTINE_WEEKLY_SUMMARY` | 매주 일요일 저녁, 이번 주 달성률 요약 | 낮음 |

### 열린 질문
1. `ROUTINE_DAILY_REMINDER`는 사용자별 스케줄러 실행이 필요해 인프라 비용이 다른 두 트리거보다 큼 — 우선순위 재조정 필요할 수 있음.
2. 그룹 공유 루틴에 대해 "그룹원이 아직 체크 안 함" 알림을 서로에게 보낼지(사회적 압박 vs 동기부여) — 별도 옵트인 설정으로 분리 제안.

---

## 4. 우선순위 제안 (원안 — 실제로도 이 순서로 진행됨)

1. **항목 0 (권한 확인)** — 코드 작업 없음, 가장 먼저 답변 필요
2. **배지 시스템** — 신규 테이블 2개, 프론트 개발 임팩트가 가장 큼(축하 UI와 직결)
3. **그룹 랭킹보드** — 스키마 변경 없이 쿼리만 추가, 상대적으로 저비용
4. **알림/리마인더** — 스케줄러 인프라가 필요해 상대적으로 고비용, 배지/랭킹 이후 진행 권장

**실제 결과**: 백엔드가 0~3번 전부를 한 번에 완료해서 전달했고, 프론트도 같은 세션에서 배지 → 그룹원 스트릭 노출 → 랭킹보드 → 알림 설정 순으로 이어서 구현했습니다.

---

## 참고: 프론트엔드 구현 현황

- 루틴 기능 문서: [docs/features/23-routine.md](../features/23-routine.md)
- 현재 API 문서: [docs/api/routines.md](../api/routines.md), [docs/api/notifications.md](../api/notifications.md)
- 프론트 담당 모델/프로바이더: `lib/features/main/routine/` (family_planner 저장소)
- 체크 시 스트릭 갱신 및 신규 배지 획득 여부를 판단해 축하 UI를 트리거하는 로직: `lib/features/main/routine/providers/routine_provider.dart`의 `RoutineManagementNotifier.toggleCheck` — `newlyEarnedBadges`가 있으면 축하 다이얼로그(`routine_badge_celebration_dialog.dart`) 우선, 없으면 스트릭 갱신 시 스낵바
- 알림 설정 연동: `lib/features/notification/data/models/notification_settings_model.dart`, `notification_settings_provider.dart`, `notification_settings_section.dart`
