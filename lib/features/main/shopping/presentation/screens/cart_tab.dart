import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/main/fridge/data/models/fridge_models.dart';
import 'package:family_planner/features/main/fridge/providers/fridge_provider.dart';
import 'package:family_planner/features/main/household/data/models/expense_model.dart';
import 'package:family_planner/features/onboarding/presentation/widgets/feature_coach_mark.dart';
import 'package:family_planner/features/onboarding/services/onboarding_service.dart';
import 'package:family_planner/shared/widgets/item_name_autocomplete.dart';

// ── 온보딩용 샘플 데이터 ─────────────────────────────────────────────────────────

final _demoCartItems = [
  CartItemModel(
    id: '__demo_cart_1__',
    cartId: '__demo_cart__',
    name: '우유',
    quantity: 2,
    unit: '개',
    isChecked: true,
    memo: null,
    createdAt: DateTime.now(),
  ),
  CartItemModel(
    id: '__demo_cart_2__',
    cartId: '__demo_cart__',
    name: '계란',
    quantity: 1,
    unit: '판',
    isChecked: false,
    memo: null,
    createdAt: DateTime.now(),
  ),
  CartItemModel(
    id: '__demo_cart_3__',
    cartId: '__demo_cart__',
    name: '두부',
    quantity: 1,
    unit: null,
    isChecked: false,
    memo: '국산',
    createdAt: DateTime.now(),
  ),
];

// ── 로컬 편집 상태 ─────────────────────────────────────────────────────────────

class _CartEditState {
  String name;
  int quantity;
  String? unit;
  String? memo;
  double? price;       // 항상 총액으로 저장 (서버 전송값)
  bool markedForDelete;

  _CartEditState(CartItemModel item)
      : name = item.name,
        quantity = item.quantity,
        unit = item.unit,
        memo = item.memo,
        price = item.price,
        markedForDelete = false;

  // 총액 반환 — 삭제 표시된 항목은 0
  double get totalPrice {
    if (markedForDelete) return 0;
    return price ?? 0;
  }

  bool hasChanges(CartItemModel original) {
    if (markedForDelete) return true;
    if (name != original.name) return true;
    if (quantity != original.quantity) return true;
    if (unit != original.unit) return true;
    if (memo != original.memo) return true;
    if (price != original.price) return true;
    return false;
  }
}

// ── 탭 ─────────────────────────────────────────────────────────────────────────

class CartTab extends ConsumerStatefulWidget {
  const CartTab({super.key, this.onReplayOnboardingReady, this.onOnboardingFinished});

  final void Function(VoidCallback replay)? onReplayOnboardingReady;
  final VoidCallback? onOnboardingFinished;

  @override
  ConsumerState<CartTab> createState() => _CartTabState();
}

class _CartTabState extends ConsumerState<CartTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final Map<String, _CartEditState> _edits = {};
  bool _saving = false;

  // ValueNotifier: setState 없이 온보딩 on/off — 코치마크 콜백 내 build 충돌 방지
  final _showDemo = ValueNotifier<bool>(false);
  final _addFabKey = GlobalKey();
  final _completeFabKey = GlobalKey();
  final _firstItemKey = GlobalKey();

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
    final completed = await OnboardingService.isCoachMarkCompleted(CoachMarkKeys.cart);
    if (completed || !mounted) return;
    _startDemo();
  }

  void replayOnboarding() {
    OnboardingService.resetCoachMark(CoachMarkKeys.cart).then((_) {
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

    final addFabPos = _keyToPosition(_addFabKey);
    final firstItemPos = _keyToPosition(_firstItemKey);
    final completeFabPos = _keyToPosition(_completeFabKey);

    final targets = <TargetFocus>[
      // 1. 품목 추가 FAB
      TargetFocus(
        identify: 'cart_add_fab',
        targetPosition: addFabPos,
        keyTarget: addFabPos == null ? _addFabKey : null,
        shape: ShapeLightFocus.Circle,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '품목 추가',
              description: '구매할 품목을 추가해요.\n여러 품목을 한 번에 목록에 담고\n한꺼번에 저장할 수 있어요.',
              icon: Icons.add,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      // 2. 첫 번째 품목 타일 (수정/삭제)
      TargetFocus(
        identify: 'cart_item',
        targetPosition: firstItemPos,
        keyTarget: firstItemPos == null ? _firstItemKey : null,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '품목 관리',
              description: '• 탭하면 이름·수량·메모를 수정할 수 있어요\n• ± 버튼으로 수량을 조절하세요\n• 왼쪽으로 스와이프하면 삭제 표시돼요\n• 변경 후 저장 버튼을 눌러야 반영됩니다',
              icon: Icons.edit_outlined,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      // 3. 장보기 완료 FAB
      TargetFocus(
        identify: 'cart_complete_fab',
        targetPosition: completeFabPos,
        keyTarget: completeFabPos == null ? _completeFabKey : null,
        shape: ShapeLightFocus.RRect,
        radius: 20,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '장보기 완료',
              description: '쇼핑을 마치면 여기를 눌러요.\n다음 화면에서 상세 기능을 확인해 보세요!',
              icon: Icons.check,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    ];

    await FeatureCoachMark.waitForTargets(targets, context);
    if (!mounted) return;

    void finishOnboarding() {
      OnboardingService.completeCoachMark(CoachMarkKeys.cart);
      _showDemo.value = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        showDialog<void>(
          context: context,
          builder: (_) => _DemoCompleteDialog(
            onClosed: () => widget.onOnboardingFinished?.call(),
          ),
        );
      });
    }

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
      onFinish: finishOnboarding,
      onSkip: () {
        OnboardingService.completeCoachMark(CoachMarkKeys.cart);
        _showDemo.value = false;
        widget.onOnboardingFinished?.call();
        return true;
      },
      paddingFocus: 8,
      focusAnimationDuration: const Duration(milliseconds: 300),
      pulseAnimationDuration: const Duration(milliseconds: 800),
    ).show(context: context);
  }

  void _syncEdits(List<CartItemModel> items) {
    final ids = items.map((i) => i.id).toSet();
    _edits.removeWhere((k, _) => !ids.contains(k));
    for (final item in items) {
      _edits.putIfAbsent(item.id, () => _CartEditState(item));
    }
  }

  // 현재 담긴 품목들의 가격 총합 (삭제 표시 제외, 가격 미입력 품목 제외)
  double _calcTotal(List<CartItemModel> serverItems, List<CartItemEntryDto> pending) {
    double total = 0;
    for (final item in serverItems) {
      final e = _edits[item.id];
      if (e == null || e.markedForDelete) continue;
      total += e.totalPrice;
    }
    for (final p in pending) {
      total += p.price ?? 0;
    }
    return total;
  }

  bool get _hasChanges {
    final items = ref.read(cartProvider).value?.items ?? [];
    if (items.any((item) => _edits[item.id]?.hasChanges(item) == true)) {
      return true;
    }
    return ref.read(cartPendingInsertsProvider).isNotEmpty;
  }

  void _cancelChanges(List<CartItemModel> items) {
    for (final item in items) {
      _edits[item.id] = _CartEditState(item);
    }
    ref.read(cartPendingInsertsProvider.notifier).state = [];
    setState(() {});
  }

  Future<void> _save(List<CartItemModel> items) async {
    final groupId = ref.read(fridgeSelectedGroupIdProvider);
    final inserts = ref.read(cartPendingInsertsProvider);

    final deletes = <String>[];
    final updates = <CartItemUpdateEntryDto>[];

    for (final item in items) {
      final e = _edits[item.id];
      if (e == null || !e.hasChanges(item)) continue;
      if (e.markedForDelete) {
        deletes.add(item.id);
      } else {
        updates.add(CartItemUpdateEntryDto(
          id: item.id,
          quantity: e.quantity != item.quantity ? e.quantity : null,
          unit: e.unit != item.unit ? e.unit : null,
          memo: e.memo != item.memo ? e.memo : null,
          price: e.price,
        ));
      }
    }

    if (inserts.isEmpty && updates.isEmpty && deletes.isEmpty) return;

    setState(() => _saving = true);
    try {
      await ref.read(cartProvider.notifier).syncCart(BulkUpdateCartItemDto(
            groupId: groupId ?? '',
            inserts: inserts.isEmpty ? null : inserts,
            updates: updates.isEmpty ? null : updates,
            deletes: deletes.isEmpty ? null : deletes,
          ));
      _edits.clear();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizations.of(context)!;

    return ValueListenableBuilder<bool>(
      valueListenable: _showDemo,
      builder: (context, isDemo, _) {
        if (isDemo) {
          return _OnboardingCartView(
            items: _demoCartItems,
            addFabKey: _addFabKey,
            completeFabKey: _completeFabKey,
            firstItemKey: _firstItemKey,
          );
        }

        final cartAsync = ref.watch(cartProvider);
        final pendingInserts = ref.watch(cartPendingInsertsProvider);
        return cartAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text(e.toString())),
          data: (cart) {
            final serverItems = cart?.items ?? [];
            _syncEdits(serverItems);
            final hasChanges = _hasChanges;

            // 서버 저장 품목 + 로컬 pending 합산
            final totalCount = serverItems.length + pendingInserts.length;

            return Scaffold(
              backgroundColor: Colors.transparent,
              appBar: hasChanges
                  ? AppBar(
                      automaticallyImplyLeading: false,
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      title: Text(l10n.cart_unsaved_changes,
                          style: Theme.of(context).textTheme.bodyMedium),
                      actions: [
                        TextButton(
                          onPressed: _saving
                              ? null
                              : () => _cancelChanges(serverItems),
                          child: Text(l10n.common_cancel),
                        ),
                        FilledButton(
                          onPressed:
                              _saving ? null : () => _save(serverItems),
                          child: _saving
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2))
                              : Text(l10n.common_save),
                        ),
                        const SizedBox(width: AppSizes.spaceS),
                      ],
                    )
                  : null,
              body: AbsorbPointer(
                absorbing: _saving,
                child: Column(
                  children: [
                    _TotalPriceBar(total: _calcTotal(serverItems, pendingInserts)),
                    Expanded(
                      child: totalCount == 0
                          ? _EmptyCart(l10n: l10n)
                          : ListView.builder(
                              padding: const EdgeInsets.only(bottom: 100),
                              itemCount: totalCount,
                              itemBuilder: (_, i) {
                                // 서버 품목
                                if (i < serverItems.length) {
                                  final item = serverItems[i];
                                  final editState = _edits[item.id]!;
                                  return _CartItemTile(
                                    key: ValueKey(item.id),
                                    item: item,
                                    editState: editState,
                                    onChanged: () => setState(() {}),
                                    onTapEdit: () => _showEditBottomSheet(
                                        context, item, editState),
                                  );
                                }
                                // Pending insert 항목
                                final pi = pendingInserts[i - serverItems.length];
                                return _PendingCartItemTile(
                                  key: ValueKey('pending_$i'),
                                  entry: pi,
                                  onRemove: () {
                                    final list = [...ref.read(cartPendingInsertsProvider)];
                                    list.removeAt(i - serverItems.length);
                                    ref.read(cartPendingInsertsProvider.notifier).state = list;
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
              floatingActionButton: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FloatingActionButton.small(
                    key: _addFabKey,
                    heroTag: 'cart_add',
                    onPressed: () => _showAddItemDialog(context),
                    child: const Icon(Icons.add),
                  ),
                  const SizedBox(height: AppSizes.spaceS),
                  if (totalCount > 0)
                    FloatingActionButton.extended(
                      key: _completeFabKey,
                      heroTag: 'cart_complete',
                      onPressed: hasChanges
                          ? null
                          : () => _showCompleteDialog(context, serverItems),
                      icon: const Icon(Icons.check),
                      label: Text(l10n.fridge_cart_complete),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showAddItemDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => const _AddCartItemDialog(),
    );
  }

  void _showCompleteDialog(BuildContext context, List<CartItemModel> items) {
    showDialog<void>(
      context: context,
      builder: (_) => _CompleteShoppingDialog(
        items: items,
        initialPrices: {
          for (final item in items)
            if (_edits[item.id]?.price != null)
              item.id: _edits[item.id]!.price!,
        },
      ),
    );
  }


  Future<void> _showEditBottomSheet(
      BuildContext context, CartItemModel item, _CartEditState es) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _EditCartItemSheet(
        item: item,
        editState: es,
        onSaved: () => setState(() {}),
      ),
    );
  }
}

// ── 장보기 완료 기능 안내 다이얼로그 (온보딩용) ──────────────────────────────────────

class _DemoCompleteDialog extends StatelessWidget {
  final VoidCallback? onClosed;
  const _DemoCompleteDialog({this.onClosed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.check_circle_outline, color: colorScheme.primary, size: 22),
          const SizedBox(width: 8),
          const Text('장보기 완료 기능 안내'),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '장보기 완료 버튼을 누르면 아래 두 가지를 한 번에 처리할 수 있어요.',
                style: textTheme.bodyMedium?.copyWith(color: colorScheme.outline),
              ),
              const SizedBox(height: 16),

              // ── 냉장고 이관 ──
              _DemoInfoCard(
                icon: Icons.kitchen_outlined,
                color: colorScheme.primary,
                title: '냉장고로 이관',
                description: '구매한 품목을 냉장고 보관소로 바로 옮길 수 있어요.\n수량·유통기한·알림일도 함께 설정할 수 있습니다.',
                preview: Column(
                  children: [
                    _DemoTransferRow(name: '우유', qty: '2개', storage: '냉장고'),
                    _DemoTransferRow(name: '계란', qty: '1판', storage: '냉장고'),
                    _DemoTransferRow(name: '두부', qty: '1개', storage: '이관 안 함'),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // ── 가계부 연동 ──
              _DemoInfoCard(
                icon: Icons.account_balance_wallet_outlined,
                color: colorScheme.tertiary,
                title: '가계부 자동 기록',
                description: '지출 금액·결제 수단·메모를 입력하면\n가계부에 자동으로 기록돼요.',
                preview: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.receipt_long_outlined, size: 16, color: colorScheme.outline),
                          const SizedBox(width: 6),
                          Text('마트 장보기', style: textTheme.bodySmall),
                          const Spacer(),
                          Text('32,500원', style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.credit_card_outlined, size: 14, color: colorScheme.outline),
                          const SizedBox(width: 4),
                          Text('카드', style: textTheme.labelSmall?.copyWith(color: colorScheme.outline)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        FilledButton(
          onPressed: () {
            Navigator.pop(context);
            onClosed?.call();
          },
          child: const Text('확인'),
        ),
      ],
    );
  }
}

class _DemoInfoCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String description;
  final Widget preview;

  const _DemoInfoCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
    required this.preview,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 6),
              Text(title, style: textTheme.titleSmall?.copyWith(color: color)),
            ],
          ),
          const SizedBox(height: 6),
          Text(description, style: textTheme.bodySmall?.copyWith(color: colorScheme.outline)),
          const SizedBox(height: 10),
          preview,
        ],
      ),
    );
  }
}

class _DemoTransferRow extends StatelessWidget {
  final String name;
  final String qty;
  final String storage;

  const _DemoTransferRow({
    required this.name,
    required this.qty,
    required this.storage,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isSkipped = storage == '이관 안 함';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(
            isSkipped ? Icons.remove_circle_outline : Icons.kitchen_outlined,
            size: 14,
            color: isSkipped ? colorScheme.outline : colorScheme.primary,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text('$name ($qty)', style: textTheme.bodySmall),
          ),
          Text(
            storage,
            style: textTheme.labelSmall?.copyWith(
              color: isSkipped ? colorScheme.outline : colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

// ── 품목 수정 바텀시트 ────────────────────────────────────────────────────────────

class _EditCartItemSheet extends StatefulWidget {
  final CartItemModel item;
  final _CartEditState editState;
  final VoidCallback onSaved;

  const _EditCartItemSheet({
    required this.item,
    required this.editState,
    required this.onSaved,
  });

  @override
  State<_EditCartItemSheet> createState() => _EditCartItemSheetState();
}

class _EditCartItemSheetState extends State<_EditCartItemSheet> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _unitCtrl;
  late final TextEditingController _memoCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.editState.name);
    _unitCtrl = TextEditingController(text: widget.editState.unit ?? '');
    _memoCtrl = TextEditingController(text: widget.editState.memo ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _unitCtrl.dispose();
    _memoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.only(
        left: AppSizes.spaceL,
        right: AppSizes.spaceL,
        top: AppSizes.spaceL,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSizes.spaceL,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.common_edit, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSizes.spaceM),
          TextField(
            controller: _nameCtrl,
            decoration: InputDecoration(labelText: l10n.fridge_item_name),
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: AppSizes.spaceS),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _unitCtrl,
                  decoration: InputDecoration(labelText: l10n.fridge_item_unit),
                ),
              ),
              const SizedBox(width: AppSizes.spaceM),
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _memoCtrl,
                  decoration: InputDecoration(labelText: l10n.fridge_item_memo),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spaceM),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.common_cancel),
              ),
              const SizedBox(width: AppSizes.spaceS),
              FilledButton(
                onPressed: () {
                  final es = widget.editState;
                  es.name = _nameCtrl.text.trim().isEmpty
                      ? widget.item.name
                      : _nameCtrl.text.trim();
                  es.unit = _unitCtrl.text.trim().isEmpty
                      ? null
                      : _unitCtrl.text.trim();
                  es.memo = _memoCtrl.text.trim().isEmpty
                      ? null
                      : _memoCtrl.text.trim();
                  widget.onSaved();
                  Navigator.pop(context);
                },
                child: Text(l10n.common_done),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── 온보딩 전용 뷰 (샘플 데이터, 탭/수정 불가) ──────────────────────────────────

class _OnboardingCartView extends StatelessWidget {
  final List<CartItemModel> items;
  final GlobalKey addFabKey;
  final GlobalKey completeFabKey;
  final GlobalKey firstItemKey;

  const _OnboardingCartView({
    required this.items,
    required this.addFabKey,
    required this.completeFabKey,
    required this.firstItemKey,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AbsorbPointer(
        child: ListView.builder(
          padding: const EdgeInsets.only(bottom: 100),
          itemCount: items.length,
          itemBuilder: (_, i) {
            final item = items[i];
            final isFirst = i == 0;

            return ListTile(
              key: isFirst ? firstItemKey : null,
              title: Text(item.name,
                  style: Theme.of(context).textTheme.bodyLarge),
              subtitle: () {
                final parts = <String>[];
                if (item.unit != null && item.unit!.isNotEmpty) {
                  parts.add(item.unit!);
                }
                if (item.memo != null && item.memo!.isNotEmpty) {
                  parts.add(item.memo!);
                }
                if (parts.isEmpty) return null;
                return Text(
                  parts.join('  ·  '),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                );
              }(),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.remove, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    '${item.quantity}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const Icon(Icons.add, size: 18),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.small(
            key: addFabKey,
            heroTag: 'cart_demo_add',
            onPressed: null,
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: AppSizes.spaceS),
          FloatingActionButton.extended(
            key: completeFabKey,
            heroTag: 'cart_demo_complete',
            onPressed: null,
            icon: const Icon(Icons.check),
            label: Text(l10n.fridge_cart_complete),
          ),
        ],
      ),
    );
  }
}

// ── 총합계 바 ───────────────────────────────────────────────────────────────────

class _TotalPriceBar extends StatelessWidget {
  final double total;
  const _TotalPriceBar({required this.total});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final fmt = NumberFormat('#,###');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spaceL, vertical: AppSizes.spaceS),
      color: colorScheme.surfaceContainerHighest,
      child: Row(
        children: [
          Icon(Icons.shopping_cart_outlined,
              size: 16, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: AppSizes.spaceS),
          Text(
            '합계',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
          const Spacer(),
          Text(
            total > 0 ? '${fmt.format(total.toInt())}원' : '-',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: total > 0 ? colorScheme.primary : colorScheme.outline,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  final AppLocalizations l10n;
  const _EmptyCart({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shopping_cart_outlined,
              size: 64, color: Theme.of(context).colorScheme.outlineVariant),
          const SizedBox(height: AppSizes.spaceM),
          Text(l10n.fridge_cart_empty,
              style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

// 아직 서버에 저장되지 않은 추가 대기 품목 타일
class _PendingCartItemTile extends StatelessWidget {
  final CartItemEntryDto entry;
  final VoidCallback onRemove;

  const _PendingCartItemTile({
    super.key,
    required this.entry,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final parts = <String>[];
    if (entry.unit != null) parts.add(entry.unit!);
    if (entry.memo != null) parts.add(entry.memo!);

    return Dismissible(
      key: ValueKey('pending_dismissible_${entry.name}_${entry.hashCode}'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onRemove(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSizes.spaceL),
        color: colorScheme.errorContainer,
        child: Icon(Icons.delete_outline, color: colorScheme.onErrorContainer),
      ),
      child: ListTile(
        leading: Icon(Icons.add_circle_outline,
            size: 18, color: colorScheme.primary),
        title: Text(
          entry.name,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: colorScheme.primary,
              ),
        ),
        subtitle: parts.isNotEmpty
            ? Text(
                parts.join('  ·  '),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.outline,
                    ),
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              entry.quantity.toString(),
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 18),
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}

class _CartItemTile extends StatefulWidget {
  final CartItemModel item;
  final _CartEditState editState;
  final VoidCallback onChanged;
  final VoidCallback onTapEdit;

  const _CartItemTile({
    super.key,
    required this.item,
    required this.editState,
    required this.onChanged,
    required this.onTapEdit,
  });

  @override
  State<_CartItemTile> createState() => _CartItemTileState();
}

class _CartItemTileState extends State<_CartItemTile> {
  late final TextEditingController _priceCtrl;
  // isUnitPrice는 State 로컬 — editState 재사용 시 컨트롤러 표시값과 불일치 방지
  bool _isUnitPrice = false;
  bool _ignoreListener = false;

  _CartEditState get _es => widget.editState;

  String _displayText() {
    if (_es.price == null) return '';
    if (_isUnitPrice && _es.quantity > 0) {
      return (_es.price! / _es.quantity).toInt().toString();
    }
    return _es.price!.toInt().toString();
  }

  // 컨트롤러 표시값 → editState.price(총액) 동기화
  void _syncPrice() {
    if (_ignoreListener) return;
    final raw = _priceCtrl.text.trim();
    final entered = raw.isEmpty ? null : double.tryParse(raw);
    if (entered == null) {
      _es.price = null;
    } else if (_isUnitPrice) {
      _es.price = entered * _es.quantity;
    } else {
      _es.price = entered;
    }
    widget.onChanged();
  }

  // 수량 변경 시 단가 모드라면 총액 재계산, 컨트롤러 표시값은 그대로 유지
  void _changeQuantity(int delta) {
    _es.quantity += delta;
    if (_es.quantity == 0) _es.markedForDelete = true;
    // 단가 모드: 입력값(단가)은 그대로, 총액만 재계산
    final raw = double.tryParse(_priceCtrl.text.trim());
    if (raw != null && _isUnitPrice) {
      _es.price = raw * _es.quantity;
    }
    widget.onChanged();
  }

  // 모드 전환 시 컨트롤러 표시값 변환
  void _togglePriceMode() {
    setState(() {
      _ignoreListener = true;
      if (_isUnitPrice) {
        // 단가 → 총액: 총액을 그대로 표시
        _priceCtrl.text = _es.price != null ? _es.price!.toInt().toString() : '';
        _isUnitPrice = false;
      } else {
        // 총액 → 단가: 총액 ÷ 수량
        if (_es.price != null && _es.quantity > 0) {
          _priceCtrl.text = (_es.price! / _es.quantity).toInt().toString();
        }
        _isUnitPrice = true;
      }
      _ignoreListener = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _priceCtrl = TextEditingController(text: _displayText());
    _priceCtrl.addListener(_syncPrice);
  }

  @override
  void didUpdateWidget(_CartItemTile old) {
    super.didUpdateWidget(old);
    // editState 객체가 바뀌었거나 외부에서 price가 변경된 경우 컨트롤러 동기화
    if (old.editState != widget.editState) {
      _isUnitPrice = false;
      _ignoreListener = true;
      _priceCtrl.text = _displayText();
      _ignoreListener = false;
    }
  }

  @override
  void dispose() {
    _priceCtrl.removeListener(_syncPrice);
    _priceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final deleted = _es.markedForDelete;
    final colorScheme = Theme.of(context).colorScheme;

    // 단가 모드일 때 총액 미리보기 문자열
    String? priceHint;
    if (_isUnitPrice && _es.price != null && _es.quantity > 1) {
      final fmt = NumberFormat('#,###');
      priceHint = '합계 ${fmt.format(_es.price!.toInt())}원';
    }

    return Dismissible(
      key: ValueKey('cart_dismissible_${widget.item.id}'),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        _es.markedForDelete = true;
        widget.onChanged();
        return false;
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSizes.spaceL),
        color: colorScheme.errorContainer,
        child: Icon(Icons.delete_outline, color: colorScheme.onErrorContainer),
      ),
      child: AnimatedOpacity(
        opacity: deleted ? 0.38 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              onTap: deleted ? null : widget.onTapEdit,
              title: Text(
                _es.name,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      decoration: deleted ? TextDecoration.lineThrough : null,
                    ),
              ),
              subtitle: () {
                final parts = <String>[];
                final u = _es.unit;
                if (u != null && u.isNotEmpty) parts.add(u);
                final m = _es.memo;
                if (m != null && m.isNotEmpty) parts.add(m);
                if (parts.isEmpty) return null;
                return Text(
                  parts.join('  ·  '),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.outline,
                      ),
                );
              }(),
              trailing: deleted
                  ? IconButton(
                      icon: Icon(Icons.undo, color: colorScheme.primary, size: 20),
                      tooltip: l10n.common_undo,
                      onPressed: () {
                        _es.markedForDelete = false;
                        if (_es.quantity == 0) _es.quantity = widget.item.quantity;
                        widget.onChanged();
                      },
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove, size: 18),
                          visualDensity: VisualDensity.compact,
                          onPressed: _es.quantity > 0
                              ? () => setState(() => _changeQuantity(-1))
                              : null,
                        ),
                        Text(
                          _es.quantity.toString(),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add, size: 18),
                          visualDensity: VisualDensity.compact,
                          onPressed: () => setState(() => _changeQuantity(1)),
                        ),
                      ],
                    ),
            ),
            if (!deleted)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSizes.spaceM, 0, AppSizes.spaceM, AppSizes.spaceS),
                child: Row(
                  children: [
                    SizedBox(
                      width: 140,
                      child: TextField(
                        controller: _priceCtrl,
                        decoration: InputDecoration(
                          labelText: _isUnitPrice ? '개당 가격' : l10n.fridge_cart_item_price,
                          suffixText: '원',
                          helperText: priceHint,
                          isDense: true,
                          border: const OutlineInputBorder(),
                        ),
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: false),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    const SizedBox(width: AppSizes.spaceXS),
                    // 단가/총액 토글
                    Tooltip(
                      message: _isUnitPrice ? '총액으로 전환' : '개당 가격으로 전환',
                      child: InkWell(
                        onTap: _togglePriceMode,
                        borderRadius: BorderRadius.circular(4),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            _isUnitPrice ? '×${_es.quantity}' : '÷${_es.quantity}',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── 품목 추가 다이얼로그 ──────────────────────────────────────────────────────────

// 대기 목록에 담긴 항목 (immutable 요약용)
class _CartPendingItem {
  final String name;
  final int quantity;
  final String? unit;
  final String? memo;
  final double? price; // 총액

  const _CartPendingItem({
    required this.name,
    required this.quantity,
    this.unit,
    this.memo,
    this.price,
  });

  String get label {
    final buf = StringBuffer('$name  $quantity${unit ?? ''}');
    if (memo != null) buf.write('  · $memo');
    if (price != null) {
      buf.write('  ${NumberFormat('#,###').format(price!.toInt())}원');
    }
    return buf.toString();
  }
}

class _AddCartItemDialog extends ConsumerStatefulWidget {
  const _AddCartItemDialog();

  @override
  ConsumerState<_AddCartItemDialog> createState() => _AddCartItemDialogState();
}

class _AddCartItemDialogState extends ConsumerState<_AddCartItemDialog> {
  final _nameCtrl = TextEditingController();
  final _quantityCtrl = TextEditingController(text: '1');
  final _unitCtrl = TextEditingController();
  final _memoCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  bool _isUnitPrice = false;

  // 다이얼로그 내 임시 목록 (확인 전 미리보기용)
  final List<_CartPendingItem> _pending = [];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _quantityCtrl.dispose();
    _unitCtrl.dispose();
    _memoCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  double? _calcTotalPrice() {
    final raw = double.tryParse(_priceCtrl.text.trim());
    if (raw == null) return null;
    final qty = int.tryParse(_quantityCtrl.text.trim()) ?? 1;
    return _isUnitPrice ? raw * qty : raw;
  }

  void _addToPending() {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;
    setState(() {
      _pending.add(_CartPendingItem(
        name: name,
        quantity: int.tryParse(_quantityCtrl.text) ?? 1,
        unit: _unitCtrl.text.trim().isEmpty ? null : _unitCtrl.text.trim(),
        memo: _memoCtrl.text.trim().isEmpty ? null : _memoCtrl.text.trim(),
        price: _calcTotalPrice(),
      ));
      _nameCtrl.clear();
      _quantityCtrl.text = '1';
      _unitCtrl.clear();
      _memoCtrl.clear();
      _priceCtrl.clear();
    });
  }

  void _removePending(int index) {
    setState(() => _pending.removeAt(index));
  }

  void _submit() {
    // 입력 중인 내용이 있으면 먼저 담기
    if (_nameCtrl.text.trim().isNotEmpty) _addToPending();
    if (_pending.isEmpty) return;

    // 서버 저장 없이 provider에 쌓기 — CartTab 저장 버튼으로 한꺼번에 전송
    final newEntries = _pending
        .map((p) => CartItemEntryDto(
              name: p.name,
              quantity: p.quantity,
              unit: p.unit,
              memo: p.memo,
              price: p.price,
            ))
        .toList();
    final current = ref.read(cartPendingInsertsProvider);
    ref.read(cartPendingInsertsProvider.notifier).state = [
      ...current,
      ...newEntries,
    ];
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final canAddToList = _nameCtrl.text.trim().isNotEmpty;

    return AlertDialog(
      title: Text(l10n.fridge_cart_add_item),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── 입력 폼 ──
              ItemNameAutocomplete(
                controller: _nameCtrl,
                decoration: InputDecoration(labelText: l10n.fridge_item_name),
                onChanged: (_) => setState(() {}),
                onSubmitted: (_) => _addToPending(),
                onSelected: (_) => setState(() {}),
              ),
              const SizedBox(height: AppSizes.spaceS),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _quantityCtrl,
                      decoration: InputDecoration(
                          labelText: l10n.fridge_item_quantity),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: AppSizes.spaceS),
                  Expanded(
                    flex: 3,
                    child: TextField(
                      controller: _unitCtrl,
                      decoration:
                          InputDecoration(labelText: l10n.fridge_item_unit),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.spaceS),
              TextField(
                controller: _memoCtrl,
                decoration: InputDecoration(labelText: l10n.fridge_item_memo),
              ),
              const SizedBox(height: AppSizes.spaceS),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _priceCtrl,
                      decoration: InputDecoration(
                        labelText: _isUnitPrice ? '개당 가격' : l10n.fridge_cart_item_price,
                        suffixText: '원',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: false),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: AppSizes.spaceXS),
                  TextButton(
                    onPressed: () => setState(() => _isUnitPrice = !_isUnitPrice),
                    child: Text(_isUnitPrice ? '개당' : '총액'),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.spaceXS),
              // 단가 모드일 때 총액 미리보기
              if (_isUnitPrice) Builder(builder: (context) {
                final qty = int.tryParse(_quantityCtrl.text.trim()) ?? 1;
                final unitPrice = double.tryParse(_priceCtrl.text.trim());
                if (unitPrice == null || qty <= 1) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSizes.spaceXS),
                  child: Text(
                    '합계 ${NumberFormat('#,###').format((unitPrice * qty).toInt())}원',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                );
              }),
              // 목록에 담기 버튼
              OutlinedButton.icon(
                onPressed: canAddToList ? _addToPending : null,
                icon: const Icon(Icons.playlist_add, size: 18),
                label: Text(l10n.common_add_to_list),
              ),
              // ── 대기 목록 ──
              if (_pending.isNotEmpty) ...[
                const SizedBox(height: AppSizes.spaceM),
                const Divider(height: 1),
                const SizedBox(height: AppSizes.spaceS),
                Wrap(
                  spacing: AppSizes.spaceXS,
                  runSpacing: AppSizes.spaceXS,
                  children: _pending.asMap().entries.map((entry) {
                    final i = entry.key;
                    final p = entry.value;
                    return Chip(
                      label: Text(p.label,
                          style: Theme.of(context).textTheme.labelMedium),
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () => _removePending(i),
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.common_cancel),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(l10n.common_save),
        ),
      ],
    );
  }
}

// ── 이관 상세 정보 (Step 2용) ──────────────────────────────────────────────────

class _TransferDetail {
  final CartItemModel cartItem;
  String storageId;
  final TextEditingController quantity;
  final TextEditingController price;
  DateTime? expiresAt;
  int alertDays;

  _TransferDetail({
    required this.cartItem,
    required this.storageId,
    String? initialPrice,
  })  : quantity = TextEditingController(text: cartItem.quantity.toString()),
        price = TextEditingController(text: initialPrice ?? ''),
        alertDays = 3;

  void dispose() {
    quantity.dispose();
    price.dispose();
  }
}

// ── 장보기 완료 다이얼로그 ─────────────────────────────────────────────────────────

class _CompleteShoppingDialog extends ConsumerStatefulWidget {
  final List<CartItemModel> items;
  final Map<String, double> initialPrices; // cartItemId → price
  const _CompleteShoppingDialog({
    required this.items,
    this.initialPrices = const {},
  });

  @override
  ConsumerState<_CompleteShoppingDialog> createState() =>
      _CompleteShoppingDialogState();
}

class _CompleteShoppingDialogState
    extends ConsumerState<_CompleteShoppingDialog> {
  // Step 1 상태
  final Map<String, String?> _transferMap = {}; // cartItemId → storageId | null
  final Map<String, TextEditingController> _priceMap = {}; // cartItemId → 가격
  bool _addExpense = false;
  final _amountController = TextEditingController();
  final _descController = TextEditingController(text: '마트 장보기');
  PaymentMethod _paymentMethod = PaymentMethod.card;

  // Step 2 상태
  bool _isStep2 = false;
  final List<_TransferDetail> _details = [];

  bool _loading = false;

  // 품목별 가격 합계를 계산해서 amountController에 반영
  void _syncAmountFromPrices() {
    if (!_addExpense) return;
    final total = _priceMap.values.fold<double>(0, (sum, c) {
      return sum + (double.tryParse(c.text.replaceAll(',', '').trim()) ?? 0);
    });
    if (total > 0) {
      _amountController.text = total.toInt().toString();
    }
  }

  @override
  void initState() {
    super.initState();
    for (final item in widget.items) {
      _transferMap[item.id] = null;
      final price = widget.initialPrices[item.id];
      final ctrl = TextEditingController(
        text: price != null ? price.toInt().toString() : '',
      );
      ctrl.addListener(_syncAmountFromPrices);
      _priceMap[item.id] = ctrl;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descController.dispose();
    for (final c in _priceMap.values) {
      c.dispose();
    }
    for (final d in _details) {
      d.dispose();
    }
    super.dispose();
  }

  void _goToStep2() {
    for (final d in _details) {
      d.dispose();
    }
    _details.clear();
    for (final item in widget.items) {
      final storageId = _transferMap[item.id];
      if (storageId != null) {
        _details.add(_TransferDetail(
          cartItem: item,
          storageId: storageId,
          // Step 1에서 입력한 가격을 Step 2 초기값으로 전달
          initialPrice: _priceMap[item.id]?.text.trim().isEmpty == true
              ? null
              : _priceMap[item.id]?.text.trim(),
        ));
      }
    }
    setState(() => _isStep2 = true);
  }

  Future<void> _submit() async {
    setState(() => _loading = true);
    try {
      final groupId = ref.read(fridgeSelectedGroupIdProvider);

      final transfers = _isStep2
          ? _details
              .map((d) => TransferItemDto(
                    cartItemId: d.cartItem.id,
                    storageLocationId: d.storageId,
                    quantity: int.tryParse(d.quantity.text) ?? d.cartItem.quantity,
                    price: double.tryParse(d.price.text.replaceAll(',', '').trim()),
                    expiresAt: d.expiresAt != null
                        ? DateFormat('yyyy-MM-dd').format(d.expiresAt!)
                        : null,
                    alertDaysBefore: d.expiresAt != null ? d.alertDays : null,
                  ))
              .toList()
          : _transferMap.entries
              .where((e) => e.value != null)
              .map((e) => TransferItemDto(
                    cartItemId: e.key,
                    storageLocationId: e.value!,
                    price: double.tryParse(
                        _priceMap[e.key]?.text.replaceAll(',', '').trim() ?? ''),
                  ))
              .toList();

      ShoppingExpenseDto? expense;
      if (_addExpense) {
        // amount를 직접 입력하지 않으면 null → 백엔드가 품목별 price 합계로 자동 계산
        final amount = double.tryParse(
            _amountController.text.replaceAll(',', '').trim());
        expense = ShoppingExpenseDto(
          amount: (amount != null && amount > 0) ? amount : null,
          paymentMethod: _paymentMethod,
          date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
          description: _descController.text.trim().isEmpty
              ? null
              : _descController.text.trim(),
          category: ExpenseCategory.groceries,
        );
      }

      await ref.read(cartProvider.notifier).complete(CompleteCartDto(
            groupId: groupId ?? '',
            transfers: transfers,
            expense: expense,
          ));

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('장보기가 완료되었습니다')),
        );
      }
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

    return AlertDialog(
      title: Text(_isStep2
          ? l10n.fridge_cart_complete_step2_title
          : l10n.fridge_cart_complete_title),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: _isStep2
              ? _Step2Content(details: _details, l10n: l10n)
              : _Step1Content(
                  items: widget.items,
                  transferMap: _transferMap,
                  priceMap: _priceMap,
                  addExpense: _addExpense,
                  amountController: _amountController,
                  descController: _descController,
                  paymentMethod: _paymentMethod,
                  onTransferChanged: (id, storageId) =>
                      setState(() => _transferMap[id] = storageId),
                  onAddExpenseChanged: (v) => setState(() {
                        _addExpense = v;
                        if (v) _syncAmountFromPrices();
                      }),
                  onPaymentMethodChanged: (v) =>
                      setState(() => _paymentMethod = v),
                  l10n: l10n,
                ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _loading
              ? null
              : () {
                  if (_isStep2) {
                    setState(() => _isStep2 = false);
                  } else {
                    Navigator.pop(context);
                  }
                },
          child: Text(_isStep2 ? l10n.common_back : l10n.common_cancel),
        ),
        FilledButton(
          onPressed: _loading
              ? null
              : () {
                  final hasTransfer =
                      _transferMap.values.any((v) => v != null);
                  if (!_isStep2 && hasTransfer) {
                    _goToStep2();
                  } else {
                    _submit();
                  }
                },
          child: _loading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : Text(_isStep2 || !_transferMap.values.any((v) => v != null)
                  ? l10n.fridge_cart_complete
                  : l10n.common_next),
        ),
      ],
    );
  }
}

// ── Step 1: 보관소 선택 + 가계부 ─────────────────────────────────────────────────

class _Step1Content extends ConsumerWidget {
  final List<CartItemModel> items;
  final Map<String, String?> transferMap;
  final Map<String, TextEditingController> priceMap;
  final bool addExpense;
  final TextEditingController amountController;
  final TextEditingController descController;
  final PaymentMethod paymentMethod;
  final void Function(String itemId, String? storageId) onTransferChanged;
  final ValueChanged<bool> onAddExpenseChanged;
  final ValueChanged<PaymentMethod> onPaymentMethodChanged;
  final AppLocalizations l10n;

  const _Step1Content({
    required this.items,
    required this.transferMap,
    required this.priceMap,
    required this.addExpense,
    required this.amountController,
    required this.descController,
    required this.paymentMethod,
    required this.onTransferChanged,
    required this.onAddExpenseChanged,
    required this.onPaymentMethodChanged,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storages = ref.watch(storagesProvider).value ?? [];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.fridge_cart_complete_transfer_hint,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline)),
        const SizedBox(height: AppSizes.spaceS),
        ...items.map((item) => _TransferRow(
              item: item,
              storages: storages,
              selectedStorageId: transferMap[item.id],
              priceController: priceMap[item.id]!,
              onChanged: (id) => onTransferChanged(item.id, id),
              l10n: l10n,
            )),
        const Divider(height: AppSizes.spaceL),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.fridge_cart_complete_add_expense),
          value: addExpense,
          onChanged: onAddExpenseChanged,
        ),
        if (addExpense) ...[
          TextField(
            controller: amountController,
            decoration:
                InputDecoration(labelText: l10n.fridge_cart_complete_amount),
            keyboardType:
                const TextInputType.numberWithOptions(decimal: false),
          ),
          const SizedBox(height: AppSizes.spaceS),
          TextField(
            controller: descController,
            decoration: InputDecoration(
                labelText: l10n.fridge_cart_complete_description),
          ),
          const SizedBox(height: AppSizes.spaceS),
          SegmentedButton<PaymentMethod>(
            segments: const [
              ButtonSegment(value: PaymentMethod.card, label: Text('카드')),
              ButtonSegment(value: PaymentMethod.cash, label: Text('현금')),
              ButtonSegment(
                  value: PaymentMethod.transfer, label: Text('이체')),
            ],
            selected: {paymentMethod},
            onSelectionChanged: (s) => onPaymentMethodChanged(s.first),
          ),
        ],
      ],
    );
  }
}

// ── Step 2: 이관 상세 입력 (아코디언) ────────────────────────────────────────────

class _Step2Content extends StatefulWidget {
  final List<_TransferDetail> details;
  final AppLocalizations l10n;

  const _Step2Content({required this.details, required this.l10n});

  @override
  State<_Step2Content> createState() => _Step2ContentState();
}

class _Step2ContentState extends State<_Step2Content> {
  // 펼쳐진 항목 ID 집합
  final Set<String> _expanded = {};

  void _toggle(String id) {
    setState(() {
      if (_expanded.contains(id)) {
        _expanded.remove(id);
      } else {
        _expanded.add(id);
      }
    });
  }

  Future<void> _pickDate(_TransferDetail detail) async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
          detail.expiresAt ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (picked != null) setState(() => detail.expiresAt = picked);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: widget.details.map((d) {
        final id = d.cartItem.id;
        final isExpanded = _expanded.contains(id);

        // 요약 텍스트: 수량 + 가격(입력 시) + 유통기한(입력 시)
        final summaryParts = <String>[];
        final qty = int.tryParse(d.quantity.text) ?? d.cartItem.quantity;
        final unit = d.cartItem.unit ?? '';
        summaryParts.add('$qty$unit');
        final priceText = d.price.text.trim();
        if (priceText.isNotEmpty) summaryParts.add('$priceText원');
        if (d.expiresAt != null) {
          summaryParts.add(DateFormat('MM/dd').format(d.expiresAt!));
        }

        return Card(
          margin: const EdgeInsets.only(bottom: AppSizes.spaceS),
          child: Column(
            children: [
              // ── 요약 행 (항상 표시) ──
              ListTile(
                onTap: () => _toggle(id),
                title: Text(d.cartItem.name,
                    style: Theme.of(context).textTheme.bodyLarge),
                subtitle: Text(
                  summaryParts.join('  ·  '),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                ),
                trailing: Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 20,
                ),
              ),
              // ── 펼침 폼 ──
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 200),
                crossFadeState: isExpanded
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                firstChild: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSizes.spaceM,
                    0,
                    AppSizes.spaceM,
                    AppSizes.spaceM,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(height: 1),
                      const SizedBox(height: AppSizes.spaceS),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: d.quantity,
                              decoration: InputDecoration(
                                  labelText: l10n.fridge_item_quantity,
                                  isDense: true),
                              keyboardType: TextInputType.number,
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                          const SizedBox(width: AppSizes.spaceS),
                          Expanded(
                            child: TextField(
                              controller: d.price,
                              decoration: InputDecoration(
                                labelText: l10n.fridge_cart_item_price,
                                suffixText: '원',
                                isDense: true,
                              ),
                              keyboardType: const TextInputType.numberWithOptions(
                                  decimal: false),
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.spaceS),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        title: Text(
                          d.expiresAt != null
                              ? DateFormat('yyyy-MM-dd').format(d.expiresAt!)
                              : l10n.fridge_item_expires_at,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: d.expiresAt != null
                                        ? null
                                        : Theme.of(context)
                                            .colorScheme
                                            .outline,
                                  ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (d.expiresAt != null)
                              IconButton(
                                icon: const Icon(Icons.clear, size: 18),
                                onPressed: () =>
                                    setState(() => d.expiresAt = null),
                              ),
                            const Icon(Icons.calendar_today_outlined,
                                size: 18),
                          ],
                        ),
                        onTap: () => _pickDate(d),
                      ),
                      if (d.expiresAt != null)
                        Row(
                          children: [
                            Text(l10n.fridge_item_alert_days(d.alertDays),
                                style:
                                    Theme.of(context).textTheme.bodySmall),
                            Expanded(
                              child: Slider(
                                value: d.alertDays.toDouble(),
                                min: 1,
                                max: 14,
                                divisions: 13,
                                onChanged: (v) =>
                                    setState(() => d.alertDays = v.toInt()),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                secondChild: const SizedBox.shrink(),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _TransferRow extends StatelessWidget {
  final CartItemModel item;
  final List<StorageModel> storages;
  final String? selectedStorageId;
  final TextEditingController priceController;
  final ValueChanged<String?> onChanged;
  final AppLocalizations l10n;

  const _TransferRow({
    required this.item,
    required this.storages,
    required this.selectedStorageId,
    required this.priceController,
    required this.onChanged,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceXS),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${item.name} (${item.quantity}${item.unit ?? ''})',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(width: AppSizes.spaceS),
              DropdownButton<String?>(
                value: selectedStorageId,
                hint: Text(l10n.fridge_cart_skip_transfer,
                    style: Theme.of(context).textTheme.bodySmall),
                underline: const SizedBox.shrink(),
                items: [
                  DropdownMenuItem<String?>(
                    value: null,
                    child: Text(l10n.fridge_cart_skip_transfer,
                        style: Theme.of(context).textTheme.bodySmall),
                  ),
                  ...storages.map((s) => DropdownMenuItem<String?>(
                        value: s.id,
                        child: Text(s.name,
                            style: Theme.of(context).textTheme.bodySmall),
                      )),
                ],
                onChanged: onChanged,
              ),
            ],
          ),
          SizedBox(
            width: 140,
            child: TextField(
              controller: priceController,
              decoration: InputDecoration(
                labelText: l10n.fridge_cart_item_price,
                suffixText: '원',
                isDense: true,
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: false),
            ),
          ),
        ],
      ),
    );
  }
}
