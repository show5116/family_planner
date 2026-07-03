import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:family_planner/core/routes/app_router.dart';

/// 딥링크 처리 서비스
///
/// familyplanner.hmncorp.org 도메인으로 들어오는 Universal Links (iOS) /
/// App Links (Android)를 GoRouter로 라우팅합니다.
class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  static const _appDomain = 'familyplanner.hmncorp.org';
  final _appLinks = AppLinks();

  // 앱 종료 상태에서 딥링크로 실행된 경우 라우터 준비 전까지 보관
  static Uri? _pendingUri;

  /// 앱 초기화 시 호출 (main.dart postFrameCallback)
  Future<void> init() async {
    if (kIsWeb) return;

    // 앱 실행 중 수신되는 딥링크
    _appLinks.uriLinkStream.listen(
      (uri) => _handleUri(uri),
      onError: (_) {},
    );

    // 앱 종료 상태에서 딥링크로 실행된 경우
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null && initialUri.host == _appDomain) {
        _pendingUri = initialUri;
      }
    } catch (_) {}
  }

  /// 홈 화면 준비 후 pending 딥링크 처리 (home_screen.dart에서 호출)
  static void handlePendingDeepLink() {
    final uri = _pendingUri;
    if (uri == null) return;
    _pendingUri = null;
    _instance._handleUri(uri);
  }

  void _handleUri(Uri uri) {
    if (uri.host != _appDomain) return;
    if (!uri.path.startsWith('/dl')) return;

    final context = AppRouter.navigatorKey.currentContext;
    if (context == null) return;

    // /dl prefix 제거 후 GoRouter에 전달
    final strippedPath = uri.path.replaceFirst('/dl', '');
    final path = strippedPath.isEmpty ? '/' : strippedPath;
    final query = uri.query.isNotEmpty ? '?${uri.query}' : '';
    GoRouter.of(context).go('$path$query');
  }
}
