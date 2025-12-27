import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/environment.dart';
import '../../../auth/providers/auth_provider.dart';
import '../models/notification_model.dart';
import '../models/notification_settings_model.dart';

/// 알림 Repository Provider
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final authState = ref.watch(authProvider);
  final token = authState.user?['accessToken'] as String?;

  return NotificationRepository(token: token);
});

/// 알림 Repository
class NotificationRepository {
  final String? token;
  late final Dio _dio;

  NotificationRepository({this.token}) {
    _dio = Dio(BaseOptions(
      baseUrl: EnvironmentConfig.apiBaseUrl,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    ));
  }

  /// FCM 토큰 등록
  Future<void> registerFcmToken({
    required String fcmToken,
    required String platform,
  }) async {
    try {
      await _dio.post('/api/notifications/token', data: {
        'fcmToken': fcmToken,
        'platform': platform,
      });
    } on DioException catch (e) {
      throw Exception('FCM 토큰 등록 실패: ${e.message}');
    }
  }

  /// FCM 토큰 삭제
  Future<void> deleteFcmToken() async {
    try {
      await _dio.delete('/api/notifications/token');
    } on DioException catch (e) {
      throw Exception('FCM 토큰 삭제 실패: ${e.message}');
    }
  }

  /// 알림 설정 조회
  Future<NotificationSettingsModel> getSettings() async {
    try {
      final response = await _dio.get('/api/notifications/settings');
      return NotificationSettingsModel.fromJson(response.data['settings']);
    } on DioException catch (e) {
      throw Exception('알림 설정 조회 실패: ${e.message}');
    }
  }

  /// 알림 설정 저장
  Future<NotificationSettingsModel> updateSettings(
    NotificationSettingsModel settings,
  ) async {
    try {
      final response = await _dio.put(
        '/api/notifications/settings',
        data: settings.toJson(),
      );
      return NotificationSettingsModel.fromJson(response.data['settings']);
    } on DioException catch (e) {
      throw Exception('알림 설정 저장 실패: ${e.message}');
    }
  }

  /// 알림 히스토리 조회
  Future<List<NotificationModel>> getHistory({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        '/api/notifications/history',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      final notifications = response.data['notifications'] as List;
      return notifications
          .map((json) => NotificationModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception('알림 히스토리 조회 실패: ${e.message}');
    }
  }

  /// 알림 읽음 처리
  Future<void> markAsRead(String notificationId) async {
    try {
      await _dio.put('/api/notifications/$notificationId/read');
    } on DioException catch (e) {
      throw Exception('알림 읽음 처리 실패: ${e.message}');
    }
  }
}
