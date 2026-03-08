import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/utils/format_utils.dart';
import 'package:family_planner/core/utils/user_utils.dart';
import 'package:family_planner/core/widgets/reorderable_widgets.dart';
import 'package:family_planner/features/main/investment/data/models/indicator_model.dart';
import 'package:family_planner/features/main/investment/data/repositories/indicator_repository.dart';
import 'package:family_planner/features/main/investment/providers/indicator_provider.dart';
import 'package:family_planner/features/ai_chat/presentation/widgets/ai_chat_icon_button.dart';
import 'package:family_planner/shared/widgets/sparkline_chart.dart';

class InvestmentIndicatorsScreen extends ConsumerStatefulWidget {
  const InvestmentIndicatorsScreen({super.key});

  @override
  ConsumerState<InvestmentIndicatorsScreen> createState() =>
      _InvestmentIndicatorsScreenState();
}

class _InvestmentIndicatorsScreenState
    extends ConsumerState<InvestmentIndicatorsScreen> {
  @override
  Widget build(BuildContext context) {
    final indicatorsAsync = ref.watch(indicatorsProvider);
    final isAdmin = ref.watch(isAdminProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('투자 지표'),
        actions: [
          const AiChatIconButton(),
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.history),
              tooltip: '과거 데이터 초기화 (관리자)',
              onPressed: () => _showInitHistoryDialog(),
            ),
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

  Future<void> _showInitHistoryDialog() async {
    final daysController = TextEditingController(text: '365');

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('과거 데이터 초기화'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Yahoo/CoinGecko/BOK에서 과거 시세를 수집해 DB에 저장합니다.\n시간이 걸릴 수 있습니다.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSizes.spaceM),
            TextField(
              controller: daysController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '수집 일수 (1~3650)',
                hintText: '365',
                border: OutlineInputBorder(),
                suffixText: '일',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('초기화 실행'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final days = int.tryParse(daysController.text.trim());

    try {
      _showLoadingSnackBar();
      final result = await ref
          .read(indicatorRepositoryProvider)
          .initHistory(days: days);
      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      _showResultDialog(result);
      ref.read(indicatorsProvider.notifier).refresh();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('초기화 실패: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _showLoadingSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            ),
            SizedBox(width: AppSizes.spaceM),
            Text('과거 데이터를 수집 중입니다...'),
          ],
        ),
        duration: Duration(minutes: 5),
      ),
    );
  }

  void _showResultDialog(InitHistoryResult result) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('초기화 완료'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ResultRow(label: 'Yahoo (주가/환율/원자재)', count: result.yahoo),
            _ResultRow(label: '암호화폐 (BTC/KRW)', count: result.crypto),
            _ResultRow(label: '한국 채권', count: result.bond),
            if (result.goldKrw != null)
              _ResultRow(label: '국내 금값', count: result.goldKrw!),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
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
                return ReorderableDelayedDragStartListener(
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

class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.label, required this.count});

  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(
            '$count건',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
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

class _IndicatorTile extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final change = indicator.change;
    final changeRate = indicator.changeRate;
    final isPositive = (change ?? 0) >= 0;
    final changeColor = isPositive ? AppColors.success : AppColors.error;
    final sparklineAsync = ref.watch(indicatorSparklineProvider(indicator.symbol));

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(
          left: showDragHandle ? AppSizes.spaceXS : AppSizes.spaceS,
          right: AppSizes.spaceXS,
          top: AppSizes.spaceS,
          bottom: AppSizes.spaceS,
        ),
        child: Row(
          children: [
            // 드래그 핸들
            if (showDragHandle)
              DragHandleIcon(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            // 이름 + 변동률 (남은 공간 모두 차지)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
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
                  if (change != null && changeRate != null)
                    Row(
                      children: [
                        Icon(
                          isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                          size: 12,
                          color: changeColor,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${formatIndicatorChange(change)} (${changeRate.abs().toStringAsFixed(2)}%)',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: changeColor,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            // 스파크라인 (항상 고정 위치)
            SizedBox(
              width: 64,
              height: 36,
              child: sparklineAsync.when(
                data: (points) => SparklineChart(
                  points: points,
                  color: isPositive ? AppColors.success : AppColors.error,
                ),
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
              ),
            ),
            const SizedBox(width: AppSizes.spaceM),
            // 가격: 수치가 길면 자동으로 단위가 다음 줄로
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (indicator.price != null) ...[
                  Text(
                    '${formatIndicatorPrice(indicator.price!)} ${indicator.unit}',
                    textAlign: TextAlign.right,
                    softWrap: true,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ] else
                  Text(
                    '-',
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
              ],
            ),
            // 즐겨찾기 버튼 (고정 너비)
            SizedBox(
              width: 40,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  indicator.isBookmarked ? Icons.star : Icons.star_border,
                  color: indicator.isBookmarked
                      ? AppColors.investment
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                onPressed: onBookmarkToggle,
              ),
            ),
          ],
        ),
      ),
    );
  }

}

