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
  StreamSubscription<List<PurchaseDetails>>? _backgroundSyncSubscription;
  List<ProductDetails> _products = [];
  bool _initialized = false;

  List<ProductDetails> get products => _products;

  /// 앱 시작 시 1회 호출 (main.dart). 구독 화면을 열지 않아도 서버 검증이
  /// 이루어지도록, 화면과 별개로 purchaseStream을 감시하는 백그라운드
  /// 구독을 하나 더 건다.
  ///
  /// 왜 필요한가: 구매 직후 앱이 죽는 등 구독 화면의 initialize()가 결제
  /// 이벤트를 못 받는 경우, 다음 실행 때 이 리스너가 미완료 거래를 받아
  /// 조용히 검증·완료 처리한다. 화면이 열려 있을 때는 화면 쪽 리스너와
  /// 같은 이벤트를 중복으로 받아 verify를 두 번 부를 수 있지만, 서버가
  /// 멱등하게 처리하므로 안전하다. UI 피드백은 화면 쪽 책임이라 여기서는
  /// 실패해도 조용히 넘어간다 — completePurchase를 안 부르면 다음 실행
  /// 때 다시 전달되어 자연스럽게 재시도된다.
  void startBackgroundSync({
    required Future<void> Function(PurchaseDetails purchase) onVerify,
  }) {
    if (_backgroundSyncSubscription != null) return;

    _backgroundSyncSubscription = _iap.purchaseStream.listen(
      (purchases) async {
        for (final purchase in purchases) {
          if (purchase.status != PurchaseStatus.purchased &&
              purchase.status != PurchaseStatus.restored) {
            continue;
          }
          try {
            await onVerify(purchase);
            await completePurchase(purchase);
          } catch (error) {
            debugPrint('🟡 [IAP] 백그라운드 검증 실패, 다음 실행 때 재시도: $error');
          }
        }
      },
      onError: (Object error) {
        debugPrint('❌ [IAP] 백그라운드 purchaseStream error: $error');
      },
    );
  }

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
    _backgroundSyncSubscription?.cancel();
    _backgroundSyncSubscription = null;
    _initialized = false;
  }
}
