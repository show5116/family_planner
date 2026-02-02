import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';

/// 상태 뱃지 위젯
///
/// 카테고리, 상태, 답변 수 등을 표시하는 공통 뱃지입니다.
class StatusBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const StatusBadge({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceS,
        vertical: AppSizes.spaceXS,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: AppSizes.iconSmall,
            color: color,
          ),
          const SizedBox(width: AppSizes.spaceXS),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
