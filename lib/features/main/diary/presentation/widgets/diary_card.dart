import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/main/diary/data/models/diary_media_models.dart';
import 'package:family_planner/features/main/diary/data/models/diary_models.dart';
import 'package:family_planner/features/main/diary/data/utils/diary_date.dart';

/// 타임라인 카드
///
/// **사진이 있으면 사진이 주인공**이다. 사람은 글보다 사진으로 기억을 더듬으므로,
/// 썸네일을 곁들인 텍스트 카드가 아니라 그 반대로 짠다.
/// 사진이 없는 날은 텍스트 카드로 낮춰 목록에 리듬을 만든다.
class DiaryCard extends StatelessWidget {
  const DiaryCard({super.key, required this.diary, this.onTap});

  final DiaryModel diary;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final preview = _previewText();
    final isToday = isDiaryToday(diary.date);
    final cover = diary.media.firstOrNull;

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceM,
        vertical: AppSizes.spaceXS,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (cover != null)
              _CoverPhoto(cover: cover, extraCount: diary.media.length - 1),
            Padding(
              padding: const EdgeInsets.all(AppSizes.spaceM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        _formatDate(context),
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: isToday
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant,
                          fontWeight: isToday ? FontWeight.bold : null,
                        ),
                      ),
                      if (diary.mood != null) ...[
                        const SizedBox(width: AppSizes.spaceS),
                        Text(diary.mood!, style: theme.textTheme.bodyMedium),
                      ],
                      const Spacer(),
                      // 공유된 일기에만 뱃지를 단다 (기본이 비공개이므로 예외를 표시)
                      if (diary.visibility.isShared) const _SharedBadge(),
                    ],
                  ),
                  if (diary.title != null && diary.title!.isNotEmpty) ...[
                    const SizedBox(height: AppSizes.spaceS),
                    Text(
                      diary.title!,
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (preview.isNotEmpty) ...[
                    const SizedBox(height: AppSizes.spaceXS),
                    Text(
                      preview,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      // 사진이 주인공인 카드에서는 글을 짧게 물린다
                      maxLines: cover != null ? 2 : 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 목록 미리보기 문구
  ///
  /// 서버가 넣어준 평문(plainText)을 우선 쓴다. Delta 원문은 JSON이라
  /// 그대로 노출하면 안 된다.
  String _previewText() {
    final plain = diary.plainText?.trim();
    if (plain != null && plain.isNotEmpty) {
      return plain.replaceAll(RegExp(r'\s*\n\s*'), ' · ');
    }
    if (diary.format != DiaryFormat.delta) return diary.content.trim();
    return '';
  }

  String _formatDate(BuildContext context) {
    if (isDiaryToday(diary.date)) return AppLocalizations.of(context)!.diary_today;
    final locale = Localizations.localeOf(context).toLanguageTag();
    return DateFormat.MMMEd(locale).format(parseDiaryDate(diary.date));
  }
}

/// 카드 상단 대표 사진
///
/// 첨부가 여러 장이면 우하단에 남은 장수를 얹는다 — 상세로 들어가면 더 있다는
/// 신호가 있어야 탭할 이유가 생긴다.
class _CoverPhoto extends StatelessWidget {
  const _CoverPhoto({required this.cover, required this.extraCount});

  final DiaryMedia cover;
  final int extraCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 4 / 3,
          child: CachedNetworkImage(
            imageUrl: cover.displayThumbnail,
            fit: BoxFit.cover,
            width: double.infinity,
            placeholder: (_, _) => Container(
              color: colorScheme.surfaceContainerHighest,
            ),
            errorWidget: (_, _, _) => Container(
              color: colorScheme.surfaceContainerHighest,
              child: Icon(
                Icons.broken_image_outlined,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
        if (extraCount > 0)
          Positioned(
            right: AppSizes.spaceS,
            bottom: AppSizes.spaceS,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spaceS,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.photo_library_outlined,
                    size: 12,
                    color: Colors.white,
                  ),
                  const SizedBox(width: AppSizes.spaceXS),
                  Text(
                    '+$extraCount',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _SharedBadge extends StatelessWidget {
  const _SharedBadge();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceS,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.group_outlined,
            size: 12,
            color: colorScheme.onSecondaryContainer,
          ),
          const SizedBox(width: AppSizes.spaceXS),
          Text(
            l10n.diary_shared_badge,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSecondaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}
