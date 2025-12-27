import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../../../../firebase_options.dart';
import 'local_notification_service.dart';

/// Firebase Cloud Messaging 서비스
class FirebaseMessagingService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Firebase Messaging 초기화
  static Future<void> initialize() async {
    try {
      // 알림 권한 요청
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      debugPrint('알림 권한 상태: ${settings.authorizationStatus}');

      // FCM 토큰 가져오기
      final token = await getToken();
      if (token != null) {
        debugPrint('FCM Token: $token');
      }

      // 토큰 갱신 리스너
      _messaging.onTokenRefresh.listen((newToken) {
        debugPrint('FCM Token 갱신: $newToken');
        // TODO: 백엔드에 새 토큰 전송
      });

      // 포그라운드 메시지 핸들러
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // 백그라운드에서 알림을 탭하여 앱을 열었을 때
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

      // 앱이 종료된 상태에서 알림을 탭하여 앱을 열었을 때
      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        _handleMessageOpenedApp(initialMessage);
      }

      debugPrint('Firebase Messaging 초기화 완료');
    } catch (e) {
      debugPrint('Firebase Messaging 초기화 실패: $e');
    }
  }

  /// FCM 토큰 가져오기
  static Future<String?> getToken() async {
    try {
      if (kIsWeb) {
        // Web의 경우 VAPID 키 필요
        final vapidKey = DefaultFirebaseOptions.webVapidKey;
        if (vapidKey.isEmpty) {
          debugPrint('⚠️ FIREBASE_WEB_VAPID_KEY가 .env에 설정되지 않았습니다');
          return null;
        }
        return await _messaging.getToken(vapidKey: vapidKey);
      } else {
        return await _messaging.getToken();
      }
    } catch (e) {
      debugPrint('FCM Token 가져오기 실패: $e');
      return null;
    }
  }

  /// FCM 토큰 삭제
  static Future<void> deleteToken() async {
    try {
      await _messaging.deleteToken();
      debugPrint('FCM Token 삭제 완료');
    } catch (e) {
      debugPrint('FCM Token 삭제 실패: $e');
    }
  }

  /// 포그라운드 메시지 처리
  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    debugPrint('포그라운드 메시지 수신: ${message.messageId}');
    debugPrint('제목: ${message.notification?.title}');
    debugPrint('내용: ${message.notification?.body}');
    debugPrint('데이터: ${message.data}');

    // 로컬 알림으로 표시
    await LocalNotificationService.show(
      id: message.messageId.hashCode,
      title: message.notification?.title ?? '',
      body: message.notification?.body ?? '',
      payload: jsonEncode(message.data),
    );
  }

  /// 백그라운드에서 알림을 탭하여 앱을 열었을 때 처리
  static Future<void> _handleMessageOpenedApp(RemoteMessage message) async {
    debugPrint('알림 탭으로 앱 열림: ${message.messageId}');
    debugPrint('데이터: ${message.data}');

    // TODO: 알림 데이터에 따라 해당 화면으로 이동
    _navigateToScreen(message.data);
  }

  /// 알림 데이터에 따라 화면 이동
  static void _navigateToScreen(Map<String, dynamic> data) {
    // TODO: GoRouter를 사용하여 화면 이동 구현
    final type = data['type'] as String?;
    final id = data['id'] as String?;

    debugPrint('화면 이동: type=$type, id=$id');

    // 예시:
    // switch (type) {
    //   case 'schedule':
    //     // 일정 상세 화면으로 이동
    //     break;
    //   case 'todo':
    //     // 할 일 상세 화면으로 이동
    //     break;
    //   // ...
    // }
  }
}

/// 백그라운드 메시지 핸들러 (Top-level 함수)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('백그라운드 메시지 수신: ${message.messageId}');
  debugPrint('제목: ${message.notification?.title}');
  debugPrint('내용: ${message.notification?.body}');
  debugPrint('데이터: ${message.data}');
}
