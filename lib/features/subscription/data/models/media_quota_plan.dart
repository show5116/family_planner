import 'package:family_planner/core/models/subscription_tier.dart';

/// 등급별 미디어 용량 한도 (플랜 비교용)
///
/// **앱에 하드코딩하지 않는다.** 한도를 조정할 때 앱 재배포가 필요하면
/// 출시 후 조정이 사실상 불가능해지므로, 값은 언제나 서버가 내려주는 것을 쓴다.
class MediaQuotaPlan {
  final SubscriptionTier tier;

  /// 월간 업로드 한도 (bytes)
  final int monthlyBytes;

  /// 계정 누적 한도 (bytes)
  final int totalBytes;

  /// 파일 1개 최대 크기 (bytes)
  final int perFileBytes;

  final bool videoAllowed;

  /// 영상 최대 길이 (ms) — 영상 불가 등급이면 null
  final int? maxVideoDurationMs;

  const MediaQuotaPlan({
    required this.tier,
    required this.monthlyBytes,
    required this.totalBytes,
    required this.perFileBytes,
    this.videoAllowed = false,
    this.maxVideoDurationMs,
  });

  factory MediaQuotaPlan.fromJson(Map<String, dynamic> json) {
    return MediaQuotaPlan(
      tier: _tierFromJson(json['tier'] as String?),
      monthlyBytes: json['monthlyBytes'] as int? ?? 0,
      totalBytes: json['totalBytes'] as int? ?? 0,
      perFileBytes: json['perFileBytes'] as int? ?? 0,
      videoAllowed: json['videoAllowed'] as bool? ?? false,
      maxVideoDurationMs: json['maxVideoDurationMs'] as int?,
    );
  }

  /// 서버는 `AD_FREE`처럼 대문자·언더스코어로 내려줄 수 있다
  /// ([SubscriptionModel]과 같은 규칙으로 맞춘다).
  static SubscriptionTier _tierFromJson(String? raw) {
    final normalized = (raw ?? '').replaceAll('_', '').toLowerCase();
    return SubscriptionTier.values.firstWhere(
      (e) => e.name.toLowerCase() == normalized,
      orElse: () => SubscriptionTier.free,
    );
  }
}
