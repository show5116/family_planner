# 알림 기능 구현 상세 가이드

> 이 문서는 알림 기능의 상세 구현 내용을 설명합니다.

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
│   │   └── notification_repository.dart   # 알림 API 통신
│   └── services/
│       ├── firebase_messaging_service.dart # FCM 초기화 및 처리
│       └── local_notification_service.dart # 로컬 알림 서비스
├── providers/
│   ├── fcm_token_provider.dart            # FCM 토큰 상태 관리
│   ├── notification_settings_provider.dart # 알림 설정 상태
│   └── notification_history_provider.dart  # 알림 히스토리 상태
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

## 🔄 주요 로직

### 1. Firebase 초기화 및 토큰 관리

**위치**: `lib/features/notification/data/services/firebase_messaging_service.dart`

```dart
class FirebaseMessagingService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // 초기화
  static Future<void> initialize() async {
    // 권한 요청
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // FCM 토큰 가져오기
    String? token = await _getToken();
    if (token != null) {
      debugPrint('FCM Token: $token');
      // TODO: 백엔드에 토큰 등록
    }

    // 토큰 갱신 리스너
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      debugPrint('FCM Token Refreshed: $newToken');
      // TODO: 백엔드에 새 토큰 업데이트
    });

    // 메시지 핸들러 등록
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
  }

  // 플랫폼별 토큰 가져오기
  static Future<String?> _getToken() async {
    if (kIsWeb) {
      // Web: VAPID 키 필요
      final vapidKey = DefaultFirebaseOptions.webVapidKey;
      if (vapidKey.isEmpty) {
        debugPrint('⚠️ FIREBASE_WEB_VAPID_KEY가 .env에 설정되지 않았습니다');
        return null;
      }
      return await FirebaseMessaging.instance.getToken(vapidKey: vapidKey);
    } else {
      // Android, iOS
      return await FirebaseMessaging.instance.getToken();
    }
  }

  // 포그라운드 메시지 처리
  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    debugPrint('포그라운드 메시지 수신: ${message.notification?.title}');

    // 로컬 알림으로 표시
    await LocalNotificationService.show(
      title: message.notification?.title ?? '',
      body: message.notification?.body ?? '',
      payload: jsonEncode(message.data),
    );
  }

  // 백그라운드에서 열린 메시지 처리
  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    debugPrint('백그라운드 메시지 열림: ${message.notification?.title}');

    // 해당 화면으로 이동
    _navigateToScreen(message.data);
  }

  // 화면 라우팅
  static void _navigateToScreen(Map<String, dynamic> data) {
    // TODO: 알림 타입에 따라 해당 화면으로 이동
    final type = data['type'];
    final id = data['id'];

    switch (type) {
      case 'schedule':
        // 일정 상세로 이동
        break;
      case 'todo':
        // 할일 상세로 이동
        break;
      // ... 기타 타입 처리
    }
  }
}
```

### 2. 로컬 알림 표시

**위치**: `lib/features/notification/data/services/local_notification_service.dart`

```dart
class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // Android 설정
    const androidSettings = AndroidInitializationSettings('@drawable/ic_notification');

    // iOS 설정
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // 초기화
    await _notifications.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  // 알림 표시
  static Future<void> show({
    required String title,
    required String body,
    String? payload,
  }) async {
    await _notifications.show(
      0, // 알림 ID
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'default_channel',
          'Default Channel',
          channelDescription: 'Family Planner 기본 알림 채널',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@drawable/ic_notification',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: payload,
    );
  }

  // 알림 클릭 처리
  static void _onNotificationTapped(NotificationResponse response) {
    if (response.payload != null) {
      final data = jsonDecode(response.payload!);
      // 해당 화면으로 이동
      FirebaseMessagingService._navigateToScreen(data);
    }
  }
}
```

### 3. 알림 설정 관리

**위치**: `lib/features/notification/providers/notification_settings_provider.dart`

```dart
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

    // 기본 설정 (모두 활성화)
    return const NotificationSettingsModel();
  }

  // 설정 업데이트
  Future<void> updateSetting({
    bool? scheduleEnabled,
    bool? todoEnabled,
    bool? householdEnabled,
    bool? assetEnabled,
    bool? childcareEnabled,
    bool? groupEnabled,
    bool? systemEnabled,
  }) async {
    final current = await future;
    final updated = current.copyWith(
      scheduleEnabled: scheduleEnabled ?? current.scheduleEnabled,
      todoEnabled: todoEnabled ?? current.todoEnabled,
      householdEnabled: householdEnabled ?? current.householdEnabled,
      assetEnabled: assetEnabled ?? current.assetEnabled,
      childcareEnabled: childcareEnabled ?? current.childcareEnabled,
      groupEnabled: groupEnabled ?? current.groupEnabled,
      systemEnabled: systemEnabled ?? current.systemEnabled,
    );

    // 로컬 저장
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('notification_settings', jsonEncode(updated.toJson()));

    // 백엔드 동기화
    // TODO: API 연동 후 활성화
    // await ref.read(notificationRepositoryProvider).updateSettings(updated);

    state = AsyncValue.data(updated);
  }
}
```

### 4. FCM 토큰 Provider

**위치**: `lib/features/notification/providers/fcm_token_provider.dart`

```dart
@riverpod
class FcmToken extends _$FcmToken {
  @override
  Future<String?> build() async {
    // 토큰 가져오기
    final token = await FirebaseMessagingService._getToken();

    if (token != null) {
      // TODO: 백엔드에 토큰 등록
      // await _registerToken(token);
    }

    return token;
  }

  // 토큰 백엔드 등록
  Future<void> registerToken(String token) async {
    // TODO: API 연동
    // await ref.read(notificationRepositoryProvider).registerToken(token);
  }

  // 토큰 백엔드 삭제
  Future<void> deleteToken() async {
    final token = await future;
    if (token != null) {
      // TODO: API 연동
      // await ref.read(notificationRepositoryProvider).deleteToken(token);
    }
  }
}
```

---

## 🎨 UI 컴포넌트

### NotificationPermissionCard

**위치**: `lib/features/notification/presentation/widgets/notification_permission_card.dart`

권한 상태를 표시하고 설정으로 이동할 수 있는 카드
- 권한 활성화 여부 표시
- 권한 비활성화 시 설정 화면으로 이동 버튼

### NotificationToggleItem

**위치**: `lib/features/notification/presentation/widgets/notification_toggle_item.dart`

개별 알림 카테고리를 토글할 수 있는 리스트 아이템
- 알림 종류 아이콘 및 텍스트
- Switch 위젯

### NotificationHistoryItem

**위치**: `lib/features/notification/presentation/widgets/notification_history_item.dart`

알림 히스토리 리스트 아이템
- 알림 아이콘 (타입별)
- 제목 및 내용
- 시간 표시
- 읽음/안 읽음 상태

---

## 📱 플랫폼별 설정

### Android

**파일 위치**:
- `android/app/build.gradle.kts`: minSdkVersion 21 이상
- `android/app/src/main/AndroidManifest.xml`: 알림 권한 추가
- `android/app/google-services.json`: Firebase 설정 파일

**AndroidManifest.xml 설정**:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>

<application>
  <!-- 알림 아이콘 -->
  <meta-data
      android:name="com.google.firebase.messaging.default_notification_icon"
      android:resource="@drawable/ic_notification" />

  <!-- 알림 색상 -->
  <meta-data
      android:name="com.google.firebase.messaging.default_notification_color"
      android:resource="@color/notification_color" />

  <!-- 알림 채널 -->
  <meta-data
      android:name="com.google.firebase.messaging.default_notification_channel_id"
      android:value="default_channel" />
</application>
```

### iOS

**파일 위치**:
- Xcode에서 Push Notifications capability 활성화
- `ios/Runner/Info.plist`: 알림 관련 권한 추가
- `ios/Runner/GoogleService-Info.plist`: Firebase 설정 파일

**Info.plist 설정**:
```xml
<key>UIBackgroundModes</key>
<array>
  <string>fetch</string>
  <string>remote-notification</string>
</array>
```

**주의사항**:
- APNs 인증서를 Firebase Console에 등록해야 함
- 개발/프로덕션 인증서를 구분하여 설정

### Web

**파일 위치**:
- `web/index.html`: Firebase SDK 스크립트 추가
- `web/firebase-messaging-sw.js`: Service Worker (미래 구현)

**주의사항**:
- HTTPS 환경에서만 작동
- VAPID Key 필수 (.env에 설정)
- Service Worker 등록 필요 (향후 구현 예정)

---

## 🚨 주의사항

1. **권한 관리**: 플랫폼별로 권한 요청 시점과 방법이 다름
2. **토큰 갱신**: FCM 토큰은 주기적으로 갱신될 수 있으므로 리스너 등록 필수
3. **백그라운드 처리**: 백그라운드에서 실행되는 핸들러는 top-level 함수여야 함
4. **데이터 페이로드**: 알림과 함께 전송되는 데이터는 String 형태로만 전송 가능
5. **플랫폼 차이**: Android, iOS, Web 각각 알림 동작 방식이 다를 수 있음

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

## 📚 참고 자료

- [Firebase Cloud Messaging 공식 문서](https://firebase.google.com/docs/cloud-messaging)
- [FlutterFire 공식 문서](https://firebase.flutter.dev/docs/messaging/overview)
- [flutter_local_notifications 패키지](https://pub.dev/packages/flutter_local_notifications)
- Flutter 푸시 알림 베스트 프랙티스
