import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/routine/data/models/routine_model.dart';
import 'package:family_planner/features/main/routine/presentation/widgets/routine_check_value_dialog.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 루틴 표의 한 행 (번호 | 시간대 | 이모지+이름 | 체크)
class RoutineListItem extends StatefulWidget {
  const RoutineListItem({
    super.key,
    required this.routine,
    required this.rowNumber,
    required this.onTap,
    required this.onToggleCheck,
    this.onEdit,
    this.onPause,
    this.onResume,
    this.onDelete,
    this.dragHandle,
    this.isEditing = false,
  });

  final Routine routine;
  final int rowNumber;
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
  final VoidCallback? onDelete;
  final Widget? dragHandle;

  /// 순서변경 편집 모드 여부. true면 체크/메뉴가 비활성화되고
  /// 드래그 핸들이 표시된다.
  final bool isEditing;

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

  String? _timeFilterLabel(AppLocalizations l10n) {
    switch (routine.timeFilter) {
      case RoutineTimeFilter.morning:
        return l10n.routine_time_filter_morning;
      case RoutineTimeFilter.afternoon:
        return l10n.routine_time_filter_afternoon;
      case RoutineTimeFilter.evening:
        return l10n.routine_time_filter_evening;
      case null:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final accent = _accentColor(context);
    final isPaused = routine.status == RoutineStatus.paused;
    final canCheck =
        routine.status == RoutineStatus.active && !widget.isEditing;
    final timeLabel = _timeFilterLabel(l10n);

    return Opacity(
      opacity: isPaused ? 0.55 : 1.0,
      child: InkWell(
        onTap: widget.isEditing ? null : onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spaceS,
            vertical: AppSizes.spaceXS,
          ),
          child: Row(
            children: [
              if (widget.isEditing && dragHandle != null) ...[
                dragHandle!,
                const SizedBox(width: AppSizes.spaceXS),
              ],
              SizedBox(
                width: 24,
                child: Text(
                  '${widget.rowNumber}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.spaceXS),
              SizedBox(
                width: 44,
                child: timeLabel != null
                    ? Text(
                        timeLabel,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: AppSizes.spaceXS),
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                ),
                alignment: Alignment.center,
                child: (routine.emoji != null && routine.emoji!.isNotEmpty)
                    ? Text(routine.emoji!, style: const TextStyle(fontSize: 15))
                    : Icon(Icons.check_circle_outline, size: 15, color: accent),
              ),
              const SizedBox(width: AppSizes.spaceS),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      routine.title,
                      style: Theme.of(context).textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    if (isPaused)
                      Text(
                        l10n.routine_status_paused,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
              if (!widget.isEditing) ...[
                const SizedBox(width: AppSizes.spaceXS),
                _CheckIndicator(
                  routine: routine,
                  accent: accent,
                  enabled: canCheck,
                  onTap: _handleToggleCheck,
                ),
              ],
              if (!widget.isEditing &&
                  (widget.onEdit != null ||
                      widget.onPause != null ||
                      widget.onResume != null ||
                      widget.onDelete != null))
                PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
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
                      case 'delete':
                        widget.onDelete?.call();
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
                    if (widget.onDelete != null)
                      PopupMenuItem(
                        value: 'delete',
                        child: Text(l10n.routine_end),
                      ),
                  ],
                ),
            ],
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
        iconSize: 24,
        visualDensity: VisualDensity.compact,
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
        decoration: BoxDecoration(
          color: accent.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, size: 14, color: accent),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                valueLabel,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
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
