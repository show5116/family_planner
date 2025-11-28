import 'package:flutter/foundation.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

/// Kakao 인증 서비스
///
/// Kakao Flutter SDK를 사용한 인증을 담당합니다.
/// - 웹: OAuth URL 방식 (auth_service.dart의 loginWithKakaoOAuth 사용)
/// - 모바일: SDK 방식 (이 서비스 사용)
class KakaoAuthService {
  /// 카카오 로그인 (SDK 방식 - 모바일 전용)
  ///
  /// Kakao Flutter SDK를 사용하여 로그인하고 Access Token을 반환합니다.
  ///
  /// Returns:
  /// - accessToken: Kakao Access Token
  ///
  /// Throws:
  /// - Exception: 로그인 취소 또는 실패 시
  Future<String> signIn() async {
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

      // 2. Access Token 반환
      return token.accessToken;
    } catch (e) {
      // 로그인 실패 시 카카오 로그아웃
      await signOut();
      rethrow;
    }
  }

  /// 카카오 로그아웃
  Future<void> signOut() async {
    try {
      await UserApi.instance.logout();
    } catch (e) {
      debugPrint('Kakao logout failed: $e');
    }
  }

  /// 카카오 연결 끊기 (회원 탈퇴)
  Future<void> unlink() async {
    try {
      await UserApi.instance.unlink();
    } catch (e) {
      debugPrint('Kakao unlink failed: $e');
      rethrow;
    }
  }

  /// 현재 카카오 사용자 정보 가져오기
  Future<User?> getCurrentUser() async {
    try {
      return await UserApi.instance.me();
    } catch (e) {
      debugPrint('Failed to get Kakao user info: $e');
      return null;
    }
  }

  /// 카카오톡 설치 여부 확인
  Future<bool> checkKakaoTalkInstalled() async {
    return await isKakaoTalkInstalled();
  }
}
