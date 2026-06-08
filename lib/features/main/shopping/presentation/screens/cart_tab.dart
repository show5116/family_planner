import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/mixins/interstitial_ad_mixin.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/main/fridge/data/models/fridge_models.dart';
import 'package:family_planner/features/main/fridge/providers/fridge_provider.dart';
import 'package:family_planner/features/main/household/data/models/expense_model.dart';
import 'package:family_planner/features/main/household/providers/merchant_provider.dart';
import 'package:family_planner/features/onboarding/presentation/widgets/feature_coach_mark.dart';
import 'package:family_planner/features/onboarding/services/onboarding_service.dart';
import 'package:family_planner/shared/widgets/item_name_autocomplete.dart';

// ── 금액 입력 유틸 ────────────────────────────────────────────────────────────────

final _priceInputFmt = NumberFormat('#,###');

// 숫자 → 콤마 포함 문자열
String _fmtPrice(double value) => _priceInputFmt.format(value.toInt());

// 콤마 포함 문자열 → double (파싱 실패 시 null)
double? _parsePrice(String text) =>
    double.tryParse(text.replaceAll(',', '').trim());

// 컨트롤러 텍스트를 콤마 포맷으로 갱신하되 커서 위치를 유지
void _applyPriceFormat(TextEditingController ctrl) {
  final raw = ctrl.text.replaceAll(',', '');
  if (raw.isEmpty) return;
  final num = int.tryParse(raw);
  if (num == null) return;
  final formatted = _priceInputFmt.format(num);
  if (ctrl.text == formatted) return;
  final cursorFromEnd = ctrl.text.length - ctrl.selection.extentOffset;
  ctrl.text = formatted;
  final newOffset = (formatted.length - cursorFromEnd).clamp(0, formatted.length);
  ctrl.selection = TextSelection.collapsed(offset: newOffset);
}

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

  // 낙관적 UI — 서버 미저장 신규 항목 (임시 ID: __pending_N__)
  final List<CartItemModel> _pendingItems = [];
  int _pendingCounter = 0;

  // 디바운스 타이머 — 변경 후 3초 뒤 자동 동기화
  Timer? _debounce;
  bool _syncing = false;
  bool _pendingSync = false; // API 호출 중 새 변경이 생긴 경우 완료 후 재실행

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
    _debounce?.cancel();
    // dispose 시점에 미전송 변경이 있으면 ref는 아직 유효하므로 fire-and-forget
    _flushSync();
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
              description: '구매할 품목을 추가해요.\n추가하면 자동으로 저장됩니다.',
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
              description: '• 탭하면 이름·수량·메모를 수정할 수 있어요\n• ± 버튼으로 수량을 조절하세요\n• 왼쪽으로 스와이프하면 삭제돼요\n• 변경하면 잠시 후 자동으로 저장됩니다',
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

  void _syncEdits(List<CartItemModel> serverItems) {
    // 서버 항목 ID 세트 (pending ID는 __pending_ 접두사라 겹치지 않음)
    final serverIds = serverItems.map((i) => i.id).toSet();
    _edits.removeWhere((k, _) => !k.startsWith('__pending_') && !serverIds.contains(k));
    for (final item in serverItems) {
      _edits.putIfAbsent(item.id, () => _CartEditState(item));
    }
    // pending 항목도 _edits에 등록 (없는 경우만)
    for (final item in _pendingItems) {
      _edits.putIfAbsent(item.id, () => _CartEditState(item));
    }
  }

  // pending 항목 추가 — 임시 CartItemModel 생성 후 _edits 등록
  void _addPendingItem(CartItemEntryDto entry) {
    final tempId = '__pending_${_pendingCounter++}__';
    final tempItem = CartItemModel(
      id: tempId,
      cartId: '',
      name: entry.name,
      quantity: entry.quantity,
      unit: entry.unit,
      price: entry.price,
      isChecked: false,
      memo: entry.memo,
      createdAt: DateTime.now(),
    );
    _pendingItems.add(tempItem);
    _edits[tempId] = _CartEditState(tempItem);
    _scheduleSync();
    setState(() {});
  }

  // 현재 담긴 품목들의 가격 총합 (삭제 표시 제외)
  double _calcTotal(List<CartItemModel> serverItems) {
    double total = 0;
    for (final item in [...serverItems, ..._pendingItems]) {
      final e = _edits[item.id];
      if (e == null || e.markedForDelete) continue;
      total += e.totalPrice;
    }
    return total;
  }

  // 변경 발생 시 호출 — 기존 타이머를 취소하고 1.5초 뒤 동기화
  void _scheduleSync() {
    if (_syncing) {
      // API 호출 중이면 타이머 대신 플래그만 세움 — 완료 후 자동 재실행
      _pendingSync = true;
      setState(() {}); // 합계 바 즉시 반영
      return;
    }
    _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 3), _flushSync);
    setState(() {}); // 합계 바 즉시 반영 (낙관적 UI)
  }

  // 실제 API 호출
  Future<void> _flushSync() async {
    final serverItems = ref.read(cartProvider).value?.items ?? [];
    final groupId = ref.read(fridgeSelectedGroupIdProvider);

    // pending 항목 → inserts
    final inserts = _pendingItems
        .map((item) {
          final e = _edits[item.id];
          if (e == null || e.markedForDelete) return null;
          return CartItemEntryDto(
            name: e.name,
            quantity: e.quantity,
            unit: e.unit,
            memo: e.memo,
            price: e.price,
          );
        })
        .whereType<CartItemEntryDto>()
        .toList();

    final deletes = <String>[];
    final updates = <CartItemUpdateEntryDto>[];

    for (final item in serverItems) {
      final e = _edits[item.id];
      if (e == null || !e.hasChanges(item)) continue;
      if (e.markedForDelete) {
        deletes.add(item.id);
      } else {
        updates.add(CartItemUpdateEntryDto(
          id: item.id,
          name: e.name,
          quantity: e.quantity,
          unit: e.unit,
          memo: e.memo,
          price: e.price,
        ));
      }
    }

    if (inserts.isEmpty && updates.isEmpty && deletes.isEmpty) return;

    if (mounted) setState(() => _syncing = true);
    try {
      // mounted 여부와 무관하게 API는 반드시 전송
      await ref.read(cartProvider.notifier).syncCart(BulkUpdateCartItemDto(
            groupId: groupId ?? '',
            inserts: inserts.isEmpty ? null : inserts,
            updates: updates.isEmpty ? null : updates,
            deletes: deletes.isEmpty ? null : deletes,
          ));
      // 성공 시 pending 목록 제거 (서버 응답으로 _edits 재구성됨)
      _pendingItems.clear();
      _edits.clear();
    } catch (_) {
      // dispose 후에는 스낵바 표시 불가 — 조용히 무시
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('저장 중 오류가 발생했습니다')),
        );
      }
    } finally {
      if (mounted) {
        _syncing = false;
        if (_pendingSync) {
          _pendingSync = false;
          _scheduleSync();
        } else {
          setState(() {});
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizations.of(context)!;

    // 자주 사는 탭에서 추가된 pending 항목을 로컬로 흡수 — build 최상단에서 호출해야 함
    ref.listen<List<CartItemEntryDto>>(cartPendingInsertsProvider, (prev, next) {
      if (next.length > (prev?.length ?? 0)) {
        final added = next.sublist(prev?.length ?? 0);
        for (final entry in added) {
          _addPendingItem(entry);
        }
        ref.read(cartPendingInsertsProvider.notifier).state = [];
      }
    });

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
        return cartAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text(e.toString())),
          data: (cart) {
            final serverItems = cart?.items ?? [];
            _syncEdits(serverItems);

            final allItems = [...serverItems, ..._pendingItems];
            final totalCount = allItems.length;

            return Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(
                children: [
                  _TotalPriceBar(
                    total: _calcTotal(serverItems),
                    syncing: _syncing,
                  ),
                  Expanded(
                    child: totalCount == 0
                        ? _EmptyCart(l10n: l10n)
                        : ListView.builder(
                            padding: const EdgeInsets.only(bottom: 88),
                            itemCount: totalCount,
                            itemBuilder: (_, i) {
                              final item = allItems[i];
                              final editState = _edits[item.id]!;
                              final isPending = item.id.startsWith('__pending_');
                              return _CartItemTile(
                                key: ValueKey(item.id),
                                item: item,
                                editState: editState,
                                isPending: isPending,
                                onChanged: _scheduleSync,
                                onTapEdit: isPending
                                    ? null
                                    : () => _showEditBottomSheet(
                                        context, item, editState),
                                onRemove: isPending
                                    ? () {
                                        _pendingItems.removeWhere(
                                            (p) => p.id == item.id);
                                        _edits.remove(item.id);
                                        _scheduleSync();
                                      }
                                    : null,
                              );
                            },
                          ),
                  ),
                  // 하단 고정 완료 버튼
                  if (totalCount > 0)
                    _CompleteBottomBar(
                      key: _completeFabKey,
                      syncing: _syncing,
                      onTap: () => _showCompleteDialog(context, allItems),
                      l10n: l10n,
                    ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                key: _addFabKey,
                heroTag: 'cart_add',
                onPressed: () => _showAddItemDialog(context),
                child: const Icon(Icons.add),
              ),
            );
          },
        );
      },
    );
  }

  void _showAddItemDialog(BuildContext context) {
    showModalBottomSheet<CartItemEntryDto>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const _AddCartItemSheet(),
    ).then((entry) {
      if (entry != null) _addPendingItem(entry);
    });
  }

  Future<void> _showCompleteDialog(
      BuildContext context, List<CartItemModel> items) async {
    // pending 항목이 있으면 API 저장 완료 후 완료 폼 열기
    if (_pendingItems.isNotEmpty || _syncing) {
      _debounce?.cancel();
      await _flushSync();
      if (!mounted) return;
      // flush 후 서버 항목으로 다시 구성
      items = ref.read(cartProvider).value?.items ?? [];
    }

    if (!context.mounted) return;
    final prices = {
      for (final item in items)
        if (_edits[item.id]?.price != null) item.id: _edits[item.id]!.price!,
    };
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _CompleteShoppingDialog(
        items: items,
        initialPrices: prices,
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
        onSaved: _scheduleSync,
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

    final mq = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: AppSizes.spaceL,
        right: AppSizes.spaceL,
        top: AppSizes.spaceL,
        bottom: mq.viewInsets.bottom + mq.padding.bottom + AppSizes.spaceL,
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
  final bool syncing;
  const _TotalPriceBar({required this.total, this.syncing = false});

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
          if (syncing)
            SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                color: colorScheme.outline,
              ),
            ),
          if (syncing) const SizedBox(width: AppSizes.spaceS),
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

// ── 하단 고정 완료 버튼 바 ──────────────────────────────────────────────────────

class _CompleteBottomBar extends StatelessWidget {
  final bool syncing;
  final VoidCallback onTap;
  final AppLocalizations l10n;

  const _CompleteBottomBar({
    super.key,
    required this.syncing,
    required this.onTap,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
          AppSizes.spaceM, AppSizes.spaceS, AppSizes.spaceM, AppSizes.spaceM),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(color: colorScheme.outlineVariant, width: 0.5),
        ),
      ),
      child: FilledButton.icon(
        onPressed: syncing ? null : onTap,
        icon: syncing
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.check_rounded, size: 18),
        label: Text(l10n.fridge_cart_complete),
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
        ),
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

class _CartItemTile extends StatefulWidget {
  final CartItemModel item;
  final _CartEditState editState;
  final bool isPending;
  final VoidCallback onChanged;
  final VoidCallback? onTapEdit;
  final VoidCallback? onRemove; // pending 항목 제거용

  const _CartItemTile({
    super.key,
    required this.item,
    required this.editState,
    this.isPending = false,
    required this.onChanged,
    this.onTapEdit,
    this.onRemove,
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
      return _fmtPrice(_es.price! / _es.quantity);
    }
    return _fmtPrice(_es.price!);
  }

  // 컨트롤러 표시값 → editState.price(총액) 동기화
  void _syncPrice() {
    if (_ignoreListener) return;
    // 콤마 제거 후 파싱
    final entered = _parsePrice(_priceCtrl.text);
    if (entered == null) {
      _es.price = _priceCtrl.text.replaceAll(',', '').trim().isEmpty ? null : _es.price;
    } else if (_isUnitPrice) {
      _es.price = entered * _es.quantity;
    } else {
      _es.price = entered;
    }
    // 입력 중 콤마 자동 포맷 적용
    _ignoreListener = true;
    _applyPriceFormat(_priceCtrl);
    _ignoreListener = false;
    widget.onChanged();
  }

  // 수량 변경 시 단가 모드라면 총액 재계산, 컨트롤러 표시값은 그대로 유지
  void _changeQuantity(int delta) {
    _es.quantity += delta;
    if (_es.quantity == 0) _es.markedForDelete = true;
    final raw = _parsePrice(_priceCtrl.text);
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
        // 단가 → 총액
        _priceCtrl.text = _es.price != null ? _fmtPrice(_es.price!) : '';
        _isUnitPrice = false;
      } else {
        // 총액 → 단가
        if (_es.price != null && _es.quantity > 0) {
          _priceCtrl.text = _fmtPrice(_es.price! / _es.quantity);
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
        if (widget.onRemove != null) {
          // pending 항목: 즉시 제거
          widget.onRemove!();
          return true;
        }
        // 서버 항목: 삭제 표시
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
                    AppSizes.spaceM, 0, AppSizes.spaceM, AppSizes.spaceXS),
                child: Row(
                  children: [
                    SizedBox(
                      width: 150,
                      child: TextField(
                        controller: _priceCtrl,
                        decoration: InputDecoration(
                          hintText: _isUnitPrice ? '개당 금액 입력' : '총 금액 입력',
                          suffixText: _priceCtrl.text.isNotEmpty ? '원' : null,
                          helperText: priceHint,
                          helperStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: colorScheme.primary,
                              ),
                          isDense: true,
                          border: InputBorder.none,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: colorScheme.outlineVariant,
                              width: 1,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: colorScheme.primary,
                              width: 1.5,
                            ),
                          ),
                        ),
                        keyboardType:
                            TextInputType.number,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    const SizedBox(width: AppSizes.spaceS),
                    // 단가/총액 토글 — 둥근 텍스트 칩 (금액 입력 시에만 표시)
                    if (_priceCtrl.text.isNotEmpty || _isUnitPrice)
                      GestureDetector(
                        onTap: _togglePriceMode,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: _isUnitPrice
                                ? colorScheme.primaryContainer
                                : colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _isUnitPrice
                                  ? colorScheme.primary
                                  : colorScheme.outlineVariant,
                            ),
                          ),
                          child: Text(
                            _isUnitPrice ? '개당' : '총액',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: _isUnitPrice
                                      ? colorScheme.primary
                                      : colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w600,
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

// ── 품목 추가 바텀시트 ────────────────────────────────────────────────────────────

class _AddCartItemSheet extends ConsumerStatefulWidget {
  const _AddCartItemSheet();

  @override
  ConsumerState<_AddCartItemSheet> createState() => _AddCartItemSheetState();
}

class _AddCartItemSheetState extends ConsumerState<_AddCartItemSheet> {
  final _nameCtrl = TextEditingController();
  final _quantityCtrl = TextEditingController(text: '1');
  final _unitCtrl = TextEditingController();
  final _memoCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  bool _isUnitPrice = false;
  bool _showExtra = false; // 단위·메모 확장 여부

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
    final raw = _parsePrice(_priceCtrl.text);
    if (raw == null) return null;
    final qty = int.tryParse(_quantityCtrl.text.trim()) ?? 1;
    return _isUnitPrice ? raw * qty : raw;
  }

  void _submit() {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;
    final entry = CartItemEntryDto(
      name: name,
      quantity: int.tryParse(_quantityCtrl.text.trim()) ?? 1,
      unit: _unitCtrl.text.trim().isEmpty ? null : _unitCtrl.text.trim(),
      memo: _memoCtrl.text.trim().isEmpty ? null : _memoCtrl.text.trim(),
      price: _calcTotalPrice(),
    );
    if (mounted) Navigator.pop(context, entry);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final canSubmit = _nameCtrl.text.trim().isNotEmpty;
    final qty = int.tryParse(_quantityCtrl.text.trim()) ?? 1;
    final unitPrice = _parsePrice(_priceCtrl.text);
    final showTotal = _isUnitPrice && unitPrice != null && qty > 1;
    final mq = MediaQuery.of(context);
    final keyboardHeight = mq.viewInsets.bottom;
    final bottomInset = mq.padding.bottom;

    return ConstrainedBox(
      // 화면 높이의 90% 까지만 올라옴
      constraints: BoxConstraints(
        maxHeight: mq.size.height * 0.9,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 핸들
          Padding(
            padding: const EdgeInsets.only(top: AppSizes.spaceM),
            child: Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          // 스크롤 가능 폼 영역
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: AppSizes.spaceL,
                right: AppSizes.spaceL,
                top: AppSizes.spaceM,
                bottom: keyboardHeight + bottomInset + AppSizes.spaceL,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(l10n.fridge_cart_add_item,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: AppSizes.spaceM),

                  // ── 필수 필드 ──
                  ItemNameAutocomplete(
                    controller: _nameCtrl,
                    decoration: InputDecoration(labelText: l10n.fridge_item_name),
                    onChanged: (_) => setState(() {}),
                    onSubmitted: (_) => _submit(),
                    onSelected: (_) => setState(() {}),
                  ),
                  const SizedBox(height: AppSizes.spaceM),
                  Row(
                    children: [
                      Text(l10n.fridge_item_quantity,
                          style: Theme.of(context).textTheme.bodyMedium),
                      const Spacer(),
                      _QtyButton(
                        icon: Icons.remove,
                        onPressed: qty > 1
                            ? () {
                                _quantityCtrl.text = '${qty - 1}';
                                setState(() {});
                              }
                            : null,
                      ),
                      SizedBox(
                        width: 40,
                        child: Text(
                          '$qty',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                      _QtyButton(
                        icon: Icons.add,
                        onPressed: () {
                          _quantityCtrl.text = '${qty + 1}';
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.spaceM),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _priceCtrl,
                          decoration: InputDecoration(
                            labelText: _isUnitPrice ? '개당 금액' : '총 금액',
                            hintText: _isUnitPrice ? '개당 금액 입력' : '총 금액 입력',
                            suffixText: '원',
                            helperText: showTotal
                                ? '합계 ${NumberFormat('#,###').format((unitPrice * qty).toInt())}원'
                                : null,
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (_) {
                            _applyPriceFormat(_priceCtrl);
                            setState(() {});
                          },
                        ),
                      ),
                      const SizedBox(width: AppSizes.spaceM),
                      GestureDetector(
                        onTap: () => setState(() => _isUnitPrice = !_isUnitPrice),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _isUnitPrice
                                ? colorScheme.primaryContainer
                                : colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _isUnitPrice
                                  ? colorScheme.primary
                                  : colorScheme.outlineVariant,
                            ),
                          ),
                          child: Text(
                            _isUnitPrice ? '개당' : '총액',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: _isUnitPrice
                                      ? colorScheme.primary
                                      : colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // ── 선택 필드 (단위·메모) ──
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 200),
                    crossFadeState: _showExtra
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    firstChild: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: AppSizes.spaceM),
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
                      ],
                    ),
                    secondChild: const SizedBox.shrink(),
                  ),

                  // 단위·메모 토글 버튼
                  const SizedBox(height: AppSizes.spaceS),
                  GestureDetector(
                    onTap: () => setState(() => _showExtra = !_showExtra),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _showExtra ? Icons.remove_circle_outline : Icons.add_circle_outline,
                          size: 16,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _showExtra ? '단위·메모 숨기기' : '단위·메모 추가',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSizes.spaceL),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(l10n.common_cancel),
                        ),
                      ),
                      const SizedBox(width: AppSizes.spaceM),
                      Expanded(
                        flex: 2,
                        child: FilledButton(
                          onPressed: canSubmit ? _submit : null,
                          child: Text(l10n.fridge_cart_add_item),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  const _QtyButton({required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, size: 20),
      onPressed: onPressed,
      visualDensity: VisualDensity.compact,
      color: Theme.of(context).colorScheme.primary,
      disabledColor: Theme.of(context).colorScheme.outlineVariant,
    );
  }
}

// ── 이관 상세 정보 (Step 2용) ──────────────────────────────────────────────────

class _TransferDetail {
  final CartItemModel cartItem;
  String storageId;
  final TextEditingController quantity;
  DateTime? expiresAt;
  int alertDays;

  _TransferDetail({
    required this.cartItem,
    required this.storageId,
  })  : quantity = TextEditingController(text: cartItem.quantity.toString()),
        alertDays = 3;

  void dispose() {
    quantity.dispose();
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
    extends ConsumerState<_CompleteShoppingDialog>
    with InterstitialAdMixin {
  // Step 1 상태
  final Map<String, String?> _transferMap = {}; // cartItemId → storageId | null
  final Set<String> _excludedSet = {}; // 이번 완료에서 제외할 cartItemId
  bool _addExpense = false;
  final _amountController = TextEditingController();
  final _descController = TextEditingController(text: '마트 장보기');
  PaymentMethod _paymentMethod = PaymentMethod.card;
  String? _selectedMerchantId;

  // Step 2 상태
  bool _isStep2 = false;
  final List<_TransferDetail> _details = [];

  bool _loading = false;

  void _syncAmountFromPrices() {
    if (!_addExpense) return;
    final total = widget.items
        .where((item) => !_excludedSet.contains(item.id))
        .fold<double>(0, (sum, item) {
      return sum + (widget.initialPrices[item.id] ?? 0);
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
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descController.dispose();
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
      if (_excludedSet.contains(item.id)) continue;
      final storageId = _transferMap[item.id];
      if (storageId != null) {
        _details.add(_TransferDetail(
          cartItem: item,
          storageId: storageId,
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
                    price: widget.initialPrices[d.cartItem.id],
                    expiresAt: d.expiresAt != null
                        ? DateFormat('yyyy-MM-dd').format(d.expiresAt!)
                        : null,
                    alertDaysBefore: d.expiresAt != null ? d.alertDays : null,
                  ))
              .toList()
          : _transferMap.entries
              .where((e) => e.value != null && !_excludedSet.contains(e.key))
              .map((e) => TransferItemDto(
                    cartItemId: e.key,
                    storageLocationId: e.value!,
                    price: widget.initialPrices[e.key],
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
          merchantId: _selectedMerchantId,
        );
      }

      await ref.read(cartProvider.notifier).complete(CompleteCartDto(
            groupId: groupId ?? '',
            transfers: transfers,
            excludes: _excludedSet.isEmpty ? null : _excludedSet.toList(),
            expense: expense,
          ));

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        showInterstitialThenNavigate(() {
          if (mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.shopping_complete_snackbar)),
            );
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
        setState(() => _loading = false);
      } else {
        _loading = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mq = MediaQuery.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    final hasTransfer = _transferMap.values.any((v) => v != null);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, scrollController) => Column(
        children: [
          // 핸들
          Padding(
            padding: const EdgeInsets.only(top: AppSizes.spaceM, bottom: AppSizes.spaceS),
            child: Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          // 제목
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceL),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _isStep2
                        ? l10n.fridge_cart_complete_step2_title
                        : l10n.fridge_cart_complete_title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _loading ? null : () => Navigator.pop(context),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // 콘텐츠 스크롤 영역
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              padding: EdgeInsets.fromLTRB(
                AppSizes.spaceL,
                AppSizes.spaceM,
                AppSizes.spaceL,
                mq.padding.bottom + AppSizes.spaceL,
              ),
              child: _isStep2
                  ? _Step2Content(details: _details, l10n: l10n)
                  : _Step1Content(
                      items: widget.items,
                      transferMap: _transferMap,
                      excludedSet: _excludedSet,
                      addExpense: _addExpense,
                      selectedMerchantId: _selectedMerchantId,
                      amountController: _amountController,
                      descController: _descController,
                      paymentMethod: _paymentMethod,
                      onTransferChanged: (id, storageId) =>
                          setState(() => _transferMap[id] = storageId),
                      onExcludeToggled: (id) => setState(() {
                            if (_excludedSet.contains(id)) {
                              _excludedSet.remove(id);
                            } else {
                              _excludedSet.add(id);
                            }
                            _syncAmountFromPrices();
                          }),
                      onAddExpenseChanged: (v) => setState(() {
                            _addExpense = v;
                            if (v) _syncAmountFromPrices();
                          }),
                      onPaymentMethodChanged: (v) =>
                          setState(() => _paymentMethod = v),
                      onMerchantChanged: (id) =>
                          setState(() => _selectedMerchantId = id),
                      l10n: l10n,
                    ),
            ),
          ),
          // 하단 버튼 영역
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.spaceL, AppSizes.spaceS, AppSizes.spaceL, AppSizes.spaceM,
              ),
              child: Row(
                children: [
                  if (_isStep2)
                    TextButton(
                      onPressed: _loading ? null : () => setState(() => _isStep2 = false),
                      child: Text(l10n.common_back),
                    ),
                  if (_isStep2) const SizedBox(width: AppSizes.spaceS),
                  Expanded(
                    child: FilledButton(
                      onPressed: _loading
                          ? null
                          : () {
                              if (!_isStep2 && hasTransfer) {
                                _goToStep2();
                              } else {
                                _submit();
                              }
                            },
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                      ),
                      child: _loading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2))
                          : Text(_isStep2 || !hasTransfer
                              ? l10n.fridge_cart_complete
                              : l10n.common_next),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Step 1: 보관소 선택 + 가계부 ─────────────────────────────────────────────────

class _Step1Content extends ConsumerWidget {
  final List<CartItemModel> items;
  final Map<String, String?> transferMap;
  final Set<String> excludedSet;
  final bool addExpense;
  final String? selectedMerchantId;
  final TextEditingController amountController;
  final TextEditingController descController;
  final PaymentMethod paymentMethod;
  final void Function(String itemId, String? storageId) onTransferChanged;
  final ValueChanged<String> onExcludeToggled;
  final ValueChanged<bool> onAddExpenseChanged;
  final ValueChanged<PaymentMethod> onPaymentMethodChanged;
  final ValueChanged<String?> onMerchantChanged;
  final AppLocalizations l10n;

  const _Step1Content({
    required this.items,
    required this.transferMap,
    required this.excludedSet,
    required this.addExpense,
    required this.selectedMerchantId,
    required this.amountController,
    required this.descController,
    required this.paymentMethod,
    required this.onTransferChanged,
    required this.onExcludeToggled,
    required this.onAddExpenseChanged,
    required this.onPaymentMethodChanged,
    required this.onMerchantChanged,
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
              excluded: excludedSet.contains(item.id),
              onChanged: (id) => onTransferChanged(item.id, id),
              onExcludeToggled: () => onExcludeToggled(item.id),
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
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: AppSizes.spaceS),
          TextField(
            controller: descController,
            decoration: InputDecoration(
                labelText: l10n.fridge_cart_complete_description),
          ),
          const SizedBox(height: AppSizes.spaceS),
          _MerchantSelector(
            selectedId: selectedMerchantId,
            onChanged: onMerchantChanged,
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

class _Step2Content extends ConsumerStatefulWidget {
  final List<_TransferDetail> details;
  final AppLocalizations l10n;

  const _Step2Content({required this.details, required this.l10n});

  @override
  ConsumerState<_Step2Content> createState() => _Step2ContentState();
}

class _Step2ContentState extends ConsumerState<_Step2Content> {
  // 펼쳐진 항목 ID 집합
  final Set<String> _expanded = {};
  // cartItemId → 추천 유통기한 일수
  final Map<String, int?> _suggestions = {};

  void _matchAll(List<ExpiryPresetModel> presets) {
    if (presets.isEmpty) return;
    var changed = false;
    for (final d in widget.details) {
      if (_suggestions.containsKey(d.cartItem.id)) continue;
      final q = d.cartItem.name.trim().toLowerCase();
      bool hits(ExpiryPresetModel p) =>
          p.category.toLowerCase().contains(q) ||
          p.keywords.any((k) => k.toLowerCase().contains(q));
      final match = presets
          .where(hits)
          .fold<ExpiryPresetModel?>(null,
              (b, p) => b == null || p.category.length < b.category.length ? p : b);
      if (match != null) {
        _suggestions[d.cartItem.id] = match.days;
        changed = true;
      }
    }
    if (changed && mounted) setState(() {});
  }

  void _toggle(String id) {
    setState(() {
      if (_expanded.contains(id)) {
        _expanded.remove(id);
      } else {
        // 다른 항목 모두 닫고 선택한 항목만 열기
        _expanded
          ..clear()
          ..add(id);
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

    ref.listen(expiryPresetsProvider, (_, next) {
      final presets = next.valueOrNull;
      if (presets != null) _matchAll(presets);
    });

    // 이미 로드된 경우 즉시 매칭
    final loaded = ref.read(expiryPresetsProvider).valueOrNull;
    if (loaded != null && _suggestions.isEmpty) _matchAll(loaded);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: widget.details.map((d) {
        final id = d.cartItem.id;
        final isExpanded = _expanded.contains(id);

        // 요약 텍스트: 수량 + 유통기한(입력 시)
        final qty = int.tryParse(d.quantity.text) ?? d.cartItem.quantity;
        final unit = d.cartItem.unit ?? '';
        final expiryLabel = d.expiresAt != null
            ? '⏱ ${DateFormat('MM/dd').format(d.expiresAt!)}'
            : null;
        final subtitle = [
          '$qty$unit',
          if (expiryLabel != null) expiryLabel,
        ].join('  ·  ');

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
                  subtitle,
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
                      TextField(
                        controller: d.quantity,
                        decoration: InputDecoration(
                            labelText: l10n.fridge_item_quantity,
                            isDense: true),
                        keyboardType: TextInputType.number,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: AppSizes.spaceS),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        subtitle: Text(
                          l10n.fridge_item_expires_at,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                        ),
                        title: Text(
                          d.expiresAt != null
                              ? DateFormat('yyyy-MM-dd').format(d.expiresAt!)
                              : '날짜 선택',
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
                      if (d.expiresAt == null && _suggestions[d.cartItem.id] != null)
                        _SuggestionChip(
                          days: _suggestions[d.cartItem.id]!,
                          onApply: () => setState(() {
                            d.expiresAt = DateTime.now().add(
                                Duration(days: _suggestions[d.cartItem.id]!));
                          }),
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
  final bool excluded;
  final ValueChanged<String?> onChanged;
  final VoidCallback onExcludeToggled;
  final AppLocalizations l10n;

  const _TransferRow({
    required this.item,
    required this.storages,
    required this.selectedStorageId,
    required this.excluded,
    required this.onChanged,
    required this.onExcludeToggled,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final priceText = item.price != null ? _fmtPrice(item.price!) : null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceXS),
      child: Row(
        children: [
          Checkbox(
            value: !excluded,
            visualDensity: VisualDensity.compact,
            onChanged: (_) => onExcludeToggled(),
          ),
          Expanded(
            child: GestureDetector(
              onTap: onExcludeToggled,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${item.name} (${item.quantity}${item.unit ?? ''})',
                    style: textTheme.bodyMedium?.copyWith(
                      color: excluded ? colorScheme.outline : null,
                      decoration: excluded ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  if (priceText != null)
                    Text(
                      '$priceText원',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.outline,
                        decoration: excluded ? TextDecoration.lineThrough : null,
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (!excluded)
            DropdownButton<String?>(
              value: selectedStorageId,
              hint: Text(l10n.fridge_cart_skip_transfer,
                  style: textTheme.bodySmall),
              underline: const SizedBox.shrink(),
              items: [
                DropdownMenuItem<String?>(
                  value: null,
                  child: Text(l10n.fridge_cart_skip_transfer,
                      style: textTheme.bodySmall),
                ),
                ...storages.map((s) => DropdownMenuItem<String?>(
                      value: s.id,
                      child: Text(s.name, style: textTheme.bodySmall),
                    )),
              ],
              onChanged: onChanged,
            ),
        ],
      ),
    );
  }
}

// ── 소비처 선택 ───────────────────────────────────────────────────────────────────

class _MerchantSelector extends ConsumerWidget {
  final String? selectedId;
  final ValueChanged<String?> onChanged;

  const _MerchantSelector({required this.selectedId, required this.onChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final merchantsAsync = ref.watch(merchantsProvider);

    return merchantsAsync.when(
      data: (merchants) => InputDecorator(
        decoration: InputDecoration(
          labelText: l10n.household_merchant_select,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spaceM,
            vertical: AppSizes.spaceS,
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.storefront_outlined, size: 18),
            tooltip: l10n.household_merchants,
            onPressed: () => context.push(AppRoutes.householdMerchants),
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String?>(
            value: merchants.any((m) => m.id == selectedId) ? selectedId : null,
            isExpanded: true,
            isDense: true,
            hint: Text(
              merchants.isEmpty
                  ? l10n.household_merchants_empty
                  : l10n.household_merchant_none,
            ),
            items: [
              DropdownMenuItem(
                value: null,
                child: Text(l10n.household_merchant_none),
              ),
              ...merchants.map(
                (m) => DropdownMenuItem(value: m.id, child: Text(m.name)),
              ),
            ],
            onChanged: merchants.isEmpty ? null : onChanged,
          ),
        ),
      ),
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}

// ── 유통기한 추천 칩 (장보기 완료 Step 2용) ─────────────────────────────────────────

class _SuggestionChip extends StatelessWidget {
  final int days;
  final VoidCallback onApply;

  const _SuggestionChip({required this.days, required this.onApply});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final suggestedDate = DateTime.now().add(Duration(days: days));
    final dateStr = DateFormat('MM/dd').format(suggestedDate);

    return GestureDetector(
      onTap: onApply,
      child: Container(
        margin: const EdgeInsets.only(top: AppSizes.spaceXS),
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spaceS, vertical: AppSizes.spaceXS),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_awesome, size: 14, color: colorScheme.primary),
            const SizedBox(width: 4),
            Text(
              '$days일 추천  ·  $dateStr 까지  →  적용',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurface,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
