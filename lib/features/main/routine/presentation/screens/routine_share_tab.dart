import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/main/routine/data/models/routine_model.dart';
import 'package:family_planner/features/main/routine/presentation/widgets/routine_share_group_tile.dart';
import 'package:family_planner/features/main/routine/providers/routine_provider.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/shared/widgets/app_error_state.dart';

/// 루틴 상세 - 공유 그룹 관리 탭
class RoutineShareTab extends ConsumerWidget {
  const RoutineShareTab({super.key, required this.routineId});

  final String routineId;

  Future<void> _removeShare(
    BuildContext context,
    WidgetRef ref,
    RoutineShare share,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.routine_share_remove),
        content: Text(l10n.routine_share_remove_confirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.routine_share_remove),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final success = await ref
        .read(routineManagementProvider.notifier)
        .removeShare(routineId, share.groupId);
    if (!success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.routine_error_generic)),
      );
    }
  }

  Future<void> _showGroupPicker(
    BuildContext context,
    WidgetRef ref,
    List<Group> myGroups,
    List<String> sharedGroupIds,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final selectable =
        myGroups.where((g) => !sharedGroupIds.contains(g.id)).toList();

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
                l10n.routine_share_select_group,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: selectable.isEmpty
                  ? Center(child: Text(l10n.routine_share_empty))
                  : ListView(
                      controller: scrollController,
                      children: selectable.map((group) {
                        return ListTile(
                          leading: const Icon(Icons.group_outlined),
                          title: Text(group.name),
                          onTap: () async {
                            Navigator.pop(sheetContext);
                            await ref
                                .read(routineManagementProvider.notifier)
                                .addShare(routineId, group.id);
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final sharesAsync = ref.watch(routineSharesProvider(routineId));
    final myGroups = ref.watch(myGroupsProvider).valueOrNull ?? [];

    return sharesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => AppErrorState(
        error: error,
        title: l10n.routine_error_generic,
        onRetry: () =>
            ref.read(routineSharesProvider(routineId).notifier).refresh(),
      ),
      data: (shares) {
        return Column(
          children: [
            Expanded(
              child: shares.isEmpty
                  ? Center(
                      child: Text(
                        l10n.routine_share_empty,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(
                        AppSizes.spaceM,
                        AppSizes.spaceM,
                        AppSizes.spaceM,
                        AppSizes.spaceS,
                      ),
                      children: shares.map((share) {
                        return RoutineShareGroupTile(
                          share: share,
                          onRemove: () => _removeShare(context, ref, share),
                          onViewMembers: () => context.push(
                            AppRoutes.routineGroupMembers.replaceFirst(
                              ':groupId',
                              share.groupId,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSizes.spaceM,
                0,
                AppSizes.spaceM,
                AppSizes.spaceM + MediaQuery.paddingOf(context).bottom,
              ),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => _showGroupPicker(
                    context,
                    ref,
                    myGroups,
                    shares.map((s) => s.groupId).toList(),
                  ),
                  icon: const Icon(Icons.add),
                  label: Text(l10n.routine_share_add),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
