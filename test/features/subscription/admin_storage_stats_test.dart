import 'package:flutter_test/flutter_test.dart';

import 'package:family_planner/core/models/subscription_tier.dart';
import 'package:family_planner/features/subscription/data/models/admin_storage_stats.dart';
import 'package:family_planner/features/subscription/data/models/admin_user_dto.dart';
import 'package:family_planner/features/subscription/data/models/media_quota_plan.dart';

void main() {
  group('AdminStorageStats.fromJson', () {
    test('등급 요약과 구간 분포를 파싱한다', () {
      final stats = AdminStorageStats.fromJson({
        'totalStoredBytes': 128849018880,
        'usersWithMedia': 412,
        'tiers': [
          {
            'tier': 'premium',
            'userCount': 1200,
            'usersWithMedia': 340,
            'totalBytes': 53687091200,
            'medianBytes': 314572800,
            'maxBytes': 39728447488,
            'limitBytes': 42949672960,
            'nearLimitCount': 12,
            'overLimitCount': 3,
          },
        ],
        'buckets': [
          {'label': '~500MB', 'maxBytes': 524288000, 'userCount': 87},
          {'label': '10GB+', 'maxBytes': null, 'userCount': 4},
        ],
      });

      expect(stats.totalStoredBytes, 128849018880);
      expect(stats.usersWithMedia, 412);

      final tier = stats.tiers.single;
      expect(tier.tier, SubscriptionTier.premium);
      expect(tier.nearLimitCount, 12);
      expect(tier.overLimitCount, 3);
      // 상위 등급 수요 신호 — 80% 이상과 초과를 합쳐서 본다
      expect(tier.pressuredCount, 15);

      expect(stats.buckets.last.maxBytes, isNull);
      expect(stats.buckets.last.userCount, 4);
    });

    test('빈 응답도 화면이 죽지 않게 0/빈 목록으로 읽는다', () {
      final stats = AdminStorageStats.fromJson({});

      expect(stats.totalStoredBytes, 0);
      expect(stats.tiers, isEmpty);
      expect(stats.buckets, isEmpty);
    });
  });

  group('신규 필드 하위호환', () {
    test('storageUsedBytes가 없는 사용자 응답도 파싱된다', () {
      final user = AdminUserDto.fromJson({
        'id': 'u1',
        'name': '홍길동',
        'subscriptionTier': 'free',
        'isSubscriptionActive': false,
        'createdAt': '2025-01-01T00:00:00Z',
      });

      expect(user.storageUsedBytes, 0);
    });

    test('storageUsedBytes는 copyWith에서 유지된다', () {
      final user = AdminUserDto.fromJson({
        'id': 'u1',
        'name': '홍길동',
        'subscriptionTier': 'free',
        'isSubscriptionActive': false,
        'createdAt': '2025-01-01T00:00:00Z',
        'storageUsedBytes': 1073741824,
      });

      expect(user.copyWith(isAdmin: true).storageUsedBytes, 1073741824);
    });

    test('maxGroups가 없는 한도표는 1개로 읽는다', () {
      final plan = MediaQuotaPlan.fromJson({
        'tier': 'free',
        'monthlyBytes': 0,
        'totalBytes': 0,
        'perFileBytes': 0,
      });

      expect(plan.maxGroups, 1);
    });

    test('maxGroups를 내려주면 그 값을 쓴다', () {
      final plan = MediaQuotaPlan.fromJson({
        'tier': 'premium',
        'monthlyBytes': 0,
        'totalBytes': 0,
        'perFileBytes': 0,
        'maxGroups': 5,
      });

      expect(plan.maxGroups, 5);
    });
  });
}
