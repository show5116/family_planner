import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/diary/data/models/diary_models.dart';

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.history,
                    size: AppSizes.iconSmall,
                    color: colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: AppSizes.spaceS),
                  Text(
                    item.label,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
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
                    color: colorScheme.onPrimaryContainer
                        .withValues(alpha: 0.8),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
