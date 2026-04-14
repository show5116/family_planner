import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/features/onboarding/services/onboarding_service.dart';

/// 온보딩 완료 여부 상태
///
/// null = 아직 로드 안됨 (로딩 중)
/// true  = 온보딩 완료
/// false = 온보딩 미완료 (보여줘야 함)
class OnboardingNotifier extends StateNotifier<bool?> {
  OnboardingNotifier() : super(null);

  /// SharedPreferences에서 완료 여부 로드
  Future<void> load() async {
    final completed = await OnboardingService.isOnboardingCompleted();
    state = completed;
  }

  /// 온보딩 완료 처리
  Future<void> complete() async {
    await OnboardingService.completeOnboarding();
    state = true;
  }
}

final onboardingProvider = StateNotifierProvider<OnboardingNotifier, bool?>((ref) {
  return OnboardingNotifier();
});
