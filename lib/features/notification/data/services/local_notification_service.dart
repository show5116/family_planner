import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// 로컬 알림 서비스
class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  /// 로컬 알림 초기화
  static Future<void> initialize() async {
    try {
      // Android 설정
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

      // iOS 설정
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      // 초기화 설정
      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      // 초기화
      await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      debugPrint('로컬 알림 초기화 완료');
    } catch (e) {
      debugPrint('로컬 알림 초기화 실패: $e');
    }
  }

  /// 알림 표시
  static Future<void> show({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      // Android 알림 설정
      const androidDetails = AndroidNotificationDetails(
        'default_channel',
        'Default Channel',
        channelDescription: 'Default notification channel',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
      );

      // iOS 알림 설정
      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      // 알림 설정
      const details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      // 알림 표시
      await _notifications.show(
        id,
        title,
        body,
        details,
        payload: payload,
      );

      debugPrint('로컬 알림 표시: $title');
    } catch (e) {
      debugPrint('로컬 알림 표시 실패: $e');
    }
  }

  /// 알림 탭 처리
  static void _onNotificationTapped(NotificationResponse response) {
    debugPrint('알림 탭: ${response.payload}');

    if (response.payload != null) {
      try {
        final data = jsonDecode(response.payload!);
        debugPrint('알림 데이터: $data');

        // TODO: GoRouter를 사용하여 해당 화면으로 이동
        _navigateToScreen(data);
      } catch (e) {
        debugPrint('알림 데이터 파싱 실패: $e');
      }
    }
  }

  /// 알림 데이터에 따라 화면 이동
  static void _navigateToScreen(Map<String, dynamic> data) {
    // TODO: GoRouter를 사용하여 화면 이동 구현
    final type = data['type'] as String?;
    final id = data['id'] as String?;

    debugPrint('화면 이동: type=$type, id=$id');

    // 예시:
    // final router = ref.read(goRouterProvider);
    // switch (type) {
    //   case 'schedule':
    //     router.go('/schedule/$id');
    //     break;
    //   case 'todo':
    //     router.go('/todo/$id');
    //     break;
    //   // ...
    // }
  }

  /// 모든 알림 취소
  static Future<void> cancelAll() async {
    await _notifications.cancelAll();
    debugPrint('모든 알림 취소');
  }

  /// 특정 알림 취소
  static Future<void> cancel(int id) async {
    await _notifications.cancel(id);
    debugPrint('알림 취소: $id');
  }
}
