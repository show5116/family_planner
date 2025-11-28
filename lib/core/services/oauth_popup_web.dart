import 'dart:async';
import 'dart:js_interop';
import 'package:web/web.dart' as web;

/// 웹 플랫폼에서 OAuth 팝업을 열고 콜백 결과를 처리하는 헬퍼 클래스
class OAuthPopupWeb {
  /// OAuth 팝업 창을 열고 콜백 결과를 기다립니다
  ///
  /// [oauthUrl]: OAuth 인증 URL (예: /auth/google, /auth/kakao)
  /// [popupWidth]: 팝업 창 너비 (기본값: 500)
  /// [popupHeight]: 팝업 창 높이 (기본값: 600)
  ///
  /// Returns: 콜백 URL의 쿼리 파라미터 (accessToken, refreshToken 등)
  static Future<Map<String, String>> openPopup({
    required String oauthUrl,
    int popupWidth = 500,
    int popupHeight = 600,
  }) async {
    final completer = Completer<Map<String, String>>();

    // 화면 중앙에 팝업 위치 계산
    final window = web.window;
    final screen = window.screen;
    final screenLeft = window.screenX.toInt();
    final screenTop = window.screenY.toInt();
    final screenWidth = screen.width.toInt();
    final screenHeight = screen.height.toInt();

    final left = screenLeft + (screenWidth - popupWidth) ~/ 2;
    final top = screenTop + (screenHeight - popupHeight) ~/ 2;

    // 팝업 창 옵션
    final features = 'width=$popupWidth,height=$popupHeight,left=$left,top=$top,'
        'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes';

    // 팝업 창 열기
    final popup = window.open(oauthUrl, 'OAuth Login', features);

    // 팝업이 열리지 않은 경우 (팝업 차단)
    if (popup == null) {
      completer.completeError(Exception('팝업 창을 열 수 없습니다. 팝업 차단을 해제해주세요.'));
      return completer.future;
    }

    // 타임아웃 타이머 (5분)
    final timeoutTimer = Timer(const Duration(minutes: 5), () {
      if (!completer.isCompleted) {
        // 타임아웃 시 팝업 닫기 전에 다시 확인
        if (!popup.closed) {
          popup.close();
        }
        if (!completer.isCompleted) {
          completer.completeError(Exception('로그인 시간이 초과되었습니다'));
        }
      }
    });

    // 팝업이 닫혔는지 주기적으로 확인
    final checkClosedTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (popup.closed) {
        timer.cancel();
        timeoutTimer.cancel();
        if (!completer.isCompleted) {
          completer.completeError(Exception('로그인이 취소되었습니다'));
        }
      }
    });

    // 메시지 이벤트 리스너 등록
    void messageHandler(web.MessageEvent event) {
      // 보안: 같은 origin에서 온 메시지만 처리
      if (event.origin != window.location.origin) {
        return;
      }

      final data = event.data.dartify();
      if (data is Map && data['type'] == 'oauth-callback') {
        // OAuth 콜백 메시지 수신
        timeoutTimer.cancel();
        checkClosedTimer.cancel();
        window.removeEventListener('message', messageHandler.toJS);
        popup.close();

        // completer가 이미 완료되지 않은 경우에만 완료
        if (!completer.isCompleted) {
          final params = Map<String, String>.from(data['params'] as Map);
          completer.complete(params);
        }
      }
    }

    window.addEventListener('message', messageHandler.toJS);

    return completer.future;
  }
}
