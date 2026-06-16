import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  AnalyticsService._();

  static final AnalyticsService instance = AnalyticsService._();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  FirebaseAnalytics get analytics => _analytics;

  FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  // ── 사용자 ──────────────────────────────────────────────

  Future<void> setUserId(String userId) =>
      _analytics.setUserId(id: userId);

  Future<void> clearUserId() =>
      _analytics.setUserId(id: null);

  Future<void> setUserGroup(String groupId) =>
      _analytics.setUserProperty(name: 'group_id', value: groupId);

  Future<void> setSubscriptionTier(String tier) =>
      _analytics.setUserProperty(name: 'subscription_tier', value: tier);

  // ── 인증 ────────────────────────────────────────────────

  Future<void> logLogin(String method) =>
      _analytics.logLogin(loginMethod: method);

  Future<void> logSignUp(String method) =>
      _analytics.logSignUp(signUpMethod: method);

  Future<void> logOnboardingComplete() =>
      _analytics.logEvent(name: 'onboarding_complete');

  Future<void> logLogout() =>
      _analytics.logEvent(name: 'logout');

  // ── 화면 ────────────────────────────────────────────────

  Future<void> logScreenView(String screenName) =>
      _analytics.logScreenView(screenName: screenName);

  // ── 그룹 ────────────────────────────────────────────────

  Future<void> logGroupCreate() =>
      _analytics.logEvent(name: 'group_create');

  Future<void> logGroupJoinRequest() =>
      _analytics.logEvent(name: 'group_join_request');

  Future<void> logGroupJoinApproved() =>
      _analytics.logEvent(name: 'group_join_approved');

  // ── 일정 ────────────────────────────────────────────────

  Future<void> logCalendarEventCreate() =>
      _analytics.logEvent(name: 'calendar_event_create');

  // ── 가계부 ──────────────────────────────────────────────

  Future<void> logHouseholdEntryCreate(String type) =>
      _analytics.logEvent(
        name: 'household_entry_create',
        parameters: {'type': type},
      );

  // ── 육아포인트 ──────────────────────────────────────────

  Future<void> logChildPointTransaction(String transactionType) =>
      _analytics.logEvent(
        name: 'child_point_transaction',
        parameters: {'transaction_type': transactionType},
      );

  // ── 메모 ────────────────────────────────────────────────

  Future<void> logMemoCreate() =>
      _analytics.logEvent(name: 'memo_create');

  // ── 투표 ────────────────────────────────────────────────

  Future<void> logVoteCreate() =>
      _analytics.logEvent(name: 'vote_create');

  Future<void> logVoteParticipate() =>
      _analytics.logEvent(name: 'vote_participate');

  // ── 미니게임 ────────────────────────────────────────────

  Future<void> logMiniGamePlay(String gameName) =>
      _analytics.logEvent(
        name: 'mini_game_play',
        parameters: {'game_name': gameName},
      );

  // ── 저축 ────────────────────────────────────────────────

  Future<void> logSavingsCreate() =>
      _analytics.logEvent(name: 'savings_create');

  // ── 자산 ────────────────────────────────────────────────

  Future<void> logAssetRecordCreate() =>
      _analytics.logEvent(name: 'asset_record_create');

  // ── 구독/결제 ────────────────────────────────────────────

  /// tier: 'premium' 등
  Future<void> logSubscriptionPurchase(String tier) =>
      _analytics.logEvent(
        name: 'subscription_purchase',
        parameters: {'tier': tier},
      );

  Future<void> logSubscriptionRestore(String tier) =>
      _analytics.logEvent(
        name: 'subscription_restore',
        parameters: {'tier': tier},
      );

  // ── 푸시 알림 ────────────────────────────────────────────

  /// category: 알림 카테고리 (calendar, household 등)
  Future<void> logNotificationOpen(String category) =>
      _analytics.logEvent(
        name: 'notification_open',
        parameters: {'category': category},
      );

  // ── 범용 ────────────────────────────────────────────────

  Future<void> logEvent(
    String name, {
    Map<String, Object>? parameters,
  }) =>
      _analytics.logEvent(name: name, parameters: parameters);
}
