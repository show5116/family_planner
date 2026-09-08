import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/diary/data/models/diary_media_models.dart';
import 'package:family_planner/features/main/diary/data/utils/media_compressor.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 용량 게이지
///
/// **남은 양을 강조한다** — 쓴 양을 앞세우면 압박으로 읽힌다.
/// 잔여가 10% 미만일 때만 색을 바꾼다 (상시 경고색은 무뎌진다).
class QuotaIndicator extends StatelessWidget {
  const QuotaIndicator({
    super.key,
    required this.bucket,
    required this.label,
    this.pendingBytes = 0,
    this.compact = false,
  });

  final QuotaBucket bucket;
  final String label;

  /// 업로드 중이라 아직 서버에 반영되지 않은 크기 (게이지에 미리 얹는다)
  final int pendingBytes;

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final projectedUsed = bucket.usedBytes + pendingBytes;
    final ratio = bucket.limitBytes <= 0
        ? 0.0
        : (projectedUsed / bucket.limitBytes).clamp(0.0, 1.0);
    final remaining = (bucket.limitBytes - projectedUsed).clamp(0, 1 << 62);

    final barColor = ratio >= 0.9
        ? AppColors.error
        : ratio >= 0.75
            ? AppColors.warning
            : colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const Spacer(),
            // 남은 용량을 앞세운다
            Text(
              '${formatBytes(remaining)} 남음',
              style: theme.textTheme.labelMedium?.copyWith(
                color: ratio >= 0.9 ? AppColors.error : colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.spaceXS),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: compact ? 4 : 6,
            backgroundColor: colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation(barColor),
          ),
        ),
        if (!compact) ...[
          const SizedBox(height: AppSizes.spaceXS),
          Text(
            '${formatBytes(projectedUsed)} / ${formatBytes(bucket.limitBytes)}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}

/// 월간 + 누적을 함께 보여주는 카드
class QuotaSummaryCard extends StatelessWidget {
  const QuotaSummaryCard({
    super.key,
    required this.quota,
    this.pendingBytes = 0,
    this.onUpgrade,
  });

  final MediaQuota quota;
  final int pendingBytes;
  final VoidCallback? onUpgrade;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            QuotaIndicator(
              bucket: quota.monthly,
              label: l10n.diary_quota_monthly,
              pendingBytes: pendingBytes,
            ),
            if (quota.monthly.resetsAt != null) ...[
              const SizedBox(height: AppSizes.spaceXS),
              Text(
                l10n.diary_quota_resets_on(
                  '${quota.monthly.resetsAt!.month}/${quota.monthly.resetsAt!.day}',
                ),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: AppSizes.spaceM),
            QuotaIndicator(
              bucket: quota.total,
              label: l10n.diary_quota_total,
              pendingBytes: pendingBytes,
            ),
            // 삭제해도 월간은 회복되지 않는다는 점을 미리 알려야 문의가 줄어든다
            const SizedBox(height: AppSizes.spaceS),
            Text(
              l10n.diary_quota_monthly_note,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (onUpgrade != null) ...[
              const SizedBox(height: AppSizes.spaceS),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: onUpgrade,
                  icon: const Icon(Icons.workspace_premium_outlined),
                  label: Text(l10n.diary_quota_upgrade),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
