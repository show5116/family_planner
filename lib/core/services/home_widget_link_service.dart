import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:home_widget/home_widget.dart';

import 'package:family_planner/core/routes/app_router.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/auth/providers/auth_provider.dart';
import 'package:family_planner/features/home/providers/dashboard_provider.dart';
import 'package:family_planner/features/main/task/providers/task_provider.dart';
import 'package:family_planner/features/onboarding/providers/onboarding_provider.dart';

/// [HomeWidgetLinkService] 싱글턴 Provider
final homeWidgetLinkServiceProvider = Provider<HomeWidgetLinkService>((ref) {
  return HomeWidgetLinkService(ref);
});

/// 홈 화면(OS) 위젯 탭 시 발생하는 딥링크를 처리한다.
///
/// 지원하는 위젯 URI:
/// - `familyplanner://widget/calendar` — 캘린더 탭으로 이동
/// - `familyplanner://widget/calendar?date=2026-07-15` — 해당 날짜를 선택한 채 캘린더 탭으로 이동
/// - `familyplanner://widget/task?id=<taskId>` — 일정 상세 화면으로 바로 이동
/// - `familyplanner://widget/add` — 일정 추가 화면으로 바로 이동 (오늘 날짜 기본 선택)
/// - `familyplanner://widget/add?date=2026-07-15` — 해당 날짜를 기본 선택한 채 일정 추가 화면으로 이동
class HomeWidgetLinkService {
  HomeWidgetLinkService(this._ref);

  final Ref _ref;
  Uri? _pendingUri;

  /// 앱 초기화 시 호출
  Future<void> init() async {
    if (kIsWeb) return;

    HomeWidget.widgetClicked.listen(
      _handleUri,
      onError: (Object e) => debugPrint('🔴 [HomeWidgetLink] widgetClicked 스트림 오류: $e'),
    );

    try {
      final initialUri = await HomeWidget.initiallyLaunchedFromHomeWidget();
      if (initialUri != null) {
        _pendingUri = initialUri;
      }
    } catch (e) {
      debugPrint('🔴 [HomeWidgetLink] initiallyLaunchedFromHomeWidget 실패: $e');
    }
  }

  /// 홈 화면 준비 후 pending 링크 처리
  void handlePendingLink() {
    final uri = _pendingUri;
    if (uri == null) return;
    _pendingUri = null;
    _handleUri(uri);
  }

  void _handleUri(Uri? uri) {
    if (uri == null) {
      debugPrint('🟡 [HomeWidgetLink] 수신 URI가 null');
      return;
    }
    if (uri.scheme != 'familyplanner' || uri.host != 'widget') {
      debugPrint('🟡 [HomeWidgetLink] 알 수 없는 scheme/host 무시: $uri');
      return;
    }

    final target = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
    if (target == null || target.isEmpty) {
      debugPrint('🟡 [HomeWidgetLink] path segment 없음: $uri');
      return;
    }

    switch (target) {
      case 'task':
        _openTaskDetail(uri.queryParameters['id']);
      case 'calendar':
        _openCalendar(dateString: uri.queryParameters['date']);
      case 'add':
        _openAddTask(dateString: uri.queryParameters['date']);
      default:
        // 그 외(예: 'todo')는 기존처럼 탭 전환만 수행
        _ref.read(homeTabNavigationProvider.notifier).state = target;
    }
  }

  void _openCalendar({String? dateString}) {
    if (dateString != null) {
      final date = DateTime.tryParse(dateString);
      if (date != null) {
        _ref.read(selectedDateProvider.notifier).state = date;
        _ref.read(focusedMonthProvider.notifier).state = date;
      }
    }
    _ref.read(homeTabNavigationProvider.notifier).state = 'calendar';
  }

  void _openTaskDetail(String? taskId) {
    if (taskId == null || taskId.isEmpty) {
      _openCalendar();
      return;
    }

    _pushWhenRouterReady(
      () => AppRouter.navigatorKey.currentContext?.push(
        AppRoutes.calendarDetail,
        extra: {'taskId': taskId},
      ),
    );
  }

  void _openAddTask({String? dateString}) {
    final initialDate = dateString != null ? DateTime.tryParse(dateString) : null;

    _pushWhenRouterReady(
      () => AppRouter.navigatorKey.currentContext?.push(
        AppRoutes.calendarAdd,
        extra: {
          if (initialDate != null) 'date': initialDate,
        },
      ),
    );
  }

  /// 로그인/온보딩 상태가 아직 확정되지 않은 시점(둘 다 null)에 push하면
  /// 직후 router의 redirect가 재평가되며 방금 push한 화면이 밀려날 수 있다.
  /// 상태가 확정될 때까지 최대 [_routerReadyTimeout] 동안 짧게 재시도한다.
  void _pushWhenRouterReady(void Function() push, {DateTime? deadline}) {
    final isAuthResolved = _ref.read(authProvider).isAuthenticated != null;
    final isOnboardingResolved = _ref.read(onboardingProvider) != null;

    if (isAuthResolved && isOnboardingResolved) {
      push();
      return;
    }

    final effectiveDeadline = deadline ?? DateTime.now().add(_routerReadyTimeout);
    if (DateTime.now().isAfter(effectiveDeadline)) {
      // 타임아웃 시에도 최선을 다해 push (redirect가 다시 채가더라도 무동작보다는 낫다)
      push();
      return;
    }

    Future.delayed(_routerReadyPollInterval, () {
      _pushWhenRouterReady(push, deadline: effectiveDeadline);
    });
  }

  static const _routerReadyTimeout = Duration(seconds: 5);
  static const _routerReadyPollInterval = Duration(milliseconds: 100);
}
