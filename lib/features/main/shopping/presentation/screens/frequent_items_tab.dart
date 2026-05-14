import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/main/fridge/data/models/fridge_models.dart';
import 'package:family_planner/features/main/fridge/providers/fridge_provider.dart';

class FrequentItemsTab extends ConsumerWidget {
  const FrequentItemsTab({super.key});

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
            return Center(
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
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: items.length,
            itemBuilder: (_, i) => _FrequentItemTile(item: items[i]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'frequent_add',
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => const _FrequentItemFormDialog(),
    );
  }
}

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
            frequentItemId: item.id,
            name: item.name,
            quantity: 1,
            unit: item.defaultUnit,
          ));
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
