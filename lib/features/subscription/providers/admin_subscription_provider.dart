import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/models/subscription_tier.dart';
import 'package:family_planner/features/subscription/data/models/admin_user_dto.dart';
import 'package:family_planner/features/subscription/data/repositories/admin_subscription_repository.dart';

// ── 목록 필터 상태 ────────────────────────────────────────────

enum UserDeleteStatusFilter { all, active, pendingDelete }

extension UserDeleteStatusFilterExt on UserDeleteStatusFilter {
  String get label {
    switch (this) {
      case UserDeleteStatusFilter.all:
        return '전체';
      case UserDeleteStatusFilter.active:
        return '정상';
      case UserDeleteStatusFilter.pendingDelete:
        return '삭제 유예';
    }
  }

  String? get apiValue {
    switch (this) {
      case UserDeleteStatusFilter.all:
        return null;
      case UserDeleteStatusFilter.active:
        return 'active';
      case UserDeleteStatusFilter.pendingDelete:
        return 'pending_delete';
    }
  }
}

class AdminUserFilter {
  final String search;
  final SubscriptionTier? tier;
  final UserDeleteStatusFilter deleteStatus;

  const AdminUserFilter({
    this.search = '',
    this.tier,
    this.deleteStatus = UserDeleteStatusFilter.all,
  });

  AdminUserFilter copyWith({
    String? search,
    SubscriptionTier? tier,
    bool clearTier = false,
    UserDeleteStatusFilter? deleteStatus,
  }) {
    return AdminUserFilter(
      search: search ?? this.search,
      tier: clearTier ? null : (tier ?? this.tier),
      deleteStatus: deleteStatus ?? this.deleteStatus,
    );
  }
}

final adminUserFilterProvider =
    StateProvider<AdminUserFilter>((_) => const AdminUserFilter());

// ── 사용자 목록 ───────────────────────────────────────────────

class AdminUserListNotifier extends AsyncNotifier<AdminUserListResult> {
  static const _limit = 20;

  @override
  Future<AdminUserListResult> build() async {
    final filter = ref.watch(adminUserFilterProvider);
    return _fetch(filter: filter, page: 1);
  }

  Future<AdminUserListResult> _fetch({
    required AdminUserFilter filter,
    required int page,
  }) async {
    final repo = ref.read(adminSubscriptionRepositoryProvider);
    return repo.getUsers(
      page: page,
      limit: _limit,
      search: filter.search.isEmpty ? null : filter.search,
      tier: filter.tier,
      deleteStatus: filter.deleteStatus.apiValue,
    );
  }

  Future<void> loadNextPage() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore) return;

    final filter = ref.read(adminUserFilterProvider);
    final next = await _fetch(filter: filter, page: current.page + 1);

    state = AsyncData(AdminUserListResult(
      items: [...current.items, ...next.items],
      total: next.total,
      page: next.page,
      limit: next.limit,
    ));
  }

  /// 목록에서 특정 유저의 정보를 갱신
  void updateUserInList(AdminUserDto updated) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(AdminUserListResult(
      items: current.items
          .map((u) => u.id == updated.id ? updated : u)
          .toList(),
      total: current.total,
      page: current.page,
      limit: current.limit,
    ));
  }

  /// 목록에서 특정 유저를 제거 (즉시 삭제 후)
  void removeUserFromList(String userId) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(AdminUserListResult(
      items: current.items.where((u) => u.id != userId).toList(),
      total: current.total - 1,
      page: current.page,
      limit: current.limit,
    ));
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final filter = ref.read(adminUserFilterProvider);
    state = await AsyncValue.guard(() => _fetch(filter: filter, page: 1));
  }
}

final adminUserListProvider =
    AsyncNotifierProvider<AdminUserListNotifier, AdminUserListResult>(
  AdminUserListNotifier.new,
);

// ── 구독 수정 ─────────────────────────────────────────────────

class AdminSubscriptionEditNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<AdminUserDto?> updateSubscription({
    required String userId,
    required SubscriptionTier tier,
    DateTime? expiresAt,
  }) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() async {
      final repo = ref.read(adminSubscriptionRepositoryProvider);
      return repo.updateSubscription(
        userId: userId,
        tier: tier,
        expiresAt: expiresAt?.toUtc().toIso8601String(),
      );
    });
    state = const AsyncData(null);

    if (result is AsyncData<AdminUserDto>) {
      ref.read(adminUserListProvider.notifier).updateUserInList(result.value);
      return result.value;
    }
    return null;
  }
}

final adminSubscriptionEditProvider =
    AsyncNotifierProvider<AdminSubscriptionEditNotifier, void>(
  AdminSubscriptionEditNotifier.new,
);

// ── 계정 삭제 관련 액션 ───────────────────────────────────────

class AdminUserDeleteNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  /// 계정 삭제 예약 (7일 유예) — 성공 시 deletedAt 날짜 반환
  Future<DateTime?> scheduleDelete(String userId) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() async {
      final repo = ref.read(adminSubscriptionRepositoryProvider);
      final data = await repo.scheduleDelete(userId);
      return data['scheduledDeleteAt'] as String?;
    });
    state = const AsyncData(null);

    if (result is AsyncData<String?> && result.value != null) {
      final scheduledAt = DateTime.tryParse(result.value!);
      final current = ref
          .read(adminUserListProvider)
          .valueOrNull
          ?.items
          .where((u) => u.id == userId)
          .firstOrNull;
      if (current != null && scheduledAt != null) {
        ref
            .read(adminUserListProvider.notifier)
            .updateUserInList(current.copyWith(deletedAt: scheduledAt));
      }
      return scheduledAt;
    }
    return null;
  }

  /// 계정 삭제 예약 취소
  Future<bool> cancelDelete(String userId) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() async {
      final repo = ref.read(adminSubscriptionRepositoryProvider);
      await repo.cancelDelete(userId);
    });
    state = const AsyncData(null);

    if (result is AsyncData) {
      final current = ref
          .read(adminUserListProvider)
          .valueOrNull
          ?.items
          .where((u) => u.id == userId)
          .firstOrNull;
      if (current != null) {
        ref
            .read(adminUserListProvider.notifier)
            .updateUserInList(current.copyWith(clearDeletedAt: true));
      }
      return true;
    }
    return false;
  }

  /// 삭제 예약 계정 즉시 완전 삭제
  Future<bool> forceDelete(String userId) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() async {
      final repo = ref.read(adminSubscriptionRepositoryProvider);
      await repo.forceDelete(userId);
    });
    state = const AsyncData(null);

    if (result is AsyncData) {
      ref.read(adminUserListProvider.notifier).removeUserFromList(userId);
      return true;
    }
    return false;
  }
}

final adminUserDeleteProvider =
    AsyncNotifierProvider<AdminUserDeleteNotifier, void>(
  AdminUserDeleteNotifier.new,
);

// ── 운영자 권한 관리 ──────────────────────────────────────────

class AdminUserAdminRoleNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> grantAdmin(String userId) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() async {
      final repo = ref.read(adminSubscriptionRepositoryProvider);
      await repo.grantAdmin(userId);
    });
    state = const AsyncData(null);

    if (result is AsyncData) {
      _updateIsAdmin(userId, isAdmin: true);
      return true;
    }
    return false;
  }

  Future<bool> revokeAdmin(String userId) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() async {
      final repo = ref.read(adminSubscriptionRepositoryProvider);
      await repo.revokeAdmin(userId);
    });
    state = const AsyncData(null);

    if (result is AsyncData) {
      _updateIsAdmin(userId, isAdmin: false);
      return true;
    }
    return false;
  }

  void _updateIsAdmin(String userId, {required bool isAdmin}) {
    final current = ref
        .read(adminUserListProvider)
        .valueOrNull
        ?.items
        .where((u) => u.id == userId)
        .firstOrNull;
    if (current != null) {
      ref
          .read(adminUserListProvider.notifier)
          .updateUserInList(current.copyWith(isAdmin: isAdmin));
    }
  }
}

final adminUserAdminRoleProvider =
    AsyncNotifierProvider<AdminUserAdminRoleNotifier, void>(
  AdminUserAdminRoleNotifier.new,
);
