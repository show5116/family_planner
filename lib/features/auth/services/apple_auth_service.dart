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
  /// - fullName: Apple이 최초 로그인 시에만 제공하는 사용자 이름 (재로그인 시 null)
  ///
  /// Throws:
  /// - SignInWithAppleAuthorizationException: 로그인 취소 또는 실패 시
  Future<({String identityToken, String? fullName})> signIn() async {
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

    // Apple은 최초 로그인 시에만 givenName/familyName을 제공한다.
    // Authentication Services가 이미 제공한 정보이므로 앱이 별도로 재입력받지 않고 그대로 백엔드에 전달해야 한다.
    final givenName = credential.givenName?.trim() ?? '';
    final familyName = credential.familyName?.trim() ?? '';
    final fullName = [familyName, givenName].where((s) => s.isNotEmpty).join(' ').trim();

    return (
      identityToken: identityToken,
      fullName: fullName.isNotEmpty ? fullName : null,
    );
  }

  /// Apple Sign In 지원 여부 확인
  static Future<bool> isAvailable() async {
    if (kIsWeb) return true;
    if (defaultTargetPlatform == TargetPlatform.android) return true;
    return await SignInWithApple.isAvailable();
  }
}
