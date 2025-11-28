import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:family_planner/core/services/oauth_popup_web.dart';

/// OAuth 웹 인증 서비스
///
/// 웹 플랫폼에서 OAuth URL 방식 로그인을 처리합니다.
/// - 웹: 팝업 창으로 OAuth 페이지를 열고 메시지로 토큰 수신
/// - 모바일: 외부 브라우저로 OAuth 페이지를 열고 Deep Link로 콜백 수신
class OAuthWebService {
  /// OAuth URL로 로그인 (웹/모바일 공통)
  ///
  /// [oauthUrl] 백엔드 OAuth 엔드포인트 URL
  ///
  /// Returns:
  /// - 웹: { 'accessToken': '...', 'refreshToken': '...' }
  /// - 모바일: {} (Deep Link로 콜백 처리)
  ///
  /// Throws:
  /// - Exception: OAuth 인증 실패 시
  static Future<Map<String, String>> login(String oauthUrl) async {
    if (kIsWeb) {
      return await _loginWeb(oauthUrl);
    } else {
      return await _loginMobile(oauthUrl);
    }
  }

  /// 웹에서 OAuth 로그인
  ///
  /// 팝업 창으로 OAuth 페이지를 열고 postMessage로 토큰을 수신합니다.
  static Future<Map<String, String>> _loginWeb(String oauthUrl) async {
    try {
      // 팝업으로 열고 토큰 수신
      final params = await OAuthPopupWeb.openPopup(oauthUrl: oauthUrl);

      final accessToken = params['accessToken'];
      final refreshToken = params['refreshToken'];

      if (accessToken == null || refreshToken == null) {
        throw Exception('OAuth 인증에 실패했습니다');
      }

      return {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
      };
    } catch (e) {
      throw Exception('OAuth 로그인 실패: $e');
    }
  }

  /// 모바일에서 OAuth 로그인
  ///
  /// 외부 브라우저로 OAuth 페이지를 열고 Deep Link로 콜백을 받습니다.
  static Future<Map<String, String>> _loginMobile(String oauthUrl) async {
    try {
      final uri = Uri.parse(oauthUrl);
      final canLaunch = await canLaunchUrl(uri);

      if (!canLaunch) {
        throw Exception('브라우저를 열 수 없습니다');
      }

      await launchUrl(uri, mode: LaunchMode.externalApplication);

      // 모바일에서는 Deep Link로 콜백 처리되므로 빈 Map 반환
      return {};
    } catch (e) {
      throw Exception('OAuth 로그인 실패: $e');
    }
  }
}
