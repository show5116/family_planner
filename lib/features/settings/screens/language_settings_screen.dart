import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/providers/locale_provider.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 언어 설정 화면
class LanguageSettingsScreen extends ConsumerWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLanguage = ref.watch(currentLanguageProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings_language),
      ),
      body: RadioGroup<AppLanguage>(
        groupValue: currentLanguage,
        onChanged: (AppLanguage? value) {
          if (value != null) {
            ref.read(localeProvider.notifier).setLocale(value);
          }
        },
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSizes.spaceM),
              child: Text(
                l10n.language_selectDescription,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
              ),
            ),
            ...AppLanguage.values.map(
              (language) => RadioListTile<AppLanguage>(
                title: Text(_getLanguageDisplayName(l10n, language)),
                subtitle: Text(
                  language.languageCode.toUpperCase(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                value: language,
              ),
            ),
            const Divider(),
            ListTile(
              title: Text(l10n.language_useSystemLanguage),
              subtitle: Text(l10n.language_useSystemLanguageDescription),
              trailing: ref.watch(localeProvider) == null
                  ? const Icon(Icons.check, color: Colors.green)
                  : null,
              onTap: () {
                ref.read(localeProvider.notifier).setSystemLocale();
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 언어별 표시 이름 가져오기
  String _getLanguageDisplayName(AppLocalizations l10n, AppLanguage language) {
    switch (language) {
      case AppLanguage.korean:
        return l10n.language_korean;
      case AppLanguage.english:
        return l10n.language_english;
      case AppLanguage.japanese:
        return l10n.language_japanese;
    }
  }
}
