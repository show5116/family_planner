import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/features/settings/groups/presentation/widgets/group_card.dart';
import 'package:family_planner/features/settings/groups/presentation/widgets/group_create_dialog.dart';
import 'package:family_planner/features/settings/groups/presentation/widgets/group_join_dialog.dart';
import 'package:family_planner/shared/widgets/app_empty_state.dart';
import 'package:family_planner/shared/widgets/app_error_state.dart';

/// 그룹 목록 화면
class GroupListScreen extends ConsumerWidget {
  const GroupListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final groupsAsyncValue = ref.watch(groupNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.group_title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(groupNotifierProvider.notifier).loadGroups();
            },
          ),
        ],
      ),
      body: groupsAsyncValue.when(
        data: (groups) => groups.isEmpty
            ? AppEmptyState(
                icon: Icons.groups_outlined,
                message: l10n.group_noGroups,
                subtitle: l10n.group_noGroupsDescription,
              )
            : RefreshIndicator(
                onRefresh: () async {
                  await ref.read(groupNotifierProvider.notifier).loadGroups();
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(AppSizes.spaceM),
                  itemCount: groups.length,
                  itemBuilder: (context, index) {
                    final group = groups[index];
                    return GroupCard(group: group);
                  },
                ),
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => AppErrorState(
          error: error,
          title: l10n.error_unknown,
          onRetry: () {
            ref.read(groupNotifierProvider.notifier).loadGroups();
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            onPressed: () => GroupJoinDialog.show(context, ref),
            icon: const Icon(Icons.login),
            label: Text(l10n.group_joinGroup),
            heroTag: 'join',
          ),
          const SizedBox(height: AppSizes.spaceM),
          FloatingActionButton.extended(
            onPressed: () => GroupCreateDialog.show(context, ref),
            icon: const Icon(Icons.add),
            label: Text(l10n.group_createGroup),
            heroTag: 'create',
          ),
        ],
      ),
    );
  }
}
