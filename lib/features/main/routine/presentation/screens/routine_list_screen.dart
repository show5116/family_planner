import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/core/widgets/reorderable_widgets.dart';
import 'package:family_planner/features/main/routine/data/models/routine_model.dart';
import 'package:family_planner/features/main/routine/presentation/widgets/routine_badge_celebration_dialog.dart';
import 'package:family_planner/features/main/routine/presentation/widgets/routine_group_form_dialog.dart';
import 'package:family_planner/features/main/routine/presentation/widgets/routine_group_section.dart';
import 'package:family_planner/features/main/routine/presentation/widgets/routine_list_item.dart';
import 'package:family_planner/features/main/routine/providers/routine_provider.dart';
import 'package:family_planner/features/onboarding/presentation/widgets/feature_coach_mark.dart';
import 'package:family_planner/features/onboarding/services/onboarding_service.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/shared/widgets/app_empty_state.dart';
import 'package:family_planner/shared/widgets/app_error_state.dart';

part '_routine_list_onboarding.dart';

/// 루틴 목록 화면 (오늘 체크 리스트)
class RoutineListScreen extends ConsumerStatefulWidget {
  const RoutineListScreen({super.key});

  @override
  ConsumerState<RoutineListScreen> createState() => _RoutineListScreenState();
}

class _RoutineListScreenState extends ConsumerState<RoutineListScreen> {
  final _addButtonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeShowOnboarding());
  }

  Future<void> _toggleCheck(
    BuildContext context,
    WidgetRef ref,
    Routine routine,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await ref
        .read(routineManagementProvider.notifier)
        .toggleCheck(routine.id, routine.checkedToday);
    if (!context.mounted) return;

    if (!result.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.routine_check_error)),
      );
    } else if (result.newlyEarnedBadges.isNotEmpty) {
      await showRoutineBadgeCelebration(context, result.newlyEarnedBadges);
    } else if (result.streakIncreased && result.currentStreakDays != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.routine_streak_celebration(result.currentStreakDays!),
          ),
          duration: const Duration(seconds: 2),
        ),
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

  Future<void> _showGroupForm(
    BuildContext context, {
    RoutineGroup? group,
  }) async {
    await showDialog<RoutineGroup>(
      context: context,
      builder: (context) => RoutineGroupFormDialog(group: group),
    );
  }

  Future<void> _confirmDeleteGroup(
    BuildContext context,
    WidgetRef ref,
    RoutineGroup group,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.routine_group_delete),
        content: Text(l10n.routine_group_delete_confirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.routine_group_delete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final success = await ref
        .read(routineGroupManagementProvider.notifier)
        .deleteRoutineGroup(group.id);
    if (!success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.routine_group_error_generic)),
      );
    }
  }

  Future<void> _showSharedGroupPicker(
    BuildContext context,
    List<Group> groups,
  ) async {
    final l10n = AppLocalizations.of(context)!;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusMedium),
        ),
      ),
      builder: (sheetContext) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (ctx, scrollController) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.spaceL,
                AppSizes.spaceM,
                AppSizes.spaceL,
                AppSizes.spaceS,
              ),
              child: Text(
                l10n.routine_shared_group_select,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: groups.isEmpty
                  ? Center(child: Text(l10n.routine_shared_group_empty))
                  : ListView(
                      controller: scrollController,
                      children: groups.map((group) {
                        return ListTile(
                          leading: const Icon(Icons.group_outlined),
                          title: Text(group.name),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.pop(sheetContext);
                            context.push(
                              AppRoutes.routineGroupMembers.replaceFirst(
                                ':groupId',
                                group.id,
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStandaloneItem(
    BuildContext context,
    List<Routine> standaloneRoutines,
    int index,
  ) {
    final routine = standaloneRoutines[index];
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
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
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
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final routinesAsync = ref.watch(routineListProvider);
    final groupsAsync = ref.watch(routineGroupListProvider);
    final myGroups = ref.watch(myGroupsProvider).valueOrNull ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.routine_title),
        actions: [
          IconButton(
            icon: const Icon(Icons.playlist_add),
            tooltip: l10n.routine_group_add,
            onPressed: () => _showGroupForm(context),
          ),
          IconButton(
            icon: const Icon(Icons.emoji_events_outlined),
            tooltip: l10n.routine_badges_title,
            onPressed: () => context.push(AppRoutes.routineBadges),
          ),
          IconButton(
            icon: const Icon(Icons.groups_outlined),
            tooltip: l10n.routine_shared_group_select,
            onPressed: () => _showSharedGroupPicker(context, myGroups),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        key: _addButtonKey,
        onPressed: () => context.push(AppRoutes.routineAdd),
        child: const Icon(Icons.add),
      ),
      body: routinesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => AppErrorState(
          error: error,
          title: l10n.routine_error_generic,
          onRetry: () => ref.read(routineListProvider.notifier).refresh(),
        ),
        data: (routines) {
          final groups = groupsAsync.valueOrNull ?? [];
          final standaloneRoutines =
              routines.where((r) => r.routineGroupId == null).toList();

          if (routines.isEmpty && groups.isEmpty) {
            return AppEmptyState(
              icon: Icons.checklist_outlined,
              message: l10n.routine_list_empty,
              subtitle: l10n.routine_list_empty_subtitle,
              action: FilledButton.icon(
                onPressed: () => context.push(AppRoutes.routineAdd),
                icon: const Icon(Icons.add),
                label: Text(l10n.routine_add),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(routineListProvider.notifier).refresh();
              await ref.read(routineGroupListProvider.notifier).refresh();
            },
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                AppSizes.spaceM,
                AppSizes.spaceM,
                AppSizes.spaceM,
                AppSizes.spaceM + MediaQuery.paddingOf(context).bottom + 72,
              ),
              children: [
                for (final group in groups)
                  RoutineGroupSection(
                    key: ValueKey(group.id),
                    group: group,
                    routines: routines
                        .where((r) => r.routineGroupId == group.id)
                        .toList(),
                    onTapRoutine: (routine) => context.push(
                      AppRoutes.routineDetail,
                      extra: {'routineId': routine.id},
                    ),
                    onToggleCheck: (routine) =>
                        _toggleCheck(context, ref, routine),
                    onReorderRoutines: (reordered) => ref
                        .read(routineManagementProvider.notifier)
                        .reorder(reordered),
                    onEditGroup: () =>
                        _showGroupForm(context, group: group),
                    onDeleteGroup: () =>
                        _confirmDeleteGroup(context, ref, group),
                  ),
                if (standaloneRoutines.isNotEmpty) ...[
                  if (groups.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSizes.spaceS,
                      ),
                      child: Text(
                        l10n.routine_group_standalone_section_title,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                  ReorderableListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    buildDefaultDragHandles: false,
                    proxyDecorator: buildReorderableProxyDecorator,
                    itemCount: standaloneRoutines.length,
                    onReorderItem: (oldIndex, newIndex) {
                      final reordered = [...standaloneRoutines];
                      final item = reordered.removeAt(oldIndex);
                      reordered.insert(newIndex, item);
                      ref
                          .read(routineManagementProvider.notifier)
                          .reorder(reordered);
                    },
                    itemBuilder: (context, index) => Padding(
                      key: ValueKey('${standaloneRoutines[index].id}_wrap'),
                      padding: const EdgeInsets.only(bottom: AppSizes.spaceM),
                      child: _buildStandaloneItem(
                        context,
                        standaloneRoutines,
                        index,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
