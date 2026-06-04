import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/assets/providers/asset_provider.dart';
import 'package:family_planner/features/main/assets/utils/asset_utils.dart';

class HoldingRecordsComparison extends ConsumerWidget {
  final String accountId;
  final String dateA;
  final String dateB;
  final String Function(String) formatDateLabel;

  const HoldingRecordsComparison({
    super.key,
    required this.accountId,
    required this.dateA,
    required this.dateB,
    required this.formatDateLabel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncA = ref.watch(holdingRecordsProvider((accountId: accountId, recordDate: dateA)));
    final asyncB = ref.watch(holdingRecordsProvider((accountId: accountId, recordDate: dateB)));

    if (asyncA.isLoading || asyncB.isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSizes.spaceL),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (asyncA.hasError || asyncB.hasError) {
      return Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Text('오류가 발생했습니다.',
            style: TextStyle(color: Theme.of(context).colorScheme.error)),
      );
    }

    final recordsA = asyncA.value ?? [];
    final recordsB = asyncB.value ?? [];

    final allNames = {
      ...recordsA.map((r) => r.name),
      ...recordsB.map((r) => r.name),
    }.toList();

    final mapA = {for (final r in recordsA) r.name: r.amount};
    final mapB = {for (final r in recordsB) r.name: r.amount};

    allNames.sort((a, b) {
      final diffA = ((mapB[a] ?? 0) - (mapA[a] ?? 0)).abs();
      final diffB = ((mapB[b] ?? 0) - (mapA[b] ?? 0)).abs();
      return diffB.compareTo(diffA);
    });

    return Column(
      children: [
        const SizedBox(height: AppSizes.spaceS),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceM),
          child: Row(
            children: [
              const Expanded(flex: 3, child: SizedBox()),
              Expanded(
                flex: 2,
                child: Text(
                  formatDateLabel(dateA),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.right,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  formatDateLabel(dateB),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.right,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  '변화',
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: AppSizes.spaceS),
        ...allNames.map((name) {
          final amtA = mapA[name];
          final amtB = mapB[name];
          final diff = (amtB ?? 0) - (amtA ?? 0);
          final isNew = amtA == null;
          final isGone = amtB == null;
          final diffColor = diff > 0
              ? Colors.green
              : diff < 0
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).colorScheme.outline;

          return Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spaceM, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      if (isNew)
                        CompareTag(
                            label: 'NEW',
                            color: Theme.of(context).colorScheme.secondary)
                      else if (isGone)
                        CompareTag(
                            label: '삭제',
                            color: Theme.of(context).colorScheme.outline),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          name,
                          style: Theme.of(context).textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    amtA != null ? '₩${formatAssetAmount(amtA)}' : '—',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                    textAlign: TextAlign.right,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    amtB != null ? '₩${formatAssetAmount(amtB)}' : '—',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.right,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    diff == 0
                        ? '—'
                        : '${diff > 0 ? '+' : ''}₩${formatAssetAmount(diff)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: diffColor,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          );
        }),
        const Divider(height: AppSizes.spaceS),
        Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSizes.spaceM, 4, AppSizes.spaceM, AppSizes.spaceM),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text('합계',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  '₩${formatAssetAmount(recordsA.fold(0.0, (s, r) => s + r.amount))}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.right,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  '₩${formatAssetAmount(recordsB.fold(0.0, (s, r) => s + r.amount))}',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                ),
              ),
              Expanded(
                flex: 2,
                child: Builder(builder: (context) {
                  final totalDiff =
                      recordsB.fold(0.0, (s, r) => s + r.amount) -
                          recordsA.fold(0.0, (s, r) => s + r.amount);
                  final color = totalDiff > 0
                      ? Colors.green
                      : totalDiff < 0
                          ? Theme.of(context).colorScheme.error
                          : Theme.of(context).colorScheme.outline;
                  return Text(
                    totalDiff == 0
                        ? '—'
                        : '${totalDiff > 0 ? '+' : ''}₩${formatAssetAmount(totalDiff)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.right,
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CompareTag extends StatelessWidget {
  final String label;
  final Color color;

  const CompareTag({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
