import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/models/dashboard_widget_settings.dart';
import 'package:family_planner/core/providers/dashboard_widget_settings_provider.dart';
import 'package:family_planner/core/utils/color_utils.dart';
import 'package:family_planner/features/auth/providers/auth_provider.dart';
import 'package:family_planner/features/home/presentation/widgets/schedule_filter_sheet.dart';
import 'package:family_planner/features/home/providers/dashboard_provider.dart';
import 'package:family_planner/features/main/task/data/models/task_model.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/shared/widgets/dashboard_card.dart';

/// 일정 위젯 (오늘 / 금주 / 이번달, 그룹 필터 지원)
class TodayScheduleWidget extends ConsumerStatefulWidget {
  const TodayScheduleWidget({
    super.key,
    this.viewMode = ScheduleViewMode.today,
    this.initialSelectedGroupIds,
    this.initialIncludePersonal = true,
  });

  final ScheduleViewMode viewMode;
  final List<String>? initialSelectedGroupIds;
  final bool initialIncludePersonal;

  @override
  ConsumerState<TodayScheduleWidget> createState() => _TodayScheduleWidgetState();
}

class _TodayScheduleWidgetState extends ConsumerState<TodayScheduleWidget> {
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
        return '오늘의 일정';
      case ScheduleViewMode.week:
        return '금주 일정';
      case ScheduleViewMode.month:
        return '이번달 일정';
    }
  }

  String _emptyMessage() {
    switch (widget.viewMode) {
      case ScheduleViewMode.today:
        return '오늘 일정이 없습니다';
      case ScheduleViewMode.week:
        return '이번 주 일정이 없습니다';
      case ScheduleViewMode.month:
        return '이번 달 일정이 없습니다';
    }
  }

  Future<void> _saveFilter() async {
    final current = ref.read(dashboardWidgetSettingsProvider).valueOrNull;
    if (current == null) return;
    await ref.read(dashboardWidgetSettingsProvider.notifier).save(
          current.copyWith(
            scheduleSelectedGroupIds: _selectedGroupIds,
            scheduleIncludePersonal: _includePersonal,
          ),
        );
  }

  Future<void> _showFilterSheet() async {
    final groups = ref.read(myGroupsProvider).valueOrNull ?? [];
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
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
  Widget build(BuildContext context, ) {
    final hasGroups = (ref.watch(myGroupsProvider).valueOrNull ?? []).isNotEmpty;
    final tasksAsync = ref.watch(
      dashboardTodayTasksProvider(
        mode: widget.viewMode,
        selectedGroupIds: _selectedGroupIds,
        includePersonal: _includePersonal,
      ),
    );

    final hasActiveFilter = _selectedGroupIds != null || !_includePersonal;

    return DashboardCard(
      title: _title(),
      icon: Icons.calendar_today,
      action: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasGroups)
            IconButton(
              iconSize: 20,
              visualDensity: VisualDensity.compact,
              tooltip: '일정 필터',
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
          TextButton(
            onPressed: () =>
                ref.read(homeTabNavigationProvider.notifier).state = 'calendar',
            child: const Text('전체보기'),
          ),
        ],
      ),
      onTap: () =>
          ref.read(homeTabNavigationProvider.notifier).state = 'calendar',
      child: tasksAsync.when(
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.all(AppSizes.spaceM),
            child: CircularProgressIndicator(),
          ),
        ),
        error: (_, _) => _EmptyState(message: _emptyMessage()),
        data: (tasks) {
          if (tasks.isEmpty) return _EmptyState(message: _emptyMessage());
          final showDate = widget.viewMode != ScheduleViewMode.today;
          return Column(
            children: tasks
                .take(5)
                .map((task) => _ScheduleItem(task: task, showDate: showDate))
                .toList(),
          );
        },
      ),
    );
  }
}

class _ScheduleItem extends ConsumerWidget {
  const _ScheduleItem({required this.task, this.showDate = false});

  final TaskModel task;
  final bool showDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(myGroupsProvider).valueOrNull ?? [];
    final personalHex = ref.watch(authProvider).user?['personalColor'] as String?;
    final color = ColorUtils.taskColor(
      groupId: task.groupId,
      groups: groups,
      personalColorHex: personalHex,
    );
    String timeText;
    if (task.scheduledAt == null) {
      timeText = '-';
    } else {
      final dt = task.scheduledAt!;
      final hhmm =
          '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      timeText = showDate ? '${dt.month}/${dt.day} $hhmm' : hhmm;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.spaceS),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
            ),
            child: task.category?.emoji != null
                ? Center(
                    child: Text(
                      task.category!.emoji!,
                      style: const TextStyle(fontSize: 20),
                    ),
                  )
                : Icon(Icons.event, color: color, size: AppSizes.iconMedium),
          ),
          const SizedBox(width: AppSizes.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        decoration: task.type == TaskType.todoLinked && task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        color: task.type == TaskType.todoLinked && task.isCompleted
                            ? Theme.of(context).colorScheme.onSurfaceVariant
                            : null,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  timeText,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
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
            Icons.event_available,
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
