import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/onboarding/services/onboarding_service.dart';

/// 기능별 코치마크를 표시하는 헬퍼
///
/// 사용법:
/// ```dart
/// FeatureCoachMark.show(
///   context: context,
///   featureKey: CoachMarkKeys.calendar,
///   targets: [...],
/// );
/// ```
class FeatureCoachMark {
  /// 해당 기능의 코치마크를 처음 진입 시 1회만 표시
  static Future<void> show({
    required BuildContext context,
    required String featureKey,
    required List<TargetFocus> targets,
  }) async {
    final completed = await OnboardingService.isCoachMarkCompleted(featureKey);
    if (completed || !context.mounted) return;

    TutorialCoachMark(
      targets: targets,
      colorShadow: AppColors.textPrimary,
      opacityShadow: 0.85,
      textSkip: '건너뛰기',
      skipWidget: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white30),
        ),
        child: const Text(
          '건너뛰기',
          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ),
      onFinish: () => OnboardingService.completeCoachMark(featureKey),
      onSkip: () {
        OnboardingService.completeCoachMark(featureKey);
        return true;
      },
      paddingFocus: 8,
      focusAnimationDuration: const Duration(milliseconds: 300),
      pulseAnimationDuration: const Duration(milliseconds: 800),
    ).show(context: context);
  }

  /// 코치마크 말풍선 콘텐츠 빌더
  static Widget buildContent({
    required String title,
    required String description,
    IconData? icon,
    Color color = AppColors.primary,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
