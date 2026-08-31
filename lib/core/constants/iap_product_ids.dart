import 'package:family_planner/core/models/subscription_tier.dart';

/// 인앱결제 상품 ID
///
/// [premiumMonthly]는 상수만 정의해두고 [all]에는 넣지 않는다. 프리미엄 전용
/// 기능(AI 어시스턴트, 다이어리 미디어 첨부)이 아직 없어 스토어 콘솔에 상품을
/// 등록하지 않았고, 구매할 수 없는 상품을 화면에 노출하면 App Store
/// Guideline 2.1(미완성 기능) 위반이 되기 때문이다. 기능이 준비되면 콘솔에
/// 상품을 등록하고 [all]에 추가하기만 하면 된다.
class IapProductIds {
  IapProductIds._();

  static const String adFreeMonthly = 'family_planner_ad_free_monthly';
  static const String premiumMonthly = 'family_planner_premium_monthly';

  /// 스토어에 조회를 요청할 상품 목록 (현재 판매 중인 것만)
  static const Set<String> all = {adFreeMonthly};

  /// 상품 ID로 구독 단계를 조회
  ///
  /// 서버가 premium tier를 내려줄 수 있으므로(수동 부여 등) 판매하지 않는
  /// 상품도 매핑은 유지한다.
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
