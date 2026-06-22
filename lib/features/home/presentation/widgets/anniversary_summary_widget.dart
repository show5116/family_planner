import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/main/task/data/models/anniversary_model.dart';
import 'package:family_planner/features/main/task/data/repositories/anniversary_repository.dart';
import 'package:family_planner/features/main/task/providers/anniversary_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/shared/widgets/dashboard_card.dart';

const _kMilestoneLimit = 3;

String _dateLabel(AnniversaryModel a) =>
    '${a.date.year}.${a.date.month.toString().padLeft(2, '0')}.${a.date.day.toString().padLeft(2, '0')}';

// ── 최상위 위젯 ───────────────────────────────────────────────────────────────

class AnniversarySummaryWidget extends ConsumerWidget {
  const AnniversarySummaryWidget({
    super.key,
    required this.anniversaryIds,
  });

  final List<String> anniversaryIds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final allAsync = ref.watch(allGroupsAnniversariesProvider);

    return allAsync.when(
      loading: () => DashboardCard(
        title: l10n.anniversary_widgetTitle,
        icon: Icons.celebration_outlined,
        onTap: () {},
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(AppSizes.spaceM),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      error: (_, _) => DashboardCard(
        title: l10n.anniversary_widgetTitle,
        icon: Icons.celebration_outlined,
        onTap: () {},
        child: _EmptyState(message: l10n.anniversary_widgetEmpty),
      ),
      data: (all) {
        final selected = anniversaryIds
            .map((id) => all.where((a) => a.id == id).firstOrNull)
            .whereType<AnniversaryModel>()
            .toList();

        if (selected.isEmpty) {
          return DashboardCard(
            title: l10n.anniversary_widgetTitle,
            icon: Icons.celebration_outlined,
            onTap: () => context.push(AppRoutes.anniversaryManagement),
            child: _EmptyState(message: l10n.anniversary_widgetEmpty),
          );
        }

        return _AnniversaryCard(anniversaries: selected);
      },
    );
  }
}

// ── 기념일 카드 (단독/캐러셀 통합) ───────────────────────────────────────────
// 단독이면 그냥 표시, 복수면 좌우 스와이프로 페이지 전환

class _AnniversaryCard extends ConsumerStatefulWidget {
  const _AnniversaryCard({required this.anniversaries});
  final List<AnniversaryModel> anniversaries;

  @override
  ConsumerState<_AnniversaryCard> createState() => _AnniversaryCardState();
}

class _AnniversaryCardState extends ConsumerState<_AnniversaryCard> {
  int _page = 0;
  bool _expanded = false;

  AnniversaryModel get _current => widget.anniversaries[_page];
  bool get _isCarousel => widget.anniversaries.length > 1;

  void _prevPage() {
    if (_page > 0) setState(() { _page--; _expanded = false; });
  }

  void _nextPage() {
    if (_page < widget.anniversaries.length - 1) {
      setState(() { _page++; _expanded = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final a = _current;
    final milestonesAsync = ref.watch(upcomingMilestoneTasksProvider(a.id));
    final total = widget.anniversaries.length;

    // 캐러셀 인디케이터 (action 영역)
    Widget? action;
    if (_isCarousel) {
      action = Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(total, (i) {
          final isActive = i == _page;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: isActive ? 16 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: isActive
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(3),
            ),
          );
        }),
      );
    }

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 날짜 행 (캐러셀이면 D-Day 배지도 인라인에 표시)
        Row(
          children: [
            Text(_dateLabel(a), style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(width: AppSizes.spaceS),
            Text(
              'D+${a.daysSince}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
        // milestone 목록
        milestonesAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.only(top: AppSizes.spaceM),
            child: CircularProgressIndicator(),
          ),
          error: (_, _) => const SizedBox.shrink(),
          data: (milestones) {
            if (milestones.isEmpty) return const SizedBox.shrink();
            final visible = _expanded
                ? milestones
                : milestones.take(_kMilestoneLimit).toList();
            final hasMore = milestones.length > _kMilestoneLimit;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(height: AppSizes.spaceL),
                ...visible.map((m) => _MilestoneRow(item: m)),
                if (hasMore)
                  TextButton.icon(
                    onPressed: () => setState(() => _expanded = !_expanded),
                    icon: Icon(
                      _expanded ? Icons.expand_less : Icons.expand_more,
                      size: 14,
                    ),
                    label: Text(
                      _expanded
                          ? '접기'
                          : '+ ${milestones.length - _kMilestoneLimit}개 더 보기',
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                      textStyle: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );

    // 캐러셀이면 좌우 스와이프 감지
    if (_isCarousel) {
      content = GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity == null) return;
          if (details.primaryVelocity! < -200) _nextPage();
          if (details.primaryVelocity! > 200) _prevPage();
        },
        child: content,
      );
    }

    return DashboardCard(
      title: a.title,
      leadingWidget: Text(a.emoji ?? '🎂', style: const TextStyle(fontSize: 20)),
      action: action,
      onTap: () => context.push(AppRoutes.anniversaryManagement),
      child: content,
    );
  }
}

// ── milestone 행 ──────────────────────────────────────────────────────────────

class _MilestoneRow extends StatelessWidget {
  const _MilestoneRow({required this.item});
  final MilestoneTaskItem item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final today = DateTime.now();
    final d = DateTime(item.scheduledAt.year, item.scheduledAt.month,
            item.scheduledAt.day)
        .difference(DateTime(today.year, today.month, today.day))
        .inDays;
    final dLabel = d == 0 ? 'D-Day' : d > 0 ? 'D-$d' : 'D+${-d}';
    final dColor = d == 0
        ? colorScheme.error
        : d > 0 && d <= 7
            ? colorScheme.error
            : d > 0 && d < 30
                ? const Color(0xFFE65100)
                : colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.spaceS),
      child: Row(
        children: [
          Icon(Icons.event_outlined, size: 14, color: colorScheme.primary),
          const SizedBox(width: AppSizes.spaceS),
          Expanded(
            child: Text(
              item.title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: AppSizes.spaceS),
          Text(
            dLabel,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: dColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}

// ── 빈 상태 ───────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.celebration_outlined,
            size: 48,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: AppSizes.spaceS),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}
