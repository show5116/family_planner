import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';

/// 권한 카테고리 헤더 위젯
class PermissionCategoryHeader extends StatelessWidget {
  final String category;
  final int count;

  const PermissionCategoryHeader({
    super.key,
    required this.category,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.spaceM),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spaceM,
              vertical: AppSizes.spaceS,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
            ),
            child: Text(
              category,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(width: AppSizes.spaceS),
          Text(
            '$count개',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
