import 'package:flutter/material.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/announcements/data/models/announcement_model.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 공지사항 카테고리 헬퍼
extension AnnouncementCategoryExtension on AnnouncementCategory {
  /// 카테고리 다국어 이름
  String displayName(AppLocalizations l10n) {
    switch (this) {
      case AnnouncementCategory.announcement:
        return l10n.announcement_category_announcement;
      case AnnouncementCategory.event:
        return l10n.announcement_category_event;
      case AnnouncementCategory.update:
        return l10n.announcement_category_update;
    }
  }

  /// 카테고리 아이콘
  IconData get icon {
    switch (this) {
      case AnnouncementCategory.announcement:
        return Icons.campaign;
      case AnnouncementCategory.event:
        return Icons.celebration;
      case AnnouncementCategory.update:
        return Icons.system_update;
    }
  }

  /// 카테고리 색상
  Color get color {
    switch (this) {
      case AnnouncementCategory.announcement:
        return AppColors.primary;
      case AnnouncementCategory.event:
        return AppColors.error;
      case AnnouncementCategory.update:
        return AppColors.success;
    }
  }
}
