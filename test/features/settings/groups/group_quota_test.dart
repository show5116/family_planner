import 'package:flutter_test/flutter_test.dart';

import 'package:family_planner/core/models/subscription_tier.dart';
import 'package:family_planner/features/settings/groups/models/group_quota.dart';

void main() {
  group('GroupQuota.fromJson', () {
    test('서버가 준 한도를 그대로 읽는다', () {
      final quota = GroupQuota.fromJson({
        'tier': 'premium',
        'used': 5,
        'limit': 5,
        'remaining': 0,
      });

      expect(quota.tier, SubscriptionTier.premium);
      expect(quota.used, 5);
      expect(quota.limit, 5);
      expect(quota.remaining, 0);
    });

    test('대문자·언더스코어 등급명도 읽는다', () {
      final quota = GroupQuota.fromJson({
        'tier': 'AD_FREE',
        'used': 1,
        'limit': 1,
        'remaining': 0,
      });

      expect(quota.tier, SubscriptionTier.adFree);
    });

    test('remaining이 빠져 오면 한도에서 계산한다', () {
      final quota = GroupQuota.fromJson({
        'tier': 'free',
        'used': 1,
        'limit': 1,
      });

      expect(quota.remaining, 0);
    });

    test('모르는 등급명은 free로 떨어뜨려 화면이 죽지 않게 한다', () {
      final quota = GroupQuota.fromJson({'tier': 'gold', 'used': 0, 'limit': 0});

      expect(quota.tier, SubscriptionTier.free);
    });
  });

  group('GroupQuotaExceededException', () {
    test('한도를 못 받아도 402라는 사실은 남는다', () {
      const error = GroupQuotaExceededException(message: '한도 초과');

      expect(error.quota, isNull);
      expect(error.isApplicant, isFalse);
      expect(error.toString(), '한도 초과');
    });

    test('승인 흐름은 신청자의 한도 초과로 표시된다', () {
      const error = GroupQuotaExceededException(isApplicant: true);

      expect(error.isApplicant, isTrue);
    });
  });
}
