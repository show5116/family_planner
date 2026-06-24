import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/utils/color_utils.dart';
import 'package:family_planner/features/auth/providers/auth_provider.dart';
import 'package:family_planner/features/main/task/data/models/task_model.dart';
import 'package:family_planner/features/main/task/providers/task_provider.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 할일 상세 조회 화면 (읽기 전용)
class TodoDetailScreen extends ConsumerStatefulWidget {
  final String? taskId;
  final TaskModel? task;

  const TodoDetailScreen({
    super.key,
    this.taskId,
    this.task,
  });

  @override
  ConsumerState<TodoDetailScreen> createState() => _TodoDetailScreenState();
}

class _TodoDetailScreenState extends ConsumerState<TodoDetailScreen> {
  TaskModel? _loadedTask;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.task == null && widget.taskId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadTask());
    }
  }

  Future<void> _loadTask() async {
    final taskId = widget.taskId;
    if (taskId == null) return;
    setState(() => _isLoading = true);
    try {
      final detail = await ref.read(taskDetailProvider(taskId).future);
      if (!mounted) return;
      setState(() {
        _loadedTask = detail.task;
        _isLoading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final baseTask = _loadedTask ?? widget.task;

    if (_isLoading || baseTask == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.nav_todo)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // 목록 Provider에서 최신 상태 반영 (상태 변경 후 자동 업데이트)
    final tasksAsync = ref.watch(todoTasksProvider(page: 1));
    final currentTask = tasksAsync.valueOrNull?.data
            .where((t) => t.id == baseTask.id)
            .firstOrNull ??
        baseTask;

    final groups = ref.watch(myGroupsProvider).valueOrNull ?? [];
    final personalHex = ref.watch(authProvider).user?['personalColor'] as String?;
    final color = ColorUtils.taskColor(
      groupId: currentTask.groupId,
      groups: groups,
      personalColorHex: personalHex,
    );
    final groupName = currentTask.groupId != null
        ? groups.where((g) => g.id == currentTask.groupId).firstOrNull?.name
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.nav_todo),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: l10n.schedule_edit,
            onPressed: () => context.push('/todo/edit', extra: {
              'taskId': currentTask.id,
              'task': currentTask,
            }),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            tooltip: l10n.schedule_delete,
            onPressed: () => _handleDelete(context, currentTask, l10n),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.spaceL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TitleSection(task: currentTask, color: color),
            const SizedBox(height: AppSizes.spaceXL),

            _StatusSection(
              task: currentTask,
              l10n: l10n,
              onStatusChange: (status) {
                ref.read(taskManagementProvider.notifier).updateStatus(
                      currentTask.id,
                      status,
                      currentTask.scheduledAt ?? currentTask.dueAt ?? DateTime.now(),
                    );
                ref.invalidate(todoTasksProvider(page: 1));
                ref.invalidate(todoOverviewTasksProvider);
              },
            ),
            const Divider(height: AppSizes.spaceXL),

            if (currentTask.priority != null) ...[
              _DetailRow(
                icon: Icons.flag_outlined,
                label: l10n.schedule_priority,
                child: _PriorityBadge(priority: currentTask.priority!, l10n: l10n),
              ),
              const Divider(height: AppSizes.spaceXL),
            ],

            _DetailRow(
              icon: Icons.event_outlined,
              label: '마감일',
              child: _DueDateDisplay(task: currentTask, l10n: l10n),
            ),
            const Divider(height: AppSizes.spaceXL),

            if (currentTask.category != null) ...[
              _DetailRow(
                icon: Icons.label_outline,
                label: '카테고리',
                child: Row(
                  children: [
                    if (currentTask.category!.emoji != null) ...[
                      Text(
                        currentTask.category!.emoji!,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(width: AppSizes.spaceS),
                    ],
                    Text(
                      currentTask.category!.name,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Divider(height: AppSizes.spaceXL),
            ],

            if (groupName != null) ...[
              _DetailRow(
                icon: Icons.group_outlined,
                label: l10n.schedule_group,
                child: Text(groupName, style: Theme.of(context).textTheme.bodyMedium),
              ),
              const Divider(height: AppSizes.spaceXL),
            ],

            if (currentTask.participants.isNotEmpty) ...[
              _DetailRow(
                icon: Icons.people_outline,
                label: l10n.schedule_participants,
                child: Wrap(
                  spacing: AppSizes.spaceS,
                  runSpacing: AppSizes.spaceXS,
                  children: currentTask.participants.map((p) {
                    return Chip(
                      label: Text(p.user?.name ?? p.userId),
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    );
                  }).toList(),
                ),
              ),
              const Divider(height: AppSizes.spaceXL),
            ],

            if (currentTask.recurring != null) ...[
              _DetailRow(
                icon: Icons.repeat,
                label: l10n.schedule_recurrence,
                child: _RecurringDisplay(recurring: currentTask.recurring!, l10n: l10n),
              ),
              const Divider(height: AppSizes.spaceXL),
            ],

            if (currentTask.description != null && currentTask.description!.isNotEmpty) ...[
              _DetailRow(
                icon: Icons.notes,
                label: l10n.schedule_description,
                child: Text(
                  currentTask.description!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const Divider(height: AppSizes.spaceXL),
            ],

            _DetailRow(
              icon: Icons.schedule_outlined,
              label: '등록일',
              child: Text(
                _formatDate(currentTask.createdAt),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ),

            if (currentTask.completedAt != null) ...[
              const Divider(height: AppSizes.spaceXL),
              _DetailRow(
                icon: Icons.check_circle_outline,
                label: '완료일',
                child: Text(
                  _formatDate(currentTask.completedAt!),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.success,
                      ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _handleDelete(
    BuildContext context,
    TaskModel currentTask,
    AppLocalizations l10n,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.schedule_deleteDialogTitle),
        content: Text(l10n.schedule_deleteDialogMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.common_cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(l10n.common_delete),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;
    final success = await ref.read(taskManagementProvider.notifier).deleteTask(
          currentTask.id,
          currentTask.scheduledAt ?? currentTask.dueAt ?? DateTime.now(),
        );
    if (!context.mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.schedule_deleteSuccess)),
      );
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.schedule_deleteError),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  String _formatDate(DateTime dt) => DateFormat('yyyy.MM.dd HH:mm').format(dt);
}

class _TitleSection extends StatelessWidget {
  final TaskModel task;
  final Color color;

  const _TitleSection({required this.task, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 8,
          height: 56,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: AppSizes.spaceM),
        Expanded(
          child: Text(
            task.title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
              color: task.isCompleted ? AppColors.textSecondary : null,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusSection extends StatelessWidget {
  final TaskModel task;
  final AppLocalizations l10n;
  final void Function(TaskStatus) onStatusChange;

  const _StatusSection({
    required this.task,
    required this.l10n,
    required this.onStatusChange,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '상태',
          style: theme.textTheme.labelSmall?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSizes.spaceS),
        Wrap(
          spacing: AppSizes.spaceS,
          runSpacing: AppSizes.spaceS,
          children: TaskStatus.values.map((status) {
            final isSelected = task.status == status;
            final sColor = _getStatusColor(status);
            return GestureDetector(
              onTap: isSelected ? null : () => onStatusChange(status),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spaceM,
                  vertical: AppSizes.spaceS,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? sColor : sColor.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  border: Border.all(
                    color: isSelected ? sColor : sColor.withValues(alpha: 0.3),
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getStatusIcon(status),
                      size: 14,
                      color: isSelected ? Colors.white : sColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _getStatusLabel(l10n, status),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isSelected ? Colors.white : sColor,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  String _getStatusLabel(AppLocalizations l10n, TaskStatus status) {
    switch (status) {
      case TaskStatus.pending: return l10n.todo_statusPending;
      case TaskStatus.inProgress: return l10n.todo_statusInProgress;
      case TaskStatus.completed: return l10n.todo_statusCompleted;
      case TaskStatus.hold: return l10n.todo_statusHold;
      case TaskStatus.drop: return l10n.todo_statusDrop;
      case TaskStatus.failed: return l10n.todo_statusFailed;
    }
  }

  IconData _getStatusIcon(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending: return Icons.radio_button_unchecked;
      case TaskStatus.inProgress: return Icons.play_circle_outline;
      case TaskStatus.completed: return Icons.check_circle;
      case TaskStatus.hold: return Icons.pause_circle_outline;
      case TaskStatus.drop: return Icons.remove_circle_outline;
      case TaskStatus.failed: return Icons.error_outline;
    }
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending: return AppColors.textSecondary;
      case TaskStatus.inProgress: return AppColors.primary;
      case TaskStatus.completed: return AppColors.success;
      case TaskStatus.hold: return AppColors.warning;
      case TaskStatus.drop: return AppColors.textSecondary;
      case TaskStatus.failed: return AppColors.error;
    }
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget child;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: AppSizes.iconMedium, color: AppColors.textSecondary),
        const SizedBox(width: AppSizes.spaceM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSizes.spaceXS),
              child,
            ],
          ),
        ),
      ],
    );
  }
}

class _DueDateDisplay extends StatelessWidget {
  final TaskModel task;
  final AppLocalizations l10n;

  const _DueDateDisplay({required this.task, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dueDate = task.dueAt ?? task.scheduledAt;
    if (dueDate == null) {
      return Text(l10n.todo_noDueDate, style: theme.textTheme.bodyMedium);
    }

    final dateStr = DateFormat('yyyy.MM.dd (E)', 'ko').format(dueDate);
    return Row(
      children: [
        Text(dateStr, style: theme.textTheme.bodyMedium),
        if (task.daysUntilDue != null) ...[
          const SizedBox(width: AppSizes.spaceS),
          _DdayBadge(days: task.daysUntilDue!),
        ],
      ],
    );
  }
}

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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        border: Border.all(color: _color.withValues(alpha: 0.3)),
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

class _PriorityBadge extends StatelessWidget {
  final TaskPriority priority;
  final AppLocalizations l10n;

  const _PriorityBadge({required this.priority, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (priority) {
      TaskPriority.urgent => (l10n.schedule_priorityUrgent, AppColors.error),
      TaskPriority.high => (l10n.schedule_priorityHigh, AppColors.secondary),
      TaskPriority.medium => (l10n.schedule_priorityMedium, AppColors.primary),
      TaskPriority.low => (l10n.schedule_priorityLow, AppColors.textSecondary),
    };
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.flag, size: 16, color: color),
        const SizedBox(width: AppSizes.spaceXS),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: color),
        ),
      ],
    );
  }
}

class _RecurringDisplay extends StatelessWidget {
  final RecurringModel recurring;
  final AppLocalizations l10n;

  const _RecurringDisplay({required this.recurring, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final label = switch (recurring.ruleType) {
      'DAILY' => l10n.schedule_recurrenceDaily,
      'WEEKLY' => l10n.schedule_recurrenceWeekly,
      'MONTHLY' => l10n.schedule_recurrenceMonthly,
      'YEARLY' => l10n.schedule_recurrenceYearly,
      _ => l10n.schedule_recurrence,
    };
    return Row(
      children: [
        Icon(Icons.repeat, size: 16, color: AppColors.primary),
        const SizedBox(width: AppSizes.spaceXS),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
