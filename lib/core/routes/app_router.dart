import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/home/screens/home_screen.dart';
import 'package:family_planner/features/settings/screens/settings_screen.dart';
import 'package:family_planner/features/settings/screens/home_widget_settings_screen.dart';
import 'package:family_planner/features/settings/screens/theme_settings_screen.dart';
import 'package:family_planner/features/auth/screens/login_screen.dart';
import 'package:family_planner/features/auth/screens/signup_screen.dart';
import 'package:family_planner/features/auth/screens/email_verification_screen.dart';
import 'package:family_planner/features/auth/screens/forgot_password_screen.dart';
import 'package:family_planner/features/auth/providers/auth_provider.dart';

/// GoRouter Provider
final goRouterProvider = Provider<GoRouter>((ref) {
  final notifier = ValueNotifier<bool>(false);

  ref.listen<AuthState>(
    authProvider,
    (previous, next) {
      if (previous?.isAuthenticated != next.isAuthenticated) {
        notifier.value = next.isAuthenticated;
      }
    },
  );

  return GoRouter(
    initialLocation: AppRoutes.login,
    debugLogDiagnostics: true,
    refreshListenable: notifier,
    redirect: (context, state) {
      final isAuthenticated = ref.read(authProvider).isAuthenticated;
      final isLoading = ref.read(authProvider).isLoading;
      final isAuthPage = state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.signup ||
          state.matchedLocation == AppRoutes.emailVerification ||
          state.matchedLocation == AppRoutes.forgotPassword;

      // 로딩 중에는 리다이렉트하지 않음
      if (isLoading) {
        return null;
      }

      // 인증되지 않았고 인증 페이지가 아니면 로그인 페이지로
      if (!isAuthenticated && !isAuthPage) {
        return AppRoutes.login;
      }

      // 인증되었고 인증 페이지에 있으면 홈으로
      if (isAuthenticated && isAuthPage) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      // Auth Routes
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        name: 'signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: AppRoutes.emailVerification,
        name: 'emailVerification',
        builder: (context, state) {
          final email = state.extra as String?;
          return EmailVerificationScreen(
            email: email ?? '',
          );
        },
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: 'forgotPassword',
        builder: (context, state) => const ForgotPasswordScreen(),
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
});

/// 레거시 지원을 위한 AppRouter 클래스
class AppRouter {
  AppRouter._();

  /// GoRouter Provider를 통해 router에 접근
  /// 더 이상 사용되지 않음 - goRouterProvider를 직접 사용하세요
  @Deprecated('Use goRouterProvider instead')
  static GoRouter? get router => null;
}
