import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:family_planner/features/main/child_points/data/models/childcare_model.dart';
import 'package:family_planner/features/main/child_points/data/repositories/childcare_repository.dart';

part 'childcare_provider.g.dart';

/// 현재 선택된 그룹 ID (육아포인트용)
final childcareSelectedGroupIdProvider = StateProvider<String?>((ref) => null);

/// 현재 선택된 계정 ID
final childcareSelectedAccountIdProvider = StateProvider<String?>((ref) => null);

/// 조회 월 Provider (YYYY-MM)
final childcareSelectedMonthProvider = StateProvider<String>((ref) {
  final now = DateTime.now();
  return '${now.year}-${now.month.toString().padLeft(2, '0')}';
});

// ── 계정 목록 ─────────────────────────────────────────────────────────────────

/// 육아 계정 목록 Provider
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
      return ref.read(childcareRepositoryProvider).getAccounts(groupId: groupId);
    });
  }

  void addAccount(ChildcareAccount account) {
    if (!state.hasValue) return;
    state = AsyncValue.data([...state.value!, account]);
  }

  void updateAccount(ChildcareAccount account) {
    if (!state.hasValue) return;
    state = AsyncValue.data(
      state.value!.map((a) => a.id == account.id ? account : a).toList(),
    );
  }
}

// ── 계정 상세 ─────────────────────────────────────────────────────────────────

/// 육아 계정 상세 Provider
@riverpod
Future<ChildcareAccount?> childcareAccountDetail(Ref ref) async {
  final accountId = ref.watch(childcareSelectedAccountIdProvider);
  if (accountId == null) return null;

  final repository = ref.watch(childcareRepositoryProvider);
  return repository.getAccount(accountId);
}

// ── 거래 내역 ─────────────────────────────────────────────────────────────────

/// 거래 내역 Provider
@riverpod
class ChildcareTransactions extends _$ChildcareTransactions {
  @override
  Future<List<ChildcareTransaction>> build() async {
    final accountId = ref.watch(childcareSelectedAccountIdProvider);
    final month = ref.watch(childcareSelectedMonthProvider);
    if (accountId == null) return [];

    final repository = ref.watch(childcareRepositoryProvider);
    return repository.getTransactions(accountId, month: month);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final accountId = ref.read(childcareSelectedAccountIdProvider);
      final month = ref.read(childcareSelectedMonthProvider);
      if (accountId == null) return <ChildcareTransaction>[];
      return ref
          .read(childcareRepositoryProvider)
          .getTransactions(accountId, month: month);
    });
  }

  void addTransaction(ChildcareTransaction transaction) {
    if (!state.hasValue) return;
    state = AsyncValue.data([transaction, ...state.value!]);
  }
}

// ── 보상 ────────────────────────────────────────────────────────────────────

/// 보상 목록 Provider
@riverpod
class ChildcareRewards extends _$ChildcareRewards {
  @override
  Future<List<ChildcareReward>> build() async {
    final accountId = ref.watch(childcareSelectedAccountIdProvider);
    if (accountId == null) return [];

    final repository = ref.watch(childcareRepositoryProvider);
    return repository.getRewards(accountId);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final accountId = ref.read(childcareSelectedAccountIdProvider);
      if (accountId == null) return <ChildcareReward>[];
      return ref.read(childcareRepositoryProvider).getRewards(accountId);
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

// ── 규칙 ────────────────────────────────────────────────────────────────────

/// 규칙 목록 Provider
@riverpod
class ChildcareRules extends _$ChildcareRules {
  @override
  Future<List<ChildcareRule>> build() async {
    final accountId = ref.watch(childcareSelectedAccountIdProvider);
    if (accountId == null) return [];

    final repository = ref.watch(childcareRepositoryProvider);
    return repository.getRules(accountId);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final accountId = ref.read(childcareSelectedAccountIdProvider);
      if (accountId == null) return <ChildcareRule>[];
      return ref.read(childcareRepositoryProvider).getRules(accountId);
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

// ── 관리 Notifier ──────────────────────────────────────────────────────────

/// 육아 포인트 관리 Notifier (생성/수정/삭제)
class ChildcareManagementNotifier extends StateNotifier<AsyncValue<void>> {
  final ChildcareRepository _repository;
  final Ref _ref;

  ChildcareManagementNotifier(this._repository, this._ref)
      : super(const AsyncValue.data(null));

  /// 계정 생성
  Future<ChildcareAccount?> createAccount(CreateChildcareAccountDto dto) async {
    state = const AsyncValue.loading();
    try {
      final account = await _repository.createAccount(dto);
      _ref.read(childcareAccountsProvider.notifier).addAccount(account);
      state = const AsyncValue.data(null);
      return account;
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
      // 계정 잔액 갱신
      _ref.invalidate(childcareAccountDetailProvider);
      _ref.read(childcareAccountsProvider.notifier).refresh();
      state = const AsyncValue.data(null);
      return transaction;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// 보상 추가
  Future<ChildcareReward?> addReward(String accountId, CreateRewardDto dto) async {
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
      _ref.invalidate(childcareAccountDetailProvider);
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
      _ref.invalidate(childcareAccountDetailProvider);
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
