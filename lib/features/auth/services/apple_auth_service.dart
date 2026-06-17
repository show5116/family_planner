import 'package:flutter/foundation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Apple 인증 서비스 (모바일 전용)
///
/// sign_in_with_apple 패키지를 사용한 인증을 담당합니다.
/// - 웹: OAuth URL 방식 (auth_service.dart의 loginWithAppleOAuth 사용)
/// - 모바일: SDK 방식 (이 서비스 사용)
class AppleAuthService {
  /// Apple 로그인 (SDK 방식 - iOS/macOS 전용)
  ///
  /// Returns:
  /// - identityToken: Apple Identity Token (JWT)
  ///
  /// Throws:
  /// - SignInWithAppleAuthorizationException: 로그인 취소 또는 실패 시
  Future<String> signIn() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final identityToken = credential.identityToken;
    if (identityToken == null || identityToken.isEmpty) {
      throw Exception('Apple Identity Token을 가져올 수 없습니다');
    }

    return identityToken;
  }

  /// Apple Sign In 지원 여부 확인
  static Future<bool> isAvailable() async {
    if (kIsWeb) return false;
    return await SignInWithApple.isAvailable();
  }
}
