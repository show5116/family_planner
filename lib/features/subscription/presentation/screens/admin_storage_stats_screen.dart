import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/utils/format_utils.dart';
import 'package:family_planner/features/subscription/data/models/admin_storage_stats.dart';
import 'package:family_planner/features/subscription/providers/admin_subscription_provider.dart';
import 'package:family_planner/shared/widgets/app_empty_state.dart';
import 'package:family_planner/shared/widgets/app_error_state.dart';

/// 저장 사용량 분포 (ADMIN 전용)
///
/// 상위 등급을 새로 낼지 판단하는 화면이다. 합계보다 **한도에 몰린 인원**이
/// 신호이므로, 등급 카드에서 80% 이상·초과 인원을 앞으로 뽑아 보여준다.
class AdminStorageStatsScreen extends ConsumerWidget {
  const AdminStorageStatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(adminStorageStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('저장 사용량 분포'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(adminStorageStatsProvider),
            tooltip: '새로고침',
          ),
        ],
      ),
      body: statsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AppErrorState(
          error: e,
          title: '분포를 불러오지 못했습니다',
          onRetry: () => ref.invalidate(adminStorageStatsProvider),
        ),
        data: (stats) {
          // 아무도 올린 적이 없으면 등급 카드가 전부 0이라 읽을 게 없다
          if (stats.usersWithMedia == 0) {
            return const AppEmptyState(
              icon: Icons.cloud_off_outlined,
              message: '아직 집계할 저장 사용량이 없습니다',
              subtitle: '미디어를 올린 사용자가 생기면 분포가 표시됩니다.',
            );
          }

          return ListView(
            padding: const EdgeInsets.all(AppSizes.spaceM),
            children: [
              _SummaryCard(stats: stats),
              const SizedBox(height: AppSizes.spaceM),
              Text('등급별', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: AppSizes.spaceS),
              for (final tier in stats.tiers) ...[
                _TierStorageCard(tier: tier),
                const SizedBox(height: AppSizes.spaceS),
              ],
              const SizedBox(height: AppSizes.spaceS),
              Text('사용량 구간', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: AppSizes.spaceS),
              _BucketCard(buckets: stats.buckets),
            ],
          );
        },
      ),
    );
  }
}

// ── 전체 요약 ─────────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.stats});

  final AdminStorageStats stats;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '전체 저장량',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    formatBytes(stats.totalStoredBytes),
                    style: textTheme.headlineSmall,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '미디어 보유 사용자',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    '${stats.usersWithMedia}명',
                    style: textTheme.headlineSmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── 등급별 요약 ───────────────────────────────────────────────

class _TierStorageCard extends StatelessWidget {
  const _TierStorageCard({required this.tier});

  final AdminTierStorage tier;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  tier.tier.displayName,
                  style: textTheme.titleSmall?.copyWith(
                    color: tier.tier.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: AppSizes.spaceS),
                Text(
                  '미디어 ${tier.usersWithMedia} / 전체 ${tier.userCount}명',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const Divider(height: AppSizes.spaceL),
            // 상위 등급 수요 신호 — 합계보다 이 두 숫자를 먼저 본다
            Row(
              children: [
                _PressureChip(
                  label: '한도 80%+',
                  count: tier.nearLimitCount,
                  color: AppColors.warning,
                ),
                const SizedBox(width: AppSizes.spaceS),
                _PressureChip(
                  label: '한도 초과',
                  count: tier.overLimitCount,
                  color: AppColors.error,
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spaceS),
            _StatLine(label: '한도', value: formatBytes(tier.limitBytes)),
            _StatLine(label: '합계', value: formatBytes(tier.totalBytes)),
            _StatLine(
              label: '중앙값',
              value: formatBytes(tier.medianBytes),
              hint: '미디어가 있는 사용자 기준',
            ),
            _StatLine(label: '최대', value: formatBytes(tier.maxBytes)),
          ],
        ),
      ),
    );
  }
}

class _PressureChip extends StatelessWidget {
  const _PressureChip({
    required this.label,
    required this.count,
    required this.color,
  });

  final String label;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final isZero = count == 0;
    final effective = isZero
        ? Theme.of(context).colorScheme.onSurfaceVariant
        : color;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceS,
        vertical: AppSizes.spaceXS,
      ),
      decoration: BoxDecoration(
        color: effective.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
      ),
      child: Text(
        '$label $count명',
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: effective,
          fontWeight: isZero ? FontWeight.normal : FontWeight.bold,
        ),
      ),
    );
  }
}

class _StatLine extends StatelessWidget {
  const _StatLine({required this.label, required this.value, this.hint});

  final String label;
  final String value;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            child: Text(
              label,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Text(value, style: textTheme.bodyMedium),
          if (hint != null) ...[
            const SizedBox(width: AppSizes.spaceXS),
            Expanded(
              child: Text(
                hint!,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.outline,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── 구간 분포 ─────────────────────────────────────────────────

class _BucketCard extends StatelessWidget {
  const _BucketCard({required this.buckets});

  final List<AdminStorageBucket> buckets;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    if (buckets.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          child: Text(
            '아직 집계할 사용량이 없습니다.',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    // 가장 많은 구간을 기준으로 막대 길이를 정한다
    final maxCount = buckets
        .map((b) => b.userCount)
        .fold<int>(0, (a, b) => a > b ? a : b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Column(
          children: [
            for (final bucket in buckets)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceXS),
                child: Row(
                  children: [
                    SizedBox(
                      width: 84,
                      child: Text(
                        bucket.label,
                        style: textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          AppSizes.radiusSmall,
                        ),
                        child: LinearProgressIndicator(
                          value: maxCount == 0
                              ? 0
                              : bucket.userCount / maxCount,
                          minHeight: 10,
                          backgroundColor: colorScheme.surfaceContainerHighest,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSizes.spaceS),
                    SizedBox(
                      width: 48,
                      child: Text(
                        '${bucket.userCount}명',
                        style: textTheme.bodySmall,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
