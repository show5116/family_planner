import 'package:family_planner/l10n/app_localizations.dart';

/// 네비게이션 아이템 ID에 대한 다국어 라벨을 반환하는 헬퍼 함수
class NavigationLabelHelper {
  /// 네비게이션 아이템 ID를 다국어 라벨로 변환
  static String getLabel(AppLocalizations l10n, String id) {
    switch (id) {
      case 'home':
        return l10n.nav_home;
      case 'assets':
        return l10n.nav_assets;
      case 'calendar':
        return l10n.nav_calendar;
      case 'todo':
        return l10n.nav_todo;
      case 'more':
        return l10n.nav_more;
      case 'household':
        return l10n.nav_household;
      case 'childPoints':
        return l10n.nav_childPoints;
      case 'memo':
        return l10n.nav_memo;
      case 'miniGames':
        return l10n.nav_miniGames;
      default:
        return id; // fallback
    }
  }
}
