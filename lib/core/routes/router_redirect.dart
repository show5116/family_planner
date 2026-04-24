import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/auth/providers/auth_provider.dart';
import 'package:family_planner/features/onboarding/providers/onboarding_provider.dart';

/// GoRouter의 redirect 로직을 처리하는 함수
///
/// 인증 상태에 따라 적절한 페이지로 리다이렉트합니다:
/// - 로딩 중: Splash 화면 유지
/// - 로그인 상태 + 온보딩 미완료: /onboarding으로 이동
/// - 로그인 상태: Auth 페이지 접근 시 Home으로 이동 (비밀번호 설정 제외)
/// - 비로그인 상태: 보호된 페이지 접근 시 Login으로 이동
String? handleRouterRedirect(BuildContext context, GoRouterState state, Ref ref) {
  final authState = ref.read(authProvider);
  final isAuthenticated = authState.isAuthenticated;
  final onboardingCompleted = ref.read(onboardingProvider);

  final String currentLocation = state.matchedLocation;

  // OAuth 콜백 페이지인 경우 redirect 건너뛰기
  if (currentLocation.startsWith('/auth/callback')) {
    return null;
  }

  // 'setup=true' 쿼리가 있으면 "로그인 한 유저의 비밀번호 변경"으로 간주
  final isPasswordSetup =
      currentLocation == AppRoutes.forgotPassword &&
      state.uri.queryParameters['setup'] == 'true';

  final isAuthPage = [
    AppRoutes.login,
    AppRoutes.signup,
    AppRoutes.emailVerification,
    AppRoutes.forgotPassword,
  ].contains(currentLocation);

  final isSplashPage = currentLocation == AppRoutes.splash;
  final isOnboardingPage = currentLocation == AppRoutes.onboarding;

  // [CASE 1] 인증 로딩 중
  // 웹에서 새로고침 시 현재 URL을 보존하기 위해 splash 페이지가 아니면 현재 위치 유지.
  // redirect는 인증 완료 후 authProvider 변경 시 다시 실행된다.
  if (isAuthenticated == null) {
    if (isSplashPage) return null;
    // auth 페이지(로그인 등)는 splash로, 그 외 보호된 페이지는 현재 위치 유지
    return isAuthPage ? AppRoutes.splash : null;
  }

  // [CASE 2] 로그인 상태 (Authenticated)
  if (isAuthenticated) {
    // 온보딩 로드 중(null)이면 splash 유지
    if (onboardingCompleted == null) {
      return isSplashPage ? null : AppRoutes.splash;
    }

    // 온보딩 미완료 → 온보딩 화면으로 (온보딩 화면 자체는 통과)
    if (!onboardingCompleted && !isOnboardingPage) {
      return AppRoutes.onboarding;
    }

    // 온보딩 완료 후 온보딩 페이지 접근 → 홈으로
    if (onboardingCompleted && isOnboardingPage) {
      return AppRoutes.home;
    }

    // Auth 페이지나 Splash → 홈으로 (비밀번호 설정 제외)
    if (isSplashPage || (isAuthPage && !isPasswordSetup)) {
      return AppRoutes.home;
    }
  }

  // [CASE 3] 비로그인 상태 (Unauthenticated)
  if (!isAuthenticated) {
    if (isSplashPage || isOnboardingPage || !isAuthPage) {
      return AppRoutes.login;
    }
  }

  return null;
}
