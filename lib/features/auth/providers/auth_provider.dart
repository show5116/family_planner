import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
import 'package:family_planner/features/settings/groups/providers/default_group_provider.dart';
import 'package:family_planner/features/main/fridge/providers/fridge_provider.dart';
import 'package:family_planner/features/main/task/providers/task_provider.dart';
import 'package:family_planner/features/home/providers/dashboard_provider.dart';
import 'package:family_planner/core/providers/dashboard_widget_settings_provider.dart';
import 'package:family_planner/features/memo/providers/memo_provider.dart';
import 'package:family_planner/features/main/investment/providers/indicator_provider.dart';
import 'package:family_planner/features/notification/providers/notification_settings_provider.dart';
import 'package:family_planner/features/onboarding/providers/onboarding_provider.dart';
import 'package:family_planner/core/services/analytics_service.dart';
import 'package:family_planner/core/services/home_widget_service.dart';

/// 인증 상태
class AuthState {
  const AuthState({
    this.isAuthenticated,
    this.user,
    this.error,
    this.pendingTempToken,
  });

  final bool? isAuthenticated;
  final Map<String, dynamic>? user;
  final String? error;

  /// 소셜 신규 가입 시 약관 동의 대기 상태의 임시 토큰.
  /// null이 아니면 약관 동의 화면을 표시해야 한다.
  final String? pendingTempToken;

  bool get isPendingTerms => pendingTempToken != null;

  /// 현재 로그인한 사용자 ID
  /// 응답 구조가 { "user": { "id": "..." } } 또는 { "id": "..." } 두 가지 케이스 대응
  String? get userId =>
      (user?['user'] as Map<String, dynamic>?)?['id']?.toString() ??
      user?['id']?.toString();

  /// 계정 삭제 예약 일시 (null이면 예약 없음)
  DateTime? get scheduledDeleteAt {
    final raw = user?['scheduledDeleteAt'];
    if (raw == null) return null;
    return DateTime.tryParse(raw.toString());
  }

  AuthState copyWith({
    bool? isAuthenticated,
    Map<String, dynamic>? user,
    String? error,
    String? pendingTempToken,
    bool clearPendingTempToken = false,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      error: error,
      pendingTempToken: clearPendingTempToken ? null : (pendingTempToken ?? this.pendingTempToken),
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

    // OAuth 콜백 스트림 구독 (웹 전용)
    // 웹에서 OAuth URL 방식 로그인 시 콜백 처리를 위함
    // 모바일은 SDK 방식을 사용하므로 불필요
    if (kIsWeb) {
      _oauthSubscription = _authService.oauthCallbackStream.listen((result) {
        if (result.isSuccess) {
          // 토큰 저장 완료, 사용자 정보 가져오기
          _handleOAuthSuccess();
        } else {
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
      await _authService.login(
        email: email,
        password: password,
      );

      // 이전 계정의 캐시된 데이터 초기화
      _invalidateGroupProviders();

      // auth/me로 정규화된 사용자 정보 조회 (로그인 응답은 user 중첩 구조라 직접 사용 불가)
      final userInfo = await _authService.getUserInfo();
      state = state.copyWith(isAuthenticated: true, user: userInfo);

      final uid = AuthState(isAuthenticated: true, user: userInfo).userId;
      if (uid != null) await AnalyticsService.instance.setUserId(uid);
      await AnalyticsService.instance.logLogin('email');

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

      await AnalyticsService.instance.logSignUp('email');
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

  /// 로그아웃 — 어떤 에러가 발생해도 반드시 로컬 데이터를 지우고 상태를 초기화한다
  Future<void> logout() async {
    // FCM 토큰 삭제 및 백엔드 로그아웃은 best-effort
    try {
      await _deleteFcmToken();
    } catch (_) {}

    try {
      await _authService.logout();
    } catch (_) {}

    await AnalyticsService.instance.logLogout();
    await AnalyticsService.instance.clearUserId();

    // 로그아웃 후 홈 화면(OS) 위젯에 이전 계정 일정이 남지 않도록 캐시 삭제
    try {
      await HomeWidgetService.clear();
    } catch (_) {}

    // 성공/실패 무관하게 반드시 인증 상태 초기화
    state = const AuthState(isAuthenticated: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _invalidateGroupProviders();
    });
  }

  /// 그룹 관련 provider들을 모두 초기화 (로그아웃/계정 전환 공통)
  void _invalidateGroupProviders() {
    // 이전 계정의 group filter가 새 계정에 적용되지 않도록 SharedPreferences 제거
    _clearGroupFilterPrefs();

    // 로그아웃/계정 전환 모두 invalidate하여 다음 로그인 시 새 계정 데이터를 fetch
    _ref.invalidate(myGroupsProvider);
    _ref.invalidate(groupNotifierProvider);
    // family provider들은 자동으로 무효화됨 (부모 provider가 무효화되면)

    // 피처별 선택된 그룹 ID 초기화 (이전 계정의 groupId가 남지 않도록)
    _ref.read(assetSelectedGroupIdProvider.notifier).state = null;
    _ref.read(householdSelectedGroupIdProvider.notifier).state = null;
    _ref.read(savingsSelectedGroupIdProvider.notifier).state = null;
    _ref.read(childcareSelectedGroupIdProvider.notifier).state = null;
    _ref.read(voteSelectedGroupIdProvider.notifier).state = null;
    _ref.read(minigameSelectedGroupIdProvider.notifier).state = null;
    _ref.read(fridgeSelectedGroupIdProvider.notifier).state = null;
    _ref.read(selectedGroupIdProvider.notifier).state = null;
    _ref.read(selectedGroupIdsProvider.notifier).state = null;
    _ref.read(includePersonalProvider.notifier).state = true;
    _ref.read(selectedCategoryIdsProvider.notifier).state = [];
    _ref.read(memoSelectedFilterProvider.notifier).state = null;
    _ref.read(assetSelectedUserIdProvider.notifier).state = null;
    _ref.read(assetStatSelectedAccountIdsProvider.notifier).state = {};
    _ref.read(childcareSelectedChildIdProvider.notifier).state = null;
    _ref.invalidate(bookmarkedIndicatorsProvider);
    _ref.invalidate(notificationSettingsProvider);
    _ref.read(defaultGroupProvider.notifier).clear();

    // 대시보드 캐시(keepAlive) 및 위젯 설정의 그룹 ID 초기화
    _ref.invalidate(dashboardTodayTasksProvider);
    _ref.invalidate(dashboardTodoTasksProvider);
    _ref.invalidate(dashboardAssetStatisticsProvider);
    _ref.invalidate(dashboardHouseholdStatisticsProvider);
    _ref.invalidate(dashboardMemosProvider);
    _ref.invalidate(dashboardSavingsProvider);
    _ref.read(dashboardWidgetSettingsProvider.notifier).clearGroupIds();
  }

  /// FCM 토큰 등록 (로그인 성공 후)
  Future<void> _registerFcmToken() async {
    try {
      final fcmTokenNotifier = _ref.read(fcmTokenProvider.notifier);
      await fcmTokenNotifier.refreshToken();
    } catch (e) {
      // 토큰 등록 실패는 로그인 자체를 막지 않음
    }
  }

  /// FCM 토큰 삭제 (로그아웃 시)
  Future<void> _deleteFcmToken() async {
    try {
      final fcmTokenNotifier = _ref.read(fcmTokenProvider.notifier);
      await fcmTokenNotifier.deleteToken();
    } catch (e) {
      // 토큰 삭제 실패는 로그아웃 자체를 막지 않음
    }
  }

  /// 토큰 검증
  Future<bool> verifyToken() async {
    return await _authService.verifyToken();
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

      // 토큰 검증 + 사용자 정보를 한 번의 auth/me 호출로 처리
      Map<String, dynamic>? user = await _authService.verifyTokenAndGetUser();

      if (user == null) {
        // 토큰 만료 시 갱신 후 재시도
        try {
          // 플랫폼별 RefreshToken 처리
          // - 웹: HTTP Only Cookie로 전송 (null 전달)
          // - 모바일: Storage에서 가져와서 전달
          final refreshToken = kIsWeb
              ? null
              : await _authService.apiClient.getRefreshToken();

          await _authService.refreshToken(refreshToken);

          // 갱신 성공 후 사용자 정보 재조회
          user = await _authService.verifyTokenAndGetUser();
        } catch (refreshError) {
          // 갱신마저 실패했다면 그때 진짜 로그아웃 처리
          user = null;
        }
      }

      await _ensureMinimumSplashDuration(startTime);

      if (user != null) {
        state = state.copyWith(isAuthenticated: true, user: user);

        final uid = AuthState(isAuthenticated: true, user: user).userId;
        if (uid != null) await AnalyticsService.instance.setUserId(uid);

        // 자동 로그인 성공 시 FCM 토큰 등록
        await _registerFcmToken();
      } else {
        // 최종 실패 시 토큰 삭제 및 로그아웃
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

      // 신규 가입 → 약관 동의 대기 상태로 전환
      if (_isPendingTerms(response)) {
        state = state.copyWith(
          pendingTempToken: response['tempToken'] as String,
          clearPendingTempToken: false,
        );
        return;
      }

      // 이전 계정의 캐시된 데이터 초기화
      _invalidateGroupProviders();

      // auth/me로 정규화된 사용자 정보 조회 (로그인 응답 구조와 무관하게 일관된 flat 구조)
      final userInfo = await _authService.getUserInfo();
      state = state.copyWith(isAuthenticated: true, user: userInfo);

      final uid = AuthState(isAuthenticated: true, user: userInfo).userId;
      if (uid != null) await AnalyticsService.instance.setUserId(uid);
      await AnalyticsService.instance.logLogin('google');

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

      // 신규 가입 → 약관 동의 대기 상태로 전환
      if (_isPendingTerms(response)) {
        state = state.copyWith(
          pendingTempToken: response['tempToken'] as String,
          clearPendingTempToken: false,
        );
        return;
      }

      // 이전 계정의 캐시된 데이터 초기화
      _invalidateGroupProviders();

      // auth/me로 정규화된 사용자 정보 조회 (로그인 응답 구조와 무관하게 일관된 flat 구조)
      final userInfo = await _authService.getUserInfo();
      state = state.copyWith(isAuthenticated: true, user: userInfo);

      final uid = AuthState(isAuthenticated: true, user: userInfo).userId;
      if (uid != null) await AnalyticsService.instance.setUserId(uid);
      await AnalyticsService.instance.logLogin('kakao');

      // 카카오 로그인 성공 후 FCM 토큰 등록
      await _registerFcmToken();
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  /// Apple 로그인 (플랫폼별 자동 분기)
  ///
  /// - 웹: OAuth 팝업 방식
  /// - Android: OAuth 외부 브라우저 방식 (Deep Link로 콜백)
  /// - iOS/macOS: SDK 방식 (sign_in_with_apple)
  Future<void> loginWithApple() async {
    state = state.copyWith(error: null);

    try {
      // Android: 외부 브라우저로 Apple OAuth 페이지를 열고 Deep Link로 콜백 수신
      // OAuthCallbackScreen이 accessToken을 받아 handleWebOAuthCallback을 호출한다
      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
        await _authService.loginWithAppleOAuth();
        return;
      }

      final response = kIsWeb
          ? await _authService.loginWithAppleOAuth()
          : await _authService.loginWithApple();

      if (_isPendingTerms(response)) {
        state = state.copyWith(
          pendingTempToken: response['tempToken'] as String,
          clearPendingTempToken: false,
        );
        return;
      }

      _invalidateGroupProviders();

      final userInfo = await _authService.getUserInfo();
      state = state.copyWith(isAuthenticated: true, user: userInfo);

      final uid = AuthState(isAuthenticated: true, user: userInfo).userId;
      if (uid != null) await AnalyticsService.instance.setUserId(uid);
      await AnalyticsService.instance.logLogin('apple');

      await _registerFcmToken();
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  /// 소셜 신규 회원가입 완료 (약관 동의 + 선택적 name/email)
  Future<void> completeSocialSignup({String? name, String? email}) async {
    final tempToken = state.pendingTempToken;
    if (tempToken == null) return;

    state = state.copyWith(error: null);

    try {
      // 토큰 저장 (socialSignup 내부에서 처리)
      await _authService.socialSignup(tempToken: tempToken, name: name, email: email);

      _invalidateGroupProviders();

      // auth/me로 최신 사용자 정보 조회 (토큰 저장 후이므로 호출 가능)
      final userInfo = await _authService.getUserInfo();

      // 온보딩 상태를 먼저 로드한 뒤 state 변경 (state 변경 시 redirect가 즉시 실행되므로)
      await _ref.read(onboardingProvider.notifier).load();

      // pendingTempToken을 클리어하고 로그인 상태로 전환 → redirect가 홈으로 이동
      state = AuthState(isAuthenticated: true, user: userInfo);

      final uid = AuthState(isAuthenticated: true, user: userInfo).userId;
      if (uid != null) await AnalyticsService.instance.setUserId(uid);
      await AnalyticsService.instance.logSignUp('social');

      await _registerFcmToken();
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  /// 약관 동의 화면에서 뒤로 가기 (로그인 화면으로)
  void cancelSocialSignup() {
    state = const AuthState(isAuthenticated: false);
  }

  /// 웹 OAuth 콜백 URL로 직접 진입한 경우 tempToken을 AuthState에 설정
  void setPendingTempToken(String tempToken) {
    state = state.copyWith(pendingTempToken: tempToken);
  }

  /// 응답에 isNewUser: true + tempToken이 있으면 약관 동의 대기 상태
  /// 웹은 String 'true', 모바일은 bool true로 올 수 있으므로 양쪽 처리
  bool _isPendingTerms(Map<String, dynamic> response) {
    final isNewUser = response['isNewUser'];
    final hasNewUserFlag = isNewUser == true || isNewUser == 'true';
    return hasNewUserFlag &&
        response['tempToken'] is String &&
        (response['tempToken'] as String).isNotEmpty;
  }

  /// 이전 계정의 그룹 필터 SharedPreferences 제거 (계정 전환 시 잔존 방지)
  Future<void> _clearGroupFilterPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      for (final key in ['calendar_group_filter', 'todo_group_filter']) {
        await prefs.remove('${key}_all');
        await prefs.remove('${key}_personal');
        await prefs.remove('${key}_ids');
      }
    } catch (_) {}
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
      await _authService.updateProfile(
        name: name,
        phoneNumber: phoneNumber,
        currentPassword: currentPassword,
        newPassword: newPassword,
        personalColor: personalColor,
      );

      // /auth/me 재호출로 최신 사용자 정보 갱신
      final user = await _authService.getUserInfo();
      state = state.copyWith(isAuthenticated: true, user: user);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  /// 계정 삭제 예약 (7일 유예)
  /// 성공 시 scheduledDeleteAt(DateTime) 반환
  Future<DateTime> scheduleDeleteAccount() async {
    state = state.copyWith(error: null);

    try {
      final data = await _authService.scheduleDeleteAccount();
      final scheduledAt = DateTime.parse(data['scheduledDeleteAt'] as String);
      // user map에 scheduledDeleteAt 반영하여 즉시 UI에 표시
      if (state.user != null) {
        final updated = Map<String, dynamic>.from(state.user!);
        updated['scheduledDeleteAt'] = data['scheduledDeleteAt'];
        state = state.copyWith(user: updated);
      }
      return scheduledAt;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  /// 계정 삭제 예약 취소
  Future<void> cancelDeleteAccount() async {
    state = state.copyWith(error: null);

    try {
      await _authService.cancelDeleteAccount();
      // user map에서 scheduledDeleteAt 제거하여 즉시 UI에 반영
      if (state.user != null) {
        final updated = Map<String, dynamic>.from(state.user!);
        updated.remove('scheduledDeleteAt');
        state = state.copyWith(user: updated);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  /// 내 데이터 내보내기
  Future<dynamic> exportMyData() async {
    state = state.copyWith(error: null);

    try {
      return await _authService.exportMyData();
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
    state = const AuthState(isAuthenticated: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _invalidateGroupProviders();
    });
  }
}

/// Auth Provider 인스턴스
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService, ref);
});
