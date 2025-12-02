import 'dart:js_interop';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:web/web.dart' as web;

/// 웹 플랫폼에서 OAuth 팝업의 부모 창으로 메시지를 전송하는 헬퍼
class OAuthPopupHelper {
  /// 팝업 창에서 호출: 부모 창으로 OAuth 콜백 결과를 전송하고 창을 닫습니다
  ///
  /// [params]: 전송할 파라미터 (accessToken, refreshToken 등)
  static void sendMessageToParent(Map<String, String> params) {
    if (!kIsWeb) return;

    final window = web.window;

    // opener가 있는 경우 (팝업 창인 경우)
    if (window.opener != null) {
      // 부모 창으로 메시지 전송
      final message = <String, dynamic>{
        'type': 'oauth-callback',
        'params': params,
      }.jsify();

      // opener를 Window 타입으로 캐스팅
      final parentWindow = window.opener as web.Window;
      parentWindow.postMessage(
        message,
        window.location.origin.toJS,
      );

      // 창 닫기
      window.close();
    }
  }

  /// 현재 창이 팝업인지 확인
  static bool isPopup() {
    if (!kIsWeb) return false;
    return web.window.opener != null;
  }
}
