# 14. 알람 (Notification)

> **상태**: ⬜ 시작 안함
> **우선순위**: P1
> **마지막 업데이트**: 2025-12-25

---

## 📋 개요

Firebase Cloud Messaging(FCM)을 활용한 푸시 알림 시스템입니다. 백엔드에서 Firebase를 통해 알림을 전송하고, 프론트엔드에서 이를 수신 및 처리합니다.

### 주요 기능
- 푸시 알림 수신 (포그라운드/백그라운드)
- 알림 권한 관리
- FCM 토큰 관리 및 백엔드 동기화
- 알림 설정 (카테고리별 on/off)
- 알림 히스토리 조회
- 알림 클릭 시 해당 화면으로 이동

---

## 🎯 사용자 스토리

### 1. 알림 수신
- **As a** 사용자
- **I want to** 앱에서 푸시 알림을 받고 싶다
- **So that** 중요한 이벤트나 일정을 놓치지 않을 수 있다

### 2. 알림 설정
- **As a** 사용자
- **I want to** 알림 종류별로 수신 여부를 설정하고 싶다
- **So that** 원하는 알림만 받을 수 있다

### 3. 알림 히스토리
- **As a** 사용자
- **I want to** 받은 알림 목록을 확인하고 싶다
- **So that** 지나간 알림도 다시 확인할 수 있다

---

## 🔧 기술 스택

- **Firebase Cloud Messaging**: 푸시 알림 전송
- **flutter_local_notifications**: 로컬 알림 표시 및 커스터마이징
- **Riverpod**: 알림 상태 관리
- **SharedPreferences**: 알림 설정 로컬 저장

---

## 📐 화면 구성

### 1. 알림 설정 화면 (설정 메뉴 내)
```
┌─────────────────────────────────┐
│ < 알림 설정                      │
├─────────────────────────────────┤
│                                 │
│ 알림 권한                        │
│ ○ 활성화됨                       │ <- 권한 상태
│ [권한 설정 열기] (비활성화 시)    │
│                                 │
│ ───────────────────────────────  │
│                                 │
│ 알림 설정                        │
│                                 │
│ 일정 알림              ☑        │
│ 할 일 알림             ☑        │
│ 가계부 알림            ☑        │
│ 그룹 초대 알림         ☑        │
│ 공지사항               ☑        │
│                                 │
│ ───────────────────────────────  │
│                                 │
│ [알림 히스토리 보기]             │
│                                 │
└─────────────────────────────────┘
```

### 2. 알림 히스토리 화면
```
┌─────────────────────────────────┐
│ < 알림 히스토리                  │
├─────────────────────────────────┤
│                                 │
│ 오늘                            │
│                                 │
│ 🔔 [일정] 회의 10분 전           │
│    오후 2:50                     │
│                                 │
│ 🔔 [할 일] 마감 기한 임박        │
│    오전 9:00                     │
│                                 │
│ 어제                            │
│                                 │
│ 🔔 [그룹] 새로운 초대            │
│    오후 5:30                     │
│                                 │
│ [더 보기]                        │
│                                 │
└─────────────────────────────────┘
```

### 3. 푸시 알림 표시 (시스템 알림)
```
┌─────────────────────────────────┐
│ Family Planner       [앱 아이콘]  │
│                                 │
│ 회의 10분 전                     │
│ 오후 3시 팀 회의가 곧 시작됩니다  │
│                                 │
│                        방금 전   │
└─────────────────────────────────┘
```

---

## 🗂️ 디렉토리 구조

```
lib/features/notification/
├── data/
│   ├── models/
│   │   ├── notification_model.dart        # 알림 데이터 모델
│   │   └── notification_settings_model.dart # 알림 설정 모델
│   ├── repositories/
│   │   ├── notification_repository.dart   # 알림 API 통신
│   │   └── fcm_token_repository.dart      # FCM 토큰 관리
│   └── services/
│       ├── firebase_messaging_service.dart # FCM 초기화 및 처리
│       └── local_notification_service.dart # 로컬 알림 서비스
├── providers/
│   ├── notification_provider.dart         # 알림 상태 관리
│   ├── notification_settings_provider.dart # 알림 설정 상태
│   └── fcm_token_provider.dart            # FCM 토큰 상태
└── presentation/
    ├── screens/
    │   ├── notification_settings_screen.dart # 알림 설정 화면
    │   └── notification_history_screen.dart  # 알림 히스토리 화면
    └── widgets/
        ├── notification_permission_card.dart # 권한 상태 카드
        ├── notification_toggle_item.dart     # 알림 토글 아이템
        └── notification_history_item.dart    # 알림 히스토리 아이템
```

---

## 📊 데이터 모델

### NotificationModel
```dart
@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required String id,
    required String title,
    required String body,
    required NotificationType type,
    required DateTime timestamp,
    bool? isRead,
    Map<String, dynamic>? data,  // 추가 데이터 (예: 일정 ID)
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}

enum NotificationType {
  schedule,    // 일정
  todo,        // 할 일
  household,   // 가계부
  groupInvite, // 그룹 초대
  announcement // 공지사항
}
```

### NotificationSettingsModel
```dart
@freezed
class NotificationSettingsModel with _$NotificationSettingsModel {
  const factory NotificationSettingsModel({
    @Default(true) bool scheduleEnabled,
    @Default(true) bool todoEnabled,
    @Default(true) bool householdEnabled,
    @Default(true) bool groupInviteEnabled,
    @Default(true) bool announcementEnabled,
  }) = _NotificationSettingsModel;

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsModelFromJson(json);
}
```

---

## 🔌 API 연동

### 1. FCM 토큰 등록
```dart
POST /api/notifications/token
Headers: Authorization: Bearer {token}
Body: {
  "fcmToken": "string",
  "platform": "android|ios|web"
}

Response 200:
{
  "success": true,
  "message": "FCM token registered successfully"
}
```

### 2. 알림 설정 저장
```dart
PUT /api/notifications/settings
Headers: Authorization: Bearer {token}
Body: {
  "scheduleEnabled": true,
  "todoEnabled": true,
  "householdEnabled": false,
  "groupInviteEnabled": true,
  "announcementEnabled": true
}

Response 200:
{
  "success": true,
  "settings": { ... }
}
```

### 3. 알림 히스토리 조회
```dart
GET /api/notifications/history?page=1&limit=20
Headers: Authorization: Bearer {token}

Response 200:
{
  "notifications": [
    {
      "id": "uuid",
      "title": "회의 10분 전",
      "body": "오후 3시 팀 회의가 곧 시작됩니다",
      "type": "schedule",
      "timestamp": "2025-12-25T14:50:00Z",
      "isRead": false,
      "data": {
        "scheduleId": "schedule-id"
      }
    }
  ],
  "total": 50,
  "page": 1,
  "totalPages": 3
}
```

### 4. 알림 읽음 처리
```dart
PUT /api/notifications/{notificationId}/read
Headers: Authorization: Bearer {token}

Response 200:
{
  "success": true
}
```

---

## 🎨 UI 컴포넌트

### NotificationPermissionCard
권한 상태를 표시하고 설정으로 이동할 수 있는 카드
- 권한 활성화 여부 표시
- 권한 비활성화 시 설정 화면으로 이동 버튼

### NotificationToggleItem
개별 알림 카테고리를 토글할 수 있는 리스트 아이템
- 알림 종류 아이콘 및 텍스트
- Switch 위젯

### NotificationHistoryItem
알림 히스토리 리스트 아이템
- 알림 아이콘 (타입별)
- 제목 및 내용
- 시간 표시
- 읽음/안 읽음 상태

---

## 🔄 주요 로직

### 1. Firebase 초기화 및 토큰 관리
```dart
// FirebaseMessagingService
class FirebaseMessagingService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // 초기화
  Future<void> initialize() async {
    // 권한 요청
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // FCM 토큰 가져오기
    String? token = await _messaging.getToken();
    if (token != null) {
      await _registerToken(token);
    }

    // 토큰 갱신 리스너
    _messaging.onTokenRefresh.listen(_registerToken);

    // 메시지 핸들러 등록
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
  }

  // 포그라운드 메시지 처리
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    // 로컬 알림으로 표시
    await LocalNotificationService.show(
      title: message.notification?.title ?? '',
      body: message.notification?.body ?? '',
      payload: jsonEncode(message.data),
    );
  }

  // 백그라운드에서 열린 메시지 처리
  Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    // 해당 화면으로 이동
    _navigateToScreen(message.data);
  }
}
```

### 2. 로컬 알림 표시
```dart
// LocalNotificationService
class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();

    await _notifications.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  static Future<void> show({
    required String title,
    required String body,
    String? payload,
  }) async {
    await _notifications.show(
      0,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'default_channel',
          'Default Channel',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: payload,
    );
  }

  static void _onNotificationTapped(NotificationResponse response) {
    if (response.payload != null) {
      final data = jsonDecode(response.payload!);
      // 해당 화면으로 이동
    }
  }
}
```

### 3. 알림 설정 관리
```dart
// NotificationSettingsProvider
@riverpod
class NotificationSettings extends _$NotificationSettings {
  @override
  Future<NotificationSettingsModel> build() async {
    // 로컬에서 설정 불러오기
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString('notification_settings');

    if (json != null) {
      return NotificationSettingsModel.fromJson(jsonDecode(json));
    }

    // 기본 설정
    return const NotificationSettingsModel();
  }

  Future<void> updateSetting({
    bool? scheduleEnabled,
    bool? todoEnabled,
    bool? householdEnabled,
    bool? groupInviteEnabled,
    bool? announcementEnabled,
  }) async {
    final current = await future;
    final updated = current.copyWith(
      scheduleEnabled: scheduleEnabled ?? current.scheduleEnabled,
      todoEnabled: todoEnabled ?? current.todoEnabled,
      householdEnabled: householdEnabled ?? current.householdEnabled,
      groupInviteEnabled: groupInviteEnabled ?? current.groupInviteEnabled,
      announcementEnabled: announcementEnabled ?? current.announcementEnabled,
    );

    // 로컬 저장
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('notification_settings', jsonEncode(updated.toJson()));

    // 백엔드 동기화
    await ref.read(notificationRepositoryProvider).updateSettings(updated);

    state = AsyncValue.data(updated);
  }
}
```

---

## ✅ 구현 체크리스트

### Phase 1: 기본 설정 및 서비스 구현
- [ ] Firebase 프로젝트 설정 안내 문서 작성
- [ ] `firebase_core`, `firebase_messaging` 패키지 추가
- [ ] `flutter_local_notifications` 패키지 추가
- [ ] Firebase 초기화 (Android, iOS, Web)
- [ ] FirebaseMessagingService 구현
- [ ] LocalNotificationService 구현
- [ ] FCM 토큰 관리 Provider 구현

### Phase 2: 알림 설정 UI
- [ ] NotificationSettingsModel 모델 작성
- [ ] NotificationSettingsProvider 구현
- [ ] 알림 설정 화면 UI 구현
- [ ] 권한 요청 로직 구현
- [ ] 카테고리별 알림 토글 기능

### Phase 3: 알림 수신 및 처리
- [ ] 포그라운드 알림 처리
- [ ] 백그라운드 알림 처리
- [ ] 알림 클릭 시 화면 이동 로직
- [ ] 알림 데이터 파싱 및 라우팅

### Phase 4: 알림 히스토리
- [ ] NotificationModel 모델 작성
- [ ] 알림 히스토리 조회 API 연동
- [ ] 알림 히스토리 화면 UI 구현
- [ ] 무한 스크롤 (페이지네이션)
- [ ] 알림 읽음 처리

### Phase 5: 통합 및 테스트
- [ ] 앱 초기화 시 Firebase 초기화
- [ ] 로그인 시 FCM 토큰 등록
- [ ] 로그아웃 시 FCM 토큰 제거
- [ ] 각 플랫폼별 테스트 (Android, iOS, Web)
- [ ] 설정 화면에 알림 설정 메뉴 추가

---

## 🎯 테스트 시나리오

### 1. 권한 테스트
- [ ] 앱 최초 실행 시 알림 권한 요청
- [ ] 권한 거부 시 설정 화면 안내
- [ ] 권한 허용 시 FCM 토큰 등록

### 2. 알림 수신 테스트
- [ ] 포그라운드에서 알림 수신 및 표시
- [ ] 백그라운드에서 알림 수신
- [ ] 앱 종료 상태에서 알림 수신
- [ ] 알림 클릭 시 해당 화면으로 이동

### 3. 알림 설정 테스트
- [ ] 카테고리별 알림 토글 on/off
- [ ] 설정 변경 시 백엔드 동기화
- [ ] 설정 변경 후 해당 카테고리 알림 수신 여부

### 4. 히스토리 테스트
- [ ] 알림 히스토리 목록 조회
- [ ] 페이지네이션 동작
- [ ] 알림 읽음 처리
- [ ] 읽음/안 읽음 표시

---

## 📱 플랫폼별 설정

### Android
- `android/app/build.gradle`: minSdkVersion 21 이상
- `android/app/src/main/AndroidManifest.xml`: 알림 권한 추가
- `google-services.json` 파일 배치

### iOS
- Xcode에서 Push Notifications capability 활성화
- `ios/Runner/Info.plist`: 알림 관련 권한 추가
- `GoogleService-Info.plist` 파일 배치
- APNs 인증서 설정 (Firebase Console)

### Web
- Firebase SDK 스크립트 추가 (`index.html`)
- `firebase-messaging-sw.js` 작성 (Service Worker)
- HTTPS 환경 필수

---

## 🚨 주의사항

1. **권한 관리**: 플랫폼별로 권한 요청 시점과 방법이 다름
2. **토큰 갱신**: FCM 토큰은 주기적으로 갱신될 수 있으므로 리스너 등록 필수
3. **백그라운드 처리**: 백그라운드에서 실행되는 핸들러는 top-level 함수여야 함
4. **데이터 페이로드**: 알림과 함께 전송되는 데이터는 String 형태로만 전송 가능
5. **플랫폼 차이**: Android, iOS, Web 각각 알림 동작 방식이 다를 수 있음

---

## 📚 참고 자료

- [Firebase Cloud Messaging 공식 문서](https://firebase.google.com/docs/cloud-messaging)
- [FlutterFire 공식 문서](https://firebase.flutter.dev/docs/messaging/overview)
- [flutter_local_notifications 패키지](https://pub.dev/packages/flutter_local_notifications)
- Flutter 푸시 알림 베스트 프랙티스

---

## 🔗 관련 문서

- [12-settings.md](12-settings.md) - 설정 화면 (알림 설정 메뉴 포함)
- [PROJECT_STRUCTURE.md](../PROJECT_STRUCTURE.md) - 프로젝트 구조
- [UI_ARCHITECTURE.md](../UI_ARCHITECTURE.md) - UI 디자인 시스템
