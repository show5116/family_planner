import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/savings/data/models/savings_model.dart';
import 'package:family_planner/features/main/savings/presentation/screens/savings_detail_screen.dart';
import 'package:family_planner/features/main/savings/presentation/screens/savings_form_screen.dart';
import 'package:family_planner/features/main/savings/providers/savings_provider.dart';
import 'package:family_planner/features/onboarding/presentation/widgets/feature_coach_mark.dart';
import 'package:family_planner/features/onboarding/services/onboarding_service.dart';
import 'package:family_planner/shared/widgets/app_bar_more_menu.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';

// 온보딩용 가짜 저금통 데이터
final _demoGoals = [
  SavingsGoalModel(
    id: '__demo_1__',
    groupId: '__demo__',
    name: '제주도 여행',
    description: '올해 여름 가족 여행 목표',
    targetAmount: 1500000,
    currentAmount: 870000,
    autoDeposit: true,
    monthlyAmount: 150000,
    depositDay: 25,
    includeInAssets: false,
    status: SavingsGoalStatus.active,
    achievementRate: 58.0,
    createdAt: DateTime(2025, 1, 1),
    updatedAt: DateTime(2025, 5, 1),
  ),
  SavingsGoalModel(
    id: '__demo_2__',
    groupId: '__demo__',
    name: '비상금',
    description: null,
    targetAmount: 3000000,
    currentAmount: 1200000,
    autoDeposit: false,
    monthlyAmount: null,
    depositDay: 1,
    includeInAssets: false,
    status: SavingsGoalStatus.active,
    achievementRate: 40.0,
    createdAt: DateTime(2025, 1, 1),
    updatedAt: DateTime(2025, 5, 1),
  ),
];

class SavingsListScreen extends ConsumerStatefulWidget {
  const SavingsListScreen({super.key});

  @override
  ConsumerState<SavingsListScreen> createState() => _SavingsListScreenState();
}

class _SavingsListScreenState extends ConsumerState<SavingsListScreen> {
  // ValueNotifier: setState 없이 가짜 데이터 on/off — 코치마크 콜백 내 setState 충돌 방지
  final _onboardingGoals = ValueNotifier<List<SavingsGoalModel>?>( null);
  final _firstCardKey = GlobalKey();
  final _fabKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initGroupSelection();
      await _maybeStartOnboarding();
    });
  }

  @override
  void dispose() {
    _onboardingGoals.dispose();
    super.dispose();
  }

  Future<void> _initGroupSelection() async {
    final groupId = ref.read(savingsSelectedGroupIdProvider);
    if (groupId != null) return;
    final groups =
        await ref.read(myGroupsProvider.future).catchError((_) => <Group>[]);
    if (groups.isNotEmpty && mounted) {
      ref.read(savingsSelectedGroupIdProvider.notifier).state = groups.first.id;
    }
  }

  Future<void> _maybeStartOnboarding() async {
    final completed =
        await OnboardingService.isCoachMarkCompleted(CoachMarkKeys.savings);
    if (completed || !mounted) return;
    _startDemo();
  }

  void _replayOnboarding() {
    OnboardingService.resetCoachMark(CoachMarkKeys.savings).then((_) {
      if (mounted) _startDemo();
    });
  }

  void _startDemo() {
    _onboardingGoals.value = _demoGoals;
    WidgetsBinding.instance.addPostFrameCallback((_) => _showCoachMark());
  }

  void _goToDemo() {
    if (!mounted) return;
    _onboardingGoals.value = null;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SavingsDetailScreen.demo(demoGoal: _demoGoals.first),
      ),
    );
  }

  Future<void> _showCoachMark() async {
    if (!mounted) return;
    TutorialCoachMark(
      targets: [
        TargetFocus(
          identify: 'savings_card_info',
          keyTarget: _firstCardKey,
          shape: ShapeLightFocus.RRect,
          radius: 12,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              builder: (_, _) => FeatureCoachMark.buildContent(
                title: '저금통',
                description: '목표 이름, 현재 적립금, 달성률을 한눈에 확인할 수 있어요.\n자동 적립을 켜두면 매달 자동으로 입금돼요.',
                icon: Icons.savings_outlined,
                color: AppColors.investment,
              ),
            ),
          ],
        ),
      ],
      colorShadow: AppColors.textPrimary,
      opacityShadow: 0.85,
      textSkip: '건너뛰기',
      alignSkip: Alignment.topRight,
      skipWidget: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white30),
        ),
        child: const Text(
          '건너뛰기',
          style: TextStyle(
              color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ),
      // 카드 탭 또는 1단계 완료(onFinish) → 상세 화면으로 이동
      onClickTarget: (_) => _goToDemo(),
      onFinish: _goToDemo,
      onSkip: () {
        OnboardingService.completeCoachMark(CoachMarkKeys.savings);
        _onboardingGoals.value = null;
        return true;
      },
      paddingFocus: 8,
      focusAnimationDuration: const Duration(milliseconds: 300),
      pulseAnimationDuration: const Duration(milliseconds: 800),
    ).show(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final groupsAsync = ref.watch(myGroupsProvider);
    final selectedGroupId = ref.watch(savingsSelectedGroupIdProvider);

    return ValueListenableBuilder<List<SavingsGoalModel>?>(
      valueListenable: _onboardingGoals,
      builder: (context, demoGoals, _) {
        final isOnboarding = demoGoals != null;

        return Scaffold(
          appBar: AppBar(
            title: const Text('그룹 저금통'),
            actions: [
              if (selectedGroupId != null && !isOnboarding)
                IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: '새로고침',
                  onPressed: () {
                    ref
                        .read(savingsGoalsProvider(selectedGroupId).notifier)
                        .refresh();
                  },
                ),
              AppBarMoreMenu(onReplayOnboarding: _replayOnboarding),
            ],
          ),
          body: Column(
            children: [
              const _InfoBanner(),
              if (!isOnboarding)
                _GroupSelectorBar(
                  groupsAsync: groupsAsync,
                  selectedGroupId: selectedGroupId,
                  onGroupChanged: (id) {
                    ref.read(savingsSelectedGroupIdProvider.notifier).state = id;
                  },
                ),
              if (isOnboarding)
                Expanded(
                  child: _OnboardingGoalsList(
                    goals: demoGoals,
                    firstCardKey: _firstCardKey,
                  ),
                )
              else if (selectedGroupId != null)
                Expanded(child: _GoalsList(groupId: selectedGroupId))
              else
                const Expanded(
                  child: Center(
                    child: Text(
                      '그룹을 선택해 주세요',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                ),
            ],
          ),
          floatingActionButton: (isOnboarding || selectedGroupId != null)
              ? FloatingActionButton(
                  key: _fabKey,
                  onPressed: isOnboarding
                      ? null
                      : () async {
                          final created = await Navigator.push<SavingsGoalModel>(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  SavingsFormScreen(groupId: selectedGroupId!),
                            ),
                          );
                          if (created != null) {
                            ref
                                .read(savingsGoalsProvider(selectedGroupId!)
                                    .notifier)
                                .addGoal(created);
                          }
                        },
                  child: const Icon(Icons.add),
                )
              : null,
        );
      },
    );
  }
}

// ── 안내 배너 ─────────────────────────────────────────────────────────────────

class _InfoBanner extends StatefulWidget {
  const _InfoBanner();

  @override
  State<_InfoBanner> createState() => _InfoBannerState();
}

class _InfoBannerState extends State<_InfoBanner> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spaceM,
          vertical: AppSizes.spaceM,
        ),
        color: AppColors.investment.withAlpha(15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.savings_outlined, color: AppColors.investment, size: 20),
            const SizedBox(width: AppSizes.spaceS),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '그룹과 함께 목표를 정해 돈을 모아요',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.investment,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (_expanded) ...[
                    const SizedBox(height: AppSizes.spaceXS),
                    Text(
                      '여행 경비, 비상금, 가전 구매 등 원하는 목표를 만들고 매달 자동으로 적립하거나 수동으로 입금할 수 있어요.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.investment.withAlpha(180),
                      ),
                    ),
                    const SizedBox(height: AppSizes.spaceXS),
                    Text(
                      '💡 가족 외에도 친구, 동료 등 그룹이라면 누구든 "계" 처럼 활용할 수 있어요.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.investment.withAlpha(180),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              _expanded ? Icons.expand_less : Icons.expand_more,
              color: AppColors.investment,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// ── 그룹 선택 바 ──────────────────────────────────────────────────────────────

class _GroupSelectorBar extends StatelessWidget {
  const _GroupSelectorBar({
    required this.groupsAsync,
    required this.selectedGroupId,
    required this.onGroupChanged,
  });

  final AsyncValue<List<Group>> groupsAsync;
  final String? selectedGroupId;
  final ValueChanged<String?> onGroupChanged;

  @override
  Widget build(BuildContext context) {
    return groupsAsync.when(
      loading: () => const LinearProgressIndicator(),
      error: (_, _) => const SizedBox.shrink(),
      data: (groups) {
        if (groups.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spaceM,
            vertical: AppSizes.spaceS,
          ),
          child: DropdownButtonFormField<String>(
            initialValue: selectedGroupId,
            decoration: const InputDecoration(
              labelText: '그룹 선택',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSizes.spaceM,
                vertical: AppSizes.spaceS,
              ),
            ),
            items: groups
                .map((g) => DropdownMenuItem(value: g.id, child: Text(g.name)))
                .toList(),
            onChanged: onGroupChanged,
          ),
        );
      },
    );
  }
}

// ── 목표 목록 ─────────────────────────────────────────────────────────────────

class _GoalsList extends ConsumerWidget {
  const _GoalsList({required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(savingsGoalsProvider(groupId));

    return goalsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline,
                size: AppSizes.iconXLarge, color: AppColors.error),
            const SizedBox(height: AppSizes.spaceM),
            Text('오류가 발생했습니다\n$e',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: AppSizes.spaceM),
            TextButton(
              onPressed: () =>
                  ref.read(savingsGoalsProvider(groupId).notifier).refresh(),
              child: const Text('다시 시도'),
            ),
          ],
        ),
      ),
      data: (goals) {
        if (goals.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.savings_outlined,
                    size: AppSizes.iconXLarge, color: AppColors.textSecondary),
                const SizedBox(height: AppSizes.spaceM),
                const Text(
                  '저금통이 없습니다\n+ 버튼을 눌러 저금통을 추가하세요',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          );
        }

        final filtered = goals;

        return RefreshIndicator(
          onRefresh: () =>
              ref.read(savingsGoalsProvider(groupId).notifier).refresh(),
          child: ListView.separated(
            padding: const EdgeInsets.all(AppSizes.spaceM),
            itemCount: filtered.length,
            separatorBuilder: (_, _) =>
                const SizedBox(height: AppSizes.spaceS),
            itemBuilder: (context, index) {
              return _GoalCard(
                goal: filtered[index],
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          SavingsDetailScreen(goalId: filtered[index].id),
                    ),
                  );
                  ref
                      .read(savingsGoalsProvider(groupId).notifier)
                      .refresh();
                },
              );
            },
          ),
        );
      },
    );
  }
}

// ── 목표 카드 ─────────────────────────────────────────────────────────────────

class _GoalCard extends StatelessWidget {
  const _GoalCard({super.key, required this.goal, required this.onTap});

  final SavingsGoalModel goal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: AppSizes.elevation1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      goal.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.investment,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  _StatusBadge(status: goal.status),
                ],
              ),
              if (goal.description != null && goal.description!.isNotEmpty) ...[
                const SizedBox(height: AppSizes.spaceXS),
                Text(
                  goal.description!,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: AppColors.textSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: AppSizes.spaceS),
              Row(
                children: [
                  Text(
                    _formatAmount(goal.currentAmount),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (goal.targetAmount != null) ...[
                    Text(
                      ' / ${_formatAmount(goal.targetAmount!)}',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ],
              ),
              if (goal.targetAmount != null) ...[
                const SizedBox(height: AppSizes.spaceS),
                LinearProgressIndicator(
                  value: (goal.achievementRate / 100).clamp(0.0, 1.0),
                  backgroundColor: AppColors.primaryLight,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(AppColors.investment),
                  borderRadius:
                      BorderRadius.circular(AppSizes.radiusSmall),
                ),
                const SizedBox(height: AppSizes.spaceXS),
                Text(
                  '${goal.achievementRate.toStringAsFixed(1)}% 달성',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatAmount(double amount) {
    final intAmount = amount.toInt();
    final formatted = intAmount
        .toString()
        .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},');
    return '$formatted원';
  }
}

// ── 온보딩 전용 목록 (가짜 데이터, 탭 불가) ──────────────────────────────────

class _OnboardingGoalsList extends StatelessWidget {
  const _OnboardingGoalsList({
    required this.goals,
    required this.firstCardKey,
  });

  final List<SavingsGoalModel> goals;
  final GlobalKey firstCardKey;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSizes.spaceM),
      itemCount: goals.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSizes.spaceS),
      itemBuilder: (context, index) {
        return _GoalCard(
          key: index == 0 ? firstCardKey : null,
          goal: goals[index],
          onTap: () {},
        );
      },
    );
  }
}

// ── 상태 뱃지 ─────────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final SavingsGoalStatus status;

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case SavingsGoalStatus.active:
        color = AppColors.success;
      case SavingsGoalStatus.paused:
        color = AppColors.warning;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceS,
        vertical: AppSizes.spaceXS,
      ),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        border: Border.all(color: color.withAlpha(100)),
      ),
      child: Text(
        status.toDisplayString(),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
