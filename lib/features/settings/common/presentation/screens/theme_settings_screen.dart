import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/theme/theme_provider.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 테마 설정 화면
class ThemeSettingsScreen extends ConsumerWidget {
  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeMode = ref.watch(themeModeProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.themeSettings_title),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        children: [
          // 설명
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.spaceM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.palette,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: AppSizes.spaceS),
                      Text(
                        l10n.themeSettings_selectTheme,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.spaceS),
                  Text(
                    l10n.themeSettings_description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSizes.spaceL),

          // 테마 옵션들
          _ThemeOption(
            title: l10n.themeSettings_lightMode,
            subtitle: l10n.themeSettings_lightModeDesc,
            icon: Icons.light_mode,
            themeMode: ThemeMode.light,
            currentThemeMode: currentThemeMode,
            onTap: () {
              ref.read(themeModeProvider.notifier).setLightMode();
            },
          ),
          const SizedBox(height: AppSizes.spaceM),

          _ThemeOption(
            title: l10n.themeSettings_darkMode,
            subtitle: l10n.themeSettings_darkModeDesc,
            icon: Icons.dark_mode,
            themeMode: ThemeMode.dark,
            currentThemeMode: currentThemeMode,
            onTap: () {
              ref.read(themeModeProvider.notifier).setDarkMode();
            },
          ),
          const SizedBox(height: AppSizes.spaceM),

          _ThemeOption(
            title: l10n.themeSettings_systemMode,
            subtitle: l10n.themeSettings_systemModeDesc,
            icon: Icons.settings_suggest,
            themeMode: ThemeMode.system,
            currentThemeMode: currentThemeMode,
            onTap: () {
              ref.read(themeModeProvider.notifier).setSystemMode();
            },
          ),

          const SizedBox(height: AppSizes.spaceXL),

          // 미리보기
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.spaceM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.themeSettings_currentThemePreview,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSizes.spaceM),
                  Container(
                    padding: const EdgeInsets.all(AppSizes.spaceM),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: AppSizes.spaceM),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.themeSettings_currentTheme,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              Text(
                                _getThemeModeText(currentThemeMode, l10n),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getThemeModeText(ThemeMode mode, AppLocalizations l10n) {
    switch (mode) {
      case ThemeMode.light:
        return l10n.themeSettings_lightMode;
      case ThemeMode.dark:
        return l10n.themeSettings_darkMode;
      case ThemeMode.system:
        return l10n.themeSettings_systemMode;
    }
  }
}

/// 테마 옵션 위젯
class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.themeMode,
    required this.currentThemeMode,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final ThemeMode themeMode;
  final ThemeMode currentThemeMode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isSelected = themeMode == currentThemeMode;

    return Card(
      elevation: isSelected ? 4 : 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                ),
                child: Icon(
                  icon,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: AppSizes.spaceM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
