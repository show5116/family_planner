import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/models/subscription_tier.dart';
import 'package:family_planner/features/subscription/data/models/admin_user_dto.dart';
import 'package:family_planner/features/subscription/data/repositories/admin_subscription_repository.dart';

// ── 목록 필터 상태 ────────────────────────────────────────────

class AdminUserFilter {
  final String search;
  final SubscriptionTier? tier;

  const AdminUserFilter({this.search = '', this.tier});

  AdminUserFilter copyWith({String? search, SubscriptionTier? tier, bool clearTier = false}) {
    return AdminUserFilter(
      search: search ?? this.search,
      tier: clearTier ? null : (tier ?? this.tier),
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

  /// 목록에서 특정 유저의 구독 정보를 갱신
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
