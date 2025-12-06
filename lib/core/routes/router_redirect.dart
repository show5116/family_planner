import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/auth/providers/auth_provider.dart';

/// GoRouter의 redirect 로직을 처리하는 함수
///
/// 인증 상태에 따라 적절한 페이지로 리다이렉트합니다:
/// - 로딩 중: Splash 화면 유지
/// - 로그인 상태: Auth 페이지 접근 시 Home으로 이동 (비밀번호 설정 제외)
/// - 비로그인 상태: 보호된 페이지 접근 시 Login으로 이동
String? handleRouterRedirect(BuildContext context, GoRouterState state, Ref ref) {
  final authState = ref.read(authProvider);
  final isAuthenticated = authState.isAuthenticated;

  final String currentLocation = state.matchedLocation;

  // OAuth 콜백 페이지인 경우, 팝업이면 redirect 건너뛰기
  if (state.matchedLocation.startsWith('/auth/callback')) {
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

  // [CASE 1] 로딩 중 (Splash 유지)
  if (isAuthenticated == null) {
    return isSplashPage ? null : AppRoutes.splash;
  }

  // [CASE 2] 로그인 상태 (Authenticated)
  if (isAuthenticated) {
    // 원칙: 로그인 한 유저는 Auth 페이지(로그인/회원가입 등)에 갈 필요가 없음 -> Home으로
    // 예외: 비밀번호 변경(setup=true)은 로그인 유저도 접근 허용
    if (isSplashPage || (isAuthPage && !isPasswordSetup)) {
      return AppRoutes.home;
    }
  }

  // [CASE 3] 비로그인 상태 (Unauthenticated)
  if (!isAuthenticated) {
    // 원칙: 비로그인 유저는 보호된 페이지(Home, Settings 등) 접근 불가 -> Login으로
    // 예외: Auth 페이지(비밀번호 찾기 포함)는 접근 허용
    if (isSplashPage || !isAuthPage) {
      return AppRoutes.login;
    }
  }

  return null;
}
