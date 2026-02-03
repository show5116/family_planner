import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';

/// 설정 화면 섹션 헤더 위젯
class SettingsSectionHeader extends StatelessWidget {
  final String title;

  const SettingsSectionHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.spaceM,
        AppSizes.spaceL,
        AppSizes.spaceM,
        AppSizes.spaceS,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
