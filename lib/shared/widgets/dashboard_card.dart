import 'package:flutter/material.dart';
import 'package:family_planner/core/constants/app_sizes.dart';

/// 대시보드 위젯 카드
/// 모든 대시보드 위젯의 기본 레이아웃을 제공
class DashboardCard extends StatelessWidget {
  const DashboardCard({
    super.key,
    required this.title,
    required this.child,
    this.icon,
    this.action,
    this.onTap,
  });

  final String title;
  final Widget child;
  final IconData? icon;
  final Widget? action;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 헤더 (제목, 아이콘, 액션)
              Row(
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      size: AppSizes.iconMedium,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: AppSizes.spaceS),
                  ],
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  if (action != null) action!,
                ],
              ),
              const SizedBox(height: AppSizes.spaceM),
              // 내용
              child,
            ],
          ),
        ),
      ),
    );
  }
}
