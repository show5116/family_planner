import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/routine/data/models/routine_model.dart';
import 'package:family_planner/features/main/routine/presentation/widgets/routine_check_value_dialog.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 루틴 목록의 개별 카드 (체크 토글 포함)
class RoutineListItem extends StatefulWidget {
  const RoutineListItem({
    super.key,
    required this.routine,
    required this.onTap,
    required this.onToggleCheck,
    this.onEdit,
    this.onPause,
    this.onResume,
    this.dragHandle,
  });

  final Routine routine;
  final VoidCallback onTap;
  final Future<void> Function({
    String? textValue,
    num? numericValue,
    String? timeValue,
  })
  onToggleCheck;
  final VoidCallback? onEdit;
  final VoidCallback? onPause;
  final VoidCallback? onResume;
  final Widget? dragHandle;

  @override
  State<RoutineListItem> createState() => _RoutineListItemState();
}

class _RoutineListItemState extends State<RoutineListItem> {
  Routine get routine => widget.routine;
  VoidCallback get onTap => widget.onTap;
  Widget? get dragHandle => widget.dragHandle;

  Color _accentColor(BuildContext context) {
    return AppColors.parseHex(
      routine.color,
      fallback: Theme.of(context).colorScheme.primary,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final accent = _accentColor(context);
    final progress = routine.targetCount != null && routine.targetCount! > 0
        ? '${routine.targetCount}${l10n.routine_field_target_count}'
        : null;
    final isPaused = routine.status == RoutineStatus.paused;
    final canCheck = routine.status == RoutineStatus.active;

    return Opacity(
      opacity: isPaused ? 0.55 : 1.0,
      child: Card(
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
                  child: (routine.emoji != null && routine.emoji!.isNotEmpty)
                      ? Text(
                          routine.emoji!,
                          style: const TextStyle(fontSize: 20),
                        )
                      : Icon(
                          Icons.check_circle_outline,
                          size: 20,
                          color: accent,
                        ),
                ),
                const SizedBox(width: AppSizes.spaceM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              routine.title,
                              style: Theme.of(context).textTheme.titleMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isPaused) ...[
                            const SizedBox(width: AppSizes.spaceS),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 1,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                l10n.routine_status_paused,
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (progress != null)
                        Text(
                          '${l10n.routine_this_week_progress}: $progress',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: colorScheme.onSurfaceVariant),
                        ),
                    ],
                  ),
                ),
                _CheckIndicator(
                  routine: routine,
                  accent: accent,
                  enabled: canCheck,
                  onTap: _handleToggleCheck,
                ),
                if (widget.onEdit != null ||
                    widget.onPause != null ||
                    widget.onResume != null)
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      size: 18,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    onSelected: (value) {
                      switch (value) {
                        case 'edit':
                          widget.onEdit?.call();
                        case 'pause':
                          widget.onPause?.call();
                        case 'resume':
                          widget.onResume?.call();
                      }
                    },
                    itemBuilder: (context) => [
                      if (widget.onEdit != null)
                        PopupMenuItem(
                          value: 'edit',
                          child: Text(l10n.routine_edit),
                        ),
                      if (isPaused && widget.onResume != null)
                        PopupMenuItem(
                          value: 'resume',
                          child: Text(l10n.routine_resume),
                        ),
                      if (!isPaused && widget.onPause != null)
                        PopupMenuItem(
                          value: 'pause',
                          child: Text(l10n.routine_pause),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleToggleCheck() async {
    if (routine.checkedToday ||
        routine.recordType == RoutineRecordType.boolean_) {
      await widget.onToggleCheck();
      return;
    }
    final value = await showRoutineCheckValueDialog(
      context,
      routine.recordType,
    );
    if (value == null || !mounted) return;
    await widget.onToggleCheck(
      textValue: value.textValue,
      numericValue: value.numericValue,
      timeValue: value.timeValue,
    );
  }
}

/// 체크 여부/기록값을 recordType에 맞게 보여주는 인디케이터.
/// BOOLEAN=체크 아이콘, TEXT/NUMERIC/TIME=실제 기록값을 배지로 표시.
class _CheckIndicator extends StatelessWidget {
  const _CheckIndicator({
    required this.routine,
    required this.accent,
    required this.enabled,
    required this.onTap,
  });

  final Routine routine;
  final Color accent;
  final bool enabled;
  final VoidCallback onTap;

  String? get _valueLabel {
    final log = routine.checkedLog;
    if (log == null) return null;
    switch (routine.recordType) {
      case RoutineRecordType.text:
        return log.textValue;
      case RoutineRecordType.numeric:
        return log.numericValue != null ? '${log.numericValue}' : null;
      case RoutineRecordType.time:
        return log.timeValue;
      case RoutineRecordType.boolean_:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final checked = routine.checkedToday;
    final valueLabel = checked ? _valueLabel : null;

    final icon = TweenAnimationBuilder<double>(
      key: ValueKey(checked),
      tween: Tween(begin: 0.6, end: 1.0),
      duration: const Duration(milliseconds: 200),
      curve: Curves.elasticOut,
      builder: (context, scale, child) =>
          Transform.scale(scale: scale, child: child),
      child: Icon(
        checked ? Icons.check_circle : Icons.radio_button_unchecked,
        color: checked ? accent : colorScheme.onSurfaceVariant,
      ),
    );

    if (valueLabel == null || valueLabel.isEmpty) {
      return IconButton(
        iconSize: 28,
        onPressed: enabled ? onTap : null,
        icon: icon,
      );
    }

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spaceS,
          vertical: 4,
        ),
        constraints: const BoxConstraints(maxWidth: 88),
        decoration: BoxDecoration(
          color: accent.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, size: 16, color: accent),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                valueLabel,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: accent,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
