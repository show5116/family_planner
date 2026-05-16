import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/main/fridge/data/models/fridge_models.dart';
import 'package:family_planner/features/main/fridge/data/repositories/fridge_repository.dart';
import 'package:family_planner/features/main/fridge/providers/fridge_provider.dart';

// ── 다중 추가 항목 데이터 ────────────────────────────────────────────────────────

class _FridgeItemEntry {
  final TextEditingController name;
  final TextEditingController quantity;
  final TextEditingController unit;
  final TextEditingController memo;
  DateTime? expiresAt;
  int alertDays;

  _FridgeItemEntry()
      : name = TextEditingController(),
        quantity = TextEditingController(text: '1'),
        unit = TextEditingController(),
        memo = TextEditingController(),
        alertDays = 3;

  void dispose() {
    name.dispose();
    quantity.dispose();
    unit.dispose();
    memo.dispose();
  }

  bool get hasName => name.text.trim().isNotEmpty;
}

// ── 다이얼로그 ──────────────────────────────────────────────────────────────────

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
  // 편집 모드 전용 컨트롤러
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitController = TextEditingController();
  final _memoController = TextEditingController();
  DateTime? _expiresAt;
  int _alertDays = 3;

  // 추가 모드 전용
  final List<_FridgeItemEntry> _entries = [_FridgeItemEntry()];

  bool _loading = false;

  bool get _isEdit => widget.item != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      final i = widget.item!;
      _nameController.text = i.name;
      _quantityController.text = i.quantity.toString();
      _unitController.text = i.unit ?? '';
      _memoController.text = i.memo ?? '';
      _expiresAt = i.expiresAt;
      _alertDays = i.alertDaysBefore;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _unitController.dispose();
    _memoController.dispose();
    for (final e in _entries) {
      e.dispose();
    }
    super.dispose();
  }

  void _addEntry() => setState(() => _entries.add(_FridgeItemEntry()));

  void _removeEntry(int index) {
    setState(() {
      _entries[index].dispose();
      _entries.removeAt(index);
    });
  }

  Future<void> _submit() async {
    setState(() => _loading = true);
    try {
      final repo = ref.read(fridgeRepositoryProvider);
      final groupId = ref.read(fridgeSelectedGroupIdProvider);

      if (_isEdit) {
        final name = _nameController.text.trim();
        if (name.isEmpty) return;
        final updated = await repo.updateFridgeItem(
          widget.item!.id,
          UpdateFridgeItemDto(
            name: name,
            quantity: int.tryParse(_quantityController.text) ?? 1,
            unit: _unitController.text.trim().isEmpty
                ? null
                : _unitController.text.trim(),
            expiresAt: _expiresAt != null
                ? DateFormat('yyyy-MM-dd').format(_expiresAt!)
                : null,
            alertDaysBefore: _alertDays,
            memo: _memoController.text.trim().isEmpty
                ? null
                : _memoController.text.trim(),
          ),
          groupId: groupId,
        );
        ref.read(storagesWithItemsProvider.notifier).updateItem(updated);
      } else {
        final valid = _entries.where((e) => e.hasName).toList();
        if (valid.isEmpty) return;
        final created = await repo.bulkCreateFridgeItems(BulkCreateFridgeItemDto(
          groupId: groupId ?? '',
          items: valid
              .map((e) => FridgeItemEntryDto(
                    storageLocationId: widget.storageId,
                    name: e.name.text.trim(),
                    quantity: int.tryParse(e.quantity.text) ?? 1,
                    unit: e.unit.text.trim().isEmpty ? null : e.unit.text.trim(),
                    expiresAt: e.expiresAt != null
                        ? DateFormat('yyyy-MM-dd').format(e.expiresAt!)
                        : null,
                    alertDaysBefore: e.alertDays,
                    memo:
                        e.memo.text.trim().isEmpty ? null : e.memo.text.trim(),
                  ))
              .toList(),
        ));
        ref.read(storagesWithItemsProvider.notifier).addItems(created);
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

    return AlertDialog(
      title: Text(_isEdit ? l10n.fridge_item_edit : l10n.fridge_item_add),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: _isEdit
              ? _EditForm(
                  nameController: _nameController,
                  quantityController: _quantityController,
                  unitController: _unitController,
                  memoController: _memoController,
                  expiresAt: _expiresAt,
                  alertDays: _alertDays,
                  onExpiresAtChanged: (d) => setState(() => _expiresAt = d),
                  onAlertDaysChanged: (v) => setState(() => _alertDays = v),
                  l10n: l10n,
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ..._entries.asMap().entries.map((entry) {
                      final i = entry.key;
                      final e = entry.value;
                      return _FridgeItemEntryRow(
                        entry: e,
                        index: i,
                        showRemove: _entries.length > 1,
                        onRemove: () => _removeEntry(i),
                        onChanged: () => setState(() {}),
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
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(_isEdit ? l10n.common_save : l10n.common_save),
        ),
      ],
    );
  }
}

// ── 편집 모드 폼 ────────────────────────────────────────────────────────────────

class _EditForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController quantityController;
  final TextEditingController unitController;
  final TextEditingController memoController;
  final DateTime? expiresAt;
  final int alertDays;
  final ValueChanged<DateTime?> onExpiresAtChanged;
  final ValueChanged<int> onAlertDaysChanged;
  final AppLocalizations l10n;

  const _EditForm({
    required this.nameController,
    required this.quantityController,
    required this.unitController,
    required this.memoController,
    required this.expiresAt,
    required this.alertDays,
    required this.onExpiresAtChanged,
    required this.onAlertDaysChanged,
    required this.l10n,
  });

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: expiresAt ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (picked != null) onExpiresAtChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: nameController,
          decoration: InputDecoration(labelText: l10n.fridge_item_name),
          textCapitalization: TextCapitalization.sentences,
        ),
        const SizedBox(height: AppSizes.spaceS),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                controller: quantityController,
                decoration:
                    InputDecoration(labelText: l10n.fridge_item_quantity),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: AppSizes.spaceS),
            Expanded(
              flex: 3,
              child: TextField(
                controller: unitController,
                decoration: InputDecoration(labelText: l10n.fridge_item_unit),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.spaceS),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            expiresAt != null
                ? DateFormat('yyyy-MM-dd').format(expiresAt!)
                : l10n.fridge_item_expires_at,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: expiresAt != null
                      ? null
                      : Theme.of(context).colorScheme.outline,
                ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (expiresAt != null)
                IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () => onExpiresAtChanged(null),
                ),
              const Icon(Icons.calendar_today_outlined, size: 18),
            ],
          ),
          onTap: () => _pickDate(context),
        ),
        if (expiresAt != null)
          Row(
            children: [
              Text(l10n.fridge_item_alert_days(alertDays),
                  style: Theme.of(context).textTheme.bodySmall),
              Expanded(
                child: Slider(
                  value: alertDays.toDouble(),
                  min: 1,
                  max: 14,
                  divisions: 13,
                  onChanged: (v) => onAlertDaysChanged(v.toInt()),
                ),
              ),
            ],
          ),
        const SizedBox(height: AppSizes.spaceS),
        TextField(
          controller: memoController,
          decoration: InputDecoration(labelText: l10n.fridge_item_memo),
        ),
      ],
    );
  }
}

// ── 추가 모드 개별 항목 row ──────────────────────────────────────────────────────

class _FridgeItemEntryRow extends StatefulWidget {
  final _FridgeItemEntry entry;
  final int index;
  final bool showRemove;
  final VoidCallback onRemove;
  final VoidCallback onChanged;
  final AppLocalizations l10n;

  const _FridgeItemEntryRow({
    required this.entry,
    required this.index,
    required this.showRemove,
    required this.onRemove,
    required this.onChanged,
    required this.l10n,
  });

  @override
  State<_FridgeItemEntryRow> createState() => _FridgeItemEntryRowState();
}

class _FridgeItemEntryRowState extends State<_FridgeItemEntryRow> {
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: widget.entry.expiresAt ??
          DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (picked != null) {
      setState(() => widget.entry.expiresAt = picked);
      widget.onChanged();
    }
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.entry;
    final l10n = widget.l10n;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.index > 0) const Divider(height: AppSizes.spaceM),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: e.name,
                  decoration:
                      InputDecoration(labelText: l10n.fridge_item_name),
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
              if (widget.showRemove)
                IconButton(
                  icon: Icon(Icons.remove_circle_outline,
                      color: Theme.of(context).colorScheme.error, size: 20),
                  onPressed: widget.onRemove,
                ),
            ],
          ),
          const SizedBox(height: AppSizes.spaceS),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: e.quantity,
                  decoration:
                      InputDecoration(labelText: l10n.fridge_item_quantity),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: AppSizes.spaceS),
              Expanded(
                flex: 3,
                child: TextField(
                  controller: e.unit,
                  decoration:
                      InputDecoration(labelText: l10n.fridge_item_unit),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spaceS),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              e.expiresAt != null
                  ? DateFormat('yyyy-MM-dd').format(e.expiresAt!)
                  : l10n.fridge_item_expires_at,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: e.expiresAt != null
                        ? null
                        : Theme.of(context).colorScheme.outline,
                  ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (e.expiresAt != null)
                  IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () {
                      setState(() => e.expiresAt = null);
                      widget.onChanged();
                    },
                  ),
                const Icon(Icons.calendar_today_outlined, size: 18),
              ],
            ),
            onTap: _pickDate,
          ),
          if (e.expiresAt != null)
            Row(
              children: [
                Text(l10n.fridge_item_alert_days(e.alertDays),
                    style: Theme.of(context).textTheme.bodySmall),
                Expanded(
                  child: Slider(
                    value: e.alertDays.toDouble(),
                    min: 1,
                    max: 14,
                    divisions: 13,
                    onChanged: (v) {
                      setState(() => e.alertDays = v.toInt());
                      widget.onChanged();
                    },
                  ),
                ),
              ],
            ),
          const SizedBox(height: AppSizes.spaceS),
          TextField(
            controller: e.memo,
            decoration: InputDecoration(labelText: l10n.fridge_item_memo),
          ),
        ],
      ),
    );
  }
}
