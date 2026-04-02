import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/savings/data/models/savings_model.dart';
import 'package:family_planner/features/main/savings/presentation/screens/savings_detail_screen.dart';
import 'package:family_planner/features/main/savings/presentation/screens/savings_form_screen.dart';
import 'package:family_planner/features/main/savings/providers/savings_provider.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';

class SavingsListScreen extends ConsumerStatefulWidget {
  const SavingsListScreen({super.key});

  @override
  ConsumerState<SavingsListScreen> createState() => _SavingsListScreenState();
}

class _SavingsListScreenState extends ConsumerState<SavingsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initGroupSelection();
    });
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

  @override
  Widget build(BuildContext context) {
    final groupsAsync = ref.watch(myGroupsProvider);
    final selectedGroupId = ref.watch(savingsSelectedGroupIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('그룹 저금통'),
        actions: [
          if (selectedGroupId != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: '새로고침',
              onPressed: () {
                ref
                    .read(savingsGoalsProvider(selectedGroupId).notifier)
                    .refresh();
              },
            ),
        ],
      ),
      body: Column(
        children: [
          const _InfoBanner(),
          _GroupSelectorBar(
            groupsAsync: groupsAsync,
            selectedGroupId: selectedGroupId,
            onGroupChanged: (id) {
              ref.read(savingsSelectedGroupIdProvider.notifier).state = id;
            },
          ),
          if (selectedGroupId != null) ...[
            Expanded(
              child: _GoalsList(
                groupId: selectedGroupId,
              ),
            ),
          ] else
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
      floatingActionButton: selectedGroupId != null
          ? FloatingActionButton(
              onPressed: () async {
                final created = await Navigator.push<SavingsGoalModel>(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        SavingsFormScreen(groupId: selectedGroupId),
                  ),
                );
                if (created != null) {
                  ref
                      .read(savingsGoalsProvider(selectedGroupId).notifier)
                      .addGoal(created);
                }
              },
              child: const Icon(Icons.add),
            )
          : null,
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
  const _GoalCard({required this.goal, required this.onTap});

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
