import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/announcements/providers/announcement_provider.dart';
import 'package:family_planner/features/announcements/utils/announcement_utils.dart';

/// 공지사항 상세 화면
class AnnouncementDetailScreen extends ConsumerWidget {
  final String announcementId;

  const AnnouncementDetailScreen({
    super.key,
    required this.announcementId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcementAsync =
        ref.watch(announcementDetailProvider(announcementId));
    final isAdmin = ref.watch(isAdminProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('공지사항'),
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(newPinState ? '공지사항이 고정되었습니다' : '고정이 해제되었습니다'),
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
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: AppSizes.iconSmall),
                        SizedBox(width: AppSizes.spaceS),
                        Text('수정'),
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
                        Text(isPinned ? '고정 해제' : '고정'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: AppSizes.iconSmall, color: AppColors.error),
                        SizedBox(width: AppSizes.spaceS),
                        Text('삭제', style: TextStyle(color: AppColors.error)),
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
                          '고정 공지',
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  ),
                if (announcement.isPinned) const SizedBox(height: AppSizes.spaceM),

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
                      '${announcement.readCount}명이 읽음',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.spaceL),

                const Divider(),
                const SizedBox(height: AppSizes.spaceL),

                // 내용 (마크다운 렌더링)
                MarkdownBody(
                  data: announcement.content,
                  styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
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
                '공지사항을 불러올 수 없습니다',
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
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('공지사항 삭제'),
        content: const Text('이 공지사항을 삭제하시겠습니까?\n삭제된 공지사항은 복구할 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();

              final success = await ref
                  .read(announcementManagementProvider.notifier)
                  .deleteAnnouncement(announcementId);

              if (context.mounted) {
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('공지사항이 삭제되었습니다')),
                  );
                  context.pop(); // 목록으로 돌아가기
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('공지사항 삭제에 실패했습니다')),
                  );
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }
}
