import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/routine/data/models/routine_model.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 스트릭 통계 카드 (현재 연속 일수 하이라이트 + 보조 통계 + 기간 진행).
///
/// 습관별 연속 기록은 배지가 아니라 이 카드로 확인한다(배지는 일일 목표
/// 기준의 사용자 단위 성취로 분리됨).
///
/// 보조 통계는 [frequencyType]에 따라 달라진다. 월간 습관은 "연속 주"가
/// 의미가 없어 0만 나오므로, 대신 "연속 달"을 보여준다.
class RoutineStreakCard extends StatelessWidget {
  const RoutineStreakCard({
    super.key,
    required this.streak,
    this.frequencyType,
  });

  final RoutineStreak streak;

  /// null이면 주 단위 지표를 보여준다(기존 동작).
  final RoutineFrequencyType? frequencyType;

  bool get _isMonthly => frequencyType == RoutineFrequencyType.monthly;

  Widget _subStatTile(BuildContext context, String label, int value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            '$value',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSizes.spaceXS),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final progress = streak.thisWeekProgress;
    final ratio = progress.target > 0
        ? (progress.checked / progress.target).clamp(0.0, 1.0)
        : 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 현재 연속 일수 하이라이트
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: AppSizes.spaceL,
                horizontal: AppSizes.spaceM,
              ),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              ),
              child: Column(
                children: [
                  Text(
                    '🔥 ${streak.currentStreakDays}',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.warning,
                    ),
                  ),
                  const SizedBox(height: AppSizes.spaceXS),
                  Text(
                    l10n.routine_streak_current_days,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.spaceM),
            // 보조 통계 (최장 일수 / 현재 주 / 최장 주)
            Row(
              children: [
                _subStatTile(
                  context,
                  l10n.routine_streak_longest_days,
                  streak.longestStreakDays,
                ),
                _subStatTile(
                  context,
                  _isMonthly
                      ? l10n.routine_streak_current_months
                      : l10n.routine_streak_current_weeks,
                  _isMonthly
                      ? streak.currentStreakMonths
                      : streak.currentStreakWeeks,
                ),
                _subStatTile(
                  context,
                  _isMonthly
                      ? l10n.routine_streak_longest_months
                      : l10n.routine_streak_longest_weeks,
                  _isMonthly
                      ? streak.longestStreakMonths
                      : streak.longestStreakWeeks,
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spaceL),
            Text(
              _isMonthly
                  ? l10n.routine_this_month_progress_label
                  : l10n.routine_this_week_progress,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: AppSizes.spaceS),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              child: LinearProgressIndicator(value: ratio, minHeight: 8),
            ),
            const SizedBox(height: AppSizes.spaceXS),
            Text(
              '${progress.checked} / ${progress.target}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
