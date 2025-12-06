import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:family_planner/core/services/api_service_base.dart';
import 'package:family_planner/core/constants/api_constants.dart';
import 'package:family_planner/core/config/environment.dart';
import 'package:family_planner/core/services/oauth_callback_handler.dart';
import 'package:family_planner/core/services/secure_storage_service.dart';
import 'package:family_planner/core/services/google_auth_service.dart';
import 'package:family_planner/core/services/kakao_auth_service.dart';
import 'package:family_planner/core/services/oauth_web_service.dart';

/// 인증 서비스
class AuthService extends ApiServiceBase {
  final _storage = SecureStorageService();
  final _googleAuthService = GoogleAuthService();
  final _kakaoAuthService = KakaoAuthService();
  final _oauthCallbackHandler = OAuthCallbackHandler();

  // ========== 공통 헬퍼 메서드 ==========

  /// 토큰 저장
  ///
  /// - AccessToken: 모든 플랫폼에서 SecureStorage에 저장
  /// - RefreshToken:
  ///   - 웹: HTTP Only Cookie로 관리 (백엔드에서 자동 설정, 저장 불필요)
  ///   - 모바일: SecureStorage에 저장
  Future<void> _saveTokens(Map<String, dynamic> data) async {
    // 모든 플랫폼에서 AccessToken 저장
    if (data['accessToken'] != null) {
      await apiClient.saveAccessToken(data['accessToken'] as String);
    }

    if (data['refreshToken'] != null) {
      await apiClient.saveRefreshToken(data['refreshToken'] as String);
    }
  }

  // ========== 기본 인증 (이메일/비밀번호) ==========

  /// 로그인
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await apiClient.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );

      final data = handleResponse<Map<String, dynamic>>(response);

      // 토큰 저장
      await _saveTokens(data);

      // 사용자 정보 저장
      await _saveUserInfoFromResponse(data);

      return data;
    } catch (e) {
      throw handleError(e);
    }
  }

  /// API 응답에서 사용자 정보 추출 및 저장
  Future<void> _saveUserInfoFromResponse(Map<String, dynamic> data) async {
    debugPrint('=== _saveUserInfoFromResponse ===');
    debugPrint('Response data: $data');

    // 응답 데이터 구조 확인
    final user = data['user'] as Map<String, dynamic>?;

    if (user != null) {
      debugPrint('User data found: $user');
      await _storage.saveUserInfo(
        email: user['email'] as String?,
        name: user['name'] as String?,
        phoneNumber: user['phoneNumber'] as String?,
        profileImage: user['profileImage'] as String?,
        isAdmin: user['isAdmin'] as bool?,
        hasPassword: user['hasPassword'] as bool?,
      );
      debugPrint('User info saved successfully');
    } else {
      // user 키가 없는 경우, 최상위 레벨에서 직접 추출 시도
      debugPrint('No "user" key found, trying top-level fields');
      await _storage.saveUserInfo(
        email: data['email'] as String?,
        name: data['name'] as String?,
        phoneNumber: data['phoneNumber'] as String?,
        profileImage: data['profileImage'] as String?,
        isAdmin: data['isAdmin'] as bool?,
        hasPassword: data['hasPassword'] as bool?,
      );
      debugPrint('User info saved from top-level fields');
    }
  }

  /// 회원가입
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await apiClient.post(
        ApiConstants.register,
        data: {'email': email, 'password': password, 'name': name},
      );

      final data = handleResponse<Map<String, dynamic>>(response);

      return data;
    } catch (e) {
      throw handleError(e);
    }
  }

  /// 로그아웃
  Future<void> logout() async {
    try {
      // 백엔드 로그아웃 API 호출
      await apiClient.post(ApiConstants.logout);
    } catch (e) {
      // 로그아웃 실패해도 로컬 토큰은 삭제
      debugPrint('Logout API failed: $e');
    } finally {
      // 소셜 로그인 SDK 로그아웃
      await _cleanupSocialLogin();

      // 로컬 토큰 및 사용자 정보 삭제
      await apiClient.clearTokens();
      await _storage.clearUserInfo();
      debugPrint('Local tokens and user info cleared');
    }
  }

  /// 소셜 로그인 정리
  Future<void> _cleanupSocialLogin() async {
    try {
      await signOutGoogle();
      debugPrint('Google sign out completed');
    } catch (e) {
      debugPrint('Google sign out failed: $e');
    }

    try {
      if (!kIsWeb) {
        // 카카오 로그아웃은 모바일에서만 (웹에서는 SDK 미사용)
        await signOutKakao();
        debugPrint('Kakao logout completed');
      }
    } catch (e) {
      debugPrint('Kakao logout failed: $e');
    }
  }

  /// 토큰 검증
  ///
  /// 토큰이 만료된 경우 ApiClient의 인터셉터가 자동으로 갱신을 시도합니다.
  /// 갱신이 성공하면 true, 실패하면 false를 반환합니다.
  Future<bool> verifyToken() async {
    try {
      debugPrint('=== verifyToken 시작 ===');
      final response = await apiClient.get(ApiConstants.verifyToken);
      final isValid = response.statusCode == 200;
      debugPrint('토큰 검증 결과: $isValid');
      return isValid;
    } catch (e) {
      // ApiClient 인터셉터가 토큰 갱신을 시도했지만 실패한 경우
      debugPrint('토큰 검증 실패: $e');
      return false;
    }
  }

  /// 토큰 갱신
  ///
  /// - 웹: RefreshToken은 HTTP Only Cookie로 자동 전송 (body 불필요)
  /// - 모바일: RefreshToken을 body에 담아 전송
  Future<Map<String, dynamic>> refreshToken(String? refreshToken) async {
    try {
      Response response;

      if (refreshToken == null) {
        // 웹: 쿠키로 refreshToken이 자동 전송됨
        response = await apiClient.post(
          ApiConstants.refreshToken,
          options: Options(
            extra: {
              'withCredentials': true, // 쿠키 자동 전송 (RefreshToken)
            },
          ),
        );
      } else {
        response = await apiClient.post(
          ApiConstants.refreshToken,
          data: {'refreshToken': refreshToken},
        );
      }

      final data = handleResponse<Map<String, dynamic>>(response);

      // 새 토큰 저장
      await _saveTokens(data);

      return data;
    } catch (e) {
      throw handleError(e);
    }
  }

  /// 이메일 인증
  Future<Map<String, dynamic>> verifyEmail({required String code}) async {
    try {
      final response = await apiClient.post(
        ApiConstants.verifyEmail,
        data: {'code': code},
      );

      return handleResponse<Map<String, dynamic>>(response);
    } catch (e) {
      throw handleError(e);
    }
  }

  /// 인증 이메일 재전송
  Future<Map<String, dynamic>> resendVerification({
    required String email,
  }) async {
    try {
      final response = await apiClient.post(
        ApiConstants.resendVerification,
        data: {'email': email},
      );

      final data = handleResponse<Map<String, dynamic>>(response);

      return data;
    } catch (e) {
      throw handleError(e);
    }
  }

  /// 비밀번호 재설정 요청 (이메일로 인증 코드 전송)
  Future<Map<String, dynamic>> requestPasswordReset({
    required String email,
  }) async {
    try {
      final response = await apiClient.post(
        ApiConstants.requestPasswordReset,
        data: {'email': email},
      );

      final data = handleResponse<Map<String, dynamic>>(response);

      return data;
    } catch (e) {
      throw handleError(e);
    }
  }

  /// 비밀번호 재설정 (인증 코드로 비밀번호 변경)
  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      final response = await apiClient.post(
        ApiConstants.resetPassword,
        data: {'email': email, 'code': code, 'newPassword': newPassword},
      );

      return handleResponse<Map<String, dynamic>>(response);
    } catch (e) {
      throw handleError(e);
    }
  }

  // ========== Google 로그인 (SDK 방식 - 모바일 전용) ==========

  /// 구글 로그인 (SDK 방식 - 모바일 전용)
  ///
  /// Google Sign-In SDK를 사용하여 인증 후 백엔드에 토큰을 전송합니다.
  /// 웹에서는 loginWithGoogleOAuth()를 사용하세요.
  ///
  /// [백엔드 API 요구사항]
  /// 올바른 구현을 위해서는 백엔드에 다음 엔드포인트가 필요합니다:
  /// - POST /auth/google/token
  /// - Request Body: { "accessToken": "...", "idToken": "..." }
  /// - Response: { "accessToken": "jwt", "refreshToken": "jwt", "user": {...} }
  ///
  /// [현재 임시 구현]
  /// 백엔드 엔드포인트가 없어 임시로 GET /auth/google/callback 사용 중
  Future<Map<String, dynamic>> loginWithGoogle() async {
    try {
      // 1. Google Sign-In SDK로 로그인하여 토큰 획득
      final tokens = await _googleAuthService.signIn();
      final accessToken = tokens['accessToken'];

      if (accessToken == null || accessToken.isEmpty) {
        throw Exception('Google Access Token을 가져올 수 없습니다');
      }

      // 2. [임시] Access Token을 백엔드로 전송
      // TODO: 백엔드에 POST /auth/google/token 엔드포인트 추가 후 다음과 같이 수정:
      // final response = await apiClient.post(
      //   '/auth/google/token',
      //   data: {
      //     'accessToken': tokens['accessToken'],
      //     'idToken': tokens['idToken'],
      //   },
      // );
      final response = await apiClient.get(
        '${ApiConstants.googleCallback}?access_token=$accessToken',
      );

      final data = handleResponse<Map<String, dynamic>>(response);

      // 3. 토큰 저장
      await _saveTokens(data);

      // 4. 사용자 정보 저장
      await _saveUserInfoFromResponse(data);

      return data;
    } catch (e) {
      // 로그인 실패 시 구글 로그아웃
      await _googleAuthService.signOut();
      throw handleError(e);
    }
  }

  /// 구글 로그아웃
  Future<void> signOutGoogle() async {
    await _googleAuthService.signOut();
  }

  // ========== Kakao 로그인 (SDK 방식 - 모바일 전용) ==========

  /// 카카오 로그인 (SDK 방식 - 모바일 전용)
  ///
  /// Kakao Flutter SDK를 사용하여 인증 후 백엔드에 토큰을 전송합니다.
  /// 웹에서는 loginWithKakaoOAuth()를 사용하세요.
  ///
  /// [백엔드 API 요구사항]
  /// 올바른 구현을 위해서는 백엔드에 다음 엔드포인트가 필요합니다:
  /// - POST /auth/kakao/token
  /// - Request Body: { "accessToken": "..." }
  /// - Response: { "accessToken": "jwt", "refreshToken": "jwt", "user": {...} }
  ///
  /// [현재 임시 구현]
  /// 백엔드 엔드포인트가 없어 임시로 GET /auth/kakao/callback 사용 중
  Future<Map<String, dynamic>> loginWithKakao() async {
    try {
      // 1. Kakao SDK로 로그인하여 Access Token 획득
      final accessToken = await _kakaoAuthService.signIn();

      if (accessToken.isEmpty) {
        throw Exception('Kakao Access Token을 가져올 수 없습니다');
      }

      // 2. [임시] Access Token을 백엔드로 전송
      // TODO: 백엔드에 POST /auth/kakao/token 엔드포인트 추가 후 다음과 같이 수정:
      // final response = await apiClient.post(
      //   '/auth/kakao/token',
      //   data: {
      //     'accessToken': accessToken,
      //   },
      // );
      final response = await apiClient.get(
        '${ApiConstants.kakaoCallback}?access_token=$accessToken',
      );

      final data = handleResponse<Map<String, dynamic>>(response);

      // 3. 토큰 저장
      await _saveTokens(data);

      // 4. 사용자 정보 저장
      await _saveUserInfoFromResponse(data);

      return data;
    } catch (e) {
      // 로그인 실패 시 카카오 로그아웃
      await _kakaoAuthService.signOut();
      throw handleError(e);
    }
  }

  /// 카카오 로그아웃
  Future<void> signOutKakao() async {
    await _kakaoAuthService.signOut();
  }

  // ========== OAuth URL 방식 로그인 (웹 전용) ==========
  // 백엔드의 OAuth 페이지를 브라우저로 열고 리다이렉트로 콜백을 받는 방식
  // 웹 플랫폼 전용 - 모바일에서는 loginWithGoogle(), loginWithKakao() 사용

  /// 구글 OAuth URL 로그인 (웹 전용)
  ///
  /// 백엔드의 OAuth 페이지를 팝업 또는 브라우저로 열어 로그인합니다.
  /// 로그인 완료 후 백엔드는 {FRONTEND_URL}/auth/callback?accessToken=xxx로 리다이렉트합니다.
  ///
  /// - 웹: 팝업 창으로 열고, AccessToken은 응답으로 받아 저장, RefreshToken은 HTTP Only Cookie로 관리
  /// - 모바일: 이 메서드 대신 loginWithGoogle() 사용 (SDK 방식)
  Future<Map<String, dynamic>> loginWithGoogleOAuth() async {
    final oauthUrl = '${EnvironmentConfig.apiBaseUrl}/auth/google';

    try {
      // OAuthWebService를 사용하여 플랫폼별 로그인 처리
      final tokens = await OAuthWebService.login(oauthUrl);

      // 웹: AccessToken은 저장, RefreshToken은 쿠키로 관리
      if (tokens['accessToken'] != null) {
        await apiClient.saveAccessToken(tokens['accessToken']!);
        debugPrint('Web OAuth: AccessToken saved, RefreshToken via cookie');
      }

      return tokens;
    } catch (e) {
      throw handleError(e);
    }
  }

  /// 카카오 OAuth URL 로그인 (웹 전용)
  ///
  /// 백엔드의 OAuth 페이지를 팝업 또는 브라우저로 열어 로그인합니다.
  /// 모바일에서는 이 메서드 대신 loginWithKakao() 사용 (SDK 방식)
  Future<Map<String, dynamic>> loginWithKakaoOAuth() async {
    final oauthUrl = '${EnvironmentConfig.apiBaseUrl}/auth/kakao';

    try {
      // OAuthWebService를 사용하여 플랫폼별 로그인 처리
      final tokens = await OAuthWebService.login(oauthUrl);

      // 웹: AccessToken은 저장, RefreshToken은 쿠키로 관리
      if (tokens['accessToken'] != null) {
        await apiClient.saveAccessToken(tokens['accessToken']!);
        debugPrint('Web OAuth: AccessToken saved, RefreshToken via cookie');
      }

      return tokens;
    } catch (e) {
      throw handleError(e);
    }
  }

  /// OAuth 콜백 스트림 가져오기
  ///
  /// AuthProvider에서 이 스트림을 구독하여 로그인 완료를 감지합니다.
  Stream<OAuthCallbackResult> get oauthCallbackStream =>
      _oauthCallbackHandler.callbackStream;

  /// 저장된 토큰으로 사용자 정보 가져오기
  ///
  /// OAuth 콜백 후 저장된 토큰을 사용하여 사용자 정보를 조회하고 로컬에 저장합니다.
  Future<Map<String, dynamic>> getUserInfo() async {
    try {
      final response = await apiClient.get(ApiConstants.verifyToken);
      final data = handleResponse<Map<String, dynamic>>(response);

      // 사용자 정보 저장
      await _saveUserInfoFromResponse(data);

      return data;
    } catch (e) {
      throw handleError(e);
    }
  }

  /// 로컬에 저장된 사용자 정보 가져오기
  Future<Map<String, dynamic>> getStoredUserInfo() async {
    return await _storage.getUserInfo();
  }

  /// 프로필 업데이트
  Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? phoneNumber,
    String? profileImage,
    String? currentPassword,
    String? newPassword,
  }) async {
    try {
      final requestData = <String, dynamic>{};

      if (name != null) requestData['name'] = name;
      if (phoneNumber != null) requestData['phoneNumber'] = phoneNumber;
      if (profileImage != null) requestData['profileImage'] = profileImage;
      if (currentPassword != null) {
        requestData['currentPassword'] = currentPassword;
      }
      if (newPassword != null) requestData['newPassword'] = newPassword;

      final response = await apiClient.patch(
        ApiConstants.updateProfile,
        data: requestData,
      );
      final data = handleResponse<Map<String, dynamic>>(response);

      // 업데이트된 사용자 정보 저장
      await _saveUserInfoFromResponse(data);

      return data;
    } catch (e) {
      throw handleError(e);
    }
  }
}
