import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/services/api_client.dart';
import 'package:family_planner/features/main/routine/data/models/routine_model.dart';

// ─── DTOs ───────────────────────────────────────────────────────────────────

/// 습관 생성 DTO
class CreateRoutineDto {
  final String title;
  final String? emoji;
  final String? color;
  final RoutineFrequencyType? frequencyType;
  final int? targetCount;
  final String startDate; // YYYY-MM-DD
  final String? endDate; // YYYY-MM-DD
  final String? routineGroupId; // 소속시킬 루틴 ID (없으면 독립 습관)

  const CreateRoutineDto({
    required this.title,
    this.emoji,
    this.color,
    this.frequencyType,
    this.targetCount,
    required this.startDate,
    this.endDate,
    this.routineGroupId,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        if (emoji != null) 'emoji': emoji,
        if (color != null) 'color': color,
        if (frequencyType != null)
          'frequencyType': frequencyType!.toJsonString(),
        if (targetCount != null) 'targetCount': targetCount,
        'startDate': startDate,
        if (endDate != null) 'endDate': endDate,
        if (routineGroupId != null) 'routineGroupId': routineGroupId,
      };
}

/// 습관 수정 DTO (부분 업데이트)
class UpdateRoutineDto {
  final String? title;
  final String? emoji;
  final String? color;
  final int? targetCount;
  final String? endDate;
  final bool? isActive;
  final String? routineGroupId;

  /// routineGroupId를 명시적으로 null 전달(그룹 소속 해제)할지 여부.
  /// false면 routineGroupId 필드 자체를 요청에서 생략(미변경).
  final bool clearRoutineGroupId;

  const UpdateRoutineDto({
    this.title,
    this.emoji,
    this.color,
    this.targetCount,
    this.endDate,
    this.isActive,
    this.routineGroupId,
    this.clearRoutineGroupId = false,
  });

  Map<String, dynamic> toJson() => {
        if (title != null) 'title': title,
        if (emoji != null) 'emoji': emoji,
        if (color != null) 'color': color,
        if (targetCount != null) 'targetCount': targetCount,
        if (endDate != null) 'endDate': endDate,
        if (isActive != null) 'isActive': isActive,
        if (routineGroupId != null) 'routineGroupId': routineGroupId,
        if (clearRoutineGroupId && routineGroupId == null)
          'routineGroupId': null,
      };
}

/// 루틴 체크 DTO
class CheckRoutineDto {
  final String? date; // YYYY-MM-DD, 미지정 시 오늘
  final String? note;

  const CheckRoutineDto({this.date, this.note});

  Map<String, dynamic> toJson() => {
        if (date != null) 'date': date,
        if (note != null) 'note': note,
      };
}

/// 순서 변경 항목 DTO
class RoutineSortOrderItemDto {
  final String id;
  final int sortOrder;

  const RoutineSortOrderItemDto({required this.id, required this.sortOrder});

  Map<String, dynamic> toJson() => {'id': id, 'sortOrder': sortOrder};
}

/// 그룹 공유 추가 DTO
class CreateRoutineShareDto {
  final String groupId;

  const CreateRoutineShareDto({required this.groupId});

  Map<String, dynamic> toJson() => {'groupId': groupId};
}

/// 루틴(습관 묶음) 생성 DTO
class CreateRoutineGroupDto {
  final String title;
  final String? emoji;
  final String? color;

  const CreateRoutineGroupDto({required this.title, this.emoji, this.color});

  Map<String, dynamic> toJson() => {
        'title': title,
        if (emoji != null) 'emoji': emoji,
        if (color != null) 'color': color,
      };
}

/// 루틴(습관 묶음) 수정 DTO (부분 업데이트)
class UpdateRoutineGroupDto {
  final String? title;
  final String? emoji;
  final String? color;

  const UpdateRoutineGroupDto({this.title, this.emoji, this.color});

  Map<String, dynamic> toJson() => {
        if (title != null) 'title': title,
        if (emoji != null) 'emoji': emoji,
        if (color != null) 'color': color,
      };
}

/// 루틴(습관 묶음) 순서 변경 항목 DTO
class RoutineGroupSortOrderItemDto {
  final String id;
  final int sortOrder;

  const RoutineGroupSortOrderItemDto({
    required this.id,
    required this.sortOrder,
  });

  Map<String, dynamic> toJson() => {'id': id, 'sortOrder': sortOrder};
}

// ─── Repository ─────────────────────────────────────────────────────────────

final routineRepositoryProvider = Provider<RoutineRepository>((ref) {
  return RoutineRepository();
});

class RoutineRepository {
  final Dio _dio = ApiClient.instance.dio;

  RoutineRepository();

  // ── 루틴 기본 CRUD ────────────────────────────────────────────────────────

  Future<Routine> createRoutine(CreateRoutineDto dto) async {
    try {
      final response = await _dio.post('/routines', data: dto.toJson());
      return Routine.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [RoutineRepository] 루틴 생성 실패: ${e.message}');
      throw Exception('루틴 생성 실패: ${e.message}');
    }
  }

  Future<List<Routine>> getRoutines({bool? isActive}) async {
    try {
      final response = await _dio.get(
        '/routines',
        queryParameters: {if (isActive != null) 'isActive': isActive},
      );
      final data = response.data;
      if (data is List) {
        return data
            .map((e) => Routine.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      debugPrint('❌ [RoutineRepository] 루틴 목록 조회 실패: ${e.message}');
      throw Exception('루틴 목록 조회 실패: ${e.message}');
    }
  }

  Future<Routine> getRoutine(String id) async {
    try {
      final response = await _dio.get('/routines/$id');
      return Routine.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [RoutineRepository] 루틴 상세 조회 실패: ${e.message}');
      throw Exception('루틴 상세 조회 실패: ${e.message}');
    }
  }

  Future<Routine> updateRoutine(String id, UpdateRoutineDto dto) async {
    try {
      final response = await _dio.patch('/routines/$id', data: dto.toJson());
      return Routine.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [RoutineRepository] 루틴 수정 실패: ${e.message}');
      throw Exception('루틴 수정 실패: ${e.message}');
    }
  }

  Future<void> deleteRoutine(String id) async {
    try {
      await _dio.delete('/routines/$id');
    } on DioException catch (e) {
      debugPrint('❌ [RoutineRepository] 루틴 삭제 실패: ${e.message}');
      throw Exception('루틴 삭제 실패: ${e.message}');
    }
  }

  /// 순서 일괄 변경. 응답 형태(단일/배열)가 불확실하므로 방어적으로 처리하고
  /// 호출부는 반환값을 신뢰하지 않고 목록을 refresh하는 것을 권장.
  Future<void> updateSortOrder(List<RoutineSortOrderItemDto> items) async {
    try {
      await _dio.patch(
        '/routines/sort-order',
        data: {'items': items.map((e) => e.toJson()).toList()},
      );
    } on DioException catch (e) {
      debugPrint('❌ [RoutineRepository] 순서 변경 실패: ${e.message}');
      throw Exception('순서 변경 실패: ${e.message}');
    }
  }

  // ── 체크 ──────────────────────────────────────────────────────────────────

  Future<RoutineLog> checkRoutine(String id, CheckRoutineDto dto) async {
    try {
      final response =
          await _dio.post('/routines/$id/check', data: dto.toJson());
      return RoutineLog.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [RoutineRepository] 루틴 체크 실패: ${e.message}');
      rethrow;
    }
  }

  Future<void> uncheckRoutine(String id, {String? date}) async {
    try {
      await _dio.delete(
        '/routines/$id/check',
        queryParameters: {if (date != null) 'date': date},
      );
    } on DioException catch (e) {
      debugPrint('❌ [RoutineRepository] 루틴 체크 취소 실패: ${e.message}');
      rethrow;
    }
  }

  // ── 그룹 공유 ─────────────────────────────────────────────────────────────

  Future<RoutineShare> addShare(String id, CreateRoutineShareDto dto) async {
    try {
      final response =
          await _dio.post('/routines/$id/shares', data: dto.toJson());
      return RoutineShare.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [RoutineRepository] 그룹 공유 추가 실패: ${e.message}');
      throw Exception('그룹 공유 추가 실패: ${e.message}');
    }
  }

  Future<void> removeShare(String id, String groupId) async {
    try {
      await _dio.delete('/routines/$id/shares/$groupId');
    } on DioException catch (e) {
      debugPrint('❌ [RoutineRepository] 그룹 공유 해제 실패: ${e.message}');
      throw Exception('그룹 공유 해제 실패: ${e.message}');
    }
  }

  Future<List<RoutineShare>> getShares(String id) async {
    try {
      final response = await _dio.get('/routines/$id/shares');
      final data = response.data;
      if (data is List) {
        return data
            .map((e) => RoutineShare.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      debugPrint('❌ [RoutineRepository] 공유 그룹 목록 조회 실패: ${e.message}');
      throw Exception('공유 그룹 목록 조회 실패: ${e.message}');
    }
  }

  Future<List<RoutineGroupMemberRoutines>> getGroupMembers(
    String groupId,
  ) async {
    try {
      final response = await _dio.get('/routines/groups/$groupId/members');
      final data = response.data;
      if (data is List) {
        return data
            .map((e) => RoutineGroupMemberRoutines.fromJson(
                  e as Map<String, dynamic>,
                ))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      debugPrint('❌ [RoutineRepository] 그룹원 루틴 조회 실패: ${e.message}');
      throw Exception('그룹원 루틴 조회 실패: ${e.message}');
    }
  }

  Future<List<Routine>> getGroupMemberDetail(
    String groupId,
    String userId,
  ) async {
    try {
      final response =
          await _dio.get('/routines/groups/$groupId/members/$userId');
      final data = response.data;
      if (data is List) {
        return data
            .map((e) => Routine.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      debugPrint('❌ [RoutineRepository] 그룹원 루틴 상세 조회 실패: ${e.message}');
      throw Exception('그룹원 루틴 상세 조회 실패: ${e.message}');
    }
  }

  // ── 통계 ──────────────────────────────────────────────────────────────────

  Future<RoutineHeatmap> getHeatmap(
    String id, {
    required String from,
    required String to,
  }) async {
    try {
      final response = await _dio.get(
        '/routines/$id/stats/heatmap',
        queryParameters: {'from': from, 'to': to},
      );
      return RoutineHeatmap.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [RoutineRepository] 히트맵 조회 실패: ${e.message}');
      throw Exception('히트맵 조회 실패: ${e.message}');
    }
  }

  Future<RoutineStreak> getStreak(String id) async {
    try {
      final response = await _dio.get('/routines/$id/stats/streak');
      return RoutineStreak.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [RoutineRepository] 스트릭 조회 실패: ${e.message}');
      throw Exception('스트릭 조회 실패: ${e.message}');
    }
  }

  Future<RoutineRate> getRate(
    String id, {
    required RoutineRatePeriod period,
    String? from,
    String? to,
  }) async {
    try {
      final response = await _dio.get(
        '/routines/$id/stats/rate',
        queryParameters: {
          'period': period.toJsonString(),
          if (from != null) 'from': from,
          if (to != null) 'to': to,
        },
      );
      return RoutineRate.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [RoutineRepository] 달성률 조회 실패: ${e.message}');
      throw Exception('달성률 조회 실패: ${e.message}');
    }
  }

  Future<List<RoutineSummaryItem>> getSummary() async {
    try {
      final response = await _dio.get('/routines/stats/summary');
      final data = response.data as Map<String, dynamic>;
      final routines = data['routines'] as List<dynamic>? ?? [];
      return routines
          .map((e) => RoutineSummaryItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      debugPrint('❌ [RoutineRepository] 루틴 요약 조회 실패: ${e.message}');
      throw Exception('루틴 요약 조회 실패: ${e.message}');
    }
  }

  // ── 배지 ──────────────────────────────────────────────────────────────────

  Future<List<RoutineBadge>> getBadgeCatalog() async {
    try {
      final response = await _dio.get('/routines/badges');
      final data = response.data;
      if (data is List) {
        return data
            .map((e) => RoutineBadge.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      debugPrint('❌ [RoutineRepository] 배지 카탈로그 조회 실패: ${e.message}');
      throw Exception('배지 카탈로그 조회 실패: ${e.message}');
    }
  }

  Future<List<UserRoutineBadge>> getMyBadges() async {
    try {
      final response = await _dio.get('/routines/me/badges');
      final data = response.data;
      if (data is List) {
        return data
            .map((e) => UserRoutineBadge.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      debugPrint('❌ [RoutineRepository] 내 배지 목록 조회 실패: ${e.message}');
      throw Exception('내 배지 목록 조회 실패: ${e.message}');
    }
  }

  Future<List<UserRoutineBadge>> getRoutineBadges(String id) async {
    try {
      final response = await _dio.get('/routines/$id/badges');
      final data = response.data;
      if (data is List) {
        return data
            .map((e) => UserRoutineBadge.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      debugPrint('❌ [RoutineRepository] 루틴별 배지 조회 실패: ${e.message}');
      throw Exception('루틴별 배지 조회 실패: ${e.message}');
    }
  }

  // ── 루틴(습관 묶음) ───────────────────────────────────────────────────────

  Future<RoutineGroup> createRoutineGroup(CreateRoutineGroupDto dto) async {
    try {
      final response = await _dio.post(
        '/routines/routine-groups',
        data: dto.toJson(),
      );
      return RoutineGroup.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [RoutineRepository] 루틴 생성 실패: ${e.message}');
      throw Exception('루틴 생성 실패: ${e.message}');
    }
  }

  Future<List<RoutineGroup>> getRoutineGroups() async {
    try {
      final response = await _dio.get('/routines/routine-groups');
      final data = response.data;
      if (data is List) {
        return data
            .map((e) => RoutineGroup.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      debugPrint('❌ [RoutineRepository] 루틴 목록 조회 실패: ${e.message}');
      throw Exception('루틴 목록 조회 실패: ${e.message}');
    }
  }

  Future<void> updateRoutineGroupSortOrder(
    List<RoutineGroupSortOrderItemDto> items,
  ) async {
    try {
      await _dio.patch(
        '/routines/routine-groups/sort-order',
        data: {'items': items.map((e) => e.toJson()).toList()},
      );
    } on DioException catch (e) {
      debugPrint('❌ [RoutineRepository] 루틴 순서 변경 실패: ${e.message}');
      throw Exception('루틴 순서 변경 실패: ${e.message}');
    }
  }

  Future<RoutineGroupDetail> getRoutineGroupDetail(String id) async {
    try {
      final response = await _dio.get('/routines/routine-groups/$id');
      return RoutineGroupDetail.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      debugPrint('❌ [RoutineRepository] 루틴 상세 조회 실패: ${e.message}');
      throw Exception('루틴 상세 조회 실패: ${e.message}');
    }
  }

  Future<RoutineGroup> updateRoutineGroup(
    String id,
    UpdateRoutineGroupDto dto,
  ) async {
    try {
      final response = await _dio.patch(
        '/routines/routine-groups/$id',
        data: dto.toJson(),
      );
      return RoutineGroup.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [RoutineRepository] 루틴 수정 실패: ${e.message}');
      throw Exception('루틴 수정 실패: ${e.message}');
    }
  }

  Future<void> deleteRoutineGroup(String id) async {
    try {
      await _dio.delete('/routines/routine-groups/$id');
    } on DioException catch (e) {
      debugPrint('❌ [RoutineRepository] 루틴 삭제 실패: ${e.message}');
      throw Exception('루틴 삭제 실패: ${e.message}');
    }
  }

  // ── 랭킹보드 ──────────────────────────────────────────────────────────────

  Future<RoutineLeaderboard> getLeaderboard(
    String groupId, {
    required LeaderboardPeriod period,
    required LeaderboardMetric metric,
  }) async {
    try {
      final response = await _dio.get(
        '/routines/groups/$groupId/leaderboard',
        queryParameters: {
          'period': period.toJsonString(),
          'metric': metric.toJsonString(),
        },
      );
      return RoutineLeaderboard.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [RoutineRepository] 랭킹보드 조회 실패: ${e.message}');
      throw Exception('랭킹보드 조회 실패: ${e.message}');
    }
  }
}
