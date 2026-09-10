import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/models/subscription_platform.dart';
import 'package:family_planner/core/services/api_client.dart';
import 'package:family_planner/features/subscription/data/models/media_quota_plan.dart';
import 'package:family_planner/features/subscription/data/models/subscription_model.dart';

class SubscriptionRepository {
  Future<SubscriptionModel> getStatus() async {
    final response = await ApiClient.instance.dio.get('/subscription');
    return SubscriptionModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// 등급별 미디어 용량 한도표 (플랜 비교 카드용)
  ///
  /// 다이어리 첨부 한도는 등급마다 다르고 출시 후에도 조정될 수 있어,
  /// 앱이 값을 들고 있지 않고 매번 서버에서 받아 그린다.
  Future<List<MediaQuotaPlan>> getQuotaPlans() async {
    final response =
        await ApiClient.instance.dio.get('/subscription/quota-plans');
    final plans = (response.data as Map<String, dynamic>)['plans'] as List?;
    return (plans ?? [])
        .map((e) => MediaQuotaPlan.fromJson(e as Map<String, dynamic>))
        .toList();
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
