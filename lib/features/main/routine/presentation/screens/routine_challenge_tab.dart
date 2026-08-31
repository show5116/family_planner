import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/routine/data/models/routine_model.dart';
import 'package:family_planner/features/main/routine/presentation/widgets/routine_challenge_form_sheet.dart';
import 'package:family_planner/features/main/routine/presentation/widgets/routine_challenge_routine_picker.dart';
import 'package:family_planner/features/main/routine/providers/routine_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/shared/widgets/app_empty_state.dart';
import 'package:family_planner/shared/widgets/app_error_state.dart';

/// 그룹 챌린지 탭.
///
/// 개인 습관 구조는 그대로 두고, 각자 자기 습관을 연결해 같은 목표를
/// 기간제로 겨룬다. 랭킹(상시)과 달리 시작·종료가 있어 내기를 붙이기 좋다.
class RoutineChallengeTab extends ConsumerWidget {
  const RoutineChallengeTab({super.key, required this.groupId});

  final String groupId;

  Future<void> _create(BuildContext context, WidgetRef ref) async {
    await showRoutineChallengeFormSheet(context, groupId: groupId);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final challengesAsync = ref.watch(routineChallengesProvider(groupId));

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'challenge_create',
        onPressed: () => _create(context, ref),
        icon: const Icon(Icons.add),
        label: Text(l10n.routine_challenge_create),
      ),
      body: challengesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => AppErrorState(
          error: error,
          title: l10n.routine_error_generic,
          onRetry: () => ref.invalidate(routineChallengesProvider(groupId)),
        ),
        data: (challenges) {
          if (challenges.isEmpty) {
            return AppEmptyState(
              icon: Icons.emoji_events_outlined,
              message: l10n.routine_challenge_empty,
            );
          }

          // 진행 중 → 시작 전 → 종료 순으로 보여준다. 지금 신경 써야 할
          // 챌린지가 위로 오도록.
          final sorted = [...challenges]
            ..sort((a, b) {
              int rank(RoutineChallengeStatus s) => switch (s) {
                RoutineChallengeStatus.ongoing => 0,
                RoutineChallengeStatus.upcoming => 1,
                RoutineChallengeStatus.ended => 2,
              };
              final byStatus = rank(a.status).compareTo(rank(b.status));
              if (byStatus != 0) return byStatus;
              return b.startDate.compareTo(a.startDate);
            });

          return ListView.builder(
            padding: EdgeInsets.fromLTRB(
              AppSizes.spaceM,
              AppSizes.spaceM,
              AppSizes.spaceM,
              // FAB에 가리지 않도록 여유를 둔다.
              AppSizes.spaceXXL + MediaQuery.paddingOf(context).bottom,
            ),
            itemCount: sorted.length,
            itemBuilder: (context, index) =>
                _ChallengeCard(groupId: groupId, challenge: sorted[index]),
          );
        },
      ),
    );
  }
}

class _ChallengeCard extends ConsumerWidget {
  const _ChallengeCard({required this.groupId, required this.challenge});

  final String groupId;
  final RoutineChallenge challenge;

  Future<void> _join(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final routineId = await showRoutineChallengeRoutinePicker(context);
    if (routineId == null || !context.mounted) return;

    final ok = await ref
        .read(routineManagementProvider.notifier)
        .joinChallenge(groupId, challenge.id, routineId);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok ? l10n.routine_challenge_joined : l10n.routine_error_generic,
        ),
      ),
    );
  }

  Future<void> _leave(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(l10n.routine_challenge_leave_confirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.routine_challenge_leave),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final ok = await ref
        .read(routineManagementProvider.notifier)
        .leaveChallenge(groupId, challenge.id);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.routine_error_generic)));
    }
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(l10n.routine_challenge_delete_confirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              l10n.routine_delete,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final ok = await ref
        .read(routineManagementProvider.notifier)
        .deleteChallenge(groupId, challenge.id);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.routine_error_generic)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isEnded = challenge.status == RoutineChallengeStatus.ended;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.spaceM),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _StatusChip(status: challenge.status),
                const SizedBox(width: AppSizes.spaceS),
                Expanded(
                  child: Text(
                    challenge.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                if (challenge.isMine)
                  PopupMenuButton<String>(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.more_vert,
                      size: 18,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    onSelected: (value) {
                      if (value == 'edit') {
                        showRoutineChallengeFormSheet(
                          context,
                          groupId: groupId,
                          challenge: challenge,
                        );
                      } else if (value == 'delete') {
                        _delete(context, ref);
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Text(l10n.routine_edit),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text(l10n.routine_delete),
                      ),
                    ],
                  ),
              ],
            ),
            if (challenge.description != null &&
                challenge.description!.isNotEmpty) ...[
              const SizedBox(height: AppSizes.spaceXS),
              Text(
                challenge.description!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: AppSizes.spaceS),
            _MetaRow(challenge: challenge),
            if (challenge.reward != null && challenge.reward!.isNotEmpty) ...[
              const SizedBox(height: AppSizes.spaceS),
              Row(
                children: [
                  Icon(
                    Icons.card_giftcard_outlined,
                    size: 14,
                    color: AppColors.warning,
                  ),
                  const SizedBox(width: AppSizes.spaceXS),
                  Expanded(
                    child: Text(
                      challenge.reward!,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.warning,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            if (challenge.joined) ...[
              const SizedBox(height: AppSizes.spaceM),
              _MyProgress(challenge: challenge),
            ],
            const SizedBox(height: AppSizes.spaceS),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (challenge.joined)
                  TextButton(
                    onPressed: isEnded ? null : () => _leave(context, ref),
                    child: Text(l10n.routine_challenge_leave),
                  )
                else
                  FilledButton.tonal(
                    onPressed: isEnded ? null : () => _join(context, ref),
                    child: Text(l10n.routine_challenge_join),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 챌린지 상태 뱃지
class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final RoutineChallengeStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final (label, color) = switch (status) {
      RoutineChallengeStatus.upcoming => (
        l10n.routine_challenge_status_upcoming,
        Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      RoutineChallengeStatus.ongoing => (
        l10n.routine_challenge_status_ongoing,
        AppColors.success,
      ),
      RoutineChallengeStatus.ended => (
        l10n.routine_challenge_status_ended,
        Theme.of(context).colorScheme.outline,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceS,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// 기간·목표·참가자 수 요약 줄
class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.challenge});

  final RoutineChallenge challenge;

  static String _fmt(DateTime d) =>
      '${d.month.toString().padLeft(2, '0')}.${d.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final style = Theme.of(
      context,
    ).textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant);

    final daysLeft = challenge.endDate.difference(DateTime.now()).inDays;

    return Wrap(
      spacing: AppSizes.spaceM,
      runSpacing: AppSizes.spaceXS,
      children: [
        Text(
          '${_fmt(challenge.startDate)} ~ ${_fmt(challenge.endDate)}',
          style: style,
        ),
        Text(
          l10n.routine_challenge_field_target_desc(challenge.targetCount),
          style: style,
        ),
        Text(
          l10n.routine_challenge_participants(challenge.participantCount),
          style: style,
        ),
        if (challenge.status == RoutineChallengeStatus.ongoing && daysLeft >= 0)
          Text(
            l10n.routine_challenge_days_left(daysLeft),
            style: style?.copyWith(color: AppColors.warning),
          ),
      ],
    );
  }
}

/// 참가 중일 때 보여주는 내 진행률
class _MyProgress extends StatelessWidget {
  const _MyProgress({required this.challenge});

  final RoutineChallenge challenge;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final achieved = challenge.myAchieved;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (achieved) ...[
              Icon(Icons.emoji_events, size: 14, color: AppColors.warning),
              const SizedBox(width: AppSizes.spaceXS),
            ],
            Text(
              l10n.routine_challenge_progress(
                challenge.myCheckedCount ?? 0,
                challenge.targetCount,
              ),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: achieved ? AppColors.success : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.spaceXS),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          child: LinearProgressIndicator(
            value: challenge.myProgress,
            minHeight: 8,
            backgroundColor: colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation(
              achieved ? AppColors.success : colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
