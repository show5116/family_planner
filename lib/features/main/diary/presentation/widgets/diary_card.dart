import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/main/diary/data/models/diary_models.dart';
import 'package:family_planner/features/main/diary/data/utils/diary_date.dart';

/// 타임라인 카드
///
/// Phase 1은 텍스트 전용이라 텍스트 카드만 그린다.
/// Phase 2에서 사진이 붙으면 사진이 주인공인 레이아웃으로 분기한다.
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

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceM,
        vertical: AppSizes.spaceXS,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        child: Padding(
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
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
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
