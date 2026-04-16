import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/features/auth/services/auth_service.dart';
import 'package:family_planner/features/auth/services/oauth_callback_handler.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/features/notification/providers/fcm_token_provider.dart';
import 'package:family_planner/features/main/assets/providers/asset_provider.dart';
import 'package:family_planner/features/main/household/providers/household_provider.dart';
import 'package:family_planner/features/main/savings/providers/savings_provider.dart';
import 'package:family_planner/features/main/child_points/providers/childcare_provider.dart';
import 'package:family_planner/features/votes/providers/vote_list_provider.dart';
import 'package:family_planner/features/minigame/providers/minigame_provider.dart';

/// 인증 상태
class AuthState {
  const AuthState({this.isAuthenticated, this.user, this.error});

  final bool? isAuthenticated;
  final Map<String, dynamic>? user;
  final String? error;

  /// 현재 로그인한 사용자 ID
  /// 응답 구조가 { "user": { "id": "..." } } 또는 { "id": "..." } 두 가지 케이스 대응
  String? get userId =>
      (user?['user'] as Map<String, dynamic>?)?['id']?.toString() ??
      user?['id']?.toString();

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
  AuthNotifier(this._authService, this._ref) : super(const AuthState()) {
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
  final Ref _ref;
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

      // 이전 계정의 캐시된 데이터 초기화
      _invalidateGroupProviders();

      state = state.copyWith(isAuthenticated: true, user: response);

      // 로그인 성공 후 FCM 토큰 등록
      await _registerFcmToken();
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
  Future<void> verifyEmail({required String email, required String code}) async {
    state = state.copyWith(error: null);

    try {
      await _authService.verifyEmail(email: email, code: code);

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
      // 로그아웃 전 FCM 토큰 삭제
      await _deleteFcmToken();

      await _authService.logout();

      // 그룹 관련 provider 초기화 (로그아웃 시에는 상태만 비움, 다시 fetch 안함)
      _invalidateGroupProviders(clearOnly: true);

      state = const AuthState(isAuthenticated: false);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  /// 그룹 관련 provider들을 모두 초기화
  /// [clearOnly]가 true면 invalidate 없이 상태만 비움 (로그아웃 시)
  /// [clearOnly]가 false면 invalidate 수행 (계정 전환 시 새로 fetch 필요)
  void _invalidateGroupProviders({bool clearOnly = false}) {
    if (clearOnly) {
      // 로그아웃 시: 상태만 비우고 다시 fetch하지 않음
      // groupNotifierProvider의 상태를 빈 데이터로 설정
      _ref.read(groupNotifierProvider.notifier).clearGroups();
    } else {
      // 로그인/계정 전환 시: invalidate하여 새 계정의 데이터를 fetch
      _ref.invalidate(myGroupsProvider);
      _ref.invalidate(groupNotifierProvider);
    }
    // family provider들은 자동으로 무효화됨 (부모 provider가 무효화되면)

    // 피처별 선택된 그룹 ID 초기화 (이전 계정의 groupId가 남지 않도록)
    _ref.read(assetSelectedGroupIdProvider.notifier).state = null;
    _ref.read(householdSelectedGroupIdProvider.notifier).state = null;
    _ref.read(savingsSelectedGroupIdProvider.notifier).state = null;
    _ref.read(childcareSelectedGroupIdProvider.notifier).state = null;
    _ref.read(voteSelectedGroupIdProvider.notifier).state = null;
    _ref.read(minigameSelectedGroupIdProvider.notifier).state = null;
  }

  /// FCM 토큰 등록 (로그인 성공 후)
  Future<void> _registerFcmToken() async {
    try {
      debugPrint('🟢 [AuthProvider] _registerFcmToken 시작');

      // FCM 토큰 notifier의 refreshToken 메서드를 직접 호출하여 백엔드에 등록
      final fcmTokenNotifier = _ref.read(fcmTokenProvider.notifier);
      debugPrint('  - FcmTokenProvider notifier 가져옴, refreshToken() 호출...');

      await fcmTokenNotifier.refreshToken();

      debugPrint('✅ [AuthProvider] FCM 토큰 등록 완료');
    } catch (e, stackTrace) {
      debugPrint('❌ [AuthProvider] FCM 토큰 등록 실패: $e');
      debugPrint('StackTrace: $stackTrace');
      // 토큰 등록 실패는 로그인 자체를 막지 않음
    }
  }

  /// FCM 토큰 삭제 (로그아웃 시)
  Future<void> _deleteFcmToken() async {
    try {
      final fcmTokenNotifier = _ref.read(fcmTokenProvider.notifier);
      await fcmTokenNotifier.deleteToken();
      debugPrint('FCM 토큰 삭제 완료');
    } catch (e) {
      debugPrint('FCM 토큰 삭제 실패: $e');
      // 토큰 삭제 실패는 로그아웃 자체를 막지 않음
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
    // 스플래시 화면을 최소 1초간 표시하기 위한 타이머 시작
    final startTime = DateTime.now();

    try {
      final hasToken = await _authService.apiClient.hasValidToken();

      if (!hasToken) {
        await _ensureMinimumSplashDuration(startTime);
        state = const AuthState(isAuthenticated: false);
        return;
      }

      // 토큰 검증
      bool isValid = await verifyToken();

      if (!isValid) {
        debugPrint('토큰 검증 실패(만료 가능성) → 토큰 갱신 시도');
        try {
          // 플랫폼별 RefreshToken 처리
          // - 웹: HTTP Only Cookie로 전송 (null 전달)
          // - 모바일: Storage에서 가져와서 전달
          final refreshToken = kIsWeb
              ? null
              : await _authService.apiClient.getRefreshToken();

          await _authService.refreshToken(refreshToken);

          // 갱신 성공! 다시 유효하다고 판단
          isValid = true;
        } catch (refreshError) {
          // 갱신마저 실패했다면 그때 진짜 로그아웃 처리
          isValid = false;
        }
      }

      await _ensureMinimumSplashDuration(startTime);

      if (isValid) {
        // 유효하면(또는 갱신 성공하면) 사용자 정보 가져오기
        try {
          final user = await _authService.getUserInfo();
          state = state.copyWith(isAuthenticated: true, user: user);

          // 자동 로그인 성공 시 FCM 토큰 등록
          await _registerFcmToken();
        } catch (e) {
          debugPrint('사용자 정보 가져오기 실패: $e');
          state = state.copyWith(isAuthenticated: true);

          // 실패해도 토큰은 등록 시도
          await _registerFcmToken();
        }
      } else {
        // 최종 실패 시 토큰 삭제 및 로그아웃
        debugPrint('최종 인증 실패 → 토큰 삭제');
        await _authService.apiClient.clearTokens();
        state = const AuthState(isAuthenticated: false);
      }
    } catch (e) {
      await _authService.apiClient.clearTokens();
      await _ensureMinimumSplashDuration(startTime);
      state = const AuthState(isAuthenticated: false);
    }
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

      // 이전 계정의 캐시된 데이터 초기화
      _invalidateGroupProviders();

      // 웹의 경우 토큰이 이미 저장됨, 사용자 정보 가져오기
      if (kIsWeb && response.isNotEmpty) {
        final userInfo = await _authService.getUserInfo();
        state = state.copyWith(isAuthenticated: true, user: userInfo);
      } else if (!kIsWeb) {
        // 모바일: response에 사용자 정보 포함
        state = state.copyWith(isAuthenticated: true, user: response);
      }

      // 구글 로그인 성공 후 FCM 토큰 등록
      await _registerFcmToken();
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

      // 이전 계정의 캐시된 데이터 초기화
      _invalidateGroupProviders();

      // 웹의 경우 토큰이 이미 저장됨, 사용자 정보 가져오기
      if (kIsWeb && response.isNotEmpty) {
        final userInfo = await _authService.getUserInfo();
        state = state.copyWith(isAuthenticated: true, user: userInfo);
      } else if (!kIsWeb) {
        // 모바일: response에 사용자 정보 포함
        state = state.copyWith(isAuthenticated: true, user: response);
      }

      // 카카오 로그인 성공 후 FCM 토큰 등록
      await _registerFcmToken();
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
    String? currentPassword,
    String? newPassword,
    String? personalColor,
  }) async {
    state = state.copyWith(error: null);

    try {
      final updatedUser = await _authService.updateProfile(
        name: name,
        phoneNumber: phoneNumber,
        currentPassword: currentPassword,
        newPassword: newPassword,
        personalColor: personalColor,
      );

      // 업데이트된 사용자 정보로 상태 업데이트
      state = state.copyWith(isAuthenticated: true, user: updatedUser);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  /// 프로필 사진 업로드
  Future<void> uploadProfilePhoto(List<int> fileBytes, String fileName) async {
    state = state.copyWith(error: null);

    try {
      await _authService.uploadProfilePhoto(fileBytes, fileName);

      // 사용자 정보 새로고침
      final user = await _authService.getUserInfo();
      state = state.copyWith(isAuthenticated: true, user: user);
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
      // AccessToken 저장 (모든 플랫폼)
      await _authService.apiClient.saveAccessToken(accessToken);

      // RefreshToken 저장 (모바일만)
      if (refreshToken != null && !kIsWeb) {
        await _authService.apiClient.saveRefreshToken(refreshToken);
      } else if (kIsWeb) {}

      // 이전 계정의 캐시된 데이터 초기화
      _invalidateGroupProviders();

      // 사용자 정보 가져오기
      final user = await _authService.getUserInfo();

      // 상태 업데이트
      state = state.copyWith(isAuthenticated: true, user: user);

      // OAuth 콜백 성공 후 FCM 토큰 등록
      await _registerFcmToken();
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  /// OAuth 콜백 성공 처리 (내부 메서드)
  Future<void> _handleOAuthSuccess() async {
    try {
      // 이전 계정의 캐시된 데이터 초기화
      _invalidateGroupProviders();

      // 저장된 토큰으로 사용자 정보 가져오기
      final user = await _authService.getUserInfo();

      state = state.copyWith(isAuthenticated: true, user: user);

      // OAuth 성공 후 FCM 토큰 등록
      await _registerFcmToken();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// 401 에러 발생 시 호출되는 콜백 (ApiClient에서 호출)
  void _handleUnauthorized() {
    // 인증 상태를 false로 설정하여 로그인 화면으로 리다이렉트
    state = const AuthState(isAuthenticated: false);
  }
}

/// Auth Provider 인스턴스
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService, ref);
});
