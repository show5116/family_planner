import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/utils/format_utils.dart';
import 'package:family_planner/core/utils/user_utils.dart';
import 'package:family_planner/core/widgets/reorderable_widgets.dart';
import 'package:family_planner/features/main/investment/data/models/indicator_model.dart';
import 'package:family_planner/features/main/investment/data/models/market_briefing_model.dart';
import 'package:family_planner/features/main/investment/data/repositories/indicator_repository.dart';
import 'package:family_planner/features/main/investment/providers/indicator_provider.dart';
import 'package:family_planner/features/onboarding/presentation/widgets/feature_coach_mark.dart';
import 'package:family_planner/features/onboarding/services/onboarding_service.dart';
import 'package:family_planner/shared/widgets/app_bar_more_menu.dart';
import 'package:family_planner/shared/widgets/sparkline_chart.dart';

class InvestmentIndicatorsScreen extends ConsumerStatefulWidget {
  const InvestmentIndicatorsScreen({super.key});

  @override
  ConsumerState<InvestmentIndicatorsScreen> createState() =>
      _InvestmentIndicatorsScreenState();
}

class _InvestmentIndicatorsScreenState
    extends ConsumerState<InvestmentIndicatorsScreen> {
  final _firstTileKey = GlobalKey();
  final _bookmarkKey = GlobalKey();

  bool _coachMarkScheduled = false;
  bool _coachMarkStarted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeShowCoachMark());
  }

  TargetPosition? _keyToPosition(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return null;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return null;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final offset = box.localToGlobal(Offset.zero, ancestor: overlay);
    return TargetPosition(box.size, offset);
  }

  Future<void> _maybeShowCoachMark() async {
    final completed = await OnboardingService.isCoachMarkCompleted(
        CoachMarkKeys.investmentIndicators);
    if (!mounted || completed) return;
    // 데이터 로드 후 키가 붙을 때까지 기다림
    _coachMarkScheduled = true;
  }

  void _tryStartCoachMarkAfterLoad({required bool briefingReady}) {
    if (!_coachMarkScheduled || _coachMarkStarted || !briefingReady) return;
    _coachMarkScheduled = false;
    _coachMarkStarted = true;
    WidgetsBinding.instance.addPostFrameCallback((_) => _showCoachMark());
  }

  Future<void> _showCoachMark() async {
    if (!mounted) return;

    final tilePos = _keyToPosition(_firstTileKey);
    final bookmarkPos = _keyToPosition(_bookmarkKey);

    final targets = <TargetFocus>[
      TargetFocus(
        identify: 'indicator_list',
        targetPosition: tilePos,
        keyTarget: tilePos == null ? _firstTileKey : null,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '투자 지표',
              description: '주요 주가지수, 환율, 원자재, 암호화폐 등\n실시간 지표를 한눈에 확인할 수 있어요.\n탭하면 상세 차트와 과거 추이를 볼 수 있어요.',
              icon: Icons.show_chart,
              color: AppColors.investment,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'indicator_bookmark',
        targetPosition: bookmarkPos,
        keyTarget: bookmarkPos == null ? _bookmarkKey : null,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '즐겨찾기',
              description: '별표를 눌러 즐겨찾기에 추가하세요.\n즐겨찾기한 지표는 목록 상단에 고정되고\n홈 화면 대시보드 위젯에서 바로 확인할 수 있어요.',
              icon: Icons.star_outline,
              color: Colors.amber,
            ),
          ),
        ],
      ),
    ];

    await FeatureCoachMark.waitForTargets(targets, context);
    if (!mounted) return;

    TutorialCoachMark(
      targets: targets,
      colorShadow: const Color(0xFF212121),
      opacityShadow: 0.85,
      textSkip: '건너뛰기',
      alignSkip: Alignment.topRight,
      skipWidget: _skipWidget,
      onFinish: () => OnboardingService.completeCoachMark(
          CoachMarkKeys.investmentIndicators),
      onSkip: () {
        OnboardingService.completeCoachMark(CoachMarkKeys.investmentIndicators);
        return true;
      },
      paddingFocus: 8,
      focusAnimationDuration: const Duration(milliseconds: 300),
      pulseAnimationDuration: const Duration(milliseconds: 800),
    ).show(context: context);
  }

  Widget get _skipWidget => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white30),
        ),
        child: const Text(
          '건너뛰기',
          style: TextStyle(
              color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final indicatorsAsync = ref.watch(indicatorsProvider);
    final briefingAsync = ref.watch(marketBriefingProvider);
    final isAdmin = ref.watch(isAdminProvider);
    final briefingReady = briefingAsync.hasValue;

    return Scaffold(
      appBar: AppBar(
        title: const Text('투자 지표'),
        actions: [
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
          AppBarMoreMenu(
            onReplayOnboarding: () {
              OnboardingService.resetCoachMark(
                  CoachMarkKeys.investmentIndicators);
              _showCoachMark();
            },
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
          _tryStartCoachMarkAfterLoad(briefingReady: briefingReady);
          return RefreshIndicator(
            onRefresh: () => ref.read(indicatorsProvider.notifier).refresh(),
            child: _IndicatorListBody(
              indicators: indicators,
              firstTileKey: _firstTileKey,
              bookmarkKey: _bookmarkKey,
            ),
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
  const _IndicatorListBody({
    required this.indicators,
    this.firstTileKey,
    this.bookmarkKey,
  });

  final List<IndicatorModel> indicators;
  final GlobalKey? firstTileKey;
  final GlobalKey? bookmarkKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarked = indicators.where((e) => e.isBookmarked).toList();
    final unbookmarked = indicators.where((e) => !e.isBookmarked).toList();
    // 튜토리얼 키: 즐겨찾기가 있으면 첫 즐겨찾기 타일, 없으면 첫 전체 타일에 배정
    final assignFirstTileKey = bookmarked.isEmpty;

    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: _MarketBriefingSection()),
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
                    tileKey: index == 0 ? firstTileKey : null,
                    bookmarkKey: index == 0 ? bookmarkKey : null,
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
                tileKey: (index == 0 && assignFirstTileKey) ? firstTileKey : null,
                bookmarkKey: (index == 0 && assignFirstTileKey) ? bookmarkKey : null,
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
        SliverPadding(
          padding: EdgeInsets.only(
            bottom: AppSizes.spaceM + MediaQuery.paddingOf(context).bottom,
          ),
        ),
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

class _MarketBriefingSection extends ConsumerWidget {
  const _MarketBriefingSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final briefingAsync = ref.watch(marketBriefingProvider);

    return briefingAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(AppSizes.spaceM),
        child: LinearProgressIndicator(),
      ),
      error: (error, _) => Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Text(
          'AI 브리핑 오류: $error',
          style: TextStyle(color: AppColors.error, fontSize: 12),
        ),
      ),
      data: (briefing) {
        final items = <(String, MarketBriefingItem)>[];
        if (briefing.macro != null) items.add(('매크로', briefing.macro!));
        if (briefing.domesticMarket != null) items.add(('국내 시장', briefing.domesticMarket!));
        if (briefing.globalMarket != null) items.add(('글로벌 시장', briefing.globalMarket!));

        if (items.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.spaceM,
            AppSizes.spaceM,
            AppSizes.spaceM,
            AppSizes.spaceXS,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.auto_awesome, size: 16, color: AppColors.investment),
                  const SizedBox(width: AppSizes.spaceXS),
                  Text(
                    'AI 시황 브리핑',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.investment,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.spaceS),
              ...items.map((entry) => _BriefingCard(label: entry.$1, item: entry.$2)),
            ],
          ),
        );
      },
    );
  }
}

class _BriefingCard extends StatefulWidget {
  const _BriefingCard({required this.label, required this.item});

  final String label;
  final MarketBriefingItem item;

  @override
  State<_BriefingCard> createState() => _BriefingCardState();
}

class _BriefingCardState extends State<_BriefingCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final updatedAt = widget.item.updatedAt.toLocal();
    final timeStr =
        '${updatedAt.month}/${updatedAt.day} ${updatedAt.hour.toString().padLeft(2, '0')}:${updatedAt.minute.toString().padLeft(2, '0')}';

    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.spaceS),
      child: InkWell(
        onTap: () => setState(() => _expanded = !_expanded),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.spaceS,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.investment.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      widget.label,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.investment,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.spaceS),
                  Expanded(
                    child: Text(
                      widget.item.title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: _expanded ? null : 1,
                      overflow: _expanded ? null : TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    size: 20,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
              if (_expanded) ...[
                const SizedBox(height: AppSizes.spaceS),
                Text(
                  widget.item.content,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: AppSizes.spaceXS),
                Text(
                  '업데이트: $timeStr',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _IndicatorTile extends ConsumerWidget {
  const _IndicatorTile({
    this.tileKey,
    this.bookmarkKey,
    required this.indicator,
    required this.showDragHandle,
    required this.onTap,
    required this.onBookmarkToggle,
  });

  final GlobalKey? tileKey;
  final GlobalKey? bookmarkKey;
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
      key: tileKey,
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
                      Flexible(
                        child: Text(
                          indicator.nameKo,
                          style: Theme.of(context).textTheme.titleSmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: AppSizes.spaceS),
                      Flexible(
                        child: Text(
                          indicator.symbol,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                          overflow: TextOverflow.ellipsis,
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
                        Flexible(
                          child: Text(
                            '${formatIndicatorChange(change)} (${changeRate.abs().toStringAsFixed(2)}%)',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: changeColor,
                                  fontWeight: FontWeight.w600,
                                ),
                            overflow: TextOverflow.ellipsis,
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
                  prevPrice: indicator.prevPrice,
                ),
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
              ),
            ),
            const SizedBox(width: AppSizes.spaceM),
            // 가격 (고정 너비로 overflow 방지)
            SizedBox(
              width: 88,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (indicator.price != null)
                    Text(
                      '${formatIndicatorPrice(indicator.price!)} ${indicator.unit}',
                      textAlign: TextAlign.right,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    )
                  else
                    Text(
                      '-',
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                ],
              ),
            ),
            // 즐겨찾기 버튼 (고정 너비)
            SizedBox(
              key: bookmarkKey,
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

