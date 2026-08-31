import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/routine/data/models/routine_model.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 배지 획득 축하 다이얼로그 (체크 시 newlyEarnedBadges가 있을 때 표시)
Future<void> showRoutineBadgeCelebration(
  BuildContext context,
  List<UserRoutineBadge> badges,
) async {
  if (badges.isEmpty) return;
  final l10n = AppLocalizations.of(context)!;

  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.routine_badge_earned_title),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: badges.map((earned) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceS),
              child: Row(
                children: [
                  Text(
                    earned.badge.iconEmoji ?? '🏅',
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(width: AppSizes.spaceM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          earned.badge.title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        if (earned.badge.description != null)
                          Text(
                            earned.badge.description!,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.routine_badge_earned_confirm),
        ),
      ],
    ),
  );
}
