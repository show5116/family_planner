import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/main/task/data/models/task_model.dart';
import 'package:family_planner/features/main/task/providers/task_provider.dart';
import 'package:family_planner/features/main/todo/presentation/widgets/todo_kanban_column.dart';
import 'package:family_planner/features/main/todo/presentation/widgets/todo_list_item.dart';
import 'package:family_planner/features/main/todo/presentation/widgets/todo_week_bar.dart';
import 'package:family_planner/features/main/calendar/presentation/widgets/calendar_group_selector.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 뷰 타입 (칸반/리스트)
enum TodoViewType { kanban, list }

/// 현재 뷰 타입 Provider
final todoViewTypeProvider = StateProvider<TodoViewType>((ref) => TodoViewType.kanban);

/// 모아 보기 섹션 타입
enum _OverviewSection { overdue, today, tomorrow, thisWeek, nextWeek, later, noDueDate }

/// 할일 관리 탭
class TodoTab extends ConsumerStatefulWidget {
  const TodoTab({super.key});

  @override
  ConsumerState<TodoTab> createState() => _TodoTabState();
}

class _TodoTabState extends ConsumerState<TodoTab> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final viewType = ref.watch(todoViewTypeProvider);
    final viewMode = ref.watch(todoViewModeProvider);
    final selectedDate = ref.watch(todoSelectedDateProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    // 모바일에서는 항상 리스트 뷰 사용
    final effectiveViewType = isMobile ? TodoViewType.list : viewType;
    final isOverview = viewMode == TodoViewMode.overview;

    return Scaffold(
      appBar: AppBar(
        title: const CalendarGroupSelector(),
        actions: [
          // 뷰 전환 버튼 (모바일에서는 숨김, 모아보기에서는 숨김)
          if (!isMobile && !isOverview)
            IconButton(
              icon: Icon(
                viewType == TodoViewType.kanban
                    ? Icons.view_list
                    : Icons.view_kanban,
              ),
              tooltip: viewType == TodoViewType.kanban
                  ? l10n.todo_viewList
                  : l10n.todo_viewKanban,
              onPressed: () {
                ref.read(todoViewTypeProvider.notifier).state =
                    viewType == TodoViewType.kanban
                        ? TodoViewType.list
                        : TodoViewType.kanban;
              },
            ),
          IconButton(
            icon: Icon(
              ref.watch(todoSearchActiveProvider)
                  ? Icons.search_off
                  : Icons.search,
            ),
            tooltip: l10n.common_search,
            onPressed: () {
              final isActive = ref.read(todoSearchActiveProvider);
              if (isActive) {
                ref.read(todoSearchQueryProvider.notifier).state = null;
                ref.read(todoSearchActiveProvider.notifier).state = false;
              } else {
                ref.read(todoSearchActiveProvider.notifier).state = true;
              }
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'categories') {
                context.push('/calendar/categories');
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'categories',
                child: Row(
                  children: [
                    const Icon(Icons.category_outlined, size: 20),
                    const SizedBox(width: AppSizes.spaceS),
                    Text(l10n.category_management),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // 검색바 (검색 모드일 때 표시)
          if (ref.watch(todoSearchActiveProvider))
            const _TodoSearchBar(),

          // 검색 쿼리가 있으면 검색 결과, 아니면 기존 뷰
          if (ref.watch(todoSearchQueryProvider) != null) ...[
            const Expanded(
              child: _TodoSearchResults(),
            ),
          ] else ...[
            // 뷰 모드 전환 (날짜별 보기 / 모아 보기)
            _ViewModeToggle(viewMode: viewMode, l10n: l10n),
            const Divider(height: 1),

            // 날짜별 보기 모드일 때만 주간 바 + 날짜 헤더 표시
            if (!isOverview) ...[
              const TodoWeekBar(),
              const Divider(height: 1),
              _SelectedDateHeader(selectedDate: selectedDate, l10n: l10n),
            ],

            // 모아 보기일 때 완료 포함 헤더
            if (isOverview)
              _OverviewHeader(l10n: l10n),

            // 필터/정렬 바
            const _FilterSortBar(),

            // 할일 목록
            Expanded(
              child: isOverview
                  ? const _OverviewListView()
                  : _DateViewContent(
                      effectiveViewType: effectiveViewType,
                      l10n: l10n,
                    ),
            ),
          ],
        ],
      ),
      floatingActionButton: ref.watch(todoSearchQueryProvider) != null
          ? null
          : FloatingActionButton(
              heroTag: 'todo_fab',
              onPressed: () {
                context.push('/todo/add');
              },
              tooltip: l10n.todo_add,
              child: const Icon(Icons.add),
            ),
    );
  }
}

/// 뷰 모드 전환 토글
class _ViewModeToggle extends ConsumerWidget {
  final TodoViewMode viewMode;
  final AppLocalizations l10n;

  const _ViewModeToggle({
    required this.viewMode,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceM,
        vertical: AppSizes.spaceS,
      ),
      child: Row(
        children: [
          Expanded(
            child: SegmentedButton<TodoViewMode>(
              segments: [
                ButtonSegment(
                  value: TodoViewMode.byDate,
                  label: Text(l10n.todo_viewByDate),
                  icon: const Icon(Icons.calendar_today, size: 16),
                ),
                ButtonSegment(
                  value: TodoViewMode.overview,
                  label: Text(l10n.todo_viewOverview),
                  icon: const Icon(Icons.list_alt, size: 16),
                ),
              ],
              selected: {viewMode},
              onSelectionChanged: (selected) {
                ref.read(todoViewModeProvider.notifier).state = selected.first;
              },
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 날짜별 보기 컨텐츠
class _DateViewContent extends ConsumerWidget {
  final TodoViewType effectiveViewType;
  final AppLocalizations l10n;

  const _DateViewContent({
    required this.effectiveViewType,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDateTasksAsync = ref.watch(todoSelectedDateTasksProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(todoTasksProvider(page: 1));
      },
      child: selectedDateTasksAsync.when(
        data: (tasks) {
          if (tasks.isEmpty) {
            return _EmptyState(l10n: l10n);
          }

          return effectiveViewType == TodoViewType.kanban
              ? _KanbanView(tasks: tasks)
              : _ListView(tasks: tasks);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _ErrorState(
          error: error.toString(),
          onRetry: () {
            ref.invalidate(todoTasksProvider(page: 1));
          },
          l10n: l10n,
        ),
      ),
    );
  }
}

/// 모아 보기 헤더 (완료 포함 체크박스)
class _OverviewHeader extends ConsumerWidget {
  final AppLocalizations l10n;

  const _OverviewHeader({required this.l10n});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showCompleted = ref.watch(showCompletedTodosProvider);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceM,
        vertical: AppSizes.spaceS,
      ),
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      child: Row(
        children: [
          Text(
            l10n.todo_viewOverview,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: () {
              ref.read(showCompletedTodosProvider.notifier).state = !showCompleted;
            },
            borderRadius: BorderRadius.circular(4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: Checkbox(
                    value: showCompleted,
                    onChanged: (value) {
                      ref.read(showCompletedTodosProvider.notifier).state = value ?? false;
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  l10n.todo_showCompleted,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 필터/정렬 바
class _FilterSortBar extends ConsumerWidget {
  const _FilterSortBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final filterStatus = ref.watch(todoFilterStatusProvider);
    final filterPriority = ref.watch(todoFilterPriorityProvider);
    final sortBy = ref.watch(todoSortByProvider);
    final hasFilter = filterStatus != null || filterPriority != null;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceM,
        vertical: AppSizes.spaceXS,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // 상태 필터
            _FilterChip(
              label: filterStatus != null
                  ? _getStatusLabel(l10n, filterStatus)
                  : l10n.todo_filterStatus,
              icon: Icons.flag_outlined,
              isActive: filterStatus != null,
              onTap: () => _showStatusFilterMenu(context, ref, l10n),
            ),
            const SizedBox(width: AppSizes.spaceS),

            // 우선순위 필터
            _FilterChip(
              label: filterPriority != null
                  ? _getPriorityLabel(l10n, filterPriority)
                  : l10n.todo_filterPriority,
              icon: Icons.priority_high,
              isActive: filterPriority != null,
              onTap: () => _showPriorityFilterMenu(context, ref, l10n),
            ),
            const SizedBox(width: AppSizes.spaceS),

            // 정렬
            _FilterChip(
              label: _getSortLabel(l10n, sortBy),
              icon: Icons.sort,
              isActive: sortBy != TodoSortBy.status,
              onTap: () => _showSortMenu(context, ref, l10n),
            ),

            // 필터 초기화
            if (hasFilter) ...[
              const SizedBox(width: AppSizes.spaceS),
              ActionChip(
                avatar: const Icon(Icons.clear, size: 16),
                label: Text(
                  l10n.todo_clearFilter,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                visualDensity: VisualDensity.compact,
                onPressed: () {
                  ref.read(todoFilterStatusProvider.notifier).state = null;
                  ref.read(todoFilterPriorityProvider.notifier).state = null;
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showStatusFilterMenu(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    final current = ref.read(todoFilterStatusProvider);
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.all_inclusive),
              title: Text(l10n.todo_filterAll),
              selected: current == null,
              onTap: () {
                ref.read(todoFilterStatusProvider.notifier).state = null;
                Navigator.pop(context);
              },
            ),
            ...TaskStatus.values.map((status) => ListTile(
              leading: Icon(
                _getStatusIconData(status),
                color: _getStatusColorValue(status),
              ),
              title: Text(_getStatusLabel(l10n, status)),
              selected: current == status,
              onTap: () {
                ref.read(todoFilterStatusProvider.notifier).state = status;
                Navigator.pop(context);
              },
            )),
          ],
        ),
      ),
    );
  }

  void _showPriorityFilterMenu(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    final current = ref.read(todoFilterPriorityProvider);
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.all_inclusive),
              title: Text(l10n.todo_filterAll),
              selected: current == null,
              onTap: () {
                ref.read(todoFilterPriorityProvider.notifier).state = null;
                Navigator.pop(context);
              },
            ),
            ...TaskPriority.values.map((priority) => ListTile(
              leading: Icon(
                Icons.flag,
                color: _getPriorityColor(priority),
              ),
              title: Text(_getPriorityLabel(l10n, priority)),
              selected: current == priority,
              onTap: () {
                ref.read(todoFilterPriorityProvider.notifier).state = priority;
                Navigator.pop(context);
              },
            )),
          ],
        ),
      ),
    );
  }

  void _showSortMenu(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    final current = ref.read(todoSortByProvider);
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: TodoSortBy.values.map((sort) => ListTile(
            leading: Icon(_getSortIcon(sort)),
            title: Text(_getSortLabel(l10n, sort)),
            selected: current == sort,
            onTap: () {
              ref.read(todoSortByProvider.notifier).state = sort;
              Navigator.pop(context);
            },
          )).toList(),
        ),
      ),
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

  String _getPriorityLabel(AppLocalizations l10n, TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low: return l10n.todo_priorityLow;
      case TaskPriority.medium: return l10n.todo_priorityMedium;
      case TaskPriority.high: return l10n.todo_priorityHigh;
      case TaskPriority.urgent: return l10n.todo_priorityUrgent;
    }
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low: return AppColors.textSecondary;
      case TaskPriority.medium: return AppColors.primary;
      case TaskPriority.high: return AppColors.warning;
      case TaskPriority.urgent: return AppColors.error;
    }
  }

  String _getSortLabel(AppLocalizations l10n, TodoSortBy sort) {
    switch (sort) {
      case TodoSortBy.status: return l10n.todo_sortByStatus;
      case TodoSortBy.priority: return l10n.todo_sortByPriority;
      case TodoSortBy.dueDate: return l10n.todo_sortByDueDate;
      case TodoSortBy.createdAt: return l10n.todo_sortByCreatedAt;
    }
  }

  IconData _getSortIcon(TodoSortBy sort) {
    switch (sort) {
      case TodoSortBy.status: return Icons.flag_outlined;
      case TodoSortBy.priority: return Icons.priority_high;
      case TodoSortBy.dueDate: return Icons.event;
      case TodoSortBy.createdAt: return Icons.access_time;
    }
  }

  IconData _getStatusIconData(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending: return Icons.radio_button_unchecked;
      case TaskStatus.inProgress: return Icons.play_circle_outline;
      case TaskStatus.completed: return Icons.check_circle;
      case TaskStatus.hold: return Icons.pause_circle_outline;
      case TaskStatus.drop: return Icons.remove_circle_outline;
      case TaskStatus.failed: return Icons.error_outline;
    }
  }

  Color _getStatusColorValue(TaskStatus status) {
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

/// 필터 칩
class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(
        icon,
        size: 16,
        color: isActive ? AppColors.primary : null,
      ),
      label: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: isActive ? AppColors.primary : null,
          fontWeight: isActive ? FontWeight.bold : null,
        ),
      ),
      visualDensity: VisualDensity.compact,
      side: isActive
          ? const BorderSide(color: AppColors.primary)
          : null,
      onPressed: onTap,
    );
  }
}

/// 모아 보기 리스트 뷰
class _OverviewListView extends ConsumerWidget {
  const _OverviewListView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final overviewTasksAsync = ref.watch(todoOverviewTasksProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(todoOverviewTasksProvider);
      },
      child: overviewTasksAsync.when(
        data: (response) {
          final filterStatus = ref.watch(todoFilterStatusProvider);
          final filterPriority = ref.watch(todoFilterPriorityProvider);
          final sortBy = ref.watch(todoSortByProvider);

          // 필터 적용
          var tasks = List<TaskModel>.from(response.data);
          if (filterStatus != null) {
            tasks = tasks.where((t) => t.status == filterStatus).toList();
          }
          if (filterPriority != null) {
            tasks = tasks.where((t) => t.priority == filterPriority).toList();
          }

          if (tasks.isEmpty) {
            return _EmptyState(l10n: l10n);
          }

          // 날짜 기준으로 섹션 분류
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          final tomorrow = today.add(const Duration(days: 1));
          final thisWeekEnd = today.add(Duration(days: 7 - today.weekday));
          final nextWeekEnd = thisWeekEnd.add(const Duration(days: 7));

          final Map<_OverviewSection, List<TaskModel>> sections = {
            _OverviewSection.overdue: [],
            _OverviewSection.today: [],
            _OverviewSection.tomorrow: [],
            _OverviewSection.thisWeek: [],
            _OverviewSection.nextWeek: [],
            _OverviewSection.later: [],
            _OverviewSection.noDueDate: [],
          };

          for (final task in tasks) {
            final dueDate = task.dueAt ?? task.scheduledAt;
            if (dueDate == null) {
              sections[_OverviewSection.noDueDate]!.add(task);
              continue;
            }

            final normalizedDue = DateTime(dueDate.year, dueDate.month, dueDate.day);

            if (normalizedDue.isBefore(today)) {
              sections[_OverviewSection.overdue]!.add(task);
            } else if (normalizedDue == today) {
              sections[_OverviewSection.today]!.add(task);
            } else if (normalizedDue == tomorrow) {
              sections[_OverviewSection.tomorrow]!.add(task);
            } else if (!normalizedDue.isAfter(thisWeekEnd)) {
              sections[_OverviewSection.thisWeek]!.add(task);
            } else if (!normalizedDue.isAfter(nextWeekEnd)) {
              sections[_OverviewSection.nextWeek]!.add(task);
            } else {
              sections[_OverviewSection.later]!.add(task);
            }
          }

          // 각 섹션 내 정렬 적용
          for (final section in sections.values) {
            section.sort((a, b) => _compareTasks(a, b, sortBy));
          }

          // 비어있지 않은 섹션만 표시
          final activeSections = sections.entries
              .where((e) => e.value.isNotEmpty)
              .toList();

          return ListView.builder(
            padding: const EdgeInsets.all(AppSizes.spaceM),
            itemCount: activeSections.fold<int>(0, (sum, e) => sum + 1 + e.value.length),
            itemBuilder: (context, index) {
              // 섹션과 아이템 인덱스 계산
              int currentIndex = 0;
              for (final entry in activeSections) {
                // 섹션 헤더
                if (currentIndex == index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      top: currentIndex > 0 ? AppSizes.spaceL : 0,
                      bottom: AppSizes.spaceS,
                    ),
                    child: _OverviewSectionHeader(
                      section: entry.key,
                      count: entry.value.length,
                      l10n: l10n,
                    ),
                  );
                }
                currentIndex++;

                // 섹션 아이템들
                if (index < currentIndex + entry.value.length) {
                  final taskIndex = index - currentIndex;
                  final task = entry.value[taskIndex];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSizes.spaceS),
                    child: TodoListItem(
                      task: task,
                      onTap: () {
                        context.push('/todo/detail', extra: {
                          'taskId': task.id,
                          'task': task,
                        });
                      },
                      onStatusChange: (newStatus) {
                        ref.read(taskManagementProvider.notifier).updateStatus(
                          task.id,
                          newStatus,
                          task.scheduledAt ?? task.dueAt ?? DateTime.now(),
                        );
                        ref.invalidate(todoOverviewTasksProvider);
                      },
                    ),
                  );
                }
                currentIndex += entry.value.length;
              }
              return const SizedBox.shrink();
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _ErrorState(
          error: error.toString(),
          onRetry: () {
            ref.invalidate(todoOverviewTasksProvider);
          },
          l10n: l10n,
        ),
      ),
    );
  }

  int _compareTasks(TaskModel a, TaskModel b, TodoSortBy sortBy) {
    switch (sortBy) {
      case TodoSortBy.status:
        if (a.status != b.status) {
          return a.status.index.compareTo(b.status.index);
        }
        final priorityA = a.priority?.index ?? 0;
        final priorityB = b.priority?.index ?? 0;
        return priorityB.compareTo(priorityA);
      case TodoSortBy.priority:
        final priorityA = a.priority?.index ?? 0;
        final priorityB = b.priority?.index ?? 0;
        if (priorityA != priorityB) return priorityB.compareTo(priorityA);
        return a.status.index.compareTo(b.status.index);
      case TodoSortBy.dueDate:
        final dueDateA = a.dueAt ?? a.scheduledAt;
        final dueDateB = b.dueAt ?? b.scheduledAt;
        if (dueDateA == null && dueDateB == null) return 0;
        if (dueDateA == null) return 1;
        if (dueDateB == null) return -1;
        return dueDateA.compareTo(dueDateB);
      case TodoSortBy.createdAt:
        return b.createdAt.compareTo(a.createdAt);
    }
  }
}

/// 모아 보기 섹션 헤더
class _OverviewSectionHeader extends StatelessWidget {
  final _OverviewSection section;
  final int count;
  final AppLocalizations l10n;

  const _OverviewSectionHeader({
    required this.section,
    required this.count,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final (title, icon, color) = _getSectionInfo();

    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: AppSizes.spaceS),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(width: AppSizes.spaceS),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$count',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  (String, IconData, Color) _getSectionInfo() {
    switch (section) {
      case _OverviewSection.overdue:
        return (l10n.todo_overviewOverdue, Icons.warning_amber, AppColors.error);
      case _OverviewSection.today:
        return (l10n.todo_overviewToday, Icons.today, AppColors.primary);
      case _OverviewSection.tomorrow:
        return (l10n.todo_overviewTomorrow, Icons.event, AppColors.secondary);
      case _OverviewSection.thisWeek:
        return (l10n.todo_overviewThisWeek, Icons.date_range, AppColors.primary);
      case _OverviewSection.nextWeek:
        return (l10n.todo_overviewNextWeek, Icons.calendar_month, AppColors.textSecondary);
      case _OverviewSection.later:
        return (l10n.todo_overviewLater, Icons.schedule, AppColors.textSecondary);
      case _OverviewSection.noDueDate:
        return (l10n.todo_overviewNoDueDate, Icons.event_busy, AppColors.textSecondary);
    }
  }
}

/// 선택된 날짜 헤더
class _SelectedDateHeader extends ConsumerWidget {
  final DateTime selectedDate;
  final AppLocalizations l10n;

  const _SelectedDateHeader({
    required this.selectedDate,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final isToday = selectedDate == today;
    final showCompleted = ref.watch(showCompletedTodosProvider);

    final dayNames = [
      l10n.schedule_daySun,
      l10n.schedule_dayMon,
      l10n.schedule_dayTue,
      l10n.schedule_dayWed,
      l10n.schedule_dayThu,
      l10n.schedule_dayFri,
      l10n.schedule_daySat,
    ];

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceM,
        vertical: AppSizes.spaceS,
      ),
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      child: Row(
        children: [
          Text(
            '${selectedDate.month}월 ${selectedDate.day}일 (${dayNames[selectedDate.weekday % 7]})',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          if (isToday) ...[
            const SizedBox(width: AppSizes.spaceS),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                l10n.schedule_today,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          const Spacer(),
          // 완료된 항목 보기 체크박스
          InkWell(
            onTap: () {
              ref.read(showCompletedTodosProvider.notifier).state = !showCompleted;
            },
            borderRadius: BorderRadius.circular(4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: Checkbox(
                    value: showCompleted,
                    onChanged: (value) {
                      ref.read(showCompletedTodosProvider.notifier).state = value ?? false;
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  l10n.todo_showCompleted,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 칸반 뷰 (태블릿/데스크톱 전용 - 가로 스크롤)
class _KanbanView extends ConsumerWidget {
  final List<TaskModel> tasks;

  const _KanbanView({required this.tasks});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    // 상태별로 분류
    final pendingTasks = tasks.where((t) => t.isPending).toList();
    final inProgressTasks = tasks.where((t) => t.isInProgress).toList();
    final completedTasks = tasks.where((t) => t.isCompleted).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(AppSizes.spaceM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TodoKanbanColumn(
            title: l10n.todo_statusPending,
            icon: Icons.pending_outlined,
            color: AppColors.textSecondary,
            tasks: pendingTasks,
            onTaskTap: (task) {
              context.push('/todo/detail', extra: {
                'taskId': task.id,
                'task': task,
              });
            },
            onStatusChange: (task, status) {
              _updateStatus(ref, task, status);
            },
            onAcceptDrop: (task) {
              if (!task.isPending) {
                _updateStatus(ref, task, TaskStatus.pending);
              }
            },
          ),
          const SizedBox(width: AppSizes.spaceM),
          TodoKanbanColumn(
            title: l10n.todo_statusInProgress,
            icon: Icons.play_circle_outline,
            color: AppColors.primary,
            tasks: inProgressTasks,
            onTaskTap: (task) {
              context.push('/todo/detail', extra: {
                'taskId': task.id,
                'task': task,
              });
            },
            onStatusChange: (task, status) {
              _updateStatus(ref, task, status);
            },
            onAcceptDrop: (task) {
              if (!task.isInProgress) {
                _updateStatus(ref, task, TaskStatus.inProgress);
              }
            },
          ),
          const SizedBox(width: AppSizes.spaceM),
          TodoKanbanColumn(
            title: l10n.todo_statusCompleted,
            icon: Icons.check_circle_outline,
            color: AppColors.success,
            tasks: completedTasks,
            onTaskTap: (task) {
              context.push('/todo/detail', extra: {
                'taskId': task.id,
                'task': task,
              });
            },
            onStatusChange: (task, status) {
              _updateStatus(ref, task, status);
            },
            onAcceptDrop: (task) {
              if (!task.isCompleted) {
                _updateStatus(ref, task, TaskStatus.completed);
              }
            },
          ),
        ],
      ),
    );
  }

  void _updateStatus(WidgetRef ref, TaskModel task, TaskStatus status) {
    ref.read(taskManagementProvider.notifier).updateStatus(
      task.id,
      status,
      task.scheduledAt ?? task.dueAt ?? DateTime.now(),
    );
    ref.invalidate(todoTasksProvider(page: 1));
  }
}

/// 리스트 뷰
class _ListView extends ConsumerWidget {
  final List<TaskModel> tasks;

  const _ListView({required this.tasks});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final filterStatus = ref.watch(todoFilterStatusProvider);
    final filterPriority = ref.watch(todoFilterPriorityProvider);
    final sortBy = ref.watch(todoSortByProvider);

    // 필터 적용
    var filteredTasks = List<TaskModel>.from(tasks);
    if (filterStatus != null) {
      filteredTasks = filteredTasks.where((t) => t.status == filterStatus).toList();
    }
    if (filterPriority != null) {
      filteredTasks = filteredTasks.where((t) => t.priority == filterPriority).toList();
    }

    if (filteredTasks.isEmpty) {
      return _EmptyState(l10n: l10n);
    }

    // 정렬 적용
    final sortedTasks = filteredTasks..sort((a, b) => _compareTasks(a, b, sortBy));

    return ListView.builder(
      padding: const EdgeInsets.all(AppSizes.spaceM),
      itemCount: sortedTasks.length,
      itemBuilder: (context, index) {
        final task = sortedTasks[index];

        // 섹션 헤더 표시 (상태별)
        final showHeader = index == 0 ||
            sortedTasks[index - 1].status != task.status;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showHeader) ...[
              if (index > 0) const SizedBox(height: AppSizes.spaceL),
              _SectionHeader(
                title: _getStatusTitle(l10n, task.status),
                icon: _getStatusIcon(task.status),
                color: _getStatusColor(task.status),
                count: sortedTasks.where((t) => t.status == task.status).length,
              ),
              const SizedBox(height: AppSizes.spaceS),
            ],
            Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.spaceS),
              child: TodoListItem(
                task: task,
                onTap: () {
                  context.push('/todo/detail', extra: {
                    'taskId': task.id,
                    'task': task,
                  });
                },
                onStatusChange: (newStatus) {
                  ref.read(taskManagementProvider.notifier).updateStatus(
                    task.id,
                    newStatus,
                    task.scheduledAt ?? task.dueAt ?? DateTime.now(),
                  );
                  ref.invalidate(todoTasksProvider(page: 1));
                },
              ),
            ),
          ],
        );
      },
    );
  }

  String _getStatusTitle(AppLocalizations l10n, TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return l10n.todo_statusPending;
      case TaskStatus.inProgress:
        return l10n.todo_statusInProgress;
      case TaskStatus.completed:
        return l10n.todo_statusCompleted;
      case TaskStatus.hold:
        return l10n.todo_statusHold;
      case TaskStatus.drop:
        return l10n.todo_statusDrop;
      case TaskStatus.failed:
        return l10n.todo_statusFailed;
    }
  }

  IconData _getStatusIcon(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return Icons.pending_outlined;
      case TaskStatus.inProgress:
        return Icons.play_circle_outline;
      case TaskStatus.completed:
        return Icons.check_circle_outline;
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

  int _compareTasks(TaskModel a, TaskModel b, TodoSortBy sortBy) {
    switch (sortBy) {
      case TodoSortBy.status:
        if (a.status != b.status) {
          return a.status.index.compareTo(b.status.index);
        }
        final priorityA = a.priority?.index ?? 0;
        final priorityB = b.priority?.index ?? 0;
        return priorityB.compareTo(priorityA);
      case TodoSortBy.priority:
        final priorityA = a.priority?.index ?? 0;
        final priorityB = b.priority?.index ?? 0;
        if (priorityA != priorityB) {
          return priorityB.compareTo(priorityA);
        }
        return a.status.index.compareTo(b.status.index);
      case TodoSortBy.dueDate:
        final dueDateA = a.dueAt ?? a.scheduledAt;
        final dueDateB = b.dueAt ?? b.scheduledAt;
        if (dueDateA == null && dueDateB == null) return 0;
        if (dueDateA == null) return 1;
        if (dueDateB == null) return -1;
        return dueDateA.compareTo(dueDateB);
      case TodoSortBy.createdAt:
        return b.createdAt.compareTo(a.createdAt);
    }
  }
}

/// 섹션 헤더
class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final int count;

  const _SectionHeader({
    required this.title,
    required this.icon,
    required this.color,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: AppSizes.spaceS),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(width: AppSizes.spaceS),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$count',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

/// 빈 상태
class _EmptyState extends StatelessWidget {
  final AppLocalizations l10n;

  const _EmptyState({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_alt,
            size: AppSizes.iconXLarge,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: AppSizes.spaceM),
          Text(
            l10n.todo_noTodos,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// 에러 상태
class _ErrorState extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;
  final AppLocalizations l10n;

  const _ErrorState({
    required this.error,
    required this.onRetry,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: AppSizes.iconXLarge,
            color: AppColors.error,
          ),
          const SizedBox(height: AppSizes.spaceM),
          Text(
            l10n.todo_loadError,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: AppSizes.spaceS),
          Text(
            error,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.spaceM),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: Text(l10n.common_retry),
          ),
        ],
      ),
    );
  }
}

/// 할일 검색 바 위젯
class _TodoSearchBar extends ConsumerStatefulWidget {
  const _TodoSearchBar();

  @override
  ConsumerState<_TodoSearchBar> createState() => _TodoSearchBarState();
}

class _TodoSearchBarState extends ConsumerState<_TodoSearchBar> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      ref.read(todoSearchQueryProvider.notifier).state =
          value.trim().isEmpty ? null : value.trim();
    });
  }

  void _clearSearch() {
    _controller.clear();
    ref.read(todoSearchQueryProvider.notifier).state = null;
    ref.read(todoSearchActiveProvider.notifier).state = false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceM,
        vertical: AppSizes.spaceS,
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        decoration: InputDecoration(
          hintText: l10n.todo_searchHint,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            icon: const Icon(Icons.close),
            onPressed: _clearSearch,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          ),
          filled: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spaceM,
            vertical: AppSizes.spaceS,
          ),
        ),
        onChanged: _onSearchChanged,
      ),
    );
  }
}

/// 할일 검색 결과 위젯
class _TodoSearchResults extends ConsumerWidget {
  const _TodoSearchResults();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final searchQuery = ref.watch(todoSearchQueryProvider);
    final resultsAsync = ref.watch(todoSearchResultsProvider);

    // 쿼리가 없으면 힌트 표시
    if (searchQuery == null || searchQuery.trim().isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: AppSizes.iconXLarge,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: AppSizes.spaceM),
            Text(
              l10n.todo_searchHint,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
      );
    }

    return resultsAsync.when(
      data: (tasks) {
        if (tasks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: AppSizes.iconXLarge,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: AppSizes.spaceM),
                Text(
                  l10n.todo_searchNoResults,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 검색 결과 개수
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spaceM,
                vertical: AppSizes.spaceS,
              ),
              child: Text(
                l10n.todo_searchResultCount(tasks.length),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ),
            // 결과 목록
            Expanded(
              child: ListView.separated(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSizes.spaceM),
                itemCount: tasks.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: AppSizes.spaceS),
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return TodoListItem(
                    task: task,
                    onTap: () {
                      context.push('/todo/detail', extra: {
                        'taskId': task.id,
                        'task': task,
                      });
                    },
                    onStatusChange: (newStatus) {
                      ref.read(taskManagementProvider.notifier).updateStatus(
                            task.id,
                            newStatus,
                            task.scheduledAt ?? task.dueAt ?? DateTime.now(),
                          );
                      ref.invalidate(todoSearchResultsProvider);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: AppSizes.iconXLarge,
              color: AppColors.error,
            ),
            const SizedBox(height: AppSizes.spaceM),
            Text(
              l10n.todo_loadError,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: AppSizes.spaceS),
            ElevatedButton.icon(
              onPressed: () {
                ref.invalidate(todoSearchResultsProvider);
              },
              icon: const Icon(Icons.refresh),
              label: Text(l10n.common_retry),
            ),
          ],
        ),
      ),
    );
  }
}
