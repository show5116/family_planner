import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/services/api_client.dart';
import 'package:family_planner/features/votes/data/models/vote_model.dart';

// ─── DTOs ─────────────────────────────────────────────────────────────────────

class CreateVoteDto {
  final String title;
  final String? description;
  final bool isMultiple;
  final bool isAnonymous;
  final String? endsAt; // ISO 8601
  final List<String> options;

  const CreateVoteDto({
    required this.title,
    this.description,
    this.isMultiple = false,
    this.isAnonymous = false,
    this.endsAt,
    required this.options,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        if (description != null) 'description': description,
        'isMultiple': isMultiple,
        'isAnonymous': isAnonymous,
        if (endsAt != null) 'endsAt': endsAt,
        'options': options,
      };
}

class CastBallotDto {
  final List<String> optionIds;

  const CastBallotDto({required this.optionIds});

  Map<String, dynamic> toJson() => {'optionIds': optionIds};
}

// ─── Repository ───────────────────────────────────────────────────────────────

final voteRepositoryProvider = Provider<VoteRepository>(
  (ref) => VoteRepository(),
);

class VoteRepository {
  final Dio _dio = ApiClient.instance.dio;

  /// 투표 목록 조회
  Future<VoteListResponse> getVotes({
    required String groupId,
    VoteStatusFilter status = VoteStatusFilter.all,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        '/votes/$groupId',
        queryParameters: {
          if (status != VoteStatusFilter.all)
            'status': voteStatusFilterToString(status),
          'page': page,
          'limit': limit,
        },
      );
      return VoteListResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [VoteRepository] 목록 조회 실패: ${e.message}');
      throw Exception('투표 목록 조회 실패: ${e.message}');
    }
  }

  /// 투표 상세 조회
  Future<VoteModel> getVote({
    required String groupId,
    required String voteId,
  }) async {
    try {
      final response = await _dio.get('/votes/$groupId/$voteId');
      return VoteModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('투표를 찾을 수 없습니다');
      }
      debugPrint('❌ [VoteRepository] 상세 조회 실패: ${e.message}');
      throw Exception('투표 상세 조회 실패: ${e.message}');
    }
  }

  /// 투표 생성
  Future<VoteModel> createVote({
    required String groupId,
    required CreateVoteDto dto,
  }) async {
    try {
      final response = await _dio.post(
        '/votes/$groupId',
        data: dto.toJson(),
      );
      return VoteModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [VoteRepository] 생성 실패: ${e.message}');
      throw Exception('투표 생성 실패: ${e.message}');
    }
  }

  /// 투표 삭제
  Future<void> deleteVote({
    required String groupId,
    required String voteId,
  }) async {
    try {
      await _dio.delete('/votes/$groupId/$voteId');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('투표를 찾을 수 없습니다');
      }
      if (e.response?.statusCode == 403) {
        throw Exception('작성자 또는 그룹 관리자만 삭제할 수 있습니다');
      }
      debugPrint('❌ [VoteRepository] 삭제 실패: ${e.message}');
      throw Exception('투표 삭제 실패: ${e.message}');
    }
  }

  /// 투표 참여
  Future<VoteModel> castBallot({
    required String groupId,
    required String voteId,
    required CastBallotDto dto,
  }) async {
    try {
      final response = await _dio.post(
        '/votes/$groupId/$voteId/ballots',
        data: dto.toJson(),
      );
      return VoteModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('투표를 찾을 수 없습니다');
      }
      debugPrint('❌ [VoteRepository] 투표 참여 실패: ${e.message}');
      throw Exception('투표 참여 실패: ${e.message}');
    }
  }

  /// 투표 취소
  Future<VoteModel> cancelBallot({
    required String groupId,
    required String voteId,
  }) async {
    try {
      final response = await _dio.delete('/votes/$groupId/$voteId/ballots');
      return VoteModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('투표를 찾을 수 없습니다');
      }
      debugPrint('❌ [VoteRepository] 투표 취소 실패: ${e.message}');
      throw Exception('투표 취소 실패: ${e.message}');
    }
  }
}
