import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/models/subscription_platform.dart';
import 'package:family_planner/core/services/ad_service.dart';
import 'package:family_planner/core/services/analytics_service.dart';
import 'package:family_planner/core/services/subscription_cache_service.dart';
import 'package:family_planner/core/utils/user_utils.dart';
import 'package:family_planner/features/auth/providers/auth_provider.dart';
import 'package:family_planner/features/subscription/data/models/subscription_model.dart';
import 'package:family_planner/features/subscription/data/repositories/subscription_repository.dart';

class SubscriptionNotifier extends AsyncNotifier<SubscriptionModel> {
  @override
  Future<SubscriptionModel> build() async {
    // isAuthenticated만 select해서 user 객체 변경에 의한 불필요한 재빌드 방지
    final isAuthenticated = ref.watch(authProvider.select((s) => s.isAuthenticated));
    if (isAuthenticated != true) return SubscriptionModel.defaultFree();
    return _fetchFromServer();
  }

  Future<SubscriptionModel> _fetchFromServer() async {
    try {
      final repo = ref.read(subscriptionRepositoryProvider);
      final result = await repo.getStatus();
      // 서버 응답이 항상 기준이다. 캐시는 여기서만 갱신한다.
      await SubscriptionCacheService.save(result);
      return result;
    } catch (_) {
      // 서버에 닿지 못했을 뿐 구독이 사라진 건 아니다. 만료 전 캐시가
      // 있으면 그걸 쓴다 — 없으면 종전대로 free.
      final cached = await SubscriptionCacheService.read();
      return cached ?? SubscriptionModel.defaultFree();
    }
  }

  // ── 액션 ────────────────────────────────────────────────────
  //
  // verify/restore는 "구독 상태"가 아니라 "일회성 요청"이다. 실패했다고 해서
  // 사용자의 구독이 사라진 건 아니므로, state를 [AsyncLoading]/[AsyncError]로
  // 덮지 않는다. 덮으면 요청 실패가 "구독 상태를 알 수 없음"으로 번역돼
  // 구독 화면의 현재 플랜 카드가 통째로 사라진다.
  //
  // 성공했을 때만 state를 교체하고, 실패는 예외로 호출부에 넘긴다.
  // 진행 표시(버튼 비활성화)와 실패 안내(스낵바·다이얼로그)는 화면이 맡는다.

  /// 인앱결제 완료 후 서버 검증 및 상태 업데이트
  ///
  /// 실패 시 state는 그대로 두고 예외를 그대로 던진다. 호출부에서
  /// [DioException.response]의 statusCode(예: 422)로 세부 에러 UI를
  /// 분기할 수 있도록 하기 위함.
  Future<void> verify({
    required SubscriptionPlatform platform,
    String? purchaseToken,
    String? signedTransaction,
  }) async {
    final repo = ref.read(subscriptionRepositoryProvider);
    final result = await repo.verify(
      platform: platform,
      purchaseToken: purchaseToken,
      signedTransaction: signedTransaction,
    );
    await SubscriptionCacheService.save(result);
    await AnalyticsService.instance.logSubscriptionPurchase(result.tier.name);
    await AnalyticsService.instance.setSubscriptionTier(result.tier.name);
    state = AsyncData(result);
  }

  /// 구독 복원 (앱 재설치, 기기 변경 등)
  ///
  /// 실패 시 예외를 던진다. [AsyncValue.guard]로 감싸면 예외가 state로
  /// 흡수돼 호출부의 catch가 실행되지 않고, 복원에 실패해도 성공 스낵바가
  /// 뜬다.
  Future<void> restore() async {
    final repo = ref.read(subscriptionRepositoryProvider);
    final result = await repo.restore();
    await SubscriptionCacheService.save(result);
    await AnalyticsService.instance.logSubscriptionRestore(result.tier.name);
    await AnalyticsService.instance.setSubscriptionTier(result.tier.name);
    state = AsyncData(result);
  }

  /// 서버에서 최신 상태 재조회
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchFromServer);
  }
}

final subscriptionProvider =
    AsyncNotifierProvider<SubscriptionNotifier, SubscriptionModel>(
  SubscriptionNotifier.new,
);

/// 광고 표시 여부만 빠르게 읽는 편의 provider
/// admin/테스트 계정은 구독 tier 무관하게 항상 광고 표시 (테스트 광고 확인용)
final showAdsProvider = Provider<bool>((ref) {
  if (ref.watch(useTestAdsProvider)) return true;
  return ref.watch(subscriptionProvider).valueOrNull?.tier.showAds ?? true;
});

/// 테스트 광고 Unit ID 사용 여부
///
/// 다음 중 하나라도 해당하면 테스트 광고를 사용합니다:
/// - 개발(디버그) 빌드
/// - 운영자 계정 (isAdmin == true)
/// - 테스트 계정 이메일 (testAdAccountEmails)
final useTestAdsProvider = Provider<bool>((ref) {
  if (kDebugMode) return true;

  final user = ref.watch(authProvider).user;
  if (user == null) return false;

  if (isUserAdmin(user)) return true;

  final email = (user['user'] as Map<String, dynamic>?)?['email']?.toString() ??
      user['email']?.toString() ??
      '';
  return testAdAccountEmails.contains(email);
});
