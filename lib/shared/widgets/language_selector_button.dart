import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/providers/locale_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 언어 선택 버튼 위젯
///
/// 현재 언어를 표시하고, 탭하면 언어를 순환하며 변경합니다.
/// 로그인 화면 등 인증 화면에서 사용됩니다.
class LanguageSelectorButton extends ConsumerWidget {
  const LanguageSelectorButton({
    super.key,
    this.isOnPrimaryColor = false,
  });

  /// Primary 색상 배경 위에 있는지 여부 (true일 경우 흰색 스타일 사용)
  final bool isOnPrimaryColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLanguage = ref.watch(currentLanguageProvider);
    final theme = Theme.of(context);

    // Primary 배경 위에서는 흰색 스타일, 일반 배경에서는 Primary 색상 스타일
    final iconColor = isOnPrimaryColor ? Colors.white : theme.colorScheme.primary;
    final borderColor = isOnPrimaryColor
        ? Colors.white.withValues(alpha: 0.7)
        : theme.colorScheme.outline.withValues(alpha: 0.5);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _showLanguageDialog(context, ref, currentLanguage),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(
              color: borderColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.language,
                size: 20,
                color: iconColor,
              ),
              const SizedBox(width: 4),
              Text(
                _getLanguageCode(currentLanguage),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: iconColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 언어 코드 가져오기 (대문자)
  String _getLanguageCode(AppLanguage language) {
    switch (language) {
      case AppLanguage.korean:
        return 'KO';
      case AppLanguage.english:
        return 'EN';
      case AppLanguage.japanese:
        return 'JP';
    }
  }

  /// 언어 선택 다이얼로그 표시
  void _showLanguageDialog(
    BuildContext context,
    WidgetRef ref,
    AppLanguage currentLanguage,
  ) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.settings_language),
        content: RadioGroup<AppLanguage>(
          groupValue: currentLanguage,
          onChanged: (value) {
            if (value != null) {
              ref.read(localeProvider.notifier).setLocale(value);
              Navigator.of(context).pop();
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...AppLanguage.values.map(
                (language) => RadioListTile<AppLanguage>(
                  title: Text(_getLanguageDisplayName(context, language)),
                  subtitle: Text(language.languageCode.toUpperCase()),
                  value: language,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.common_close),
          ),
        ],
      ),
    );
  }

  /// 언어별 표시 이름 가져오기
  String _getLanguageDisplayName(BuildContext context, AppLanguage language) {
    final l10n = AppLocalizations.of(context)!;
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
