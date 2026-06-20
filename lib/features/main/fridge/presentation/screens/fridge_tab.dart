import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/main/fridge/data/models/fridge_models.dart';
import 'package:family_planner/features/main/fridge/providers/fridge_provider.dart';
import 'package:family_planner/features/main/fridge/presentation/widgets/storage_form_dialog.dart';
import 'package:family_planner/features/main/fridge/presentation/widgets/fridge_item_form_dialog.dart';
import 'package:family_planner/features/main/fridge/presentation/widgets/fridge_item_tile.dart';
import 'package:family_planner/features/onboarding/presentation/widgets/feature_coach_mark.dart';
import 'package:family_planner/features/onboarding/services/onboarding_service.dart';
import 'package:intl/intl.dart';

part '_fridge_onboarding.dart';

// ── 정렬 방식 ──────────────────────────────────────────────────────────────────

enum FridgeSortOrder { expiry, name, registeredAt }

extension FridgeSortOrderX on FridgeSortOrder {
  String label(AppLocalizations l10n) {
    switch (this) {
      case FridgeSortOrder.expiry:
        return l10n.fridge_sort_expiry;
      case FridgeSortOrder.name:
        return l10n.fridge_sort_name;
      case FridgeSortOrder.registeredAt:
        return l10n.fridge_sort_registered;
    }
  }

  List<FridgeItemModel> sort(List<FridgeItemModel> items) {
    final sorted = [...items];
    switch (this) {
      case FridgeSortOrder.expiry:
        sorted.sort((a, b) {
          if (a.expiresAt == null && b.expiresAt == null) return 0;
          if (a.expiresAt == null) return 1;
          if (b.expiresAt == null) return -1;
          return a.expiresAt!.compareTo(b.expiresAt!);
        });
      case FridgeSortOrder.name:
        sorted.sort((a, b) => a.name.compareTo(b.name));
      case FridgeSortOrder.registeredAt:
        sorted.sort((a, b) => b.registeredAt.compareTo(a.registeredAt));
    }
    return sorted;
  }
}

// ── 탭 메인 ────────────────────────────────────────────────────────────────────

class FridgeTab extends ConsumerStatefulWidget {
  const FridgeTab({super.key, this.onReplayOnboardingReady});

  /// FridgeScreen이 튜토리얼 다시보기 콜백을 받을 수 있도록 노출
  final void Function(VoidCallback replay)? onReplayOnboardingReady;

  @override
  ConsumerState<FridgeTab> createState() => _FridgeTabState();
}

class _FridgeTabState extends ConsumerState<FridgeTab> {
  FridgeSortOrder _sortOrder = FridgeSortOrder.expiry;
  bool _deletingStorage = false;

  // ValueNotifier: setState 없이 온보딩 on/off — 코치마크 콜백 내 build 충돌 방지
  final _showDemo = ValueNotifier<bool>(false);
  final _fabKey = GlobalKey();
  final _firstSectionKey = GlobalKey();
  final _firstItemKey = GlobalKey();
  final _addItemKey = GlobalKey();
  final _ddayChipKey = GlobalKey();
  final _suggestionChipKey = GlobalKey();

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

  void _setDeletingStorage(bool value) {
    if (mounted) setState(() => _deletingStorage = value);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ValueListenableBuilder<bool>(
      valueListenable: _showDemo,
      builder: (context, isDemo, _) {
        // Pre-warm providers so autocomplete and expiry suggestion are ready before dialog opens
        ref.watch(itemNamesProvider);
        ref.watch(expiryPresetsProvider);

        final swisAsync = ref.watch(storagesWithItemsProvider);

        return Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButton: FloatingActionButton(
            key: _fabKey,
            heroTag: 'fridge_add_storage',
            onPressed: isDemo
                ? null
                : () => showDialog<void>(
                      context: context,
                      builder: (_) => const StorageFormDialog(),
                    ),
            child: const Icon(Icons.add),
          ),
          body: isDemo
              ? _OnboardingFridgeView(
                  swis: _demoSwis,
                  sortOrder: _sortOrder,
                  firstSectionKey: _firstSectionKey,
                  firstItemKey: _firstItemKey,
                  addItemKey: _addItemKey,
                  ddayChipKey: _ddayChipKey,
                  suggestionChipKey: _suggestionChipKey,
                )
              : AbsorbPointer(
                  absorbing: _deletingStorage,
                  child: swisAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(child: Text(e.toString())),
                    data: (swis) {
                      if (swis.isEmpty) {
                        return _EmptyStorageView(l10n: l10n);
                      }
                      return Column(
                        children: [
                          if (_deletingStorage)
                            const LinearProgressIndicator(),
                          _SortBar(
                            current: _sortOrder,
                            onChanged: (v) =>
                                setState(() => _sortOrder = v),
                            l10n: l10n,
                          ),
                          Expanded(
                            child: ListView.builder(
                              padding:
                                  const EdgeInsets.only(bottom: 80),
                              itemCount: swis.length,
                              itemBuilder: (context, index) =>
                                  _StorageSection(
                                swi: swis[index],
                                sortOrder: _sortOrder,
                                onDeletingChanged: _setDeletingStorage,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
        );
      },
    );
  }
}

// ── 정렬 바 ────────────────────────────────────────────────────────────────────

class _SortBar extends StatelessWidget {
  final FridgeSortOrder current;
  final ValueChanged<FridgeSortOrder> onChanged;
  final AppLocalizations l10n;

  const _SortBar({
    required this.current,
    required this.onChanged,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSizes.spaceM, AppSizes.spaceS, AppSizes.spaceS, 0),
      child: Row(
        children: [
          Icon(Icons.sort,
              size: 16, color: Theme.of(context).colorScheme.outline),
          const SizedBox(width: AppSizes.spaceS),
          ...FridgeSortOrder.values.map((order) => Padding(
                padding: const EdgeInsets.only(right: AppSizes.spaceXS),
                child: FilterChip(
                  label: Text(order.label(l10n)),
                  selected: order == current,
                  onSelected: (_) => onChanged(order),
                  visualDensity: VisualDensity.compact,
                ),
              )),
        ],
      ),
    );
  }
}

// ── 보관소 섹션 (접기/펼치기) ──────────────────────────────────────────────────

class _StorageSection extends ConsumerStatefulWidget {
  final StorageWithItemsModel swi;
  final FridgeSortOrder sortOrder;
  final ValueChanged<bool> onDeletingChanged;

  const _StorageSection({
    required this.swi,
    required this.sortOrder,
    required this.onDeletingChanged,
  });

  @override
  ConsumerState<_StorageSection> createState() => _StorageSectionState();
}

class _StorageSectionState extends ConsumerState<_StorageSection> {
  bool _expanded = true;
  bool _saving = false;
  final Map<String, FridgeItemEditState> _edits = {};

  StorageModel get storage => widget.swi.storage;

  @override
  void initState() {
    super.initState();
    _syncEdits(widget.swi.items);
  }

  @override
  void didUpdateWidget(_StorageSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncEdits(widget.swi.items);
  }

  void _syncEdits(List<FridgeItemModel> items) {
    final incoming = {for (final i in items) i.id: i};
    _edits.removeWhere((id, _) => !incoming.containsKey(id));
    for (final item in items) {
      _edits.putIfAbsent(item.id, () => FridgeItemEditState(item));
    }
  }

  bool get _hasChanges =>
      widget.swi.items.any((item) => _edits[item.id]?.hasChanges(item) == true);

  void _cancelChanges() {
    for (final item in widget.swi.items) {
      _edits[item.id] = FridgeItemEditState(item);
    }
    setState(() {});
  }

  Future<void> _save(List<FridgeItemModel> items) async {
    final groupId = ref.read(fridgeSelectedGroupIdProvider);
    if (groupId == null) return;

    final updates = <FridgeItemUpdateEntryDto>[];
    final deletes = <String>[];

    for (final item in items) {
      final es = _edits[item.id];
      if (es == null || !es.hasChanges(item)) continue;
      if (es.markedForDelete) {
        deletes.add(item.id);
      } else {
        updates.add(FridgeItemUpdateEntryDto(
          id: item.id,
          name: es.name.isEmpty ? null : es.name,
          quantity: es.quantity,
          unit: es.unit?.isEmpty == true ? null : es.unit,
          expiresAt: es.expiresAt,
          alertDaysBefore: es.alertDaysBefore,
          memo: es.memo?.isEmpty == true ? null : es.memo,
        ));
      }
    }

    setState(() => _saving = true);
    try {
      await ref.read(storagesWithItemsProvider.notifier).bulkUpdate(
            BulkUpdateFridgeItemDto(
              groupId: groupId,
              updates: updates.isEmpty ? null : updates,
              deletes: deletes.isEmpty ? null : deletes,
            ),
          );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  // 탭 → 바텀 시트로 상세 편집
  Future<void> _showEditBottomSheet(
      BuildContext context, FridgeItemModel item, FridgeItemEditState es) async {
    final l10n = AppLocalizations.of(context)!;

    // 바텀 시트용 임시 컨트롤러 (기존 es 값으로 초기화)
    final nameCtrl = TextEditingController(text: es.name);
    final unitCtrl = TextEditingController(text: es.unit ?? '');
    final memoCtrl = TextEditingController(text: es.memo ?? '');
    DateTime? expiresAt = es.expiresAt != null
        ? DateTime.tryParse(es.expiresAt!)
        : null;
    int alertDays = es.alertDaysBefore;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setInner) {
          return Padding(
            padding: EdgeInsets.only(
              left: AppSizes.spaceL,
              right: AppSizes.spaceL,
              top: AppSizes.spaceL,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + AppSizes.spaceL,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.fridge_item_edit,
                    style: Theme.of(ctx).textTheme.titleMedium),
                const SizedBox(height: AppSizes.spaceM),
                TextField(
                  controller: nameCtrl,
                  decoration:
                      InputDecoration(labelText: l10n.fridge_item_name),
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: AppSizes.spaceS),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: unitCtrl,
                        decoration:
                            InputDecoration(labelText: l10n.fridge_item_unit),
                      ),
                    ),
                    const SizedBox(width: AppSizes.spaceM),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: memoCtrl,
                        decoration:
                            InputDecoration(labelText: l10n.fridge_item_memo),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.spaceS),
                // 유통기한 선택
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    expiresAt != null
                        ? DateFormat('yyyy-MM-dd').format(expiresAt!)
                        : l10n.fridge_item_expires_at,
                    style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                          color: expiresAt != null
                              ? null
                              : Theme.of(ctx).colorScheme.outline,
                        ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (expiresAt != null)
                        IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () => setInner(() => expiresAt = null),
                        ),
                      const Icon(Icons.calendar_today_outlined, size: 18),
                    ],
                  ),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: ctx,
                      initialDate: expiresAt ??
                          DateTime.now().add(const Duration(days: 7)),
                      firstDate: DateTime.now(),
                      lastDate:
                          DateTime.now().add(const Duration(days: 3650)),
                    );
                    if (picked != null) setInner(() => expiresAt = picked);
                  },
                ),
                if (expiresAt != null)
                  Row(
                    children: [
                      Text(l10n.fridge_item_alert_days(alertDays),
                          style: Theme.of(ctx).textTheme.bodySmall),
                      Expanded(
                        child: Slider(
                          value: alertDays.toDouble(),
                          min: 1,
                          max: 14,
                          divisions: 13,
                          onChanged: (v) =>
                              setInner(() => alertDays = v.toInt()),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: AppSizes.spaceM),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: Text(l10n.common_cancel),
                    ),
                    const SizedBox(width: AppSizes.spaceS),
                    FilledButton(
                      onPressed: () {
                        // es에 바텀 시트 값 반영
                        es.name = nameCtrl.text.trim().isEmpty
                            ? item.name
                            : nameCtrl.text.trim();
                        es.unit = unitCtrl.text.trim().isEmpty
                            ? null
                            : unitCtrl.text.trim();
                        es.memo = memoCtrl.text.trim().isEmpty
                            ? null
                            : memoCtrl.text.trim();
                        es.expiresAt = expiresAt != null
                            ? DateFormat('yyyy-MM-dd').format(expiresAt!)
                            : null;
                        es.alertDaysBefore = alertDays;
                        setState(() {});
                        Navigator.pop(ctx);
                      },
                      child: Text(l10n.common_done),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );

    nameCtrl.dispose();
    unitCtrl.dispose();
    memoCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final items = widget.sortOrder.sort(widget.swi.items);
    final hasChanges = _hasChanges;

    return AbsorbPointer(
      absorbing: _saving,
      child: Card(
        margin: const EdgeInsets.symmetric(
            horizontal: AppSizes.spaceM, vertical: AppSizes.spaceS),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_saving) const LinearProgressIndicator(),
            ListTile(
              leading: Icon(_storageIcon(storage.type)),
              title: Text(storage.name,
                  style: Theme.of(context).textTheme.titleMedium),
              subtitle: Text(
                '${_storageTypeLabel(l10n, storage.type)}  ·  ${items.length}${l10n.fridge_item_count}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.add, size: 20),
                    tooltip: l10n.fridge_item_add,
                    onPressed: () => _showAddItemDialog(context, storage.id),
                  ),
                  IconButton(
                    icon: Icon(
                      _expanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _expanded = !_expanded),
                  ),
                  PopupMenuButton<_StorageAction>(
                    onSelected: _handleStorageAction,
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: _StorageAction.edit,
                        child: Text(l10n.fridge_storage_edit),
                      ),
                      PopupMenuItem(
                        value: _StorageAction.delete,
                        child: Text(l10n.fridge_storage_delete,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.error)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState: _expanded
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: Column(
                children: [
                  if (items.isEmpty)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                          AppSizes.spaceL, 0, AppSizes.spaceM, AppSizes.spaceM),
                      child: Text(l10n.fridge_empty_items,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.outline)),
                    )
                  else
                    ...items.map((item) {
                      final es = _edits[item.id];
                      if (es == null) return const SizedBox.shrink();
                      return FridgeItemTile(
                        key: ValueKey(item.id),
                        item: item,
                        editState: es,
                        onChanged: () => setState(() {}),
                        onTapEdit: () =>
                            _showEditBottomSheet(context, item, es),
                      );
                    }),
                  // 변경사항 저장/취소 바
                  if (hasChanges)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.spaceM,
                          vertical: AppSizes.spaceS),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(AppSizes.radiusMedium),
                          bottomRight: Radius.circular(AppSizes.radiusMedium),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              l10n.cart_unsaved_changes,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          TextButton(
                            onPressed: _cancelChanges,
                            child: Text(l10n.common_cancel),
                          ),
                          const SizedBox(width: AppSizes.spaceXS),
                          FilledButton(
                            onPressed: () => _save(items),
                            child: Text(l10n.common_save),
                          ),
                        ],
                      ),
                    ),
                  if (!hasChanges) const SizedBox(height: AppSizes.spaceS),
                ],
              ),
              secondChild: const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  IconData _storageIcon(StorageType type) {
    switch (type) {
      case StorageType.fridge:
        return Icons.kitchen_outlined;
      case StorageType.freezer:
        return Icons.ac_unit_outlined;
      case StorageType.pantry:
        return Icons.shelves;
    }
  }

  String _storageTypeLabel(AppLocalizations l10n, StorageType type) {
    switch (type) {
      case StorageType.fridge:
        return l10n.fridge_storage_type_fridge;
      case StorageType.freezer:
        return l10n.fridge_storage_type_freezer;
      case StorageType.pantry:
        return l10n.fridge_storage_type_pantry;
    }
  }

  void _showAddItemDialog(BuildContext context, String storageId) {
    showDialog<void>(
      context: context,
      builder: (_) => FridgeItemFormDialog(
        storageId: storageId,
        storageType: storage.type,
      ),
    );
  }

  Future<void> _handleStorageAction(_StorageAction action) async {
    final l10n = AppLocalizations.of(context)!;
    switch (action) {
      case _StorageAction.edit:
        await showDialog<void>(
          context: context,
          builder: (_) => StorageFormDialog(storage: storage),
        );
      case _StorageAction.delete:
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(l10n.fridge_storage_delete),
            content: Text(l10n.fridge_storage_delete_confirm),
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
        if (confirmed != true) return;
        widget.onDeletingChanged(true);
        try {
          await ref.read(storagesProvider.notifier).delete(storage.id);
        } finally {
          widget.onDeletingChanged(false);
        }
    }
  }
}

// ── 빈 상태 ────────────────────────────────────────────────────────────────────

class _EmptyStorageView extends StatelessWidget {
  final AppLocalizations l10n;
  const _EmptyStorageView({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.kitchen_outlined,
              size: 64, color: Theme.of(context).colorScheme.outlineVariant),
          const SizedBox(height: AppSizes.spaceM),
          Text(l10n.fridge_empty_storage,
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: AppSizes.spaceL),
          FilledButton.icon(
            onPressed: () => showDialog<void>(
              context: context,
              builder: (_) => const StorageFormDialog(),
            ),
            icon: const Icon(Icons.add),
            label: Text(l10n.fridge_storage_add),
          ),
        ],
      ),
    );
  }
}

enum _StorageAction { edit, delete }

