import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/main/fridge/data/models/fridge_models.dart';
import 'package:family_planner/features/main/fridge/providers/fridge_provider.dart';

class ShoppingHistoryDetailScreen extends ConsumerWidget {
  final String historyId;
  const ShoppingHistoryDetailScreen({super.key, required this.historyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final historyAsync = ref.watch(shoppingHistoryDetailProvider(historyId));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.fridge_tab_history)),
      body: historyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (history) => _HistoryDetail(history: history, l10n: l10n),
      ),
    );
  }
}

class _HistoryDetail extends StatelessWidget {
  final ShoppingHistoryModel history;
  final AppLocalizations l10n;
  const _HistoryDetail({required this.history, required this.l10n});

  @override
  Widget build(BuildContext context) {
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
                onPressed: () {
                  context.push(
                    '${AppRoutes.assetDetail}?id=${history.expense!.id}',
                  );
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
      trailing: item.transferredToFridge
          ? Icon(Icons.check_circle_outline,
              color: Theme.of(context).colorScheme.primary, size: 18)
          : null,
    );
  }
}
