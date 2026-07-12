import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/core/widgets/reorderable_widgets.dart';
import 'package:family_planner/features/main/routine/data/models/routine_model.dart';
import 'package:family_planner/features/main/routine/presentation/widgets/routine_list_item.dart';
import 'package:family_planner/features/main/routine/providers/routine_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 루틴 목록 화면 (오늘 체크 리스트)
class RoutineListScreen extends ConsumerWidget {
  const RoutineListScreen({super.key});

  Future<void> _toggleCheck(
    BuildContext context,
    WidgetRef ref,
    Routine routine,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final success = await ref
        .read(routineManagementProvider.notifier)
        .toggleCheck(routine.id, routine.checkedToday);
    if (!success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.routine_check_error)),
      );
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Routine routine,
  ) async {
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
        .deleteRoutine(routine.id);
    if (!success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.routine_error_generic)),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final routinesAsync = ref.watch(routineListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.routine_title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.routineAdd),
        child: const Icon(Icons.add),
      ),
      body: routinesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(l10n.routine_error_generic)),
        data: (routines) {
          if (routines.isEmpty) {
            return Center(
              child: Text(
                l10n.routine_list_empty,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.read(routineListProvider.notifier).refresh(),
            child: ReorderableListView.builder(
              padding: EdgeInsets.fromLTRB(
                AppSizes.spaceM,
                AppSizes.spaceM,
                AppSizes.spaceM,
                AppSizes.spaceM + MediaQuery.paddingOf(context).bottom + 72,
              ),
              buildDefaultDragHandles: false,
              proxyDecorator: buildReorderableProxyDecorator,
              itemCount: routines.length,
              onReorderItem: (oldIndex, newIndex) {
                final reordered = [...routines];
                final item = reordered.removeAt(oldIndex);
                reordered.insert(newIndex, item);
                ref
                    .read(routineManagementProvider.notifier)
                    .reorder(reordered);
              },
              itemBuilder: (context, index) {
                final routine = routines[index];
                return Dismissible(
                  key: ValueKey(routine.id),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (_) async {
                    await _confirmDelete(context, ref, routine);
                    return false;
                  },
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: AppSizes.spaceL),
                    margin: const EdgeInsets.only(bottom: AppSizes.spaceM),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.errorContainer,
                      borderRadius:
                          BorderRadius.circular(AppSizes.radiusMedium),
                    ),
                    child: Icon(
                      Icons.delete_outline,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                  child: RoutineListItem(
                    key: ValueKey('${routine.id}_content'),
                    routine: routine,
                    dragHandle: ReorderableDragStartListener(
                      index: index,
                      child: const DragHandleIcon(),
                    ),
                    onTap: () => context.push(
                      AppRoutes.routineDetail,
                      extra: {'routineId': routine.id},
                    ),
                    onToggleCheck: () => _toggleCheck(context, ref, routine),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
