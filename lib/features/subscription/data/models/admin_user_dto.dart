import 'package:family_planner/core/models/subscription_tier.dart';

class AdminUserDto {
  final String id;
  final String name;
  final String? email;
  final SubscriptionTier subscriptionTier;
  final DateTime? subscriptionExpiresAt;
  final bool isSubscriptionActive;
  final DateTime createdAt;
  final DateTime? lastLoginAt;

  const AdminUserDto({
    required this.id,
    required this.name,
    this.email,
    required this.subscriptionTier,
    this.subscriptionExpiresAt,
    required this.isSubscriptionActive,
    required this.createdAt,
    this.lastLoginAt,
  });

  factory AdminUserDto.fromJson(Map<String, dynamic> json) {
    return AdminUserDto(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String?,
      subscriptionTier: SubscriptionTier.values.firstWhere(
        (e) => e.name == json['subscriptionTier'],
        orElse: () => SubscriptionTier.free,
      ),
      subscriptionExpiresAt: json['subscriptionExpiresAt'] != null
          ? DateTime.tryParse(json['subscriptionExpiresAt'] as String)
          : null,
      isSubscriptionActive: json['isSubscriptionActive'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.tryParse(json['lastLoginAt'] as String)
          : null,
    );
  }

  AdminUserDto copyWith({
    SubscriptionTier? subscriptionTier,
    DateTime? subscriptionExpiresAt,
    bool? isSubscriptionActive,
    bool clearExpiresAt = false,
  }) {
    return AdminUserDto(
      id: id,
      name: name,
      email: email,
      subscriptionTier: subscriptionTier ?? this.subscriptionTier,
      subscriptionExpiresAt: clearExpiresAt
          ? null
          : (subscriptionExpiresAt ?? this.subscriptionExpiresAt),
      isSubscriptionActive: isSubscriptionActive ?? this.isSubscriptionActive,
      createdAt: createdAt,
      lastLoginAt: lastLoginAt,
    );
  }
}

class AdminUserListResult {
  final List<AdminUserDto> items;
  final int total;
  final int page;
  final int limit;

  const AdminUserListResult({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
  });

  bool get hasMore => page * limit < total;

  factory AdminUserListResult.fromJson(Map<String, dynamic> json) {
    return AdminUserListResult(
      items: (json['items'] as List)
          .map((e) => AdminUserDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
      page: json['page'] as int,
      limit: json['limit'] as int,
    );
  }
}
