part of 'shopping_history_tab.dart';

// 온보딩 샘플 데이터
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
              title: '구매 이력',
              description: '장보기를 완료할 때마다 이력이 쌓여요.\n카드를 탭하면 품목별 상세 내역을\n확인할 수 있어요.',
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
      targets: FeatureCoachMark.refreshPositions(targets),
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
