import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/widgets/reorderable_widgets.dart';
import 'package:family_planner/features/main/investment/data/models/indicator_model.dart';
import 'package:family_planner/features/main/investment/providers/indicator_provider.dart';

class InvestmentIndicatorsScreen extends ConsumerWidget {
  const InvestmentIndicatorsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final indicatorsAsync = ref.watch(indicatorsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('투자 지표'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(indicatorsProvider.notifier).refresh(),
          ),
        ],
      ),
      body: indicatorsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ErrorBody(
          message: error.toString(),
          onRetry: () => ref.read(indicatorsProvider.notifier).refresh(),
        ),
        data: (indicators) {
          if (indicators.isEmpty) {
            return const Center(child: Text('지표 데이터가 없습니다'));
          }
          return RefreshIndicator(
            onRefresh: () => ref.read(indicatorsProvider.notifier).refresh(),
            child: _IndicatorListBody(indicators: indicators),
          );
        },
      ),
    );
  }
}

class _IndicatorListBody extends ConsumerWidget {
  const _IndicatorListBody({required this.indicators});

  final List<IndicatorModel> indicators;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarked = indicators.where((e) => e.isBookmarked).toList();
    final unbookmarked = indicators.where((e) => !e.isBookmarked).toList();

    return CustomScrollView(
      slivers: [
        if (bookmarked.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.spaceM,
                AppSizes.spaceM,
                AppSizes.spaceM,
                AppSizes.spaceXS,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.star,
                    size: 16,
                    color: AppColors.investment,
                  ),
                  const SizedBox(width: AppSizes.spaceXS),
                  Text(
                    '즐겨찾기',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.investment,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(width: AppSizes.spaceXS),
                  Text(
                    '(길게 눌러 순서 변경)',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: ReorderableListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              buildDefaultDragHandles: false,
              proxyDecorator: buildReorderableProxyDecorator,
              itemCount: bookmarked.length,
              onReorder: (oldIndex, newIndex) {
                if (newIndex > oldIndex) newIndex -= 1;
                ref
                    .read(indicatorsProvider.notifier)
                    .reorderBookmarks(oldIndex, newIndex);
              },
              itemBuilder: (context, index) {
                final indicator = bookmarked[index];
                return ReorderableDragStartListener(
                  key: ValueKey(indicator.symbol),
                  index: index,
                  child: _IndicatorTile(
                    indicator: indicator,
                    showDragHandle: true,
                    onTap: () => context.push(
                      '/investment-indicators/${indicator.symbol}',
                    ),
                    onBookmarkToggle: () => ref
                        .read(indicatorsProvider.notifier)
                        .toggleBookmark(indicator.symbol),
                  ),
                );
              },
            ),
          ),
          if (unbookmarked.isNotEmpty)
            const SliverToBoxAdapter(child: Divider(height: 1)),
        ],
        if (unbookmarked.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.spaceM,
                AppSizes.spaceM,
                AppSizes.spaceM,
                AppSizes.spaceXS,
              ),
              child: Text(
                '전체 지표',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
          SliverList.separated(
            itemCount: unbookmarked.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final indicator = unbookmarked[index];
              return _IndicatorTile(
                indicator: indicator,
                showDragHandle: false,
                onTap: () => context.push(
                  '/investment-indicators/${indicator.symbol}',
                ),
                onBookmarkToggle: () => ref
                    .read(indicatorsProvider.notifier)
                    .toggleBookmark(indicator.symbol),
              );
            },
          ),
        ],
        const SliverPadding(padding: EdgeInsets.only(bottom: AppSizes.spaceM)),
      ],
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppColors.error),
          const SizedBox(height: AppSizes.spaceM),
          Text(
            '데이터를 불러오지 못했습니다',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSizes.spaceS),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('다시 시도'),
          ),
        ],
      ),
    );
  }
}

class _IndicatorTile extends StatelessWidget {
  const _IndicatorTile({
    required this.indicator,
    required this.showDragHandle,
    required this.onTap,
    required this.onBookmarkToggle,
  });

  final IndicatorModel indicator;
  final bool showDragHandle;
  final VoidCallback onTap;
  final VoidCallback onBookmarkToggle;

  @override
  Widget build(BuildContext context) {
    final change = indicator.change;
    final changeRate = indicator.changeRate;
    final isPositive = (change ?? 0) >= 0;
    final changeColor = isPositive ? AppColors.success : AppColors.error;

    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.only(
        left: showDragHandle ? AppSizes.spaceXS : AppSizes.spaceS,
        right: 0,
        top: AppSizes.spaceXS,
        bottom: AppSizes.spaceXS,
      ),
      leading: showDragHandle
          ? DragHandleIcon(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            )
          : null,
      title: Row(
        children: [
          Text(
            indicator.nameKo,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(width: AppSizes.spaceS),
          Text(
            indicator.symbol,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
      subtitle: change != null && changeRate != null
          ? Row(
              children: [
                Icon(
                  isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 12,
                  color: changeColor,
                ),
                const SizedBox(width: 2),
                Text(
                  '${change.abs().toStringAsFixed(2)} (${changeRate.abs().toStringAsFixed(2)}%)',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: changeColor,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            )
          : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                indicator.price != null
                    ? '${_formatNumber(indicator.price!)} ${indicator.unit}'
                    : '-',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(width: AppSizes.spaceXS),
          IconButton(
            icon: Icon(
              indicator.isBookmarked ? Icons.star : Icons.star_border,
              color: indicator.isBookmarked
                  ? AppColors.investment
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            onPressed: onBookmarkToggle,
          ),
        ],
      ),
    );
  }

  String _formatNumber(double value) {
    if (value >= 1000) {
      return value.toStringAsFixed(2).replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (m) => '${m[1]},',
          );
    }
    return value.toStringAsFixed(2);
  }
}
