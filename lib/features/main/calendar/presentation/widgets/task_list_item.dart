import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/main/task/data/models/task_model.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// Task 목록 아이템 위젯
class TaskListItem extends StatelessWidget {
  final TaskModel task;
  final DateFormat timeFormat;
  final VoidCallback onTap;
  final VoidCallback onToggleComplete;

  const TaskListItem({
    super.key,
    required this.task,
    required this.timeFormat,
    required this.onTap,
    required this.onToggleComplete,
  });

  /// 기간 일정 여부 (시작일과 종료일이 다른 경우)
  bool get _hasDateRange {
    if (task.scheduledAt == null || task.dueAt == null) return false;
    final startDate = DateTime(
      task.scheduledAt!.year,
      task.scheduledAt!.month,
      task.scheduledAt!.day,
    );
    final endDate = DateTime(
      task.dueAt!.year,
      task.dueAt!.month,
      task.dueAt!.day,
    );
    return startDate != endDate;
  }

  /// 시간/기간 표시 문자열
  String _getTimeDisplay(AppLocalizations l10n) {
    if (_hasDateRange) {
      // 기간 일정: "1/15 ~ 1/20" 형식
      final startDate = task.scheduledAt!;
      final endDate = task.dueAt!;
      return '${startDate.month}/${startDate.day} ~ ${endDate.month}/${endDate.day}';
    } else if (task.isAllDay) {
      return l10n.schedule_allDay;
    } else if (task.scheduledAt != null) {
      return timeFormat.format(task.scheduledAt!);
    }
    return '-';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = Color(task.colorValue);

    return Card(
      elevation: AppSizes.elevation1,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          child: Row(
            children: [
              // 완료 체크박스
              _CompletionCheckbox(
                isCompleted: task.isCompleted,
                color: color,
                onTap: onToggleComplete,
              ),
              const SizedBox(width: AppSizes.spaceM),

              // 색상 표시 바
              _ColorBar(color: color),
              const SizedBox(width: AppSizes.spaceM),

              // Task 정보
              Expanded(
                child: _TaskInfo(
                  task: task,
                  timeDisplay: _getTimeDisplay(l10n),
                  hasDateRange: _hasDateRange,
                ),
              ),

              // 아이콘들
              _TaskIcons(task: task),

              const Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 완료 체크박스
class _CompletionCheckbox extends StatelessWidget {
  final bool isCompleted;
  final Color color;
  final VoidCallback onTap;

  const _CompletionCheckbox({
    required this.isCompleted,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: isCompleted ? color : Colors.transparent,
          border: Border.all(
            color: color,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: isCompleted
            ? const Icon(
                Icons.check,
                size: 16,
                color: Colors.white,
              )
            : null,
      ),
    );
  }
}

/// 색상 표시 바
class _ColorBar extends StatelessWidget {
  final Color color;

  const _ColorBar({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: 48,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

/// Task 정보 (제목, 시간, 장소)
class _TaskInfo extends StatelessWidget {
  final TaskModel task;
  final String timeDisplay;
  final bool hasDateRange;

  const _TaskInfo({
    required this.task,
    required this.timeDisplay,
    required this.hasDateRange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 제목
        Text(
          task.title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                decoration:
                    task.isCompleted ? TextDecoration.lineThrough : null,
                color: task.isCompleted ? AppColors.textSecondary : null,
              ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSizes.spaceXS),

        // 시간 / 종일 / 기간 표시
        Row(
          children: [
            Icon(
              hasDateRange
                  ? Icons.date_range
                  : task.isAllDay
                      ? Icons.wb_sunny_outlined
                      : Icons.access_time,
              size: AppSizes.iconSmall,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: AppSizes.spaceXS),
            Flexible(
              child: Text(
                timeDisplay,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // D-Day 표시
            if (task.daysUntilDue != null) ...[
              const SizedBox(width: AppSizes.spaceS),
              _DdayBadge(days: task.daysUntilDue!),
            ],
          ],
        ),

        // 장소 (있는 경우)
        if (task.location != null && task.location!.isNotEmpty) ...[
          const SizedBox(height: AppSizes.spaceXS),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: AppSizes.iconSmall,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: AppSizes.spaceXS),
              Expanded(
                child: Text(
                  task.location!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

/// D-Day 배지
class _DdayBadge extends StatelessWidget {
  final int days;

  const _DdayBadge({required this.days});

  String get _text {
    if (days == 0) return 'D-Day';
    if (days > 0) return 'D-$days';
    return 'D+${days.abs()}';
  }

  Color get _color {
    if (days < 0) return AppColors.error;
    if (days == 0) return AppColors.warning;
    if (days <= 3) return AppColors.secondary;
    return AppColors.textSecondary;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        _text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: _color,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

/// Task 아이콘들 (카테고리, 반복, 우선순위)
class _TaskIcons extends StatelessWidget {
  final TaskModel task;

  const _TaskIcons({required this.task});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 카테고리 이모지
        if (task.category?.emoji != null) ...[
          const SizedBox(width: AppSizes.spaceS),
          Text(
            task.category!.emoji!,
            style: const TextStyle(fontSize: 20),
          ),
        ],

        // 반복 아이콘
        if (task.recurring != null) ...[
          const SizedBox(width: AppSizes.spaceS),
          Icon(
            Icons.repeat,
            size: AppSizes.iconSmall,
            color: AppColors.textSecondary,
          ),
        ],

        // 우선순위 아이콘
        if (task.priority != null && task.priority != TaskPriority.low) ...[
          const SizedBox(width: AppSizes.spaceS),
          Icon(
            _getPriorityIcon(task.priority!),
            size: AppSizes.iconSmall,
            color: _getPriorityColor(task.priority!),
          ),
        ],
      ],
    );
  }

  IconData _getPriorityIcon(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.urgent:
        return Icons.priority_high;
      case TaskPriority.high:
        return Icons.arrow_upward;
      case TaskPriority.medium:
        return Icons.remove;
      case TaskPriority.low:
        return Icons.arrow_downward;
    }
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.urgent:
        return AppColors.error;
      case TaskPriority.high:
        return AppColors.secondary;
      case TaskPriority.medium:
        return AppColors.primary;
      case TaskPriority.low:
        return AppColors.textSecondary;
    }
  }
}
