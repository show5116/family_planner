# 루틴 게이미피케이션 & 확장 기능 — 백엔드 API 제안 문서

> ⚠️ **이 문서는 자동 생성 문서가 아닙니다.** `docs/api/*.md`는 백엔드 코드에서 자동 생성되지만, 이 문서는 프론트엔드 세션에서 사람이 작성한 **제안서**입니다. 실제 구현 여부와 최종 스펙은 백엔드팀 검토 후 확정됩니다.
>
> **작성 배경**: 루틴(습관 관리) 기능 1차 구현 완료 후 UX 강화를 검토하는 과정에서, 참고 서비스(마이루틴 등)와 비교했을 때 동기부여 장치(배지, 랭킹, 알림)가 전무하다는 점이 확인되었습니다. 현재 유일한 동기부여 신호는 홈 위젯의 `🔥 {currentStreakDays}` 텍스트와, 체크 시 스트릭이 갱신될 때 뜨는 축하 스낵바뿐입니다. 이 문서는 백엔드 확장이 필요한 3가지 항목(배지/랭킹보드/알림)의 API 설계 초안과, 즉시 확인이 필요한 기존 API 권한 질문을 정리합니다.

---

## 0. 즉시 확인 요청 — 기존 stats 엔드포인트의 그룹원 접근 권한

**우선순위: 최상 (코드 변경 없이 정책 확인만 필요, 프론트 작업을 막고 있음)**

`docs/api/routines.md` 기준 아래 3개 엔드포인트에는 `/routines/:id`(단건 조회)와 달리 403 케이스가 문서화되어 있지 않습니다.

- `GET /routines/:id/stats/heatmap`
- `GET /routines/:id/stats/streak`
- `GET /routines/:id/stats/rate`

`/routines/:id`는 "본인 또는 공유 그룹원" 접근이 명시(`docs/api/routines.md` 231행)되어 있는데, 위 3개 stats 엔드포인트도 동일 정책(공유 그룹원 접근 허용)인지 확인이 필요합니다.

**질문**: 그룹원 A가 같은 그룹에 공유된 사용자 B의 루틴 `routineId`에 대해 `GET /routines/{routineId}/stats/streak`를 호출하면 200으로 B의 스트릭이 반환되나요, 아니면 403인가요?

**이 답변에 따라 프론트 분기**:
- **200 (접근 허용)**: 그룹원 현황 화면에 각 루틴의 🔥 스트릭 배지를 추가.
- **403 (접근 차단)**: 스트릭 대신 "오늘 체크 완료 인원 / 전체 인원" 같은 집계 형태로 대체(이미 프론트가 가진 `checkedToday` 필드만으로 가능, 백엔드 변경 불필요).

---

## 1. 배지(Badge) 시스템

### 목적
연속 달성/누적 체크 등 마일스톤 달성 시 영구적으로 기록되는 보상 요소. 현재 스트릭은 조회 시점 스냅샷이라 "한때 30일을 달성했었다"는 이력이 남지 않음 — 배지는 이 이력을 영구 저장.

### 스키마 초안

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

## 2. 그룹 랭킹보드 (리더보드)

### 목적
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

## 3. 알림 / 리마인더

### 목적
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

## 4. 우선순위 제안

1. **항목 0 (권한 확인)** — 코드 작업 없음, 가장 먼저 답변 필요
2. **배지 시스템** — 신규 테이블 2개, 프론트 개발 임팩트가 가장 큼(축하 UI와 직결)
3. **그룹 랭킹보드** — 스키마 변경 없이 쿼리만 추가, 상대적으로 저비용
4. **알림/리마인더** — 스케줄러 인프라가 필요해 상대적으로 고비용, 배지/랭킹 이후 진행 권장

---

## 참고: 프론트엔드 현황

- 루틴 기능 문서: [docs/features/23-routine.md](../features/23-routine.md)
- 현재 API 문서: [docs/api/routines.md](../api/routines.md)
- 프론트 담당 모델/프로바이더: `lib/features/main/routine/` (family_planner 저장소)
- 체크 시 스트릭 갱신 여부를 감지해 축하 스낵바를 띄우는 로직: `lib/features/main/routine/providers/routine_provider.dart`의 `RoutineManagementNotifier.toggleCheck` (항목 1의 `newlyEarnedBadges` 필드가 추가되면 이 로직과 자연스럽게 결합 가능)
