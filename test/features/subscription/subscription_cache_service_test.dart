import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:family_planner/core/models/subscription_tier.dart';
import 'package:family_planner/core/services/subscription_cache_service.dart';
import 'package:family_planner/features/subscription/data/models/subscription_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  SubscriptionModel adFree(DateTime expiresAt, {bool isTrial = false}) =>
      SubscriptionModel(
        tier: SubscriptionTier.adFree,
        expiresAt: expiresAt,
        isActive: true,
        isTrial: isTrial,
        daysLeft: expiresAt.difference(DateTime.now()).inDays,
      );

  group('SubscriptionCacheService', () {
    test('만료 전 구독은 저장 후 그대로 읽힌다', () async {
      final expiresAt = DateTime.now().add(const Duration(days: 30));
      await SubscriptionCacheService.save(adFree(expiresAt));

      final cached = await SubscriptionCacheService.read();

      expect(cached, isNotNull);
      expect(cached!.tier, SubscriptionTier.adFree);
      expect(cached.isActive, isTrue);
    });

    test('만료된 구독은 읽히지 않고 캐시도 지워진다', () async {
      await SubscriptionCacheService.save(
        adFree(DateTime.now().subtract(const Duration(days: 1))),
      );

      expect(await SubscriptionCacheService.read(), isNull);

      // 만료 캐시는 읽는 시점에 정리되어야 한다
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('subscription_cache'), isNull);
    });

    test('free 등급은 캐시하지 않는다 (폴백 기본값과 동일)', () async {
      await SubscriptionCacheService.save(SubscriptionModel.defaultFree());

      expect(await SubscriptionCacheService.read(), isNull);
    });

    test('만료일 없는 유료 등급은 신뢰하지 않는다', () async {
      // 만료일이 없으면 무기한 유효해져 버리므로 거부해야 한다
      SharedPreferences.setMockInitialValues({
        'subscription_cache': jsonEncode({
          'tier': 'adFree',
          'expiresAt': null,
          'isTrial': false,
        }),
      });

      expect(await SubscriptionCacheService.read(), isNull);
    });

    test('clear()는 캐시를 제거한다 (계정 전환 시 사용)', () async {
      await SubscriptionCacheService.save(
        adFree(DateTime.now().add(const Duration(days: 30))),
      );

      await SubscriptionCacheService.clear();

      expect(await SubscriptionCacheService.read(), isNull);
    });

    test('무료 체험도 만료 전이면 유지된다', () async {
      await SubscriptionCacheService.save(
        adFree(DateTime.now().add(const Duration(days: 7)), isTrial: true),
      );

      final cached = await SubscriptionCacheService.read();

      expect(cached?.isTrial, isTrue);
    });

    test('깨진 캐시 값은 예외 없이 null을 반환한다', () async {
      SharedPreferences.setMockInitialValues({
        'subscription_cache': 'not-a-json',
      });

      expect(await SubscriptionCacheService.read(), isNull);
    });
  });
}
