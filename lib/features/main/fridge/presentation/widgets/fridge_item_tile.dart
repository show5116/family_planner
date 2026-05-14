import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/main/fridge/data/models/fridge_models.dart';
import 'package:family_planner/features/main/fridge/data/repositories/fridge_repository.dart';
import 'package:family_planner/features/main/fridge/providers/fridge_provider.dart';
import 'package:family_planner/features/main/fridge/presentation/widgets/fridge_item_form_dialog.dart';

class FridgeItemTile extends ConsumerWidget {
  final FridgeItemModel item;
  final String storageId;

  const FridgeItemTile({
    super.key,
    required this.item,
    required this.storageId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final dday = item.daysUntilExpiry;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spaceL, vertical: 0),
      title: Row(
        children: [
          Expanded(child: Text(item.name)),
          if (dday != null) _DdayChip(days: dday, l10n: l10n),
        ],
      ),
      subtitle: Text(
        '${item.quantity}${item.unit != null ? ' ${item.unit}' : ''}',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 수량 감소
          IconButton(
            icon: const Icon(Icons.remove, size: 18),
            onPressed: item.quantity > 0
                ? () => _changeQuantity(ref, item.quantity - 1)
                : null,
          ),
          // 수량 증가
          IconButton(
            icon: const Icon(Icons.add, size: 18),
            onPressed: () => _changeQuantity(ref, item.quantity + 1),
          ),
          PopupMenuButton<_ItemAction>(
            onSelected: (action) =>
                _handleAction(context, ref, action),
            itemBuilder: (_) => [
              PopupMenuItem(
                value: _ItemAction.edit,
                child: Text(l10n.fridge_item_edit),
              ),
              PopupMenuItem(
                value: _ItemAction.delete,
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

  Future<void> _changeQuantity(WidgetRef ref, int newQty) async {
    final groupId = ref.read(fridgeSelectedGroupIdProvider);
    final updated = await ref
        .read(fridgeRepositoryProvider)
        .updateFridgeItemQuantity(item.id, newQty, groupId: groupId);
    ref.read(storagesWithItemsProvider.notifier).updateItem(updated);
    if (updated.quantity == 0) {
      ref.invalidate(cartProvider);
    }
  }

  Future<void> _handleAction(
      BuildContext context, WidgetRef ref, _ItemAction action) async {
    switch (action) {
      case _ItemAction.edit:
        await showDialog<void>(
          context: context,
          builder: (_) =>
              FridgeItemFormDialog(storageId: storageId, item: item),
        );
      case _ItemAction.delete:
        final groupId = ref.read(fridgeSelectedGroupIdProvider);
        await ref
            .read(fridgeRepositoryProvider)
            .deleteFridgeItem(item.id, groupId: groupId);
        ref.read(storagesWithItemsProvider.notifier).removeItem(item.id);
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
