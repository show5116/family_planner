import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';

/// 폼 섹션 헤더 위젯
///
/// 폼의 각 섹션에서 제목과 선택적 액션 버튼을 표시합니다.
///
/// ```dart
/// FormSectionHeader(
///   title: '카테고리',
///   action: TextButton.icon(
///     onPressed: () => ...,
///     icon: Icon(Icons.settings),
///     label: Text('관리'),
///   ),
/// )
/// ```
class FormSectionHeader extends StatelessWidget {
  /// 섹션 제목
  final String title;

  /// 우측 액션 위젯 (선택)
  final Widget? action;

  /// 제목 아래 부제목 (선택)
  final String? subtitle;

  /// 제목 좌측 아이콘 (선택)
  final IconData? icon;

  /// 하단 여백 (기본: AppSizes.spaceM)
  final double bottomSpacing;

  const FormSectionHeader({
    super.key,
    required this.title,
    this.action,
    this.subtitle,
    this.icon,
    this.bottomSpacing = AppSizes.spaceM,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: bottomSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    if (icon != null) ...[
                      Icon(
                        icon,
                        size: 20,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: AppSizes.spaceS),
                    ],
                    Flexible(
                      child: Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              if (action != null) action!,
            ],
          ),
          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSizes.spaceXS),
              child: Text(
                subtitle!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// 폼 섹션 헤더의 액션 버튼 스타일 헬퍼
///
/// 일관된 스타일의 액션 버튼을 쉽게 생성할 수 있습니다.
///
/// ```dart
/// FormSectionHeader(
///   title: '카테고리',
///   action: FormSectionAction(
///     icon: Icons.settings,
///     label: '관리',
///     onPressed: () => ...,
///   ),
/// )
/// ```
class FormSectionAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const FormSectionAction({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceS),
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
