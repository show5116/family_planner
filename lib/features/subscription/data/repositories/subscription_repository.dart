import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/models/subscription_platform.dart';
import 'package:family_planner/core/services/api_client.dart';
import 'package:family_planner/features/subscription/data/models/subscription_model.dart';

class SubscriptionRepository {
  Future<SubscriptionModel> getStatus() async {
    final response = await ApiClient.instance.dio.get('/subscription');
    return SubscriptionModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// 인앱결제 완료 후 서버에 스토어 영수증 검증 요청
  ///
  /// [platform]이 android면 [purchaseToken], ios면 [signedTransaction] 필수
  Future<SubscriptionModel> verify({
    required SubscriptionPlatform platform,
    String? purchaseToken,
    String? signedTransaction,
  }) async {
    final response = await ApiClient.instance.dio.post(
      '/subscription/verify',
      data: {
        'platform': platform.value,
        if (purchaseToken != null) 'purchaseToken': purchaseToken,
        if (signedTransaction != null) 'signedTransaction': signedTransaction,
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
