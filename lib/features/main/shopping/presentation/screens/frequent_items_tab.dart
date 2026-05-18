import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/main/fridge/data/models/fridge_models.dart';
import 'package:family_planner/features/main/fridge/providers/fridge_provider.dart';
import 'package:family_planner/features/onboarding/presentation/widgets/feature_coach_mark.dart';
import 'package:family_planner/features/onboarding/services/onboarding_service.dart';

// ── 온보딩 샘플 데이터 ──────────────────────────────────────────────────────────

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

// ── 탭 ─────────────────────────────────────────────────────────────────────────

class FrequentItemsTab extends ConsumerStatefulWidget {
  const FrequentItemsTab({super.key, this.onReplayOnboardingReady, this.onOnboardingFinished});

  final void Function(VoidCallback replay)? onReplayOnboardingReady;
  final VoidCallback? onOnboardingFinished;

  @override
  ConsumerState<FrequentItemsTab> createState() => _FrequentItemsTabState();
}

class _FrequentItemsTabState extends ConsumerState<FrequentItemsTab> {
  final _showDemo = ValueNotifier<bool>(false);
  final _fabKey = GlobalKey();
  final _firstItemKey = GlobalKey();
  final _autoAddKey = GlobalKey();
  final _addToCartKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    widget.onReplayOnboardingReady?.call(replayOnboarding);
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeStartOnboarding());
  }

  @override
  void dispose() {
    _showDemo.dispose();
    super.dispose();
  }

  Future<void> _maybeStartOnboarding() async {
    final completed = await OnboardingService.isCoachMarkCompleted(CoachMarkKeys.frequentItems);
    if (completed || !mounted) return;
    _startDemo();
  }

  void replayOnboarding() {
    OnboardingService.resetCoachMark(CoachMarkKeys.frequentItems).then((_) {
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

    final fabPos = _keyToPosition(_fabKey);
    final firstItemPos = _keyToPosition(_firstItemKey);
    final autoAddPos = _keyToPosition(_autoAddKey);
    final addToCartPos = _keyToPosition(_addToCartKey);

    final targets = <TargetFocus>[
      // 1. 추가 FAB
      TargetFocus(
        identify: 'frequent_fab',
        targetPosition: fabPos,
        keyTarget: fabPos == null ? _fabKey : null,
        shape: ShapeLightFocus.Circle,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '자주 사는 항목 추가',
              description: '자주 구매하는 품목을 등록해 두면\n다음 장보기 때 빠르게 담을 수 있어요.',
              icon: Icons.add,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      // 2. 첫 번째 항목 타일
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
              title: '항목 관리',
              description: '품목명·기본 단위를 설정할 수 있어요.\n탭하면 수정, 길게 누르면 삭제할 수 있습니다.',
              icon: Icons.star_outline,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      // 3. 자동 추가 스위치
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
              title: '자동 추가',
              description: '냉장고에서 이 품목의 수량이 0이 되면\n장바구니에 자동으로 추가돼요.\n냉장고 탭과 연동되는 스마트 기능이에요.',
              icon: Icons.kitchen_outlined,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      // 4. 장바구니에 담기 버튼
      TargetFocus(
        identify: 'frequent_add_to_cart',
        targetPosition: addToCartPos,
        keyTarget: addToCartPos == null ? _addToCartKey : null,
        shape: ShapeLightFocus.Circle,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '장바구니에 바로 담기',
              description: '버튼 하나로 현재 장바구니에\n즉시 추가할 수 있어요.',
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

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _showDemo,
      builder: (context, isDemo, _) {
        if (isDemo) {
          return _OnboardingFrequentView(
            items: _demoFrequentItems,
            fabKey: _fabKey,
            firstItemKey: _firstItemKey,
            autoAddKey: _autoAddKey,
            addToCartKey: _addToCartKey,
          );
        }

        return _RealFrequentItemsView(
          onAdd: () => _showAddDialog(context),
        );
      },
    );
  }

  void _showAddDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => const _FrequentItemFormDialog(),
    );
  }
}

// ── 온보딩 전용 뷰 ──────────────────────────────────────────────────────────────

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
                  Switch(
                    key: isFirst ? autoAddKey : null,
                    value: item.autoAdd,
                    onChanged: null,
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

// ── 자동 추가 안내 배너 ────────────────────────────────────────────────────────

class _AutoAddInfoBanner extends StatefulWidget {
  const _AutoAddInfoBanner();

  @override
  State<_AutoAddInfoBanner> createState() => _AutoAddInfoBannerState();
}

class _AutoAddInfoBannerState extends State<_AutoAddInfoBanner> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSizes.spaceM, AppSizes.spaceM, AppSizes.spaceM, 0),
      child: InkWell(
        onTap: () => setState(() => _expanded = !_expanded),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: colorScheme.secondaryContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.secondaryContainer),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.kitchen_outlined, size: 16, color: colorScheme.secondary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '자동 추가란?',
                      style: textTheme.labelMedium?.copyWith(color: colorScheme.secondary),
                    ),
                  ),
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    size: 18,
                    color: colorScheme.secondary,
                  ),
                ],
              ),
              if (_expanded) ...[
                const SizedBox(height: 8),
                Text(
                  '냉장고에서 이 품목의 수량이 0이 되면 장바구니에 자동으로 추가돼요.\n스위치를 켜두면 냉장고가 비었을 때 알아서 장보기 목록에 담아드립니다.',
                  style: textTheme.bodySmall?.copyWith(color: colorScheme.onSecondaryContainer),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.info_outline, size: 12, color: colorScheme.outline),
                    const SizedBox(width: 4),
                    Text(
                      '냉장고 탭에서 수량을 관리하면 연동됩니다',
                      style: textTheme.labelSmall?.copyWith(color: colorScheme.outline),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ── 실제 뷰 ────────────────────────────────────────────────────────────────────

class _RealFrequentItemsView extends ConsumerWidget {
  final VoidCallback onAdd;
  const _RealFrequentItemsView({required this.onAdd});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final itemsAsync = ref.watch(frequentItemsProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: itemsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (items) {
          if (items.isEmpty) {
            return Column(
              children: [
                const _AutoAddInfoBanner(),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star_outline,
                            size: 64,
                            color: Theme.of(context).colorScheme.outlineVariant),
                        const SizedBox(height: AppSizes.spaceM),
                        Text(l10n.fridge_frequent_empty,
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: items.length + 1,
            itemBuilder: (_, i) {
              if (i == 0) return const _AutoAddInfoBanner();
              return _FrequentItemTile(item: items[i - 1]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'frequent_add',
        onPressed: onAdd,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ── 항목 타일 ──────────────────────────────────────────────────────────────────

class _FrequentItemTile extends ConsumerWidget {
  final FrequentItemModel item;
  const _FrequentItemTile({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return ListTile(
      title: Text(item.name),
      subtitle: item.defaultUnit != null ? Text(item.defaultUnit!) : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Tooltip(
            message: l10n.fridge_frequent_auto_add,
            child: Switch(
              value: item.autoAdd,
              onChanged: (v) => ref
                  .read(frequentItemsProvider.notifier)
                  .toggleAutoAdd(item.id, v),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_shopping_cart_outlined, size: 20),
            tooltip: l10n.fridge_frequent_add_to_cart,
            onPressed: () => _addToCart(context, ref),
          ),
          PopupMenuButton<_Action>(
            onSelected: (a) => _handleAction(context, ref, a),
            itemBuilder: (_) => [
              PopupMenuItem(
                value: _Action.edit,
                child: Text(l10n.common_edit),
              ),
              PopupMenuItem(
                value: _Action.delete,
                child: Text(l10n.common_delete,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.error)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _addToCart(BuildContext context, WidgetRef ref) async {
    final groupId = ref.read(fridgeSelectedGroupIdProvider);
    try {
      await ref.read(cartProvider.notifier).addItem(AddCartItemDto(
            groupId: groupId ?? '',
            name: item.name,
            quantity: 1,
            unit: item.defaultUnit,
          ));
      ref.invalidate(cartProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${item.name}을(를) 장바구니에 추가했습니다')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  Future<void> _handleAction(
      BuildContext context, WidgetRef ref, _Action action) async {
    final l10n = AppLocalizations.of(context)!;
    switch (action) {
      case _Action.edit:
        await showDialog<void>(
          context: context,
          builder: (_) => _FrequentItemFormDialog(item: item),
        );
      case _Action.delete:
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            content: Text('${item.name}을(를) 삭제하시겠습니까?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(l10n.common_cancel),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(l10n.common_delete,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.error)),
              ),
            ],
          ),
        );
        if (confirmed == true && context.mounted) {
          await ref.read(frequentItemsProvider.notifier).delete(item.id);
        }
    }
  }
}

enum _Action { edit, delete }

// ── 자주 사는 항목 폼 ─────────────────────────────────────────────────────────────

class _FrequentItemFormDialog extends ConsumerStatefulWidget {
  final FrequentItemModel? item;
  const _FrequentItemFormDialog({this.item});

  @override
  ConsumerState<_FrequentItemFormDialog> createState() =>
      _FrequentItemFormDialogState();
}

class _FrequentItemFormDialogState
    extends ConsumerState<_FrequentItemFormDialog> {
  final _nameController = TextEditingController();
  final _unitController = TextEditingController();
  bool _autoAdd = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _nameController.text = widget.item!.name;
      _unitController.text = widget.item!.defaultUnit ?? '';
      _autoAdd = widget.item!.autoAdd;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    final unit =
        _unitController.text.trim().isEmpty ? null : _unitController.text.trim();

    setState(() => _loading = true);
    try {
      final notifier = ref.read(frequentItemsProvider.notifier);
      if (widget.item == null) {
        final groupId = ref.read(fridgeSelectedGroupIdProvider);
        await notifier.create(CreateFrequentItemDto(
          groupId: groupId ?? '',
          name: name,
          defaultUnit: unit,
          autoAdd: _autoAdd,
        ));
      } else {
        await notifier.edit(
          widget.item!.id,
          UpdateFrequentItemDto(name: name, defaultUnit: unit, autoAdd: _autoAdd),
        );
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEdit = widget.item != null;

    return AlertDialog(
      title: Text(isEdit ? l10n.common_edit : l10n.fridge_frequent_add),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: l10n.fridge_item_name),
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: AppSizes.spaceS),
          TextField(
            controller: _unitController,
            decoration: InputDecoration(labelText: l10n.fridge_item_unit),
          ),
          const SizedBox(height: AppSizes.spaceS),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.fridge_frequent_auto_add,
                style: Theme.of(context).textTheme.bodyMedium),
            value: _autoAdd,
            onChanged: (v) => setState(() => _autoAdd = v),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.pop(context),
          child: Text(l10n.common_cancel),
        ),
        FilledButton(
          onPressed: _loading ? null : _submit,
          child: _loading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : Text(isEdit ? l10n.common_save : l10n.common_add),
        ),
      ],
    );
  }
}
