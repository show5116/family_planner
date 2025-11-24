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

  /// 프론트엔드 URL (OAuth 콜백에 사용)
  ///
  /// 백엔드가 OAuth 인증 후 이 URL로 리다이렉트합니다.
  /// - 개발: localhost:3001 (웹)
  /// - 프로덕션: 실제 도메인 (웹), Universal/App Links (모바일)
  static String get frontendUrl {
    switch (_currentEnvironment) {
      case Environment.development:
        return 'http://localhost:3001';
      case Environment.production:
        return 'https://family-planner-web.netlify.app/';
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
    return const String.fromEnvironment(
      'GOOGLE_WEB_CLIENT_ID',
      defaultValue: '1091403716522-pgm7m06s5tcpen6g0okcpvd8djfq0m5l.apps.googleusercontent.com',
    );
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
    return const String.fromEnvironment(
      'KAKAO_NATIVE_APP_KEY',
      defaultValue: 'YOUR_KAKAO_NATIVE_APP_KEY',
    );
  }

  /// Kakao JavaScript App Key (웹용)
  static String get kakaoJavaScriptAppKey {
    return const String.fromEnvironment(
      'KAKAO_JS_APP_KEY',
      defaultValue: 'f0366e83a5499e200ce35d5d18688d8f',
    );
  }
}
