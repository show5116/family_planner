import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/main/fridge/data/models/fridge_models.dart';
import 'package:family_planner/features/main/fridge/providers/fridge_provider.dart';
import 'package:family_planner/features/main/household/providers/household_provider.dart';

class ShoppingHistoryDetailScreen extends ConsumerWidget {
  final String historyId;
  final String? groupId;
  const ShoppingHistoryDetailScreen({super.key, required this.historyId, this.groupId});

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, ShoppingHistoryModel history) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.shopping_history_delete_title),
        content: RichText(
          text: TextSpan(
            style: Theme.of(ctx).textTheme.bodyMedium,
            children: [
              TextSpan(text: '${l10n.shopping_history_delete_body}\n\n'),
              TextSpan(
                text: l10n.shopping_history_delete_notice,
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.common_cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
                foregroundColor: Theme.of(ctx).colorScheme.error),
            child: Text(l10n.common_delete),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await ref.read(shoppingHistoryProvider.notifier).delete(historyId);
    if (context.mounted) context.pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final historyAsync = ref.watch(shoppingHistoryDetailProvider((historyId, groupId)));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.fridge_tab_history),
        actions: [
          if (historyAsync.hasValue)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: l10n.fridge_history_delete,
              onPressed: () => _confirmDelete(context, ref, historyAsync.value!),
            ),
        ],
      ),
      body: historyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (history) => _HistoryDetail(history: history, l10n: l10n),
      ),
    );
  }
}

class _HistoryDetail extends ConsumerWidget {
  final ShoppingHistoryModel history;
  final AppLocalizations l10n;
  const _HistoryDetail({required this.history, required this.l10n});

  void _readdToCart(BuildContext context, WidgetRef ref) {
    final entries = history.items
        .map((item) => CartItemEntryDto(
              name: item.name,
              quantity: item.quantity,
              unit: item.unit,
              price: item.price,
            ))
        .toList();
    final current = ref.read(cartPendingInsertsProvider);
    ref.read(cartPendingInsertsProvider.notifier).state = [...current, ...entries];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.shopping_history_readd_all_snackbar(history.items.length))),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateStr =
        DateFormat('yyyy년 MM월 dd일 HH:mm').format(history.completedAt);

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppSizes.spaceM),
            children: [
              Text(dateStr, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSizes.spaceM),

              if (history.expense != null) ...[
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.receipt_outlined),
                    title: Text(
                      '${NumberFormat('#,###').format(history.expense!.amount)}원',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    subtitle: history.expense!.description != null
                        ? Text(history.expense!.description!)
                        : null,
                    trailing: TextButton(
                      onPressed: () async {
                        final expense = await ref
                            .read(expenseByIdProvider(history.expense!.id).future);
                        if (context.mounted) {
                          context.push(AppRoutes.householdDetail,
                              extra: {'expense': expense});
                        }
                      },
                      child: Text(l10n.fridge_history_view_expense),
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.spaceM),
              ],

              Text(l10n.fridge_history_items_count(history.items.length),
                  style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: AppSizes.spaceS),
              ...history.items.map((item) => _HistoryItemTile(item: item)),
            ],
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSizes.spaceM, AppSizes.spaceS, AppSizes.spaceM, AppSizes.spaceM),
            child: FilledButton.icon(
              onPressed: () => _readdToCart(context, ref),
              icon: const Icon(Icons.add_shopping_cart_outlined),
              label: Text(l10n.shopping_history_readd_all),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HistoryItemTile extends ConsumerWidget {
  final ShoppingHistoryItemModel item;
  const _HistoryItemTile({required this.item});

  void _addToCart(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final current = ref.read(cartPendingInsertsProvider);
    ref.read(cartPendingInsertsProvider.notifier).state = [
      ...current,
      CartItemEntryDto(name: item.name, quantity: item.quantity, unit: item.unit, price: item.price),
    ];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.shopping_history_readd_item_snackbar(item.name))),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final priceText = item.price != null
        ? '${NumberFormat('#,###').format(item.price!.toInt())}원'
        : null;

    return ListTile(
      leading: Tooltip(
        message: item.transferredToFridge
            ? l10n.shopping_history_fridge_transferred
            : l10n.shopping_history_fridge_not_transferred,
        child: Icon(
          item.transferredToFridge
              ? Icons.kitchen_outlined
              : Icons.shopping_bag_outlined,
          color: item.transferredToFridge
              ? colorScheme.primary
              : colorScheme.outline,
        ),
      ),
      title: Text(item.name),
      subtitle: Text(
          '${item.quantity}${item.unit != null ? ' ${item.unit}' : ''}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          priceText != null
              ? Text(
                  priceText,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.outline,
                      ),
                )
              : Text(
                  l10n.shopping_history_price_none,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.outlineVariant,
                      ),
                ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.add_shopping_cart_outlined, size: 20),
            tooltip: l10n.shopping_history_add_to_cart,
            onPressed: () => _addToCart(context, ref),
          ),
        ],
      ),
    );
  }
}
