import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';

/// 알림 빈 상태 위젯
class NotificationEmptyState extends StatelessWidget {
  final IconData icon;
  final String message;

  const NotificationEmptyState({
    super.key,
    this.icon = Icons.notifications_none,
    this.message = '알림이 없습니다',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: AppSizes.spaceM),
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
          ),
        ],
      ),
    );
  }
}
