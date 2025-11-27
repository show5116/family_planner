/// Family Planner 앱의 라우트 경로 상수
class AppRoutes {
  AppRoutes._(); // Private constructor

  // Auth Routes
  static const String splash = '/splash';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String emailVerification = '/email-verification';
  static const String forgotPassword = '/forgot-password';
  static const String oauthCallback = '/auth/callback';

  // Main Routes
  static const String home = '/';
  static const String assets = '/assets';
  static const String calendar = '/calendar';
  static const String todo = '/todo';
  static const String more = '/more';

  // Feature Routes
  static const String assetDetail = '/assets/detail';
  static const String investmentIndicators = '/investment-indicators';
  static const String household = '/household';
  static const String householdDetail = '/household/detail';
  static const String calendarDetail = '/calendar/detail';
  static const String calendarAdd = '/calendar/add';
  static const String todoDetail = '/todo/detail';
  static const String todoAdd = '/todo/add';
  static const String childPoints = '/child-points';
  static const String childPointsDetail = '/child-points/detail';
  static const String memo = '/memo';
  static const String memoDetail = '/memo/detail';
  static const String memoAdd = '/memo/add';
  static const String miniGames = '/mini-games';
  static const String ladderGame = '/mini-games/ladder';
  static const String rouletteGame = '/mini-games/roulette';

  // Settings Routes
  static const String settings = '/settings';
  static const String bottomNavigationSettings = '/settings/bottom-navigation';
  static const String homeWidgetSettings = '/settings/home-widgets';
  static const String profile = '/settings/profile';
  static const String familyManagement = '/settings/family';
  static const String notifications = '/settings/notifications';
  static const String theme = '/settings/theme';
  static const String language = '/settings/language';
}
