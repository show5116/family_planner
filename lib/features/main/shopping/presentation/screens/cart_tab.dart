import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/main/fridge/data/models/fridge_models.dart';
import 'package:family_planner/features/main/fridge/providers/fridge_provider.dart';
import 'package:family_planner/features/main/household/data/models/expense_model.dart';

class CartTab extends ConsumerWidget {
  const CartTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final cartAsync = ref.watch(cartProvider);

    return cartAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(e.toString())),
      data: (cart) {
        final items = cart?.items ?? [];
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: items.isEmpty
              ? _EmptyCart(l10n: l10n)
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: items.length,
                  itemBuilder: (_, i) => _CartItemTile(item: items[i]),
                ),
          floatingActionButton: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FloatingActionButton.small(
                heroTag: 'cart_add',
                onPressed: () => _showAddItemDialog(context, ref),
                child: const Icon(Icons.add),
              ),
              const SizedBox(height: AppSizes.spaceS),
              if (items.isNotEmpty)
                FloatingActionButton.extended(
                  heroTag: 'cart_complete',
                  onPressed: () => _showCompleteDialog(context, ref, items),
                  icon: const Icon(Icons.check),
                  label: Text(l10n.fridge_cart_complete),
                ),
            ],
          ),
        );
      },
    );
  }

  void _showAddItemDialog(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (_) => const _AddCartItemDialog(),
    );
  }

  void _showCompleteDialog(
      BuildContext context, WidgetRef ref, List<CartItemModel> items) {
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

class _CartItemTile extends ConsumerStatefulWidget {
  final CartItemModel item;
  const _CartItemTile({required this.item});

  @override
  ConsumerState<_CartItemTile> createState() => _CartItemTileState();
}

class _CartItemTileState extends ConsumerState<_CartItemTile> {
  bool _loadingCheck = false;
  bool _loadingDelete = false;

  bool get _busy => _loadingCheck || _loadingDelete;

  Future<void> _toggleCheck(bool value) async {
    setState(() => _loadingCheck = true);
    try {
      await ref
          .read(cartProvider.notifier)
          .toggleCheck(widget.item.id, value);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _loadingCheck = false);
    }
  }

  Future<void> _delete() async {
    setState(() => _loadingDelete = true);
    try {
      await ref.read(cartProvider.notifier).deleteItem(widget.item.id);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _loadingDelete = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final item = widget.item;

    return AbsorbPointer(
      absorbing: _busy,
      child: ListTile(
        leading: _loadingCheck
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Checkbox(
                value: item.isChecked,
                onChanged: (v) => _toggleCheck(v ?? false),
              ),
        title: Text(
          item.name,
          style: item.isChecked
              ? Theme.of(context).textTheme.bodyMedium?.copyWith(
                  decoration: TextDecoration.lineThrough,
                  color: Theme.of(context).colorScheme.outline)
              : null,
        ),
        subtitle: Text(
            '${item.quantity}${item.unit != null ? ' ${item.unit}' : ''}',
            style: Theme.of(context).textTheme.bodySmall),
        trailing: _loadingDelete
            ? const SizedBox(
                width: 36,
                height: 36,
                child: Center(
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              )
            : IconButton(
                icon: Icon(Icons.delete_outline,
                    color: Theme.of(context).colorScheme.error, size: 20),
                tooltip: l10n.common_delete,
                onPressed: _delete,
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
  // cartItemId → storageLocationId (null = 이관 안 함)
  final Map<String, String?> _transferMap = {};
  bool _addExpense = false;
  final _amountController = TextEditingController();
  final _descController = TextEditingController(text: '마트 장보기');
  PaymentMethod _paymentMethod = PaymentMethod.card;
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
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _loading = true);
    try {
      final groupId = ref.read(fridgeSelectedGroupIdProvider);

      final transfers = _transferMap.entries
          .where((e) => e.value != null)
          .map((e) => TransferItemDto(
                cartItemId: e.key,
                storageLocationId: e.value!,
              ))
          .toList();

      ShoppingExpenseDto? expense;
      if (_addExpense) {
        final amount = double.tryParse(
            _amountController.text.replaceAll(',', '').trim());
        if (amount != null && amount > 0) {
          expense = ShoppingExpenseDto(
            amount: amount,
            paymentMethod: _paymentMethod,
            date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
            description: _descController.text.trim().isEmpty
                ? null
                : _descController.text.trim(),
            category: ExpenseCategory.food,
          );
        }
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
    final storagesAsync = ref.watch(storagesProvider);
    final storages = storagesAsync.value ?? [];

    return AlertDialog(
      title: Text(l10n.fridge_cart_complete_title),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.fridge_cart_complete_transfer_hint,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline)),
              const SizedBox(height: AppSizes.spaceS),
              ...widget.items.map((item) => _TransferRow(
                    item: item,
                    storages: storages,
                    selectedStorageId: _transferMap[item.id],
                    onChanged: (id) =>
                        setState(() => _transferMap[item.id] = id),
                    l10n: l10n,
                  )),
              const Divider(height: AppSizes.spaceL),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.fridge_cart_complete_add_expense),
                value: _addExpense,
                onChanged: (v) => setState(() => _addExpense = v),
              ),
              if (_addExpense) ...[
                TextField(
                  controller: _amountController,
                  decoration: InputDecoration(
                      labelText: l10n.fridge_cart_complete_amount),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: false),
                ),
                const SizedBox(height: AppSizes.spaceS),
                TextField(
                  controller: _descController,
                  decoration: InputDecoration(
                      labelText: l10n.fridge_cart_complete_description),
                ),
                const SizedBox(height: AppSizes.spaceS),
                SegmentedButton<PaymentMethod>(
                  segments: const [
                    ButtonSegment(
                        value: PaymentMethod.card, label: Text('카드')),
                    ButtonSegment(
                        value: PaymentMethod.cash, label: Text('현금')),
                    ButtonSegment(
                        value: PaymentMethod.transfer, label: Text('이체')),
                  ],
                  selected: {_paymentMethod},
                  onSelectionChanged: (s) =>
                      setState(() => _paymentMethod = s.first),
                ),
              ],
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
              : Text(l10n.fridge_cart_complete),
        ),
      ],
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
