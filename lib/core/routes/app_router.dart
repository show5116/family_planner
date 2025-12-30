import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/core/routes/router_redirect.dart';
import 'package:family_planner/core/routes/auth_routes.dart';
import 'package:family_planner/core/routes/main_routes.dart';
import 'package:family_planner/core/routes/settings_routes.dart';
import 'package:family_planner/core/routes/admin_routes.dart';
import 'package:family_planner/core/routes/announcement_routes.dart';
import 'package:family_planner/core/routes/qna_routes.dart';
import 'package:family_planner/features/auth/providers/auth_provider.dart';

/// GoRouter Provider
final goRouterProvider = Provider<GoRouter>((ref) {
  final notifier = ValueNotifier<int>(0);
  ref.onDispose(() {
    notifier.dispose();
  });

  ref.listen<AuthState>(authProvider, (previous, next) {
    if (previous?.isAuthenticated != next.isAuthenticated) {
      notifier.value++;
    }
  });

  return GoRouter(
    initialLocation: AppRoutes.splash, // 스플래시 화면을 기본 위치로 설정
    debugLogDiagnostics: true,
    refreshListenable: notifier,

    redirect: (context, state) => handleRouterRedirect(context, state, ref),

    routes: [
      // Auth Routes (인증 관련)
      ...getAuthRoutes(),

      // Main Routes (메인 기능)
      ...getMainRoutes(),

      // Settings Routes (설정)
      ...getSettingsRoutes(),

      // Admin Routes (관리자)
      ...getAdminRoutes(),

      // Announcement Routes (공지사항)
      ...getAnnouncementRoutes(),

      // QnA Routes (Q&A)
      ...getQnaRoutes(),
    ],

    // Error Page
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('오류')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              '페이지를 찾을 수 없습니다',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              state.uri.toString(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('홈으로 돌아가기'),
            ),
          ],
        ),
      ),
    ),
  );
});

/// 레거시 지원을 위한 AppRouter 클래스
class AppRouter {
  AppRouter._();

  /// GoRouter Provider를 통해 router에 접근
  /// 더 이상 사용되지 않음 - goRouterProvider를 직접 사용하세요
  @Deprecated('Use goRouterProvider instead')
  static GoRouter? get router => null;
}
