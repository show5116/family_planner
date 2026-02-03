import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/announcements/data/models/announcement_model.dart';
import 'package:family_planner/features/announcements/providers/announcement_provider.dart';
import 'package:family_planner/features/announcements/utils/announcement_category_helper.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 공지사항 카테고리 필터 위젯
class AnnouncementCategoryFilter extends ConsumerWidget {
  final AnnouncementCategory? selectedCategory;

  const AnnouncementCategoryFilter({
    super.key,
    required this.selectedCategory,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceS),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceM),
        children: [
          // 전체 칩
          Padding(
            padding: const EdgeInsets.only(right: AppSizes.spaceS),
            child: FilterChip(
              label: Text(
                l10n.common_all,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              selected: selectedCategory == null,
              onSelected: (selected) {
                if (selected) {
                  ref.read(announcementListProvider.notifier).setCategory(null);
                }
              },
            ),
          ),
          // 카테고리별 칩
          ...AnnouncementCategory.values.map((category) {
            return Padding(
              padding: const EdgeInsets.only(right: AppSizes.spaceS),
              child: FilterChip(
                avatar: Icon(
                  category.icon,
                  size: AppSizes.iconSmall,
                  color: selectedCategory == category
                      ? category.color
                      : AppColors.textSecondary,
                ),
                label: Text(
                  category.displayName(l10n),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                selected: selectedCategory == category,
                onSelected: (selected) {
                  ref.read(announcementListProvider.notifier).setCategory(
                        selected ? category : null,
                      );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
