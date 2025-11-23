import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/home/screens/home_screen.dart';
import 'package:family_planner/features/settings/screens/settings_screen.dart';
import 'package:family_planner/features/settings/screens/home_widget_settings_screen.dart';
import 'package:family_planner/features/settings/screens/theme_settings_screen.dart';
import 'package:family_planner/features/settings/screens/language_settings_screen.dart';
import 'package:family_planner/features/auth/screens/login_screen.dart';
import 'package:family_planner/features/auth/screens/signup_screen.dart';
import 'package:family_planner/features/auth/screens/email_verification_screen.dart';
import 'package:family_planner/features/auth/screens/forgot_password_screen.dart';
import 'package:family_planner/features/auth/screens/oauth_callback_screen.dart';
import 'package:family_planner/features/auth/screens/splash_screen.dart';
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
    initialLocation: AppRoutes.home, // 홈을 기본 위치로 설정
    debugLogDiagnostics: true,
    refreshListenable: notifier,
    redirect: (context, state) {
      final isAuthenticated = ref.read(authProvider).isAuthenticated;
      final isLoading = ref.read(authProvider).isLoading;

      debugPrint('=== GoRouter Redirect ===');
      debugPrint('Location: ${state.matchedLocation}');
      debugPrint('URI: ${state.uri}');
      debugPrint('isAuthenticated: $isAuthenticated');
      debugPrint('isLoading: $isLoading');

      final isAuthPage = state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.signup ||
          state.matchedLocation == AppRoutes.emailVerification ||
          state.matchedLocation == AppRoutes.forgotPassword ||
          state.matchedLocation.startsWith('/auth/callback');

      debugPrint('isAuthPage: $isAuthPage');

      // 로딩 중에는 리다이렉트하지 않음 (토큰 확인 중)
      if (isLoading) {
        debugPrint('Redirect: null (loading)');
        return null;
      }

      // 인증되지 않았고 인증 페이지가 아니면 로그인 페이지로
      if (!isAuthenticated && !isAuthPage) {
        debugPrint('Redirect: ${AppRoutes.login} (not authenticated, not auth page)');
        return AppRoutes.login;
      }

      // 인증되었고 인증 페이지에 있으면 홈으로
      if (isAuthenticated && isAuthPage) {
        debugPrint('Redirect: ${AppRoutes.home} (authenticated, on auth page)');
        return AppRoutes.home;
      }

      debugPrint('Redirect: null (no redirect needed)');
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
      GoRoute(
        path: AppRoutes.oauthCallback,
        name: 'oauthCallback',
        builder: (context, state) {
          // 디버깅: 받은 URL 전체 출력
          debugPrint('=== OAuth Callback Route Builder ===');
          debugPrint('OAuth Callback URL: ${state.uri}');
          debugPrint('Path: ${state.path}');
          debugPrint('MatchedLocation: ${state.matchedLocation}');
          debugPrint('Query Parameters: ${state.uri.queryParameters}');

          final accessToken = state.uri.queryParameters['accessToken'];
          final refreshToken = state.uri.queryParameters['refreshToken'];

          debugPrint('Access Token exists: ${accessToken != null}');
          debugPrint('Refresh Token exists: ${refreshToken != null}');

          if (accessToken == null || refreshToken == null) {
            // 토큰이 없으면 로그인 화면으로
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('잘못된 OAuth 콜백입니다'),
                    const SizedBox(height: 16),
                    Text(
                      'URL: ${state.uri}',
                      style: const TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Query Parameters: ${state.uri.queryParameters}',
                      style: const TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.go(AppRoutes.login),
                      child: const Text('로그인 화면으로 돌아가기'),
                    ),
                  ],
                ),
              ),
            );
          }

          return OAuthCallbackScreen(
            accessToken: accessToken,
            refreshToken: refreshToken,
          );
        },
      ),

      // Main Routes with Bottom Navigation
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) {
          // 로딩 중이면 스플래시 화면 표시
          final isLoading = ref.read(authProvider).isLoading;
          if (isLoading) {
            return const SplashScreen();
          }
          return const HomeScreen();
        },
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
      GoRoute(
        path: AppRoutes.language,
        name: 'language',
        builder: (context, state) => const LanguageSettingsScreen(),
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
