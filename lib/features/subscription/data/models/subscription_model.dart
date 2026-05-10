import 'package:family_planner/core/models/subscription_tier.dart';

class SubscriptionModel {
  final SubscriptionTier tier;
  final DateTime? expiresAt;
  final bool isActive;

  const SubscriptionModel({
    required this.tier,
    required this.expiresAt,
    required this.isActive,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      tier: SubscriptionTier.values.firstWhere(
        (e) => e.name == json['tier'],
        orElse: () => SubscriptionTier.free,
      ),
      expiresAt: json['expiresAt'] != null
          ? DateTime.tryParse(json['expiresAt'] as String)
          : null,
      isActive: json['isActive'] as bool? ?? false,
    );
  }

  factory SubscriptionModel.defaultFree() => const SubscriptionModel(
        tier: SubscriptionTier.free,
        expiresAt: null,
        isActive: false,
      );
}
