import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/models/subscription_tier.dart';
import 'package:family_planner/core/services/api_client.dart';
import 'package:family_planner/features/subscription/data/models/subscription_model.dart';

class SubscriptionRepository {
  Future<SubscriptionModel> getStatus() async {
    final response = await ApiClient.instance.dio.get('/subscription');
    return SubscriptionModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// 인앱결제 완료 후 서버에 tier/토큰 전달
  Future<SubscriptionModel> verify({
    required SubscriptionTier tier,
    String? expiresAt,
    String? purchaseToken,
  }) async {
    final response = await ApiClient.instance.dio.post(
      '/subscription/verify',
      data: {
        'tier': tier.name,
        if (expiresAt != null) 'expiresAt': expiresAt,
        if (purchaseToken != null) 'purchaseToken': purchaseToken,
      },
    );
    return SubscriptionModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// 구독 복원 (만료 확인 → free 다운그레이드)
  Future<SubscriptionModel> restore() async {
    final response = await ApiClient.instance.dio.post('/subscription/restore');
    return SubscriptionModel.fromJson(response.data as Map<String, dynamic>);
  }
}

final subscriptionRepositoryProvider = Provider<SubscriptionRepository>(
  (_) => SubscriptionRepository(),
);
