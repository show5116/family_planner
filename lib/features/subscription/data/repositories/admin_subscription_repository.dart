import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/models/subscription_tier.dart';
import 'package:family_planner/core/services/api_client.dart';
import 'package:family_planner/features/subscription/data/models/admin_user_dto.dart';

class AdminSubscriptionRepository {
  Future<AdminUserListResult> getUsers({
    int page = 1,
    int limit = 20,
    String? search,
    SubscriptionTier? tier,
  }) async {
    final response = await ApiClient.instance.dio.get(
      '/subscription/admin/users',
      queryParameters: {
        'page': page,
        'limit': limit,
        if (search != null && search.isNotEmpty) 'search': search,
        if (tier != null) 'tier': tier.name,
      },
    );
    return AdminUserListResult.fromJson(response.data as Map<String, dynamic>);
  }

  Future<AdminUserDto> getUser(String userId) async {
    final response = await ApiClient.instance.dio.get(
      '/subscription/admin/users/$userId',
    );
    return AdminUserDto.fromJson(response.data as Map<String, dynamic>);
  }

  Future<AdminUserDto> updateSubscription({
    required String userId,
    required SubscriptionTier tier,
    String? expiresAt,
  }) async {
    final response = await ApiClient.instance.dio.patch(
      '/subscription/admin/users/$userId/subscription',
      data: {
        'tier': tier.name,
        'expiresAt': expiresAt,
      },
    );
    return AdminUserDto.fromJson(response.data as Map<String, dynamic>);
  }
}

final adminSubscriptionRepositoryProvider =
    Provider<AdminSubscriptionRepository>((_) => AdminSubscriptionRepository());
