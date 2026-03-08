import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/services/api_client.dart';
import 'package:family_planner/features/minigame/data/models/minigame_model.dart';

// ─── DTOs ────────────────────────────────────────────────────────────────────

/// 게임 결과 저장 DTO
class SaveMinigameResultDto {
  final String groupId;
  final MinigameType gameType;
  final String title;
  final List<String> participants;
  final List<String> options;
  final Map<String, dynamic> result;

  const SaveMinigameResultDto({
    required this.groupId,
    required this.gameType,
    required this.title,
    required this.participants,
    required this.options,
    required this.result,
  });

  Map<String, dynamic> toJson() => {
        'groupId': groupId,
        'gameType': minigameTypeToString(gameType),
        'title': title,
        'participants': participants,
        'options': options,
        'result': result,
      };
}

// ─── Repository ──────────────────────────────────────────────────────────────

final minigameRepositoryProvider = Provider<MinigameRepository>(
  (ref) => MinigameRepository(),
);

class MinigameRepository {
  final Dio _dio = ApiClient.instance.dio;

  /// 게임 결과 저장
  Future<MinigameResult> saveResult(SaveMinigameResultDto dto) async {
    try {
      final response = await _dio.post('/minigames/results', data: dto.toJson());
      return MinigameResult.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [MinigameRepository] 결과 저장 실패: ${e.message}');
      throw Exception('결과 저장 실패: ${e.message}');
    }
  }

  /// 그룹 게임 이력 조회
  Future<MinigameResultsResponse> getResults({
    required String groupId,
    MinigameType? gameType,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await _dio.get(
        '/minigames/results',
        queryParameters: {
          'groupId': groupId,
          if (gameType != null) 'gameType': minigameTypeToString(gameType),
          'limit': limit,
          'offset': offset,
        },
      );
      return MinigameResultsResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      debugPrint('❌ [MinigameRepository] 이력 조회 실패: ${e.message}');
      throw Exception('이력 조회 실패: ${e.message}');
    }
  }

  /// 게임 이력 삭제
  Future<void> deleteResult(String id) async {
    try {
      await _dio.delete('/minigames/results/$id');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('게임 이력을 찾을 수 없습니다');
      }
      if (e.response?.statusCode == 403) {
        throw Exception('본인 또는 그룹 관리자만 삭제할 수 있습니다');
      }
      throw Exception('이력 삭제 실패: ${e.message}');
    }
  }
}
