import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/main/routine/presentation/screens/routine_badges_tab.dart';
import 'package:family_planner/features/main/routine/presentation/screens/routine_heatmap_tab.dart';
import 'package:family_planner/features/main/routine/presentation/screens/routine_share_tab.dart';
import 'package:family_planner/features/main/routine/presentation/screens/routine_stats_tab.dart';
import 'package:family_planner/features/main/routine/providers/routine_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/shared/widgets/app_error_state.dart';

/// 루틴 상세 화면 셸 (히트맵/통계/배지/공유 4탭)
class RoutineDetailScreen extends ConsumerWidget {
  const RoutineDetailScreen({super.key, required this.routineId});

  final String routineId;

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.routine_delete),
        content: Text(l10n.routine_delete_confirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.routine_delete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final success = await ref
        .read(routineManagementProvider.notifier)
        .deleteRoutine(routineId);
    if (!context.mounted) return;
    if (success) {
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.routine_error_generic)),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final detailAsync = ref.watch(routineDetailProvider(routineId));

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            detailAsync.valueOrNull?.title ?? l10n.routine_title,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => context.push(
                AppRoutes.routineEdit,
                extra: {'routineId': routineId},
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _confirmDelete(context, ref),
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: l10n.routine_tab_heatmap),
              Tab(text: l10n.routine_tab_stats),
              Tab(text: l10n.routine_tab_badges),
              Tab(text: l10n.routine_tab_share),
            ],
          ),
        ),
        body: detailAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => AppErrorState(
            error: error,
            title: l10n.routine_error_generic,
            onRetry: () => ref.invalidate(routineDetailProvider(routineId)),
          ),
          data: (routine) => TabBarView(
            children: [
              RoutineHeatmapTab(routine: routine),
              RoutineStatsTab(routineId: routineId),
              RoutineBadgesTab(routineId: routineId),
              RoutineShareTab(routineId: routineId),
            ],
          ),
        ),
      ),
    );
  }
}
