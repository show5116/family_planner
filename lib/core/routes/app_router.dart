import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/home/screens/home_screen.dart';
import 'package:family_planner/features/settings/screens/settings_screen.dart';
import 'package:family_planner/features/settings/screens/home_widget_settings_screen.dart';
import 'package:family_planner/features/settings/screens/theme_settings_screen.dart';
import 'package:family_planner/features/auth/screens/login_screen.dart';

/// Family Planner 앱의 라우터 설정
/// go_router를 사용한 선언적 라우팅
class AppRouter {
  AppRouter._(); // Private constructor

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: true,
    routes: [
      // Auth Routes
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      // Main Routes with Bottom Navigation
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),

      // Settings Routes
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.homeWidgetSettings,
        name: 'homeWidgetSettings',
        builder: (context, state) => const HomeWidgetSettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.theme,
        name: 'theme',
        builder: (context, state) => const ThemeSettingsScreen(),
      ),

      // Assets Routes (추후 구현)
      // GoRoute(
      //   path: AppRoutes.assets,
      //   name: 'assets',
      //   builder: (context, state) => const AssetsScreen(),
      // ),

      // Calendar Routes (추후 구현)
      // GoRoute(
      //   path: AppRoutes.calendar,
      //   name: 'calendar',
      //   builder: (context, state) => const CalendarScreen(),
      // ),

      // Todo Routes (추후 구현)
      // GoRoute(
      //   path: AppRoutes.todo,
      //   name: 'todo',
      //   builder: (context, state) => const TodoScreen(),
      // ),

      // More/Settings Routes (추후 구현)
      // GoRoute(
      //   path: AppRoutes.more,
      //   name: 'more',
      //   builder: (context, state) => const MoreScreen(),
      // ),
    ],

    // Error Page
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('오류'),
      ),
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
}
