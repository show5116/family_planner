import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/models/subscription_tier.dart';
import 'package:family_planner/core/services/ad_service.dart';
import 'package:family_planner/core/utils/user_utils.dart';
import 'package:family_planner/features/auth/providers/auth_provider.dart';
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
