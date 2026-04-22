import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/models/dashboard_widget_settings.dart';
import 'package:family_planner/core/providers/dashboard_widget_settings_provider.dart';
import 'package:family_planner/features/home/presentation/widgets/schedule_filter_sheet.dart';
import 'package:family_planner/features/home/providers/dashboard_provider.dart';
import 'package:family_planner/features/main/task/data/models/task_model.dart';
import 'package:family_planner/features/main/task/providers/task_provider.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/shared/widgets/dashboard_card.dart';

/// 할일 요약 위젯 (오늘 / 금주 / 이번달, 그룹 필터 지원)
class TodoSummaryWidget extends ConsumerStatefulWidget {
  const TodoSummaryWidget({
    super.key,
    this.viewMode = ScheduleViewMode.today,
    this.initialSelectedGroupIds,
    this.initialIncludePersonal = true,
  });

  final ScheduleViewMode viewMode;
  final List<String>? initialSelectedGroupIds;
  final bool initialIncludePersonal;

  @override
  ConsumerState<TodoSummaryWidget> createState() => _TodoSummaryWidgetState();
}

class _TodoSummaryWidgetState extends ConsumerState<TodoSummaryWidget> {
  late List<String>? _selectedGroupIds;
  late bool _includePersonal;

  @override
  void initState() {
    super.initState();
    _selectedGroupIds = widget.initialSelectedGroupIds;
    _includePersonal = widget.initialIncludePersonal;
  }

  String _title() {
    switch (widget.viewMode) {
      case ScheduleViewMode.today:
        return '오늘의 할일';
      case ScheduleViewMode.week:
        return '금주 할일';
      case ScheduleViewMode.month:
        return '이번달 할일';
    }
  }

  String _emptyMessage() {
    switch (widget.viewMode) {
      case ScheduleViewMode.today:
        return '오늘 할일이 없습니다';
      case ScheduleViewMode.week:
        return '이번 주 할일이 없습니다';
      case ScheduleViewMode.month:
        return '이번 달 할일이 없습니다';
    }
  }

  Future<void> _saveFilter() async {
    final current = ref.read(dashboardWidgetSettingsProvider).valueOrNull;
    if (current == null) return;
    await ref.read(dashboardWidgetSettingsProvider.notifier).save(
          current.copyWith(
            todoSelectedGroupIds: _selectedGroupIds,
            todoIncludePersonal: _includePersonal,
          ),
        );
  }

  Future<void> _showFilterSheet() async {
    final groups = ref.read(myGroupsProvider).valueOrNull ?? [];
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusMedium),
        ),
      ),
      builder: (context) => ScheduleFilterSheet(
        groups: groups,
        selectedGroupIds: _selectedGroupIds,
        includePersonal: _includePersonal,
        onApply: (selectedGroupIds, includePersonal) {
          setState(() {
            _selectedGroupIds = selectedGroupIds;
            _includePersonal = includePersonal;
          });
          _saveFilter();
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasGroups = (ref.watch(myGroupsProvider).valueOrNull ?? []).isNotEmpty;
    final todosAsync = ref.watch(
      dashboardTodoTasksProvider(
        mode: widget.viewMode,
        selectedGroupIds: _selectedGroupIds,
        includePersonal: _includePersonal,
      ),
    );

    final hasActiveFilter = _selectedGroupIds != null || !_includePersonal;

    return todosAsync.when(
      loading: () => DashboardCard(
        title: _title(),
        icon: Icons.check_box,
        onTap: () {},
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(AppSizes.spaceM),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      error: (_, _) => _buildCard(context, [], hasGroups, hasActiveFilter),
      data: (todos) => _buildCard(context, todos, hasGroups, hasActiveFilter),
    );
  }

  Widget _buildCard(
    BuildContext context,
    List<TaskModel> todos,
    bool hasGroups,
    bool hasActiveFilter,
  ) {
    final completedCount = todos.where((t) => t.isCompleted).length;
    final totalCount = todos.length;

    return DashboardCard(
      title: _title(),
      icon: Icons.check_box,
      action: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (totalCount > 0)
            Chip(
              label: Text(
                '$completedCount/$totalCount',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              backgroundColor: AppColors.primaryLight,
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
            ),
          if (hasGroups)
            IconButton(
              iconSize: 20,
              visualDensity: VisualDensity.compact,
              tooltip: '할일 필터',
              icon: Badge(
                isLabelVisible: hasActiveFilter,
                smallSize: 7,
                child: Icon(
                  Icons.tune,
                  color: hasActiveFilter
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              onPressed: _showFilterSheet,
            ),
        ],
      ),
      onTap: () => ref.read(homeTabNavigationProvider.notifier).state = 'todo',
      child: todos.isEmpty
          ? _EmptyState(message: _emptyMessage())
          : Column(
              children: todos
                  .take(5)
                  .map((todo) => _TodoItem(todo: todo, ref: ref))
                  .toList(),
            ),
    );
  }
}

class _TodoItem extends StatefulWidget {
  const _TodoItem({required this.todo, required this.ref});

  final TaskModel todo;
  final WidgetRef ref;

  @override
  State<_TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<_TodoItem> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final todo = widget.todo;
    final ref = widget.ref;
    final priorityColor = _getPriorityColor(todo.priority);
    final priorityLabel = _getPriorityLabel(todo.priority);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.spaceS),
      child: Row(
        children: [
          if (_loading)
            const SizedBox(
              width: 36,
              height: 36,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
          Checkbox(
            value: todo.isCompleted,
            onChanged: (value) async {
              setState(() => _loading = true);
              final taskDate = todo.scheduledAt ?? todo.dueAt ?? DateTime.now();
              await ref.read(taskManagementProvider.notifier).toggleComplete(
                    todo.id,
                    value ?? false,
                    taskDate,
                  );
              ref.invalidate(dashboardTodoTasksProvider);
              if (mounted) setState(() => _loading = false);
            },
            visualDensity: VisualDensity.compact,
          ),
          Expanded(
            child: Text(
              todo.title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    decoration: todo.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: todo.isCompleted
                        ? Theme.of(context).colorScheme.onSurfaceVariant
                        : null,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (priorityLabel != null)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spaceS,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: priorityColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              ),
              child: Text(
                priorityLabel,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: priorityColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getPriorityColor(TaskPriority? priority) {
    switch (priority) {
      case TaskPriority.urgent:
      case TaskPriority.high:
        return AppColors.error;
      case TaskPriority.medium:
        return AppColors.warning;
      case TaskPriority.low:
        return AppColors.success;
      default:
        return Colors.grey;
    }
  }

  String? _getPriorityLabel(TaskPriority? priority) {
    switch (priority) {
      case TaskPriority.urgent:
        return '긴급';
      case TaskPriority.high:
        return '높음';
      case TaskPriority.medium:
        return '중간';
      case TaskPriority.low:
        return '낮음';
      default:
        return null;
    }
  }
}


class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 48,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: AppSizes.spaceS),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}
