import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/home/screens/home_screen.dart';
import 'package:family_planner/features/settings/screens/settings_screen.dart';
import 'package:family_planner/features/settings/screens/bottom_navigation_settings_screen.dart';
import 'package:family_planner/features/settings/screens/home_widget_settings_screen.dart';
import 'package:family_planner/features/settings/screens/theme_settings_screen.dart';
import 'package:family_planner/features/settings/screens/language_settings_screen.dart';
import 'package:family_planner/features/settings/screens/profile_settings_screen.dart';
import 'package:family_planner/features/settings/screens/permission_management_screen.dart';
import 'package:family_planner/features/groups/screens/group_list_screen.dart';
import 'package:family_planner/features/auth/screens/login_screen.dart';
import 'package:family_planner/features/auth/screens/signup_screen.dart';
import 'package:family_planner/features/auth/screens/email_verification_screen.dart';
import 'package:family_planner/features/auth/screens/forgot_password_screen.dart';
import 'package:family_planner/features/auth/screens/oauth_callback_screen.dart';
import 'package:family_planner/features/auth/screens/splash_screen.dart';
import 'package:family_planner/features/auth/providers/auth_provider.dart';

/// GoRouter Provider
final goRouterProvider = Provider<GoRouter>((ref) {
  final notifier = ValueNotifier<int>(0);

  ref.listen<AuthState>(authProvider, (previous, next) {
    debugPrint('=== GoRouter: AuthState changed ===');
    debugPrint('Previous: ${previous?.isAuthenticated}');
    debugPrint('Next: ${next.isAuthenticated}');

    if (previous?.isAuthenticated != next.isAuthenticated) {
      // ValueNotifier 값을 변경하여 GoRouter가 redirect를 재실행하도록 트리거
      notifier.value++;
      debugPrint('GoRouter refreshListenable triggered: ${notifier.value}');
    }
  });

  return GoRouter(
    initialLocation: AppRoutes.splash, // 스플래시 화면을 기본 위치로 설정
    debugLogDiagnostics: true,
    refreshListenable: notifier,
    redirect: (context, state) {
      final isAuthenticated = ref.read(authProvider).isAuthenticated;

      debugPrint('=== GoRouter Redirect ===');
      debugPrint('Location: ${state.matchedLocation}');
      debugPrint('URI: ${state.uri}');
      debugPrint('Query Parameters: ${state.uri.queryParameters}');
      debugPrint('isAuthenticated: $isAuthenticated');

      // OAuth 콜백 페이지인 경우, 팝업이면 redirect 건너뛰기
      if (state.matchedLocation.startsWith('/auth/callback')) {
        debugPrint('OAuth callback route - checking if popup...');
        // 팝업 여부는 OAuthCallbackScreen에서 처리하므로 redirect 없이 진행
        return null;
      }

      // 비밀번호 설정 모드인 경우 (인증된 사용자가 접근 가능)
      final isPasswordSetup = state.matchedLocation == AppRoutes.forgotPassword &&
          state.uri.queryParameters['setup'] == 'true';

      final isAuthPage =
          state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.signup ||
          state.matchedLocation == AppRoutes.emailVerification ||
          state.matchedLocation == AppRoutes.forgotPassword;

      final isSplashPage = state.matchedLocation == AppRoutes.splash;

      debugPrint('isAuthPage: $isAuthPage');
      debugPrint('isPasswordSetup: $isPasswordSetup');
      debugPrint('isSplashPage: $isSplashPage');

      // 인증 상태가 null (초기/로딩 상태)이면 스플래시 화면으로
      if (isAuthenticated == null && !isSplashPage) {
        debugPrint('Redirect: ${AppRoutes.splash} (initial/loading state)');
        return AppRoutes.splash;
      }

      // 인증 상태 확인 완료 후 스플래시 화면에 있으면 적절한 페이지로 리다이렉트
      if (isAuthenticated != null && isSplashPage) {
        if (isAuthenticated) {
          debugPrint(
            'Redirect: ${AppRoutes.home} (loading finished, authenticated)',
          );
          return AppRoutes.home;
        } else {
          debugPrint(
            'Redirect: ${AppRoutes.login} (loading finished, not authenticated)',
          );
          return AppRoutes.login;
        }
      }

      // 인증되지 않았고 인증 페이지가 아니면 로그인 페이지로
      if (isAuthenticated == false && !isAuthPage) {
        debugPrint(
          'Redirect: ${AppRoutes.login} (not authenticated, not auth page)',
        );
        return AppRoutes.login;
      }

      // 인증되었고 인증 페이지에 있으면 홈으로 (단, 비밀번호 설정 모드는 예외)
      if (isAuthenticated == true && isAuthPage && !isPasswordSetup) {
        debugPrint('Redirect: ${AppRoutes.home} (authenticated, on auth page)');
        return AppRoutes.home;
      }

      debugPrint('Redirect: null (no redirect needed)');
      return null;
    },
    routes: [
      // Auth Routes
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
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
          // 쿼리 파라미터에서 이메일 가져오기
          final email =
              state.uri.queryParameters['email'] ??
              (state.extra as String?) ??
              '';
          return EmailVerificationScreen(email: email);
        },
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: 'forgotPassword',
        builder: (context, state) {
          // 쿼리 파라미터에서 비밀번호 설정 모드 여부 가져오기
          final isNewPasswordSetup =
              state.uri.queryParameters['setup'] == 'true';
          // 이메일 가져오기 (쿼리 파라미터 또는 extra에서)
          final email = state.uri.queryParameters['email'] ??
              (state.extra as String?);
          return ForgotPasswordScreen(
            isNewPasswordSetup: isNewPasswordSetup,
            email: email,
          );
        },
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
        builder: (context, state) => const HomeScreen(),
      ),

      // Settings Routes
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.bottomNavigationSettings,
        name: 'bottomNavigationSettings',
        builder: (context, state) => const BottomNavigationSettingsScreen(),
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
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        builder: (context, state) => const ProfileSettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.groupManagement,
        name: 'groupManagement',
        builder: (context, state) => const GroupListScreen(),
      ),

      // Admin Routes
      GoRoute(
        path: AppRoutes.permissionManagement,
        name: 'permissionManagement',
        builder: (context, state) => const PermissionManagementScreen(),
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
