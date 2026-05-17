import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/main/fridge/data/models/fridge_models.dart';
import 'package:family_planner/features/main/fridge/providers/fridge_provider.dart';
import 'package:family_planner/features/main/household/data/models/expense_model.dart';

// ── 로컬 편집 상태 ─────────────────────────────────────────────────────────────

class _CartEditState {
  final TextEditingController name;
  final TextEditingController quantity;
  final TextEditingController unit;
  final TextEditingController memo;
  bool markedForDelete;

  _CartEditState(CartItemModel item)
      : name = TextEditingController(text: item.name),
        quantity = TextEditingController(text: item.quantity.toString()),
        unit = TextEditingController(text: item.unit ?? ''),
        memo = TextEditingController(text: item.memo ?? ''),
        markedForDelete = false;

  void dispose() {
    name.dispose();
    quantity.dispose();
    unit.dispose();
    memo.dispose();
  }
}

// ── 탭 ─────────────────────────────────────────────────────────────────────────

class CartTab extends ConsumerStatefulWidget {
  const CartTab({super.key});

  @override
  ConsumerState<CartTab> createState() => _CartTabState();
}

class _CartTabState extends ConsumerState<CartTab> {
  // itemId → 편집 상태
  final Map<String, _CartEditState> _edits = {};
  bool _saving = false;

  @override
  void dispose() {
    for (final e in _edits.values) {
      e.dispose();
    }
    super.dispose();
  }

  void _syncEdits(List<CartItemModel> items) {
    // 새 항목에 대한 편집 상태 생성, 삭제된 항목 정리
    final ids = items.map((i) => i.id).toSet();
    final removed = _edits.keys.where((k) => !ids.contains(k)).toList();
    for (final k in removed) {
      _edits[k]!.dispose();
      _edits.remove(k);
    }
    for (final item in items) {
      _edits.putIfAbsent(item.id, () => _CartEditState(item));
    }
  }

  bool get _hasChanges {
    return _edits.values.any((e) => e.markedForDelete) ||
        _edits.entries.any((entry) {
          final item = ref
              .read(cartProvider)
              .value
              ?.items
              .firstWhere((i) => i.id == entry.key,
                  orElse: () => throw StateError(''));
          if (item == null) return false;
          final e = entry.value;
          return e.name.text.trim() != item.name ||
              e.quantity.text.trim() != item.quantity.toString() ||
              e.unit.text.trim() != (item.unit ?? '') ||
              e.memo.text.trim() != (item.memo ?? '');
        });
  }

  Future<void> _save(List<CartItemModel> items) async {
    final groupId = ref.read(fridgeSelectedGroupIdProvider);

    final deletes = _edits.entries
        .where((e) => e.value.markedForDelete)
        .map((e) => e.key)
        .toList();

    final updates = _edits.entries
        .where((e) => !e.value.markedForDelete)
        .map((entry) {
          final item = items.firstWhere((i) => i.id == entry.key,
              orElse: () => throw StateError(''));
          final e = entry.value;
          final newName = e.name.text.trim();
          final newQty = int.tryParse(e.quantity.text) ?? item.quantity;
          final newUnit = e.unit.text.trim().isEmpty ? null : e.unit.text.trim();
          final newMemo = e.memo.text.trim().isEmpty ? null : e.memo.text.trim();

          if (newName == item.name &&
              newQty == item.quantity &&
              newUnit == item.unit &&
              newMemo == item.memo) {
            return null;
          }

          return CartItemUpdateEntryDto(
            id: item.id,
            quantity: newQty != item.quantity ? newQty : null,
            unit: newUnit != item.unit ? newUnit : null,
            memo: newMemo != item.memo ? newMemo : null,
          );
        })
        .whereType<CartItemUpdateEntryDto>()
        .toList();

    if (updates.isEmpty && deletes.isEmpty) return;

    setState(() => _saving = true);
    try {
      await ref.read(cartProvider.notifier).bulkUpdate(BulkUpdateCartItemDto(
            groupId: groupId ?? '',
            updates: updates.isEmpty ? null : updates,
            deletes: deletes.isEmpty ? null : deletes,
          ));
      // 저장 후 편집 상태 초기화 (새 items로 재동기화됨)
      for (final e in _edits.values) {
        e.dispose();
      }
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
    final l10n = AppLocalizations.of(context)!;
    final cartAsync = ref.watch(cartProvider);

    return cartAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(e.toString())),
      data: (cart) {
        final items = cart?.items ?? [];
        _syncEdits(items);
        final hasChanges = _hasChanges;

        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: hasChanges
              ? AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  title: Text(l10n.cart_unsaved_changes,
                      style: Theme.of(context).textTheme.bodyMedium),
                  actions: [
                    TextButton(
                      onPressed: _saving ? null : () {
                        for (final e in _edits.values) {
                          e.dispose();
                        }
                        _edits.clear();
                        setState(() {});
                      },
                      child: Text(l10n.common_cancel),
                    ),
                    FilledButton(
                      onPressed: _saving ? null : () => _save(items),
                      child: _saving
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2))
                          : Text(l10n.common_save),
                    ),
                    const SizedBox(width: AppSizes.spaceS),
                  ],
                )
              : null,
          body: AbsorbPointer(
            absorbing: _saving,
            child: items.isEmpty
                ? _EmptyCart(l10n: l10n)
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 100),
                    itemCount: items.length,
                    itemBuilder: (_, i) {
                      final item = items[i];
                      final editState = _edits[item.id]!;
                      return _CartItemTile(
                        item: item,
                        editState: editState,
                        onChanged: () => setState(() {}),
                      );
                    },
                  ),
          ),
          floatingActionButton: hasChanges
              ? null
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FloatingActionButton.small(
                      heroTag: 'cart_add',
                      onPressed: () => _showAddItemDialog(context),
                      child: const Icon(Icons.add),
                    ),
                    const SizedBox(height: AppSizes.spaceS),
                    if (items.isNotEmpty)
                      FloatingActionButton.extended(
                        heroTag: 'cart_complete',
                        onPressed: () => _showCompleteDialog(context, items),
                        icon: const Icon(Icons.check),
                        label: Text(l10n.fridge_cart_complete),
                      ),
                  ],
                ),
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
      builder: (_) => _CompleteShoppingDialog(items: items),
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

class _CartItemTile extends StatelessWidget {
  final CartItemModel item;
  final _CartEditState editState;
  final VoidCallback onChanged;

  const _CartItemTile({
    required this.item,
    required this.editState,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final deleted = editState.markedForDelete;

    return AnimatedOpacity(
      opacity: deleted ? 0.4 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spaceM, vertical: AppSizes.spaceS),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 삭제 마킹 버튼
            IconButton(
              icon: Icon(
                deleted ? Icons.undo : Icons.delete_outline,
                color: deleted
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.error,
                size: 20,
              ),
              tooltip: deleted ? l10n.common_undo : l10n.common_delete,
              onPressed: () {
                editState.markedForDelete = !editState.markedForDelete;
                onChanged();
              },
            ),
            // 편집 필드
            Expanded(
              child: IgnorePointer(
                ignoring: deleted,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: editState.name,
                      decoration: InputDecoration(
                        labelText: l10n.fridge_item_name,
                        isDense: true,
                      ),
                      style: Theme.of(context).textTheme.bodyMedium,
                      onChanged: (_) => onChanged(),
                    ),
                    const SizedBox(height: AppSizes.spaceXS),
                    Row(
                      children: [
                        SizedBox(
                          width: 64,
                          child: TextField(
                            controller: editState.quantity,
                            decoration: InputDecoration(
                              labelText: l10n.fridge_item_quantity,
                              isDense: true,
                            ),
                            keyboardType: TextInputType.number,
                            style: Theme.of(context).textTheme.bodySmall,
                            onChanged: (_) => onChanged(),
                          ),
                        ),
                        const SizedBox(width: AppSizes.spaceS),
                        Expanded(
                          child: TextField(
                            controller: editState.unit,
                            decoration: InputDecoration(
                              labelText: l10n.fridge_item_unit,
                              isDense: true,
                            ),
                            style: Theme.of(context).textTheme.bodySmall,
                            onChanged: (_) => onChanged(),
                          ),
                        ),
                        const SizedBox(width: AppSizes.spaceS),
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: editState.memo,
                            decoration: InputDecoration(
                              labelText: l10n.fridge_item_memo,
                              isDense: true,
                            ),
                            style: Theme.of(context).textTheme.bodySmall,
                            onChanged: (_) => onChanged(),
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
      ),
    );
  }
}

// ── 품목 추가 다이얼로그 ──────────────────────────────────────────────────────────

class _CartItemEntry {
  final TextEditingController name;
  final TextEditingController quantity;
  final TextEditingController unit;
  final TextEditingController memo;

  _CartItemEntry()
      : name = TextEditingController(),
        quantity = TextEditingController(text: '1'),
        unit = TextEditingController(),
        memo = TextEditingController();

  void dispose() {
    name.dispose();
    quantity.dispose();
    unit.dispose();
    memo.dispose();
  }

  bool get hasName => name.text.trim().isNotEmpty;
}

class _AddCartItemDialog extends ConsumerStatefulWidget {
  const _AddCartItemDialog();

  @override
  ConsumerState<_AddCartItemDialog> createState() => _AddCartItemDialogState();
}

class _AddCartItemDialogState extends ConsumerState<_AddCartItemDialog> {
  final List<_CartItemEntry> _entries = [_CartItemEntry()];
  bool _loading = false;

  @override
  void dispose() {
    for (final e in _entries) {
      e.dispose();
    }
    super.dispose();
  }

  void _addEntry() {
    setState(() => _entries.add(_CartItemEntry()));
  }

  void _removeEntry(int index) {
    setState(() {
      _entries[index].dispose();
      _entries.removeAt(index);
    });
  }

  Future<void> _submit() async {
    final valid = _entries.where((e) => e.hasName).toList();
    if (valid.isEmpty) return;

    setState(() => _loading = true);
    try {
      final groupId = ref.read(fridgeSelectedGroupIdProvider);
      await ref.read(cartProvider.notifier).bulkAddItems(BulkAddCartItemDto(
            groupId: groupId ?? '',
            items: valid
                .map((e) => CartItemEntryDto(
                      name: e.name.text.trim(),
                      quantity: int.tryParse(e.quantity.text) ?? 1,
                      unit:
                          e.unit.text.trim().isEmpty ? null : e.unit.text.trim(),
                      memo:
                          e.memo.text.trim().isEmpty ? null : e.memo.text.trim(),
                    ))
                .toList(),
          ));
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
    return AlertDialog(
      title: Text(l10n.fridge_cart_add_item),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ..._entries.asMap().entries.map((entry) {
                final i = entry.key;
                final e = entry.value;
                return _CartItemEntryRow(
                  entry: e,
                  index: i,
                  showRemove: _entries.length > 1,
                  onRemove: () => _removeEntry(i),
                  l10n: l10n,
                );
              }),
              const SizedBox(height: AppSizes.spaceS),
              TextButton.icon(
                onPressed: _addEntry,
                icon: const Icon(Icons.add, size: 18),
                label: Text(l10n.common_add),
              ),
            ],
          ),
        ),
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
              : Text(l10n.common_save),
        ),
      ],
    );
  }
}

class _CartItemEntryRow extends StatelessWidget {
  final _CartItemEntry entry;
  final int index;
  final bool showRemove;
  final VoidCallback onRemove;
  final AppLocalizations l10n;

  const _CartItemEntryRow({
    required this.entry,
    required this.index,
    required this.showRemove,
    required this.onRemove,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (index > 0) const Divider(height: AppSizes.spaceM),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: entry.name,
                  decoration:
                      InputDecoration(labelText: l10n.fridge_item_name),
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
              if (showRemove)
                IconButton(
                  icon: Icon(Icons.remove_circle_outline,
                      color: Theme.of(context).colorScheme.error, size: 20),
                  onPressed: onRemove,
                ),
            ],
          ),
          const SizedBox(height: AppSizes.spaceS),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: entry.quantity,
                  decoration:
                      InputDecoration(labelText: l10n.fridge_item_quantity),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: AppSizes.spaceS),
              Expanded(
                flex: 3,
                child: TextField(
                  controller: entry.unit,
                  decoration:
                      InputDecoration(labelText: l10n.fridge_item_unit),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spaceS),
          TextField(
            controller: entry.memo,
            decoration: InputDecoration(labelText: l10n.fridge_item_memo),
          ),
        ],
      ),
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
  })  : quantity = TextEditingController(text: cartItem.quantity.toString()),
        price = TextEditingController(),
        alertDays = 3;

  void dispose() {
    quantity.dispose();
    price.dispose();
  }
}

// ── 장보기 완료 다이얼로그 ─────────────────────────────────────────────────────────

class _CompleteShoppingDialog extends ConsumerStatefulWidget {
  final List<CartItemModel> items;
  const _CompleteShoppingDialog({required this.items});

  @override
  ConsumerState<_CompleteShoppingDialog> createState() =>
      _CompleteShoppingDialogState();
}

class _CompleteShoppingDialogState
    extends ConsumerState<_CompleteShoppingDialog> {
  // Step 1 상태
  final Map<String, String?> _transferMap = {}; // cartItemId → storageId | null
  bool _addExpense = false;
  final _amountController = TextEditingController();
  final _descController = TextEditingController(text: '마트 장보기');
  PaymentMethod _paymentMethod = PaymentMethod.card;

  // Step 2 상태
  bool _isStep2 = false;
  final List<_TransferDetail> _details = [];

  bool _loading = false;

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
    // 이관할 항목만 추려서 Step2 상세 목록 구성
    for (final d in _details) {
      d.dispose();
    }
    _details.clear();
    for (final item in widget.items) {
      final storageId = _transferMap[item.id];
      if (storageId != null) {
        _details.add(_TransferDetail(cartItem: item, storageId: storageId));
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
          category: ExpenseCategory.food,
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
                  addExpense: _addExpense,
                  amountController: _amountController,
                  descController: _descController,
                  paymentMethod: _paymentMethod,
                  onTransferChanged: (id, storageId) =>
                      setState(() => _transferMap[id] = storageId),
                  onAddExpenseChanged: (v) =>
                      setState(() => _addExpense = v),
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

// ── Step 2: 이관 상세 입력 ───────────────────────────────────────────────────────

class _Step2Content extends StatefulWidget {
  final List<_TransferDetail> details;
  final AppLocalizations l10n;

  const _Step2Content({required this.details, required this.l10n});

  @override
  State<_Step2Content> createState() => _Step2ContentState();
}

class _Step2ContentState extends State<_Step2Content> {
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
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSizes.spaceM),
          child: Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.spaceM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    d.cartItem.name,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: AppSizes.spaceS),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: d.quantity,
                          decoration: InputDecoration(
                              labelText: l10n.fridge_item_quantity),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: AppSizes.spaceS),
                      Expanded(
                        child: TextField(
                          controller: d.price,
                          decoration: InputDecoration(
                              labelText: l10n.fridge_cart_item_price,
                              suffixText: '원'),
                          keyboardType: const TextInputType.numberWithOptions(decimal: false),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.spaceS),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      d.expiresAt != null
                          ? DateFormat('yyyy-MM-dd').format(d.expiresAt!)
                          : l10n.fridge_item_expires_at,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: d.expiresAt != null
                                ? null
                                : Theme.of(context).colorScheme.outline,
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
                        const Icon(Icons.calendar_today_outlined, size: 18),
                      ],
                    ),
                    onTap: () => _pickDate(d),
                  ),
                  if (d.expiresAt != null)
                    Row(
                      children: [
                        Text(l10n.fridge_item_alert_days(d.alertDays),
                            style: Theme.of(context).textTheme.bodySmall),
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
  final ValueChanged<String?> onChanged;
  final AppLocalizations l10n;

  const _TransferRow({
    required this.item,
    required this.storages,
    required this.selectedStorageId,
    required this.onChanged,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
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
    );
  }
}
