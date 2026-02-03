import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/announcements/data/models/announcement_model.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 공지사항 메타 정보 위젯 (작성자, 날짜, 읽은 수)
class AnnouncementMetaInfo extends StatelessWidget {
  final AnnouncementModel announcement;

  const AnnouncementMetaInfo({
    super.key,
    required this.announcement,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dateFormat = DateFormat('yyyy년 MM월 dd일 HH:mm');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 작성자 및 날짜
        Row(
          children: [
            Icon(
              Icons.person_outline,
              size: AppSizes.iconSmall,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: AppSizes.spaceXS),
            Text(
              announcement.author.name,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(width: AppSizes.spaceM),
            Icon(
              Icons.access_time,
              size: AppSizes.iconSmall,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: AppSizes.spaceXS),
            Text(
              dateFormat.format(announcement.createdAt),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.spaceS),

        // 읽은 사람 수
        Row(
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
        ),
      ],
    );
  }
}
