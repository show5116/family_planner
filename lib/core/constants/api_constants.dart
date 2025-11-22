/// API 엔드포인트 상수
class ApiConstants {
  ApiConstants._(); // Private constructor

  // API 버전
  static const String apiVersion = '/api/v1';

  // Auth Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/signup';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String verifyToken = '/auth/me';
  static const String verifyEmail = '/auth/verify-email';
  static const String resendVerification = '/auth/resend-verification';
  static const String requestPasswordReset = '/auth/request-password-reset';
  static const String resetPassword = '/auth/reset-password';

  // Social Login Endpoints
  static const String googleLogin = '/auth/google';
  static const String googleCallback = '/auth/google/callback';
  static const String kakaoLogin = '/auth/kakao';
  static const String kakaoCallback = '/auth/kakao/callback';

  // User Endpoints
  static const String userProfile = '$apiVersion/users/profile';
  static const String updateProfile = '$apiVersion/users/profile';
  static const String changePassword = '$apiVersion/users/password';

  // Family Endpoints
  static const String families = '$apiVersion/families';
  static const String familyMembers = '$apiVersion/families/members';
  static const String inviteFamily = '$apiVersion/families/invite';

  // Asset Endpoints
  static const String assets = '$apiVersion/assets';
  static const String assetAccounts = '$apiVersion/assets/accounts';
  static const String assetTransactions = '$apiVersion/assets/transactions';

  // Investment Endpoints
  static const String investmentIndicators = '$apiVersion/investments/indicators';
  static const String marketData = '$apiVersion/investments/market-data';

  // Household Endpoints
  static const String household = '$apiVersion/household';
  static const String householdExpenses = '$apiVersion/household/expenses';
  static const String householdFixed = '$apiVersion/household/fixed';

  // Calendar Endpoints
  static const String calendar = '$apiVersion/calendar';
  static const String calendarEvents = '$apiVersion/calendar/events';

  // Todo Endpoints
  static const String todos = '$apiVersion/todos';
  static const String todoBoards = '$apiVersion/todos/boards';

  // Child Points Endpoints
  static const String childPoints = '$apiVersion/child-points';
  static const String pointsHistory = '$apiVersion/child-points/history';
  static const String pointsRules = '$apiVersion/child-points/rules';

  // Memo Endpoints
  static const String memos = '$apiVersion/memos';

  // Mini Games Endpoints
  static const String miniGames = '$apiVersion/mini-games';
  static const String ladderGame = '$apiVersion/mini-games/ladder';
  static const String rouletteGame = '$apiVersion/mini-games/roulette';

  // Notification Endpoints
  static const String notifications = '$apiVersion/notifications';
  static const String notificationSettings = '$apiVersion/notifications/settings';
}
