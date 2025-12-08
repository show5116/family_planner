import 'package:flutter/material.dart';
import 'package:family_planner/core/constants/app_sizes.dart';

/// 공통 로딩 위젯
class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

/// 공통 에러 위젯
class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final String? retryButtonText;

  const ErrorView({
    super.key,
    required this.message,
    this.onRetry,
    this.retryButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceL),
            child: Text(
              message,
              textAlign: TextAlign.center,
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: Text(retryButtonText ?? '다시 시도'),
            ),
          ],
        ],
      ),
    );
  }
}

/// 공통 빈 상태 위젯
class EmptyView extends StatelessWidget {
  final String message;
  final IconData? icon;

  const EmptyView({
    super.key,
    required this.message,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
          ],
          Text(
            message,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

/// 역할 뱃지 위젯
class RoleBadge extends StatelessWidget {
  final String roleName;
  final Color color;

  const RoleBadge({
    super.key,
    required this.roleName,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        roleName,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// 정보 카드 위젯
class InfoCard extends StatelessWidget {
  final String title;
  final String message;
  final List<String>? bulletPoints;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? textColor;

  const InfoCard({
    super.key,
    required this.title,
    required this.message,
    this.bulletPoints,
    this.backgroundColor,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? Colors.blue[50];
    final iColor = iconColor ?? Colors.blue[700];
    final tColor = textColor ?? Colors.blue[900];

    return Card(
      color: bgColor,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, size: 20, color: iColor),
                const SizedBox(width: AppSizes.spaceS),
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: iColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spaceS),
            Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(color: tColor),
            ),
            if (bulletPoints != null && bulletPoints!.isNotEmpty)
              ...bulletPoints!.map((point) => Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '• $point',
                  style: theme.textTheme.bodySmall?.copyWith(color: tColor),
                ),
              )),
          ],
        ),
      ),
    );
  }
}
