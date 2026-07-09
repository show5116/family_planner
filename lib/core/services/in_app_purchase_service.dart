import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'package:family_planner/core/constants/iap_product_ids.dart';
import 'package:family_planner/core/models/subscription_platform.dart';

/// 인앱결제(구독) 서비스
///
/// Android는 Google Play Billing, iOS는 StoreKit2를 in_app_purchase 패키지가
/// 공통 인터페이스로 감싸서 제공한다.
class InAppPurchaseService {
  InAppPurchaseService._();

  static final InAppPurchaseService instance = InAppPurchaseService._();

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  List<ProductDetails> _products = [];
  bool _initialized = false;

  List<ProductDetails> get products => _products;

  /// 앱 전역에서 1회만 초기화 (구독 관리 화면 재진입 시 중복 초기화 방지)
  Future<void> initialize({
    required void Function(PurchaseDetails purchase) onPurchaseUpdate,
  }) async {
    if (_initialized) return;
    _initialized = true;

    final available = await _iap.isAvailable();
    if (!available) {
      debugPrint('🟡 [IAP] 스토어 사용 불가 (isAvailable == false)');
      return;
    }

    _subscription = _iap.purchaseStream.listen(
      (purchases) {
        for (final purchase in purchases) {
          onPurchaseUpdate(purchase);
        }
      },
      onError: (Object error) {
        debugPrint('❌ [IAP] purchaseStream error: $error');
      },
    );

    final response = await _iap.queryProductDetails(IapProductIds.all);
    if (response.notFoundIDs.isNotEmpty) {
      debugPrint('🟡 [IAP] 콘솔 미등록 상품: ${response.notFoundIDs}');
    }
    _products = response.productDetails;
  }

  /// 구독 상품 구매 시작 (결과는 purchaseStream을 통해 비동기로 전달됨)
  Future<void> purchaseSubscription(String productId) async {
    final product = _products.firstWhere(
      (p) => p.id == productId,
      orElse: () => throw StateError('상품을 찾을 수 없습니다: $productId'),
    );
    final param = PurchaseParam(productDetails: product);
    await _iap.buyNonConsumable(purchaseParam: param);
  }

  /// 구독 복원 (스토어 측 구매 내역 재조회 → purchaseStream으로 결과 전달)
  Future<void> restorePurchases() => _iap.restorePurchases();

  /// 서버 검증까지 끝난 구매를 완료 처리
  ///
  /// 호출하지 않으면 Android는 일정 기간 후 자동 환불되므로 반드시 호출해야 하지만,
  /// 서버 검증 실패(422 등) 시에는 호출하지 않아 재시도 기회를 남겨야 한다.
  Future<void> completePurchase(PurchaseDetails purchase) async {
    if (purchase.pendingCompletePurchase) {
      await _iap.completePurchase(purchase);
    }
  }

  SubscriptionPlatform get currentPlatform =>
      Platform.isIOS ? SubscriptionPlatform.ios : SubscriptionPlatform.android;

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    _initialized = false;
  }
}
