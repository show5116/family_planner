import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/utils/extensions.dart';
import 'package:family_planner/features/main/routine/providers/routine_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/shared/widgets/app_empty_state.dart';
import 'package:family_planner/shared/widgets/app_error_state.dart';

/// 내 배지 목록 화면 (전체 카탈로그 + 획득 여부 표시).
///
/// 배지는 개별 습관이 아니라 **일일 목표 달성** 기준으로 부여된다.
/// 습관별 연속 기록은 루틴 상세의 통계 탭에서 볼 수 있다.
class RoutineBadgesScreen extends StatelessWidget {
  const RoutineBadgesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.routine_badges_title)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.spaceM,
              AppSizes.spaceM,
              AppSizes.spaceM,
              0,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.flag_outlined,
                  size: 18,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: AppSizes.spaceXS),
                Expanded(
                  child: Text(
                    l10n.routine_badges_goal_subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Expanded(child: RoutineBadgeGrid()),
        ],
      ),
    );
  }
}

/// 배지 카탈로그 그리드(전체 카탈로그 + 획득 여부 표시). Scaffold 없이
/// 그리드만 반환하므로 전용 화면([RoutineBadgesScreen])과 통합 통계
/// 화면 양쪽에서 섹션으로 재사용할 수 있다.
class RoutineBadgeGrid extends ConsumerWidget {
  const RoutineBadgeGrid({super.key, this.shrinkWrap = false});

  /// true면 스크롤 가능한 부모(예: 통계 화면의 ListView) 안에 넣기 위해
  /// 그리드 자체 스크롤을 끄고 내용 크기만큼만 차지한다.
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final catalogAsync = ref.watch(routineBadgeCatalogProvider);
    final myBadgesAsync = ref.watch(routineMyBadgesProvider);

    return catalogAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => AppErrorState(
        error: error,
        title: l10n.routine_error_generic,
        onRetry: () => ref.invalidate(routineBadgeCatalogProvider),
      ),
      data: (catalog) {
        if (catalog.isEmpty) {
          return AppEmptyState(
            icon: Icons.emoji_events_outlined,
            message: l10n.routine_badges_empty,
          );
        }

        final myBadges = myBadgesAsync.valueOrNull ?? [];
        final earnedByBadgeId = {for (final e in myBadges) e.badgeId: e};

        return GridView.builder(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          shrinkWrap: shrinkWrap,
          physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: AppSizes.spaceM,
            crossAxisSpacing: AppSizes.spaceM,
            childAspectRatio: 0.85,
          ),
          itemCount: catalog.length,
          itemBuilder: (context, index) {
            final badge = catalog[index];
            final earnedRecord = earnedByBadgeId[badge.id];
            final earned = earnedRecord != null;

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.spaceM),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Opacity(
                      opacity: earned ? 1.0 : 0.3,
                      child: Text(
                        badge.iconEmoji ?? '🏅',
                        style: const TextStyle(fontSize: 40),
                      ),
                    ),
                    const SizedBox(height: AppSizes.spaceS),
                    Text(
                      badge.title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: earned
                            ? null
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (earned) ...[
                      const SizedBox(height: AppSizes.spaceXS),
                      Text(
                        earnedRecord.earnedAt.toDateString(),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
