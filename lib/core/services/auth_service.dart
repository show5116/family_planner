import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:family_planner/core/services/api_service_base.dart';
import 'package:family_planner/core/constants/api_constants.dart';
import 'package:family_planner/core/config/environment.dart';

/// 인증 서비스
class AuthService extends ApiServiceBase {
  /// 로그인
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await apiClient.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      final data = handleResponse<Map<String, dynamic>>(response);

      // 토큰 저장
      if (data['accessToken'] != null) {
        await apiClient.saveAccessToken(data['accessToken'] as String);
      }
      if (data['refreshToken'] != null) {
        await apiClient.saveRefreshToken(data['refreshToken'] as String);
      }

      return data;
    } catch (e) {
      throw handleError(e);
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
        data: {
          'email': email,
          'password': password,
          'name': name,
        },
      );

      return handleResponse<Map<String, dynamic>>(response);
    } catch (e) {
      throw handleError(e);
    }
  }

  /// 로그아웃
  Future<void> logout() async {
    try {
      await apiClient.post(ApiConstants.logout);
    } catch (e) {
      // 로그아웃 실패해도 로컬 토큰은 삭제
      debugPrint('Logout API failed: $e');
    } finally {
      // 로컬 토큰 삭제
      await apiClient.clearTokens();
    }
  }

  /// 토큰 검증
  Future<bool> verifyToken() async {
    try {
      final response = await apiClient.get(ApiConstants.verifyToken);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// 토큰 갱신
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    try {
      final response = await apiClient.post(
        ApiConstants.refreshToken,
        data: {
          'refreshToken': refreshToken,
        },
      );

      final data = handleResponse<Map<String, dynamic>>(response);

      // 새 토큰 저장
      if (data['accessToken'] != null) {
        await apiClient.saveAccessToken(data['accessToken'] as String);
      }
      if (data['refreshToken'] != null) {
        await apiClient.saveRefreshToken(data['refreshToken'] as String);
      }

      return data;
    } catch (e) {
      throw handleError(e);
    }
  }

  /// 이메일 인증
  Future<Map<String, dynamic>> verifyEmail({
    required String code,
  }) async {
    try {
      final response = await apiClient.post(
        ApiConstants.verifyEmail,
        data: {
          'code': code,
        },
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
        data: {
          'email': email,
        },
      );

      return handleResponse<Map<String, dynamic>>(response);
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
        data: {
          'email': email,
        },
      );

      return handleResponse<Map<String, dynamic>>(response);
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
        data: {
          'email': email,
          'code': code,
          'newPassword': newPassword,
        },
      );

      return handleResponse<Map<String, dynamic>>(response);
    } catch (e) {
      throw handleError(e);
    }
  }

  // Google Sign-In 인스턴스
  // 웹에서는 clientId를 명시적으로 설정해야 함
  late final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    // 웹 플랫폼에서는 clientId 필수, 모바일에서는 선택사항
    clientId: kIsWeb
        ? EnvironmentConfig.googleWebClientId
        : (defaultTargetPlatform == TargetPlatform.android
            ? EnvironmentConfig.googleAndroidClientId
            : EnvironmentConfig.googleIosClientId),
  );

  /// 구글 로그인
  ///
  /// [중요] 현재 구현은 임시 방식입니다.
  /// 백엔드가 모바일/웹 앱용 토큰 검증 엔드포인트를 제공하지 않아
  /// 웹 리다이렉트 방식의 콜백 URL을 사용하고 있습니다.
  ///
  /// 올바른 구현을 위해서는 백엔드에 다음 엔드포인트가 필요합니다:
  /// - POST /auth/google/token
  /// - Request Body: { "accessToken": "...", "idToken": "..." }
  /// - Response: { "accessToken": "jwt", "refreshToken": "jwt", "user": {...} }
  ///
  /// 자세한 내용은 CLAUDE.md의 "소셜 로그인 API" 섹션 참조
  Future<Map<String, dynamic>> loginWithGoogle() async {
    try {
      // 1. Google Sign-In으로 로그인
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Google 로그인이 취소되었습니다');
      }

      // 2. 인증 정보 가져오기
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 3. [임시] ID Token을 백엔드로 전송
      // TODO: 백엔드에 POST /auth/google/token 엔드포인트 추가 후 수정 필요
      final response = await apiClient.get(
        '${ApiConstants.googleCallback}?access_token=${googleAuth.accessToken}',
      );

      final data = handleResponse<Map<String, dynamic>>(response);

      // 4. 토큰 저장
      if (data['accessToken'] != null) {
        await apiClient.saveAccessToken(data['accessToken'] as String);
      }
      if (data['refreshToken'] != null) {
        await apiClient.saveRefreshToken(data['refreshToken'] as String);
      }

      return data;
    } catch (e) {
      // 로그인 실패 시 구글 로그아웃
      await _googleSignIn.signOut();
      throw handleError(e);
    }
  }

  /// 구글 로그아웃
  Future<void> signOutGoogle() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      debugPrint('Google sign out failed: $e');
    }
  }

  /// 카카오 로그인
  ///
  /// [중요] 현재 구현은 임시 방식입니다.
  /// 백엔드가 모바일/웹 앱용 토큰 검증 엔드포인트를 제공하지 않아
  /// 웹 리다이렉트 방식의 콜백 URL을 사용하고 있습니다.
  ///
  /// 올바른 구현을 위해서는 백엔드에 다음 엔드포인트가 필요합니다:
  /// - POST /auth/kakao/token
  /// - Request Body: { "accessToken": "..." }
  /// - Response: { "accessToken": "jwt", "refreshToken": "jwt", "user": {...} }
  ///
  /// 자세한 내용은 CLAUDE.md의 "소셜 로그인 API" 섹션 참조
  Future<Map<String, dynamic>> loginWithKakao() async {
    try {
      // 1. 카카오톡 설치 여부 확인
      bool isInstalled = await isKakaoTalkInstalled();

      OAuthToken token;

      if (isInstalled) {
        // 카카오톡으로 로그인
        try {
          token = await UserApi.instance.loginWithKakaoTalk();
        } catch (e) {
          debugPrint('카카오톡 로그인 실패: $e');
          // 카카오톡 로그인 실패 시 카카오 계정으로 로그인
          token = await UserApi.instance.loginWithKakaoAccount();
        }
      } else {
        // 카카오 계정으로 로그인
        token = await UserApi.instance.loginWithKakaoAccount();
      }

      // 2. [임시] Access Token을 백엔드로 전송
      // TODO: 백엔드에 POST /auth/kakao/token 엔드포인트 추가 후 수정 필요
      final response = await apiClient.get(
        '${ApiConstants.kakaoCallback}?access_token=${token.accessToken}',
      );

      final data = handleResponse<Map<String, dynamic>>(response);

      // 3. 토큰 저장
      if (data['accessToken'] != null) {
        await apiClient.saveAccessToken(data['accessToken'] as String);
      }
      if (data['refreshToken'] != null) {
        await apiClient.saveRefreshToken(data['refreshToken'] as String);
      }

      return data;
    } catch (e) {
      // 로그인 실패 시 카카오 로그아웃
      await signOutKakao();
      throw handleError(e);
    }
  }

  /// 카카오 로그아웃
  Future<void> signOutKakao() async {
    try {
      await UserApi.instance.logout();
    } catch (e) {
      debugPrint('Kakao logout failed: $e');
    }
  }
}
