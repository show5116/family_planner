import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/main/fridge/data/models/fridge_models.dart';
import 'package:family_planner/features/main/fridge/providers/fridge_provider.dart';
import 'package:family_planner/features/main/fridge/presentation/widgets/storage_form_dialog.dart';
import 'package:family_planner/features/main/fridge/presentation/widgets/fridge_item_form_dialog.dart';
import 'package:family_planner/features/main/fridge/presentation/widgets/fridge_item_tile.dart';

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
  const FridgeTab({super.key});

  @override
  ConsumerState<FridgeTab> createState() => _FridgeTabState();
}

class _FridgeTabState extends ConsumerState<FridgeTab> {
  FridgeSortOrder _sortOrder = FridgeSortOrder.expiry;
  bool _deletingStorage = false;

  void _setDeletingStorage(bool value) {
    if (mounted) setState(() => _deletingStorage = value);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final swisAsync = ref.watch(storagesWithItemsProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        heroTag: 'fridge_add_storage',
        onPressed: () => showDialog<void>(
          context: context,
          builder: (_) => const StorageFormDialog(),
        ),
        child: const Icon(Icons.add),
      ),
      body: AbsorbPointer(
        absorbing: _deletingStorage,
        child: swisAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text(e.toString())),
          data: (swis) {
            if (swis.isEmpty) {
              return _EmptyStorageView(l10n: l10n);
            }
            return Column(
              children: [
                if (_deletingStorage) const LinearProgressIndicator(),
                _SortBar(
                  current: _sortOrder,
                  onChanged: (v) => setState(() => _sortOrder = v),
                  l10n: l10n,
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: swis.length,
                    itemBuilder: (context, index) => _StorageSection(
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

  StorageModel get storage => widget.swi.storage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final items = widget.sortOrder.sort(widget.swi.items);

    return Card(
      margin: const EdgeInsets.symmetric(
          horizontal: AppSizes.spaceM, vertical: AppSizes.spaceS),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.outline)),
                  )
                else
                  ...items.map((item) => FridgeItemTile(
                        item: item,
                        storageId: storage.id,
                      )),
                const SizedBox(height: AppSizes.spaceS),
              ],
            ),
            secondChild: const SizedBox.shrink(),
          ),
        ],
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
      builder: (_) => FridgeItemFormDialog(storageId: storageId),
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
