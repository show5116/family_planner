# 반복 일정 규칙 설정 가이드

프론트엔드에서 반복 일정을 생성할 때 `ruleConfig` 필드에 전달해야 하는 데이터 형식을 설명합니다.

## 목차
- [공통 필드](#공통-필드)
- [DAILY (매일 반복)](#daily-매일-반복)
- [WEEKLY (매주 반복)](#weekly-매주-반복)
- [MONTHLY (매월 반복)](#monthly-매월-반복)
- [YEARLY (매년 반복)](#yearly-매년-반복)
- [종료 조건](#종료-조건)
- [예제 시나리오](#예제-시나리오)

---

## 공통 필드

모든 반복 규칙에는 다음 공통 필드가 포함됩니다:

| 필드 | 타입 | 필수 | 설명 |
|------|------|------|------|
| `interval` | number | O | 반복 간격 (1 = 매번, 2 = 격일/격주/격월 등) |
| `endType` | string | O | 종료 조건: `"NEVER"`, `"DATE"`, `"COUNT"` |
| `endDate` | string | △ | 종료 날짜 (endType이 `"DATE"`인 경우 필수, ISO 형식) |
| `count` | number | △ | 반복 횟수 (endType이 `"COUNT"`인 경우 필수) |

> **주의**: `generatedCount`는 서버에서 자동 관리하므로 프론트엔드에서 전송하지 않습니다.

---

## DAILY (매일 반복)

가장 간단한 형태로, 공통 필드만 사용합니다.

### 예제: 매일 반복 (종료 없음)
```json
{
  "ruleType": "DAILY",
  "ruleConfig": {
    "interval": 1,
    "endType": "NEVER"
  }
}
```

### 예제: 격일 반복 (3일마다)
```json
{
  "ruleType": "DAILY",
  "ruleConfig": {
    "interval": 3,
    "endType": "NEVER"
  }
}
```

### 예제: 매일 반복, 10회 후 종료
```json
{
  "ruleType": "DAILY",
  "ruleConfig": {
    "interval": 1,
    "endType": "COUNT",
    "count": 10
  }
}
```

---

## WEEKLY (매주 반복)

특정 요일에 반복합니다.

### 추가 필드

| 필드 | 타입 | 필수 | 설명 |
|------|------|------|------|
| `daysOfWeek` | number[] | O | 반복할 요일 배열 |

### 요일 코드

| 값 | 요일 |
|----|------|
| 0 | 일요일 |
| 1 | 월요일 |
| 2 | 화요일 |
| 3 | 수요일 |
| 4 | 목요일 |
| 5 | 금요일 |
| 6 | 토요일 |

### 예제: 매주 월/수/금 반복
```json
{
  "ruleType": "WEEKLY",
  "ruleConfig": {
    "interval": 1,
    "endType": "NEVER",
    "daysOfWeek": [1, 3, 5]
  }
}
```

### 예제: 격주 화요일 반복
```json
{
  "ruleType": "WEEKLY",
  "ruleConfig": {
    "interval": 2,
    "endType": "NEVER",
    "daysOfWeek": [2]
  }
}
```

### 예제: 매주 주말(토/일), 2025년 말까지
```json
{
  "ruleType": "WEEKLY",
  "ruleConfig": {
    "interval": 1,
    "endType": "DATE",
    "endDate": "2025-12-31",
    "daysOfWeek": [0, 6]
  }
}
```

---

## MONTHLY (매월 반복)

두 가지 방식을 지원합니다:
1. **날짜 기준**: 매월 15일
2. **요일 기준**: 매월 첫 번째 월요일

### 추가 필드

| 필드 | 타입 | 필수 | 설명 |
|------|------|------|------|
| `monthlyType` | string | O | `"dayOfMonth"` 또는 `"weekOfMonth"` |
| `dayOfMonth` | number | △ | 날짜 (1-31), monthlyType이 `"dayOfMonth"`인 경우 |
| `weekOfMonth` | number | △ | 주차 (1-5), monthlyType이 `"weekOfMonth"`인 경우 |
| `dayOfWeek` | number | △ | 요일 (0-6), monthlyType이 `"weekOfMonth"`인 경우 |

### 주차 코드

| 값 | 의미 |
|----|------|
| 1 | 첫째 주 |
| 2 | 둘째 주 |
| 3 | 셋째 주 |
| 4 | 넷째 주 |
| 5 | 마지막 주 |

### 예제: 매월 15일 반복
```json
{
  "ruleType": "MONTHLY",
  "ruleConfig": {
    "interval": 1,
    "endType": "NEVER",
    "monthlyType": "dayOfMonth",
    "dayOfMonth": 15
  }
}
```

### 예제: 격월 말일(31일) 반복
```json
{
  "ruleType": "MONTHLY",
  "ruleConfig": {
    "interval": 2,
    "endType": "NEVER",
    "monthlyType": "dayOfMonth",
    "dayOfMonth": 31
  }
}
```
> **참고**: 31일이 없는 달(2월, 4월 등)에는 자동으로 해당 월의 마지막 날로 조정됩니다.

### 예제: 매월 첫 번째 월요일 반복
```json
{
  "ruleType": "MONTHLY",
  "ruleConfig": {
    "interval": 1,
    "endType": "NEVER",
    "monthlyType": "weekOfMonth",
    "weekOfMonth": 1,
    "dayOfWeek": 1
  }
}
```

### 예제: 매월 마지막 금요일 반복
```json
{
  "ruleType": "MONTHLY",
  "ruleConfig": {
    "interval": 1,
    "endType": "NEVER",
    "monthlyType": "weekOfMonth",
    "weekOfMonth": 5,
    "dayOfWeek": 5
  }
}
```

---

## YEARLY (매년 반복)

두 가지 방식을 지원합니다:
1. **날짜 기준**: 매년 12월 25일 (크리스마스)
2. **요일 기준**: 매년 5월 둘째 주 일요일 (어버이날)

### 추가 필드

| 필드 | 타입 | 필수 | 설명 |
|------|------|------|------|
| `month` | number | O | 월 (1-12) |
| `yearlyType` | string | △ | `"dayOfMonth"` 또는 `"weekOfMonth"` (기본값: `"dayOfMonth"`) |
| `dayOfMonth` | number | △ | 날짜 (1-31), yearlyType이 `"dayOfMonth"`인 경우 |
| `weekOfMonth` | number | △ | 주차 (1-5), yearlyType이 `"weekOfMonth"`인 경우 |
| `dayOfWeek` | number | △ | 요일 (0-6), yearlyType이 `"weekOfMonth"`인 경우 |

### 예제: 매년 12월 25일 (크리스마스)
```json
{
  "ruleType": "YEARLY",
  "ruleConfig": {
    "interval": 1,
    "endType": "NEVER",
    "month": 12,
    "yearlyType": "dayOfMonth",
    "dayOfMonth": 25
  }
}
```

### 예제: 매년 2월 29일 (윤년 생일)
```json
{
  "ruleType": "YEARLY",
  "ruleConfig": {
    "interval": 1,
    "endType": "NEVER",
    "month": 2,
    "yearlyType": "dayOfMonth",
    "dayOfMonth": 29
  }
}
```
> **참고**: 윤년이 아닌 해에는 2월 28일로 자동 조정됩니다.

### 예제: 매년 5월 둘째 주 일요일 (어버이날 스타일)
```json
{
  "ruleType": "YEARLY",
  "ruleConfig": {
    "interval": 1,
    "endType": "NEVER",
    "month": 5,
    "yearlyType": "weekOfMonth",
    "weekOfMonth": 2,
    "dayOfWeek": 0
  }
}
```

### 예제: 매년 11월 넷째 주 목요일 (미국 추수감사절)
```json
{
  "ruleType": "YEARLY",
  "ruleConfig": {
    "interval": 1,
    "endType": "NEVER",
    "month": 11,
    "yearlyType": "weekOfMonth",
    "weekOfMonth": 4,
    "dayOfWeek": 4
  }
}
```

---

## 종료 조건

### NEVER: 종료 없음
```json
{
  "endType": "NEVER"
}
```

### DATE: 특정 날짜까지
```json
{
  "endType": "DATE",
  "endDate": "2025-12-31"
}
```

### COUNT: 지정 횟수만큼
```json
{
  "endType": "COUNT",
  "count": 10
}
```

---

## 예제 시나리오

### 시나리오 1: 매일 아침 운동 (3개월간)
```json
{
  "title": "아침 운동",
  "scheduledAt": "2025-01-01T07:00:00Z",
  "recurring": {
    "ruleType": "DAILY",
    "generationType": "AUTO_SCHEDULER",
    "ruleConfig": {
      "interval": 1,
      "endType": "DATE",
      "endDate": "2025-03-31"
    }
  }
}
```

### 시나리오 2: 주 3회 영어 수업 (총 24회)
```json
{
  "title": "영어 수업",
  "scheduledAt": "2025-01-06T19:00:00Z",
  "recurring": {
    "ruleType": "WEEKLY",
    "generationType": "AUTO_SCHEDULER",
    "ruleConfig": {
      "interval": 1,
      "endType": "COUNT",
      "count": 24,
      "daysOfWeek": [1, 3, 5]
    }
  }
}
```

### 시나리오 3: 월급일 알림 (매월 25일)
```json
{
  "title": "월급일",
  "scheduledAt": "2025-01-25T09:00:00Z",
  "recurring": {
    "ruleType": "MONTHLY",
    "generationType": "AUTO_SCHEDULER",
    "ruleConfig": {
      "interval": 1,
      "endType": "NEVER",
      "monthlyType": "dayOfMonth",
      "dayOfMonth": 25
    }
  }
}
```

### 시나리오 4: 월례 회의 (매월 첫 번째 월요일)
```json
{
  "title": "월례 회의",
  "scheduledAt": "2025-01-06T10:00:00Z",
  "groupId": "group-uuid",
  "recurring": {
    "ruleType": "MONTHLY",
    "generationType": "AUTO_SCHEDULER",
    "ruleConfig": {
      "interval": 1,
      "endType": "NEVER",
      "monthlyType": "weekOfMonth",
      "weekOfMonth": 1,
      "dayOfWeek": 1
    }
  },
  "participantIds": ["user-1", "user-2", "user-3"]
}
```

### 시나리오 5: 결혼기념일 (매년 6월 15일)
```json
{
  "title": "결혼기념일",
  "scheduledAt": "2025-06-15T00:00:00Z",
  "recurring": {
    "ruleType": "YEARLY",
    "generationType": "AUTO_SCHEDULER",
    "ruleConfig": {
      "interval": 1,
      "endType": "NEVER",
      "month": 6,
      "yearlyType": "dayOfMonth",
      "dayOfMonth": 15
    }
  }
}
```

### 시나리오 6: 약 복용 후 다음 복용 (완료 후 3일 뒤)
```json
{
  "title": "약 복용",
  "scheduledAt": "2025-01-01T08:00:00Z",
  "recurring": {
    "ruleType": "DAILY",
    "generationType": "AFTER_COMPLETION",
    "ruleConfig": {
      "interval": 3,
      "endType": "COUNT",
      "count": 10
    }
  }
}
```
> **참고**: `generationType: "AFTER_COMPLETION"`은 Task 완료 시 자동으로 다음 Task가 생성됩니다.

---

## generationType 설명

| 값 | 설명 |
|----|------|
| `AUTO_SCHEDULER` | 스케줄러가 자동으로 미래 일정 생성 (기본값) |
| `AFTER_COMPLETION` | Task 완료 후 다음 일정 생성 (약 복용 등에 적합) |

---

## 주의사항

1. **월말 처리**: 31일로 설정했는데 해당 월에 31일이 없으면, 해당 월의 마지막 날로 자동 조정됩니다.
   - 예: 1월 31일 → 2월 28일(또는 29일) → 3월 31일

2. **윤년 처리**: 2월 29일로 설정했는데 윤년이 아니면, 2월 28일로 자동 조정됩니다.

3. **interval 최소값**: interval은 최소 1 이상이어야 합니다. 0이나 음수는 자동으로 1로 보정됩니다.

4. **요일 코드**: JavaScript Date 표준을 따릅니다 (일요일 = 0, 토요일 = 6).

5. **시간대**: 서버는 `scheduledAt`의 시간 정보를 기준으로 반복 일정의 시간을 설정합니다.
