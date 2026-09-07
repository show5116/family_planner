import 'package:shared_preferences/shared_preferences.dart';

import 'package:family_planner/core/providers/locale_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// BuildContext 없이 번역 문구를 얻기 위한 로더.
///
/// 로컬 알림처럼 위젯 트리 밖(서비스·프로바이더·백그라운드 아이솔레이트)에서
/// 문구를 만들어야 할 때 쓴다. 저장된 언어 설정을 읽어 그 언어로 로드하고,
/// 설정이 없거나 읽지 못하면 한국어로 떨어진다.
///
/// 화면 안에서는 이걸 쓰지 말고 `AppLocalizations.of(context)!`를 쓴다.
class LocalizationLoader {
  const LocalizationLoader._();

  /// [LocaleNotifier]가 쓰는 것과 같은 키. 두 곳이 어긋나면 알림만 다른
  /// 언어로 나가므로 값을 바꿀 때 함께 고쳐야 한다.
  static const String _localeKey = 'app_locale';

  /// 저장된 언어로 [AppLocalizations]를 로드한다.
  static Future<AppLocalizations> load() async {
    var language = AppLanguage.korean;
    try {
      final prefs = await SharedPreferences.getInstance();
      final code = prefs.getString(_localeKey);
      if (code != null) {
        language = AppLanguage.values.firstWhere(
          (lang) => lang.languageCode == code,
          orElse: () => AppLanguage.korean,
        );
      }
    } catch (_) {
      // 설정을 못 읽으면 한국어로 둔다
    }
    return AppLocalizations.delegate.load(language.locale);
  }
}
