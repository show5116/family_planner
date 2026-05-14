import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/main/fridge/data/models/fridge_models.dart';
import 'package:family_planner/features/main/fridge/data/repositories/fridge_repository.dart';
import 'package:family_planner/features/main/fridge/providers/fridge_provider.dart';

class FridgeItemFormDialog extends ConsumerStatefulWidget {
  final String storageId;
  final FridgeItemModel? item;

  const FridgeItemFormDialog({
    super.key,
    required this.storageId,
    this.item,
  });

  @override
  ConsumerState<FridgeItemFormDialog> createState() =>
      _FridgeItemFormDialogState();
}

class _FridgeItemFormDialogState extends ConsumerState<FridgeItemFormDialog> {
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitController = TextEditingController();
  final _memoController = TextEditingController();
  DateTime? _expiresAt;
  int _alertDays = 3;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      final i = widget.item!;
      _nameController.text = i.name;
      _quantityController.text = i.quantity.toString();
      _unitController.text = i.unit ?? '';
      _memoController.text = i.memo ?? '';
      _expiresAt = i.expiresAt;
      _alertDays = i.alertDaysBefore;
    } else {
      _quantityController.text = '1';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _unitController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _expiresAt ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (picked != null) setState(() => _expiresAt = picked);
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    final quantity = int.tryParse(_quantityController.text) ?? 1;
    final unit =
        _unitController.text.trim().isEmpty ? null : _unitController.text.trim();
    final memo =
        _memoController.text.trim().isEmpty ? null : _memoController.text.trim();
    final expiresAtStr =
        _expiresAt != null ? DateFormat('yyyy-MM-dd').format(_expiresAt!) : null;

    setState(() => _loading = true);
    try {
      final repo = ref.read(fridgeRepositoryProvider);
      if (widget.item == null) {
        final groupId = ref.read(fridgeSelectedGroupIdProvider);
        final created = await repo.createFridgeItem(CreateFridgeItemDto(
          groupId: groupId ?? '',
          storageLocationId: widget.storageId,
          name: name,
          quantity: quantity,
          unit: unit,
          expiresAt: expiresAtStr,
          alertDaysBefore: _alertDays,
          memo: memo,
        ));
        ref.read(storagesWithItemsProvider.notifier).addItem(created);
      } else {
        final groupId = ref.read(fridgeSelectedGroupIdProvider);
        final updated = await repo.updateFridgeItem(
          widget.item!.id,
          UpdateFridgeItemDto(
            name: name,
            quantity: quantity,
            unit: unit,
            expiresAt: expiresAtStr,
            alertDaysBefore: _alertDays,
            memo: memo,
          ),
          groupId: groupId,
        );
        ref.read(storagesWithItemsProvider.notifier).updateItem(updated);
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
      title: Text(isEdit ? l10n.fridge_item_edit : l10n.fridge_item_add),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: l10n.fridge_item_name),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: AppSizes.spaceS),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _quantityController,
                    decoration:
                        InputDecoration(labelText: l10n.fridge_item_quantity),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: AppSizes.spaceS),
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _unitController,
                    decoration:
                        InputDecoration(labelText: l10n.fridge_item_unit),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spaceS),
            // 유통기한
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                _expiresAt != null
                    ? DateFormat('yyyy-MM-dd').format(_expiresAt!)
                    : l10n.fridge_item_expires_at,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: _expiresAt != null
                          ? null
                          : Theme.of(context).colorScheme.outline,
                    ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_expiresAt != null)
                    IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () => setState(() => _expiresAt = null),
                    ),
                  const Icon(Icons.calendar_today_outlined, size: 18),
                ],
              ),
              onTap: _pickDate,
            ),
            if (_expiresAt != null) ...[
              Row(
                children: [
                  Text(l10n.fridge_item_alert_days(_alertDays),
                      style: Theme.of(context).textTheme.bodySmall),
                  Expanded(
                    child: Slider(
                      value: _alertDays.toDouble(),
                      min: 1,
                      max: 14,
                      divisions: 13,
                      onChanged: (v) => setState(() => _alertDays = v.toInt()),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: AppSizes.spaceS),
            TextField(
              controller: _memoController,
              decoration: InputDecoration(labelText: l10n.fridge_item_memo),
            ),
          ],
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
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(isEdit ? l10n.common_save : l10n.common_add),
        ),
      ],
    );
  }
}
