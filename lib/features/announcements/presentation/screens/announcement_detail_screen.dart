import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/announcements/providers/announcement_provider.dart';
import 'package:family_planner/features/announcements/utils/announcement_utils.dart';
import 'package:family_planner/features/announcements/presentation/widgets/announcement_badge_row.dart';
import 'package:family_planner/features/announcements/presentation/widgets/announcement_meta_info.dart';
import 'package:family_planner/features/announcements/presentation/widgets/announcement_delete_dialog.dart';
import 'package:family_planner/shared/widgets/app_error_state.dart';
import 'package:family_planner/shared/widgets/rich_text_viewer.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 공지사항 상세 화면
class AnnouncementDetailScreen extends ConsumerWidget {
  final String announcementId;

  const AnnouncementDetailScreen({
    super.key,
    required this.announcementId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final announcementAsync =
        ref.watch(announcementDetailProvider(announcementId));
    final isAdmin = ref.watch(isAdminProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.announcement_detail),
        actions: [
          if (isAdmin)
            _buildAdminMenu(context, ref, l10n, announcementAsync),
        ],
      ),
      body: announcementAsync.when(
        data: (announcement) {
          Future(() {
            ref.read(announcementListProvider.notifier).markAsRead(announcementId);
          });

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.spaceL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnnouncementBadgeRow(
                  category: announcement.category,
                  isPinned: announcement.isPinned,
                ),
                if (announcement.isPinned || announcement.category != null)
                  const SizedBox(height: AppSizes.spaceM),

                // 제목
                Text(
                  announcement.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: AppSizes.spaceM),

                // 메타 정보
                AnnouncementMetaInfo(announcement: announcement),
                const SizedBox(height: AppSizes.spaceL),

                const Divider(),
                const SizedBox(height: AppSizes.spaceL),

                // 내용
                RichTextViewer(content: announcement.content),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => AppErrorState(
          error: error,
          title: l10n.announcement_loadError,
          onRetry: () => ref.invalidate(announcementDetailProvider(announcementId)),
        ),
      ),
    );
  }

  Widget _buildAdminMenu(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    AsyncValue announcementAsync,
  ) {
    return PopupMenuButton<String>(
      onSelected: (value) => _handleMenuAction(
        context,
        ref,
        l10n,
        value,
        announcementAsync,
      ),
      itemBuilder: (context) {
        final announcement = announcementAsync.value;
        final isPinned = announcement?.isPinned ?? false;

        return [
          PopupMenuItem(
            value: 'edit',
            child: Row(
              children: [
                const Icon(Icons.edit, size: AppSizes.iconSmall),
                const SizedBox(width: AppSizes.spaceS),
                Text(l10n.common_edit),
              ],
            ),
          ),
          PopupMenuItem(
            value: isPinned ? 'unpin' : 'pin',
            child: Row(
              children: [
                Icon(
                  isPinned ? Icons.push_pin_outlined : Icons.push_pin,
                  size: AppSizes.iconSmall,
                ),
                const SizedBox(width: AppSizes.spaceS),
                Text(isPinned ? l10n.announcement_unpin : l10n.announcement_pin),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                const Icon(Icons.delete, size: AppSizes.iconSmall, color: AppColors.error),
                const SizedBox(width: AppSizes.spaceS),
                Text(l10n.common_delete, style: const TextStyle(color: AppColors.error)),
              ],
            ),
          ),
        ];
      },
    );
  }

  Future<void> _handleMenuAction(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    String value,
    AsyncValue announcementAsync,
  ) async {
    if (value == 'edit') {
      context.push('/announcements/$announcementId/edit');
    } else if (value == 'delete') {
      AnnouncementDeleteDialog.show(context, ref, announcementId);
    } else if (value == 'pin' || value == 'unpin') {
      final announcement = announcementAsync.value;
      if (announcement != null) {
        final newPinState = value == 'pin';
        await ref
            .read(announcementManagementProvider.notifier)
            .togglePin(announcementId, newPinState);

        if (context.mounted) {
          ref.invalidate(announcementListProvider);
          ref.invalidate(announcementDetailProvider(announcementId));

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                newPinState
                    ? l10n.announcement_pinSuccess
                    : l10n.announcement_unpinSuccess,
              ),
            ),
          );
        }
      }
    }
  }
}
