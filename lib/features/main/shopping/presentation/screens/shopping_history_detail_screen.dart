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
        title: Text(l10n.fridge_history_delete_confirm_title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.fridge_history_delete_confirm_body),
            if (history.expense != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(ctx).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline,
                        size: 16,
                        color: Theme.of(ctx).colorScheme.onSurfaceVariant),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.fridge_history_delete_expense_notice,
                        style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                            color: Theme.of(ctx).colorScheme.onSurfaceVariant),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateStr =
        DateFormat('yyyy년 MM월 dd일 HH:mm').format(history.completedAt);

    return ListView(
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
    );
  }
}

class _HistoryItemTile extends StatelessWidget {
  final ShoppingHistoryItemModel item;
  const _HistoryItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        item.transferredToFridge
            ? Icons.kitchen_outlined
            : Icons.shopping_bag_outlined,
        color: item.transferredToFridge
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.outline,
      ),
      title: Text(item.name),
      subtitle: Text(
          '${item.quantity}${item.unit != null ? ' ${item.unit}' : ''}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (item.price != null)
            Text(
              '${NumberFormat('#,###').format(item.price!.toInt())}원',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          if (item.transferredToFridge) ...[
            if (item.price != null) const SizedBox(width: 4),
            Icon(Icons.check_circle_outline,
                color: Theme.of(context).colorScheme.primary, size: 18),
          ],
        ],
      ),
    );
  }
}
