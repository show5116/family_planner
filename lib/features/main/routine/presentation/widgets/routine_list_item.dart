import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/routine/data/models/routine_model.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 루틴 목록의 개별 카드 (체크 토글 포함)
class RoutineListItem extends StatelessWidget {
  const RoutineListItem({
    super.key,
    required this.routine,
    required this.onTap,
    required this.onToggleCheck,
    this.dragHandle,
  });

  final Routine routine;
  final VoidCallback onTap;
  final VoidCallback onToggleCheck;
  final Widget? dragHandle;

  Color _accentColor(BuildContext context) {
    if (routine.color == null) return Theme.of(context).colorScheme.primary;
    try {
      final hex = routine.color!.replaceFirst('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return Theme.of(context).colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final accent = _accentColor(context);
    final progress = routine.targetCount != null && routine.targetCount! > 0
        ? '${routine.targetCount}${l10n.routine_field_target_count}'
        : null;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.spaceM),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spaceM,
            vertical: AppSizes.spaceS,
          ),
          child: Row(
            children: [
              if (dragHandle != null) ...[
                dragHandle!,
                const SizedBox(width: AppSizes.spaceS),
              ],
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                ),
                alignment: Alignment.center,
                child: Text(
                  routine.emoji ?? '✅',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(width: AppSizes.spaceM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      routine.title,
                      style: Theme.of(context).textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (progress != null)
                      Text(
                        '${l10n.routine_this_week_progress}: $progress',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                      ),
                  ],
                ),
              ),
              IconButton(
                iconSize: 28,
                onPressed: onToggleCheck,
                icon: Icon(
                  routine.checkedToday
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: routine.checkedToday
                      ? accent
                      : colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
