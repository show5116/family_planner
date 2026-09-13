import 'package:family_planner/core/models/subscription_tier.dart';

/// 저장 사용량 분포 (ADMIN 전용)
///
/// 상위 등급을 새로 낼지 판단하려면 "한도에 몰린 사람이 몇 명인지"가 필요하다.
/// 합계만으로는 안 보이므로 등급별 요약과 구간별 인원을 함께 받는다.
class AdminStorageStats {
  /// 전체 저장량 합 (bytes)
  final int totalStoredBytes;

  /// 미디어를 1건이라도 올린 전체 사용자 수
  final int usersWithMedia;

  final List<AdminTierStorage> tiers;

  /// 저장량 구간별 사용자 분포 (미디어가 있는 사용자만)
  final List<AdminStorageBucket> buckets;

  const AdminStorageStats({
    required this.totalStoredBytes,
    required this.usersWithMedia,
    required this.tiers,
    required this.buckets,
  });

  factory AdminStorageStats.fromJson(Map<String, dynamic> json) {
    return AdminStorageStats(
      totalStoredBytes: json['totalStoredBytes'] as int? ?? 0,
      usersWithMedia: json['usersWithMedia'] as int? ?? 0,
      tiers: (json['tiers'] as List? ?? [])
          .map((e) => AdminTierStorage.fromJson(e as Map<String, dynamic>))
          .toList(),
      buckets: (json['buckets'] as List? ?? [])
          .map((e) => AdminStorageBucket.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// 등급별 저장량 요약
class AdminTierStorage {
  final SubscriptionTier tier;

  /// 해당 등급 전체 사용자 수
  final int userCount;

  /// 미디어를 1건이라도 올린 사용자 수
  final int usersWithMedia;

  final int totalBytes;

  /// 미디어가 있는 사용자 기준 중앙값 (bytes)
  final int medianBytes;

  final int maxBytes;

  /// 등급 누적 한도 (bytes)
  final int limitBytes;

  /// 한도의 80% 이상 100% 미만 — 상위 등급 수요 신호
  final int nearLimitCount;

  /// 한도를 이미 넘긴 사용자 수
  final int overLimitCount;

  const AdminTierStorage({
    required this.tier,
    required this.userCount,
    required this.usersWithMedia,
    required this.totalBytes,
    required this.medianBytes,
    required this.maxBytes,
    required this.limitBytes,
    required this.nearLimitCount,
    required this.overLimitCount,
  });

  /// 한도가 빠듯한 사용자 수 (80% 이상 + 초과)
  int get pressuredCount => nearLimitCount + overLimitCount;

  factory AdminTierStorage.fromJson(Map<String, dynamic> json) {
    return AdminTierStorage(
      tier: _tierFromJson(json['tier'] as String?),
      userCount: json['userCount'] as int? ?? 0,
      usersWithMedia: json['usersWithMedia'] as int? ?? 0,
      totalBytes: json['totalBytes'] as int? ?? 0,
      medianBytes: json['medianBytes'] as int? ?? 0,
      maxBytes: json['maxBytes'] as int? ?? 0,
      limitBytes: json['limitBytes'] as int? ?? 0,
      nearLimitCount: json['nearLimitCount'] as int? ?? 0,
      overLimitCount: json['overLimitCount'] as int? ?? 0,
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

/// 저장량 구간별 사용자 수
class AdminStorageBucket {
  final String label;

  /// 구간 상한 (bytes) — null이면 상한 없음
  final int? maxBytes;

  final int userCount;

  const AdminStorageBucket({
    required this.label,
    this.maxBytes,
    required this.userCount,
  });

  factory AdminStorageBucket.fromJson(Map<String, dynamic> json) {
    return AdminStorageBucket(
      label: json['label'] as String? ?? '',
      maxBytes: json['maxBytes'] as int?,
      userCount: json['userCount'] as int? ?? 0,
    );
  }
}
