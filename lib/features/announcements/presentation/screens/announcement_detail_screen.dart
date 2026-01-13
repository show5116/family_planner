import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/announcements/providers/announcement_provider.dart';
import 'package:family_planner/features/announcements/utils/announcement_utils.dart';
import 'package:family_planner/features/announcements/utils/announcement_category_helper.dart';
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
          // ADMIN만 수정/삭제 버튼 표시
          if (isAdmin)
            PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'edit') {
                  context.push('/announcements/$announcementId/edit');
                } else if (value == 'delete') {
                  _showDeleteConfirmDialog(context, ref);
                } else if (value == 'pin' || value == 'unpin') {
                  final announcement = announcementAsync.value;
                  if (announcement != null) {
                    final newPinState = value == 'pin';
                    await ref
                        .read(announcementManagementProvider.notifier)
                        .togglePin(announcementId, newPinState);

                    if (context.mounted) {
                      // 목록 및 상세 정보 새로고침
                      ref.invalidate(announcementListProvider);
                      ref.invalidate(announcementDetailProvider(announcementId));

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(newPinState ? l10n.announcement_pinSuccess : l10n.announcement_unpinSuccess),
                        ),
                      );
                    }
                  }
                }
              },
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
            ),
        ],
      ),
      body: announcementAsync.when(
        data: (announcement) {
          final dateFormat = DateFormat('yyyy년 MM월 dd일 HH:mm');

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.spaceL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 뱃지 영역 (카테고리 + 고정)
                Row(
                  children: [
                    // 카테고리 뱃지
                    if (announcement.category != null) ...[
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
                      const SizedBox(width: AppSizes.spaceS),
                    ],
                    // 고정 뱃지
                    if (announcement.isPinned)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.spaceS,
                          vertical: AppSizes.spaceXS,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
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
                              style:
                                  Theme.of(context).textTheme.labelSmall?.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                            ),
                          ],
                        ),
                      ),
                  ],
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
                const SizedBox(height: AppSizes.spaceL),

                const Divider(),
                const SizedBox(height: AppSizes.spaceL),

                // 내용 (HTML 렌더링)
                RichTextViewer(
                  content: announcement.content,
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: AppSizes.iconXLarge * 2,
                color: AppColors.error,
              ),
              const SizedBox(height: AppSizes.spaceL),
              Text(
                l10n.announcement_loadError,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSizes.spaceS),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 삭제 확인 다이얼로그
  void _showDeleteConfirmDialog(BuildContext context, WidgetRef ref) {
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
            onPressed: () async {
              Navigator.of(dialogContext).pop();

              final success = await ref
                  .read(announcementManagementProvider.notifier)
                  .deleteAnnouncement(announcementId);

              if (context.mounted) {
                if (success) {
                  // 목록 새로고침
                  ref.invalidate(announcementListProvider);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.announcement_deleteSuccess)),
                  );
                  context.pop(); // 목록으로 돌아가기
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.announcement_deleteError)),
                  );
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(l10n.common_delete),
          ),
        ],
      ),
    );
  }
}
