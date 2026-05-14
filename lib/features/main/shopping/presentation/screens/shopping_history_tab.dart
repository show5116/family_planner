import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/main/fridge/data/models/fridge_models.dart';
import 'package:family_planner/features/main/fridge/providers/fridge_provider.dart';

class ShoppingHistoryTab extends ConsumerWidget {
  const ShoppingHistoryTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final historyAsync = ref.watch(shoppingHistoryProvider);

    return historyAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(e.toString())),
      data: (page) {
        if (page.data.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.receipt_long_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.outlineVariant),
                const SizedBox(height: AppSizes.spaceM),
                Text(l10n.fridge_history_empty,
                    style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          );
        }
        return ListView.builder(
          itemCount: page.data.length + (page.hasMore ? 1 : 0),
          itemBuilder: (_, i) {
            if (i == page.data.length) {
              return _LoadMoreButton(
                onTap: () =>
                    ref.read(shoppingHistoryProvider.notifier).loadMore(),
              );
            }
            return _HistoryCard(history: page.data[i]);
          },
        );
      },
    );
  }
}

class _LoadMoreButton extends StatelessWidget {
  final VoidCallback onTap;
  const _LoadMoreButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: TextButton(
          onPressed: onTap,
          child: const Text('더 보기'),
        ),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final ShoppingHistoryModel history;
  const _HistoryCard({required this.history});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dateStr =
        DateFormat('yyyy.MM.dd HH:mm').format(history.completedAt);
    final itemCount = history.items.length;
    final hasExpense = history.expense != null;

    return Card(
      margin: const EdgeInsets.symmetric(
          horizontal: AppSizes.spaceM, vertical: AppSizes.spaceS),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        onTap: () => context.push(
          AppRoutes.shoppingHistoryDetail
              .replaceFirst(':historyId', history.id),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(dateStr,
                        style: Theme.of(context).textTheme.titleSmall),
                  ),
                  if (hasExpense)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primaryContainer,
                        borderRadius:
                            BorderRadius.circular(AppSizes.radiusSmall),
                      ),
                      child: Text(
                        l10n.fridge_history_linked_expense,
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSizes.spaceXS),
              Text(
                l10n.fridge_history_items_count(itemCount),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline),
              ),
              if (history.items.isNotEmpty) ...[
                const SizedBox(height: AppSizes.spaceXS),
                Text(
                  history.items.map((i) => i.name).join(', '),
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (hasExpense) ...[
                const SizedBox(height: AppSizes.spaceS),
                Text(
                  '${NumberFormat('#,###').format(history.expense!.amount)}원',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
