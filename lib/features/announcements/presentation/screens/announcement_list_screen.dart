import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../providers/announcement_provider.dart';
import '../../utils/announcement_utils.dart';
import '../../data/models/announcement_model.dart';

/// 공지사항 목록 화면
class AnnouncementListScreen extends ConsumerStatefulWidget {
  const AnnouncementListScreen({super.key});

  @override
  ConsumerState<AnnouncementListScreen> createState() =>
      _AnnouncementListScreenState();
}

class _AnnouncementListScreenState
    extends ConsumerState<AnnouncementListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // 스크롤 리스너 추가 (무한 스크롤)
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// 스크롤 이벤트 처리 (무한 스크롤)
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      // 90% 스크롤 시 다음 페이지 로드
      final notifier = ref.read(announcementListProvider.notifier);
      if (notifier.hasMore) {
        notifier.loadMore();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final announcementsAsync = ref.watch(announcementListProvider);
    final isAdmin = ref.watch(isAdminProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('공지사항'),
        actions: [
          // ADMIN만 작성 버튼 표시
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: '공지사항 작성',
              onPressed: () {
                context.push('/announcements/create');
              },
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(announcementListProvider.notifier).refresh();
        },
        child: announcementsAsync.when(
          data: (announcements) {
            if (announcements.isEmpty) {
              return _buildEmptyState();
            }

            return ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.all(AppSizes.spaceM),
              itemCount: announcements.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppSizes.spaceM),
              itemBuilder: (context, index) {
                final announcement = announcements[index];
                return _AnnouncementCard(
                  announcement: announcement,
                  isAdmin: isAdmin,
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => _buildErrorState(error.toString()),
        ),
      ),
    );
  }

  /// 빈 상태 위젯
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.campaign_outlined,
            size: AppSizes.iconXLarge * 2,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: AppSizes.spaceL),
          Text(
            '등록된 공지사항이 없습니다',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }

  /// 에러 상태 위젯
  Widget _buildErrorState(String error) {
    return Center(
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
            error,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.spaceL),
          ElevatedButton.icon(
            onPressed: () {
              ref.read(announcementListProvider.notifier).refresh();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('다시 시도'),
          ),
        ],
      ),
    );
  }
}

/// 공지사항 카드 위젯
class _AnnouncementCard extends StatelessWidget {
  final AnnouncementModel announcement;
  final bool isAdmin;

  const _AnnouncementCard({
    required this.announcement,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy.MM.dd');

    return Card(
      elevation: AppSizes.elevation1,
      color: announcement.isPinned
          ? AppColors.primary.withOpacity(0.05)
          : AppColors.surface,
      child: InkWell(
        onTap: () {
          context.push('/announcements/${announcement.id}');
        },
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 헤더 (고정 아이콘 + 날짜)
              Row(
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
                  // 읽지 않은 공지 표시
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
              ),
              const SizedBox(height: AppSizes.spaceS),

              // 제목
              Text(
                announcement.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight:
                          announcement.isRead ? FontWeight.normal : FontWeight.bold,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSizes.spaceXS),

              // 내용 미리보기
              Text(
                announcement.content,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              // 첨부파일 및 읽은 사람 수
              if (announcement.attachments?.isNotEmpty == true ||
                  announcement.readCount > 0) ...[
                const SizedBox(height: AppSizes.spaceS),
                Row(
                  children: [
                    if (announcement.attachments?.isNotEmpty == true) ...[
                      Icon(
                        Icons.attach_file,
                        size: AppSizes.iconSmall,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: AppSizes.spaceXS),
                      Text(
                        '${announcement.attachments!.length}',
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                      ),
                      const SizedBox(width: AppSizes.spaceM),
                    ],
                    Icon(
                      Icons.visibility,
                      size: AppSizes.iconSmall,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: AppSizes.spaceXS),
                    Text(
                      '${announcement.readCount}명 읽음',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
