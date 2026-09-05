import 'package:family_planner/core/models/subscription_tier.dart';

class SubscriptionModel {
  final SubscriptionTier tier;
  final DateTime? expiresAt;
  final bool isActive;
  final bool isTrial;
  final int daysLeft;

  /// 자동 갱신 예약 여부. `false`면 해지된 상태로 [expiresAt]에 혜택이 끝난다.
  ///
  /// 서버가 이 필드를 주지 않는 경우(구버전 서버)를 구분하려고 nullable로 둔다.
  /// null이면 갱신 여부를 단정하지 않고 조건절로 안내한다.
  final bool? autoRenewing;

  const SubscriptionModel({
    required this.tier,
    required this.expiresAt,
    required this.isActive,
    this.isTrial = false,
    this.daysLeft = 0,
    this.autoRenewing,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      tier: SubscriptionTier.values.firstWhere(
        (e) {
          final raw = (json['tier'] as String? ?? '').replaceAll('_', '').toLowerCase();
          return e.name.toLowerCase() == raw;
        },
        orElse: () => SubscriptionTier.free,
      ),
      expiresAt: json['expiresAt'] != null
          ? DateTime.tryParse(json['expiresAt'] as String)
          : null,
      isActive: json['isActive'] as bool? ?? false,
      isTrial: json['isTrial'] as bool? ?? false,
      daysLeft: json['daysLeft'] as int? ?? 0,
      autoRenewing: json['autoRenewing'] as bool?,
    );
  }

  factory SubscriptionModel.defaultFree() => const SubscriptionModel(
        tier: SubscriptionTier.free,
        expiresAt: null,
        isActive: false,
      );
}
