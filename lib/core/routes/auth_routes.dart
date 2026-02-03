import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/auth/presentation/screens/login_screen.dart';
import 'package:family_planner/features/auth/presentation/screens/signup_screen.dart';
import 'package:family_planner/features/auth/presentation/screens/email_verification_screen.dart';
import 'package:family_planner/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:family_planner/features/auth/presentation/screens/oauth_callback_screen.dart';
import 'package:family_planner/features/auth/presentation/screens/splash_screen.dart';

/// 인증 관련 라우트 목록
///
/// 포함되는 화면:
/// - Splash (앱 시작 화면)
/// - Login (로그인)
/// - Signup (회원가입)
/// - Email Verification (이메일 인증)
/// - Forgot Password (비밀번호 찾기/변경)
/// - OAuth Callback (소셜 로그인 콜백)
List<RouteBase> getAuthRoutes() {
  return [
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
        final email =
            state.uri.queryParameters['email'] ?? (state.extra as String?);
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
        final accessToken = state.uri.queryParameters['accessToken'];
        final refreshToken = state.uri.queryParameters['refreshToken'];

        // 웹 환경에서는 RefreshToken이 HTTP Only Cookie로 전달되므로
        // accessToken만 있어도 정상입니다
        if (accessToken == null) {
          // AccessToken이 없으면 로그인 화면으로
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

        // 웹: accessToken만 쿼리로 전달, refreshToken은 쿠키
        // 모바일: accessToken, refreshToken 모두 쿼리로 전달
        return OAuthCallbackScreen(
          accessToken: accessToken,
          refreshToken: refreshToken, // 웹에서는 null일 수 있음 (쿠키로 관리)
        );
      },
    ),
  ];
}
