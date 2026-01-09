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
    debugPrint('=== FcmToken.build() 시작 ===');

    // FCM 토큰 가져오기만 수행 (백엔드 등록은 하지 않음)
    // 백엔드 등록은 로그인 성공 후 refreshToken()을 통해 명시적으로 수행
    final token = await FirebaseMessagingService.getToken();
    debugPrint('FCM 토큰 가져오기 결과: ${token != null ? "성공 (${token.substring(0, 20)}...)" : "실패 (null)"}');

    if (token == null && kIsWeb) {
      debugPrint('ℹ️ 웹 개발 환경에서는 FCM 토큰이 없어도 정상입니다');
    }

    debugPrint('=== FcmToken.build() 완료 (백엔드 등록 안함) ===');
    return token;
  }

  /// 토큰을 백엔드에 등록
  Future<void> _registerToken(String fcmToken) async {
    try {
      debugPrint('_registerToken 시작: platform=${_getPlatform()}');
      final repository = ref.read(notificationRepositoryProvider);
      debugPrint('NotificationRepository 가져옴, API 호출 시작...');

      await repository.registerFcmToken(
        fcmToken: fcmToken,
        platform: _getPlatform(),
      );

      debugPrint('✅ FCM 토큰 백엔드 등록 완료');
    } catch (e, stackTrace) {
      debugPrint('❌ FCM 토큰 백엔드 등록 실패: $e');
      debugPrint('StackTrace: $stackTrace');
    }
  }

  /// 토큰 갱신
  Future<void> refreshToken() async {
    debugPrint('=== FcmToken.refreshToken() 호출됨 ===');

    final newToken = await FirebaseMessagingService.getToken();
    debugPrint('refreshToken - FCM 토큰: ${newToken != null ? "존재 (${newToken.substring(0, 20)}...)" : "null"}');

    if (newToken != null) {
      await _registerToken(newToken);
      state = AsyncValue.data(newToken);
      debugPrint('✅ refreshToken 완료 - state 업데이트됨');
    } else {
      if (kIsWeb) {
        debugPrint('ℹ️ 웹 개발 환경에서는 FCM 토큰이 없어도 정상입니다');
      } else {
        debugPrint('⚠️ refreshToken - FCM 토큰이 null이므로 등록하지 않음');
      }
    }
  }

  /// 토큰 삭제
  Future<void> deleteToken() async {
    try {
      final currentToken = await future;
      if (currentToken == null) {
        debugPrint('삭제할 FCM 토큰이 없습니다');
        return;
      }

      // Firebase에서 토큰 삭제
      await FirebaseMessagingService.deleteToken();

      // 백엔드에서 토큰 삭제
      final repository = ref.read(notificationRepositoryProvider);
      await repository.deleteFcmToken(currentToken);

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
      return 'WEB';
    } else if (Platform.isAndroid) {
      return 'ANDROID';
    } else if (Platform.isIOS) {
      return 'IOS';
    }
    return 'UNKNOWN';
  }
}
