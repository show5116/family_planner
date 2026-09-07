part of 'shopping_history_tab.dart';

// 온보딩 샘플 데이터
// 온보딩용 가짜 데이터. 번역이 필요해 최상위 상수로 둘 수 없다.
List<ShoppingHistoryModel> _demoHistories(AppLocalizations l10n) => [
  ShoppingHistoryModel(
    id: '__demo_hist_1__',
    groupId: '__demo__',
    completedAt: DateTime.now().subtract(const Duration(days: 2)),
    items: [
      ShoppingHistoryItemModel(
        id: '__demo_hist_item_1__',
        name: l10n.demo_milk,
        quantity: 2,
        unit: l10n.demo_unit_piece,
        price: 3200,
        transferredToFridge: true,
        fridgeItemId: '__demo__',
      ),
      ShoppingHistoryItemModel(
        id: '__demo_hist_item_2__',
        name: l10n.demo_eggs,
        quantity: 1,
        unit: l10n.demo_unit_pack,
        price: 6500,
        transferredToFridge: true,
        fridgeItemId: '__demo__',
      ),
      ShoppingHistoryItemModel(
        id: '__demo_hist_item_3__',
        name: l10n.demo_tofu,
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
      description: l10n.cart_default_description,
    ),
  ),
  ShoppingHistoryModel(
    id: '__demo_hist_2__',
    groupId: '__demo__',
    completedAt: DateTime.now().subtract(const Duration(days: 7)),
    items: [
      ShoppingHistoryItemModel(
        id: '__demo_hist_item_4__',
        name: l10n.demo_apple,
        quantity: 5,
        unit: l10n.demo_unit_piece,
        price: 8000,
        transferredToFridge: false,
        fridgeItemId: null,
      ),
    ],
    expense: null,
  ),
];

extension _ShoppingHistoryOnboarding on _ShoppingHistoryTabState {
  void _onTutorialTrigger() {
    if (widget.tutorialTrigger?.value == true && mounted) {
      _startDemo();
    }
  }

  void replayOnboarding() {
    OnboardingService.resetCoachMark(CoachMarkKeys.shoppingHistory).then((_) {
      if (mounted) _startDemo();
    });
  }

  void _startDemo() {
    _coachMarkScheduled = false;
    _showDemo.value = true;
    setState(() {}); // ignore: invalid_use_of_protected_member
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
    final l10n = AppLocalizations.of(context)!;
    if (!mounted) return;

    final firstCardPos = _keyToPosition(_firstCardKey);
    final expenseBadgePos = _keyToPosition(_expenseBadgeKey);

    final targets = <TargetFocus>[
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
              title: l10n.coach_history_records,
              description: l10n.coach_history_records_desc,
              icon: Icons.receipt_long_outlined,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
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
              title: l10n.coach_history_expense,
              description: l10n.coach_history_expense_desc,
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
      targets: FeatureCoachMark.refreshPositions(targets),
      colorShadow: AppColors.textPrimary,
      opacityShadow: 0.85,
      textSkip: l10n.common_skip,
      alignSkip: Alignment.topRight,
      skipWidget: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white30),
        ),
        child: Text(
          l10n.common_skip,
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
}

// 온보딩 전용 뷰
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
