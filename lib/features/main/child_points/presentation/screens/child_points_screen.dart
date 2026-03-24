import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/main/child_points/data/models/childcare_model.dart';
import 'package:family_planner/features/main/child_points/data/repositories/childcare_repository.dart';
import 'package:family_planner/features/main/child_points/presentation/widgets/account_summary_card.dart';
import 'package:family_planner/features/main/child_points/presentation/widgets/reward_list_item.dart';
import 'package:family_planner/features/main/child_points/presentation/widgets/rule_list_item.dart';
import 'package:family_planner/features/main/child_points/presentation/widgets/transaction_list_item.dart';
import 'package:family_planner/features/main/child_points/providers/childcare_provider.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/ai_chat/presentation/widgets/ai_chat_icon_button.dart';
import 'package:family_planner/shared/widgets/app_empty_state.dart';

/// 육아포인트 메인 화면
class ChildPointsScreen extends ConsumerStatefulWidget {
  const ChildPointsScreen({super.key});

  @override
  ConsumerState<ChildPointsScreen> createState() => _ChildPointsScreenState();
}

class _ChildPointsScreenState extends ConsumerState<ChildPointsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initGroupSelection();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _initGroupSelection() async {
    final groupId = ref.read(childcareSelectedGroupIdProvider);
    if (groupId != null) return;

    final groups =
        await ref.read(myGroupsProvider.future).catchError((_) => <Group>[]);
    if (groups.isNotEmpty && mounted) {
      ref.read(childcareSelectedGroupIdProvider.notifier).state =
          groups.first.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final groupsAsync = ref.watch(myGroupsProvider);
    final selectedGroupId = ref.watch(childcareSelectedGroupIdProvider);
    final selectedChildId = ref.watch(childcareSelectedChildIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.childcare_title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          const AiChatIconButton(),
          // 자녀별 메뉴 (용돈 플랜, 계정 연동)
          if (selectedChildId != null)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'allowance') {
                  context.push(
                    AppRoutes.childPointsAllowancePlan,
                    extra: {'childId': selectedChildId},
                  );
                } else if (value == 'link') {
                  context.push(
                    AppRoutes.childPointsLinkUser,
                    extra: {'childId': selectedChildId},
                  );
                }
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: 'allowance',
                  child: ListTile(
                    leading: Icon(Icons.monetization_on_outlined),
                    title: Text('용돈 플랜 설정'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'link',
                  child: ListTile(
                    leading: Icon(Icons.link),
                    title: Text('앱 계정 연동'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          // 자녀 추가
          if (selectedGroupId != null)
            IconButton(
              icon: const Icon(Icons.person_add_outlined),
              tooltip: '자녀 등록',
              onPressed: () => context.push(
                AppRoutes.childPointsChildProfileForm,
                extra: {'groupId': selectedGroupId},
              ),
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: [
            Tab(text: l10n.childcare_tab_points),
            Tab(text: l10n.childcare_tab_rewards),
            Tab(text: l10n.childcare_tab_rules),
            Tab(text: l10n.childcare_tab_history),
          ],
        ),
      ),
      body: Column(
        children: [
          _GroupAndChildBar(
            groupsAsync: groupsAsync,
            selectedGroupId: selectedGroupId,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _PointsTab(selectedChildId: selectedChildId),
                _RewardsTab(),
                _RulesTab(),
                _HistoryTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── 그룹 + 자녀 선택 바 ──────────────────────────────────────────────────────

class _GroupAndChildBar extends ConsumerWidget {
  final AsyncValue<List<Group>> groupsAsync;
  final String? selectedGroupId;

  const _GroupAndChildBar({
    required this.groupsAsync,
    required this.selectedGroupId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final childrenAsync = ref.watch(childcareChildrenProvider);
    final selectedChildId = ref.watch(childcareSelectedChildIdProvider);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceM,
        vertical: AppSizes.spaceS,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // 그룹 선택
          const Icon(Icons.group, size: AppSizes.iconSmall),
          const SizedBox(width: AppSizes.spaceXS),
          groupsAsync.when(
            data: (groups) {
              if (groups.isEmpty) {
                return Text(l10n.childcare_no_group,
                    style: Theme.of(context).textTheme.bodySmall);
              }
              return DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedGroupId ?? groups.first.id,
                  isDense: true,
                  items: groups
                      .map<DropdownMenuItem<String>>(
                        (g) => DropdownMenuItem<String>(
                          value: g.id,
                          child: Text(g.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    ref
                        .read(childcareSelectedGroupIdProvider.notifier)
                        .state = value;
                    ref
                        .read(childcareSelectedChildIdProvider.notifier)
                        .state = null;
                  },
                ),
              );
            },
            loading: () => const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            error: (_, _) => Text(l10n.childcare_select_group),
          ),
          // 자녀 선택
          if (selectedGroupId != null)
            childrenAsync.when(
              data: (children) {
                if (children.isEmpty) return const SizedBox.shrink();

                if (selectedChildId == null && children.isNotEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ref
                        .read(childcareSelectedChildIdProvider.notifier)
                        .state = children.first.id;
                  });
                }

                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: AppSizes.spaceS),
                    Container(
                      width: 1,
                      height: 16,
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                    const SizedBox(width: AppSizes.spaceS),
                    const Icon(Icons.child_care, size: AppSizes.iconSmall),
                    const SizedBox(width: AppSizes.spaceXS),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedChildId ?? children.first.id,
                        isDense: true,
                        items: children.map<DropdownMenuItem<String>>((c) {
                          return DropdownMenuItem<String>(
                            value: c.id,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(c.name),
                                if (c.userId != null) ...[
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.link,
                                    size: 14,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary,
                                  ),
                                ],
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          ref
                              .read(childcareSelectedChildIdProvider.notifier)
                              .state = value;
                        },
                      ),
                    ),
                  ],
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),
        ],
      ),
    );
  }
}

// ── 포인트 탭 ────────────────────────────────────────────────────────────────

class _PointsTab extends ConsumerWidget {
  final String? selectedChildId;

  const _PointsTab({required this.selectedChildId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final account = ref.watch(selectedChildAccountProvider);
    final accountsAsync = ref.watch(childcareAccountsProvider);
    final planAsync = ref.watch(childcareAllowancePlanProvider);

    if (selectedChildId == null) {
      return Center(child: Text(l10n.childcare_no_child));
    }

    return accountsAsync.when(
      data: (_) {
        if (account == null) {
          return AppEmptyState(
            icon: Icons.child_care,
            message: l10n.childcare_empty_accounts,
          );
        }

        final plan = planAsync.maybeWhen(
          data: (p) => p,
          orElse: () => null,
        );

        return RefreshIndicator(
          onRefresh: () => ref.read(childcareAccountsProvider.notifier).refresh(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppSizes.spaceM),
            child: Column(
              children: [
                AccountSummaryCard(
                  account: account,
                  plan: plan,
                  onAddTransaction: () => context.push(
                    AppRoutes.childPointsTransactionAdd,
                    extra: {'accountId': account.id},
                  ),
                  onDepositSavings: () => _showSavingsDialog(
                    context,
                    ref,
                    account,
                    isDeposit: true,
                  ),
                  onWithdrawSavings: () => _showSavingsDialog(
                    context,
                    ref,
                    account,
                    isDeposit: false,
                  ),
                ),
                // 용돈 플랜 미설정 안내
                if (plan == null) ...[
                  const SizedBox(height: AppSizes.spaceM),
                  _AllowancePlanBanner(childId: selectedChildId!),
                ],
                // 연봉 협상일 알림
                if (plan != null &&
                    plan.nextNegotiationDate != null) ...[
                  const SizedBox(height: AppSizes.spaceM),
                  _NegotiationDateBanner(
                    childId: selectedChildId!,
                    negotiationDate: plan.nextNegotiationDate!,
                  ),
                ],
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(l10n.childcare_empty_accounts),
            const SizedBox(height: AppSizes.spaceS),
            ElevatedButton(
              onPressed: () =>
                  ref.read(childcareAccountsProvider.notifier).refresh(),
              child: const Text('다시 시도'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showSavingsDialog(
    BuildContext context,
    WidgetRef ref,
    ChildcareAccount account, {
    required bool isDeposit,
  }) async {
    final controller = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isDeposit ? '적금 입금' : '적금 출금'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: '금액', suffixText: 'P'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(isDeposit ? '입금' : '출금'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final amount = double.tryParse(controller.text);
    if (amount == null || amount <= 0) return;

    final dto = SavingsAmountDto(amount: amount);
    final notifier = ref.read(childcareManagementProvider.notifier);

    final result = isDeposit
        ? await notifier.savingsDeposit(account.id, dto)
        : await notifier.savingsWithdraw(account.id, dto);

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result != null ? '완료되었습니다' : '오류가 발생했습니다')),
    );
  }
}

/// 용돈 플랜 미설정 시 안내 배너
class _AllowancePlanBanner extends StatelessWidget {
  const _AllowancePlanBanner({required this.childId});

  final String childId;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: ListTile(
        leading: const Icon(Icons.monetization_on_outlined),
        title: const Text('용돈 플랜이 설정되지 않았습니다'),
        subtitle: const Text('월 포인트, 지급일 등을 설정해보세요'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push(
          AppRoutes.childPointsAllowancePlan,
          extra: {'childId': childId},
        ),
      ),
    );
  }
}

/// 연봉 협상일 알림 배너 (D-7 이내 또는 지난 경우)
class _NegotiationDateBanner extends StatelessWidget {
  const _NegotiationDateBanner({
    required this.childId,
    required this.negotiationDate,
  });

  final String childId;
  final DateTime negotiationDate;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final diff = negotiationDate.difference(DateTime(today.year, today.month, today.day)).inDays;

    final bool isOverdue = diff < 0;
    final bool isUpcoming = diff >= 0 && diff <= 7;

    if (!isOverdue && !isUpcoming) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;
    final color = isOverdue ? colorScheme.errorContainer : colorScheme.tertiaryContainer;
    final onColor = isOverdue ? colorScheme.onErrorContainer : colorScheme.onTertiaryContainer;

    final String title = isOverdue ? '연봉 협상일이 지났습니다' : '연봉 협상일이 다가오고 있습니다';
    final String subtitle = isOverdue
        ? '${-diff}일 전 (${_fmt(negotiationDate)})이었습니다. 용돈 플랜을 검토해보세요'
        : diff == 0
            ? '오늘이 연봉 협상일입니다! (${_fmt(negotiationDate)})'
            : 'D-$diff · ${_fmt(negotiationDate)}';

    return Card(
      color: color,
      child: ListTile(
        leading: Icon(
          isOverdue ? Icons.warning_amber_rounded : Icons.notifications_active_outlined,
          color: onColor,
        ),
        title: Text(title, style: TextStyle(color: onColor, fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: TextStyle(color: onColor)),
        trailing: Icon(Icons.chevron_right, color: onColor),
        onTap: () => context.push(
          AppRoutes.childPointsAllowancePlan,
          extra: {'childId': childId},
        ),
      ),
    );
  }

  String _fmt(DateTime d) => '${d.year}.${d.month.toString().padLeft(2, '0')}.${d.day.toString().padLeft(2, '0')}';
}

// ── 보상 탭 ──────────────────────────────────────────────────────────────────

class _RewardsTab extends ConsumerWidget {
  const _RewardsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final account = ref.watch(selectedChildAccountProvider);
    final rewardsAsync = ref.watch(childcareRewardsProvider);

    if (account == null) {
      return Center(child: Text(l10n.childcare_no_child));
    }

    return Scaffold(
      body: rewardsAsync.when(
        data: (rewards) {
          if (rewards.isEmpty) {
            return AppEmptyState(
              icon: Icons.card_giftcard,
              message: l10n.childcare_empty_rewards,
            );
          }
          return RefreshIndicator(
            onRefresh: () =>
                ref.read(childcareRewardsProvider.notifier).refresh(),
            child: ListView.separated(
              itemCount: rewards.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final reward = rewards[index];
                return RewardListItem(
                  reward: reward,
                  onEdit: () => _showRewardForm(context, ref,
                      accountId: account.id, reward: reward),
                  onDelete: () =>
                      _confirmDeleteReward(context, ref, account.id, reward),
                  onToggleActive: () => ref
                      .read(childcareManagementProvider.notifier)
                      .updateReward(
                        account.id,
                        reward.id,
                        UpdateRewardDto(isActive: !reward.isActive),
                      ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(l10n.childcare_empty_rewards)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showRewardForm(context, ref, accountId: account.id),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showRewardForm(
    BuildContext context,
    WidgetRef ref, {
    required String accountId,
    ChildcareReward? reward,
  }) async {
    final nameController = TextEditingController(text: reward?.name ?? '');
    final descController =
        TextEditingController(text: reward?.description ?? '');
    final pointsController = TextEditingController(
      text: reward != null ? reward.points.toInt().toString() : '',
    );

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(reward == null ? '보상 추가' : '보상 수정'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: '보상 이름'),
              autofocus: true,
            ),
            const SizedBox(height: AppSizes.spaceS),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: '설명 (선택)'),
            ),
            const SizedBox(height: AppSizes.spaceS),
            TextField(
              controller: pointsController,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: '포인트 비용', suffixText: 'P'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(reward == null ? '추가' : '저장'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final name = nameController.text.trim();
    final points = double.tryParse(pointsController.text);
    if (name.isEmpty || points == null || points <= 0) return;

    final notifier = ref.read(childcareManagementProvider.notifier);
    final desc = descController.text.trim().isEmpty
        ? null
        : descController.text.trim();

    if (reward == null) {
      await notifier.addReward(
          accountId, CreateRewardDto(name: name, description: desc, points: points));
    } else {
      await notifier.updateReward(
          accountId,
          reward.id,
          UpdateRewardDto(name: name, description: desc, points: points));
    }

    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('저장되었습니다')));
  }

  Future<void> _confirmDeleteReward(
    BuildContext context,
    WidgetRef ref,
    String accountId,
    ChildcareReward reward,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('보상 삭제'),
        content: Text('"${reward.name}"을(를) 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await ref
        .read(childcareManagementProvider.notifier)
        .deleteReward(accountId, reward.id);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('삭제되었습니다')));
  }
}

// ── 규칙 탭 ──────────────────────────────────────────────────────────────────

class _RulesTab extends ConsumerWidget {
  const _RulesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final account = ref.watch(selectedChildAccountProvider);
    final rulesAsync = ref.watch(childcareRulesProvider);

    if (account == null) {
      return Center(child: Text(l10n.childcare_no_child));
    }

    return Scaffold(
      body: rulesAsync.when(
        data: (rules) {
          if (rules.isEmpty) {
            return AppEmptyState(
              icon: Icons.rule_rounded,
              message: l10n.childcare_empty_rules,
            );
          }
          return RefreshIndicator(
            onRefresh: () =>
                ref.read(childcareRulesProvider.notifier).refresh(),
            child: ListView.separated(
              itemCount: rules.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final rule = rules[index];
                return RuleListItem(
                  rule: rule,
                  onEdit: () => _showRuleForm(context, ref,
                      accountId: account.id, rule: rule),
                  onDelete: () =>
                      _confirmDeleteRule(context, ref, account.id, rule),
                  onToggleActive: () => ref
                      .read(childcareManagementProvider.notifier)
                      .updateRule(
                        account.id,
                        rule.id,
                        UpdateRuleDto(isActive: !rule.isActive),
                      ),
                  onApplyPenalty: () =>
                      _applyPenalty(context, ref, account.id, rule),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(l10n.childcare_empty_rules)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showRuleForm(context, ref, accountId: account.id),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showRuleForm(
    BuildContext context,
    WidgetRef ref, {
    required String accountId,
    ChildcareRule? rule,
  }) async {
    final nameController = TextEditingController(text: rule?.name ?? '');
    final descController =
        TextEditingController(text: rule?.description ?? '');
    final penaltyController = TextEditingController(
      text: rule != null ? rule.penalty.toInt().toString() : '',
    );

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(rule == null ? '규칙 추가' : '규칙 수정'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: '규칙 이름'),
              autofocus: true,
            ),
            const SizedBox(height: AppSizes.spaceS),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: '설명 (선택)'),
            ),
            const SizedBox(height: AppSizes.spaceS),
            TextField(
              controller: penaltyController,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: '차감 포인트', suffixText: 'P'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(rule == null ? '추가' : '저장'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final name = nameController.text.trim();
    final penalty = double.tryParse(penaltyController.text);
    if (name.isEmpty || penalty == null || penalty <= 0) return;

    final notifier = ref.read(childcareManagementProvider.notifier);
    final desc = descController.text.trim().isEmpty
        ? null
        : descController.text.trim();

    if (rule == null) {
      await notifier.addRule(
          accountId, CreateRuleDto(name: name, description: desc, penalty: penalty));
    } else {
      await notifier.updateRule(
          accountId,
          rule.id,
          UpdateRuleDto(name: name, description: desc, penalty: penalty));
    }

    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('저장되었습니다')));
  }

  Future<void> _applyPenalty(
    BuildContext context,
    WidgetRef ref,
    String accountId,
    ChildcareRule rule,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('규칙 위반 적용'),
        content:
            Text('"${rule.name}" 위반으로 ${rule.penalty.toInt()}P를 차감합니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('차감'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    await ref.read(childcareManagementProvider.notifier).addTransaction(
          accountId,
          CreateTransactionDto(
            type: ChildcareTransactionType.penalty,
            amount: rule.penalty,
            description: '규칙 위반: ${rule.name}',
          ),
        );

    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('차감되었습니다')));
  }

  Future<void> _confirmDeleteRule(
    BuildContext context,
    WidgetRef ref,
    String accountId,
    ChildcareRule rule,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('규칙 삭제'),
        content: Text('"${rule.name}"을(를) 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await ref
        .read(childcareManagementProvider.notifier)
        .deleteRule(accountId, rule.id);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('삭제되었습니다')));
  }
}

// ── 히스토리 탭 ───────────────────────────────────────────────────────────────

class _HistoryTab extends ConsumerWidget {
  const _HistoryTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final account = ref.watch(selectedChildAccountProvider);
    final selectedMonth = ref.watch(childcareSelectedMonthProvider);
    final transactionsAsync = ref.watch(childcareTransactionsProvider);

    if (account == null) {
      return Center(child: Text(l10n.childcare_no_child));
    }

    return Column(
      children: [
        // 월 이동 바
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spaceM,
            vertical: AppSizes.spaceXS,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => _changeMonth(ref, selectedMonth, -1),
                icon: const Icon(Icons.chevron_left),
                visualDensity: VisualDensity.compact,
              ),
              Text(
                _formatMonth(selectedMonth),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              IconButton(
                onPressed: () => _changeMonth(ref, selectedMonth, 1),
                icon: const Icon(Icons.chevron_right),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ),
        Expanded(
          child: transactionsAsync.when(
            data: (transactions) {
              if (transactions.isEmpty) {
                return AppEmptyState(
                  icon: Icons.history,
                  message: l10n.childcare_empty_transactions,
                );
              }
              return RefreshIndicator(
                onRefresh: () =>
                    ref.read(childcareTransactionsProvider.notifier).refresh(),
                child: ListView.separated(
                  itemCount: transactions.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    return TransactionListItem(
                        transaction: transactions[index]);
                  },
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) =>
                Center(child: Text(l10n.childcare_empty_transactions)),
          ),
        ),
      ],
    );
  }

  void _changeMonth(WidgetRef ref, String currentMonth, int delta) {
    final parts = currentMonth.split('-');
    var year = int.parse(parts[0]);
    var month = int.parse(parts[1]) + delta;
    if (month > 12) {
      month = 1;
      year++;
    } else if (month < 1) {
      month = 12;
      year--;
    }
    ref.read(childcareSelectedMonthProvider.notifier).state =
        '$year-${month.toString().padLeft(2, '0')}';
  }

  String _formatMonth(String month) {
    final parts = month.split('-');
    return '${parts[0]}.${parts[1]}';
  }
}
