import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/settings/models/permission.dart';
import 'package:flutter/material.dart';

/// 권한 카드 위젯
class PermissionCard extends StatelessWidget {
  final Permission permission;
  final VoidCallback onTap;
  final String activeText;
  final String inactiveText;

  const PermissionCard({
    required this.permission,
    required this.onTap,
    required this.activeText,
    required this.inactiveText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.spaceM),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // 권한 아이콘
                  Container(
                    padding: const EdgeInsets.all(AppSizes.spaceS),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                    ),
                    child: Icon(Icons.key, size: 20, color: Colors.blue[700]),
                  ),
                  const SizedBox(width: AppSizes.spaceM),
                  // 권한 정보
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          permission.name,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          permission.code,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                    fontFamily: 'monospace',
                                  ),
                        ),
                      ],
                    ),
                  ),
                  // 활성 상태 배지
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.spaceS,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: permission.isActive
                          ? Colors.green[50]
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                    ),
                    child: Text(
                      permission.isActive ? activeText : inactiveText,
                      style: TextStyle(
                        fontSize: 12,
                        color: permission.isActive
                            ? Colors.green[700]
                            : Colors.grey[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              if (permission.description != null &&
                  permission.description!.isNotEmpty) ...[
                const SizedBox(height: AppSizes.spaceM),
                Text(
                  permission.description!,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.grey[700]),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
