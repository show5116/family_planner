import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/main/fridge/data/models/fridge_models.dart';
import 'package:family_planner/features/main/fridge/providers/fridge_provider.dart';
import 'package:family_planner/features/onboarding/presentation/widgets/feature_coach_mark.dart';
import 'package:family_planner/features/onboarding/services/onboarding_service.dart';

// ── 온보딩 샘플 데이터 ──────────────────────────────────────────────────────────

final _demoHistories = [
  ShoppingHistoryModel(
    id: '__demo_hist_1__',
    groupId: '__demo__',
    completedAt: DateTime.now().subtract(const Duration(days: 2)),
    items: [
      ShoppingHistoryItemModel(
        id: '__demo_hist_item_1__',
        name: '우유',
        quantity: 2,
        unit: '개',
        price: 3200,
        transferredToFridge: true,
        fridgeItemId: '__demo__',
      ),
      ShoppingHistoryItemModel(
        id: '__demo_hist_item_2__',
        name: '계란',
        quantity: 1,
        unit: '판',
        price: 6500,
        transferredToFridge: true,
        fridgeItemId: '__demo__',
      ),
      ShoppingHistoryItemModel(
        id: '__demo_hist_item_3__',
        name: '두부',
        quantity: 1,
        unit: null,
        price: 1800,
        transferredToFridge: false,
        fridgeItemId: null,
      ),
    ],
    expense: LinkedExpenseModel(
      id: '__demo_expense_1__',
      amount: 11500,
      category: 'food',
      paymentMethod: 'card',
      date: DateTime.now().subtract(const Duration(days: 2)),
      description: '마트 장보기',
    ),
  ),
  ShoppingHistoryModel(
    id: '__demo_hist_2__',
    groupId: '__demo__',
    completedAt: DateTime.now().subtract(const Duration(days: 7)),
    items: [
      ShoppingHistoryItemModel(
        id: '__demo_hist_item_4__',
        name: '사과',
        quantity: 5,
        unit: '개',
        price: 8000,
        transferredToFridge: false,
        fridgeItemId: null,
      ),
    ],
    expense: null,
  ),
];

// ── 탭 ─────────────────────────────────────────────────────────────────────────

class ShoppingHistoryTab extends ConsumerStatefulWidget {
  const ShoppingHistoryTab({
    super.key,
    this.onReplayOnboardingReady,
    this.onStartOnboardingReady,
    this.onOnboardingFinished,
  });

  final void Function(VoidCallback replay)? onReplayOnboardingReady;
  final void Function(VoidCallback start)? onStartOnboardingReady;
  final VoidCallback? onOnboardingFinished;

  @override
  ConsumerState<ShoppingHistoryTab> createState() => _ShoppingHistoryTabState();
}

class _ShoppingHistoryTabState extends ConsumerState<ShoppingHistoryTab> {
  final _showDemo = ValueNotifier<bool>(false);
  final _firstCardKey = GlobalKey();
  final _expenseBadgeKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    widget.onReplayOnboardingReady?.call(replayOnboarding);
    widget.onStartOnboardingReady?.call(_startDemo);
    // 자동 시작 없음 — FrequentItemsTab 온보딩 완료 후 ShoppingScreen 체인으로만 시작
  }

  @override
  void dispose() {
    _showDemo.dispose();
    super.dispose();
  }

  void replayOnboarding() {
    OnboardingService.resetCoachMark(CoachMarkKeys.shoppingHistory).then((_) {
      if (mounted) _startDemo();
    });
  }

  void _startDemo() {
    _showDemo.value = true;
    WidgetsBinding.instance.addPostFrameCallback((_) => _showCoachMark());
  }

  TargetPosition? _keyToPosition(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return null;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return null;
    final offset = box.localToGlobal(Offset.zero);
    return TargetPosition(box.size, offset);
  }

  Future<void> _showCoachMark() async {
    if (!mounted) return;

    final firstCardPos = _keyToPosition(_firstCardKey);
    final expenseBadgePos = _keyToPosition(_expenseBadgeKey);

    final targets = <TargetFocus>[
      // 1. 이력 카드
      TargetFocus(
        identify: 'history_card',
        targetPosition: firstCardPos,
        keyTarget: firstCardPos == null ? _firstCardKey : null,
        shape: ShapeLightFocus.RRect,
        radius: 12,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '구매 이력',
              description: '장보기를 완료할 때마다 이력이 쌓여요.\n카드를 탭하면 품목별 상세 내역을\n확인할 수 있어요.',
              icon: Icons.receipt_long_outlined,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      // 2. 가계부 연동 배지
      TargetFocus(
        identify: 'history_expense_badge',
        targetPosition: expenseBadgePos,
        keyTarget: expenseBadgePos == null ? _expenseBadgeKey : null,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '가계부 연동',
              description: '장보기 완료 시 지출을 함께 기록하면\n이 배지가 표시돼요.\n가계부와 자동으로 연동되어 지출 관리가 편해져요.',
              icon: Icons.account_balance_wallet_outlined,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    ];

    await FeatureCoachMark.waitForTargets(targets, context);
    if (!mounted) return;

    TutorialCoachMark(
      targets: targets,
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
          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ),
      onFinish: () {
        OnboardingService.completeCoachMark(CoachMarkKeys.shoppingHistory);
        _showDemo.value = false;
        widget.onOnboardingFinished?.call();
      },
      onSkip: () {
        OnboardingService.completeCoachMark(CoachMarkKeys.shoppingHistory);
        _showDemo.value = false;
        widget.onOnboardingFinished?.call();
        return true;
      },
      paddingFocus: 8,
      focusAnimationDuration: const Duration(milliseconds: 300),
      pulseAnimationDuration: const Duration(milliseconds: 800),
    ).show(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _showDemo,
      builder: (context, isDemo, _) {
        if (isDemo) {
          return _OnboardingHistoryView(
            histories: _demoHistories,
            firstCardKey: _firstCardKey,
            expenseBadgeKey: _expenseBadgeKey,
          );
        }
        return _RealHistoryView();
      },
    );
  }
}

// ── 온보딩 전용 뷰 ──────────────────────────────────────────────────────────────

class _OnboardingHistoryView extends StatelessWidget {
  final List<ShoppingHistoryModel> histories;
  final GlobalKey firstCardKey;
  final GlobalKey expenseBadgeKey;

  const _OnboardingHistoryView({
    required this.histories,
    required this.firstCardKey,
    required this.expenseBadgeKey,
  });

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      child: ListView.builder(
        itemCount: histories.length,
        itemBuilder: (_, i) {
          final history = histories[i];
          final isFirst = i == 0;
          return _HistoryCard(
            history: history,
            cardKey: isFirst ? firstCardKey : null,
            expenseBadgeKey: isFirst ? expenseBadgeKey : null,
          );
        },
      ),
    );
  }
}

// ── 실제 뷰 ────────────────────────────────────────────────────────────────────

class _RealHistoryView extends ConsumerWidget {
  const _RealHistoryView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final historyAsync = ref.watch(shoppingHistoryProvider);

    return historyAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(e.toString())),
      data: (page) {
        if (page.data.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.receipt_long_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.outlineVariant),
                const SizedBox(height: AppSizes.spaceM),
                Text(l10n.fridge_history_empty,
                    style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          );
        }
        return ListView.builder(
          itemCount: page.data.length + (page.hasMore ? 1 : 0),
          itemBuilder: (_, i) {
            if (i == page.data.length) {
              return _LoadMoreButton(
                onTap: () =>
                    ref.read(shoppingHistoryProvider.notifier).loadMore(),
              );
            }
            return _HistoryCard(history: page.data[i]);
          },
        );
      },
    );
  }
}

// ── 공용 위젯 ──────────────────────────────────────────────────────────────────

class _LoadMoreButton extends StatelessWidget {
  final VoidCallback onTap;
  const _LoadMoreButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: TextButton(
          onPressed: onTap,
          child: const Text('더 보기'),
        ),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final ShoppingHistoryModel history;
  final GlobalKey? cardKey;
  final GlobalKey? expenseBadgeKey;

  const _HistoryCard({
    required this.history,
    this.cardKey,
    this.expenseBadgeKey,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dateStr = DateFormat('yyyy.MM.dd HH:mm').format(history.completedAt);
    final itemCount = history.items.length;
    final hasExpense = history.expense != null;

    return Card(
      key: cardKey,
      margin: const EdgeInsets.symmetric(
          horizontal: AppSizes.spaceM, vertical: AppSizes.spaceS),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        onTap: cardKey != null
            ? null
            : () => context.push(
                  AppRoutes.shoppingHistoryDetail
                      .replaceFirst(':historyId', history.id),
                ),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(dateStr,
                        style: Theme.of(context).textTheme.titleSmall),
                  ),
                  if (hasExpense)
                    Container(
                      key: expenseBadgeKey,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius:
                            BorderRadius.circular(AppSizes.radiusSmall),
                      ),
                      child: Text(
                        l10n.fridge_history_linked_expense,
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSizes.spaceXS),
              Text(
                l10n.fridge_history_items_count(itemCount),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline),
              ),
              if (history.items.isNotEmpty) ...[
                const SizedBox(height: AppSizes.spaceXS),
                Text(
                  history.items.map((i) => i.name).join(', '),
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (hasExpense) ...[
                const SizedBox(height: AppSizes.spaceS),
                Text(
                  '${NumberFormat('#,###').format(history.expense!.amount)}원',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
