import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/utils/color_utils.dart';
import 'package:family_planner/core/widgets/location_map_view.dart';
import 'package:family_planner/features/auth/providers/auth_provider.dart';
import 'package:family_planner/features/main/task/data/models/task_model.dart';
import 'package:family_planner/features/main/task/providers/task_provider.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 일정 상세 조회 화면 (읽기 전용)
class TaskDetailScreen extends ConsumerStatefulWidget {
  final String? taskId;
  final TaskModel? task;

  const TaskDetailScreen({
    super.key,
    this.taskId,
    this.task,
  });

  @override
  ConsumerState<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends ConsumerState<TaskDetailScreen> {
  TaskModel? _loadedTask;
  List<TaskReminderResponse>? _reminders;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.taskId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadDetail());
    }
  }

  Future<void> _loadDetail() async {
    final taskId = widget.taskId;
    if (taskId == null) return;
    if (widget.task == null) {
      setState(() => _isLoading = true);
    }
    try {
      final detail = await ref.read(taskDetailProvider(taskId).future);
      if (!mounted) return;
      setState(() {
        _loadedTask = detail.task;
        _reminders = detail.reminders;
        _isLoading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final task = _loadedTask ?? widget.task;
    if (_isLoading || task == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.schedule_detail)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final groups = ref.watch(myGroupsProvider).valueOrNull ?? [];
    final personalHex = ref.watch(authProvider).user?['personalColor'] as String?;
    final color = ColorUtils.taskColor(
      groupId: task.groupId,
      groups: groups,
      personalColorHex: personalHex,
    );
    final groupName = task.groupId != null
        ? groups.where((g) => g.id == task.groupId).firstOrNull?.name
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.schedule_detail),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: l10n.schedule_edit,
            onPressed: () => context.push('/calendar/edit', extra: {
              'taskId': task.id,
              'task': task,
            }),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            tooltip: l10n.schedule_delete,
            onPressed: () => _handleDelete(task, l10n),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.spaceL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(task: task, color: color),
            const SizedBox(height: AppSizes.spaceXL),

            _InfoRow(
              icon: Icons.access_time,
              label: l10n.schedule_startDate,
              child: _DateTimeDisplay(task: task, l10n: l10n),
            ),
            const Divider(height: AppSizes.spaceXL),

            if (task.location != null) ...[
              _InfoRow(
                icon: Icons.location_on_outlined,
                label: l10n.schedule_location,
                child: InkWell(
                  onTap: () => showLocationMapBottomSheet(context, task.location!),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          task.location!.name,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.primary,
                                decoration: TextDecoration.underline,
                              ),
                        ),
                      ),
                      const Icon(Icons.open_in_new, size: 14, color: AppColors.primary),
                    ],
                  ),
                ),
              ),
              const Divider(height: AppSizes.spaceXL),
            ],

            _InfoRow(
              icon: Icons.category_outlined,
              label: '유형',
              child: _TaskTypeBadge(type: task.type),
            ),
            const Divider(height: AppSizes.spaceXL),

            if (task.category != null) ...[
              _InfoRow(
                icon: Icons.label_outline,
                label: '카테고리',
                child: Row(
                  children: [
                    if (task.category!.emoji != null) ...[
                      Text(task.category!.emoji!, style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: AppSizes.spaceS),
                    ],
                    Text(task.category!.name, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
              const Divider(height: AppSizes.spaceXL),
            ],

            if (task.priority != null) ...[
              _InfoRow(
                icon: Icons.flag_outlined,
                label: l10n.schedule_priority,
                child: _PriorityBadge(priority: task.priority!, l10n: l10n),
              ),
              const Divider(height: AppSizes.spaceXL),
            ],

            if (groupName != null) ...[
              _InfoRow(
                icon: Icons.group_outlined,
                label: l10n.schedule_group,
                child: Text(groupName, style: Theme.of(context).textTheme.bodyMedium),
              ),
              const Divider(height: AppSizes.spaceXL),
            ],

            if (task.participants.isNotEmpty) ...[
              _InfoRow(
                icon: Icons.people_outline,
                label: l10n.schedule_participants,
                child: Wrap(
                  spacing: AppSizes.spaceS,
                  runSpacing: AppSizes.spaceXS,
                  children: task.participants.map((p) {
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

            if (task.recurring != null) ...[
              _InfoRow(
                icon: Icons.repeat,
                label: l10n.schedule_recurrence,
                child: _RecurringDisplay(recurring: task.recurring!, l10n: l10n),
              ),
              const Divider(height: AppSizes.spaceXL),
            ],

            if (_reminders != null && _reminders!.isNotEmpty) ...[
              _InfoRow(
                icon: Icons.notifications_outlined,
                label: l10n.schedule_reminder,
                child: Wrap(
                  spacing: AppSizes.spaceS,
                  runSpacing: AppSizes.spaceXS,
                  children: _reminders!.map((r) {
                    return Chip(
                      label: Text(_formatReminder(r.offsetMinutes, l10n)),
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    );
                  }).toList(),
                ),
              ),
              const Divider(height: AppSizes.spaceXL),
            ],

            if (task.description != null && task.description!.isNotEmpty) ...[
              _InfoRow(
                icon: Icons.notes,
                label: l10n.schedule_description,
                child: Text(
                  task.description!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const Divider(height: AppSizes.spaceXL),
            ],

            _InfoRow(
              icon: Icons.schedule_outlined,
              label: '등록일',
              child: Text(
                _formatDateTime(task.createdAt),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleDelete(TaskModel task, AppLocalizations l10n) async {
    final isRecurring = task.recurring != null;
    String? deleteScope;

    if (isRecurring) {
      deleteScope = await _showRecurringDeleteDialog(l10n);
      if (deleteScope == null) return;
    } else {
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
      if (confirmed != true) return;
    }

    if (!mounted) return;
    final success = await ref.read(taskManagementProvider.notifier).deleteTask(
          task.id,
          task.scheduledAt ?? task.dueAt ?? DateTime.now(),
          deleteScope: deleteScope,
        );
    if (!mounted) return;
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

  Future<String?> _showRecurringDeleteDialog(AppLocalizations l10n) async {
    String selected = 'current';
    return showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('이 반복 일정을 삭제하시겠습니까?'),
          content: RadioGroup<String>(
            groupValue: selected,
            onChanged: (v) => setState(() => selected = v!),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<String>(
                  title: Text('이 일정만 삭제'),
                  value: 'current',
                  contentPadding: EdgeInsets.zero,
                ),
                RadioListTile<String>(
                  title: Text('이 일정 및 이후 일정 모두 삭제'),
                  value: 'future',
                  contentPadding: EdgeInsets.zero,
                ),
                RadioListTile<String>(
                  title: Text('모든 반복 일정 삭제'),
                  value: 'all',
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: Text(l10n.common_cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, selected),
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              child: Text(l10n.common_delete),
            ),
          ],
        ),
      ),
    );
  }

  String _formatReminder(int offsetMinutes, AppLocalizations l10n) {
    if (offsetMinutes == 0) return l10n.schedule_reminderAtTime;
    if (offsetMinutes < 60) return l10n.schedule_reminderMinutesBefore(offsetMinutes);
    final hours = offsetMinutes ~/ 60;
    if (offsetMinutes % 60 == 0 && hours < 24) {
      return l10n.schedule_reminderHoursBefore(hours);
    }
    if (offsetMinutes == 1440) return l10n.schedule_reminder1Day;
    return l10n.schedule_reminderMinutesBefore(offsetMinutes);
  }

  String _formatDateTime(DateTime dt) {
    return DateFormat('yyyy.MM.dd HH:mm').format(dt);
  }
}

class _Header extends StatelessWidget {
  final TaskModel task;
  final Color color;

  const _Header({required this.task, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          alignment: Alignment.center,
          child: task.category?.emoji != null
              ? Text(task.category!.emoji!, style: const TextStyle(fontSize: 28))
              : Icon(Icons.event, color: color, size: AppSizes.iconLarge),
        ),
        const SizedBox(width: AppSizes.spaceL),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                  color: task.isCompleted ? AppColors.textSecondary : null,
                ),
              ),
              if (task.isCompleted) ...[
                const SizedBox(height: AppSizes.spaceXS),
                Row(
                  children: [
                    Icon(Icons.check_circle, size: 14, color: AppColors.success),
                    const SizedBox(width: 4),
                    Text(
                      '완료됨',
                      style: theme.textTheme.labelSmall?.copyWith(color: AppColors.success),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget child;

  const _InfoRow({
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

class _DateTimeDisplay extends StatelessWidget {
  final TaskModel task;
  final AppLocalizations l10n;

  const _DateTimeDisplay({required this.task, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('yyyy.MM.dd (E)', 'ko');
    final timeFormat = DateFormat('HH:mm');

    final scheduled = task.scheduledAt;
    final dueAt = task.dueAt;

    if (scheduled == null && dueAt == null) {
      return Text(l10n.todo_noDueDate, style: theme.textTheme.bodyMedium);
    }

    final hasTimeRange = scheduled != null;
    final hasDueDate = dueAt != null;
    final hasDifferentDays = scheduled != null &&
        dueAt != null &&
        DateTime(scheduled.year, scheduled.month, scheduled.day) !=
            DateTime(dueAt.year, dueAt.month, dueAt.day);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasTimeRange) ...[
          Text(
            '시작: ${dateFormat.format(scheduled)} ${timeFormat.format(scheduled)}',
            style: theme.textTheme.bodyMedium,
          ),
        ],
        if (hasDueDate) ...[
          if (hasTimeRange) const SizedBox(height: AppSizes.spaceXS),
          Text(
            hasDifferentDays
                ? '종료: ${dateFormat.format(dueAt)} ${timeFormat.format(dueAt)}'
                : '종료: ${timeFormat.format(dueAt)}',
            style: theme.textTheme.bodyMedium,
          ),
        ],
        if (task.daysUntilDue != null) ...[
          const SizedBox(height: AppSizes.spaceXS),
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

class _TaskTypeBadge extends StatelessWidget {
  final TaskType? type;

  const _TaskTypeBadge({this.type});

  @override
  Widget build(BuildContext context) {
    final (label, icon) = switch (type) {
      TaskType.calendarOnly => ('캘린더 전용', Icons.calendar_today),
      TaskType.todoLinked => ('할일 연동', Icons.task_alt),
      TaskType.todoOnly => ('할일 전용', Icons.checklist),
      null => ('일반 일정', Icons.event),
    };
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: AppSizes.spaceXS),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
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
        if (!recurring.isActive) ...[
          const SizedBox(width: AppSizes.spaceS),
          Text(
            '(비활성)',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ],
    );
  }
}
