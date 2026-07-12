import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/main/routine/data/models/routine_model.dart';
import 'package:family_planner/features/main/routine/providers/routine_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/shared/widgets/dashboard_card.dart';

/// 홈 대시보드 - 오늘의 루틴 요약 위젯 (인라인 체크 토글 포함)
class RoutineSummaryWidget extends ConsumerWidget {
  const RoutineSummaryWidget({super.key});

  Future<void> _toggleCheck(
    BuildContext context,
    WidgetRef ref,
    RoutineSummaryItem item,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final success = await ref
        .read(routineManagementProvider.notifier)
        .toggleCheck(item.routineId, item.checkedToday);
    if (!success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.routine_check_error)),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final summaryAsync = ref.watch(routineSummaryProvider);

    return DashboardCard(
      title: l10n.widgetSettings_routineSummary,
      icon: Icons.check_circle_outline,
      onTap: () => context.push(AppRoutes.routines),
      child: summaryAsync.when(
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.all(AppSizes.spaceM),
            child: CircularProgressIndicator(),
          ),
        ),
        error: (_, _) => const _EmptyState(),
        data: (items) {
          if (items.isEmpty) return const _EmptyState();
          return Column(
            children: items.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.spaceS),
                child: Row(
                  children: [
                    Text(
                      item.emoji ?? '✅',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(width: AppSizes.spaceS),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: Theme.of(context).textTheme.bodyMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (item.currentStreakDays > 0)
                            Text(
                              '🔥 ${item.currentStreakDays}',
                              style:
                                  Theme.of(context).textTheme.labelSmall?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      icon: Icon(
                        item.checkedToday
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: item.checkedToday
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      onPressed: () => _toggleCheck(context, ref, item),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceM),
      child: Center(
        child: Text(
          l10n.routine_list_empty,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ),
    );
  }
}
