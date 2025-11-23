import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/services/auth_service.dart';
import 'package:family_planner/core/services/oauth_callback_handler.dart';

/// 인증 상태
class AuthState {
  const AuthState({
    this.isAuthenticated = false,
    this.user,
    this.isLoading = false,
    this.error,
  });

  final bool isAuthenticated;
  final Map<String, dynamic>? user;
  final bool isLoading;
  final String? error;

  AuthState copyWith({
    bool? isAuthenticated,
    Map<String, dynamic>? user,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
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
    // OAuth 콜백 스트림 구독 (웹 전용)
    // 웹에서 OAuth URL 방식 로그인 시 콜백 처리를 위함
    // 모바일은 SDK 방식을 사용하므로 불필요
    if (kIsWeb) {
      debugPrint('=== AuthNotifier initialized (Web) ===');
      debugPrint('Setting up OAuth callback stream listener...');
      _oauthSubscription = _authService.oauthCallbackStream.listen(
        (result) {
          debugPrint('=== OAuth Callback Received in AuthNotifier ===');
          debugPrint('Success: ${result.isSuccess}');
          if (result.isSuccess) {
            debugPrint('Handling OAuth success...');
            // 토큰 저장 완료, 사용자 정보 가져오기
            _handleOAuthSuccess();
          } else {
            debugPrint('OAuth error: ${result.error}');
            // 에러 처리
            state = state.copyWith(
              isLoading: false,
              error: result.error,
            );
          }
        },
      );
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
  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _authService.login(
        email: email,
        password: password,
      );

      state = state.copyWith(
        isAuthenticated: true,
        user: response,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  /// 회원가입
  Future<void> signup({
    required String email,
    required String password,
    required String name,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _authService.register(
        email: email,
        password: password,
        name: name,
      );

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  /// 이메일 인증
  Future<void> verifyEmail({
    required String code,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _authService.verifyEmail(code: code);

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  /// 인증 이메일 재전송
  Future<void> resendVerification({
    required String email,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _authService.resendVerification(email: email);

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  /// 로그아웃
  Future<void> logout() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _authService.logout();

      state = const AuthState();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
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
    state = state.copyWith(isLoading: true);

    try {
      // 저장된 토큰이 있는지 확인
      final hasToken = await _authService.apiClient.hasValidToken();

      if (!hasToken) {
        state = const AuthState(isLoading: false);
        return;
      }

      // 토큰 검증
      final isValid = await verifyToken();

      if (isValid) {
        // 토큰이 유효하면 인증 상태로 설정
        state = state.copyWith(
          isAuthenticated: true,
          isLoading: false,
        );
      } else {
        // 토큰이 유효하지 않으면 토큰 삭제
        await _authService.apiClient.clearTokens();
        state = const AuthState(isLoading: false);
      }
    } catch (e) {
      await _authService.apiClient.clearTokens();
      state = const AuthState(isLoading: false);
    }
  }

  /// 구글 로그인 (플랫폼별 자동 분기)
  ///
  /// - 웹: OAuth URL 방식 (브라우저 리다이렉트)
  /// - 모바일: SDK 방식 (Google Sign-In)
  Future<void> loginWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      if (kIsWeb) {
        // 웹: OAuth URL 방식
        await _authService.loginWithGoogleOAuth();
        // 브라우저가 열리고, 콜백은 스트림으로 처리됨
      } else {
        // 모바일: SDK 방식
        final response = await _authService.loginWithGoogle();

        state = state.copyWith(
          isAuthenticated: true,
          user: response,
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  /// 카카오 로그인 (플랫폼별 자동 분기)
  ///
  /// - 웹: OAuth URL 방식 (브라우저 리다이렉트)
  /// - 모바일: SDK 방식 (Kakao Flutter SDK)
  Future<void> loginWithKakao() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      if (kIsWeb) {
        // 웹: OAuth URL 방식
        await _authService.loginWithKakaoOAuth();
        // 브라우저가 열리고, 콜백은 스트림으로 처리됨
      } else {
        // 모바일: SDK 방식
        final response = await _authService.loginWithKakao();

        state = state.copyWith(
          isAuthenticated: true,
          user: response,
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  /// 비밀번호 재설정 요청
  Future<void> requestPasswordReset({
    required String email,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _authService.requestPasswordReset(email: email);

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  /// 비밀번호 재설정
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _authService.resetPassword(
        email: email,
        code: code,
        newPassword: newPassword,
      );

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      rethrow;
    }
  }

  // ========== OAuth 콜백 처리 (웹 전용) ==========

  /// 웹 OAuth 콜백 처리 (공개 메서드)
  ///
  /// OAuthCallbackScreen에서 호출되어 토큰을 저장하고 사용자 정보를 가져옵니다.
  Future<void> handleWebOAuthCallback({
    required String accessToken,
    required String refreshToken,
  }) async {
    try {
      debugPrint('=== handleWebOAuthCallback called ===');
      debugPrint('Access Token: ${accessToken.substring(0, 20)}...');
      debugPrint('Refresh Token: ${refreshToken.substring(0, 20)}...');

      // 토큰 저장
      await _authService.apiClient.saveAccessToken(accessToken);
      await _authService.apiClient.saveRefreshToken(refreshToken);

      debugPrint('Tokens saved, fetching user info...');

      // 사용자 정보 가져오기
      final user = await _authService.getUserInfo();
      debugPrint('User info fetched: $user');

      // 상태 업데이트
      state = state.copyWith(
        isAuthenticated: true,
        user: user,
        isLoading: false,
      );
      debugPrint('Auth state updated: isAuthenticated=${state.isAuthenticated}');
    } catch (e) {
      debugPrint('Error in handleWebOAuthCallback: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
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

      state = state.copyWith(
        isAuthenticated: true,
        user: user,
        isLoading: false,
      );
      debugPrint('Auth state updated: isAuthenticated=${state.isAuthenticated}');
    } catch (e) {
      debugPrint('Error in _handleOAuthSuccess: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

/// Auth Provider 인스턴스
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});
