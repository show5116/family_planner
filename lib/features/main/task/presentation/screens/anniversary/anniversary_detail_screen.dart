import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/task/data/models/anniversary_model.dart';
import 'package:family_planner/features/main/task/data/repositories/anniversary_repository.dart';
import 'package:family_planner/features/main/task/providers/anniversary_provider.dart';
import 'package:family_planner/features/main/task/presentation/screens/anniversary/anniversary_form_dialog.dart';

/// 기념일 상세 화면
class AnniversaryDetailScreen extends ConsumerWidget {
  final AnniversaryModel anniversary;
  final String groupId;

  const AnniversaryDetailScreen({
    super.key,
    required this.anniversary,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 목록 provider에서 최신 데이터 구독 (수정 후 자동 반영)
    final listAsync = ref.watch(anniversaryManagementProvider(groupId));
    final current = listAsync.valueOrNull
            ?.firstWhere((a) => a.id == anniversary.id,
                orElse: () => anniversary) ??
        anniversary;

    final theme = Theme.of(context);
    final daysUntil = current.daysUntilNext;
    final daysSince = current.daysSince;

    final dateStr =
        '${current.date.year}.${current.date.month.toString().padLeft(2, '0')}.${current.date.day.toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('기념일 상세'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: '수정',
            onPressed: () => AnniversaryFormDialog.show(
              context,
              groupId: groupId,
              anniversary: current,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            tooltip: '삭제',
            onPressed: () => _confirmDelete(context, ref, current),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.spaceL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더 — 이모지 + 제목
            _Header(anniversary: current),
            const SizedBox(height: AppSizes.spaceXL),

            // D-Day / D+N 카드 행
            _DayCountRow(daysUntil: daysUntil, daysSince: daysSince),
            const SizedBox(height: AppSizes.spaceL),

            // 날짜 정보
            _InfoSection(
              title: '기념일 날짜',
              child: Text(dateStr, style: theme.textTheme.bodyLarge),
            ),
            const SizedBox(height: AppSizes.spaceL),

            // milestone 설정
            if (current.milestoneConfig != null) ...[
              _MilestoneSection(config: current.milestoneConfig!),
              const SizedBox(height: AppSizes.spaceL),
            ],

            // 예정된 milestone 기념일 목록
            _UpcomingMilestonesSection(anniversaryId: current.id),
            const SizedBox(height: AppSizes.spaceL),

            // 등록일
            _InfoSection(
              title: '등록일',
              child: Text(
                '${current.createdAt.year}.${current.createdAt.month.toString().padLeft(2, '0')}.${current.createdAt.day.toString().padLeft(2, '0')}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    AnniversaryModel current,
  ) async {
    bool deleteWithTasks = false;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('기념일 삭제'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('"${current.title}"을(를) 삭제하시겠습니까?'),
              const SizedBox(height: AppSizes.spaceM),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                title: const Text('연동된 기념일 일정도 함께 삭제'),
                subtitle: const Text('체크 해제 시 일정은 유지됩니다'),
                value: deleteWithTasks,
                onChanged: (v) => setState(() => deleteWithTasks = v ?? false),
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              child: const Text('삭제'),
            ),
          ],
        ),
      ),
    );

    if (confirmed != true || !context.mounted) return;
    final success = await ref
        .read(anniversaryManagementProvider(groupId).notifier)
        .delete(current.id, deleteWithTasks: deleteWithTasks);
    if (!context.mounted) return;
    if (success) {
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('삭제에 실패했습니다')),
      );
    }
  }
}

// ── 헤더 ──────────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final AnniversaryModel anniversary;
  const _Header({required this.anniversary});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
          ),
          alignment: Alignment.center,
          child: Text(
            anniversary.emoji ?? '🎂',
            style: const TextStyle(fontSize: 32),
          ),
        ),
        const SizedBox(width: AppSizes.spaceL),
        Expanded(
          child: Text(
            anniversary.title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

// ── D-Day / D+N 카드 행 ───────────────────────────────────────────────────────

class _DayCountRow extends StatelessWidget {
  final int? daysUntil;
  final int daysSince;

  const _DayCountRow({required this.daysUntil, required this.daysSince});

  @override
  Widget build(BuildContext context) {
    final d = daysUntil;
    final Color nextColor;
    if (d == null || d > 7) {
      nextColor = Theme.of(context).colorScheme.primary;
    } else if (d == 0) {
      nextColor = AppColors.error;
    } else {
      nextColor = Colors.orange;
    }

    return Row(
      children: [
        Expanded(
          child: _DayCard(
            label: '경과일',
            value: daysSince >= 0 ? 'D+$daysSince' : 'D$daysSince',
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        const SizedBox(width: AppSizes.spaceM),
        Expanded(
          child: _DayCard(
            label: '다음 기념일',
            value: d == null ? '-' : d == 0 ? 'D-Day' : 'D-$d',
            color: nextColor,
          ),
        ),
      ],
    );
  }
}

class _DayCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _DayCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSizes.spaceL,
        horizontal: AppSizes.spaceM,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

// ── 정보 섹션 ─────────────────────────────────────────────────────────────────

class _InfoSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _InfoSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSizes.spaceXS),
        child,
      ],
    );
  }
}

// ── 예정된 milestone 기념일 섹션 ──────────────────────────────────────────────

class _UpcomingMilestonesSection extends ConsumerWidget {
  final String anniversaryId;
  const _UpcomingMilestonesSection({required this.anniversaryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(upcomingMilestoneTasksProvider(anniversaryId));

    return async.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (items) {
        if (items.isEmpty) return const SizedBox.shrink();
        return _InfoSection(
          title: '예정된 기념일',
          child: Column(
            children: items
                .map((item) => _UpcomingMilestoneRow(item: item))
                .toList(),
          ),
        );
      },
    );
  }
}

class _UpcomingMilestoneRow extends StatelessWidget {
  final MilestoneTaskItem item;
  const _UpcomingMilestoneRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final d = item.daysUntilDue;
    final dLabel = d == null
        ? ''
        : d == 0
            ? 'D-Day'
            : 'D-$d';
    final dateStr =
        '${item.scheduledAt.year}.${item.scheduledAt.month.toString().padLeft(2, '0')}.${item.scheduledAt.day.toString().padLeft(2, '0')}';

    return Padding(
      padding: const EdgeInsets.only(top: AppSizes.spaceS),
      child: Row(
        children: [
          Icon(
            Icons.event_outlined,
            size: 16,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: AppSizes.spaceS),
          Expanded(
            child: Text(
              '${item.title}  $dateStr',
              style: theme.textTheme.bodyMedium,
            ),
          ),
          if (dLabel.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spaceS,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              ),
              child: Text(
                dLabel,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Milestone 설정 섹션 ───────────────────────────────────────────────────────

class _MilestoneSection extends StatelessWidget {
  final MilestoneConfig config;
  const _MilestoneSection({required this.config});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = <String>[];
    if (config.every100Days == true) items.add('100일 단위 (D+100, D+200…)');
    if (config.everyYear == true) items.add('매년 주년 (1주년, 2주년…)');
    if (items.isEmpty) return const SizedBox.shrink();

    return _InfoSection(
      title: '기념일 알림 일정 자동 생성',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items
            .map(
              (text) => Padding(
                padding: const EdgeInsets.only(top: AppSizes.spaceXS),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: AppSizes.spaceXS),
                    Text(text, style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
