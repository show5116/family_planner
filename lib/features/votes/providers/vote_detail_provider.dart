import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:family_planner/features/votes/data/models/vote_model.dart';
import 'package:family_planner/features/votes/data/repositories/vote_repository.dart';
import 'package:family_planner/features/votes/providers/vote_list_provider.dart';

part 'vote_detail_provider.g.dart';

// ── 상세 Provider ─────────────────────────────────────────────────────────────

@riverpod
class VoteDetail extends _$VoteDetail {
  @override
  Future<VoteModel> build({
    required String groupId,
    required String voteId,
  }) async {
    return ref.watch(voteRepositoryProvider).getVote(
          groupId: groupId,
          voteId: voteId,
        );
  }

  /// 투표 결과로 상태 업데이트 (투표/취소 후 서버 응답 반영)
  void applyUpdate(VoteModel vote) {
    state = AsyncValue.data(vote);
    // 목록에도 반영
    ref.read(voteListProvider.notifier).updateVote(vote);
  }
}

// ── 투표 참여/취소 Notifier ────────────────────────────────────────────────────

class VoteBallotNotifier extends StateNotifier<AsyncValue<void>> {
  final VoteRepository _repository;
  final Ref _ref;

  VoteBallotNotifier(this._repository, this._ref)
      : super(const AsyncValue.data(null));

  Future<bool> castBallot({
    required String groupId,
    required String voteId,
    required List<String> optionIds,
  }) async {
    state = const AsyncValue.loading();
    try {
      final updated = await _repository.castBallot(
        groupId: groupId,
        voteId: voteId,
        dto: CastBallotDto(optionIds: optionIds),
      );
      _ref
          .read(voteDetailProvider(groupId: groupId, voteId: voteId).notifier)
          .applyUpdate(updated);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  Future<bool> cancelBallot({
    required String groupId,
    required String voteId,
  }) async {
    state = const AsyncValue.loading();
    try {
      final updated = await _repository.cancelBallot(
        groupId: groupId,
        voteId: voteId,
      );
      _ref
          .read(voteDetailProvider(groupId: groupId, voteId: voteId).notifier)
          .applyUpdate(updated);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

final voteBallotProvider =
    StateNotifierProvider<VoteBallotNotifier, AsyncValue<void>>((ref) {
  return VoteBallotNotifier(ref.watch(voteRepositoryProvider), ref);
});
