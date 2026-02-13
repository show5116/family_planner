import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/main/task/providers/task_provider.dart';
import 'package:family_planner/features/main/calendar/presentation/widgets/task_list_item.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 캘린더 검색 결과 위젯
class CalendarSearchResults extends ConsumerWidget {
  const CalendarSearchResults({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final searchQuery = ref.watch(calendarSearchQueryProvider);
    final resultsAsync = ref.watch(calendarSearchResultsProvider);
    final timeFormat =
        DateFormat.jm(Localizations.localeOf(context).toString());

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
              l10n.schedule_searchHint,
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
                  l10n.schedule_searchNoResults,
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
                l10n.schedule_searchResultCount(tasks.length),
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
                      ref
                          .read(taskManagementProvider.notifier)
                          .toggleComplete(
                            task.id,
                            !task.isCompleted,
                            task.scheduledAt ?? DateTime.now(),
                          );
                      ref.invalidate(calendarSearchResultsProvider);
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
              l10n.schedule_loadError,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: AppSizes.spaceS),
            ElevatedButton.icon(
              onPressed: () {
                ref.invalidate(calendarSearchResultsProvider);
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
