import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/shared/widgets/language_selector_button.dart';
import 'package:family_planner/shared/widgets/theme_toggle_button.dart';

/// 인증 화면용 앱바 위젯
class AuthAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBackButton;

  const AuthAppBar({
    super.key,
    this.title,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title != null ? Text(title!) : null,
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: showBackButton,
      actions: [
        ThemeToggleButton(
          key: ValueKey('theme_toggle_$hashCode'),
          isOnPrimaryColor: true,
        ),
        const SizedBox(width: AppSizes.spaceXS),
        Padding(
          padding: const EdgeInsets.only(right: AppSizes.spaceS),
          child: LanguageSelectorButton(
            key: ValueKey('language_selector_$hashCode'),
            isOnPrimaryColor: true,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
