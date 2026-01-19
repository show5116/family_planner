# 알림 클릭 시 화면 이동 스펙

> 프론트엔드에서 알림 클릭 시 해당 화면으로 이동하기 위한 백엔드 데이터 스펙입니다.

## 개요

알림을 클릭하면 해당 컨텐츠의 상세 화면으로 이동합니다. 이를 위해 백엔드에서 알림 전송 시 `data` 필드에 라우팅 정보를 포함해야 합니다.

## 데이터 구조

### 기본 알림 응답 구조

```json
{
  "id": "uuid",
  "userId": "uuid",
  "category": "SCHEDULE",
  "title": "알림 제목",
  "body": "알림 내용",
  "data": {
    "category": "SCHEDULE",
    "<entityId>": "uuid"
  },
  "isRead": false,
  "sentAt": "2025-12-27T00:00:00Z",
  "readAt": null
}
```

### 필수 필드

| 필드 | 타입 | 설명 |
|------|------|------|
| `category` | string | 알림 카테고리 (data 내부에도 포함 권장) |
| `<entityId>` | string | 카테고리별 엔티티 ID (아래 표 참조) |

## 카테고리별 data 필드 스펙

### 1. SCHEDULE (일정)

```json
{
  "category": "SCHEDULE",
  "scheduleId": "550e8400-e29b-41d4-a716-446655440001"
}
```

**이동 화면**: `/calendar/detail?id={scheduleId}`

---

### 2. TODO (할 일)

```json
{
  "category": "TODO",
  "todoId": "550e8400-e29b-41d4-a716-446655440002"
}
```

**이동 화면**: `/todo/detail?id={todoId}`

---

### 3. HOUSEHOLD (가계부)

```json
{
  "category": "HOUSEHOLD",
  "householdId": "550e8400-e29b-41d4-a716-446655440003"
}
```

**이동 화면**: `/household/detail?id={householdId}`

---

### 4. ASSET (자산)

```json
{
  "category": "ASSET",
  "assetId": "550e8400-e29b-41d4-a716-446655440004"
}
```

**이동 화면**: `/assets/detail?id={assetId}`

---

### 5. CHILDCARE (육아/자녀 포인트)

```json
{
  "category": "CHILDCARE",
  "childId": "550e8400-e29b-41d4-a716-446655440005"
}
```

**이동 화면**: `/child-points/detail?id={childId}`

---

### 6. GROUP (그룹)

```json
{
  "category": "GROUP",
  "groupId": "550e8400-e29b-41d4-a716-446655440006"
}
```

**이동 화면**: `/settings/groups/{groupId}`

---

### 7. SYSTEM (시스템 - 공지사항)

```json
{
  "category": "SYSTEM",
  "announcementId": "550e8400-e29b-41d4-a716-446655440007"
}
```

**이동 화면**: `/announcements/{announcementId}`

---

### 8. SYSTEM (시스템 - QnA 답변)

```json
{
  "category": "SYSTEM",
  "questionId": "550e8400-e29b-41d4-a716-446655440008"
}
```

**이동 화면**: `/qna/questions/{questionId}`

---

## 예시: 알림 전송 API 요청

### POST /notifications/schedule (예약 알림)

```json
{
  "userId": "550e8400-e29b-41d4-a716-446655440000",
  "category": "SCHEDULE",
  "title": "일정 알림",
  "body": "30분 후 '가족 모임'이 시작됩니다.",
  "scheduledTime": "2026-01-20T14:30:00Z",
  "data": {
    "category": "SCHEDULE",
    "scheduleId": "550e8400-e29b-41d4-a716-446655440001"
  }
}
```

### FCM 푸시 알림 페이로드 예시

```json
{
  "notification": {
    "title": "일정 알림",
    "body": "30분 후 '가족 모임'이 시작됩니다."
  },
  "data": {
    "category": "SCHEDULE",
    "scheduleId": "550e8400-e29b-41d4-a716-446655440001"
  }
}
```

## 프론트엔드 처리 로직

1. **알림 히스토리 화면**: 알림 탭 → 읽음 처리 → `data` 기반 화면 이동
2. **홈 화면 알림 위젯**: 알림 탭 → 읽음 처리 → `data` 기반 화면 이동
3. **푸시 알림 탭**: FCM `data` 페이로드 기반 화면 이동

## 주의사항

1. `data` 필드가 `null`이거나 비어있으면 화면 이동하지 않음
2. `category`는 대문자로 전송 (예: `SCHEDULE`, `TODO`)
3. 엔티티 ID 키 이름은 반드시 위 스펙을 따를 것
4. SYSTEM 카테고리는 `announcementId` 또는 `questionId` 중 하나만 포함

## 관련 파일

- **프론트엔드 서비스**: `lib/features/notification/data/services/notification_navigation_service.dart`
- **로컬 알림 서비스**: `lib/features/notification/data/services/local_notification_service.dart`
- **알림 히스토리 화면**: `lib/features/notification/presentation/screens/notification_history_screen.dart`
- **홈 알림 위젯**: `lib/features/notification/presentation/widgets/unread_notifications_widget.dart`
