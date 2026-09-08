import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/child_points/data/models/childcare_model.dart';
import 'package:family_planner/features/main/child_points/data/repositories/childcare_repository.dart';
import 'package:family_planner/features/main/child_points/presentation/widgets/shop_item_list_item.dart';
import 'package:family_planner/features/main/child_points/providers/childcare_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 포인트 상점 탭
class ShopTab extends ConsumerWidget {
  const ShopTab({super.key, this.demoItems, this.demoShopKey});

  final List<ChildcareShopItem>? demoItems;
  final GlobalKey? demoShopKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    // 데모 모드: 샘플 아이템 렌더링
    if (demoItems != null) {
      return Scaffold(
        body: ListView(
          children: [
            const ShopGuide(hasItems: true),
            Column(
              key: demoShopKey,
              mainAxisSize: MainAxisSize.min,
              children: demoItems!.map(
                (item) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ShopItemListItem(item: item),
                    const Divider(height: 1),
                  ],
                ),
              ).toList(),
            ),
          ],
        ),
      );
    }

    final account = ref.watch(selectedChildAccountProvider);
    final shopAsync = ref.watch(childcareShopItemsProvider);

    if (account == null) {
      final childrenAsync = ref.watch(childcareChildrenProvider);
      return childrenAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(l10n.childcare_no_child)),
        data: (_) => Center(child: Text(l10n.childcare_no_child)),
      );
    }

    return Scaffold(
      body: shopAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return const ShopGuide(hasItems: false);
          }
          return RefreshIndicator(
            onRefresh: () =>
                ref.read(childcareShopItemsProvider.notifier).refresh(),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: const ShopGuide(hasItems: true),
                ),
                SliverReorderableList(
                  itemCount: items.length,
                  onReorderItem: (oldIndex, newIndex) {
                    if (oldIndex < newIndex) newIndex++;
                    final updated = [...items];
                    final moved = updated.removeAt(oldIndex);
                    updated.insert(newIndex, moved);
                    ref
                        .read(childcareManagementProvider.notifier)
                        .reorderShopItems(account.id, updated);
                  },
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ReorderableDragStartListener(
                      key: ValueKey(item.id),
                      index: index,
                      child: Material(
                        color: Colors.transparent,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ShopItemListItem(
                              item: item,
                              onUse: () => _confirmUseItem(
                                  context, ref, account.id, item),
                              onEdit: () => _showShopItemForm(context, ref,
                                  accountId: account.id, item: item),
                              onDelete: () =>
                                  _confirmDeleteItem(context, ref, account.id, item),
                              onToggleActive: () => ref
                                  .read(childcareManagementProvider.notifier)
                                  .updateShopItem(
                                    account.id,
                                    item.id,
                                    UpdateShopItemDto(isActive: !item.isActive),
                                  ),
                            ),
                            const Divider(height: 1),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                SliverPadding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.paddingOf(context).bottom + 80,
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const ShopGuide(hasItems: false),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: l10n.childcare_add_reward,
        onPressed: () =>
            _showShopItemForm(context, ref, accountId: account.id),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _confirmUseItem(
    BuildContext context,
    WidgetRef ref,
    String accountId,
    ChildcareShopItem item,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.childcare_item_use),
        content: Text(
          l10n.childcare_item_use_message(item.name, '${item.points}'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.common_cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.childcare_item_use_confirm),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final result = await ref.read(childcareManagementProvider.notifier).addTransaction(
          accountId,
          CreateTransactionDto.byShopItem(item.id),
        );

    if (!context.mounted) return;
    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.childcare_item_use_failed)),
      );
      return;
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
            content: Text(l10n.childcare_item_used(item.name))));
  }

  Future<void> _showShopItemForm(
    BuildContext context,
    WidgetRef ref, {
    required String accountId,
    ChildcareShopItem? item,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => ShopItemFormDialog(
        accountId: accountId,
        item: item,
        ref: ref,
      ),
    );
  }

  Future<void> _confirmDeleteItem(
    BuildContext context,
    WidgetRef ref,
    String accountId,
    ChildcareShopItem item,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.childcare_item_delete),
        content: Text(l10n.childcare_item_delete_message(item.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.common_cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.common_delete),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    final success = await ref
        .read(childcareManagementProvider.notifier)
        .deleteShopItem(accountId, item.id);
    if (!context.mounted) return;
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.childcare_delete_failed)),
      );
      return;
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l10n.common_deleted)));
  }
}

// ── 상점 아이템 폼 다이얼로그 ─────────────────────────────────────────────────────

class ShopItemFormDialog extends StatefulWidget {
  const ShopItemFormDialog({
    super.key,
    required this.accountId,
    required this.item,
    required this.ref,
  });

  final String accountId;
  final ChildcareShopItem? item;
  final WidgetRef ref;

  @override
  State<ShopItemFormDialog> createState() => _ShopItemFormDialogState();
}

class _ShopItemFormDialogState extends State<ShopItemFormDialog> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _pointsCtrl;
  bool _isSaving = false;
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.item?.name ?? '');
    _descCtrl = TextEditingController(text: widget.item?.description ?? '');
    _pointsCtrl = TextEditingController(
      text: widget.item != null ? widget.item!.points.toString() : '',
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _pointsCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final l10n = AppLocalizations.of(context)!;
    final name = _nameCtrl.text.trim();
    final points = int.tryParse(_pointsCtrl.text.trim());
    if (name.isEmpty || points == null || points <= 0) return;

    setState(() => _isSaving = true);

    final desc = _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim();
    final notifier = widget.ref.read(childcareManagementProvider.notifier);

    final Object? result;
    if (widget.item == null) {
      result = await notifier.addShopItem(
        widget.accountId,
        CreateShopItemDto(name: name, description: desc, points: points),
      );
    } else {
      result = await notifier.updateShopItem(
        widget.accountId,
        widget.item!.id,
        UpdateShopItemDto(name: name, description: desc, points: points),
      );
    }

    if (!mounted) return;

    if (result == null) {
      setState(() {
        _isSaving = false;
        _errorMsg = l10n.childcare_save_failed;
      });
      return;
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l10n.common_saved)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isNew = widget.item == null;

    return AlertDialog(
      title: Text(isNew ? l10n.childcare_item_add : l10n.childcare_item_edit),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameCtrl,
            decoration: InputDecoration(
              labelText: l10n.childcare_item_name,
              hintText: l10n.childcare_item_name_hint,
            ),
            autofocus: true,
          ),
          const SizedBox(height: AppSizes.spaceS),
          TextField(
            controller: _descCtrl,
            decoration:
                InputDecoration(labelText: l10n.childcare_reward_description),
          ),
          const SizedBox(height: AppSizes.spaceS),
          TextField(
            controller: _pointsCtrl,
            keyboardType: TextInputType.number,
            decoration:
                InputDecoration(
                    labelText: l10n.childcare_item_points, suffixText: 'P'),
          ),
          if (_errorMsg != null) ...[
            const SizedBox(height: AppSizes.spaceS),
            Text(
              _errorMsg!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.pop(context),
          child: Text(l10n.common_cancel),
        ),
        FilledButton(
          onPressed: _isSaving ? null : _handleSave,
          child: Text(isNew ? l10n.common_add : l10n.common_save),
        ),
      ],
    );
  }
}

// ── 포인트 상점 안내 카드 ─────────────────────────────────────────────────────

class ShopGuide extends StatefulWidget {
  const ShopGuide({super.key, required this.hasItems});

  final bool hasItems;

  @override
  State<ShopGuide> createState() => _ShopGuideState();
}

class _ShopGuideState extends State<ShopGuide> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = !widget.hasItems;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: Card(
        margin: const EdgeInsets.all(AppSizes.spaceM),
        color: colorScheme.surfaceContainerHighest,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spaceM,
                  vertical: AppSizes.spaceS,
                ),
                child: Row(
                  children: [
                    Icon(Icons.storefront_outlined,
                        size: 18, color: colorScheme.secondary),
                    const SizedBox(width: AppSizes.spaceS),
                    Expanded(
                      child: Text(
                        l10n.childcare_shop_help_title,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: colorScheme.secondary,
                            ),
                      ),
                    ),
                    Icon(
                      _expanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 18,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
            if (_expanded) ...[
              Divider(height: 1, color: colorScheme.outlineVariant),
              Padding(
                padding: const EdgeInsets.all(AppSizes.spaceM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.childcare_shop_help_body,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: AppSizes.spaceM),
                    Text(
                      l10n.childcare_shop_examples,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: AppSizes.spaceS),
                    ...[
                      (l10n.childcare_shop_example1, 10),
                      (l10n.childcare_shop_example2, 20),
                      (l10n.childcare_shop_example3, 15),
                      (l10n.childcare_shop_example4, 30),
                    ].map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(left: 4, bottom: 4),
                        child: Row(
                          children: [
                            Icon(Icons.storefront_outlined,
                                size: 14, color: colorScheme.secondary),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                e.$1,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color: colorScheme.onSurfaceVariant),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: colorScheme.secondaryContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${e.$2}P',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: colorScheme.secondary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.spaceS),
                    Text(
                      l10n.childcare_shop_disable_note,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
