import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:family_planner/core/services/api_service_base.dart';
import 'package:family_planner/core/constants/api_constants.dart';
import 'package:family_planner/core/config/environment.dart';
import 'package:family_planner/core/services/oauth_callback_handler.dart';
import 'package:family_planner/core/services/oauth_popup_web.dart';

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

      // 로컬 토큰 삭제
      await apiClient.clearTokens();
      debugPrint('Local tokens cleared');
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
        data: {
          'email': email,
        },
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
      // 1. Google Sign-In으로 로그인
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Google 로그인이 취소되었습니다');
      }

      // 2. 인증 정보 가져오기
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 3. [임시] Access Token을 백엔드로 전송
      // TODO: 백엔드에 POST /auth/google/token 엔드포인트 추가 후 다음과 같이 수정:
      // final response = await apiClient.post(
      //   '/auth/google/token',
      //   data: {
      //     'accessToken': googleAuth.accessToken,
      //     'idToken': googleAuth.idToken,
      //   },
      // );
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
      // TODO: 백엔드에 POST /auth/kakao/token 엔드포인트 추가 후 다음과 같이 수정:
      // final response = await apiClient.post(
      //   '/auth/kakao/token',
      //   data: {
      //     'accessToken': token.accessToken,
      //   },
      // );
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

  // ========== OAuth URL 방식 로그인 (웹 전용) ==========
  // 백엔드의 OAuth 페이지를 브라우저로 열고 리다이렉트로 콜백을 받는 방식
  // 웹 플랫폼 전용 - 모바일에서는 loginWithGoogle(), loginWithKakao() 사용

  final _oauthCallbackHandler = OAuthCallbackHandler();

  /// 구글 OAuth URL 로그인 (웹 전용)
  ///
  /// 백엔드의 OAuth 페이지를 팝업 또는 브라우저로 열어 로그인합니다.
  /// 로그인 완료 후 백엔드는 {FRONTEND_URL}/auth/callback?accessToken=xxx&refreshToken=xxx로 리다이렉트합니다.
  ///
  /// - 웹: 팝업 창으로 열고 메시지로 토큰 수신
  /// - 모바일: 이 메서드 대신 loginWithGoogle() 사용 (SDK 방식)
  Future<Map<String, dynamic>> loginWithGoogleOAuth() async {
    final oauthUrl = '${EnvironmentConfig.apiBaseUrl}/auth/google';

    try {
      if (kIsWeb) {
        // 웹: 팝업으로 열고 토큰 수신
        final params = await OAuthPopupWeb.openPopup(oauthUrl: oauthUrl);

        final accessToken = params['accessToken'];
        final refreshToken = params['refreshToken'];

        if (accessToken == null || refreshToken == null) {
          throw Exception('OAuth 인증에 실패했습니다');
        }

        // 토큰 저장
        await apiClient.saveAccessToken(accessToken);
        await apiClient.saveRefreshToken(refreshToken);

        return {
          'accessToken': accessToken,
          'refreshToken': refreshToken,
        };
      } else {
        // 모바일: 외부 브라우저로 열기 (기존 방식)
        final uri = Uri.parse(oauthUrl);
        final canLaunch = await canLaunchUrl(uri);
        if (!canLaunch) {
          throw Exception('브라우저를 열 수 없습니다');
        }

        await launchUrl(uri, mode: LaunchMode.externalApplication);

        // 모바일에서는 Deep Link로 콜백 처리
        return {};
      }
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
      if (kIsWeb) {
        // 웹: 팝업으로 열고 토큰 수신
        final params = await OAuthPopupWeb.openPopup(oauthUrl: oauthUrl);

        final accessToken = params['accessToken'];
        final refreshToken = params['refreshToken'];

        if (accessToken == null || refreshToken == null) {
          throw Exception('OAuth 인증에 실패했습니다');
        }

        // 토큰 저장
        await apiClient.saveAccessToken(accessToken);
        await apiClient.saveRefreshToken(refreshToken);

        return {
          'accessToken': accessToken,
          'refreshToken': refreshToken,
        };
      } else {
        // 모바일: 외부 브라우저로 열기 (기존 방식)
        final uri = Uri.parse(oauthUrl);
        final canLaunch = await canLaunchUrl(uri);
        if (!canLaunch) {
          throw Exception('브라우저를 열 수 없습니다');
        }

        await launchUrl(uri, mode: LaunchMode.externalApplication);

        // 모바일에서는 Deep Link로 콜백 처리
        return {};
      }
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
  /// OAuth 콜백 후 저장된 토큰을 사용하여 사용자 정보를 조회합니다.
  Future<Map<String, dynamic>> getUserInfo() async {
    try {
      final response = await apiClient.get(ApiConstants.verifyToken);
      return handleResponse<Map<String, dynamic>>(response);
    } catch (e) {
      throw handleError(e);
    }
  }
}
