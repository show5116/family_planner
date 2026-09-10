import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/main/diary/data/models/diary_media_models.dart';
import 'package:family_planner/features/main/diary/presentation/screens/diary_media_viewer_screen.dart';
import 'package:family_planner/features/main/diary/providers/media_upload_provider.dart';

/// 첨부 썸네일 한 변 (편집 스트립)
const double _thumbSize = 84;

/// 상세 화면의 미디어 갤러리 (읽기 전용)
///
/// 본문 Delta에는 미디어를 임베드하지 않는다. 첨부는 언제나 이 그리드가 소유하며,
/// 그래서 "본문에서 지웠는데 파일은 남는" 누수가 구조적으로 생기지 않는다.
class DiaryMediaGallery extends StatelessWidget {
  const DiaryMediaGallery({super.key, required this.media});

  final List<DiaryMedia> media;

  @override
  Widget build(BuildContext context) {
    if (media.isEmpty) return const SizedBox.shrink();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: AppSizes.spaceXS,
        crossAxisSpacing: AppSizes.spaceXS,
      ),
      itemCount: media.length,
      itemBuilder: (context, index) => InkWell(
        onTap: () => DiaryMediaViewerScreen.open(
          context,
          media: media,
          initialIndex: index,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          child: _RemoteThumb(media: media[index]),
        ),
      ),
    );
  }
}

/// 다듬기 화면의 첨부 편집 스트립
///
/// 가로 스크롤 + 드래그 순서 변경. 세로 그리드로 두면 키보드가 올라왔을 때
/// 본문이 설 자리가 없어진다 — 첨부는 한 줄로 눕히는 편이 편집 화면에 맞는다.
class DiaryMediaEditor extends ConsumerWidget {
  const DiaryMediaEditor({
    super.key,
    required this.existing,
    required this.onAdd,
    required this.onDelete,
    required this.onReorder,
  });

  /// 이미 일기에 붙어 있는 첨부 (서버 확정분)
  final List<DiaryMedia> existing;

  final VoidCallback onAdd;
  final void Function(DiaryMedia media) onDelete;
  final void Function(List<DiaryMedia> reordered) onReorder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    // 업로드 중이거나 실패한 항목만 여기서 그린다.
    // 확정된 항목은 화면이 [existing]으로 다시 내려주므로 중복 표시하지 않는다.
    final pending = ref
        .watch(mediaUploadProvider)
        .items
        .where((i) => !i.isDone)
        .toList();

    return SizedBox(
      height: _thumbSize + AppSizes.spaceS * 2,
      child: Row(
        children: [
          Expanded(
            child: ReorderableListView.builder(
              scrollDirection: Axis.horizontal,
              buildDefaultDragHandles: false,
              padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceS),
              itemCount: existing.length + pending.length,
              // onReorderItem은 newIndex를 이미 보정해서 준다
              // (제거 후 기준). 직접 -1 하면 한 칸씩 밀린다.
              onReorderItem: (oldIndex, newIndex) {
                // 업로드 중인 항목은 아직 서버에 순서가 없다 — 확정분끼리만 옮긴다
                if (oldIndex >= existing.length) return;
                if (newIndex >= existing.length) newIndex = existing.length - 1;

                final next = [...existing];
                next.insert(newIndex, next.removeAt(oldIndex));
                onReorder(next);
              },
              itemBuilder: (context, index) {
                if (index < existing.length) {
                  final media = existing[index];
                  return ReorderableDragStartListener(
                    key: ValueKey(media.id),
                    index: index,
                    child: _EditableThumb(
                      media: media,
                      allMedia: existing,
                      indexInAll: index,
                      onDelete: () => _confirmDelete(context, media),
                    ),
                  );
                }

                final item = pending[index - existing.length];
                return _PendingThumb(
                  key: ValueKey(item.localId),
                  item: item,
                  onCancel: () => ref
                      .read(mediaUploadProvider.notifier)
                      .remove(item.localId),
                  onRetry: () => ref
                      .read(mediaUploadProvider.notifier)
                      .upload(item.localId),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: AppSizes.spaceS),
            child: _AddButton(label: l10n.diary_add_photo, onTap: onAdd),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, DiaryMedia media) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.diary_media_delete_confirm),
        // 미디어는 즉시·영구 삭제다. 문구 자체가 스펙의 일부다.
        content: Text(l10n.diary_media_delete_permanent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(MaterialLocalizations.of(context).deleteButtonTooltip),
          ),
        ],
      ),
    );

    if (confirmed == true) onDelete(media);
  }
}

// ── 썸네일들 ─────────────────────────────────────────────────────────────────

class _RemoteThumb extends StatelessWidget {
  const _RemoteThumb({required this.media});

  final DiaryMedia media;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return CachedNetworkImage(
      imageUrl: media.displayThumbnail,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
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

class _EditableThumb extends StatelessWidget {
  const _EditableThumb({
    required this.media,
    required this.allMedia,
    required this.indexInAll,
    required this.onDelete,
  });

  final DiaryMedia media;
  final List<DiaryMedia> allMedia;
  final int indexInAll;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSizes.spaceS),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => DiaryMediaViewerScreen.open(
              context,
              media: allMedia,
              initialIndex: indexInAll,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              child: SizedBox(
                width: _thumbSize,
                height: _thumbSize,
                child: _RemoteThumb(media: media),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: _ThumbAction(icon: Icons.close, onTap: onDelete),
          ),
        ],
      ),
    );
  }
}

/// 업로드 중·실패한 항목
///
/// 진행률과 취소를 항목 위에 얹는다. 실패해도 큐에서 빼지 않으므로 여기서
/// 바로 재시도할 수 있다.
class _PendingThumb extends StatelessWidget {
  const _PendingThumb({
    super.key,
    required this.item,
    required this.onCancel,
    required this.onRetry,
  });

  final PendingUpload item;
  final VoidCallback onCancel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(right: AppSizes.spaceS),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            child: SizedBox(
              width: _thumbSize,
              height: _thumbSize,
              child: Opacity(
                opacity: 0.55,
                child: Image.memory(item.bytes, fit: BoxFit.cover),
              ),
            ),
          ),
          Positioned.fill(
            child: Center(
              child: item.hasError
                  ? IconButton(
                      onPressed: onRetry,
                      icon: const Icon(Icons.refresh),
                      color: AppColors.error,
                      tooltip: AppLocalizations.of(context)!.diary_upload_retry,
                    )
                  : SizedBox(
                      width: AppSizes.iconLarge,
                      height: AppSizes.iconLarge,
                      child: CircularProgressIndicator(
                        value: item.progress > 0 ? item.progress : null,
                        strokeWidth: 3,
                        color: colorScheme.primary,
                      ),
                    ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: _ThumbAction(icon: Icons.close, onTap: onCancel),
          ),
        ],
      ),
    );
  }
}

class _ThumbAction extends StatelessWidget {
  const _ThumbAction({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(2),
        padding: const EdgeInsets.all(2),
        decoration: const BoxDecoration(
          color: Colors.black54,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: AppSizes.iconSmall, color: Colors.white),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      child: Container(
        width: _thumbSize,
        height: _thumbSize,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo_outlined, color: colorScheme.primary),
            const SizedBox(height: AppSizes.spaceXS),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
