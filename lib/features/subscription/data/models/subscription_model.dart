import 'package:family_planner/core/models/subscription_tier.dart';

class SubscriptionModel {
  final SubscriptionTier tier;
  final DateTime? expiresAt;
  final bool isActive;
  final bool isTrial;
  final int daysLeft;

  const SubscriptionModel({
    required this.tier,
    required this.expiresAt,
    required this.isActive,
    this.isTrial = false,
    this.daysLeft = 0,
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
    );
  }

  factory SubscriptionModel.defaultFree() => const SubscriptionModel(
        tier: SubscriptionTier.free,
        expiresAt: null,
        isActive: false,
      );
}
