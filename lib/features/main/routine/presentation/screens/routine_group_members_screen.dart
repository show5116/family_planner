import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/routine/data/models/routine_model.dart';
import 'package:family_planner/features/main/routine/providers/routine_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 그룹원별 공유 루틴 현황 화면 (읽기 전용)
class RoutineGroupMembersScreen extends ConsumerWidget {
  const RoutineGroupMembersScreen({super.key, required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final membersAsync = ref.watch(routineGroupMembersProvider(groupId));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.routine_group_members_title)),
      body: membersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(l10n.routine_error_generic)),
        data: (members) {
          final withRoutines =
              members.where((m) => m.routines.isNotEmpty).toList();
          if (withRoutines.isEmpty) {
            return Center(
              child: Text(
                l10n.routine_group_members_empty,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.fromLTRB(
              AppSizes.spaceM,
              AppSizes.spaceM,
              AppSizes.spaceM,
              AppSizes.spaceM + MediaQuery.paddingOf(context).bottom,
            ),
            itemCount: withRoutines.length,
            itemBuilder: (context, index) {
              final member = withRoutines[index];
              return _MemberSection(member: member);
            },
          );
        },
      ),
    );
  }
}

class _MemberSection extends StatelessWidget {
  const _MemberSection({required this.member});

  final RoutineGroupMemberRoutines member;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.spaceM),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  child: Text(
                    member.userName.isNotEmpty ? member.userName[0] : '?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.spaceS),
                Text(
                  member.userName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spaceS),
            const Divider(height: 1),
            ...member.routines.map((routine) {
              final progress = routine.checkedToday;
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSizes.spaceS,
                ),
                child: Row(
                  children: [
                    Text(
                      routine.emoji ?? '✅',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(width: AppSizes.spaceS),
                    Expanded(
                      child: Text(
                        routine.title,
                        style: Theme.of(context).textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      progress
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: progress
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
