import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/main/task/providers/task_provider.dart';
import 'package:family_planner/features/main/calendar/presentation/widgets/task_list_item.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 선택된 날짜의 Task 목록 섹션 (Sliver 버전 — CustomScrollView 전용)
class SliverTaskListSection extends ConsumerWidget {
  final DateTime selectedDate;

  const SliverTaskListSection({
    super.key,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final tasksAsync = ref.watch(selectedDateTasksProvider);
    final focusedMonth = ref.watch(focusedMonthProvider);
    final monthlyAsync = ref.watch(monthlyTasksProvider(focusedMonth.year, focusedMonth.month));
    final isRefreshing = monthlyAsync.isLoading;
    final dateFormat = DateFormat.yMMMMd(Localizations.localeOf(context).toString());
    final timeFormat = DateFormat.jm(Localizations.localeOf(context).toString());

    // 헤더 sliver
    final headerSliver = SliverToBoxAdapter(
      child: _DateHeader(date: selectedDate, dateFormat: dateFormat),
    );

    if (isRefreshing) {
      return SliverMainAxisGroup(slivers: [
        headerSliver,
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: AppSizes.spaceXL),
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
      ]);
    }

    return tasksAsync.when(
      data: (tasks) {
        if (tasks.isEmpty) {
          return SliverMainAxisGroup(slivers: [
            headerSliver,
            SliverToBoxAdapter(child: _EmptyState(message: l10n.home_noSchedule)),
          ]);
        }
        return SliverMainAxisGroup(slivers: [
          headerSliver,
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceM),
            sliver: SliverList.separated(
              itemCount: tasks.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSizes.spaceS),
              itemBuilder: (context, index) {
                final task = tasks[index];
                return TaskListItem(
                  task: task,
                  timeFormat: timeFormat,
                  onTap: () {
                    context.push('/calendar/detail', extra: {
                      'taskId': task.id,
                      'task': task,
                    });
                  },
                  onToggleComplete: () {
                    ref.read(taskManagementProvider.notifier).toggleComplete(
                          task.id,
                          !task.isCompleted,
                          task.scheduledAt ?? DateTime.now(),
                        );
                  },
                );
              },
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSizes.spaceL)),
        ]);
      },
      loading: () => SliverMainAxisGroup(slivers: [
        headerSliver,
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: AppSizes.spaceXL),
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
      ]),
      error: (error, stack) => SliverMainAxisGroup(slivers: [
        headerSliver,
        SliverToBoxAdapter(
          child: _ErrorState(
            error: error.toString(),
            onRetry: () {
              final focusedMonth = ref.read(focusedMonthProvider);
              ref.invalidate(monthlyTasksProvider(focusedMonth.year, focusedMonth.month));
            },
          ),
        ),
      ]),
    );
  }
}

/// 선택된 날짜의 Task 목록 섹션 (기존 — Expanded 필요한 경우용)
class TaskListSection extends ConsumerWidget {
  final DateTime selectedDate;

  const TaskListSection({
    super.key,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final tasksAsync = ref.watch(selectedDateTasksProvider);
    final focusedMonth = ref.watch(focusedMonthProvider);
    final monthlyAsync = ref.watch(monthlyTasksProvider(focusedMonth.year, focusedMonth.month));
    final isRefreshing = monthlyAsync.isLoading;
    final dateFormat =
        DateFormat.yMMMMd(Localizations.localeOf(context).toString());
    final timeFormat =
        DateFormat.jm(Localizations.localeOf(context).toString());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DateHeader(date: selectedDate, dateFormat: dateFormat),
        Expanded(
          child: isRefreshing
              ? const Center(child: CircularProgressIndicator())
              : tasksAsync.when(
            data: (tasks) {
              if (tasks.isEmpty) {
                return _EmptyState(message: l10n.home_noSchedule);
              }
              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceM),
                itemCount: tasks.length,
                separatorBuilder: (_, _) => const SizedBox(height: AppSizes.spaceS),
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return TaskListItem(
                    task: task,
                    timeFormat: timeFormat,
                    onTap: () {
                      context.push('/calendar/detail', extra: {
                        'taskId': task.id,
                        'task': task,
                      });
                    },
                    onToggleComplete: () {
                      ref.read(taskManagementProvider.notifier).toggleComplete(
                            task.id,
                            !task.isCompleted,
                            task.scheduledAt ?? DateTime.now(),
                          );
                    },
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => _ErrorState(
              error: error.toString(),
              onRetry: () {
                final focusedMonth = ref.read(focusedMonthProvider);
                ref.invalidate(
                  monthlyTasksProvider(focusedMonth.year, focusedMonth.month),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

/// 날짜 헤더
class _DateHeader extends StatelessWidget {
  final DateTime date;
  final DateFormat dateFormat;

  const _DateHeader({
    required this.date,
    required this.dateFormat,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.spaceM),
      child: Row(
        children: [
          Icon(
            Icons.event_note,
            size: AppSizes.iconMedium,
            color: AppColors.primary,
          ),
          const SizedBox(width: AppSizes.spaceS),
          Text(
            dateFormat.format(date),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}

/// 빈 상태
class _EmptyState extends StatelessWidget {
  final String message;

  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_available,
            size: AppSizes.iconXLarge,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: AppSizes.spaceM),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
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

  const _ErrorState({
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
            l10n.schedule_loadError,
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
