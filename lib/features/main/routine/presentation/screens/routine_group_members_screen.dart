import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/main/routine/data/models/routine_model.dart';
import 'package:family_planner/features/main/routine/providers/routine_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/shared/widgets/app_empty_state.dart';
import 'package:family_planner/shared/widgets/app_error_state.dart';

/// 그룹원별 공유 루틴 현황 화면 (읽기 전용)
class RoutineGroupMembersScreen extends ConsumerWidget {
  const RoutineGroupMembersScreen({super.key, required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final membersAsync = ref.watch(routineGroupMembersProvider(groupId));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.routine_group_members_title),
        actions: [
          IconButton(
            icon: const Icon(Icons.leaderboard_outlined),
            tooltip: l10n.routine_leaderboard_title,
            onPressed: () => context.push(
              AppRoutes.routineLeaderboard.replaceFirst(':groupId', groupId),
            ),
          ),
        ],
      ),
      body: membersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => AppErrorState(
          error: error,
          title: l10n.routine_error_generic,
          onRetry: () => ref.invalidate(routineGroupMembersProvider(groupId)),
        ),
        data: (members) {
          final withRoutines = members
              .where((m) => m.routines.isNotEmpty)
              .toList();
          if (withRoutines.isEmpty) {
            return AppEmptyState(
              icon: Icons.groups_outlined,
              message: l10n.routine_group_members_empty,
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
              return _MemberSection(groupId: groupId, member: member);
            },
          );
        },
      ),
    );
  }
}

class _MemberSection extends StatelessWidget {
  const _MemberSection({required this.groupId, required this.member});

  final String groupId;
  final RoutineGroupMemberRoutines member;

  void _showMemberDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusMedium),
        ),
      ),
      builder: (_) => _MemberDetailSheet(
        groupId: groupId,
        userId: member.userId,
        userName: member.userName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.spaceM),
      child: InkWell(
        onTap: () => _showMemberDetail(context),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer,
                    child: Text(
                      member.userName.isNotEmpty ? member.userName[0] : '?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.spaceS),
                  Expanded(
                    child: Text(
                      member.userName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.spaceS),
              const Divider(height: 1),
              ...member.routines.map(
                (routine) => _MemberRoutineTile(routine: routine),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 그룹원 카드의 개별 루틴 행 (체크 여부 + 스트릭 배지)
class _MemberRoutineTile extends ConsumerWidget {
  const _MemberRoutineTile({required this.routine});

  final Routine routine;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = routine.checkedToday;
    final streakDays =
        ref
            .watch(routineStreakProvider(routine.id))
            .valueOrNull
            ?.currentStreakDays ??
        0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceS),
      child: Row(
        children: [
          (routine.emoji != null && routine.emoji!.isNotEmpty)
              ? Text(routine.emoji!, style: const TextStyle(fontSize: 18))
              : const Icon(Icons.check_circle_outline, size: 18),
          const SizedBox(width: AppSizes.spaceS),
          Expanded(
            child: Text(
              routine.title,
              style: Theme.of(context).textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          _StreakBadge(streakDays: streakDays),
          Icon(
            progress ? Icons.check_circle : Icons.radio_button_unchecked,
            color: progress
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
            size: 20,
          ),
        ],
      ),
    );
  }
}

/// 스트릭 일수 배지 (🔥N) — 0일이면 아무것도 렌더링하지 않음
class _StreakBadge extends StatelessWidget {
  const _StreakBadge({required this.streakDays});

  final int streakDays;

  @override
  Widget build(BuildContext context) {
    if (streakDays <= 0) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(right: AppSizes.spaceS),
      child: Text(
        '🔥 $streakDays',
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: AppColors.warning,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// 그룹원 상세 바텀시트 (루틴별 진행 정보)
class _MemberDetailSheet extends ConsumerWidget {
  const _MemberDetailSheet({
    required this.groupId,
    required this.userId,
    required this.userName,
  });

  final String groupId;
  final String userId;
  final String userName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final detailProviderArg = routineGroupMemberDetailProvider(groupId, userId);
    final detailAsync = ref.watch(detailProviderArg);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      builder: (context, scrollController) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.spaceL,
              AppSizes.spaceM,
              AppSizes.spaceL,
              AppSizes.spaceS,
            ),
            child: Text(
              userName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: detailAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => AppErrorState(
                error: error,
                title: l10n.routine_error_generic,
                onRetry: () => ref.invalidate(detailProviderArg),
              ),
              data: (routines) {
                if (routines.isEmpty) {
                  return AppEmptyState(
                    icon: Icons.checklist_outlined,
                    message: l10n.routine_group_members_empty,
                  );
                }
                return ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(AppSizes.spaceM),
                  itemCount: routines.length,
                  itemBuilder: (context, index) {
                    return _MemberDetailRoutineCard(routine: routines[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// 그룹원 상세 바텀시트의 개별 루틴 카드 (체크 여부 + 스트릭 배지)
class _MemberDetailRoutineCard extends ConsumerWidget {
  const _MemberDetailRoutineCard({required this.routine});

  final Routine routine;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final progress = routine.checkedToday;
    final streakDays =
        ref
            .watch(routineStreakProvider(routine.id))
            .valueOrNull
            ?.currentStreakDays ??
        0;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.spaceS),
      child: ListTile(
        leading: (routine.emoji != null && routine.emoji!.isNotEmpty)
            ? Text(routine.emoji!, style: const TextStyle(fontSize: 20))
            : const Icon(Icons.check_circle_outline, size: 20),
        title: Text(routine.title),
        subtitle: routine.targetCount != null
            ? Text(
                '${l10n.routine_this_week_progress}: ${routine.targetCount}${l10n.routine_field_target_count}',
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _StreakBadge(streakDays: streakDays),
            Icon(
              progress ? Icons.check_circle : Icons.radio_button_unchecked,
              color: progress
                  ? AppColors.success
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
