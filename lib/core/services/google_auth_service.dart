import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:family_planner/core/config/environment.dart';

/// Google 인증 서비스
///
/// Google Sign-In SDK를 사용한 인증을 담당합니다.
/// - 웹: OAuth URL 방식 (auth_service.dart의 loginWithGoogleOAuth 사용)
/// - 모바일: SDK 방식 (이 서비스 사용)
class GoogleAuthService {
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
  /// Google Sign-In SDK를 사용하여 로그인하고 Access Token과 ID Token을 반환합니다.
  ///
  /// Returns:
  /// - accessToken: Google Access Token
  /// - idToken: Google ID Token
  ///
  /// Throws:
  /// - Exception: 로그인 취소 또는 실패 시
  Future<Map<String, String>> signIn() async {
    try {
      // 1. Google Sign-In으로 로그인
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Google 로그인이 취소되었습니다');
      }

      // 2. 인증 정보 가져오기
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 3. 토큰 반환
      return {
        'accessToken': googleAuth.accessToken ?? '',
        'idToken': googleAuth.idToken ?? '',
      };
    } catch (e) {
      // 로그인 실패 시 구글 로그아웃
      await signOut();
      rethrow;
    }
  }

  /// 구글 로그아웃
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      debugPrint('Google sign out failed: $e');
    }
  }

  /// 현재 로그인된 Google 계정 가져오기
  Future<GoogleSignInAccount?> getCurrentUser() async {
    return _googleSignIn.currentUser;
  }

  /// 자동 로그인 시도 (이전에 로그인한 적이 있는 경우)
  Future<GoogleSignInAccount?> signInSilently() async {
    try {
      return await _googleSignIn.signInSilently();
    } catch (e) {
      debugPrint('Silent sign-in failed: $e');
      return null;
    }
  }
}
