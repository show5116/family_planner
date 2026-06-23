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
    String? deleteStatus,
  }) async {
    final response = await ApiClient.instance.dio.get(
      '/subscription/admin/users',
      queryParameters: {
        'page': page,
        'limit': limit,
        if (search != null && search.isNotEmpty) 'search': search,
        if (tier != null) 'tier': tier.name,
        if (deleteStatus != null) 'deleteStatus': deleteStatus,
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

  /// 계정 삭제 예약 (7일 유예)
  Future<Map<String, dynamic>> scheduleDelete(String userId) async {
    final response = await ApiClient.instance.dio.delete(
      '/auth/admin/users/$userId',
    );
    return response.data as Map<String, dynamic>;
  }

  /// 계정 삭제 예약 취소
  Future<void> cancelDelete(String userId) async {
    await ApiClient.instance.dio.post(
      '/auth/admin/users/$userId/cancel-delete',
    );
  }

  /// 삭제 예약 계정 즉시 완전 삭제
  Future<void> forceDelete(String userId) async {
    await ApiClient.instance.dio.delete(
      '/auth/admin/users/$userId/force',
    );
  }

  /// 운영자 권한 부여
  Future<void> grantAdmin(String userId) async {
    await ApiClient.instance.dio.patch(
      '/auth/admin/users/$userId/grant-admin',
    );
  }

  /// 운영자 권한 회수
  Future<void> revokeAdmin(String userId) async {
    await ApiClient.instance.dio.patch(
      '/auth/admin/users/$userId/revoke-admin',
    );
  }
}

final adminSubscriptionRepositoryProvider =
    Provider<AdminSubscriptionRepository>((_) => AdminSubscriptionRepository());
