import 'dart:async';

/// 웹이 아닌 플랫폼에서 사용할 OAuth 팝업 스텁
class OAuthPopupWeb {
  /// 웹이 아닌 플랫폼에서는 지원하지 않습니다
  static Future<Map<String, String>> openPopup({
    required String oauthUrl,
    int popupWidth = 500,
    int popupHeight = 600,
  }) async {
    throw UnsupportedError('OAuth popup is only supported on web platform');
  }
}
