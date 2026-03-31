import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/features/main/savings/data/models/savings_model.dart';
import 'package:family_planner/features/main/savings/data/repositories/savings_repository.dart';

/// 현재 선택된 그룹 ID (적립금 관리용)
final savingsSelectedGroupIdProvider = StateProvider<String?>((ref) => null);

// ── 적립 목표 목록 ─────────────────────────────────────────────────────────────

class _SavingsGoalsNotifier
    extends StateNotifier<AsyncValue<List<SavingsGoalModel>>> {
  final SavingsRepository _repository;
  final String groupId;

  _SavingsGoalsNotifier(this._repository, this.groupId)
      : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    state = const AsyncValue.loading();
    state =
        await AsyncValue.guard(() => _repository.getGoals(groupId));
  }

  Future<void> refresh() => _load();

  void removeGoal(String id) {
    if (!state.hasValue) return;
    state = AsyncValue.data(
      state.value!.where((g) => g.id != id).toList(),
    );
  }

  void addGoal(SavingsGoalModel goal) {
    if (!state.hasValue) return;
    state = AsyncValue.data([...state.value!, goal]);
  }

  void updateGoal(SavingsGoalModel goal) {
    if (!state.hasValue) return;
    state = AsyncValue.data(
      state.value!.map((g) => g.id == goal.id ? goal : g).toList(),
    );
  }
}

/// 적립 목표 목록 Provider (groupId 기반)
final savingsGoalsProvider = StateNotifierProvider.family<
    _SavingsGoalsNotifier, AsyncValue<List<SavingsGoalModel>>, String>(
  (ref, groupId) {
    final repository = ref.watch(savingsRepositoryProvider);
    return _SavingsGoalsNotifier(repository, groupId);
  },
);

// ── 적립 목표 상세 ─────────────────────────────────────────────────────────────

class _SavingsGoalDetailNotifier
    extends StateNotifier<AsyncValue<SavingsGoalModel>> {
  final SavingsRepository _repository;
  final String id;

  _SavingsGoalDetailNotifier(this._repository, this.id)
      : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getGoal(id));
  }

  Future<void> refresh() => _load();
}

/// 적립 목표 상세 Provider (id 기반)
final savingsGoalDetailProvider = StateNotifierProvider.family<
    _SavingsGoalDetailNotifier, AsyncValue<SavingsGoalModel>, String>(
  (ref, id) {
    final repository = ref.watch(savingsRepositoryProvider);
    return _SavingsGoalDetailNotifier(repository, id);
  },
);

// ── 적립 거래 내역 ─────────────────────────────────────────────────────────────

class _SavingsTransactionsNotifier
    extends StateNotifier<AsyncValue<SavingsTransactionListResult>> {
  final SavingsRepository _repository;
  final String goalId;

  _SavingsTransactionsNotifier(this._repository, this.goalId)
      : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    state = const AsyncValue.loading();
    state =
        await AsyncValue.guard(() => _repository.getTransactions(goalId));
  }

  Future<void> refresh() => _load();
}

/// 적립 거래 내역 Provider (goalId 기반)
final savingsTransactionsProvider = StateNotifierProvider.family<
    _SavingsTransactionsNotifier,
    AsyncValue<SavingsTransactionListResult>,
    String>(
  (ref, goalId) {
    final repository = ref.watch(savingsRepositoryProvider);
    return _SavingsTransactionsNotifier(repository, goalId);
  },
);
