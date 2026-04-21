import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:family_planner/features/main/assets/data/models/account_model.dart';
import 'package:family_planner/features/main/assets/data/models/asset_record_model.dart';
import 'package:family_planner/features/main/assets/data/models/asset_statistics_model.dart';
import 'package:family_planner/features/main/assets/data/models/asset_trend_model.dart';
import 'package:family_planner/features/home/providers/dashboard_provider.dart';
import 'package:family_planner/features/main/assets/data/repositories/asset_repository.dart';

part 'asset_provider.g.dart';

/// 현재 선택된 그룹 ID (자산관리용)
final assetSelectedGroupIdProvider = StateProvider<String?>((ref) => null);

/// 선택된 멤버 필터 (null = 전체)
final assetSelectedUserIdProvider = StateProvider<String?>((ref) => null);

/// 계좌 목록 Provider
@riverpod
class AssetAccounts extends _$AssetAccounts {
  @override
  Future<List<AccountModel>> build() async {
    final groupId = ref.watch(assetSelectedGroupIdProvider);
    final userId = ref.watch(assetSelectedUserIdProvider);

    if (groupId == null) return [];

    final repository = ref.watch(assetRepositoryProvider);
    return repository.getAccounts(groupId: groupId, userId: userId);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final groupId = ref.read(assetSelectedGroupIdProvider);
      final userId = ref.read(assetSelectedUserIdProvider);
      if (groupId == null) return <AccountModel>[];
      return ref.read(assetRepositoryProvider).getAccounts(
            groupId: groupId,
            userId: userId,
          );
    });
  }

  void addAccount(AccountModel account) {
    if (!state.hasValue) return;
    state = AsyncValue.data([account, ...state.value!]);
  }

  void updateAccount(AccountModel account) {
    if (!state.hasValue) return;
    state = AsyncValue.data(
      state.value!.map((a) => a.id == account.id ? account : a).toList(),
    );
  }

  void removeAccount(String id) {
    if (!state.hasValue) return;
    state = AsyncValue.data(
      state.value!.where((a) => a.id != id).toList(),
    );
  }
}

/// 자산 기록 Provider
@riverpod
class AssetRecords extends _$AssetRecords {
  @override
  Future<List<AssetRecordModel>> build(String accountId) async {
    final repository = ref.watch(assetRepositoryProvider);
    return repository.getAssetRecords(accountId);
  }

  Future<void> refresh(String accountId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(assetRepositoryProvider).getAssetRecords(accountId),
    );
  }

  void addRecord(AssetRecordModel record) {
    if (!state.hasValue) return;
    final updated = [record, ...state.value!]
      ..sort((a, b) => b.recordDate.compareTo(a.recordDate));
    state = AsyncValue.data(updated);
  }

  void removeRecord(String recordId) {
    if (!state.hasValue) return;
    state = AsyncValue.data(
      state.value!.where((r) => r.id != recordId).toList(),
    );
  }
}

/// 자산 통계 Provider
@riverpod
Future<AssetStatisticsModel> assetStatistics(Ref ref) async {
  final groupId = ref.watch(assetSelectedGroupIdProvider);
  final userId = ref.watch(assetSelectedUserIdProvider);

  if (groupId == null) return AssetStatisticsModel.empty();

  final repository = ref.watch(assetRepositoryProvider);
  return repository.getAssetStatistics(groupId: groupId, userId: userId);
}

/// 그룹 자산 추이 Provider
@riverpod
Future<List<AssetTrendPoint>> groupAssetTrend(
  Ref ref, {
  required TrendPeriod period,
  String? year,
}) async {
  final groupId = ref.watch(assetSelectedGroupIdProvider);
  if (groupId == null) return [];
  final repository = ref.watch(assetRepositoryProvider);
  return repository.getGroupAssetTrend(
    groupId: groupId,
    period: period,
    year: year,
  );
}

/// 계좌별 자산 추이 Provider
@riverpod
Future<List<AssetTrendPoint>> accountAssetTrend(
  Ref ref,
  String accountId, {
  required TrendPeriod period,
  String? year,
}) async {
  final repository = ref.watch(assetRepositoryProvider);
  return repository.getAccountAssetTrend(
    accountId: accountId,
    period: period,
    year: year,
  );
}

/// 자산 관리 Notifier (생성/수정/삭제)
class AssetManagementNotifier extends StateNotifier<AsyncValue<void>> {
  final AssetRepository _repository;
  final Ref _ref;

  AssetManagementNotifier(this._repository, this._ref)
      : super(const AsyncValue.data(null));

  Future<AccountModel?> createAccount(CreateAccountDto dto) async {
    state = const AsyncValue.loading();
    try {
      final account = await _repository.createAccount(dto);
      _ref.read(assetAccountsProvider.notifier).addAccount(account);
      _ref.invalidate(assetStatisticsProvider);
      _ref.invalidate(dashboardAssetStatisticsProvider);
      state = const AsyncValue.data(null);
      return account;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<AccountModel?> updateAccount(String id, UpdateAccountDto dto) async {
    state = const AsyncValue.loading();
    try {
      final account = await _repository.updateAccount(id, dto);
      _ref.read(assetAccountsProvider.notifier).updateAccount(account);
      _ref.invalidate(assetStatisticsProvider);
      _ref.invalidate(dashboardAssetStatisticsProvider);
      state = const AsyncValue.data(null);
      return account;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<bool> deleteAccount(String id) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteAccount(id);
      _ref.read(assetAccountsProvider.notifier).removeAccount(id);
      _ref.invalidate(assetStatisticsProvider);
      _ref.invalidate(dashboardAssetStatisticsProvider);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<AssetRecordModel?> createRecord(
    String accountId,
    CreateAssetRecordDto dto,
  ) async {
    state = const AsyncValue.loading();
    try {
      final record = await _repository.createAssetRecord(accountId, dto);
      _ref.read(assetRecordsProvider(accountId).notifier).addRecord(record);
      _ref.invalidate(assetStatisticsProvider);
      _ref.invalidate(dashboardAssetStatisticsProvider);
      _ref.invalidate(groupAssetTrendProvider);
      _ref.invalidate(accountAssetTrendProvider);
      // 계좌 목록도 갱신 (latestBalance 업데이트)
      _ref.read(assetAccountsProvider.notifier).refresh();
      state = const AsyncValue.data(null);
      return record;
    } on DuplicateRecordDateException {
      state = const AsyncValue.data(null);
      rethrow;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<bool> deleteRecord(String accountId, String recordId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteAssetRecord(accountId, recordId);
      _ref.read(assetRecordsProvider(accountId).notifier).removeRecord(recordId);
      _ref.invalidate(assetStatisticsProvider);
      _ref.invalidate(dashboardAssetStatisticsProvider);
      _ref.invalidate(groupAssetTrendProvider);
      _ref.invalidate(accountAssetTrendProvider);
      _ref.read(assetAccountsProvider.notifier).refresh();
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

final assetManagementProvider =
    StateNotifierProvider<AssetManagementNotifier, AsyncValue<void>>((ref) {
  return AssetManagementNotifier(
    ref.watch(assetRepositoryProvider),
    ref,
  );
});
