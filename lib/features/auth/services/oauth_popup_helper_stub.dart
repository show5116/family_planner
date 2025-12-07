// 웹이 아닌 플랫폼에서 사용할 OAuth 팝업 헬퍼 스텁
class OAuthPopupHelper {
  /// 웹이 아닌 플랫폼에서는 지원하지 않습니다
  static void sendMessageToParent(Map<String, String> params) {
    // 웹이 아닌 플랫폼에서는 아무것도 하지 않음
  }

  /// 웹이 아닌 플랫폼에서는 항상 false 반환
  static bool isPopup() {
    return false;
  }
}
