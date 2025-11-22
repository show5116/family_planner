import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/providers/locale_provider.dart';
import 'package:family_planner/core/constants/app_sizes.dart';

/// 언어 설정 화면
class LanguageSettingsScreen extends ConsumerWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLanguage = ref.watch(currentLanguageProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('언어 설정'), // TODO: 다국어 적용
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSizes.spaceM),
            child: Text(
              '앱에서 사용할 언어를 선택하세요', // TODO: 다국어 적용
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
            ),
          ),
          ...AppLanguage.values.map(
            (language) => ListTile(
              title: Text(language.displayName),
              subtitle: Text(
                language.languageCode.toUpperCase(),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              leading: Radio<AppLanguage>(
                value: language,
                groupValue: currentLanguage,
                onChanged: (AppLanguage? value) {
                  if (value != null) {
                    ref.read(localeProvider.notifier).setLocale(value);
                  }
                },
              ),
              onTap: () {
                ref.read(localeProvider.notifier).setLocale(language);
              },
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('시스템 언어 사용'), // TODO: 다국어 적용
            subtitle: const Text('기기의 언어 설정을 따릅니다'), // TODO: 다국어 적용
            trailing: ref.watch(localeProvider) == null
                ? const Icon(Icons.check, color: Colors.green)
                : null,
            onTap: () {
              ref.read(localeProvider.notifier).setSystemLocale();
            },
          ),
        ],
      ),
    );
  }
}
