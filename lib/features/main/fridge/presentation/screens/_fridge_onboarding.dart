part of 'fridge_tab.dart';

// ── 온보딩용 샘플 데이터 ─────────────────────────────────────────────────────────

final _demoStorage1 = StorageModel(
  id: '__demo_storage_1__',
  groupId: '__demo__',
  name: '냉장고',
  type: StorageType.fridge,
  sortOrder: 0,
  createdAt: DateTime(2025, 1, 1),
);

final _demoStorage2 = StorageModel(
  id: '__demo_storage_2__',
  groupId: '__demo__',
  name: '냉동실',
  type: StorageType.freezer,
  sortOrder: 1,
  createdAt: DateTime(2025, 1, 1),
);

final _demoItems1 = [
  FridgeItemModel(
    id: '__demo_item_1__',
    groupId: '__demo__',
    storageLocationId: '__demo_storage_1__',
    name: '우유',
    quantity: 2,
    unit: '개',
    registeredAt: DateTime.now().subtract(const Duration(days: 2)),
    expiresAt: DateTime.now().add(const Duration(days: 3)),
    alertDaysBefore: 3,
    memo: null,
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    updatedAt: DateTime.now(),
  ),
  FridgeItemModel(
    id: '__demo_item_2__',
    groupId: '__demo__',
    storageLocationId: '__demo_storage_1__',
    name: '계란',
    quantity: 10,
    unit: '개',
    registeredAt: DateTime.now().subtract(const Duration(days: 1)),
    expiresAt: DateTime.now().add(const Duration(days: 14)),
    alertDaysBefore: 3,
    memo: null,
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    updatedAt: DateTime.now(),
  ),
];

final _demoSwis = [
  StorageWithItemsModel(storage: _demoStorage1, items: _demoItems1),
  StorageWithItemsModel(storage: _demoStorage2, items: []),
];

// ── 온보딩 로직 ────────────────────────────────────────────────────────────────

extension _FridgeOnboarding on _FridgeTabState {
  Future<void> _maybeStartOnboarding() async {
    final completed = await OnboardingService.isCoachMarkCompleted(CoachMarkKeys.fridge);
    if (completed || !mounted) return;
    _startDemo();
  }

  void replayOnboarding() {
    OnboardingService.resetCoachMark(CoachMarkKeys.fridge).then((_) {
      if (mounted) _startDemo();
    });
  }

  void _startDemo() {
    _showDemo.value = true;
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

    final l10n = AppLocalizations.of(context)!;
    final fabPos = _keyToPosition(_fabKey);
    final sectionPos = _keyToPosition(_firstSectionKey);
    final itemPos = _keyToPosition(_firstItemKey);
    final ddayPos = _keyToPosition(_ddayChipKey);

    final targets = <TargetFocus>[
      TargetFocus(
        identify: 'fridge_fab',
        targetPosition: fabPos,
        keyTarget: fabPos == null ? _fabKey : null,
        shape: ShapeLightFocus.Circle,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: l10n.fridge_coach_fabTitle,
              description: l10n.fridge_coach_fabDesc,
              icon: Icons.add,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'fridge_section',
        targetPosition: sectionPos,
        keyTarget: sectionPos == null ? _firstSectionKey : null,
        shape: ShapeLightFocus.RRect,
        radius: 12,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: l10n.fridge_coach_sectionTitle,
              description: l10n.fridge_coach_sectionDesc,
              icon: Icons.kitchen_outlined,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'fridge_item',
        targetPosition: itemPos,
        keyTarget: itemPos == null ? _firstItemKey : null,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: l10n.fridge_coach_itemTitle,
              description: l10n.fridge_coach_itemDesc,
              icon: Icons.edit_outlined,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'fridge_dday',
        targetPosition: ddayPos,
        keyTarget: ddayPos == null ? _ddayChipKey : null,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: l10n.fridge_coach_ddayTitle,
              description: l10n.fridge_coach_ddayDesc,
              icon: Icons.notifications_outlined,
              color: Colors.orange,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'fridge_add_item',
        keyTarget: _addItemKey,
        shape: ShapeLightFocus.Circle,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: l10n.fridge_coach_addItemTitle,
              description: l10n.fridge_coach_addItemDesc,
              icon: Icons.add_circle_outline,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'fridge_expiry_suggestion',
        keyTarget: _suggestionChipKey,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: l10n.fridge_coach_suggestionTitle,
              description: l10n.fridge_coach_suggestionDesc,
              icon: Icons.lightbulb_outline,
              color: Colors.amber.shade700,
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
      textSkip: l10n.fridge_coach_skip,
      alignSkip: Alignment.topRight,
      skipWidget: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white30),
        ),
        child: Text(
          l10n.fridge_coach_skip,
          style: const TextStyle(
              color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ),
      onFinish: () {
        OnboardingService.completeCoachMark(CoachMarkKeys.fridge);
        _showDemo.value = false;
      },
      onSkip: () {
        OnboardingService.completeCoachMark(CoachMarkKeys.fridge);
        _showDemo.value = false;
        return true;
      },
      paddingFocus: 8,
      focusAnimationDuration: const Duration(milliseconds: 300),
      pulseAnimationDuration: const Duration(milliseconds: 800),
    ).show(context: context);
  }
}

// ── 온보딩 전용 뷰 (샘플 데이터, 탭/수정 불가) ──────────────────────────────────

class _OnboardingFridgeView extends StatelessWidget {
  final List<StorageWithItemsModel> swis;
  final FridgeSortOrder sortOrder;
  final GlobalKey firstSectionKey;
  final GlobalKey firstItemKey;
  final GlobalKey addItemKey;
  final GlobalKey ddayChipKey;
  final GlobalKey suggestionChipKey;

  const _OnboardingFridgeView({
    required this.swis,
    required this.sortOrder,
    required this.firstSectionKey,
    required this.firstItemKey,
    required this.addItemKey,
    required this.ddayChipKey,
    required this.suggestionChipKey,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: swis.length,
      itemBuilder: (context, sectionIndex) {
        final swi = swis[sectionIndex];
        final items = sortOrder.sort(swi.items);
        final isFirstSection = sectionIndex == 0;
        return Card(
          margin: const EdgeInsets.symmetric(
              horizontal: AppSizes.spaceM, vertical: AppSizes.spaceS),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                key: isFirstSection ? firstSectionKey : null,
                leading: Icon(_sectionIcon(swi.storage.type)),
                title: Text(swi.storage.name,
                    style: Theme.of(context).textTheme.titleMedium),
                subtitle: Text(
                  '${swi.items.length}개',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      key: isFirstSection ? addItemKey : null,
                      icon: const Icon(Icons.add, size: 20),
                      onPressed: null,
                    ),
                    const Icon(Icons.keyboard_arrow_up, size: 20),
                  ],
                ),
              ),
              ...items.asMap().entries.expand((entry) {
                final isFirstItem = isFirstSection && entry.key == 0;
                final item = entry.value;
                final dday = item.daysUntilExpiry;
                return [
                  AbsorbPointer(
                    child: ListTile(
                      key: isFirstItem ? firstItemKey : null,
                      contentPadding: const EdgeInsets.only(
                          left: AppSizes.spaceL, right: AppSizes.spaceXS),
                      title: Row(
                        children: [
                          Expanded(child: Text(item.name)),
                          if (dday != null) ...[
                            const SizedBox(width: AppSizes.spaceS),
                            _DemoExpiryChip(
                              key: isFirstItem ? ddayChipKey : null,
                              days: dday,
                            ),
                          ],
                        ],
                      ),
                      subtitle: Text(
                        item.unit ?? '',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.remove, size: 18),
                          const SizedBox(width: 4),
                          Text('${item.quantity}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w600)),
                          const Icon(Icons.add, size: 18),
                        ],
                      ),
                    ),
                  ),
                  if (isFirstItem)
                    AbsorbPointer(
                      child: Padding(
                        key: suggestionChipKey,
                        padding: const EdgeInsets.fromLTRB(
                            AppSizes.spaceL, 0, AppSizes.spaceM, AppSizes.spaceS),
                        child: _DemoSuggestionChip(),
                      ),
                    ),
                ];
              }),
              if (items.isEmpty) const SizedBox(height: AppSizes.spaceS),
            ],
          ),
        );
      },
    );
  }

  IconData _sectionIcon(StorageType type) {
    switch (type) {
      case StorageType.fridge:
        return Icons.kitchen_outlined;
      case StorageType.freezer:
        return Icons.ac_unit_outlined;
      case StorageType.pantry:
        return Icons.shelves;
    }
  }
}

class _DemoExpiryChip extends StatelessWidget {
  final int days;
  const _DemoExpiryChip({super.key, required this.days});

  @override
  Widget build(BuildContext context) {
    final Color color;
    final String label;
    if (days <= 0) {
      color = Theme.of(context).colorScheme.error;
      label = 'D+${-days}';
    } else if (days <= 3) {
      color = Colors.orange;
      label = 'D-$days';
    } else {
      color = Theme.of(context).colorScheme.primary;
      label = 'D-$days';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color, fontWeight: FontWeight.bold)),
    );
  }
}

class _DemoSuggestionChip extends StatelessWidget {
  const _DemoSuggestionChip();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spaceS, vertical: AppSizes.spaceXS),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(Icons.lightbulb_outline, size: 14, color: colorScheme.primary),
          const SizedBox(width: AppSizes.spaceXS),
          Expanded(
            child: Text(
              l10n.fridge_expiry_suggestion_label(
                '우유',
                l10n.fridge_storage_type_fridge,
                7,
              ),
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          const SizedBox(width: AppSizes.spaceXS),
          FilledButton(
            onPressed: null,
            style: FilledButton.styleFrom(
              visualDensity: VisualDensity.compact,
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSizes.spaceS),
            ),
            child: Text(
              l10n.fridge_expiry_apply,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
        ],
      ),
    );
  }
}
