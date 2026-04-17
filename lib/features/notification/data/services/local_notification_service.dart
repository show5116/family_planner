import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:family_planner/core/routes/app_router.dart';
import 'package:family_planner/features/notification/data/services/notification_navigation_service.dart';

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

    } catch (e) {
      // 초기화 실패 무시
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

    } catch (e) {
      // 알림 표시 실패 무시
    }
  }

  /// 알림 탭 처리
  static void _onNotificationTapped(NotificationResponse response) {
    if (response.payload != null) {
      try {
        final data = jsonDecode(response.payload!);
        _navigateToScreen(data);
      } catch (e) {
        // 데이터 파싱 실패 무시
      }
    }
  }

  /// 알림 데이터에 따라 화면 이동
  static void _navigateToScreen(Map<String, dynamic> data) {
    final context = AppRouter.navigatorKey.currentContext;
    if (context == null) return;

    final category = data['category'] as String?;
    NotificationNavigationService.navigateByData(context, category, data);
  }

  /// 모든 알림 취소
  static Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }

  /// 특정 알림 취소
  static Future<void> cancel(int id) async {
    await _notifications.cancel(id);
  }
}
