import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:family_planner/features/main/routine/data/models/routine_model.dart';
import 'package:family_planner/features/main/routine/data/repositories/routine_repository.dart';

part 'routine_provider.g.dart';

// ── 루틴 목록 ─────────────────────────────────────────────────────────────────

/// 활성 루틴 목록 Provider
@riverpod
class RoutineList extends _$RoutineList {
  @override
  Future<List<Routine>> build() async {
    final repository = ref.watch(routineRepositoryProvider);
    return repository.getRoutines(isActive: true);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return ref.read(routineRepositoryProvider).getRoutines(isActive: true);
    });
  }

  void upsertRoutine(Routine routine) {
    if (!state.hasValue) return;
    final list = state.value!;
    final index = list.indexWhere((r) => r.id == routine.id);
    if (index == -1) {
      state = AsyncValue.data([...list, routine]);
    } else {
      final updated = [...list];
      updated[index] = routine;
      state = AsyncValue.data(updated);
    }
  }

  void removeRoutine(String routineId) {
    if (!state.hasValue) return;
    state = AsyncValue.data(
      state.value!.where((r) => r.id != routineId).toList(),
    );
  }

  void reorder(List<Routine> reordered) {
    if (!state.hasValue) return;
    state = AsyncValue.data(reordered);
  }

  /// 체크 상태 낙관적 반영
  void setCheckedToday(String routineId, bool checked) {
    if (!state.hasValue) return;
    state = AsyncValue.data(
      state.value!
          .map((r) =>
              r.id == routineId ? r.copyWith(checkedToday: checked) : r)
          .toList(),
    );
  }
}

// ── 루틴 상세 ─────────────────────────────────────────────────────────────────

@riverpod
class RoutineDetail extends _$RoutineDetail {
  @override
  Future<Routine> build(String routineId) async {
    final repository = ref.watch(routineRepositoryProvider);
    return repository.getRoutine(routineId);
  }

  void setRoutine(Routine routine) {
    state = AsyncValue.data(routine);
  }
}

// ── 통계 ──────────────────────────────────────────────────────────────────────

@riverpod
Future<RoutineHeatmap> routineHeatmap(
  Ref ref,
  String routineId, {
  required String fromDate,
  required String toDate,
}) async {
  final repository = ref.watch(routineRepositoryProvider);
  return repository.getHeatmap(routineId, from: fromDate, to: toDate);
}

@riverpod
Future<RoutineStreak> routineStreak(Ref ref, String routineId) async {
  final repository = ref.watch(routineRepositoryProvider);
  return repository.getStreak(routineId);
}

@riverpod
Future<RoutineRate> routineRate(
  Ref ref,
  String routineId, {
  required RoutineRatePeriod period,
  String? fromDate,
  String? toDate,
}) async {
  final repository = ref.watch(routineRepositoryProvider);
  return repository.getRate(
    routineId,
    period: period,
    from: fromDate,
    to: toDate,
  );
}

// ── 그룹 공유 ─────────────────────────────────────────────────────────────────

@riverpod
class RoutineShares extends _$RoutineShares {
  @override
  Future<List<RoutineShare>> build(String routineId) async {
    final repository = ref.watch(routineRepositoryProvider);
    return repository.getShares(routineId);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return ref.read(routineRepositoryProvider).getShares(routineId);
    });
  }
}

/// 그룹원별 공유 루틴 현황
@riverpod
Future<List<RoutineGroupMemberRoutines>> routineGroupMembers(
  Ref ref,
  String groupId,
) async {
  final repository = ref.watch(routineRepositoryProvider);
  return repository.getGroupMembers(groupId);
}

// ── 대시보드 요약 ─────────────────────────────────────────────────────────────

@riverpod
Future<List<RoutineSummaryItem>> routineSummary(Ref ref) async {
  final repository = ref.watch(routineRepositoryProvider);
  return repository.getSummary();
}

// ── 관리 Notifier ─────────────────────────────────────────────────────────────

/// 루틴 관리 Notifier (생성/수정/삭제/체크/공유)
class RoutineManagementNotifier extends StateNotifier<AsyncValue<void>> {
  final RoutineRepository _repository;
  final Ref _ref;

  RoutineManagementNotifier(this._repository, this._ref)
      : super(const AsyncValue.data(null));

  Future<Routine?> createRoutine(CreateRoutineDto dto) async {
    state = const AsyncValue.loading();
    try {
      final routine = await _repository.createRoutine(dto);
      _ref.read(routineListProvider.notifier).upsertRoutine(routine);
      state = const AsyncValue.data(null);
      return routine;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<Routine?> updateRoutine(String id, UpdateRoutineDto dto) async {
    state = const AsyncValue.loading();
    try {
      final routine = await _repository.updateRoutine(id, dto);
      _ref.read(routineListProvider.notifier).upsertRoutine(routine);
      _ref.read(routineDetailProvider(id).notifier).setRoutine(routine);
      state = const AsyncValue.data(null);
      return routine;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<bool> deleteRoutine(String id) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteRoutine(id);
      _ref.read(routineListProvider.notifier).removeRoutine(id);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// 순서 변경 (낙관적 반영, 실패 시 롤백)
  Future<void> reorder(List<Routine> reordered) async {
    _ref.read(routineListProvider.notifier).reorder(reordered);
    try {
      await _repository.updateSortOrder(
        reordered
            .asMap()
            .entries
            .map((e) => RoutineSortOrderItemDto(
                  id: e.value.id,
                  sortOrder: e.key,
                ))
            .toList(),
      );
    } catch (_) {
      _ref.read(routineListProvider.notifier).refresh();
    }
  }

  /// 체크 토글 (낙관적 업데이트, 파생 통계는 invalidate로 재조회)
  Future<bool> toggleCheck(String routineId, bool currentlyChecked) async {
    _ref.read(routineListProvider.notifier).setCheckedToday(
          routineId,
          !currentlyChecked,
        );
    try {
      if (currentlyChecked) {
        await _repository.uncheckRoutine(routineId);
      } else {
        await _repository.checkRoutine(routineId, const CheckRoutineDto());
      }
      _ref.invalidate(routineStreakProvider(routineId));
      _ref.invalidate(routineSummaryProvider);
      return true;
    } catch (e) {
      _ref.read(routineListProvider.notifier).setCheckedToday(
            routineId,
            currentlyChecked,
          );
      return false;
    }
  }

  Future<RoutineShare?> addShare(String routineId, String groupId) async {
    state = const AsyncValue.loading();
    try {
      final share = await _repository.addShare(
        routineId,
        CreateRoutineShareDto(groupId: groupId),
      );
      _ref.read(routineSharesProvider(routineId).notifier).refresh();
      state = const AsyncValue.data(null);
      return share;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<bool> removeShare(String routineId, String groupId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.removeShare(routineId, groupId);
      _ref.read(routineSharesProvider(routineId).notifier).refresh();
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

final routineManagementProvider =
    StateNotifierProvider<RoutineManagementNotifier, AsyncValue<void>>((ref) {
  return RoutineManagementNotifier(
    ref.watch(routineRepositoryProvider),
    ref,
  );
});
