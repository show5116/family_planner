import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';

import 'package:family_planner/features/home/providers/dashboard_provider.dart';

/// [HomeWidgetLinkService] 싱글턴 Provider
final homeWidgetLinkServiceProvider = Provider<HomeWidgetLinkService>((ref) {
  return HomeWidgetLinkService(ref);
});

/// 홈 화면(OS) 위젯 탭 시 발생하는 딥링크를 처리한다.
///
/// 위젯 URI(`familyplanner://widget/<tabId>`)를 파싱해 [homeTabNavigationProvider]에
/// 반영하면, home_screen.dart가 자동으로 해당 탭으로 이동시킨다.
class HomeWidgetLinkService {
  HomeWidgetLinkService(this._ref);

  final Ref _ref;
  Uri? _pendingUri;

  /// 앱 초기화 시 호출
  Future<void> init() async {
    if (kIsWeb) return;

    HomeWidget.widgetClicked.listen(_handleUri, onError: (_) {});

    try {
      final initialUri = await HomeWidget.initiallyLaunchedFromHomeWidget();
      if (initialUri != null) {
        _pendingUri = initialUri;
      }
    } catch (_) {}
  }

  /// 홈 화면 준비 후 pending 링크 처리
  void handlePendingLink() {
    final uri = _pendingUri;
    if (uri == null) return;
    _pendingUri = null;
    _handleUri(uri);
  }

  void _handleUri(Uri? uri) {
    if (uri == null) return;
    if (uri.scheme != 'familyplanner' || uri.host != 'widget') return;

    final tabId = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
    if (tabId == null || tabId.isEmpty) return;

    _ref.read(homeTabNavigationProvider.notifier).state = tabId;
  }
}
