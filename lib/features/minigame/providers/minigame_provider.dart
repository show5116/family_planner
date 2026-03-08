import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:family_planner/features/minigame/data/models/minigame_model.dart';
import 'package:family_planner/features/minigame/data/repositories/minigame_repository.dart';

part 'minigame_provider.g.dart';

/// 현재 선택된 그룹 ID (미니게임용)
final minigameSelectedGroupIdProvider = StateProvider<String?>((ref) => null);

/// 게임 타입 필터
final minigameTypeFilterProvider = StateProvider<MinigameType?>((ref) => null);

// ── 게임 이력 ─────────────────────────────────────────────────────────────────

/// 게임 이력 목록 Provider
@riverpod
class MinigameResults extends _$MinigameResults {
  static const int _pageSize = 20;

  @override
  Future<List<MinigameResult>> build() async {
    final groupId = ref.watch(minigameSelectedGroupIdProvider);
    if (groupId == null) return [];

    final gameType = ref.watch(minigameTypeFilterProvider);
    final repository = ref.watch(minigameRepositoryProvider);
    final response = await repository.getResults(
      groupId: groupId,
      gameType: gameType,
      limit: _pageSize,
    );
    return response.items;
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final groupId = ref.read(minigameSelectedGroupIdProvider);
      if (groupId == null) return <MinigameResult>[];
      final gameType = ref.read(minigameTypeFilterProvider);
      final response = await ref.read(minigameRepositoryProvider).getResults(
            groupId: groupId,
            gameType: gameType,
            limit: _pageSize,
          );
      return response.items;
    });
  }

  void addResult(MinigameResult result) {
    if (!state.hasValue) return;
    state = AsyncValue.data([result, ...state.value!]);
  }

  void removeResult(String id) {
    if (!state.hasValue) return;
    state = AsyncValue.data(state.value!.where((r) => r.id != id).toList());
  }
}

// ── 관리 Notifier ─────────────────────────────────────────────────────────────

/// 미니게임 관리 Notifier (결과 저장/삭제)
class MinigameManagementNotifier extends StateNotifier<AsyncValue<void>> {
  final MinigameRepository _repository;
  final Ref _ref;

  MinigameManagementNotifier(this._repository, this._ref)
      : super(const AsyncValue.data(null));

  /// 게임 결과 저장
  Future<MinigameResult?> saveResult(SaveMinigameResultDto dto) async {
    state = const AsyncValue.loading();
    try {
      final result = await _repository.saveResult(dto);
      _ref.read(minigameResultsProvider.notifier).addResult(result);
      state = const AsyncValue.data(null);
      return result;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// 게임 이력 삭제
  Future<bool> deleteResult(String id) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteResult(id);
      _ref.read(minigameResultsProvider.notifier).removeResult(id);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

final minigameManagementProvider =
    StateNotifierProvider<MinigameManagementNotifier, AsyncValue<void>>((ref) {
  return MinigameManagementNotifier(
    ref.watch(minigameRepositoryProvider),
    ref,
  );
});
