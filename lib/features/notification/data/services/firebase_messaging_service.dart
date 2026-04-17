import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import 'package:family_planner/firebase_options.dart';
import 'package:family_planner/features/notification/data/services/local_notification_service.dart';

/// Firebase Cloud Messaging 서비스
class FirebaseMessagingService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Firebase Messaging 초기화
  static Future<void> initialize() async {
    try {
      // 알림 권한 요청
      await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      // FCM 토큰 가져오기
      await getToken();

      // 토큰 갱신 리스너
      _messaging.onTokenRefresh.listen((newToken) {
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
        if (vapidKey.isEmpty) return null;
        return await _messaging.getToken(vapidKey: vapidKey);
      } else {
        return await _messaging.getToken();
      }
    } catch (e) {
      return null;
    }
  }

  /// FCM 토큰 삭제
  static Future<void> deleteToken() async {
    try {
      await _messaging.deleteToken();
    } catch (e) {
      // 삭제 실패 무시
    }
  }

  /// 포그라운드 메시지 처리
  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
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
    // TODO: 알림 데이터에 따라 해당 화면으로 이동
    _navigateToScreen(message.data);
  }

  /// 알림 데이터에 따라 화면 이동
  static void _navigateToScreen(Map<String, dynamic> data) {
    // TODO: GoRouter를 사용하여 화면 이동 구현
    // switch (data['type']) {
    //   case 'schedule': ...
    // }
  }
}

/// 백그라운드 메시지 핸들러 (Top-level 함수)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // 백그라운드 메시지 수신 처리
}
