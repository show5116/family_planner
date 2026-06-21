import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/features/main/task/data/models/anniversary_model.dart';
import 'package:family_planner/features/main/task/data/repositories/anniversary_repository.dart';
import 'package:family_planner/features/main/task/providers/task_provider.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';

/// 그룹별 기념일 목록 Provider
final anniversariesProvider =
    FutureProvider.family<List<AnniversaryModel>, String>((ref, groupId) async {
  final repository = ref.watch(anniversaryRepositoryProvider);
  return repository.getAnniversaries(groupId);
});

/// 기념일 관리 Notifier
class AnniversaryManagementNotifier
    extends StateNotifier<AsyncValue<List<AnniversaryModel>>> {
  final AnniversaryRepository _repository;
  final Ref _ref;
  final String groupId;

  AnniversaryManagementNotifier(this._repository, this._ref, this.groupId)
      : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getAnniversaries(groupId));
  }

  Future<void> refresh() => _load();

  Future<AnniversaryModel?> create({
    required String title,
    required DateTime date,
    String? emoji,
    MilestoneConfig? milestoneConfig,
  }) async {
    try {
      final item = await _repository.createAnniversary(
        groupId: groupId,
        title: title,
        date: date,
        emoji: emoji,
        milestoneConfig: milestoneConfig,
      );
      if (state.hasValue) {
        state = AsyncValue.data([...state.value!, item]);
      }
      _ref.invalidate(anniversariesProvider(groupId));
      _ref.invalidate(monthlyTasksProvider);
      return item;
    } catch (_) {
      return null;
    }
  }

  Future<AnniversaryModel?> update(
    String id, {
    String? title,
    DateTime? date,
    String? emoji,
    MilestoneConfig? milestoneConfig,
  }) async {
    try {
      final item = await _repository.updateAnniversary(
        id,
        title: title,
        date: date,
        emoji: emoji,
        milestoneConfig: milestoneConfig,
      );
      if (state.hasValue) {
        final list = state.value!.map((a) => a.id == id ? item : a).toList();
        state = AsyncValue.data(list);
      }
      _ref.invalidate(anniversariesProvider(groupId));
      _ref.invalidate(monthlyTasksProvider);
      return item;
    } catch (_) {
      return null;
    }
  }

  Future<bool> delete(String id, {bool deleteWithTasks = false}) async {
    try {
      await _repository.deleteAnniversary(id, deleteWithTasks: deleteWithTasks);
      if (state.hasValue) {
        state = AsyncValue.data(
          state.value!.where((a) => a.id != id).toList(),
        );
      }
      _ref.invalidate(anniversariesProvider(groupId));
      _ref.invalidate(monthlyTasksProvider);
      return true;
    } catch (_) {
      return false;
    }
  }
}

/// 기념일 관리 Provider (groupId 파라미터)
final anniversaryManagementProvider = StateNotifierProvider.family<
    AnniversaryManagementNotifier,
    AsyncValue<List<AnniversaryModel>>,
    String>((ref, groupId) {
  final repository = ref.watch(anniversaryRepositoryProvider);
  return AnniversaryManagementNotifier(repository, ref, groupId);
});

/// 내가 속한 모든 그룹의 기념일 목록 (캘린더 표시용)
final allGroupsAnniversariesProvider =
    FutureProvider<List<AnniversaryModel>>((ref) async {
  final groups = ref.watch(myGroupsProvider).valueOrNull ?? [];
  final repository = ref.watch(anniversaryRepositoryProvider);

  final results = await Future.wait(
    groups.map((g) => repository.getAnniversaries(g.id)),
  );
  return results.expand<AnniversaryModel>((list) => list).toList();
});
