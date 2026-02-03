import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/settings/common/providers/bottom_navigation_settings_provider.dart';

/// 네비게이션 슬롯 미리보기 위젯
class NavigationSlotPreview extends StatelessWidget {
  final NavigationItem item;
  final String slotNumber;
  final bool isFixed;
  final VoidCallback? onTap;

  const NavigationSlotPreview({
    super.key,
    required this.item,
    required this.slotNumber,
    required this.isFixed,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceM),
        decoration: BoxDecoration(
          border: Border.all(
            color: isFixed
                ? Colors.grey.shade300
                : Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
            width: isFixed ? 1 : 2,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isFixed
              ? Colors.grey.shade50
              : Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              item.selectedIcon,
              size: 24,
              color: isFixed
                  ? Colors.grey
                  : Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: AppSizes.spaceXS),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isFixed ? FontWeight.normal : FontWeight.bold,
                color: isFixed ? Colors.grey : null,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              slotNumber,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade600,
              ),
            ),
            if (isFixed)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(
                  Icons.lock_outline,
                  size: 12,
                  color: Colors.grey.shade400,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
