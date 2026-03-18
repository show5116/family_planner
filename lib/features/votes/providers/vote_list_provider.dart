import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:family_planner/features/votes/data/models/vote_model.dart';
import 'package:family_planner/features/votes/data/repositories/vote_repository.dart';

part 'vote_list_provider.g.dart';

/// 현재 선택된 그룹 ID (투표용)
final voteSelectedGroupIdProvider = StateProvider<String?>((ref) => null);

/// 투표 상태 필터
final voteStatusFilterProvider =
    StateProvider<VoteStatusFilter>((ref) => VoteStatusFilter.all);

// ── 목록 Provider ─────────────────────────────────────────────────────────────

@riverpod
class VoteList extends _$VoteList {
  static const int _pageSize = 20;

  @override
  Future<List<VoteModel>> build() async {
    final groupId = ref.watch(voteSelectedGroupIdProvider);
    if (groupId == null) return [];

    final status = ref.watch(voteStatusFilterProvider);
    final response = await ref.watch(voteRepositoryProvider).getVotes(
          groupId: groupId,
          status: status,
          limit: _pageSize,
        );
    return response.items;
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final groupId = ref.read(voteSelectedGroupIdProvider);
      if (groupId == null) return <VoteModel>[];
      final status = ref.read(voteStatusFilterProvider);
      final response = await ref.read(voteRepositoryProvider).getVotes(
            groupId: groupId,
            status: status,
            limit: _pageSize,
          );
      return response.items;
    });
  }

  void addVote(VoteModel vote) {
    if (!state.hasValue) return;
    state = AsyncValue.data([vote, ...state.value!]);
  }

  void updateVote(VoteModel vote) {
    if (!state.hasValue) return;
    state = AsyncValue.data([
      for (final v in state.value!)
        if (v.id == vote.id) vote else v,
    ]);
  }

  void removeVote(String id) {
    if (!state.hasValue) return;
    state = AsyncValue.data(state.value!.where((v) => v.id != id).toList());
  }
}

// ── 투표 생성/삭제 Notifier ────────────────────────────────────────────────────

class VoteManagementNotifier extends StateNotifier<AsyncValue<void>> {
  final VoteRepository _repository;
  final Ref _ref;

  VoteManagementNotifier(this._repository, this._ref)
      : super(const AsyncValue.data(null));

  Future<VoteModel?> createVote({
    required String groupId,
    required CreateVoteDto dto,
  }) async {
    state = const AsyncValue.loading();
    try {
      final vote = await _repository.createVote(groupId: groupId, dto: dto);
      _ref.read(voteListProvider.notifier).addVote(vote);
      state = const AsyncValue.data(null);
      return vote;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<bool> deleteVote({
    required String groupId,
    required String voteId,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteVote(groupId: groupId, voteId: voteId);
      _ref.read(voteListProvider.notifier).removeVote(voteId);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

final voteManagementProvider =
    StateNotifierProvider<VoteManagementNotifier, AsyncValue<void>>((ref) {
  return VoteManagementNotifier(ref.watch(voteRepositoryProvider), ref);
});
