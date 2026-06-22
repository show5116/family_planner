import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/main/task/data/models/anniversary_model.dart';
import 'package:family_planner/features/main/task/providers/anniversary_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/shared/widgets/dashboard_card.dart';

/// 기념일 요약 대시보드 위젯
class AnniversarySummaryWidget extends ConsumerWidget {
  const AnniversarySummaryWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final anniversariesAsync = ref.watch(allGroupsAnniversariesProvider);

    return DashboardCard(
      title: l10n.anniversary_widgetTitle,
      icon: Icons.celebration_outlined,
      action: TextButton(
        onPressed: () => context.push(AppRoutes.anniversaryManagement),
        child: Text(l10n.common_view_all),
      ),
      onTap: () => context.push(AppRoutes.anniversaryManagement),
      child: anniversariesAsync.when(
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.all(AppSizes.spaceM),
            child: CircularProgressIndicator(),
          ),
        ),
        error: (_, _) => _EmptyState(message: l10n.anniversary_widgetEmpty),
        data: (anniversaries) {
          if (anniversaries.isEmpty) {
            return _EmptyState(message: l10n.anniversary_widgetEmpty);
          }
          final sorted = [...anniversaries]
            ..sort((a, b) =>
                (a.daysUntilNext ?? 999).compareTo(b.daysUntilNext ?? 999));
          return Column(
            children: sorted
                .take(5)
                .map((a) => _AnniversaryItem(anniversary: a))
                .toList(),
          );
        },
      ),
    );
  }
}

class _AnniversaryItem extends StatelessWidget {
  const _AnniversaryItem({required this.anniversary});

  final AnniversaryModel anniversary;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final days = anniversary.daysUntilNext;

    String dDayText;
    Color dDayColor;
    if (days == null) {
      dDayText = '';
      dDayColor = colorScheme.onSurfaceVariant;
    } else if (days == 0) {
      dDayText = 'D-Day';
      dDayColor = colorScheme.error;
    } else {
      dDayText = 'D-$days';
      dDayColor = days <= 7 ? colorScheme.primary : colorScheme.onSurfaceVariant;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.spaceS),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
            ),
            child: Center(
              child: anniversary.emoji != null
                  ? Text(anniversary.emoji!, style: const TextStyle(fontSize: 22))
                  : Icon(Icons.celebration, color: colorScheme.primary, size: AppSizes.iconMedium),
            ),
          ),
          const SizedBox(width: AppSizes.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  anniversary.title,
                  style: Theme.of(context).textTheme.bodyLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${anniversary.date.month}/${anniversary.date.day} · D+${anniversary.daysSince}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          if (dDayText.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: dDayColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              ),
              child: Text(
                dDayText,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: dDayColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.celebration_outlined,
            size: 48,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: AppSizes.spaceS),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}
