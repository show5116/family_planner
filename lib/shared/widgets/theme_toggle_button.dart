import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/theme/theme_provider.dart';

/// 다크모드 토글 버튼 위젯
///
/// 현재 테마 모드를 표시하고, 탭하면 라이트/다크 모드를 전환합니다.
class ThemeToggleButton extends ConsumerWidget {
  const ThemeToggleButton({
    super.key,
    this.isOnPrimaryColor = false,
  });

  /// Primary 색상 배경 위에 있는지 여부 (true일 경우 흰색 스타일 사용)
  final bool isOnPrimaryColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    // 현재 실제 밝기 (system 모드 고려)
    final isDark = themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system && brightness == Brightness.dark);

    // Primary 배경 위에서는 흰색 스타일, 일반 배경에서는 Primary 색상 스타일
    final iconColor =
        isOnPrimaryColor ? Colors.white : theme.colorScheme.primary;
    final borderColor = isOnPrimaryColor
        ? Colors.white.withValues(alpha: 0.7)
        : theme.colorScheme.outline.withValues(alpha: 0.5);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _toggleTheme(ref, isDark),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(
              color: borderColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            isDark ? Icons.dark_mode : Icons.light_mode,
            size: 20,
            color: iconColor,
          ),
        ),
      ),
    );
  }

  /// 테마 전환
  void _toggleTheme(WidgetRef ref, bool isDark) {
    if (isDark) {
      ref.read(themeModeProvider.notifier).setLightMode();
    } else {
      ref.read(themeModeProvider.notifier).setDarkMode();
    }
  }
}
