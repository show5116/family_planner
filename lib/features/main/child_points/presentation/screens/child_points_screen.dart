import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/main/child_points/data/models/childcare_model.dart';
import 'package:family_planner/features/main/child_points/data/repositories/childcare_repository.dart';
import 'package:family_planner/features/main/child_points/presentation/widgets/account_summary_card.dart';
import 'package:family_planner/features/main/child_points/presentation/widgets/shop_item_list_item.dart';
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
    final shopAsync = ref.watch(childcareShopItemsProvider);

    if (account == null) {
      return Center(child: Text(l10n.childcare_no_child));
    }

    return Scaffold(
      body: shopAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return const _ShopGuide(hasItems: false);
          }
          return RefreshIndicator(
            onRefresh: () =>
                ref.read(childcareShopItemsProvider.notifier).refresh(),
            child: ListView.separated(
              itemCount: items.length + 1,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                if (index == 0) return const _ShopGuide(hasItems: true);
                final item = items[index - 1];
                return ShopItemListItem(
                  item: item,
                  onEdit: () => _showShopItemForm(context, ref,
                      accountId: account.id, item: item),
                  onDelete: () =>
                      _confirmDeleteItem(context, ref, account.id, item),
                  onToggleActive: () => ref
                      .read(childcareManagementProvider.notifier)
                      .updateShopItem(
                        account.id,
                        item.id,
                        UpdateShopItemDto(isActive: !item.isActive),
                      ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const _ShopGuide(hasItems: false),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            _showShopItemForm(context, ref, accountId: account.id),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showShopItemForm(
    BuildContext context,
    WidgetRef ref, {
    required String accountId,
    ChildcareShopItem? item,
  }) async {
    final nameController = TextEditingController(text: item?.name ?? '');
    final descController =
        TextEditingController(text: item?.description ?? '');
    final pointsController = TextEditingController(
      text: item != null ? item.points.toString() : '',
    );

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(item == null ? '상점 아이템 추가' : '상점 아이템 수정'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: '아이템 이름',
                hintText: '예: TV 30분 더보기',
              ),
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
            child: Text(item == null ? '추가' : '저장'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final name = nameController.text.trim();
    final points = int.tryParse(pointsController.text.trim());
    if (name.isEmpty || points == null || points <= 0) return;

    final notifier = ref.read(childcareManagementProvider.notifier);
    final desc = descController.text.trim().isEmpty
        ? null
        : descController.text.trim();

    if (item == null) {
      await notifier.addShopItem(
          accountId, CreateShopItemDto(name: name, description: desc, points: points));
    } else {
      await notifier.updateShopItem(
          accountId,
          item.id,
          UpdateShopItemDto(name: name, description: desc, points: points));
    }

    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('저장되었습니다')));
  }

  Future<void> _confirmDeleteItem(
    BuildContext context,
    WidgetRef ref,
    String accountId,
    ChildcareShopItem item,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('아이템 삭제'),
        content: Text('"${item.name}"을(를) 삭제하시겠습니까?'),
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
        .deleteShopItem(accountId, item.id);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('삭제되었습니다')));
  }
}

// ── 포인트 상점 안내 카드 ─────────────────────────────────────────────────────

class _ShopGuide extends StatefulWidget {
  const _ShopGuide({required this.hasItems});

  final bool hasItems;

  @override
  State<_ShopGuide> createState() => _ShopGuideState();
}

class _ShopGuideState extends State<_ShopGuide> {
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _expanded = !widget.hasItems;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: Card(
        margin: const EdgeInsets.all(AppSizes.spaceM),
        color: colorScheme.surfaceContainerHighest,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spaceM,
                  vertical: AppSizes.spaceS,
                ),
                child: Row(
                  children: [
                    Icon(Icons.storefront_outlined,
                        size: 18, color: colorScheme.secondary),
                    const SizedBox(width: AppSizes.spaceS),
                    Expanded(
                      child: Text(
                        '포인트 상점이란?',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: colorScheme.secondary,
                            ),
                      ),
                    ),
                    Icon(
                      _expanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 18,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
            if (_expanded) ...[
              Divider(height: 1, color: colorScheme.outlineVariant),
              Padding(
                padding: const EdgeInsets.all(AppSizes.spaceM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '아이가 모은 포인트로 구매할 수 있는 보상 목록입니다.\n원하는 것을 얻기 위해 스스로 포인트를 모으는 동기부여가 됩니다.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: AppSizes.spaceM),
                    Text(
                      '예시 아이템',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: AppSizes.spaceS),
                    ...const [
                      ('TV 30분 더보기', 10),
                      ('게임 1시간 하기', 20),
                      ('원하는 간식 고르기', 15),
                      ('늦게 자도 되는 날', 30),
                    ].map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(left: 4, bottom: 4),
                        child: Row(
                          children: [
                            Icon(Icons.storefront_outlined,
                                size: 14, color: colorScheme.secondary),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                e.$1,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color: colorScheme.onSurfaceVariant),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: colorScheme.secondaryContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${e.$2}P',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: colorScheme.secondary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.spaceS),
                    Text(
                      '아이템을 비활성화하면 목록에서 숨길 수 있습니다.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── 규칙 안내 카드 ────────────────────────────────────────────────────────────

class _RulesGuide extends StatefulWidget {
  const _RulesGuide({required this.hasRules});

  final bool hasRules;

  @override
  State<_RulesGuide> createState() => _RulesGuideState();
}

class _RulesGuideState extends State<_RulesGuide> {
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    // 규칙이 없으면 처음부터 펼쳐서 보여줌
    _expanded = !widget.hasRules;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: Card(
        margin: const EdgeInsets.all(AppSizes.spaceM),
        color: colorScheme.surfaceContainerHighest,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spaceM,
                  vertical: AppSizes.spaceS,
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        size: 18, color: colorScheme.primary),
                    const SizedBox(width: AppSizes.spaceS),
                    Expanded(
                      child: Text(
                        '규칙이란 무엇인가요?',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: colorScheme.primary,
                            ),
                      ),
                    ),
                    Icon(
                      _expanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 18,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
            if (_expanded) ...[
              Divider(height: 1, color: colorScheme.outlineVariant),
              Padding(
                padding: const EdgeInsets.all(AppSizes.spaceM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '규칙은 아이의 행동에 포인트를 연결하는 약속입니다.\n좋은 행동에는 포인트를 주고, 약속을 어겼을 때는 포인트를 차감해요.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: AppSizes.spaceS),
                    Container(
                      padding: const EdgeInsets.all(AppSizes.spaceS),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: colorScheme.primary.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.lightbulb_outline,
                              size: 14, color: colorScheme.primary),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              '규칙은 구체적이고 명확할수록 좋습니다.\n애매한 규칙은 아이와 불필요한 기싸움으로 이어질 수 있어요.\n아이와 함께 규칙을 정하면 신뢰가 쌓입니다.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: colorScheme.primary),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSizes.spaceM),
                    _ExampleRow(
                      icon: Icons.add_circle_outline,
                      color: Colors.green.shade700,
                      label: '+ 규칙 예시 (포인트 지급)',
                      examples: const [
                        '학교 숙제를 혼자 힘으로 끝냈을 때  +10P',
                        '저녁 9시 이전에 스스로 잠자리에 들었을 때  +5P',
                        '밥 먹은 후 식기를 싱크대에 가져다 놓았을 때  +3P',
                        '일주일 동안 지각 없이 등교했을 때  +20P',
                      ],
                    ),
                    const SizedBox(height: AppSizes.spaceS),
                    _ExampleRow(
                      icon: Icons.remove_circle_outline,
                      color: colorScheme.error,
                      label: '- 규칙 예시 (포인트 차감)',
                      examples: const [
                        '평일에 스마트폰을 1시간 이상 사용했을 때  -10P',
                        '저녁 10시가 넘도록 잠자리에 들지 않았을 때  -5P',
                        '형제·자매에게 욕설을 했을 때  -15P',
                        '약속된 귀가 시간인 오후 6시를 넘겼을 때  -10P',
                      ],
                    ),
                    const SizedBox(height: AppSizes.spaceS),
                    _ExampleRow(
                      icon: Icons.info_outline,
                      color: colorScheme.primary,
                      label: '일반 규칙 예시 (포인트 없음)',
                      examples: const [
                        '이달 포인트 현금 전환은 최대 50P까지만 가능',
                        '포인트 상점 아이템은 하루 1개만 사용 가능',
                      ],
                    ),
                    const SizedBox(height: AppSizes.spaceS),
                    Text(
                      '규칙을 적용하면 해당 포인트가 즉시 반영됩니다.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ExampleRow extends StatelessWidget {
  const _ExampleRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.examples,
  });

  final IconData icon;
  final Color color;
  final String label;
  final List<String> examples;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ...examples.map(
          (e) => Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 2),
            child: Text(
              '· $e',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
        ),
      ],
    );
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
            return const _RulesGuide(hasRules: false);
          }
          return RefreshIndicator(
            onRefresh: () =>
                ref.read(childcareRulesProvider.notifier).refresh(),
            child: ListView.separated(
              itemCount: rules.length + 1,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                if (index == 0) return const _RulesGuide(hasRules: true);
                final rule = rules[index - 1];
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
    await showDialog<void>(
      context: context,
      builder: (ctx) => _RuleFormDialog(
        accountId: accountId,
        rule: rule,
        ref: ref,
      ),
    );
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
            Text('"${rule.name}" 위반으로 ${rule.points}P를 차감합니다.'),
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
            amount: rule.points.toDouble(),
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

// ── 규칙 폼 다이얼로그 ────────────────────────────────────────────────────────

class _RuleFormDialog extends StatefulWidget {
  const _RuleFormDialog({
    required this.accountId,
    required this.rule,
    required this.ref,
  });

  final String accountId;
  final ChildcareRule? rule;
  final WidgetRef ref;

  @override
  State<_RuleFormDialog> createState() => _RuleFormDialogState();
}

class _RuleFormDialogState extends State<_RuleFormDialog> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _pointsCtrl;
  late ChildcareRuleType _type;

  @override
  void initState() {
    super.initState();
    final rule = widget.rule;
    _nameCtrl = TextEditingController(text: rule?.name ?? '');
    _descCtrl = TextEditingController(text: rule?.description ?? '');
    _pointsCtrl = TextEditingController(
        text: rule != null ? rule.points.toString() : '');
    _type = rule?.type ?? ChildcareRuleType.plus;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _pointsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isNew = widget.rule == null;

    // type별 색상
    Color typeColor() {
      switch (_type) {
        case ChildcareRuleType.plus:
          return Colors.green;
        case ChildcareRuleType.minus:
          return colorScheme.error;
        case ChildcareRuleType.info:
          return colorScheme.primary;
      }
    }

    return AlertDialog(
      title: Text(isNew ? '규칙 추가' : '규칙 수정'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 규칙 유형 선택
            Text('규칙 유형',
                style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 6),
            SegmentedButton<ChildcareRuleType>(
              segments: const [
                ButtonSegment(
                  value: ChildcareRuleType.plus,
                  label: Text('+포인트'),
                  icon: Icon(Icons.add_circle_outline, size: 16),
                ),
                ButtonSegment(
                  value: ChildcareRuleType.minus,
                  label: Text('-포인트'),
                  icon: Icon(Icons.remove_circle_outline, size: 16),
                ),
                ButtonSegment(
                  value: ChildcareRuleType.info,
                  label: Text('일반'),
                  icon: Icon(Icons.info_outline, size: 16),
                ),
              ],
              selected: {_type},
              onSelectionChanged: (s) =>
                  setState(() => _type = s.first),
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return typeColor();
                  }
                  return null;
                }),
              ),
            ),
            const SizedBox(height: AppSizes.spaceM),
            TextField(
              controller: _nameCtrl,
              decoration: InputDecoration(
                labelText: '규칙 이름',
                hintText: _type == ChildcareRuleType.plus
                    ? '예: 숙제를 스스로 했을 때'
                    : _type == ChildcareRuleType.minus
                        ? '예: 스마트폰을 30분 이상 보았을 때'
                        : '예: 이달 현금 출금 한도',
              ),
              autofocus: true,
            ),
            const SizedBox(height: AppSizes.spaceS),
            TextField(
              controller: _descCtrl,
              decoration:
                  const InputDecoration(labelText: '설명 (선택)'),
            ),
            if (_type != ChildcareRuleType.info) ...[
              const SizedBox(height: AppSizes.spaceS),
              TextField(
                controller: _pointsCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: _type == ChildcareRuleType.plus
                      ? '지급 포인트'
                      : '차감 포인트',
                  suffixText: 'P',
                  helperText: _type == ChildcareRuleType.plus
                      ? '좋은 행동 시 지급할 포인트'
                      : '규칙 위반 시 차감할 포인트',
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: _handleSave,
          child: Text(isNew ? '추가' : '저장'),
        ),
      ],
    );
  }

  Future<void> _handleSave() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;

    int points = 0;
    if (_type != ChildcareRuleType.info) {
      points = int.tryParse(_pointsCtrl.text.trim()) ?? 0;
      if (points < 0) return;
    }

    final desc =
        _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim();
    final notifier =
        widget.ref.read(childcareManagementProvider.notifier);

    if (widget.rule == null) {
      await notifier.addRule(
        widget.accountId,
        CreateRuleDto(
            name: name, description: desc, type: _type, points: points),
      );
    } else {
      await notifier.updateRule(
        widget.accountId,
        widget.rule!.id,
        UpdateRuleDto(
            name: name, description: desc, type: _type, points: points),
      );
    }

    if (!mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('저장되었습니다')));
  }
}
