import 'package:family_planner/core/models/subscription_tier.dart';

/// 요금제별 그룹 개수 한도 (서버 402 응답의 `groupQuota`)
///
/// **앱에 한도를 하드코딩하지 않는다.** 등급별 값은 언제나 서버가 내려주는 것을
/// 쓴다 ([MediaQuotaPlan]과 같은 규칙).
class GroupQuota {
  final SubscriptionTier tier;

  /// 현재 속한 그룹 수
  final int used;

  /// 이 등급에서 속할 수 있는 그룹 수
  final int limit;

  /// 남은 자리 — 서버가 계산해서 내려준다
  final int remaining;

  const GroupQuota({
    required this.tier,
    required this.used,
    required this.limit,
    required this.remaining,
  });

  factory GroupQuota.fromJson(Map<String, dynamic> json) {
    final limit = json['limit'] as int? ?? 0;
    final used = json['used'] as int? ?? 0;
    return GroupQuota(
      tier: _tierFromJson(json['tier'] as String?),
      used: used,
      limit: limit,
      // remaining이 빠져 와도 화면이 빈칸을 보이지 않도록 보정한다
      remaining: json['remaining'] as int? ?? (limit - used).clamp(0, limit),
    );
  }

  /// 서버는 `AD_FREE`처럼 대문자·언더스코어로 내려줄 수 있다
  static SubscriptionTier _tierFromJson(String? raw) {
    final normalized = (raw ?? '').replaceAll('_', '').toLowerCase();
    return SubscriptionTier.values.firstWhere(
      (e) => e.name.toLowerCase() == normalized,
      orElse: () => SubscriptionTier.free,
    );
  }
}

/// 그룹 개수 한도 초과로 거부됨 (서버 402)
///
/// 한도를 함께 담아, 화면이 "무료 요금제는 그룹 1개까지"를 그 자리에서 안내하고
/// 업그레이드로 이어줄 수 있게 한다.
class GroupQuotaExceededException implements Exception {
  final GroupQuota? quota;

  /// 서버가 내려준 메시지 (없으면 화면에서 l10n 문구로 대체한다)
  final String? message;

  /// 승인 흐름에서는 한도를 넘긴 쪽이 승인자가 아니라 **신청자**다
  final bool isApplicant;

  const GroupQuotaExceededException({
    this.quota,
    this.message,
    this.isApplicant = false,
  });

  @override
  String toString() => message ?? 'Group quota exceeded';
}
