import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/repositories/notification_repository.dart';
import '../data/services/firebase_messaging_service.dart';

part 'fcm_token_provider.g.dart';

/// FCM 토큰 Provider
@riverpod
class FcmToken extends _$FcmToken {
  @override
  Future<String?> build() async {
    // FCM 토큰 가져오기
    final token = await FirebaseMessagingService.getToken();

    // 백엔드에 토큰 등록
    if (token != null) {
      await _registerToken(token);
    }

    return token;
  }

  /// 토큰을 백엔드에 등록
  Future<void> _registerToken(String fcmToken) async {
    try {
      final repository = ref.read(notificationRepositoryProvider);
      await repository.registerFcmToken(
        fcmToken: fcmToken,
        platform: _getPlatform(),
      );
      debugPrint('FCM 토큰 백엔드 등록 완료');
    } catch (e) {
      debugPrint('FCM 토큰 백엔드 등록 실패: $e');
    }
  }

  /// 토큰 갱신
  Future<void> refreshToken() async {
    final newToken = await FirebaseMessagingService.getToken();
    if (newToken != null) {
      await _registerToken(newToken);
      state = AsyncValue.data(newToken);
    }
  }

  /// 토큰 삭제
  Future<void> deleteToken() async {
    try {
      // Firebase에서 토큰 삭제
      await FirebaseMessagingService.deleteToken();

      // 백엔드에서 토큰 삭제
      final repository = ref.read(notificationRepositoryProvider);
      await repository.deleteFcmToken();

      state = const AsyncValue.data(null);
      debugPrint('FCM 토큰 삭제 완료');
    } catch (e) {
      debugPrint('FCM 토큰 삭제 실패: $e');
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// 플랫폼 문자열 반환
  String _getPlatform() {
    if (kIsWeb) {
      return 'web';
    } else if (Platform.isAndroid) {
      return 'android';
    } else if (Platform.isIOS) {
      return 'ios';
    }
    return 'unknown';
  }
}
