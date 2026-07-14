import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/utils/extensions.dart';
import 'package:family_planner/features/main/routine/providers/routine_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/shared/widgets/app_empty_state.dart';
import 'package:family_planner/shared/widgets/app_error_state.dart';

/// 루틴 상세 - 배지 탭 (해당 루틴 기준으로 획득한 배지 목록)
class RoutineBadgesTab extends ConsumerWidget {
  const RoutineBadgesTab({super.key, required this.routineId});

  final String routineId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final badgesAsync = ref.watch(routineBadgesProvider(routineId));

    return badgesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => AppErrorState(
        error: error,
        title: l10n.routine_error_generic,
        onRetry: () => ref.invalidate(routineBadgesProvider(routineId)),
      ),
      data: (badges) {
        if (badges.isEmpty) {
          return AppEmptyState(
            icon: Icons.emoji_events_outlined,
            message: l10n.routine_badges_empty,
          );
        }
        return ListView.builder(
          padding: EdgeInsets.fromLTRB(
            AppSizes.spaceM,
            AppSizes.spaceM,
            AppSizes.spaceM,
            AppSizes.spaceM + MediaQuery.paddingOf(context).bottom,
          ),
          itemCount: badges.length,
          itemBuilder: (context, index) {
            final earned = badges[index];
            return Card(
              margin: const EdgeInsets.only(bottom: AppSizes.spaceS),
              child: ListTile(
                leading: Text(
                  earned.badge.iconEmoji ?? '🏅',
                  style: const TextStyle(fontSize: 28),
                ),
                title: Text(earned.badge.title),
                subtitle: earned.badge.description != null
                    ? Text(earned.badge.description!)
                    : null,
                trailing: Text(
                  earned.earnedAt.toDateString(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
