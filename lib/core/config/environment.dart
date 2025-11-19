/// 애플리케이션 환경 설정
enum Environment {
  development,
  production,
}

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
  static bool get isDevelopment => _currentEnvironment == Environment.development;

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
}
