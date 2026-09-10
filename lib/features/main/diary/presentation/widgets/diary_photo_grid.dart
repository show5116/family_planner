import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/main/diary/data/models/diary_media_models.dart';
import 'package:family_planner/features/main/diary/data/models/diary_models.dart';
import 'package:family_planner/features/main/diary/providers/diary_provider.dart';
import 'package:family_planner/shared/widgets/app_empty_state.dart';
import 'package:family_planner/shared/widgets/app_error_state.dart';

/// 사진 그리드 뷰 — "그때 그 사진"을 찾는 뷰
///
/// 날짜·본문을 걷어내고 정사각 썸네일만 빽빽하게 깐다. 탭하면 그날 일기로 간다
/// (사진 한 장이 아니라 그날을 찾는 것이 이 뷰의 목적이다).
class DiaryPhotoGrid extends ConsumerStatefulWidget {
  const DiaryPhotoGrid({super.key, required this.onDiaryTap});

  final void Function(String diaryId) onDiaryTap;

  @override
  ConsumerState<DiaryPhotoGrid> createState() => _DiaryPhotoGridState();
}

class _DiaryPhotoGridState extends ConsumerState<DiaryPhotoGrid> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 300) {
      ref.read(diaryListProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final listState = ref.watch(diaryListProvider);

    return listState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => AppErrorState(
        error: error,
        title: l10n.diary_load_error,
        onRetry: () => ref.read(diaryListProvider.notifier).refresh(),
      ),
      data: (state) {
        final photos = _flatten(state.items);

        if (photos.isEmpty) {
          return RefreshIndicator(
            onRefresh: ref.read(diaryListProvider.notifier).refresh,
            child: ListView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.6,
                  child: ref.watch(diaryHasActiveFilterProvider)
                      ? AppEmptyState(
                          icon: Icons.search_off,
                          message: l10n.diary_search_empty,
                        )
                      : AppEmptyState(
                          icon: Icons.photo_library_outlined,
                          message: l10n.diary_photos_empty,
                        ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: ref.read(diaryListProvider.notifier).refresh,
          child: GridView.builder(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppSizes.spaceXS),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
            ),
            itemCount: photos.length,
            itemBuilder: (context, index) {
              final photo = photos[index];
              return InkWell(
                onTap: () => widget.onDiaryTap(photo.diaryId),
                child: _GridThumb(media: photo.media),
              );
            },
          ),
        );
      },
    );
  }

  /// 일기별 첨부를 한 줄로 편다 (목록 순서 = 날짜 역순을 그대로 따른다)
  List<_PhotoRef> _flatten(List<DiaryModel> items) {
    return [
      for (final diary in items)
        for (final media in diary.media)
          _PhotoRef(diaryId: diary.id, media: media),
    ];
  }
}

class _PhotoRef {
  const _PhotoRef({required this.diaryId, required this.media});

  final String diaryId;
  final DiaryMedia media;
}

class _GridThumb extends StatelessWidget {
  const _GridThumb({required this.media});

  final DiaryMedia media;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return CachedNetworkImage(
      imageUrl: media.displayThumbnail,
      fit: BoxFit.cover,
      placeholder: (_, _) => Container(
        color: colorScheme.surfaceContainerHighest,
      ),
      errorWidget: (_, _, _) => Container(
        color: colorScheme.surfaceContainerHighest,
        child: Icon(
          Icons.broken_image_outlined,
          color: colorScheme.onSurfaceVariant,
          size: AppSizes.iconMedium,
        ),
      ),
    );
  }
}
