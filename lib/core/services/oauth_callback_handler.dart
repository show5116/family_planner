import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:app_links/app_links.dart';
import 'package:family_planner/core/services/secure_storage_service.dart';

/// OAuth 콜백 핸들러
/// Universal Links (iOS) / App Links (Android) / Web 라우팅을 통해
/// 백엔드로부터 전달받은 토큰을 처리합니다.
class OAuthCallbackHandler {
  // Singleton 패턴
  static final OAuthCallbackHandler _instance = OAuthCallbackHandler._internal();
  factory OAuthCallbackHandler() => _instance;
  OAuthCallbackHandler._internal();

  final _secureStorage = SecureStorageService();
  final _appLinks = AppLinks();

  // 콜백 처리 완료 알림을 위한 StreamController
  final _callbackController = StreamController<OAuthCallbackResult>.broadcast();

  /// 콜백 결과를 받을 수 있는 Stream
  Stream<OAuthCallbackResult> get callbackStream => _callbackController.stream;

  /// Deep Link 리스너 초기화 (모바일 전용)
  /// 앱이 시작될 때 호출하여 Deep Link를 수신 대기합니다.
  Future<void> initDeepLinkListener() async {
    if (kIsWeb) {
      // 웹에서는 라우터가 직접 처리하므로 Deep Link 리스너 불필요
      return;
    }

    // 1. 앱이 실행 중일 때 받은 Deep Link 처리
    _appLinks.uriLinkStream.listen(
      (uri) {
        debugPrint('Deep Link received: $uri');
        _handleDeepLink(uri);
      },
      onError: (err) {
        debugPrint('Deep Link error: $err');
      },
    );

    // 2. 앱이 종료된 상태에서 Deep Link로 실행된 경우 처리
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        debugPrint('Initial Deep Link: $initialUri');
        _handleDeepLink(initialUri);
      }
    } catch (e) {
      debugPrint('Failed to get initial link: $e');
    }
  }

  /// Deep Link URI 처리
  void _handleDeepLink(Uri uri) {
    // OAuth 콜백인지 확인
    if (uri.path == '/auth/callback') {
      final accessToken = uri.queryParameters['accessToken'];
      final refreshToken = uri.queryParameters['refreshToken'];

      if (accessToken != null && refreshToken != null) {
        handleOAuthCallback(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
      } else {
        _callbackController.add(
          OAuthCallbackResult.error('토큰이 누락되었습니다'),
        );
      }
    }
  }

  /// OAuth 콜백 처리 (웹 및 모바일 공통)
  ///
  /// 웹에서는 라우터에서 직접 호출하고,
  /// 모바일에서는 Deep Link 리스너가 호출합니다.
  Future<void> handleOAuthCallback({
    required String accessToken,
    required String refreshToken,
  }) async {
    try {
      debugPrint('=== OAuth Callback Handler ===');
      debugPrint('Access Token: ${accessToken.substring(0, 20)}...');
      debugPrint('Refresh Token: ${refreshToken.substring(0, 20)}...');

      // 1. 토큰 저장
      await _secureStorage.saveAccessToken(accessToken);
      await _secureStorage.saveRefreshToken(refreshToken);

      debugPrint('OAuth tokens saved successfully');

      // 2. 성공 알림
      _callbackController.add(
        OAuthCallbackResult.success(
          accessToken: accessToken,
          refreshToken: refreshToken,
        ),
      );
      debugPrint('OAuth success event sent to stream');
    } catch (e) {
      debugPrint('Failed to save OAuth tokens: $e');
      _callbackController.add(
        OAuthCallbackResult.error(e.toString()),
      );
    }
  }

  /// 리소스 정리
  void dispose() {
    _callbackController.close();
  }
}

/// OAuth 콜백 처리 결과
class OAuthCallbackResult {
  final bool isSuccess;
  final String? accessToken;
  final String? refreshToken;
  final String? error;

  OAuthCallbackResult._({
    required this.isSuccess,
    this.accessToken,
    this.refreshToken,
    this.error,
  });

  factory OAuthCallbackResult.success({
    required String accessToken,
    required String refreshToken,
  }) {
    return OAuthCallbackResult._(
      isSuccess: true,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  factory OAuthCallbackResult.error(String error) {
    return OAuthCallbackResult._(
      isSuccess: false,
      error: error,
    );
  }
}
