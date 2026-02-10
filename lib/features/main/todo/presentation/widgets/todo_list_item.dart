import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/main/task/data/models/task_model.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 할일 목록 아이템 위젯
class TodoListItem extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onTap;
  final void Function(TaskStatus status) onStatusChange;

  const TodoListItem({
    super.key,
    required this.task,
    required this.onTap,
    required this.onStatusChange,
  });

  @override
  Widget build(BuildContext context) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상태 드롭다운
              _StatusDropdown(
                status: task.status,
                color: color,
                onStatusChange: onStatusChange,
              ),
              const SizedBox(width: AppSizes.spaceM),

              // 색상 표시 바
              _ColorBar(color: color),
              const SizedBox(width: AppSizes.spaceM),

              // Task 정보
              Expanded(
                child: _TaskInfo(task: task),
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

/// 상태 선택 드롭다운
class _StatusDropdown extends StatelessWidget {
  final TaskStatus status;
  final Color color;
  final void Function(TaskStatus status) onStatusChange;

  const _StatusDropdown({
    required this.status,
    required this.color,
    required this.onStatusChange,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PopupMenuButton<TaskStatus>(
      initialValue: status,
      onSelected: onStatusChange,
      tooltip: l10n.todo_changeStatus,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(
        minWidth: 32,
        minHeight: 32,
      ),
      position: PopupMenuPosition.under,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: _getStatusColor(status).withValues(alpha: 0.15),
          border: Border.all(
            color: _getStatusColor(status),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          _getStatusIcon(status),
          size: 16,
          color: _getStatusColor(status),
        ),
      ),
      itemBuilder: (context) => [
        _buildMenuItem(context, TaskStatus.pending, l10n.todo_statusPending),
        _buildMenuItem(context, TaskStatus.inProgress, l10n.todo_statusInProgress),
        _buildMenuItem(context, TaskStatus.completed, l10n.todo_statusCompleted),
        _buildMenuItem(context, TaskStatus.hold, l10n.todo_statusHold),
        _buildMenuItem(context, TaskStatus.drop, l10n.todo_statusDrop),
        _buildMenuItem(context, TaskStatus.failed, l10n.todo_statusFailed),
      ],
    );
  }

  PopupMenuItem<TaskStatus> _buildMenuItem(
    BuildContext context,
    TaskStatus itemStatus,
    String label,
  ) {
    final isSelected = status == itemStatus;
    return PopupMenuItem<TaskStatus>(
      value: itemStatus,
      child: Row(
        children: [
          Icon(
            _getStatusIcon(itemStatus),
            size: 18,
            color: _getStatusColor(itemStatus),
          ),
          const SizedBox(width: AppSizes.spaceS),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? _getStatusColor(itemStatus) : null,
                ),
          ),
          if (isSelected) ...[
            const Spacer(),
            Icon(
              Icons.check,
              size: 16,
              color: _getStatusColor(itemStatus),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getStatusIcon(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return Icons.radio_button_unchecked;
      case TaskStatus.inProgress:
        return Icons.play_circle_outline;
      case TaskStatus.completed:
        return Icons.check_circle;
      case TaskStatus.hold:
        return Icons.pause_circle_outline;
      case TaskStatus.drop:
        return Icons.remove_circle_outline;
      case TaskStatus.failed:
        return Icons.error_outline;
    }
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return AppColors.textSecondary;
      case TaskStatus.inProgress:
        return AppColors.primary;
      case TaskStatus.completed:
        return AppColors.success;
      case TaskStatus.hold:
        return AppColors.warning;
      case TaskStatus.drop:
        return AppColors.textSecondary;
      case TaskStatus.failed:
        return AppColors.error;
    }
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
      height: 60,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

/// Task 정보 (제목, 마감일, 설명)
class _TaskInfo extends StatelessWidget {
  final TaskModel task;

  const _TaskInfo({required this.task});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 제목
        Text(
          task.title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                color: task.isCompleted ? AppColors.textSecondary : null,
              ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSizes.spaceXS),

        // 마감일 / D-Day
        Row(
          children: [
            Icon(
              Icons.event,
              size: AppSizes.iconSmall,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: AppSizes.spaceXS),
            Flexible(
              child: Text(
                _getDueDateDisplay(l10n),
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

        // 설명 (있는 경우)
        if (task.description != null && task.description!.isNotEmpty) ...[
          const SizedBox(height: AppSizes.spaceXS),
          Text(
            task.description!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  String _getDueDateDisplay(AppLocalizations l10n) {
    if (task.dueAt != null) {
      final dueDate = task.dueAt!;
      return '${dueDate.month}/${dueDate.day}';
    }
    if (task.scheduledAt != null) {
      final scheduledDate = task.scheduledAt!;
      return '${scheduledDate.month}/${scheduledDate.day}';
    }
    return l10n.todo_noDueDate;
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
