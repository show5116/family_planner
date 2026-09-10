import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/main/diary/data/models/diary_models.dart';

/// 회고 카드 썸네일 한 변
const double _thumbSize = 72;

/// "n개월 전 오늘" 회고 카드
///
/// 찾으러 가지 않아도 올라오는 유일한 뷰. 타임라인 최상단에만 노출한다.
/// 보여줄 게 없으면 위젯 자체를 그리지 않는다 (빈 카드로 자리 차지 금지).
class FlashbackCard extends StatelessWidget {
  const FlashbackCard({super.key, required this.item, this.onTap});

  final DiaryFlashbackItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final thumbnailUrl = item.thumbnailUrl;

    return Card(
      margin: const EdgeInsets.fromLTRB(
        AppSizes.spaceM,
        AppSizes.spaceM,
        AppSizes.spaceM,
        AppSizes.spaceS,
      ),
      color: colorScheme.primaryContainer,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 사진이 있으면 앞에 세운다 — 회고의 위력은 사진에서 나온다
              if (thumbnailUrl != null) ...[
                _Thumbnail(url: thumbnailUrl),
                const SizedBox(width: AppSizes.spaceM),
              ],
              Expanded(child: _buildText(context, theme, colorScheme)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildText(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(
              Icons.history,
              size: AppSizes.iconSmall,
              color: colorScheme.onPrimaryContainer,
            ),
            const SizedBox(width: AppSizes.spaceS),
            Expanded(
              child: Text(
                _label(context),
                style: theme.textTheme.labelLarge?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (item.mood != null) ...[
              const SizedBox(width: AppSizes.spaceS),
              Text(item.mood!, style: theme.textTheme.bodyMedium),
            ],
          ],
        ),
        if (item.title != null && item.title!.isNotEmpty) ...[
          const SizedBox(height: AppSizes.spaceS),
          Text(
            item.title!,
            style: theme.textTheme.titleSmall?.copyWith(
              color: colorScheme.onPrimaryContainer,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        if (item.excerpt != null && item.excerpt!.isNotEmpty) ...[
          const SizedBox(height: AppSizes.spaceXS),
          Text(
            item.excerpt!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  /// 회고 라벨 문구
  ///
  /// 서버가 주는 `label`은 한국어로 고정돼 있어 그대로 쓰면 다른 언어 사용자에게
  /// 한국어가 노출된다. `unit`·`amount`로 각 언어의 복수형에 맞게 조립하고,
  /// 구버전 서버라 그 값이 없을 때만 `label`로 폴백한다.
  String _label(BuildContext context) {
    final unit = item.unit;
    final amount = item.amount;
    if (unit == null || amount == null) return item.label;

    final l10n = AppLocalizations.of(context)!;
    return switch (unit) {
      FlashbackUnit.month => l10n.diary_flashback_months(amount),
      FlashbackUnit.year => l10n.diary_flashback_years(amount),
    };
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      child: CachedNetworkImage(
        imageUrl: url,
        width: _thumbSize,
        height: _thumbSize,
        fit: BoxFit.cover,
        placeholder: (_, _) => Container(
          width: _thumbSize,
          height: _thumbSize,
          color: colorScheme.surfaceContainerHighest,
        ),
        // 썸네일 URL은 단기 만료라 화면을 오래 열어두면 만료될 수 있다.
        // 그때 깨진 아이콘을 띄우기보다 글자 카드로 돌아가는 편이 덜 거슬린다.
        errorWidget: (_, _, _) => const SizedBox.shrink(),
      ),
    );
  }
}
