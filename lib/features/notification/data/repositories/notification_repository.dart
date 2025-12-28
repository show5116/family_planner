import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/api_client.dart';
import '../models/notification_model.dart';
import '../models/notification_settings_model.dart';

/// 알림 Repository Provider
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository();
});

/// 알림 Repository
class NotificationRepository {
  final Dio _dio = ApiClient.instance.dio;

  NotificationRepository();

  /// FCM 토큰 등록
  Future<void> registerFcmToken({
    required String fcmToken,
    required String platform,
  }) async {
    try {
      debugPrint('🔵 [NotificationRepository] FCM 토큰 등록 API 호출 시작');
      debugPrint('  - URL: /notifications/token');
      debugPrint('  - Platform: $platform');
      debugPrint('  - Token: ${fcmToken.substring(0, 20)}...');

      final response = await _dio.post('/notifications/token', data: {
        'token': fcmToken,
        'platform': platform,
      });

      debugPrint('✅ [NotificationRepository] FCM 토큰 등록 성공: ${response.statusCode}');
    } on DioException catch (e) {
      debugPrint('❌ [NotificationRepository] FCM 토큰 등록 실패');
      debugPrint('  - Status: ${e.response?.statusCode}');
      debugPrint('  - Message: ${e.message}');
      debugPrint('  - Response: ${e.response?.data}');
      throw Exception('FCM 토큰 등록 실패: ${e.message}');
    }
  }

  /// FCM 토큰 삭제
  Future<void> deleteFcmToken(String fcmToken) async {
    try {
      await _dio.delete('/notifications/token/$fcmToken');
    } on DioException catch (e) {
      throw Exception('FCM 토큰 삭제 실패: ${e.message}');
    }
  }

  /// 알림 설정 조회
  /// 백엔드는 카테고리별 설정 배열을 반환하므로, 이를 단일 객체로 변환
  Future<NotificationSettingsModel> getSettings() async {
    try {
      final response = await _dio.get('/notifications/settings');
      final settingsList = response.data as List;

      // 배열을 Map으로 변환
      final settingsMap = <String, bool>{};
      for (var setting in settingsList) {
        final category = setting['category'] as String?;
        final enabled = setting['enabled'] as bool;
        if (category != null) {
          // SCHEDULE -> scheduleEnabled 형식으로 변환
          final key = '${category.toLowerCase()}Enabled';
          settingsMap[key] = enabled;
        }
      }

      return NotificationSettingsModel.fromJson(settingsMap);
    } on DioException catch (e) {
      throw Exception('알림 설정 조회 실패: ${e.message}');
    }
  }

  /// 알림 설정 저장
  /// 단일 카테고리의 설정을 업데이트
  Future<void> updateSetting({
    required String category,
    required bool enabled,
  }) async {
    try {
      await _dio.put(
        '/notifications/settings',
        data: {
          'category': category,
          'enabled': enabled,
        },
      );
    } on DioException catch (e) {
      throw Exception('알림 설정 저장 실패: ${e.message}');
    }
  }

  /// 알림 히스토리 조회
  Future<Map<String, dynamic>> getHistory({
    int page = 1,
    int limit = 20,
    bool? unreadOnly,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (unreadOnly != null) {
        queryParameters['unreadOnly'] = unreadOnly;
      }

      final response = await _dio.get(
        '/notifications',
        queryParameters: queryParameters,
      );

      final data = response.data['data'] as List;
      final meta = response.data['meta'] as Map<String, dynamic>;

      final notifications = data
          .map((json) => NotificationModel.fromJson(json))
          .toList();

      return {
        'notifications': notifications,
        'meta': meta,
      };
    } on DioException catch (e) {
      throw Exception('알림 히스토리 조회 실패: ${e.message}');
    }
  }

  /// 읽지 않은 알림 개수 조회
  Future<int> getUnreadCount() async {
    try {
      final response = await _dio.get('/notifications/unread-count');
      return response.data['count'] as int;
    } on DioException catch (e) {
      throw Exception('읽지 않은 알림 개수 조회 실패: ${e.message}');
    }
  }

  /// 알림 읽음 처리
  Future<void> markAsRead(String notificationId) async {
    try {
      await _dio.put('/notifications/$notificationId/read');
    } on DioException catch (e) {
      throw Exception('알림 읽음 처리 실패: ${e.message}');
    }
  }

  /// 알림 삭제
  Future<void> deleteNotification(String notificationId) async {
    try {
      await _dio.delete('/notifications/$notificationId');
    } on DioException catch (e) {
      throw Exception('알림 삭제 실패: ${e.message}');
    }
  }

  /// 테스트 알림 전송 (운영자 전용)
  Future<void> sendTestNotification() async {
    try {
      await _dio.post('/notifications/test');
    } on DioException catch (e) {
      throw Exception('테스트 알림 전송 실패: ${e.message}');
    }
  }
}
