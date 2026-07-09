import 'package:family_planner/core/models/subscription_tier.dart';

/// 인앱결제 상품 ID
///
/// TODO: 스토어 콘솔(Google Play Console / App Store Connect)에 실제 상품 등록 후
/// 아래 상수 값을 실제 상품 ID로 교체
class IapProductIds {
  IapProductIds._();

  static const String adFreeMonthly = 'family_planner_ad_free_monthly';
  static const String premiumMonthly = 'family_planner_premium_monthly';

  static const Set<String> all = {adFreeMonthly, premiumMonthly};

  /// 상품 ID로 구독 단계를 조회
  static SubscriptionTier tierForProductId(String productId) {
    switch (productId) {
      case adFreeMonthly:
        return SubscriptionTier.adFree;
      case premiumMonthly:
        return SubscriptionTier.premium;
      default:
        return SubscriptionTier.free;
    }
  }
}
