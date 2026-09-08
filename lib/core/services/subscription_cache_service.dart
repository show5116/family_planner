import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:family_planner/core/models/subscription_tier.dart';
import 'package:family_planner/features/subscription/data/models/subscription_model.dart';

/// 구독 상태 로컬 캐시
///
/// 서버 조회에 실패하면 무조건 free로 떨어져 오프라인에서는 구독자에게도
/// 광고가 노출됐다. 마지막으로 확인된 구독 상태를 저장해두고, 서버에
/// 닿지 못할 때만 폴백으로 쓴다.
///
/// 조작 위험이 낮은 이유:
/// - 만료일이 지난 캐시는 읽는 즉시 버린다
/// - 서버에 닿는 순간 응답으로 덮어쓴다
/// - 결제 검증 자체는 늘 서버가 하며, 이 캐시는 광고 노출 여부에만 관여한다
class SubscriptionCacheService {
  SubscriptionCacheService._();

  static const String _key = 'subscription_cache';

  /// 서버 응답을 캐시에 저장한다.
  ///
  /// 무료 체험(`isTrial`)도 만료일이 있어 그대로 저장한다.
  static Future<void> save(SubscriptionModel subscription) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _key,
        jsonEncode({
          'tier': subscription.tier.name,
          'expiresAt': subscription.expiresAt?.toIso8601String(),
          'isTrial': subscription.isTrial,
          'autoRenewing': subscription.autoRenewing,
        }),
      );
    } catch (e) {
      // 캐시는 부가 기능이므로 실패해도 앱 동작을 막지 않는다
      debugPrint('🟡 [SubscriptionCache] 저장 실패: $e');
    }
  }

  /// 캐시된 구독 상태를 읽는다.
  ///
  /// 캐시가 없거나, 만료됐거나, 만료일이 없는 유료 등급이면 null을 반환한다.
  /// (만료일 없는 유료 등급은 무기한 유효해져 버리므로 신뢰하지 않는다)
  static Future<SubscriptionModel?> read() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_key);
      if (raw == null) return null;

      final json = jsonDecode(raw) as Map<String, dynamic>;
      final tier = SubscriptionTier.values.firstWhere(
        (e) => e.name == json['tier'],
        orElse: () => SubscriptionTier.free,
      );
      if (tier == SubscriptionTier.free) return null;

      final expiresAtRaw = json['expiresAt'] as String?;
      final expiresAt =
          expiresAtRaw == null ? null : DateTime.tryParse(expiresAtRaw);
      if (expiresAt == null || !expiresAt.isAfter(DateTime.now())) {
        await clear();
        return null;
      }

      return SubscriptionModel(
        tier: tier,
        expiresAt: expiresAt,
        isActive: true,
        isTrial: json['isTrial'] as bool? ?? false,
        daysLeft: expiresAt.difference(DateTime.now()).inDays,
        autoRenewing: json['autoRenewing'] as bool?,
      );
    } catch (e) {
      debugPrint('🟡 [SubscriptionCache] 읽기 실패: $e');
      return null;
    }
  }

  /// 캐시를 지운다. 로그아웃·계정 전환 시 반드시 호출해야 이전 계정의
  /// 구독이 새 계정에 적용되지 않는다.
  static Future<void> clear() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_key);
    } catch (e) {
      debugPrint('🟡 [SubscriptionCache] 삭제 실패: $e');
    }
  }
}
