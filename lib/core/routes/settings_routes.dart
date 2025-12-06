import 'package:go_router/go_router.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/settings/screens/settings_screen.dart';
import 'package:family_planner/features/settings/screens/bottom_navigation_settings_screen.dart';
import 'package:family_planner/features/settings/screens/home_widget_settings_screen.dart';
import 'package:family_planner/features/settings/screens/theme_settings_screen.dart';
import 'package:family_planner/features/settings/screens/language_settings_screen.dart';
import 'package:family_planner/features/settings/screens/profile_settings_screen.dart';
import 'package:family_planner/features/groups/screens/group_list_screen.dart';

/// 설정 관련 라우트 목록
///
/// 포함되는 화면:
/// - Settings (설정 메인)
/// - Bottom Navigation Settings (하단 네비게이션 설정)
/// - Home Widget Settings (홈 위젯 설정)
/// - Theme Settings (테마 설정)
/// - Language Settings (언어 설정)
/// - Profile Settings (프로필 설정)
/// - Group Management (그룹 관리)
List<RouteBase> getSettingsRoutes() {
  return [
    GoRoute(
      path: AppRoutes.settings,
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: AppRoutes.bottomNavigationSettings,
      name: 'bottomNavigationSettings',
      builder: (context, state) => const BottomNavigationSettingsScreen(),
    ),
    GoRoute(
      path: AppRoutes.homeWidgetSettings,
      name: 'homeWidgetSettings',
      builder: (context, state) => const HomeWidgetSettingsScreen(),
    ),
    GoRoute(
      path: AppRoutes.theme,
      name: 'theme',
      builder: (context, state) => const ThemeSettingsScreen(),
    ),
    GoRoute(
      path: AppRoutes.language,
      name: 'language',
      builder: (context, state) => const LanguageSettingsScreen(),
    ),
    GoRoute(
      path: AppRoutes.profile,
      name: 'profile',
      builder: (context, state) => const ProfileSettingsScreen(),
    ),
    GoRoute(
      path: AppRoutes.groupManagement,
      name: 'groupManagement',
      builder: (context, state) => const GroupListScreen(),
    ),
  ];
}
