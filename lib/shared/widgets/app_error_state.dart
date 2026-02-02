import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';

/// 앱 전역 에러 상태 위젯
///
/// 데이터 로드 실패 시 표시하는 공통 위젯입니다.
class AppErrorState extends StatelessWidget {
  final Object error;
  final String title;
  final VoidCallback? onRetry;

  const AppErrorState({
    super.key,
    required this.error,
    required this.title,
    this.onRetry,
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
              Icons.error_outline,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: AppSizes.spaceM),
            Text(
              title,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.spaceS),
            Text(
              error.toString(),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSizes.spaceL),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('다시 시도'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
