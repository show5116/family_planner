import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/announcements/data/models/announcement_model.dart';
import 'package:family_planner/features/announcements/utils/announcement_category_helper.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 공지사항 뱃지 행 위젯 (카테고리 + 고정)
class AnnouncementBadgeRow extends StatelessWidget {
  final AnnouncementCategory? category;
  final bool isPinned;

  const AnnouncementBadgeRow({
    super.key,
    required this.category,
    required this.isPinned,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        if (category != null) ...[
          _buildCategoryBadge(context, l10n),
          const SizedBox(width: AppSizes.spaceS),
        ],
        if (isPinned) _buildPinnedBadge(context, l10n),
      ],
    );
  }

  Widget _buildCategoryBadge(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceS,
        vertical: AppSizes.spaceXS,
      ),
      decoration: BoxDecoration(
        color: category!.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            category!.icon,
            size: AppSizes.iconSmall,
            color: category!.color,
          ),
          const SizedBox(width: AppSizes.spaceXS),
          Text(
            category!.displayName(l10n),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: category!.color,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildPinnedBadge(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceM,
        vertical: AppSizes.spaceS,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.push_pin,
            size: AppSizes.iconSmall,
            color: AppColors.primary,
          ),
          const SizedBox(width: AppSizes.spaceXS),
          Text(
            l10n.announcement_pinned,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
