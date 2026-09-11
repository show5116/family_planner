import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:family_planner/l10n/app_localizations.dart';

/// 다국어 리소스가 4개 언어 모두에서 실제로 로드되는지 확인한다.
///
/// ARB에 키를 한 언어에만 추가하면 다른 언어에서 조용히 한국어가 노출되는데,
/// `flutter analyze`로는 잡히지 않아서 테스트로 막는다.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<AppLocalizations> load(Locale locale) =>
      AppLocalizations.delegate.load(locale);

  test('지원 언어 4종(ko/en/ja/zh)이 모두 로드된다', () async {
    expect(
      AppLocalizations.supportedLocales.map((l) => l.languageCode).toSet(),
      {'ko', 'en', 'ja', 'zh'},
    );

    for (final locale in AppLocalizations.supportedLocales) {
      final l10n = await load(locale);
      expect(l10n.appTitle, isNotEmpty, reason: locale.toString());
      expect(l10n.common_save, isNotEmpty, reason: locale.toString());
    }
  });

  test('대시보드 인사말 문자열이 언어마다 비어 있지 않다', () async {
    for (final locale in AppLocalizations.supportedLocales) {
      final l10n = await load(locale);
      final reason = locale.toString();

      expect(l10n.greeting_settingsTitle, isNotEmpty, reason: reason);
      expect(l10n.greeting_todayLabel, isNotEmpty, reason: reason);
      expect(l10n.greeting_presetSourceNote, isNotEmpty, reason: reason);
      for (final label in [
        l10n.greeting_packInfant,
        l10n.greeting_packToddler,
        l10n.greeting_packPreschool,
        l10n.greeting_packSchool,
        l10n.greeting_packTeen,
        l10n.greeting_packParenting,
        l10n.greeting_packQuote,
        l10n.greeting_packCheer,
        l10n.greeting_packChoreKitchen,
        l10n.greeting_packChoreLaundry,
        l10n.greeting_packChoreCleaning,
        l10n.greeting_packEnglishDaily,
        l10n.greeting_packEnglishTravel,
        l10n.greeting_packEnglishWork,
        l10n.greeting_groupChild,
        l10n.greeting_groupMind,
        l10n.greeting_groupChore,
        l10n.greeting_groupEnglish,
      ]) {
        expect(label, isNotEmpty, reason: reason);
      }
    }
  });

  test('한국어 외 언어에서 인사말 라벨이 한국어로 남아 있지 않다', () async {
    final ko = await load(const Locale('ko'));
    for (final locale in AppLocalizations.supportedLocales) {
      if (locale.languageCode == 'ko') continue;
      final l10n = await load(locale);
      expect(
        l10n.greeting_settingsTitle,
        isNot(ko.greeting_settingsTitle),
        reason: locale.toString(),
      );
    }
  });
}
