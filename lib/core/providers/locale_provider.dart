import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:family_planner/core/services/api_client.dart';

/// 지원 언어 목록
enum AppLanguage {
  korean('ko', 'KR', '한국어'),
  english('en', 'US', 'English'),
  japanese('ja', 'JP', '日本語'),
  chinese('zh', 'CN', '中文');

  const AppLanguage(this.languageCode, this.countryCode, this.displayName);

  final String languageCode;
  final String countryCode;
  final String displayName;

  Locale get locale => Locale(languageCode, countryCode);

  /// 언어 코드로 AppLanguage 찾기
  static AppLanguage? fromLocale(Locale locale) {
    try {
      return AppLanguage.values.firstWhere(
        (lang) => lang.languageCode == locale.languageCode,
      );
    } catch (e) {
      return null;
    }
  }
}

/// Locale 상태 관리
class LocaleNotifier extends StateNotifier<Locale?> {
  LocaleNotifier() : super(null) {
    _loadLocale();
  }

  static const String _localeKey = 'app_locale';

  /// 저장된 언어 설정 불러오기
  Future<void> _loadLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_localeKey);

      if (languageCode != null) {
        final language = AppLanguage.values.firstWhere(
          (lang) => lang.languageCode == languageCode,
          orElse: () => AppLanguage.korean,
        );
        state = language.locale;
        ApiClient.instance.setLanguageCode(language.languageCode);
      } else {
        state = AppLanguage.korean.locale;
        ApiClient.instance.setLanguageCode(AppLanguage.korean.languageCode);
      }
    } catch (e) {
      state = AppLanguage.korean.locale;
      ApiClient.instance.setLanguageCode(AppLanguage.korean.languageCode);
    }
  }

  /// 언어 변경
  Future<void> setLocale(AppLanguage language) async {
    state = language.locale;
    ApiClient.instance.setLanguageCode(language.languageCode);

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, language.languageCode);
    } catch (e) {
      debugPrint('Failed to save locale: $e');
    }
  }

  /// 시스템 언어로 변경
  Future<void> setSystemLocale() async {
    state = null; // null이면 시스템 언어 사용
    ApiClient.instance.setLanguageCode(AppLanguage.korean.languageCode);

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_localeKey);
    } catch (e) {
      debugPrint('Failed to remove locale: $e');
    }
  }
}

/// Locale Provider
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>((ref) {
  return LocaleNotifier();
});

/// 현재 언어를 AppLanguage enum으로 반환하는 Provider
final currentLanguageProvider = Provider<AppLanguage>((ref) {
  final locale = ref.watch(localeProvider);
  if (locale == null) {
    // 시스템 언어 사용 중
    return AppLanguage.korean; // 기본값
  }

  return AppLanguage.fromLocale(locale) ?? AppLanguage.korean;
});
