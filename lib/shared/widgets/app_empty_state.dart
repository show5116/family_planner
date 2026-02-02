import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';

/// 앱 전역 빈 상태 위젯
///
/// 데이터가 없을 때 표시하는 공통 위젯입니다.
class AppEmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? subtitle;
  final Widget? action;

  const AppEmptyState({
    super.key,
    required this.icon,
    required this.message,
    this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: AppSizes.spaceM),
            Text(
              message,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: AppSizes.spaceS),
              Text(
                subtitle!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: AppSizes.spaceL),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
