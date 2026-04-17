import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:family_planner/features/notification/data/repositories/notification_repository.dart';
import 'package:family_planner/features/notification/data/services/firebase_messaging_service.dart';

part 'fcm_token_provider.g.dart';

/// FCM 토큰 Provider
@riverpod
class FcmToken extends _$FcmToken {
  @override
  Future<String?> build() async {
    // FCM 토큰 가져오기만 수행 (백엔드 등록은 하지 않음)
    // 백엔드 등록은 로그인 성공 후 refreshToken()을 통해 명시적으로 수행
    return await FirebaseMessagingService.getToken();
  }

  /// 토큰을 백엔드에 등록
  Future<void> _registerToken(String fcmToken) async {
    try {
      final repository = ref.read(notificationRepositoryProvider);
      await repository.registerFcmToken(
        fcmToken: fcmToken,
        platform: _getPlatform(),
      );
    } catch (e) {
      // 등록 실패 무시 (로그인 자체를 막지 않음)
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
      final currentToken = await future.timeout(
        const Duration(seconds: 5),
        onTimeout: () => null,
      );
      if (currentToken == null) return;

      await FirebaseMessagingService.deleteToken();

      final repository = ref.read(notificationRepositoryProvider);
      await repository.deleteFcmToken(currentToken);

      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// 플랫폼 문자열 반환
  String _getPlatform() {
    if (kIsWeb) {
      return 'WEB';
    } else if (Platform.isAndroid) {
      return 'ANDROID';
    } else if (Platform.isIOS) {
      return 'IOS';
    }
    return 'UNKNOWN';
  }
}
