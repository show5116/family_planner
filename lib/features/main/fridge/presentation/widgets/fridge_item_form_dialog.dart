import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/main/fridge/data/models/fridge_models.dart';
import 'package:family_planner/features/main/fridge/data/repositories/fridge_repository.dart';
import 'package:family_planner/features/main/fridge/providers/fridge_provider.dart';
import 'package:family_planner/features/main/fridge/presentation/widgets/expiry_reference_selector_sheet.dart';
import 'package:family_planner/shared/widgets/item_name_autocomplete.dart';

// ── 대기 목록 항목 ───────────────────────────────────────────────────────────────

class _FridgePendingItem {
  String name;
  int quantity;
  String? unit;
  DateTime? expiresAt;
  int alertDays;
  String? memo;

  _FridgePendingItem({
    required this.name,
    required this.quantity,
    this.unit,
    this.expiresAt,
    this.alertDays = 3,
    this.memo,
  });

  String get label {
    final qty = '$quantity${unit != null ? ' $unit' : ''}';
    final exp = expiresAt != null
        ? '  📅${DateFormat('MM/dd').format(expiresAt!)}'
        : '';
    return '$name  $qty$exp';
  }
}

// ── 유통기한 추천 상태 ────────────────────────────────────────────────────────────

class _ExpirySuggestion {
  final String keyword;
  final StorageType storageType;
  final int days;
  final DateTime suggestedDate;

  const _ExpirySuggestion({
    required this.keyword,
    required this.storageType,
    required this.days,
    required this.suggestedDate,
  });
}

// ── 다이얼로그 ──────────────────────────────────────────────────────────────────

class FridgeItemFormDialog extends ConsumerStatefulWidget {
  final String storageId;
  final StorageType storageType;
  final FridgeItemModel? item;

  const FridgeItemFormDialog({
    super.key,
    required this.storageId,
    required this.storageType,
    this.item,
  });

  @override
  ConsumerState<FridgeItemFormDialog> createState() =>
      _FridgeItemFormDialogState();
}

class _FridgeItemFormDialogState extends ConsumerState<FridgeItemFormDialog> {
  // 편집 모드 전용
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitController = TextEditingController();
  final _memoController = TextEditingController();
  DateTime? _expiresAt;
  int _alertDays = 3;

  // 추가 모드: 입력 폼
  final _addNameCtrl = TextEditingController();
  final _addQuantityCtrl = TextEditingController(text: '1');
  final _addUnitCtrl = TextEditingController();
  final _addMemoCtrl = TextEditingController();
  DateTime? _addExpiresAt;
  int _addAlertDays = 3;

  // 대기 목록
  final List<_FridgePendingItem> _pending = [];

  // 유통기한 추천
  _ExpirySuggestion? _suggestion;
  Timer? _debounce;
  // expiryPresetsProvider 로드 완료 시 재매칭을 위해 현재 입력명 기억
  String _lastNameForSuggestion = '';

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
    _debounce?.cancel();
    _nameController.dispose();
    _quantityController.dispose();
    _unitController.dispose();
    _memoController.dispose();
    _addNameCtrl.dispose();
    _addQuantityCtrl.dispose();
    _addUnitCtrl.dispose();
    _addMemoCtrl.dispose();
    super.dispose();
  }

  // ── 유통기한 추천 ────────────────────────────────────────────────────────────

  void _onNameChanged(String name, StorageType storageType) {
    _lastNameForSuggestion = name.trim();
    _debounce?.cancel();
    if (name.trim().isEmpty) {
      setState(() => _suggestion = null);
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _matchSuggestion(name.trim(), storageType);
    });
  }

  void _matchSuggestion(String name, StorageType storageType) {
    final presets = ref.read(expiryPresetsProvider).valueOrNull;
    if (presets == null || presets.isEmpty) {
      setState(() => _suggestion = null);
      return;
    }

    final q = name.toLowerCase();

    // 프리셋 매칭: category 또는 keywords 중 하나라도 q를 포함하면 후보
    bool hits(ExpiryPresetModel p) =>
        p.category.toLowerCase().contains(q) ||
        p.keywords.any((k) => k.toLowerCase().contains(q));

    // 매칭된 것 중 category 길이가 짧을수록 더 구체적인 매칭으로 우선
    ExpiryPresetModel? best(Iterable<ExpiryPresetModel> candidates) =>
        candidates.fold<ExpiryPresetModel?>(
          null,
          (b, p) => b == null || p.category.length < b.category.length ? p : b,
        );

    // 1) storageType 일치 우선, 2) storageType null(무관)도 허용, 3) 전체 fallback
    ExpiryPresetModel? match =
        best(presets.where((p) => p.storageType == storageType && hits(p)));
    match ??= best(presets.where((p) => p.storageType == null && hits(p)));
    match ??= best(presets.where(hits));

    if (match == null) {
      setState(() => _suggestion = null);
      return;
    }

    setState(() {
      _suggestion = _ExpirySuggestion(
        keyword: match!.category,
        storageType: match.storageType ?? storageType,
        days: match.days,
        suggestedDate: DateTime.now().add(Duration(days: match.days)),
      );
    });
  }

  Future<void> _openReferenceSelector(BuildContext context) async {
    final result = await showModalBottomSheet<ExpiryReferenceResult>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => ExpiryReferenceSelectorSheet(
        currentStorageType: widget.storageType,
      ),
    );
    if (result == null || !mounted) return;
    setState(() {
      if (_isEdit) {
        _expiresAt = result.suggestedExpiresAt;
      } else {
        _addExpiresAt = result.suggestedExpiresAt;
      }
      _suggestion = null;
    });
  }

  // ── 대기 목록 ────────────────────────────────────────────────────────────────

  void _addToPending() {
    final name = _addNameCtrl.text.trim();
    if (name.isEmpty) return;
    setState(() {
      _pending.add(_FridgePendingItem(
        name: name,
        quantity: int.tryParse(_addQuantityCtrl.text) ?? 1,
        unit: _addUnitCtrl.text.trim().isEmpty ? null : _addUnitCtrl.text.trim(),
        expiresAt: _addExpiresAt,
        alertDays: _addAlertDays,
        memo: _addMemoCtrl.text.trim().isEmpty ? null : _addMemoCtrl.text.trim(),
      ));
      _addNameCtrl.clear();
      _addQuantityCtrl.text = '1';
      _addUnitCtrl.clear();
      _addMemoCtrl.clear();
      _addExpiresAt = null;
      _addAlertDays = 3;
      _suggestion = null;
    });
  }

  void _removePending(int index) {
    setState(() => _pending.removeAt(index));
  }

  Future<void> _editPendingDetail(BuildContext context, int index) async {
    final item = _pending[index];
    DateTime? tmpExpires = item.expiresAt;
    int tmpAlert = item.alertDays;

    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setInner) {
          final l10n = AppLocalizations.of(ctx)!;
          return AlertDialog(
            title: Text(item.name),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    tmpExpires != null
                        ? DateFormat('yyyy-MM-dd').format(tmpExpires!)
                        : l10n.fridge_item_expires_at,
                    style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                          color: tmpExpires != null
                              ? null
                              : Theme.of(ctx).colorScheme.outline,
                        ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (tmpExpires != null)
                        IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () => setInner(() => tmpExpires = null),
                        ),
                      const Icon(Icons.calendar_today_outlined, size: 18),
                    ],
                  ),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: ctx,
                      initialDate: tmpExpires ??
                          DateTime.now().add(const Duration(days: 7)),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 3650)),
                    );
                    if (picked != null) setInner(() => tmpExpires = picked);
                  },
                ),
                if (tmpExpires != null)
                  Row(
                    children: [
                      Text(l10n.fridge_item_alert_days(tmpAlert),
                          style: Theme.of(ctx).textTheme.bodySmall),
                      Expanded(
                        child: Slider(
                          value: tmpAlert.toDouble(),
                          min: 1,
                          max: 14,
                          divisions: 13,
                          onChanged: (v) => setInner(() => tmpAlert = v.toInt()),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(l10n.common_cancel),
              ),
              FilledButton(
                onPressed: () {
                  setState(() {
                    _pending[index].expiresAt = tmpExpires;
                    _pending[index].alertDays = tmpAlert;
                  });
                  Navigator.pop(ctx);
                },
                child: Text(l10n.common_done),
              ),
            ],
          );
        },
      ),
    );
  }

  // ── 저장 ─────────────────────────────────────────────────────────────────────

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
        if (_addNameCtrl.text.trim().isNotEmpty) {
          _addToPending();
        }
        if (_pending.isEmpty) return;
        final created = await repo.bulkCreateFridgeItems(
          BulkCreateFridgeItemDto(
            groupId: groupId ?? '',
            items: _pending
                .map((p) => FridgeItemEntryDto(
                      storageLocationId: widget.storageId,
                      name: p.name,
                      quantity: p.quantity,
                      unit: p.unit,
                      expiresAt: p.expiresAt != null
                          ? DateFormat('yyyy-MM-dd').format(p.expiresAt!)
                          : null,
                      alertDaysBefore: p.alertDays,
                      memo: p.memo,
                    ))
                .toList(),
          ),
        );
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

    // presets 로드 완료 시 이미 입력된 이름으로 즉시 재매칭
    ref.listen<AsyncValue<List<ExpiryPresetModel>>>(expiryPresetsProvider,
        (prev, next) {
      if (next.hasValue &&
          _lastNameForSuggestion.isNotEmpty &&
          _suggestion == null) {
        _matchSuggestion(_lastNameForSuggestion, widget.storageType);
      }
    });

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
                  suggestion: _suggestion,
                  storageType: widget.storageType,
                  onExpiresAtChanged: (d) => setState(() => _expiresAt = d),
                  onAlertDaysChanged: (v) => setState(() => _alertDays = v),
                  onNameChanged: (name) =>
                      _onNameChanged(name, widget.storageType),
                  onApplySuggestion: () => setState(() {
                    _expiresAt = _suggestion?.suggestedDate;
                    _suggestion = null;
                  }),
                  onOpenReferenceSelector: () =>
                      _openReferenceSelector(context),
                  l10n: l10n,
                )
              : _AddForm(
                  nameCtrl: _addNameCtrl,
                  quantityCtrl: _addQuantityCtrl,
                  unitCtrl: _addUnitCtrl,
                  memoCtrl: _addMemoCtrl,
                  expiresAt: _addExpiresAt,
                  alertDays: _addAlertDays,
                  pending: _pending,
                  suggestion: _suggestion,
                  storageType: widget.storageType,
                  onExpiresAtChanged: (d) =>
                      setState(() => _addExpiresAt = d),
                  onAlertDaysChanged: (v) =>
                      setState(() => _addAlertDays = v),
                  onAddToPending: _addToPending,
                  onRemovePending: _removePending,
                  onEditPendingDetail: (i) =>
                      _editPendingDetail(context, i),
                  onChanged: () => setState(() {}),
                  onNameChanged: (name) =>
                      _onNameChanged(name, widget.storageType),
                  onApplySuggestion: () => setState(() {
                    _addExpiresAt = _suggestion?.suggestedDate;
                    _suggestion = null;
                  }),
                  onOpenReferenceSelector: () =>
                      _openReferenceSelector(context),
                  l10n: l10n,
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
              : Text(l10n.common_save),
        ),
      ],
    );
  }
}

// ── 유통기한 추천 칩 ──────────────────────────────────────────────────────────────

class _ExpirysuggestionChip extends StatelessWidget {
  final _ExpirySuggestion suggestion;
  final String inputName;
  final StorageType currentStorageType;
  final VoidCallback onApply;
  final VoidCallback onManual;
  final AppLocalizations l10n;

  const _ExpirysuggestionChip({
    required this.suggestion,
    required this.inputName,
    required this.currentStorageType,
    required this.onApply,
    required this.onManual,
    required this.l10n,
  });

  String _storageLabel(StorageType type) {
    switch (type) {
      case StorageType.fridge:
        return l10n.fridge_storage_type_fridge;
      case StorageType.freezer:
        return l10n.fridge_storage_type_freezer;
      case StorageType.pantry:
        return l10n.fridge_storage_type_pantry;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final baseStyle = Theme.of(context).textTheme.labelMedium?.copyWith(
          color: colorScheme.onSurface,
        );

    final storageLabel = _storageLabel(suggestion.storageType);
    final storageMismatch = suggestion.storageType != currentStorageType;

    // 입력한 이름과 keyword가 다를 때 "양파 → 파 기준" 형태로 표시
    final displayKeyword = inputName.trim().isNotEmpty &&
            inputName.trim() != suggestion.keyword
        ? '${inputName.trim()} → ${suggestion.keyword}'
        : suggestion.keyword;

    // fridge_expiry_suggestion_label: "{keyword} 기준 · {storageType} {days}일 추천"
    // storageType 부분만 색을 다르게 줘야 하므로 RichText로 분리
    final beforeStorage = '$displayKeyword 기준 · ';
    final afterStorage = ' ${suggestion.days}일 추천';

    return Container(
      margin: const EdgeInsets.only(top: AppSizes.spaceXS),
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
            child: RichText(
              text: TextSpan(
                style: baseStyle,
                children: [
                  TextSpan(text: beforeStorage),
                  TextSpan(
                    text: storageLabel,
                    style: storageMismatch
                        ? baseStyle?.copyWith(
                            color: colorScheme.error,
                            fontWeight: FontWeight.bold,
                          )
                        : null,
                  ),
                  TextSpan(text: afterStorage),
                ],
              ),
            ),
          ),
          const SizedBox(width: AppSizes.spaceXS),
          FilledButton(
            onPressed: onApply,
            style: FilledButton.styleFrom(
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceS),
            ),
            child: Text(
              l10n.fridge_expiry_apply,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colorScheme.onPrimary,
                  ),
            ),
          ),
        ],
      ),
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
  final _ExpirySuggestion? suggestion;
  final StorageType storageType;
  final ValueChanged<DateTime?> onExpiresAtChanged;
  final ValueChanged<int> onAlertDaysChanged;
  final ValueChanged<String> onNameChanged;
  final VoidCallback onApplySuggestion;
  final VoidCallback onOpenReferenceSelector;
  final AppLocalizations l10n;

  const _EditForm({
    required this.nameController,
    required this.quantityController,
    required this.unitController,
    required this.memoController,
    required this.expiresAt,
    required this.alertDays,
    required this.suggestion,
    required this.storageType,
    required this.onExpiresAtChanged,
    required this.onAlertDaysChanged,
    required this.onNameChanged,
    required this.onApplySuggestion,
    required this.onOpenReferenceSelector,
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
          onChanged: onNameChanged,
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
              IconButton(
                tooltip: l10n.fridge_expiry_change_reference,
                icon: const Icon(Icons.search, size: 18),
                onPressed: onOpenReferenceSelector,
              ),
            ],
          ),
          onTap: () => _pickDate(context),
        ),
        // 유통기한 추천 칩
        if (suggestion != null && expiresAt == null)
          _ExpirysuggestionChip(
            suggestion: suggestion!,
            inputName: nameController.text,
            currentStorageType: storageType,
            onApply: onApplySuggestion,
            onManual: () => _pickDate(context),
            l10n: l10n,
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

// ── 추가 모드 폼 (입력 + 대기 목록) ─────────────────────────────────────────────

class _AddForm extends ConsumerWidget {
  final TextEditingController nameCtrl;
  final TextEditingController quantityCtrl;
  final TextEditingController unitCtrl;
  final TextEditingController memoCtrl;
  final DateTime? expiresAt;
  final int alertDays;
  final List<_FridgePendingItem> pending;
  final _ExpirySuggestion? suggestion;
  final StorageType storageType;
  final ValueChanged<DateTime?> onExpiresAtChanged;
  final ValueChanged<int> onAlertDaysChanged;
  final VoidCallback onAddToPending;
  final ValueChanged<int> onRemovePending;
  final ValueChanged<int> onEditPendingDetail;
  final VoidCallback onChanged;
  final ValueChanged<String> onNameChanged;
  final VoidCallback onApplySuggestion;
  final VoidCallback onOpenReferenceSelector;
  final AppLocalizations l10n;

  const _AddForm({
    required this.nameCtrl,
    required this.quantityCtrl,
    required this.unitCtrl,
    required this.memoCtrl,
    required this.expiresAt,
    required this.alertDays,
    required this.pending,
    required this.suggestion,
    required this.storageType,
    required this.onExpiresAtChanged,
    required this.onAlertDaysChanged,
    required this.onAddToPending,
    required this.onRemovePending,
    required this.onEditPendingDetail,
    required this.onChanged,
    required this.onNameChanged,
    required this.onApplySuggestion,
    required this.onOpenReferenceSelector,
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
  Widget build(BuildContext context, WidgetRef ref) {
    final canAdd = nameCtrl.text.trim().isNotEmpty;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── 입력 폼 ──
        ItemNameAutocomplete(
          controller: nameCtrl,
          decoration: InputDecoration(labelText: l10n.fridge_item_name),
          onChanged: (v) {
            onChanged();
            onNameChanged(v);
          },
          onSubmitted: (_) => onAddToPending(),
          onSelected: (v) {
            onChanged();
            onNameChanged(v);
          },
        ),
        const SizedBox(height: AppSizes.spaceS),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                controller: quantityCtrl,
                decoration:
                    InputDecoration(labelText: l10n.fridge_item_quantity),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: AppSizes.spaceS),
            Expanded(
              flex: 3,
              child: TextField(
                controller: unitCtrl,
                decoration: InputDecoration(labelText: l10n.fridge_item_unit),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.spaceS),
        // 유통기한 선택
        ListTile(
          contentPadding: EdgeInsets.zero,
          dense: true,
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
              IconButton(
                tooltip: l10n.fridge_expiry_change_reference,
                icon: const Icon(Icons.search, size: 18),
                onPressed: onOpenReferenceSelector,
              ),
            ],
          ),
          onTap: () => _pickDate(context),
        ),
        // 유통기한 추천 칩 (날짜 미선택 상태에서만 표시)
        if (suggestion != null && expiresAt == null)
          _ExpirysuggestionChip(
            suggestion: suggestion!,
            inputName: nameCtrl.text,
            currentStorageType: storageType,
            onApply: onApplySuggestion,
            onManual: () => _pickDate(context),
            l10n: l10n,
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
        const SizedBox(height: AppSizes.spaceXS),
        TextField(
          controller: memoCtrl,
          decoration: InputDecoration(labelText: l10n.fridge_item_memo),
        ),
        const SizedBox(height: AppSizes.spaceS),
        // 목록에 담기 버튼
        OutlinedButton.icon(
          onPressed: canAdd ? onAddToPending : null,
          icon: const Icon(Icons.playlist_add, size: 18),
          label: Text(l10n.common_add_to_list),
        ),
        // ── 대기 목록 ──
        if (pending.isNotEmpty) ...[
          const SizedBox(height: AppSizes.spaceM),
          const Divider(height: 1),
          const SizedBox(height: AppSizes.spaceS),
          Wrap(
            spacing: AppSizes.spaceXS,
            runSpacing: AppSizes.spaceXS,
            children: pending.asMap().entries.map((entry) {
              final i = entry.key;
              final p = entry.value;
              return GestureDetector(
                onTap: () => onEditPendingDetail(i),
                child: Chip(
                  label: Text(p.label,
                      style: Theme.of(context).textTheme.labelMedium),
                  deleteIcon: const Icon(Icons.close, size: 16),
                  onDeleted: () => onRemovePending(i),
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
