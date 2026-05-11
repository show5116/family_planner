import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/theme/app_theme.dart';
import 'package:family_planner/core/theme/theme_provider.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';

class ThemeSettingsScreen extends ConsumerWidget {
  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(themeSettingsProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.themeSettings_title),
      ),
      body: ListView(
        padding: EdgeInsets.only(
          left: AppSizes.spaceM,
          right: AppSizes.spaceM,
          top: AppSizes.spaceM,
          bottom: AppSizes.spaceM + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          // 컬러 선택
          _SectionHeader(title: l10n.themeSettings_colorTitle),
          const SizedBox(height: AppSizes.spaceS),
          _ColorPalette(current: settings.variant),
          const SizedBox(height: AppSizes.spaceXL),

          // 밝기 선택
          _SectionHeader(title: l10n.themeSettings_brightnessTitle),
          const SizedBox(height: AppSizes.spaceS),
          _BrightnessOption(
            title: l10n.themeSettings_lightMode,
            subtitle: l10n.themeSettings_lightModeDesc,
            icon: Icons.light_mode,
            mode: ThemeMode.light,
            current: settings.mode,
            onTap: () => ref.read(themeSettingsProvider.notifier).setLightMode(),
          ),
          const SizedBox(height: AppSizes.spaceM),
          _BrightnessOption(
            title: l10n.themeSettings_darkMode,
            subtitle: l10n.themeSettings_darkModeDesc,
            icon: Icons.dark_mode,
            mode: ThemeMode.dark,
            current: settings.mode,
            onTap: () => ref.read(themeSettingsProvider.notifier).setDarkMode(),
          ),
          const SizedBox(height: AppSizes.spaceM),
          _BrightnessOption(
            title: l10n.themeSettings_systemMode,
            subtitle: l10n.themeSettings_systemModeDesc,
            icon: Icons.settings_suggest,
            mode: ThemeMode.system,
            current: settings.mode,
            onTap: () => ref.read(themeSettingsProvider.notifier).setSystemMode(),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }
}

/// 컬러 팔레트 — 원형 스와치 그리드
class _ColorPalette extends ConsumerWidget {
  const _ColorPalette({required this.current});

  final AppThemeVariant current;

  static const _variants = [
    (AppThemeVariant.blue, '파랑', Icons.water_drop),
    (AppThemeVariant.green, '초록', Icons.eco),
    (AppThemeVariant.purple, '보라', Icons.auto_awesome),
    (AppThemeVariant.pink, '분홍', Icons.favorite),
    (AppThemeVariant.teal, '청록', Icons.waves),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: AppSizes.spaceM,
      runSpacing: AppSizes.spaceM,
      children: _variants.map((entry) {
        final (variant, label, icon) = entry;
        final isSelected = variant == current;
        final color = variant.lightPrimary;

        return GestureDetector(
          onTap: () => ref.read(themeSettingsProvider.notifier).setVariant(variant),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(
                          color: Theme.of(context).colorScheme.onSurface,
                          width: 3,
                        )
                      : null,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: color.withValues(alpha: 0.5),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  isSelected ? Icons.check : icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected
                          ? color
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

/// 밝기 선택 옵션 카드
class _BrightnessOption extends StatelessWidget {
  const _BrightnessOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.mode,
    required this.current,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final ThemeMode mode;
  final ThemeMode current;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isSelected = mode == current;

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
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
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
