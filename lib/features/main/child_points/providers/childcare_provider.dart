import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:family_planner/features/main/child_points/data/models/childcare_model.dart';
import 'package:family_planner/features/main/child_points/data/repositories/childcare_repository.dart';

part 'childcare_provider.g.dart';

/// 현재 선택된 그룹 ID (육아포인트용)
final childcareSelectedGroupIdProvider = StateProvider<String?>((ref) => null);

/// 현재 선택된 자녀 프로필 ID
final childcareSelectedChildIdProvider = StateProvider<String?>((ref) => null);

/// 히스토리 조회 단위 (월별 / 연도별)
enum HistoryViewMode { monthly, yearly }

final childcareHistoryViewModeProvider =
    StateProvider<HistoryViewMode>((ref) => HistoryViewMode.monthly);

/// 조회 월 Provider (YYYY-MM)
final childcareSelectedMonthProvider = StateProvider<String>((ref) {
  final now = DateTime.now();
  return '${now.year}-${now.month.toString().padLeft(2, '0')}';
});

/// 조회 연도 Provider (YYYY)
final childcareSelectedYearProvider = StateProvider<String>((ref) {
  return DateTime.now().year.toString();
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

/// 거래 내역 Provider (월별 또는 연도별)
@riverpod
class ChildcareTransactions extends _$ChildcareTransactions {
  @override
  Future<TransactionResult> build() async {
    final account = ref.watch(selectedChildAccountProvider);
    final mode = ref.watch(childcareHistoryViewModeProvider);
    final month = ref.watch(childcareSelectedMonthProvider);
    final year = ref.watch(childcareSelectedYearProvider);
    if (account == null) {
      return TransactionResult(transactions: [], closingBalance: 0);
    }
    final repository = ref.watch(childcareRepositoryProvider);
    return mode == HistoryViewMode.monthly
        ? repository.getTransactions(account.id, month: month)
        : repository.getTransactions(account.id, year: year);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final account = ref.read(selectedChildAccountProvider);
      final mode = ref.read(childcareHistoryViewModeProvider);
      final month = ref.read(childcareSelectedMonthProvider);
      final year = ref.read(childcareSelectedYearProvider);
      if (account == null) {
        return TransactionResult(transactions: [], closingBalance: 0);
      }
      return mode == HistoryViewMode.monthly
          ? ref.read(childcareRepositoryProvider)
              .getTransactions(account.id, month: month)
          : ref.read(childcareRepositoryProvider)
              .getTransactions(account.id, year: year);
    });
  }

  void addTransaction(ChildcareTransaction transaction) {
    if (!state.hasValue) return;
    final current = state.value!;
    state = AsyncValue.data(TransactionResult(
      transactions: [transaction, ...current.transactions],
      closingBalance: current.closingBalance + transaction.amount,
    ));
  }
}

// ── 포인트 상점 ───────────────────────────────────────────────────────────────

/// 포인트 상점 아이템 목록 Provider
@riverpod
class ChildcareShopItems extends _$ChildcareShopItems {
  @override
  Future<List<ChildcareShopItem>> build() async {
    final account = ref.watch(selectedChildAccountProvider);
    if (account == null) return [];

    final repository = ref.watch(childcareRepositoryProvider);
    return repository.getShopItems(account.id);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final account = ref.read(selectedChildAccountProvider);
      if (account == null) return <ChildcareShopItem>[];
      return ref.read(childcareRepositoryProvider).getShopItems(account.id);
    });
  }

  void addItem(ChildcareShopItem item) {
    if (!state.hasValue) return;
    state = AsyncValue.data([...state.value!, item]);
  }

  void updateItem(ChildcareShopItem item) {
    if (!state.hasValue) return;
    state = AsyncValue.data(
      state.value!.map((r) => r.id == item.id ? item : r).toList(),
    );
  }

  void removeItem(String id) {
    if (!state.hasValue) return;
    state = AsyncValue.data(state.value!.where((r) => r.id != id).toList());
  }

  void reorderItems(List<ChildcareShopItem> items) {
    if (!state.hasValue) return;
    state = AsyncValue.data(items);
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

  void reorderRules(List<ChildcareRule> rules) {
    if (!state.hasValue) return;
    state = AsyncValue.data(rules);
  }
}

// ── 적금 플랜 ─────────────────────────────────────────────────────────────────

/// 적금 플랜 Provider (accountId 기반)
final childcareSavingsPlanProvider =
    FutureProvider.family<ChildcareSavingsPlan?, String>((ref, accountId) {
  return ref.watch(childcareRepositoryProvider).getSavingsPlan(accountId);
});


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

  /// 상점 아이템 추가
  Future<ChildcareShopItem?> addShopItem(
      String accountId, CreateShopItemDto dto) async {
    state = const AsyncValue.loading();
    try {
      final item = await _repository.addShopItem(accountId, dto);
      _ref.read(childcareShopItemsProvider.notifier).addItem(item);
      state = const AsyncValue.data(null);
      return item;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// 상점 아이템 수정
  Future<ChildcareShopItem?> updateShopItem(
    String accountId,
    String itemId,
    UpdateShopItemDto dto,
  ) async {
    state = const AsyncValue.loading();
    try {
      final item = await _repository.updateShopItem(accountId, itemId, dto);
      _ref.read(childcareShopItemsProvider.notifier).updateItem(item);
      state = const AsyncValue.data(null);
      return item;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// 상점 아이템 순서 변경
  Future<void> reorderShopItems(
      String accountId, List<ChildcareShopItem> items) async {
    // 낙관적 업데이트 — UI 즉시 반영
    _ref.read(childcareShopItemsProvider.notifier).reorderItems(items);
    try {
      await _repository.reorderShopItems(
          accountId, items.map((e) => e.id).toList());
    } catch (_) {
      // 실패 시 서버 데이터로 복구
      _ref.read(childcareShopItemsProvider.notifier).refresh();
    }
  }

  /// 상점 아이템 삭제
  Future<bool> deleteShopItem(String accountId, String itemId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteShopItem(accountId, itemId);
      _ref.read(childcareShopItemsProvider.notifier).removeItem(itemId);
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

  /// 규칙 순서 변경
  Future<void> reorderRules(
      String accountId, List<ChildcareRule> rules) async {
    _ref.read(childcareRulesProvider.notifier).reorderRules(rules);
    try {
      await _repository.reorderRules(
          accountId, rules.map((e) => e.id).toList());
    } catch (_) {
      _ref.read(childcareRulesProvider.notifier).refresh();
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

  /// 적금 플랜 생성
  Future<ChildcareSavingsPlan?> createSavingsPlan(
    String accountId,
    CreateSavingsPlanDto dto,
  ) async {
    state = const AsyncValue.loading();
    try {
      final plan = await _repository.createSavingsPlan(accountId, dto);
      _ref.invalidate(childcareSavingsPlanProvider(accountId));
      _ref.read(childcareAccountsProvider.notifier).refresh();
      state = const AsyncValue.data(null);
      return plan;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// 적금 플랜 중도 해지
  Future<bool> cancelSavingsPlan(String accountId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.cancelSavingsPlan(accountId);
      _ref.invalidate(childcareSavingsPlanProvider(accountId));
      _ref.read(childcareAccountsProvider.notifier).refresh();
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
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
