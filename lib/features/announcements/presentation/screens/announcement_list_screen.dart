import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/announcements/providers/announcement_provider.dart';
import 'package:family_planner/features/announcements/utils/announcement_utils.dart';
import 'package:family_planner/features/announcements/presentation/widgets/announcement_card.dart';
import 'package:family_planner/features/announcements/presentation/widgets/announcement_category_filter.dart';
import 'package:family_planner/shared/widgets/app_empty_state.dart';
import 'package:family_planner/shared/widgets/app_error_state.dart';
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
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
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
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: l10n.announcement_create,
              onPressed: () => context.push('/announcements/create'),
            ),
        ],
      ),
      body: Column(
        children: [
          AnnouncementCategoryFilter(selectedCategory: selectedCategory),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref.read(announcementListProvider.notifier).refresh(),
              child: announcementsAsync.when(
                data: (announcements) {
                  if (announcements.isEmpty) {
                    return AppEmptyState(
                      icon: Icons.campaign_outlined,
                      message: l10n.announcement_empty,
                    );
                  }

                  return ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(AppSizes.spaceM),
                    itemCount: announcements.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: AppSizes.spaceM),
                    itemBuilder: (context, index) {
                      final announcement = announcements[index];
                      return AnnouncementCard(
                        announcement: announcement,
                        isAdmin: isAdmin,
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => AppErrorState(
                  error: error,
                  title: l10n.announcement_loadError,
                  onRetry: () => ref.read(announcementListProvider.notifier).refresh(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
