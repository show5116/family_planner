import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import 'package:family_planner/core/routes/app_router.dart';
import 'package:family_planner/core/services/analytics_service.dart';
import 'package:family_planner/firebase_options.dart';
import 'package:family_planner/features/notification/data/services/local_notification_service.dart';
import 'package:family_planner/features/notification/data/services/notification_navigation_service.dart';

/// Firebase Cloud Messaging 서비스
class FirebaseMessagingService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // 앱 종료 상태에서 탭한 메시지 — 앱 초기화 완료 후 처리
  static Map<String, dynamic>? _pendingNavigationData;

  // 토큰 갱신 시 호출할 콜백 — 로그인 성공 후 fcm_token_provider가 주입
  static Future<void> Function(String)? _onTokenRefreshCallback;
  static String? _cachedToken;

  static void setOnTokenRefreshCallback(Future<void> Function(String)? callback) {
    _onTokenRefreshCallback = callback;
    // 콜백 등록 시점에 이미 발급된 토큰이 있으면 즉시 전달
    if (callback != null && _cachedToken != null) {
      callback(_cachedToken!);
    }
  }

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

      // FCM 토큰 가져오기 및 캐시
      _cachedToken = await getToken();

      // 토큰 갱신 리스너
      _messaging.onTokenRefresh.listen((newToken) {
        _cachedToken = newToken;
        _onTokenRefreshCallback?.call(newToken);
      });

      // 포그라운드 메시지 핸들러
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // 백그라운드에서 알림을 탭하여 앱을 열었을 때
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

      // 앱이 종료된 상태에서 알림을 탭하여 앱을 열었을 때
      // navigatorKey.currentContext가 아직 없으므로 pending으로 저장
      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        _pendingNavigationData = initialMessage.data;
      }

    } catch (e) {
      debugPrint('Firebase Messaging 초기화 실패: $e');
    }
  }

  /// 앱 초기화 완료 후 pending 알림 처리
  ///
  /// 홈 화면이 준비된 시점(HomeScreen initState의 postFrameCallback)에서 호출
  static void handlePendingNavigation() {
    final data = _pendingNavigationData;
    if (data == null) return;
    _pendingNavigationData = null;
    _navigateToScreen(data);
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
      debugPrint('FCM 토큰 발급 실패: $e');
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
    final title = message.data['title'] ?? message.notification?.title ?? '';
    final body = message.data['body'] ?? message.notification?.body ?? '';
    await LocalNotificationService.show(
      id: message.messageId.hashCode,
      title: title,
      body: body,
      payload: jsonEncode(message.data),
    );
  }

  /// 백그라운드에서 알림을 탭하여 앱을 열었을 때 처리
  static Future<void> _handleMessageOpenedApp(RemoteMessage message) async {
    _navigateToScreen(message.data);
  }

  /// 알림 데이터에 따라 화면 이동
  static void _navigateToScreen(Map<String, dynamic> data) {
    final context = AppRouter.navigatorKey.currentContext;
    if (context == null) return;

    final category = data['category'] as String? ?? 'unknown';
    AnalyticsService.instance.logNotificationOpen(category);
    NotificationNavigationService.navigateByData(context, category, data);
  }
}

/// 백그라운드 메시지 핸들러 (Top-level 함수)
/// data-only 메시지를 백그라운드/종료 상태에서 수신하면 로컬 알림으로 표시
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await LocalNotificationService.initialize();
  final title = message.data['title'] ?? '';
  final body = message.data['body'] ?? '';
  if (title.isEmpty && body.isEmpty) return;
  await LocalNotificationService.show(
    id: message.messageId.hashCode,
    title: title,
    body: body,
    payload: jsonEncode(message.data),
  );
}
