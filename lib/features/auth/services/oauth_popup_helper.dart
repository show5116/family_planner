// OAuth 팝업 헬퍼 - 플랫폼별 조건부 import
// 웹 플랫폼에서는 실제 팝업 구현을, 다른 플랫폼에서는 스텁을 사용합니다.
export 'oauth_popup_stub.dart'
    if (dart.library.html) 'oauth_popup_web.dart'
    if (dart.library.js_interop) 'oauth_popup_web.dart';
