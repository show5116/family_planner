part of 'frequent_items_tab.dart';

final _demoFrequentItems = [
  FrequentItemModel(
    id: '__demo_freq_1__',
    groupId: '__demo__',
    name: '우유',
    defaultUnit: '개',
    autoAdd: true,
    sortOrder: 0,
    createdAt: DateTime(2025, 1, 1),
    updatedAt: DateTime(2025, 1, 1),
  ),
  FrequentItemModel(
    id: '__demo_freq_2__',
    groupId: '__demo__',
    name: '계란',
    defaultUnit: '판',
    autoAdd: false,
    sortOrder: 1,
    createdAt: DateTime(2025, 1, 2),
    updatedAt: DateTime(2025, 1, 2),
  ),
  FrequentItemModel(
    id: '__demo_freq_3__',
    groupId: '__demo__',
    name: '두부',
    defaultUnit: null,
    autoAdd: false,
    sortOrder: 2,
    createdAt: DateTime(2025, 1, 3),
    updatedAt: DateTime(2025, 1, 3),
  ),
];

extension _FrequentItemsOnboarding on _FrequentItemsTabState {
  void _onTutorialTrigger() {
    if (widget.tutorialTrigger?.value == true && mounted) {
      _startDemo();
    }
  }

  void replayOnboarding() {
    OnboardingService.resetCoachMark(CoachMarkKeys.frequentItems).then((_) {
      if (mounted) _startDemo();
    });
  }

  void _startDemo() {
    // _coachMarkScheduled를 초기화해 다음 빌드에서 코치마크를 예약하도록 허용
    _coachMarkScheduled = false;
    _showDemo.value = true;
    setState(() {}); // keep-alive 엘리먼트에 ValueNotifier 알림이 묵살될 때 대비
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

    final fabPos = _keyToPosition(_fabKey);
    final firstItemPos = _keyToPosition(_firstItemKey);
    final autoAddPos = _keyToPosition(_autoAddKey);
    final addToCartPos = _keyToPosition(_addToCartKey);

    final l10n = AppLocalizations.of(context)!;

    final targets = <TargetFocus>[
      TargetFocus(
        identify: 'frequent_fab',
        targetPosition: fabPos,
        keyTarget: fabPos == null ? _fabKey : null,
        shape: ShapeLightFocus.Circle,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: l10n.fridge_frequent_coach_fabTitle,
              description: l10n.fridge_frequent_coach_fabDesc,
              icon: Icons.add,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'frequent_item',
        targetPosition: firstItemPos,
        keyTarget: firstItemPos == null ? _firstItemKey : null,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: l10n.fridge_frequent_coach_itemTitle,
              description: l10n.fridge_frequent_coach_itemDesc,
              icon: Icons.star_outline,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'frequent_auto_add',
        targetPosition: autoAddPos,
        keyTarget: autoAddPos == null ? _autoAddKey : null,
        shape: ShapeLightFocus.RRect,
        radius: 20,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: l10n.fridge_frequent_coach_autoAddTitle,
              description: l10n.fridge_frequent_coach_autoAddDesc,
              icon: Icons.kitchen_outlined,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'frequent_add_to_cart',
        targetPosition: addToCartPos,
        keyTarget: addToCartPos == null ? _addToCartKey : null,
        shape: ShapeLightFocus.Circle,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: l10n.fridge_frequent_coach_addToCartTitle,
              description: l10n.fridge_frequent_coach_addToCartDesc,
              icon: Icons.add_shopping_cart_outlined,
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
      textSkip: l10n.fridge_frequent_coach_skip,
      alignSkip: Alignment.topRight,
      skipWidget: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white30),
        ),
        child: Text(
          l10n.fridge_frequent_coach_skip,
          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ),
      onFinish: () {
        OnboardingService.completeCoachMark(CoachMarkKeys.frequentItems);
        _showDemo.value = false;
        widget.onOnboardingFinished?.call();
      },
      onSkip: () {
        OnboardingService.completeCoachMark(CoachMarkKeys.frequentItems);
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

class _OnboardingFrequentView extends StatelessWidget {
  final List<FrequentItemModel> items;
  final GlobalKey fabKey;
  final GlobalKey firstItemKey;
  final GlobalKey autoAddKey;
  final GlobalKey addToCartKey;

  const _OnboardingFrequentView({
    required this.items,
    required this.fabKey,
    required this.firstItemKey,
    required this.autoAddKey,
    required this.addToCartKey,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AbsorbPointer(
        child: ListView.builder(
          padding: const EdgeInsets.only(bottom: 80),
          itemCount: items.length,
          itemBuilder: (_, i) {
            final item = items[i];
            final isFirst = i == 0;

            return ListTile(
              key: isFirst ? firstItemKey : null,
              title: Text(item.name, style: Theme.of(context).textTheme.bodyLarge),
              subtitle: item.defaultUnit != null ? Text(item.defaultUnit!) : null,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    key: isFirst ? autoAddKey : null,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.fridge_frequent_auto_add,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: item.autoAdd
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.outline,
                            ),
                      ),
                      SizedBox(
                        height: 28,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Switch(
                            value: item.autoAdd,
                            onChanged: null,
                          ),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    key: isFirst ? addToCartKey : null,
                    icon: const Icon(Icons.add_shopping_cart_outlined, size: 20),
                    onPressed: null,
                  ),
                  const Icon(Icons.more_vert, size: 20),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: fabKey,
        heroTag: 'frequent_demo_add',
        onPressed: null,
        child: const Icon(Icons.add),
      ),
    );
  }
}
