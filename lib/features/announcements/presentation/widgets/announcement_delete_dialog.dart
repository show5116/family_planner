import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/announcements/providers/announcement_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 공지사항 삭제 확인 다이얼로그
class AnnouncementDeleteDialog {
  static void show(
    BuildContext context,
    WidgetRef ref,
    String announcementId,
  ) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.announcement_deleteDialogTitle),
        content: Text(l10n.announcement_deleteDialogMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.common_cancel),
          ),
          TextButton(
            onPressed: () => _handleDelete(
              dialogContext,
              context,
              ref,
              announcementId,
              l10n,
            ),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(l10n.common_delete),
          ),
        ],
      ),
    );
  }

  static Future<void> _handleDelete(
    BuildContext dialogContext,
    BuildContext context,
    WidgetRef ref,
    String announcementId,
    AppLocalizations l10n,
  ) async {
    Navigator.of(dialogContext).pop();

    final success = await ref
        .read(announcementManagementProvider.notifier)
        .deleteAnnouncement(announcementId);

    if (context.mounted) {
      if (success) {
        ref.invalidate(announcementListProvider);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.announcement_deleteSuccess)),
        );
        context.pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.announcement_deleteError)),
        );
      }
    }
  }
}
