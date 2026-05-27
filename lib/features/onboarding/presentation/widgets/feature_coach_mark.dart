import 'dart:async';

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
  /// [forceShow]가 true면 완료 여부와 관계없이 즉시 표시
  static Future<void> show({
    required BuildContext context,
    required String featureKey,
    required List<TargetFocus> targets,
    FutureOr<void> Function(TargetFocus)? onClickTarget,
    FutureOr<void> Function(TargetFocus)? beforeFocus,
    AlignmentGeometry alignSkip = Alignment.topRight,
    bool forceShow = false,
  }) async {
    if (!forceShow) {
      final completed = await OnboardingService.isCoachMarkCompleted(featureKey);
      if (completed || !context.mounted) return;
    }
    if (!context.mounted) return;

    await waitForTargets(targets, context);
    if (!context.mounted) return;

    // 레이아웃 완료 후 좌표 재계산 — 화면이 빠르게 열릴 때 사전 계산된
    // targetPosition이 아직 settle되지 않은 좌표를 가질 수 있으므로
    // keyTarget이 있는 타겟은 항상 이 시점에 재계산한다
    final refreshed = refreshPositions(targets);

    TutorialCoachMark(
      targets: refreshed,
      colorShadow: AppColors.textPrimary,
      opacityShadow: 0.85,
      textSkip: '건너뛰기',
      alignSkip: alignSkip,
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
      onClickTarget: onClickTarget,
      beforeFocus: beforeFocus,
      paddingFocus: 8,
      focusAnimationDuration: const Duration(milliseconds: 300),
      pulseAnimationDuration: const Duration(milliseconds: 800),
    ).show(context: context);
  }

  /// GlobalKey로부터 현재 레이아웃 기준 TargetPosition을 계산한다
  static TargetPosition? positionFromKey(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return null;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return null;
    return TargetPosition(box.size, box.localToGlobal(Offset.zero));
  }

  /// keyTarget이 있는 TargetFocus의 targetPosition을 현재 시점 좌표로 갱신한 새 리스트 반환
  ///
  /// TargetFocus.targetPosition이 final이라 직접 수정 불가 — keyTarget이 있으면
  /// positionFromKey로 좌표를 재계산한 새 TargetFocus로 교체한다.
  static List<TargetFocus> refreshPositions(List<TargetFocus> targets) {
    return targets.map((t) {
      final key = t.keyTarget;
      if (key == null) return t;
      final pos = positionFromKey(key);
      if (pos == null) return t;
      return TargetFocus(
        identify: t.identify,
        keyTarget: t.keyTarget,
        targetPosition: pos,
        contents: t.contents,
        shape: t.shape,
        radius: t.radius,
        borderSide: t.borderSide,
        color: t.color,
        enableOverlayTab: t.enableOverlayTab,
        enableTargetTab: t.enableTargetTab,
        alignSkip: t.alignSkip,
        paddingFocus: t.paddingFocus,
        focusAnimationDuration: t.focusAnimationDuration,
        unFocusAnimationDuration: t.unFocusAnimationDuration,
        pulseVariation: t.pulseVariation,
      );
    }).toList();
  }

  /// keyTarget 기반 타겟이 모두 렌더링되고 RenderBox 크기가 유효할 때까지 대기
  ///
  /// context 존재만으로는 부족 — 화면이 빠르게 열릴 때 첫 프레임에서는
  /// 레이아웃이 아직 settle되지 않아 localToGlobal 좌표가 틀릴 수 있다.
  static Future<void> waitForTargets(
    List<TargetFocus> targets,
    BuildContext context,
  ) async {
    // 화면 진입 직후 레이아웃 settle을 위한 최소 대기
    await Future.delayed(const Duration(milliseconds: 150));
    if (!context.mounted) return;

    for (var i = 0; i < 15; i++) {
      final allReady = targets.every((t) {
        final key = t.keyTarget;
        if (key != null) {
          final ctx = key.currentContext;
          if (ctx == null) return false;
          final box = ctx.findRenderObject() as RenderBox?;
          return box != null && box.hasSize && box.size.width > 0 && box.size.height > 0;
        }
        // keyTarget 없고 targetPosition만 있으면 수동 좌표 — 통과
        return t.targetPosition != null;
      });
      if (allReady) return;
      await Future.delayed(const Duration(milliseconds: 150));
      if (!context.mounted) return;
    }
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
