import 'package:flutter/material.dart';

enum SubscriptionTier {
  free,
  adFree,
  premium;

  bool get showAds => this == SubscriptionTier.free;
  bool get isPremium => this == SubscriptionTier.premium;
  bool get hasPremiumAccess => this != SubscriptionTier.free;

  String get displayName => switch (this) {
        SubscriptionTier.free => 'Free',
        SubscriptionTier.adFree => '광고 제거',
        SubscriptionTier.premium => 'Premium',
      };

  Color get color => switch (this) {
        SubscriptionTier.free => Colors.grey,
        SubscriptionTier.adFree => Colors.blue,
        SubscriptionTier.premium => const Color(0xFFFF9800),
      };
}
