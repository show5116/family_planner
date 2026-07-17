import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 생성/수정 화면 하단에 항상 고정되는 저장 버튼 바.
///
/// `Scaffold(body: Column(children: [Expanded(스크롤 폼), FormBottomBar(...)]))`
/// 형태로 사용한다. 스크롤 여부와 무관하게 화면 하단에 붙어 있어야 하는
/// 생성/수정 화면(다이얼로그 제외)에서 공통으로 재사용한다.
class FormBottomBar extends StatelessWidget {
  const FormBottomBar({
    super.key,
    required this.onPressed,
    this.label,
    this.isLoading = false,
    this.backgroundColor,
    this.foregroundColor,
    this.icon,
  });

  /// 버튼 텍스트. null이면 l10n의 공용 "저장" 문구를 사용한다.
  final String? label;

  final bool isLoading;
  final VoidCallback? onPressed;

  /// 버튼 배경색을 앱 기본 테마와 다르게 지정하고 싶을 때 사용 (예: 도메인별 강조색)
  final Color? backgroundColor;
  final Color? foregroundColor;

  /// 라벨 앞에 표시할 아이콘 (선택)
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSizes.spaceM,
        AppSizes.spaceS,
        AppSizes.spaceM,
        AppSizes.spaceM + MediaQuery.paddingOf(context).bottom,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(color: colorScheme.outlineVariant, width: 0.5),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: _buildButton(context, l10n),
      ),
    );
  }

  Widget _buildButton(BuildContext context, AppLocalizations l10n) {
    final style = (backgroundColor != null || foregroundColor != null)
        ? FilledButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
          )
        : null;
    final labelWidget = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: foregroundColor,
            ),
          )
        : Text(
            label ?? l10n.common_save,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          );

    if (icon == null) {
      return FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: style,
        child: labelWidget,
      );
    }

    return FilledButton.icon(
      onPressed: isLoading ? null : onPressed,
      style: style,
      icon: isLoading
          ? SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: foregroundColor,
              ),
            )
          : Icon(icon),
      label: Text(
        label ?? l10n.common_save,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }
}
