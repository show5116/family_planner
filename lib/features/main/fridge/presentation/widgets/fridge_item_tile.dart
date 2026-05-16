import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/main/fridge/data/models/fridge_models.dart';
import 'package:family_planner/features/main/fridge/data/repositories/fridge_repository.dart';
import 'package:family_planner/features/main/fridge/providers/fridge_provider.dart';
import 'package:family_planner/features/main/fridge/presentation/widgets/fridge_item_form_dialog.dart';

class FridgeItemTile extends ConsumerStatefulWidget {
  final FridgeItemModel item;
  final String storageId;

  const FridgeItemTile({
    super.key,
    required this.item,
    required this.storageId,
  });

  @override
  ConsumerState<FridgeItemTile> createState() => _FridgeItemTileState();
}

class _FridgeItemTileState extends ConsumerState<FridgeItemTile> {
  bool _loadingQuantity = false;
  bool _loadingDelete = false;

  bool get _busy => _loadingQuantity || _loadingDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final item = widget.item;
    final dday = item.daysUntilExpiry;

    final now = DateTime.now();
    final registered = item.registeredAt;
    final elapsedDays = DateTime(now.year, now.month, now.day)
        .difference(
            DateTime(registered.year, registered.month, registered.day))
        .inDays;
    final registeredLabel =
        '${registered.month}/${registered.day}  +$elapsedDays${l10n.fridge_item_elapsed_days}';

    return AbsorbPointer(
      absorbing: _busy,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spaceL, vertical: 0),
        title: Row(
          children: [
            Expanded(child: Text(item.name)),
            if (dday != null) _DdayChip(days: dday, l10n: l10n),
          ],
        ),
        subtitle: Text(
          '${item.quantity}${item.unit != null ? ' ${item.unit}' : ''}  ·  $registeredLabel',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 수량 감소
            _loadingQuantity
                ? const SizedBox(
                    width: 36,
                    height: 36,
                    child: Center(
                        child: SizedBox(
                            width: 16,
                            height: 16,
                            child:
                                CircularProgressIndicator(strokeWidth: 2))),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, size: 18),
                        onPressed: item.quantity > 0
                            ? () => _changeQuantity(item.quantity - 1)
                            : null,
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, size: 18),
                        onPressed: () => _changeQuantity(item.quantity + 1),
                      ),
                    ],
                  ),
            _loadingDelete
                ? const SizedBox(
                    width: 36,
                    height: 36,
                    child: Center(
                        child: SizedBox(
                            width: 16,
                            height: 16,
                            child:
                                CircularProgressIndicator(strokeWidth: 2))),
                  )
                : PopupMenuButton<_ItemAction>(
                    enabled: !_busy,
                    onSelected: _handleAction,
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: _ItemAction.edit,
                        child: Text(l10n.fridge_item_edit),
                      ),
                      PopupMenuItem(
                        value: _ItemAction.delete,
                        child: Text(l10n.common_delete,
                            style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.error)),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> _changeQuantity(int newQty) async {
    setState(() => _loadingQuantity = true);
    try {
      final groupId = ref.read(fridgeSelectedGroupIdProvider);
      final updated = await ref
          .read(fridgeRepositoryProvider)
          .updateFridgeItemQuantity(widget.item.id, newQty,
              groupId: groupId);
      ref.read(storagesWithItemsProvider.notifier).updateItem(updated);
      if (updated.quantity == 0) {
        ref.invalidate(cartProvider);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _loadingQuantity = false);
    }
  }

  Future<void> _handleAction(_ItemAction action) async {
    switch (action) {
      case _ItemAction.edit:
        await showDialog<void>(
          context: context,
          builder: (_) => FridgeItemFormDialog(
              storageId: widget.storageId, item: widget.item),
        );
      case _ItemAction.delete:
        setState(() => _loadingDelete = true);
        try {
          final groupId = ref.read(fridgeSelectedGroupIdProvider);
          await ref
              .read(fridgeRepositoryProvider)
              .deleteFridgeItem(widget.item.id, groupId: groupId);
          if (!mounted) return;
          ref
              .read(storagesWithItemsProvider.notifier)
              .removeItem(widget.item.id);
        } catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.toString())));
        } finally {
          if (mounted) setState(() => _loadingDelete = false);
        }
    }
  }
}

class _DdayChip extends StatelessWidget {
  final int days;
  final AppLocalizations l10n;
  const _DdayChip({required this.days, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final Color color;
    final String label;

    if (days < 0) {
      color = Theme.of(context).colorScheme.error;
      label = l10n.fridge_item_dday_expired(-days);
    } else if (days == 0) {
      color = Theme.of(context).colorScheme.error;
      label = l10n.fridge_item_dday_today;
    } else if (days <= 3) {
      color = Colors.orange;
      label = l10n.fridge_item_dday_remaining(days);
    } else {
      color = Theme.of(context).colorScheme.primary;
      label = l10n.fridge_item_dday_remaining(days);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .labelSmall
            ?.copyWith(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}

enum _ItemAction { edit, delete }
