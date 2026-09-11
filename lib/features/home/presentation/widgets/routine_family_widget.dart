import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/providers/dashboard_widget_settings_provider.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/auth/providers/auth_provider.dart';
import 'package:family_planner/features/home/presentation/widgets/dashboard_error_state.dart';
import 'package:family_planner/features/main/routine/data/models/routine_model.dart';
import 'package:family_planner/features/main/routine/providers/routine_provider.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/shared/widgets/dashboard_card.dart';

/// 한 번에 노출할 그룹원 수
const _kMemberLimit = 4;

/// 홈 대시보드 - 가족 루틴 보드 위젯.
///
/// 그룹원별 오늘 진행률 + 진행 중인 챌린지를 한 카드에 모아, 루틴 탭
/// 3뎁스 안쪽에 있던 공유/챌린지 기능을 대시보드로 끌어올린다.
class RoutineFamilyWidget extends ConsumerStatefulWidget {
  const RoutineFamilyWidget({super.key, this.initialSelectedGroupId});

  /// null이면 첫 번째 그룹을 자동 선택한다.
  final String? initialSelectedGroupId;

  @override
  ConsumerState<RoutineFamilyWidget> createState() =>
      _RoutineFamilyWidgetState();
}

class _RoutineFamilyWidgetState extends ConsumerState<RoutineFamilyWidget> {
  String? _selectedGroupId;

  @override
  void initState() {
    super.initState();
    _selectedGroupId = widget.initialSelectedGroupId;
  }

  @override
  void didUpdateWidget(RoutineFamilyWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialSelectedGroupId != oldWidget.initialSelectedGroupId) {
      _selectedGroupId = widget.initialSelectedGroupId;
    }
  }

  /// 선택된 그룹이 삭제/탈퇴로 사라졌을 수 있어 항상 실제 목록에서 되짚는다.
  Group? _effectiveGroup(List<Group> groups) {
    if (groups.isEmpty) return null;
    if (_selectedGroupId == null) return groups.first;
    return groups.firstWhere(
      (g) => g.id == _selectedGroupId,
      orElse: () => groups.first,
    );
  }

  Future<void> _saveFilter(String groupId) async {
    final current = ref.read(dashboardWidgetSettingsProvider).valueOrNull;
    if (current == null) return;
    await ref
        .read(dashboardWidgetSettingsProvider.notifier)
        .save(current.copyWith(routineFamilySelectedGroupId: groupId));
  }

  Future<void> _showGroupPicker(List<Group> groups, String? selectedId) async {
    await showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusMedium),
        ),
      ),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: groups
              .map(
                (group) => ListTile(
                  title: Text(group.name),
                  trailing: group.id == selectedId
                      ? Icon(
                          Icons.check,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : null,
                  onTap: () {
                    setState(() => _selectedGroupId = group.id);
                    _saveFilter(group.id);
                    Navigator.pop(sheetContext);
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final groups = ref.watch(myGroupsProvider).valueOrNull ?? [];
    final group = _effectiveGroup(groups);

    return DashboardCard(
      title: l10n.widgetSettings_routineFamily,
      icon: Icons.groups_outlined,
      onTap: () => context.push(AppRoutes.routineTogether),
      action: groups.length > 1
          ? IconButton(
              iconSize: AppSizes.iconSmall,
              visualDensity: VisualDensity.compact,
              tooltip: l10n.routineWidget_groupTooltip,
              icon: Icon(
                Icons.tune,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              onPressed: () => _showGroupPicker(groups, group?.id),
            )
          : null,
      child: group == null
          ? _MessageState(message: l10n.routineWidget_familyNoGroup)
          : _FamilyBoard(groupId: group.id),
    );
  }
}

class _FamilyBoard extends ConsumerWidget {
  const _FamilyBoard({required this.groupId});

  final String groupId;

  /// 오늘 체크한 습관 수 / 대상 습관 수. 일시정지·종료된 습관은 제외한다.
  ({int checked, int total}) _todayProgress(RoutineGroupMemberRoutines member) {
    final active = member.routines
        .where((r) => r.status == RoutineStatus.active)
        .toList();
    return (
      checked: active.where((r) => r.checkedToday).length,
      total: active.length,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final membersAsync = ref.watch(routineGroupMembersProvider(groupId));

    if (membersAsync.hasError) {
      return DashboardErrorState(
        onRetry: () => ref.invalidate(routineGroupMembersProvider(groupId)),
      );
    }
    final members = membersAsync.valueOrNull;
    if (members == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.spaceM),
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (members.isEmpty) {
      return _ShareCta(message: l10n.routineWidget_familyEmpty);
    }

    // 오늘 진행률이 높은 순으로 정렬해 순위를 매긴다.
    final ranked = [...members];
    ranked.sort((a, b) {
      final pa = _todayProgress(a);
      final pb = _todayProgress(b);
      final ra = pa.total == 0 ? 0.0 : pa.checked / pa.total;
      final rb = pb.total == 0 ? 0.0 : pb.checked / pb.total;
      return rb.compareTo(ra);
    });

    final myUserId = ref.watch(authProvider).userId;
    final myIndex = ranked.indexWhere((m) => m.userId == myUserId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (myIndex >= 0)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.spaceS),
            child: Text(
              l10n.routineWidget_familyRank(myIndex + 1),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ...ranked.take(_kMemberLimit).map((member) {
          final progress = _todayProgress(member);
          return _MemberRow(
            name: member.userName,
            checked: progress.checked,
            total: progress.total,
            isMe: member.userId == myUserId,
          );
        }),
        if (ranked.length > _kMemberLimit)
          Padding(
            padding: const EdgeInsets.only(top: AppSizes.spaceXS),
            child: Text(
              l10n.routineWidget_moreCount(ranked.length - _kMemberLimit),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
        _ChallengeFooter(groupId: groupId),
      ],
    );
  }
}

class _MemberRow extends StatelessWidget {
  const _MemberRow({
    required this.name,
    required this.checked,
    required this.total,
    required this.isMe,
  });

  final String name;
  final int checked;
  final int total;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final ratio = total == 0 ? 0.0 : (checked / total).clamp(0.0, 1.0);
    final isComplete = total > 0 && checked == total;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.spaceS),
      child: Row(
        children: [
          SizedBox(
            width: 64,
            child: Text(
              name,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: isMe ? FontWeight.bold : FontWeight.normal,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: AppSizes.spaceS),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              child: LinearProgressIndicator(
                value: ratio,
                minHeight: AppSizes.spaceS,
                backgroundColor: colorScheme.surfaceContainerHighest,
                color: isComplete ? AppColors.success : colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(width: AppSizes.spaceS),
          Text(
            '$checked/$total',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}

/// 진행 중인 챌린지 한 건 요약.
///
/// 선택된 그룹이 아니라 **내가 속한 모든 그룹**을 대상으로 한다
/// (`GET /routines/challenges/me`). 마감이 임박한 챌린지가 다른 그룹에 있으면
/// 그룹을 바꿔보기 전까지 모르는 문제를 막기 위해서다.
class _ChallengeFooter extends ConsumerWidget {
  const _ChallengeFooter({required this.groupId});

  /// 현재 보고 있는 그룹. 다른 그룹의 챌린지면 그룹명을 함께 보여주기 위해 쓴다.
  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    // 챌린지는 부가 정보라 로딩/에러 시 조용히 생략한다.
    final challenges = ref.watch(routineMyChallengesProvider).valueOrNull;
    if (challenges == null) return const SizedBox.shrink();

    final ongoing = challenges
        .where((c) => c.status == RoutineChallengeStatus.ongoing)
        .toList();
    if (ongoing.isEmpty) return const SizedBox.shrink();

    // 참여 중인 챌린지가 있으면 그것을, 없으면 가장 먼저 끝나는 것을 보여준다.
    // (서버가 이미 마감 임박순으로 주지만 참여 여부는 클라이언트 기준이다)
    ongoing.sort((a, b) {
      if (a.joined != b.joined) return a.joined ? -1 : 1;
      return a.endDate.compareTo(b.endDate);
    });
    final challenge = ongoing.first;

    // 지금 보고 있는 그룹의 챌린지가 아니면 어디 것인지 밝힌다.
    final isOtherGroup =
        challenge.groupId != null && challenge.groupId != groupId;
    final challengeLabel =
        isOtherGroup && (challenge.groupName?.isNotEmpty ?? false)
        ? l10n.routineWidget_challengeGroup(
            challenge.groupName!,
            challenge.title,
          )
        : challenge.title;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final endDay = DateTime(
      challenge.endDate.year,
      challenge.endDate.month,
      challenge.endDate.day,
    );
    final daysLeft = endDay.difference(today).inDays;

    return Padding(
      padding: const EdgeInsets.only(top: AppSizes.spaceS),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(height: AppSizes.spaceM, color: Theme.of(context).dividerColor),
          Row(
            children: [
              const Text('🏆'),
              const SizedBox(width: AppSizes.spaceXS),
              Expanded(
                child: Text(
                  challengeLabel,
                  style: Theme.of(context).textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                daysLeft <= 0
                    ? l10n.routineWidget_challengeLastDay
                    : l10n.routineWidget_challengeDday(daysLeft),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: daysLeft <= 1
                          ? AppColors.warning
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          if (challenge.joined && challenge.myCheckedCount != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSizes.spaceXS),
              child: Text(
                l10n.routineWidget_myChallengeProgress(
                  challenge.myCheckedCount!,
                  challenge.targetCount,
                ),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: challenge.myAchieved
                          ? AppColors.success
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
        ],
      ),
    );
  }
}

/// 공유된 루틴이 없을 때 빈 카드 대신 공유 설정으로 유도한다.
class _ShareCta extends StatelessWidget {
  const _ShareCta({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceS),
      child: Column(
        children: [
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: AppSizes.spaceS),
          TextButton.icon(
            icon: const Icon(Icons.share_outlined, size: AppSizes.iconSmall),
            label: Text(l10n.routineWidget_familyShareCta),
            onPressed: () => context.push(AppRoutes.routineShareSettings),
          ),
        ],
      ),
    );
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceM),
      child: Center(
        child: Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ),
    );
  }
}
