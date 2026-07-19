import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:family_planner/features/main/routine/data/models/routine_model.dart';
import 'package:family_planner/features/main/routine/data/repositories/routine_repository.dart';

part 'routine_provider.g.dart';

/// 체크 토글 결과 (축하 마이크로 인터랙션 판단용)
class RoutineCheckResult {
  final bool success;
  final bool streakIncreased;
  final int? currentStreakDays;
  final List<UserRoutineBadge> newlyEarnedBadges;

  const RoutineCheckResult({
    required this.success,
    this.streakIncreased = false,
    this.currentStreakDays,
    this.newlyEarnedBadges = const [],
  });
}

// ── 루틴 목록 ─────────────────────────────────────────────────────────────────

/// 루틴 목록 화면에서 현재 선택된 날짜 (YYYY-MM-DD, null이면 오늘).
/// RoutineManagementNotifier가 낙관적 업데이트를 적용할 routineListProvider
/// family 인스턴스를 찾을 때 이 값을 함께 사용한다.
final selectedRoutineDateProvider = StateProvider<String?>((ref) => null);

/// 루틴 목록 Provider (ACTIVE+PAUSED, ENDED는 서버에서 항상 제외).
/// [date]는 YYYY-MM-DD 형식의 조회 기준 날짜 (null이면 오늘).
/// 날짜별로 인스턴스가 분리되어 캐시되므로, 이미 조회한 날짜로 돌아오면
/// 재조회 없이 즉시 표시된다.
@riverpod
class RoutineList extends _$RoutineList {
  @override
  Future<List<Routine>> build(String? date) async {
    final repository = ref.watch(routineRepositoryProvider);
    return repository.getRoutines(date: date);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return ref.read(routineRepositoryProvider).getRoutines(date: date);
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

  /// 체크 상태 낙관적 반영. [checkedLog]는 체크 시 낙관적으로 표시할 기록값,
  /// 체크 해제 시에는 null을 전달하면 되고 [checked]가 false면 자동으로
  /// checkedLog도 함께 지워진다.
  void setCheckedToday(
    String routineId,
    bool checked, {
    RoutineCheckedLog? checkedLog,
  }) {
    if (!state.hasValue) return;
    state = AsyncValue.data(
      state.value!
          .map(
            (r) => r.id == routineId
                ? r.copyWith(
                    checkedToday: checked,
                    checkedLog: checked ? checkedLog : null,
                    clearCheckedLog: !checked,
                  )
                : r,
          )
          .toList(),
    );
  }
}

// ── 루틴(습관 묶음) 목록/상세 ─────────────────────────────────────────────────

/// 루틴(습관 묶음) 목록 Provider
@riverpod
class RoutineGroupList extends _$RoutineGroupList {
  @override
  Future<List<RoutineGroup>> build() async {
    final repository = ref.watch(routineRepositoryProvider);
    return repository.getRoutineGroups();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return ref.read(routineRepositoryProvider).getRoutineGroups();
    });
  }

  void upsertGroup(RoutineGroup group) {
    if (!state.hasValue) return;
    final list = state.value!;
    final index = list.indexWhere((g) => g.id == group.id);
    if (index == -1) {
      state = AsyncValue.data([...list, group]);
    } else {
      final updated = [...list];
      updated[index] = group;
      state = AsyncValue.data(updated);
    }
  }

  void removeGroup(String groupId) {
    if (!state.hasValue) return;
    state = AsyncValue.data(
      state.value!.where((g) => g.id != groupId).toList(),
    );
  }

  void reorder(List<RoutineGroup> reordered) {
    if (!state.hasValue) return;
    state = AsyncValue.data(reordered);
  }
}

@riverpod
class RoutineGroupDetailNotifier extends _$RoutineGroupDetailNotifier {
  @override
  Future<RoutineGroupDetail> build(String groupId) async {
    final repository = ref.watch(routineRepositoryProvider);
    return repository.getRoutineGroupDetail(groupId);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return ref.read(routineRepositoryProvider).getRoutineGroupDetail(groupId);
    });
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

/// 특정 그룹원의 공유 루틴 상세 조회
@riverpod
Future<List<Routine>> routineGroupMemberDetail(
  Ref ref,
  String groupId,
  String userId,
) async {
  final repository = ref.watch(routineRepositoryProvider);
  return repository.getGroupMemberDetail(groupId, userId);
}

// ── 대시보드 요약 ─────────────────────────────────────────────────────────────

@riverpod
Future<List<RoutineSummaryItem>> routineSummary(Ref ref) async {
  final repository = ref.watch(routineRepositoryProvider);
  return repository.getSummary();
}

// ── 배지 ──────────────────────────────────────────────────────────────────────

/// 전체 배지 카탈로그 (마스터 데이터)
@riverpod
Future<List<RoutineBadge>> routineBadgeCatalog(Ref ref) async {
  final repository = ref.watch(routineRepositoryProvider);
  return repository.getBadgeCatalog();
}

/// 내가 획득한 통산 배지 목록
@riverpod
Future<List<UserRoutineBadge>> routineMyBadges(Ref ref) async {
  final repository = ref.watch(routineRepositoryProvider);
  return repository.getMyBadges();
}

/// 특정 루틴에서 획득한 배지 목록
@riverpod
Future<List<UserRoutineBadge>> routineBadges(Ref ref, String routineId) async {
  final repository = ref.watch(routineRepositoryProvider);
  return repository.getRoutineBadges(routineId);
}

// ── 랭킹보드 ──────────────────────────────────────────────────────────────────

@riverpod
Future<RoutineLeaderboard> routineLeaderboard(
  Ref ref,
  String groupId, {
  required LeaderboardPeriod period,
  required LeaderboardMetric metric,
}) async {
  final repository = ref.watch(routineRepositoryProvider);
  return repository.getLeaderboard(groupId, period: period, metric: metric);
}

// ── 관리 Notifier ─────────────────────────────────────────────────────────────

/// 루틴 관리 Notifier (생성/수정/삭제/체크/공유)
class RoutineManagementNotifier extends StateNotifier<AsyncValue<void>> {
  final RoutineRepository _repository;
  final Ref _ref;

  RoutineManagementNotifier(this._repository, this._ref)
    : super(const AsyncValue.data(null));

  String? get _selectedDate => _ref.read(selectedRoutineDateProvider);

  Future<Routine?> createRoutine(CreateRoutineDto dto) async {
    state = const AsyncValue.loading();
    try {
      final routine = await _repository.createRoutine(dto);
      _ref
          .read(routineListProvider(_selectedDate).notifier)
          .upsertRoutine(routine);
      if (routine.routineGroupId != null) {
        _ref.invalidate(routineGroupListProvider);
        _ref.invalidate(
          routineGroupDetailNotifierProvider(routine.routineGroupId!),
        );
      }
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
      final existingRoutines = _ref
          .read(routineListProvider(_selectedDate))
          .valueOrNull;
      String? previousGroupId;
      if (existingRoutines != null) {
        for (final r in existingRoutines) {
          if (r.id == id) {
            previousGroupId = r.routineGroupId;
            break;
          }
        }
      }
      final routine = await _repository.updateRoutine(id, dto);
      _ref
          .read(routineListProvider(_selectedDate).notifier)
          .upsertRoutine(routine);
      _ref.read(routineDetailProvider(id).notifier).setRoutine(routine);
      if (dto.routineGroupId != null || dto.clearRoutineGroupId) {
        _ref.invalidate(routineGroupListProvider);
        if (previousGroupId != null) {
          _ref.invalidate(routineGroupDetailNotifierProvider(previousGroupId));
        }
        if (routine.routineGroupId != null) {
          _ref.invalidate(
            routineGroupDetailNotifierProvider(routine.routineGroupId!),
          );
        }
      }
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
      _ref.read(routineListProvider(_selectedDate).notifier).removeRoutine(id);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<Routine?> pauseRoutine(String id) async {
    state = const AsyncValue.loading();
    try {
      final routine = await _repository.pauseRoutine(id);
      _ref
          .read(routineListProvider(_selectedDate).notifier)
          .upsertRoutine(routine);
      _ref.read(routineDetailProvider(id).notifier).setRoutine(routine);
      state = const AsyncValue.data(null);
      return routine;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<Routine?> resumeRoutine(String id) async {
    state = const AsyncValue.loading();
    try {
      final routine = await _repository.resumeRoutine(id);
      _ref
          .read(routineListProvider(_selectedDate).notifier)
          .upsertRoutine(routine);
      _ref.read(routineDetailProvider(id).notifier).setRoutine(routine);
      state = const AsyncValue.data(null);
      return routine;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// 순서 변경 (낙관적 반영, 실패 시 롤백)
  Future<void> reorder(List<Routine> reordered) async {
    _ref.read(routineListProvider(_selectedDate).notifier).reorder(reordered);
    try {
      await _repository.updateSortOrder(
        reordered
            .asMap()
            .entries
            .map(
              (e) => RoutineSortOrderItemDto(id: e.value.id, sortOrder: e.key),
            )
            .toList(),
      );
    } catch (_) {
      _ref.read(routineListProvider(_selectedDate).notifier).refresh();
    }
  }

  /// 체크 토글 (낙관적 업데이트, 파생 통계는 invalidate 후 재조회해 스트릭 갱신 여부 판단)
  Future<RoutineCheckResult> toggleCheck(
    String routineId,
    bool currentlyChecked, {
    String? textValue,
    num? numericValue,
    String? timeValue,
  }) async {
    _ref
        .read(routineListProvider(_selectedDate).notifier)
        .setCheckedToday(
          routineId,
          !currentlyChecked,
          checkedLog: currentlyChecked
              ? null
              : RoutineCheckedLog(
                  textValue: textValue,
                  numericValue: numericValue,
                  timeValue: timeValue,
                ),
        );

    final previousStreak = _ref
        .read(routineStreakProvider(routineId))
        .valueOrNull;

    try {
      var newlyEarnedBadges = const <UserRoutineBadge>[];
      if (currentlyChecked) {
        await _repository.uncheckRoutine(routineId, date: _selectedDate);
      } else {
        final log = await _repository.checkRoutine(
          routineId,
          CheckRoutineDto(
            date: _selectedDate,
            textValue: textValue,
            numericValue: numericValue,
            timeValue: timeValue,
          ),
        );
        newlyEarnedBadges = log.newlyEarnedBadges;
      }
      _ref.invalidate(routineSummaryProvider);
      if (newlyEarnedBadges.isNotEmpty) {
        _ref.invalidate(routineMyBadgesProvider);
        _ref.invalidate(routineBadgesProvider(routineId));
      }

      final checkedRoutines = _ref
          .read(routineListProvider(_selectedDate))
          .valueOrNull;
      String? groupId;
      if (checkedRoutines != null) {
        for (final r in checkedRoutines) {
          if (r.id == routineId) {
            groupId = r.routineGroupId;
            break;
          }
        }
      }
      if (groupId != null) {
        _ref.invalidate(routineGroupListProvider);
        _ref.invalidate(routineGroupDetailNotifierProvider(groupId));
      }

      // 체크(해제 아님) 성공 시에만 스트릭 갱신 여부를 비교해 축하 신호 반환
      var streakIncreased = false;
      int? newStreakDays;
      if (!currentlyChecked) {
        final newStreak = await _ref.refresh(
          routineStreakProvider(routineId).future,
        );
        newStreakDays = newStreak.currentStreakDays;
        streakIncreased =
            previousStreak == null ||
            newStreak.currentStreakDays > previousStreak.currentStreakDays;
      } else {
        _ref.invalidate(routineStreakProvider(routineId));
      }

      return RoutineCheckResult(
        success: true,
        streakIncreased: streakIncreased,
        currentStreakDays: newStreakDays,
        newlyEarnedBadges: newlyEarnedBadges,
      );
    } catch (e) {
      _ref
          .read(routineListProvider(_selectedDate).notifier)
          .setCheckedToday(routineId, currentlyChecked);
      return const RoutineCheckResult(success: false);
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

/// 루틴(습관 묶음) 관리 Notifier (생성/수정/삭제/순서변경)
class RoutineGroupManagementNotifier extends StateNotifier<AsyncValue<void>> {
  final RoutineRepository _repository;
  final Ref _ref;

  RoutineGroupManagementNotifier(this._repository, this._ref)
    : super(const AsyncValue.data(null));

  Future<RoutineGroup?> createRoutineGroup(CreateRoutineGroupDto dto) async {
    state = const AsyncValue.loading();
    try {
      final group = await _repository.createRoutineGroup(dto);
      _ref.read(routineGroupListProvider.notifier).upsertGroup(group);
      state = const AsyncValue.data(null);
      return group;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<RoutineGroup?> updateRoutineGroup(
    String id,
    UpdateRoutineGroupDto dto,
  ) async {
    state = const AsyncValue.loading();
    try {
      final group = await _repository.updateRoutineGroup(id, dto);
      _ref.read(routineGroupListProvider.notifier).upsertGroup(group);
      _ref.invalidate(routineGroupDetailNotifierProvider(id));
      state = const AsyncValue.data(null);
      return group;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// 그룹 삭제. 소속 습관은 백엔드에서 그룹 소속만 해제되어 유지되므로
  /// 습관 목록도 함께 refresh해 독립 습관 섹션으로 옮겨진 상태를 반영한다.
  Future<bool> deleteRoutineGroup(String id) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteRoutineGroup(id);
      _ref.read(routineGroupListProvider.notifier).removeGroup(id);
      await _ref
          .read(
            routineListProvider(
              _ref.read(selectedRoutineDateProvider),
            ).notifier,
          )
          .refresh();
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// 그룹 순서 변경 (낙관적 반영, 실패 시 롤백)
  Future<void> reorderGroups(List<RoutineGroup> reordered) async {
    _ref.read(routineGroupListProvider.notifier).reorder(reordered);
    try {
      await _repository.updateRoutineGroupSortOrder(
        reordered
            .asMap()
            .entries
            .map(
              (e) => RoutineGroupSortOrderItemDto(
                id: e.value.id,
                sortOrder: e.key,
              ),
            )
            .toList(),
      );
    } catch (_) {
      _ref.read(routineGroupListProvider.notifier).refresh();
    }
  }
}

final routineGroupManagementProvider =
    StateNotifierProvider<RoutineGroupManagementNotifier, AsyncValue<void>>((
      ref,
    ) {
      return RoutineGroupManagementNotifier(
        ref.watch(routineRepositoryProvider),
        ref,
      );
    });

// ── 루틴 카테고리 ─────────────────────────────────────────────────────────────

/// 루틴 카테고리 목록 Provider
@riverpod
class RoutineCategoryList extends _$RoutineCategoryList {
  @override
  Future<List<RoutineCategory>> build() async {
    final repository = ref.watch(routineRepositoryProvider);
    return repository.getRoutineCategories();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return ref.read(routineRepositoryProvider).getRoutineCategories();
    });
  }

  void upsertCategory(RoutineCategory category) {
    if (!state.hasValue) return;
    final list = state.value!;
    final index = list.indexWhere((c) => c.id == category.id);
    if (index == -1) {
      state = AsyncValue.data([...list, category]);
    } else {
      final updated = [...list];
      updated[index] = category;
      state = AsyncValue.data(updated);
    }
  }

  void removeCategory(String categoryId) {
    if (!state.hasValue) return;
    state = AsyncValue.data(
      state.value!.where((c) => c.id != categoryId).toList(),
    );
  }

  void reorder(List<RoutineCategory> reordered) {
    if (!state.hasValue) return;
    state = AsyncValue.data(reordered);
  }
}

/// 루틴 카테고리 관리 Notifier (생성/수정/삭제/순서변경)
class RoutineCategoryManagementNotifier
    extends StateNotifier<AsyncValue<void>> {
  final RoutineRepository _repository;
  final Ref _ref;

  RoutineCategoryManagementNotifier(this._repository, this._ref)
    : super(const AsyncValue.data(null));

  Future<RoutineCategory?> createRoutineCategory(
    CreateRoutineCategoryDto dto,
  ) async {
    state = const AsyncValue.loading();
    try {
      final category = await _repository.createRoutineCategory(dto);
      _ref.read(routineCategoryListProvider.notifier).upsertCategory(category);
      state = const AsyncValue.data(null);
      return category;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<RoutineCategory?> updateRoutineCategory(
    String id,
    UpdateRoutineCategoryDto dto,
  ) async {
    state = const AsyncValue.loading();
    try {
      final category = await _repository.updateRoutineCategory(id, dto);
      _ref.read(routineCategoryListProvider.notifier).upsertCategory(category);
      state = const AsyncValue.data(null);
      return category;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// 카테고리 삭제. 소속 습관은 백엔드에서 categoryId만 해제되어 유지되므로
  /// 습관 목록도 함께 refresh한다.
  Future<bool> deleteRoutineCategory(String id) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteRoutineCategory(id);
      _ref.read(routineCategoryListProvider.notifier).removeCategory(id);
      await _ref
          .read(
            routineListProvider(
              _ref.read(selectedRoutineDateProvider),
            ).notifier,
          )
          .refresh();
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<void> reorderCategories(List<RoutineCategory> reordered) async {
    _ref.read(routineCategoryListProvider.notifier).reorder(reordered);
    try {
      await _repository.updateRoutineCategorySortOrder(
        reordered
            .asMap()
            .entries
            .map(
              (e) => RoutineCategorySortOrderItemDto(
                id: e.value.id,
                sortOrder: e.key,
              ),
            )
            .toList(),
      );
    } catch (_) {
      _ref.read(routineCategoryListProvider.notifier).refresh();
    }
  }
}

final routineCategoryManagementProvider =
    StateNotifierProvider<RoutineCategoryManagementNotifier, AsyncValue<void>>((
      ref,
    ) {
      return RoutineCategoryManagementNotifier(
        ref.watch(routineRepositoryProvider),
        ref,
      );
    });
