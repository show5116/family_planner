import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/services/auth_service.dart';
import 'package:family_planner/core/services/oauth_callback_handler.dart';

/// 인증 상태
class AuthState {
  const AuthState({this.isAuthenticated, this.user, this.error});

  final bool? isAuthenticated;
  final Map<String, dynamic>? user;
  final String? error;

  AuthState copyWith({
    bool? isAuthenticated,
    Map<String, dynamic>? user,
    String? error,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      error: error,
    );
  }
}

/// AuthService Provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

/// Auth Provider
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._authService) : super(const AuthState()) {
    // 401 에러 시 자동 로그아웃 콜백 설정
    _authService.apiClient.onUnauthorized = _handleUnauthorized;
    debugPrint('=== AuthNotifier: onUnauthorized callback registered ===');

    // OAuth 콜백 스트림 구독 (웹 전용)
    // 웹에서 OAuth URL 방식 로그인 시 콜백 처리를 위함
    // 모바일은 SDK 방식을 사용하므로 불필요
    if (kIsWeb) {
      debugPrint('=== AuthNotifier initialized (Web) ===');
      debugPrint('Setting up OAuth callback stream listener...');
      _oauthSubscription = _authService.oauthCallbackStream.listen((result) {
        debugPrint('=== OAuth Callback Received in AuthNotifier ===');
        debugPrint('Success: ${result.isSuccess}');
        if (result.isSuccess) {
          debugPrint('Handling OAuth success...');
          // 토큰 저장 완료, 사용자 정보 가져오기
          _handleOAuthSuccess();
        } else {
          debugPrint('OAuth error: ${result.error}');
          // 에러 처리
          state = state.copyWith(error: result.error);
        }
      });
    }
  }

  final AuthService _authService;
  StreamSubscription<OAuthCallbackResult>? _oauthSubscription;

  @override
  void dispose() {
    _oauthSubscription?.cancel();
    super.dispose();
  }

  /// 로그인
  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(error: null);

    try {
      final response = await _authService.login(
        email: email,
        password: password,
      );

      state = state.copyWith(isAuthenticated: true, user: response);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  /// 회원가입
  Future<void> signup({
    required String email,
    required String password,
    required String name,
  }) async {
    state = state.copyWith(error: null);

    try {
      await _authService.register(email: email, password: password, name: name);

      state = const AuthState();
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  /// 이메일 인증
  Future<void> verifyEmail({required String code}) async {
    state = state.copyWith(error: null);

    try {
      await _authService.verifyEmail(code: code);

      state = const AuthState();
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  /// 인증 이메일 재전송
  Future<void> resendVerification({required String email}) async {
    state = state.copyWith(error: null);

    try {
      await _authService.resendVerification(email: email);

      state = const AuthState();
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  /// 로그아웃
  Future<void> logout() async {
    state = state.copyWith(error: null);

    try {
      await _authService.logout();

      state = const AuthState(isAuthenticated: false);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  /// 토큰 검증
  Future<bool> verifyToken() async {
    try {
      return await _authService.verifyToken();
    } catch (e) {
      return false;
    }
  }

  /// 자동 로그인 (저장된 토큰으로)
  Future<void> checkAuthStatus() async {
    debugPrint('=== checkAuthStatus 시작 ===');
    debugPrint('현재 상태: isAuthenticated = ${state.isAuthenticated}');

    // 스플래시 화면을 최소 1초간 표시하기 위한 타이머 시작
    final startTime = DateTime.now();

    try {
      // 저장된 토큰이 있는지 확인
      debugPrint('토큰 확인 중...');
      final hasToken = await _authService.apiClient.hasValidToken();
      debugPrint('토큰 존재 여부: $hasToken');

      if (!hasToken) {
        debugPrint('토큰 없음 → isAuthenticated = false 설정');
        await _ensureMinimumSplashDuration(startTime);
        state = const AuthState(isAuthenticated: false);
        debugPrint('상태 업데이트 완료: isAuthenticated = ${state.isAuthenticated}');
        return;
      }

      // 토큰 검증
      debugPrint('토큰 검증 중...');
      final isValid = await verifyToken();
      debugPrint('토큰 유효성: $isValid');

      if (isValid) {
        // 토큰이 유효하면 인증 상태로 설정
        debugPrint('토큰 유효 → isAuthenticated = true 설정');
        await _ensureMinimumSplashDuration(startTime);
        state = state.copyWith(isAuthenticated: true);
        debugPrint('상태 업데이트 완료: isAuthenticated = ${state.isAuthenticated}');
      } else {
        // 토큰이 유효하지 않으면 토큰 삭제
        debugPrint('토큰 무효 → 토큰 삭제 및 isAuthenticated = false 설정');
        await _authService.apiClient.clearTokens();
        await _ensureMinimumSplashDuration(startTime);
        state = const AuthState(isAuthenticated: false);
        debugPrint('상태 업데이트 완료: isAuthenticated = ${state.isAuthenticated}');
      }
    } catch (e) {
      debugPrint('에러 발생: $e');
      debugPrint('토큰 삭제 및 isAuthenticated = false 설정');
      await _authService.apiClient.clearTokens();
      await _ensureMinimumSplashDuration(startTime);
      state = const AuthState(isAuthenticated: false);
      debugPrint('상태 업데이트 완료: isAuthenticated = ${state.isAuthenticated}');
    }

    debugPrint('=== checkAuthStatus 완료 ===');
  }

  /// 스플래시 화면 최소 표시 시간 보장 (1초)
  Future<void> _ensureMinimumSplashDuration(DateTime startTime) async {
    const minimumDuration = Duration(seconds: 1);
    final elapsed = DateTime.now().difference(startTime);

    if (elapsed < minimumDuration) {
      final remaining = minimumDuration - elapsed;
      await Future.delayed(remaining);
    }
  }

  /// 구글 로그인 (플랫폼별 자동 분기)
  ///
  /// - 웹: OAuth 팝업 방식 (팝업 창으로 인증)
  /// - 모바일: SDK 방식 (Google Sign-In)
  Future<void> loginWithGoogle() async {
    state = state.copyWith(error: null);

    try {
      final response = kIsWeb
          ? await _authService.loginWithGoogleOAuth()
          : await _authService.loginWithGoogle();

      // 웹의 경우 토큰이 이미 저장됨, 사용자 정보 가져오기
      if (kIsWeb && response.isNotEmpty) {
        final userInfo = await _authService.getUserInfo();
        state = state.copyWith(isAuthenticated: true, user: userInfo);
      } else if (!kIsWeb) {
        // 모바일: response에 사용자 정보 포함
        state = state.copyWith(isAuthenticated: true, user: response);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  /// 카카오 로그인 (플랫폼별 자동 분기)
  ///
  /// - 웹: OAuth 팝업 방식 (팝업 창으로 인증)
  /// - 모바일: SDK 방식 (Kakao Flutter SDK)
  Future<void> loginWithKakao() async {
    state = state.copyWith(error: null);

    try {
      final response = kIsWeb
          ? await _authService.loginWithKakaoOAuth()
          : await _authService.loginWithKakao();

      // 웹의 경우 토큰이 이미 저장됨, 사용자 정보 가져오기
      if (kIsWeb && response.isNotEmpty) {
        final userInfo = await _authService.getUserInfo();
        state = state.copyWith(isAuthenticated: true, user: userInfo);
      } else if (!kIsWeb) {
        // 모바일: response에 사용자 정보 포함
        state = state.copyWith(isAuthenticated: true, user: response);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  /// 비밀번호 재설정 요청
  Future<void> requestPasswordReset({required String email}) async {
    state = state.copyWith(error: null);

    try {
      await _authService.requestPasswordReset(email: email);

      // 비밀번호 재설정 요청은 인증 상태에 영향을 주지 않으므로
      // AuthState를 리셋하지 않고 에러만 클리어
      // state = const AuthState(); // 제거: 이로 인해 isAuthenticated가 null로 변경됨
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  /// 비밀번호 재설정
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    state = state.copyWith(error: null);

    try {
      await _authService.resetPassword(
        email: email,
        code: code,
        newPassword: newPassword,
      );

      // 비밀번호 재설정도 인증 상태를 변경하지 않음
      // (소셜 로그인 사용자가 인증된 상태에서 비밀번호를 설정하는 경우를 고려)
      // state = const AuthState(); // 제거: 이로 인해 isAuthenticated가 null로 변경됨
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  /// 프로필 업데이트
  Future<void> updateProfile({
    String? name,
    String? phoneNumber,
    String? profileImage,
    String? currentPassword,
    String? newPassword,
  }) async {
    state = state.copyWith(error: null);

    try {
      final updatedUser = await _authService.updateProfile(
        name: name,
        phoneNumber: phoneNumber,
        profileImage: profileImage,
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      // 업데이트된 사용자 정보로 상태 업데이트
      state = state.copyWith(isAuthenticated: true, user: updatedUser);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  // ========== OAuth 콜백 처리 (웹 전용) ==========

  /// 웹 OAuth 콜백 처리 (공개 메서드)
  ///
  /// OAuthCallbackScreen에서 호출되어 토큰을 저장하고 사용자 정보를 가져옵니다.
  ///
  /// **토큰 처리:**
  /// - accessToken: 항상 저장 (모든 플랫폼)
  /// - refreshToken: 모바일에서만 저장, 웹은 HTTP Only Cookie로 관리
  Future<void> handleWebOAuthCallback({
    required String accessToken,
    String? refreshToken, // 웹에서는 null (쿠키로 관리)
  }) async {
    try {
      debugPrint('=== handleWebOAuthCallback called ===');
      debugPrint('Access Token: ${accessToken.substring(0, 20)}...');
      debugPrint('Refresh Token: ${refreshToken != null ? "${refreshToken.substring(0, 20)}..." : "null (managed by cookie)"}');

      // AccessToken 저장 (모든 플랫폼)
      await _authService.apiClient.saveAccessToken(accessToken);
      debugPrint('AccessToken saved');

      // RefreshToken 저장 (모바일만)
      if (refreshToken != null && !kIsWeb) {
        await _authService.apiClient.saveRefreshToken(refreshToken);
        debugPrint('RefreshToken saved (Mobile)');
      } else if (kIsWeb) {
        debugPrint('RefreshToken managed by HTTP Only Cookie (Web)');
      }

      debugPrint('Tokens processed, fetching user info...');

      // 사용자 정보 가져오기
      final user = await _authService.getUserInfo();
      debugPrint('User info fetched: $user');

      // 상태 업데이트
      state = state.copyWith(isAuthenticated: true, user: user);
      debugPrint(
        'Auth state updated: isAuthenticated=${state.isAuthenticated}',
      );
    } catch (e) {
      debugPrint('Error in handleWebOAuthCallback: $e');
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  /// OAuth 콜백 성공 처리 (내부 메서드)
  Future<void> _handleOAuthSuccess() async {
    try {
      debugPrint('=== _handleOAuthSuccess called ===');
      // 저장된 토큰으로 사용자 정보 가져오기
      final user = await _authService.getUserInfo();
      debugPrint('User info fetched: $user');

      state = state.copyWith(isAuthenticated: true, user: user);
      debugPrint(
        'Auth state updated: isAuthenticated=${state.isAuthenticated}',
      );
    } catch (e) {
      debugPrint('Error in _handleOAuthSuccess: $e');
      state = state.copyWith(error: e.toString());
    }
  }

  /// 401 에러 발생 시 호출되는 콜백 (ApiClient에서 호출)
  void _handleUnauthorized() {
    debugPrint('=== _handleUnauthorized called ===');
    debugPrint('401 Unauthorized error detected - forcing logout');

    // 인증 상태를 false로 설정하여 로그인 화면으로 리다이렉트
    state = const AuthState(isAuthenticated: false);

    debugPrint('Auth state updated: isAuthenticated=${state.isAuthenticated}');
    debugPrint('GoRouter will redirect to login screen');
  }
}

/// Auth Provider 인스턴스
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});
