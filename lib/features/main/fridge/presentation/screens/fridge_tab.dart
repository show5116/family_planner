import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/main/fridge/data/models/fridge_models.dart';
import 'package:family_planner/features/main/fridge/providers/fridge_provider.dart';
import 'package:family_planner/features/main/fridge/presentation/widgets/storage_form_dialog.dart';
import 'package:family_planner/features/main/fridge/presentation/widgets/fridge_item_form_dialog.dart';
import 'package:family_planner/features/main/fridge/presentation/widgets/fridge_item_tile.dart';

/// 냉장고 탭 — 보관소별 품목 목록
class FridgeTab extends ConsumerWidget {
  const FridgeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final swisAsync = ref.watch(storagesWithItemsProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: swisAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (swis) {
          if (swis.isEmpty) {
            return _EmptyStorageView(l10n: l10n);
          }
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: swis.length,
            itemBuilder: (context, index) {
              return _StorageSection(swi: swis[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fridge_add_storage',
        onPressed: () => showDialog<void>(
          context: context,
          builder: (_) => const StorageFormDialog(),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

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
            onPressed: () => _showAddStorageDialog(context),
            icon: const Icon(Icons.add),
            label: Text(l10n.fridge_storage_add),
          ),
        ],
      ),
    );
  }

  void _showAddStorageDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => const StorageFormDialog(),
    );
  }
}

class _StorageSection extends ConsumerWidget {
  final StorageWithItemsModel swi;
  const _StorageSection({required this.swi});

  StorageModel get storage => swi.storage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final items = swi.items;

    return Card(
      margin: const EdgeInsets.symmetric(
          horizontal: AppSizes.spaceM, vertical: AppSizes.spaceS),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 보관소 헤더
          ListTile(
            leading: Icon(_storageIcon(storage.type)),
            title: Text(storage.name,
                style: Theme.of(context).textTheme.titleMedium),
            subtitle: Text(_storageTypeLabel(l10n, storage.type),
                style: Theme.of(context).textTheme.bodySmall),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.add, size: 20),
                  tooltip: l10n.fridge_item_add,
                  onPressed: () => _showAddItemDialog(context, storage.id),
                ),
                PopupMenuButton<_StorageAction>(
                  onSelected: (action) =>
                      _handleStorageAction(context, ref, action),
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
          // 품목 목록
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

  Future<void> _handleStorageAction(
      BuildContext context, WidgetRef ref, _StorageAction action) async {
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
        if (confirmed == true && context.mounted) {
          await ref.read(storagesProvider.notifier).delete(storage.id);
        }
    }
  }
}

enum _StorageAction { edit, delete }
