import 'package:shared_preferences/shared_preferences.dart';

/// 온보딩 완료 상태를 SharedPreferences에 저장/조회하는 서비스
class OnboardingService {
  static const String _onboardingCompletedKey = 'onboarding_completed';
  static const String _coachMarkPrefix = 'coach_mark_';

  /// 앱 최초 진입 온보딩 슬라이드 완료 여부
  static Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingCompletedKey) ?? false;
  }

  /// 온보딩 슬라이드 완료 처리
  static Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompletedKey, true);
  }

  /// 특정 기능의 코치마크 완료 여부
  static Future<bool> isCoachMarkCompleted(String featureKey) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('$_coachMarkPrefix$featureKey') ?? false;
  }

  /// 특정 기능의 코치마크 완료 처리
  static Future<void> completeCoachMark(String featureKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_coachMarkPrefix$featureKey', true);
  }

  /// 개발/테스트용: 모든 온보딩 상태 초기화
  static Future<void> resetAll() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where(
      (k) => k == _onboardingCompletedKey || k.startsWith(_coachMarkPrefix),
    );
    for (final key in keys) {
      await prefs.remove(key);
    }
  }
}

/// 코치마크 기능 키 상수
class CoachMarkKeys {
  CoachMarkKeys._();

  static const String calendar = 'calendar';
  static const String todo = 'todo';
  static const String groupManagement = 'group_management';
  static const String household = 'household';
  static const String assets = 'assets';
  static const String more = 'more';
}
