import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:family_planner/features/main/child_points/data/models/childcare_model.dart';
import 'package:family_planner/features/main/child_points/data/repositories/childcare_repository.dart';

part 'childcare_provider.g.dart';

/// 현재 선택된 그룹 ID (육아포인트용)
final childcareSelectedGroupIdProvider = StateProvider<String?>((ref) => null);

/// 현재 선택된 자녀 프로필 ID
final childcareSelectedChildIdProvider = StateProvider<String?>((ref) => null);

/// 조회 월 Provider (YYYY-MM)
final childcareSelectedMonthProvider = StateProvider<String>((ref) {
  final now = DateTime.now();
  return '${now.year}-${now.month.toString().padLeft(2, '0')}';
});

// ── 자녀 프로필 목록 ──────────────────────────────────────────────────────────

/// 자녀 프로필 목록 Provider
@riverpod
class ChildcareChildren extends _$ChildcareChildren {
  @override
  Future<List<ChildcareChild>> build() async {
    final groupId = ref.watch(childcareSelectedGroupIdProvider);
    if (groupId == null) return [];

    final repository = ref.watch(childcareRepositoryProvider);
    return repository.getChildren(groupId: groupId);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final groupId = ref.read(childcareSelectedGroupIdProvider);
      if (groupId == null) return <ChildcareChild>[];
      return ref
          .read(childcareRepositoryProvider)
          .getChildren(groupId: groupId);
    });
  }

  void addChild(ChildcareChild child) {
    if (!state.hasValue) return;
    state = AsyncValue.data([...state.value!, child]);
  }

  void updateChild(ChildcareChild child) {
    if (!state.hasValue) return;
    state = AsyncValue.data(
      state.value!.map((c) => c.id == child.id ? child : c).toList(),
    );
  }
}

// ── 포인트 계정 (자녀 프로필 기준 조회) ──────────────────────────────────────

/// 포인트 계정 목록 Provider (그룹 기준)
@riverpod
class ChildcareAccounts extends _$ChildcareAccounts {
  @override
  Future<List<ChildcareAccount>> build() async {
    final groupId = ref.watch(childcareSelectedGroupIdProvider);
    if (groupId == null) return [];

    final repository = ref.watch(childcareRepositoryProvider);
    return repository.getAccounts(groupId: groupId);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final groupId = ref.read(childcareSelectedGroupIdProvider);
      if (groupId == null) return <ChildcareAccount>[];
      return ref
          .read(childcareRepositoryProvider)
          .getAccounts(groupId: groupId);
    });
  }

  void updateAccount(ChildcareAccount account) {
    if (!state.hasValue) return;
    state = AsyncValue.data(
      state.value!.map((a) => a.id == account.id ? account : a).toList(),
    );
  }
}

/// 현재 선택된 자녀의 포인트 계정 (childId 기반 매핑)
final selectedChildAccountProvider = Provider<ChildcareAccount?>((ref) {
  final childId = ref.watch(childcareSelectedChildIdProvider);
  final accountsAsync = ref.watch(childcareAccountsProvider);
  if (childId == null) return null;
  return accountsAsync.maybeWhen(
    data: (accounts) {
      try {
        return accounts.firstWhere((a) => a.childId == childId);
      } catch (_) {
        return null;
      }
    },
    orElse: () => null,
  );
});

// ── 용돈 플랜 ─────────────────────────────────────────────────────────────────

class _AllowancePlanNotifier
    extends StateNotifier<AsyncValue<AllowancePlan?>> {
  final ChildcareRepository _repository;
  final Ref _ref;

  _AllowancePlanNotifier(this._repository, this._ref)
      : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    final childId = _ref.read(childcareSelectedChildIdProvider);
    if (childId == null) {
      state = const AsyncValue.data(null);
      return;
    }
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getAllowancePlan(childId));
  }

  Future<void> refresh() => _load();

  void setPlan(AllowancePlan plan) {
    state = AsyncValue.data(plan);
  }
}

/// 선택된 자녀의 용돈 플랜 Provider
final childcareAllowancePlanProvider =
    StateNotifierProvider<_AllowancePlanNotifier, AsyncValue<AllowancePlan?>>(
        (ref) {
  final repository = ref.watch(childcareRepositoryProvider);
  final notifier = _AllowancePlanNotifier(repository, ref);
  // 선택된 자녀가 바뀌면 자동 갱신
  ref.listen(childcareSelectedChildIdProvider, (_, _) => notifier.refresh());
  return notifier;
});

/// 용돈 플랜 히스토리 Provider
final childcareAllowancePlanHistoryProvider =
    FutureProvider<List<AllowancePlanHistory>>((ref) async {
  final childId = ref.watch(childcareSelectedChildIdProvider);
  if (childId == null) return [];
  return ref
      .watch(childcareRepositoryProvider)
      .getAllowancePlanHistory(childId);
});

// ── 거래 내역 ─────────────────────────────────────────────────────────────────

/// 거래 내역 Provider
@riverpod
class ChildcareTransactions extends _$ChildcareTransactions {
  @override
  Future<List<ChildcareTransaction>> build() async {
    final account = ref.watch(selectedChildAccountProvider);
    final month = ref.watch(childcareSelectedMonthProvider);
    if (account == null) return [];

    final repository = ref.watch(childcareRepositoryProvider);
    return repository.getTransactions(account.id, month: month);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final account = ref.read(selectedChildAccountProvider);
      final month = ref.read(childcareSelectedMonthProvider);
      if (account == null) return <ChildcareTransaction>[];
      return ref
          .read(childcareRepositoryProvider)
          .getTransactions(account.id, month: month);
    });
  }

  void addTransaction(ChildcareTransaction transaction) {
    if (!state.hasValue) return;
    state = AsyncValue.data([transaction, ...state.value!]);
  }
}

// ── 보상 ─────────────────────────────────────────────────────────────────────

/// 보상 목록 Provider
@riverpod
class ChildcareRewards extends _$ChildcareRewards {
  @override
  Future<List<ChildcareReward>> build() async {
    final account = ref.watch(selectedChildAccountProvider);
    if (account == null) return [];

    final repository = ref.watch(childcareRepositoryProvider);
    return repository.getRewards(account.id);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final account = ref.read(selectedChildAccountProvider);
      if (account == null) return <ChildcareReward>[];
      return ref.read(childcareRepositoryProvider).getRewards(account.id);
    });
  }

  void addReward(ChildcareReward reward) {
    if (!state.hasValue) return;
    state = AsyncValue.data([...state.value!, reward]);
  }

  void updateReward(ChildcareReward reward) {
    if (!state.hasValue) return;
    state = AsyncValue.data(
      state.value!.map((r) => r.id == reward.id ? reward : r).toList(),
    );
  }

  void removeReward(String id) {
    if (!state.hasValue) return;
    state = AsyncValue.data(state.value!.where((r) => r.id != id).toList());
  }
}

// ── 규칙 ─────────────────────────────────────────────────────────────────────

/// 규칙 목록 Provider
@riverpod
class ChildcareRules extends _$ChildcareRules {
  @override
  Future<List<ChildcareRule>> build() async {
    final account = ref.watch(selectedChildAccountProvider);
    if (account == null) return [];

    final repository = ref.watch(childcareRepositoryProvider);
    return repository.getRules(account.id);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final account = ref.read(selectedChildAccountProvider);
      if (account == null) return <ChildcareRule>[];
      return ref.read(childcareRepositoryProvider).getRules(account.id);
    });
  }

  void addRule(ChildcareRule rule) {
    if (!state.hasValue) return;
    state = AsyncValue.data([...state.value!, rule]);
  }

  void updateRule(ChildcareRule rule) {
    if (!state.hasValue) return;
    state = AsyncValue.data(
      state.value!.map((r) => r.id == rule.id ? rule : r).toList(),
    );
  }

  void removeRule(String id) {
    if (!state.hasValue) return;
    state = AsyncValue.data(state.value!.where((r) => r.id != id).toList());
  }
}

// ── 관리 Notifier ─────────────────────────────────────────────────────────────

/// 육아 포인트 관리 Notifier (생성/수정/삭제)
class ChildcareManagementNotifier extends StateNotifier<AsyncValue<void>> {
  final ChildcareRepository _repository;
  final Ref _ref;

  ChildcareManagementNotifier(this._repository, this._ref)
      : super(const AsyncValue.data(null));

  /// 자녀 프로필 등록 (포인트 계정 자동 생성)
  Future<ChildcareChild?> createChild(CreateChildProfileDto dto) async {
    state = const AsyncValue.loading();
    try {
      final child = await _repository.createChild(dto);
      _ref.read(childcareChildrenProvider.notifier).addChild(child);
      // 계정 목록도 갱신 (자동 생성됨)
      _ref.read(childcareAccountsProvider.notifier).refresh();
      state = const AsyncValue.data(null);
      return child;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// 앱 계정 연동
  Future<ChildcareChild?> linkUser(String childId) async {
    state = const AsyncValue.loading();
    try {
      final child = await _repository.linkUser(childId);
      _ref.read(childcareChildrenProvider.notifier).updateChild(child);
      state = const AsyncValue.data(null);
      return child;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// 용돈 플랜 설정 (생성 또는 수정)
  Future<AllowancePlan?> upsertAllowancePlan(
    String childId,
    UpsertAllowancePlanDto dto,
  ) async {
    state = const AsyncValue.loading();
    try {
      final plan = await _repository.upsertAllowancePlan(childId, dto);
      _ref.read(childcareAllowancePlanProvider.notifier).setPlan(plan);
      // 히스토리 갱신
      _ref.invalidate(childcareAllowancePlanHistoryProvider);
      state = const AsyncValue.data(null);
      return plan;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// 포인트 거래 추가
  Future<ChildcareTransaction?> addTransaction(
    String accountId,
    CreateTransactionDto dto,
  ) async {
    state = const AsyncValue.loading();
    try {
      final transaction = await _repository.addTransaction(accountId, dto);
      _ref.read(childcareTransactionsProvider.notifier).addTransaction(transaction);
      _ref.read(childcareAccountsProvider.notifier).refresh();
      state = const AsyncValue.data(null);
      return transaction;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// 보상 추가
  Future<ChildcareReward?> addReward(
      String accountId, CreateRewardDto dto) async {
    state = const AsyncValue.loading();
    try {
      final reward = await _repository.addReward(accountId, dto);
      _ref.read(childcareRewardsProvider.notifier).addReward(reward);
      state = const AsyncValue.data(null);
      return reward;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// 보상 수정
  Future<ChildcareReward?> updateReward(
    String accountId,
    String rewardId,
    UpdateRewardDto dto,
  ) async {
    state = const AsyncValue.loading();
    try {
      final reward = await _repository.updateReward(accountId, rewardId, dto);
      _ref.read(childcareRewardsProvider.notifier).updateReward(reward);
      state = const AsyncValue.data(null);
      return reward;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// 보상 삭제
  Future<bool> deleteReward(String accountId, String rewardId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteReward(accountId, rewardId);
      _ref.read(childcareRewardsProvider.notifier).removeReward(rewardId);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// 규칙 추가
  Future<ChildcareRule?> addRule(String accountId, CreateRuleDto dto) async {
    state = const AsyncValue.loading();
    try {
      final rule = await _repository.addRule(accountId, dto);
      _ref.read(childcareRulesProvider.notifier).addRule(rule);
      state = const AsyncValue.data(null);
      return rule;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// 규칙 수정
  Future<ChildcareRule?> updateRule(
    String accountId,
    String ruleId,
    UpdateRuleDto dto,
  ) async {
    state = const AsyncValue.loading();
    try {
      final rule = await _repository.updateRule(accountId, ruleId, dto);
      _ref.read(childcareRulesProvider.notifier).updateRule(rule);
      state = const AsyncValue.data(null);
      return rule;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// 규칙 삭제
  Future<bool> deleteRule(String accountId, String ruleId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteRule(accountId, ruleId);
      _ref.read(childcareRulesProvider.notifier).removeRule(ruleId);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// 적금 입금
  Future<ChildcareTransaction?> savingsDeposit(
    String accountId,
    SavingsAmountDto dto,
  ) async {
    state = const AsyncValue.loading();
    try {
      final transaction = await _repository.savingsDeposit(accountId, dto);
      _ref.read(childcareTransactionsProvider.notifier).addTransaction(transaction);
      _ref.read(childcareAccountsProvider.notifier).refresh();
      state = const AsyncValue.data(null);
      return transaction;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// 적금 출금 (부모만)
  Future<ChildcareTransaction?> savingsWithdraw(
    String accountId,
    SavingsAmountDto dto,
  ) async {
    state = const AsyncValue.loading();
    try {
      final transaction = await _repository.savingsWithdraw(accountId, dto);
      _ref.read(childcareTransactionsProvider.notifier).addTransaction(transaction);
      _ref.read(childcareAccountsProvider.notifier).refresh();
      state = const AsyncValue.data(null);
      return transaction;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }
}

final childcareManagementProvider =
    StateNotifierProvider<ChildcareManagementNotifier, AsyncValue<void>>((ref) {
  return ChildcareManagementNotifier(
    ref.watch(childcareRepositoryProvider),
    ref,
  );
});
