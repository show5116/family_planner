import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/announcements/providers/announcement_provider.dart';
import 'package:family_planner/features/announcements/utils/announcement_utils.dart';
import 'package:family_planner/features/announcements/data/models/announcement_model.dart';
import 'package:family_planner/features/announcements/utils/announcement_category_helper.dart';
import 'package:family_planner/l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;
    final announcementsAsync = ref.watch(announcementListProvider);
    final isAdmin = ref.watch(isAdminProvider);
    final notifier = ref.read(announcementListProvider.notifier);
    final selectedCategory = notifier.selectedCategory;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.announcement_title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          // ADMIN만 작성 버튼 표시
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: l10n.announcement_create,
              onPressed: () {
                context.push('/announcements/create');
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // 카테고리 필터 칩
          _buildCategoryFilter(selectedCategory),
          // 공지사항 목록
          Expanded(
            child: RefreshIndicator(
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
          ),
        ],
      ),
    );
  }

  /// 카테고리 필터 칩
  Widget _buildCategoryFilter(AnnouncementCategory? selectedCategory) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      height: 56, // 고정 높이로 레이아웃 안정성 확보
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

  /// 빈 상태 위젯
  Widget _buildEmptyState() {
    final l10n = AppLocalizations.of(context)!;
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
            l10n.announcement_empty,
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
    final l10n = AppLocalizations.of(context)!;
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
            l10n.announcement_loadError,
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
            label: Text(l10n.common_retry),
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

  /// 마크다운 구조 제거 (미리보기용)
  String _stripMarkdown(String markdown) {
    return markdown
        // 헤더 제거 (# ## ### 등)
        .replaceAll(RegExp(r'^#+\s+', multiLine: true), '')
        // 볼드/이탤릭 제거 (**text**, *text*, __text__, _text_)
        .replaceAll(RegExp(r'\*\*([^*]+)\*\*'), r'$1')
        .replaceAll(RegExp(r'__([^_]+)__'), r'$1')
        .replaceAll(RegExp(r'\*([^*]+)\*'), r'$1')
        .replaceAll(RegExp(r'_([^_]+)_'), r'$1')
        // 링크 제거 [text](url)
        .replaceAll(RegExp(r'\[([^\]]+)\]\([^)]+\)'), r'$1')
        // 코드 블록 제거 ```code```
        .replaceAll(RegExp(r'```[^`]*```'), '')
        // 인라인 코드 제거 `code`
        .replaceAll(RegExp(r'`([^`]+)`'), r'$1')
        // 리스트 마커 제거 (-, *, +)
        .replaceAll(RegExp(r'^[\-\*\+]\s+', multiLine: true), '')
        // 숫자 리스트 마커 제거 (1. 2. 등)
        .replaceAll(RegExp(r'^\d+\.\s+', multiLine: true), '')
        // 인용 제거 (>)
        .replaceAll(RegExp(r'^>\s+', multiLine: true), '')
        // 구분선 제거 (---, ***)
        .replaceAll(RegExp(r'^[\-\*]{3,}$', multiLine: true), '')
        // 연속된 공백/줄바꿈을 하나로
        .replaceAll(RegExp(r'\n+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

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

              // 카테고리 뱃지 + 제목
              Row(
                children: [
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
                ],
              ),
              if (announcement.category != null) const SizedBox(height: AppSizes.spaceS),

              // 제목
              Text(
                announcement.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: announcement.isRead ? null : AppColors.primary,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSizes.spaceS),

              // 내용 미리보기 (마크다운 구조 제거)
              Text(
                _stripMarkdown(announcement.content),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              // 읽은 사람 수
              if (announcement.readCount > 0) ...[
                const SizedBox(height: AppSizes.spaceS),
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
            ],
          ),
        ),
      ),
    );
  }
}
