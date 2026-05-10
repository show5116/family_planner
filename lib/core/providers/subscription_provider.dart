import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/models/subscription_tier.dart';
import 'package:family_planner/features/subscription/data/models/subscription_model.dart';
import 'package:family_planner/features/subscription/data/repositories/subscription_repository.dart';

class SubscriptionNotifier extends AsyncNotifier<SubscriptionModel> {
  @override
  Future<SubscriptionModel> build() async {
    return _fetchFromServer();
  }

  Future<SubscriptionModel> _fetchFromServer() async {
    try {
      final repo = ref.read(subscriptionRepositoryProvider);
      return await repo.getStatus();
    } catch (_) {
      return SubscriptionModel.defaultFree();
    }
  }

  /// 인앱결제 완료 후 서버 검증 및 상태 업데이트
  Future<void> verify({
    required SubscriptionTier tier,
    String? expiresAt,
    String? purchaseToken,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(subscriptionRepositoryProvider);
      return repo.verify(
        tier: tier,
        expiresAt: expiresAt,
        purchaseToken: purchaseToken,
      );
    });
  }

  /// 구독 복원 (앱 재설치, 기기 변경 등)
  Future<void> restore() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(subscriptionRepositoryProvider);
      return repo.restore();
    });
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
final showAdsProvider = Provider<bool>((ref) {
  return ref.watch(subscriptionProvider).valueOrNull?.tier.showAds ?? true;
});
