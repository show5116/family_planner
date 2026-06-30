import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/mixins/interstitial_ad_mixin.dart';
import 'package:family_planner/core/widgets/focus_dismiss_dropdown.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/main/fridge/data/models/fridge_models.dart';
import 'package:family_planner/features/main/fridge/presentation/widgets/expiry_reference_selector_sheet.dart';
import 'package:family_planner/features/main/fridge/providers/fridge_provider.dart';
import 'package:family_planner/features/main/household/data/models/expense_model.dart';
import 'package:family_planner/features/main/household/data/models/merchant_model.dart';
import 'package:family_planner/features/main/household/data/repositories/household_repository.dart';
import 'package:family_planner/features/main/household/providers/merchant_provider.dart';
import 'package:family_planner/features/onboarding/presentation/widgets/feature_coach_mark.dart';
import 'package:family_planner/features/onboarding/services/onboarding_service.dart';
import 'package:family_planner/shared/widgets/item_name_autocomplete.dart';

part '_cart_onboarding.dart';
part '_cart_item_tile.dart';
part '_cart_sheets.dart';
part '_cart_complete_dialog.dart';

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
  final _demoDialogKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    widget.onReplayOnboardingReady?.call(replayOnboarding);
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeStartOnboarding());
  }

  @override
  void dispose() {
    _debounce?.cancel();
    // ConsumerStatefulElement.unmount()은 _mounted = false 세팅 후 State.dispose()를
    // 호출하므로, dispose() 시점엔 ref가 이미 무효화된 상태임.
    // _flushSync()를 여기서 호출하면 ref.read()가 StateError를 던짐 → 제거.
    // 타이머 취소(_debounce?.cancel())로 미전송 변경이 있을 때 재시도 방지만 하면 충분.
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
          barrierDismissible: false,
          builder: (_) => _DemoCompleteDialog(dialogKey: _demoDialogKey),
        );
        // 다이얼로그가 렌더링된 후 그 위에 코치마크를 표시
        WidgetsBinding.instance.addPostFrameCallback((_) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            _showDialogCoachMark();
          });
        });
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

  Future<void> _showDialogCoachMark() async {
    if (!mounted) return;

    // 다이얼로그가 렌더링될 때까지 대기
    await FeatureCoachMark.waitForTargets([
      TargetFocus(identify: 'dialog_wait', keyTarget: _demoDialogKey),
    ], context);
    if (!mounted) return;

    final dialogPos = _keyToPosition(_demoDialogKey);
    if (dialogPos == null) return;

    void closeAndProceed() {
      if (mounted) Navigator.of(context, rootNavigator: true).pop();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.onOnboardingFinished?.call();
      });
    }

    TutorialCoachMark(
      targets: [
        TargetFocus(
          identify: 'cart_complete_dialog',
          targetPosition: dialogPos,
          shape: ShapeLightFocus.RRect,
          radius: 16,
          enableOverlayTab: true,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              builder: (_, _) => FeatureCoachMark.buildContent(
                title: '탭하면 다음 기능으로 넘어가요!',
                description: '자주 사는 물건 탭에서 더 많은 기능을 안내해 드릴게요.',
                icon: Icons.touch_app_outlined,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ],
      colorShadow: AppColors.textPrimary,
      opacityShadow: 0.75,
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
      onFinish: closeAndProceed,
      onSkip: () {
        closeAndProceed();
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
    if (!mounted) return;
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

    // build() 안의 ref.listen은 Riverpod이 빌드 사이클 종료 후 안전한 타이밍에
    // 콜백을 실행하므로 setState() 충돌 없음. initState()에서 등록하면 빌드 도중
    // 콜백이 즉시 실행돼 TabBarView의 debugCanApplyOutOfTurn() 어서션이 발생함.
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
