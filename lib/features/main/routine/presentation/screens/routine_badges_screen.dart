import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/utils/extensions.dart';
import 'package:family_planner/features/main/routine/providers/routine_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/shared/widgets/app_empty_state.dart';

/// 내 배지 목록 화면 (전체 카탈로그 + 획득 여부 표시)
class RoutineBadgesScreen extends ConsumerWidget {
  const RoutineBadgesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final catalogAsync = ref.watch(routineBadgeCatalogProvider);
    final myBadgesAsync = ref.watch(routineMyBadgesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.routine_badges_title)),
      body: catalogAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(l10n.routine_error_generic)),
        data: (catalog) {
          if (catalog.isEmpty) {
            return AppEmptyState(
              icon: Icons.emoji_events_outlined,
              message: l10n.routine_badges_empty,
            );
          }

          final myBadges = myBadgesAsync.valueOrNull ?? [];
          final earnedByBadgeId = {
            for (final e in myBadges) e.badgeId: e,
          };

          return GridView.builder(
            padding: const EdgeInsets.all(AppSizes.spaceM),
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
                                  : Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                            ),
                      ),
                      if (earned) ...[
                        const SizedBox(height: AppSizes.spaceXS),
                        Text(
                          earnedRecord.earnedAt.toDateString(),
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
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
      ),
    );
  }
}
