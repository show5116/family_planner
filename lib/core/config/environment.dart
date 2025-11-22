/// 애플리케이션 환경 설정
enum Environment { development, production }

/// 환경 설정 관리 클래스
class EnvironmentConfig {
  static Environment _currentEnvironment = Environment.development;

  /// 현재 환경 설정
  static Environment get currentEnvironment => _currentEnvironment;

  /// 환경 초기화
  static void setEnvironment(Environment env) {
    _currentEnvironment = env;
  }

  /// 개발 환경 여부
  static bool get isDevelopment =>
      _currentEnvironment == Environment.development;

  /// 프로덕션 환경 여부
  static bool get isProduction => _currentEnvironment == Environment.production;

  /// API 베이스 URL
  static String get apiBaseUrl {
    switch (_currentEnvironment) {
      case Environment.development:
        return 'http://localhost:3000';
      case Environment.production:
        return 'https://familyplannerbackend-production.up.railway.app';
    }
  }

  /// API 타임아웃 설정 (밀리초)
  static int get apiTimeout {
    switch (_currentEnvironment) {
      case Environment.development:
        return 30000; // 30초
      case Environment.production:
        return 15000; // 15초
    }
  }

  /// 로그 활성화 여부
  static bool get enableLogging => isDevelopment;

  /// 디버그 모드 여부
  static bool get isDebugMode => isDevelopment;

  // ========== OAuth 설정 ==========

  /// Google OAuth 웹 클라이언트 ID
  /// Google Cloud Console에서 발급: https://console.cloud.google.com/apis/credentials
  /// 발급 후 web/index.html의 meta 태그도 함께 업데이트 필요
  static String get googleWebClientId {
    // TODO: Google Cloud Console에서 OAuth 2.0 클라이언트 ID 발급 후 설정
    return '1091403716522-pgm7m06s5tcpen6g0okcpvd8djfq0m5l.apps.googleusercontent.com';
  }

  /// Google OAuth Android 클라이언트 ID (선택사항)
  /// android/app/src/main/res/values/strings.xml에서도 설정 필요
  static String? get googleAndroidClientId {
    // 필요시 설정
    return null;
  }

  /// Google OAuth iOS 클라이언트 ID (선택사항)
  /// ios/Runner/Info.plist에서도 설정 필요
  static String? get googleIosClientId {
    // 필요시 설정
    return null;
  }

  /// Kakao Native App Key
  /// Kakao Developers에서 발급: https://developers.kakao.com
  static String get kakaoNativeAppKey {
    // TODO: Kakao Developers 콘솔에서 Native App Key 발급 후 설정
    return 'YOUR_KAKAO_NATIVE_APP_KEY';
  }

  /// Kakao JavaScript App Key (웹용)
  static String get kakaoJavaScriptAppKey {
    // TODO: Kakao Developers 콘솔에서 JavaScript Key 발급 후 설정
    return 'YOUR_KAKAO_JAVASCRIPT_APP_KEY';
  }
}
