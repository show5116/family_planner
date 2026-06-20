part of 'household_screen.dart';

// ── 온보딩용 샘플 데이터 ─────────────────────────────────────────────────────────

final _demoStats = MonthlyStatisticsModel(
  month: '2025-06',
  totalIncome: 3000000,
  totalExpense: 1870000,
  balance: 1130000,
  totalBudget: 2500000,
  categories: [
    CategoryStatModel(category: ExpenseCategory.food, total: 520000, count: 12),
    CategoryStatModel(category: ExpenseCategory.groceries, total: 380000, count: 8),
    CategoryStatModel(category: ExpenseCategory.transportation, total: 210000, count: 15),
    CategoryStatModel(category: ExpenseCategory.living, total: 450000, count: 4),
    CategoryStatModel(category: ExpenseCategory.leisure, total: 310000, count: 5),
  ],
);

final _now = DateTime(2025, 6, 19);
final _demoExpenses = [
  ExpenseModel(
    id: '__demo_1__', groupId: '__demo__', userId: '__demo__',
    type: TransactionType.income, amount: 3000000,
    incomeCategory: IncomeCategory.salary,
    date: DateTime(2025, 6, 5), description: '6월 급여',
    createdAt: _now, updatedAt: _now,
  ),
  ExpenseModel(
    id: '__demo_2__', groupId: '__demo__', userId: '__demo__',
    type: TransactionType.expense, amount: 68000,
    category: ExpenseCategory.food,
    date: DateTime(2025, 6, 18), description: '저녁 외식',
    createdAt: _now, updatedAt: _now,
  ),
  ExpenseModel(
    id: '__demo_3__', groupId: '__demo__', userId: '__demo__',
    type: TransactionType.expense, amount: 142000,
    category: ExpenseCategory.groceries,
    date: DateTime(2025, 6, 17), description: '마트 장보기',
    createdAt: _now, updatedAt: _now,
  ),
  ExpenseModel(
    id: '__demo_4__', groupId: '__demo__', userId: '__demo__',
    type: TransactionType.expense, amount: 45000,
    category: ExpenseCategory.transportation,
    date: DateTime(2025, 6, 16), description: '주유',
    createdAt: _now, updatedAt: _now,
  ),
  ExpenseModel(
    id: '__demo_5__', groupId: '__demo__', userId: '__demo__',
    type: TransactionType.expense, amount: 350000,
    category: ExpenseCategory.living,
    date: DateTime(2025, 6, 10), description: '전기/가스 요금',
    createdAt: _now, updatedAt: _now,
  ),
];

// ── 온보딩 로직 ────────────────────────────────────────────────────────────────

extension _HouseholdOnboarding on _HouseholdScreenState {
  TargetPosition? _keyToPosition(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return null;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return null;
    final offset = box.localToGlobal(Offset.zero);
    return TargetPosition(box.size, offset);
  }

  Future<void> _maybeStartOnboarding() async {
    final completed = await OnboardingService.isCoachMarkCompleted(CoachMarkKeys.household);
    if (completed || !mounted) return;
    setState(() => _isDemo = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final animation = ModalRoute.of(context)?.animation;
      if (animation == null || animation.isCompleted) {
        _showCoachMark();
      } else {
        void listener(AnimationStatus status) {
          if (status == AnimationStatus.completed) {
            animation.removeStatusListener(listener);
            if (mounted) _showCoachMark();
          }
        }
        animation.addStatusListener(listener);
      }
    });
  }

  Future<void> _replayOnboarding() async {
    await OnboardingService.resetCoachMark(CoachMarkKeys.household);
    if (!mounted) return;
    setState(() => _isDemo = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final animation = ModalRoute.of(context)?.animation;
      if (animation == null || animation.isCompleted) {
        _showCoachMark();
      } else {
        void listener(AnimationStatus status) {
          if (status == AnimationStatus.completed) {
            animation.removeStatusListener(listener);
            if (mounted) _showCoachMark();
          }
        }
        animation.addStatusListener(listener);
      }
    });
  }

  Future<void> _showCoachMark() async {
    if (!mounted) return;

    final summaryPos = _keyToPosition(_budgetKey);
    final moreMenuPos = _keyToPosition(_moreMenuKey);
    final recurringPos = _keyToPosition(_recurringKey);
    final statisticsPos = _keyToPosition(_statisticsKey);
    final fabPos = _keyToPosition(_fabKey);

    final targets = <TargetFocus>[
      TargetFocus(
        identify: 'household_summary',
        targetPosition: summaryPos,
        keyTarget: summaryPos == null ? _budgetKey : null,
        shape: ShapeLightFocus.RRect,
        radius: 12,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '월간 요약',
              description: '이번 달 수입·지출·잔액을 한눈에 확인하고,\n예산 대비 사용량을 진척도 바로 볼 수 있어요.',
              icon: Icons.account_balance_wallet_outlined,
              color: Colors.teal,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'household_budget',
        targetPosition: moreMenuPos,
        keyTarget: moreMenuPos == null ? _moreMenuKey : null,
        shape: ShapeLightFocus.Circle,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '예산 설정',
              description: '여기 더보기 메뉴를 열면 월별 예산을\n카테고리별로 설정할 수 있어요.',
              icon: Icons.more_vert,
              color: Colors.teal,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'household_recurring',
        targetPosition: recurringPos,
        keyTarget: recurringPos == null ? _recurringKey : null,
        shape: ShapeLightFocus.Circle,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '고정 지출',
              description: '월세, 구독료 등 매달 반복되는 지출을\n등록하면 자동으로 기록해 드려요.',
              icon: Icons.repeat,
              color: Colors.indigo,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'household_statistics',
        targetPosition: statisticsPos,
        keyTarget: statisticsPos == null ? _statisticsKey : null,
        shape: ShapeLightFocus.Circle,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '통계',
              description: '카테고리별 지출 비율과 월별 추이를\n차트로 확인할 수 있어요.',
              icon: Icons.bar_chart,
              color: Colors.purple,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'household_fab',
        targetPosition: fabPos,
        keyTarget: fabPos == null ? _fabKey : null,
        shape: ShapeLightFocus.Circle,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '지출/수입 추가',
              description: '새 지출이나 수입을 기록하세요.\n그룹별로 나눠서 관리할 수 있어요.',
              icon: Icons.add,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    ];
    await FeatureCoachMark.waitForTargets(targets, context);
    if (!mounted) return;
    TutorialCoachMark(
      targets: FeatureCoachMark.refreshPositions(targets),
      colorShadow: const Color(0xFF212121),
      opacityShadow: 0.85,
      textSkip: '건너뛰기',
      alignSkip: Alignment.bottomLeft,
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
        OnboardingService.completeCoachMark(CoachMarkKeys.household);
        if (mounted) setState(() => _isDemo = false);
      },
      onSkip: () {
        OnboardingService.completeCoachMark(CoachMarkKeys.household);
        if (mounted) setState(() => _isDemo = false);
        return true;
      },
      paddingFocus: 8,
      focusAnimationDuration: const Duration(milliseconds: 300),
      pulseAnimationDuration: const Duration(milliseconds: 800),
    ).show(context: context);
  }
}

// ── 온보딩 데모용 지출 목록 ────────────────────────────────────────────────────

class _DemoExpenseList extends StatelessWidget {
  final List<ExpenseModel> expenses;

  const _DemoExpenseList({required this.expenses});

  @override
  Widget build(BuildContext context) {
    final sorted = [...expenses]..sort((a, b) => b.date.compareTo(a.date));
    final grouped = <String, List<ExpenseModel>>{};
    for (final e in sorted) {
      final key =
          '${e.date.year}-${e.date.month.toString().padLeft(2, '0')}-${e.date.day.toString().padLeft(2, '0')}';
      grouped.putIfAbsent(key, () => []).add(e);
    }
    final dateKeys = grouped.keys.toList();

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: dateKeys.length,
      padding: const EdgeInsets.only(bottom: 80),
      itemBuilder: (context, index) {
        final dateKey = dateKeys[index];
        final dayExpenses = grouped[dateKey]!;
        return _DayGroup(
          dateKey: dateKey,
          expenses: dayExpenses,
          onTap: (_) {},
          onDelete: (_) {},
        );
      },
    );
  }
}
