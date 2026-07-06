import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/announcements/data/models/announcement_model.dart';
import 'package:family_planner/features/announcements/utils/announcement_category_helper.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/shared/widgets/editor/utils/html_utils.dart';

/// 공지사항 카드 위젯
class AnnouncementCard extends StatelessWidget {
  final AnnouncementModel announcement;
  final bool isAdmin;

  const AnnouncementCard({
    super.key,
    required this.announcement,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dateFormat = DateFormat('yyyy.MM.dd');

    return Card(
      elevation: announcement.isPinned ? 0 : AppSizes.elevation1,
      surfaceTintColor: Colors.transparent,
      color: announcement.isPinned
          ? AppColors.primary.withValues(alpha: 0.1)
          : null,
      shape: announcement.isPinned
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              side: BorderSide(
                color: AppColors.primary.withValues(alpha: 0.3),
                width: 1.5,
              ),
            )
          : null,
      child: InkWell(
        onTap: () => context.push('/announcements/${announcement.id}'),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, dateFormat),
              const SizedBox(height: AppSizes.spaceS),
              _buildCategoryBadge(context, l10n),
              if (announcement.category != null)
                const SizedBox(height: AppSizes.spaceS),
              _buildTitle(context),
              const SizedBox(height: AppSizes.spaceS),
              _buildContentPreview(context),
              if (announcement.readCount > 0) ...[
                const SizedBox(height: AppSizes.spaceS),
                _buildReadCount(context, l10n),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, DateFormat dateFormat) {
    return Row(
      children: [
        if (announcement.isPinned) ...[
          Icon(
            Icons.push_pin,
            size: AppSizes.iconSmall,
            color: AppColors.primary,
          ),
          const SizedBox(width: AppSizes.spaceXS),
        ],
        Expanded(
          child: Text(
            dateFormat.format(announcement.createdAt),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ),
        if (!announcement.isRead)
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.error,
              shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }

  Widget _buildCategoryBadge(BuildContext context, AppLocalizations l10n) {
    if (announcement.category == null) return const SizedBox.shrink();

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spaceS,
            vertical: AppSizes.spaceXS,
          ),
          decoration: BoxDecoration(
            color: announcement.category!.color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                announcement.category!.icon,
                size: AppSizes.iconSmall,
                color: announcement.category!.color,
              ),
              const SizedBox(width: AppSizes.spaceXS),
              Text(
                announcement.category!.displayName(l10n),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: announcement.category!.color,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      announcement.title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: announcement.isRead ? null : AppColors.primary,
          ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildContentPreview(BuildContext context) {
    return Text(
      stripHtmlTags(announcement.content),
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildReadCount(BuildContext context, AppLocalizations l10n) {
    return Row(
      children: [
        Icon(
          Icons.visibility,
          size: AppSizes.iconSmall,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: AppSizes.spaceXS),
        Text(
          l10n.announcement_readCount(announcement.readCount),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
      ],
    );
  }
}
