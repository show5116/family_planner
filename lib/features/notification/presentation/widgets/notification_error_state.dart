import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';

/// 알림 에러 상태 위젯
class NotificationErrorState extends StatelessWidget {
  final Object error;
  final VoidCallback? onRetry;
  final String title;

  const NotificationErrorState({
    super.key,
    required this.error,
    this.onRetry,
    this.title = '알림을 불러오는 데 실패했습니다',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: AppSizes.spaceM),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSizes.spaceS),
          Text(
            error.toString(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: AppSizes.spaceM),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('다시 시도'),
            ),
          ],
        ],
      ),
    );
  }
}
