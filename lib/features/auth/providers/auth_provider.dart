import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/services/auth_service.dart';

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
  AuthNotifier(this._authService) : super(const AuthState());

  final AuthService _authService;

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
}

/// Auth Provider 인스턴스
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});
