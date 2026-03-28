import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/child_points/presentation/widgets/transaction_list_item.dart';
import 'package:family_planner/features/main/child_points/providers/childcare_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/shared/widgets/app_empty_state.dart';

/// 히스토리 탭
class HistoryTab extends ConsumerWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final account = ref.watch(selectedChildAccountProvider);
    final selectedMonth = ref.watch(childcareSelectedMonthProvider);
    final transactionsAsync = ref.watch(childcareTransactionsProvider);

    if (account == null) {
      return Center(child: Text(l10n.childcare_no_child));
    }

    return Column(
      children: [
        // 월 이동 바
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spaceM,
            vertical: AppSizes.spaceXS,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => _changeMonth(ref, selectedMonth, -1),
                icon: const Icon(Icons.chevron_left),
                visualDensity: VisualDensity.compact,
              ),
              Text(
                _formatMonth(selectedMonth),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              IconButton(
                onPressed: () => _changeMonth(ref, selectedMonth, 1),
                icon: const Icon(Icons.chevron_right),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ),
        Expanded(
          child: transactionsAsync.when(
            data: (transactions) {
              if (transactions.isEmpty) {
                return AppEmptyState(
                  icon: Icons.history,
                  message: l10n.childcare_empty_transactions,
                );
              }
              return RefreshIndicator(
                onRefresh: () =>
                    ref.read(childcareTransactionsProvider.notifier).refresh(),
                child: ListView.separated(
                  itemCount: transactions.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    return TransactionListItem(
                        transaction: transactions[index]);
                  },
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) =>
                Center(child: Text(l10n.childcare_empty_transactions)),
          ),
        ),
      ],
    );
  }

  void _changeMonth(WidgetRef ref, String currentMonth, int delta) {
    final parts = currentMonth.split('-');
    var year = int.parse(parts[0]);
    var month = int.parse(parts[1]) + delta;
    if (month > 12) {
      month = 1;
      year++;
    } else if (month < 1) {
      month = 12;
      year--;
    }
    ref.read(childcareSelectedMonthProvider.notifier).state =
        '$year-${month.toString().padLeft(2, '0')}';
  }

  String _formatMonth(String month) {
    final parts = month.split('-');
    return '${parts[0]}.${parts[1]}';
  }
}
