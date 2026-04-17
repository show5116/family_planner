import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/services/api_client.dart';
import 'package:family_planner/features/memo/data/models/memo_model.dart';
import 'package:family_planner/features/memo/data/dto/memo_dto.dart';

/// 메모 Repository Provider
final memoRepositoryProvider = Provider<MemoRepository>((ref) {
  return MemoRepository();
});

/// 메모 Repository
class MemoRepository {
  final Dio _dio = ApiClient.instance.dio;

  MemoRepository();

  /// 메모 목록 조회
  Future<MemoListResponse> getMemos({
    int page = 1,
    int limit = 20,
    String? visibility,
    String? groupId,
    String? tag,
    String? search,
  }) async {
    try {
      final response = await _dio.get('/memos', queryParameters: {
        'page': page,
        'limit': limit,
        if (visibility != null && visibility.isNotEmpty) 'visibility': visibility,
        if (groupId != null && groupId.isNotEmpty) 'groupId': groupId,
        if (tag != null && tag.isNotEmpty) 'tag': tag,
        if (search != null && search.isNotEmpty) 'search': search,
      });

      final data = response.data as Map<String, dynamic>;
      final meta = data['meta'] as Map<String, dynamic>;

      return MemoListResponse(
        items: (data['data'] as List<dynamic>)
            .map((e) => MemoModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        total: meta['total'] as int,
        page: meta['page'] as int,
        limit: meta['limit'] as int,
        totalPages: meta['totalPages'] as int,
      );
    } on DioException catch (e) {
      debugPrint('❌ [MemoRepository] 메모 목록 조회 실패: ${e.message}');
      throw Exception('메모 목록 조회 실패: ${e.message}');
    }
  }

  /// 태그 이름 목록 조회 (중복 제거)
  Future<List<String>> getTags({String? groupId, bool? personal}) async {
    try {
      final response = await _dio.get('/memos/tags', queryParameters: {
        if (groupId != null) 'groupId': groupId,
        if (personal != null) 'personal': personal,
      });
      final data = response.data as Map<String, dynamic>;
      return List<String>.from(data['tags'] as List);
    } on DioException catch (e) {
      debugPrint('❌ [MemoRepository] 태그 목록 조회 실패: ${e.message}');
      throw Exception('태그 목록 조회 실패: ${e.message}');
    }
  }

  /// 메모 상세 조회
  Future<MemoModel> getMemoById(String id) async {
    try {
      final response = await _dio.get('/memos/$id');
      return MemoModel.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('❌ [MemoRepository] 메모 상세 조회 실패: ${e.message}');
      if (e.response?.statusCode == 404) {
        throw Exception('메모를 찾을 수 없습니다');
      }
      if (e.response?.statusCode == 403) {
        throw Exception('메모에 접근할 권한이 없습니다');
      }
      throw Exception('메모 조회 실패: ${e.message}');
    }
  }

  /// 메모 생성
  Future<MemoModel> createMemo(CreateMemoDto dto) async {
    try {
      final response = await _dio.post('/memos', data: dto.toJson());
      return MemoModel.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('❌ [MemoRepository] 메모 생성 실패: ${e.message}');
      throw Exception('메모 작성 실패: ${e.message}');
    }
  }

  /// 메모 수정
  Future<MemoModel> updateMemo(String id, UpdateMemoDto dto) async {
    try {
      final response = await _dio.patch('/memos/$id', data: dto.toJson());
      return MemoModel.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('❌ [MemoRepository] 메모 수정 실패: ${e.message}');
      if (e.response?.statusCode == 404) {
        throw Exception('메모를 찾을 수 없습니다');
      }
      if (e.response?.statusCode == 403) {
        throw Exception('본인의 메모만 수정할 수 있습니다');
      }
      throw Exception('메모 수정 실패: ${e.message}');
    }
  }

  /// 메모 삭제
  Future<void> deleteMemo(String id) async {
    try {
      await _dio.delete('/memos/$id');
    } on DioException catch (e) {
      debugPrint('❌ [MemoRepository] 메모 삭제 실패: ${e.message}');
      if (e.response?.statusCode == 404) {
        throw Exception('메모를 찾을 수 없습니다');
      }
      if (e.response?.statusCode == 403) {
        throw Exception('본인의 메모만 삭제할 수 있습니다');
      }
      throw Exception('메모 삭제 실패: ${e.message}');
    }
  }

  // ── 핀 ──────────────────────────────────────────────────────────

  /// 핀된 메모 목록 조회 (대시보드 위젯용)
  Future<List<MemoModel>> getPinnedMemos() async {
    try {
      final response = await _dio.get('/memos/pinned');
      final data = response.data;
      final list = data is List ? data : [data];
      return list
          .map((e) => MemoModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      debugPrint('❌ [MemoRepository] 핀된 메모 조회 실패: ${e.message}');
      throw Exception('핀된 메모 조회 실패: ${e.message}');
    }
  }

  /// 메모 핀 토글 (핀 ↔ 핀 해제)
  Future<MemoModel> togglePin(String id) async {
    try {
      final response = await _dio.post('/memos/$id/pin');
      return MemoModel.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('❌ [MemoRepository] 핀 토글 실패: ${e.message}');
      if (e.response?.statusCode == 403) {
        throw Exception('본인의 메모만 핀 설정할 수 있습니다');
      }
      throw Exception('핀 토글 실패: ${e.message}');
    }
  }

  // ── 체크리스트 ──────────────────────────────────────────────────

  /// 체크리스트 항목 추가
  Future<ChecklistItem> addChecklistItem(String memoId, CreateChecklistItemDto dto) async {
    try {
      final response = await _dio.post('/memos/$memoId/checklist', data: dto.toJson());
      return ChecklistItem.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('❌ [MemoRepository] 항목 추가 실패: ${e.message}');
      throw Exception('체크리스트 항목 추가 실패: ${e.message}');
    }
  }

  /// 체크리스트 항목 수정 (내용/순서)
  Future<ChecklistItem> updateChecklistItem(String memoId, String itemId, UpdateChecklistItemDto dto) async {
    try {
      final response = await _dio.patch('/memos/$memoId/checklist/$itemId', data: dto.toJson());
      return ChecklistItem.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('❌ [MemoRepository] 항목 수정 실패: ${e.message}');
      throw Exception('체크리스트 항목 수정 실패: ${e.message}');
    }
  }

  /// 체크리스트 항목 삭제
  Future<void> deleteChecklistItem(String memoId, String itemId) async {
    try {
      await _dio.delete('/memos/$memoId/checklist/$itemId');
    } on DioException catch (e) {
      debugPrint('❌ [MemoRepository] 항목 삭제 실패: ${e.message}');
      throw Exception('체크리스트 항목 삭제 실패: ${e.message}');
    }
  }

  /// 체크리스트 항목 체크/해제 토글
  Future<ChecklistItem> toggleChecklistItem(String memoId, String itemId) async {
    try {
      final response = await _dio.post('/memos/$memoId/checklist/$itemId/toggle');
      return ChecklistItem.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('❌ [MemoRepository] 토글 실패: ${e.message}');
      throw Exception('체크리스트 토글 실패: ${e.message}');
    }
  }

  /// 체크리스트 전체 선택/해제
  Future<void> toggleAllChecklist(String memoId, {required bool checkAll}) async {
    try {
      await _dio.post(
        '/memos/$memoId/checklist/toggle-all',
        queryParameters: {'checkAll': checkAll},
      );
    } on DioException catch (e) {
      debugPrint('❌ [MemoRepository] 전체 토글 실패: ${e.message}');
      throw Exception('체크리스트 전체 토글 실패: ${e.message}');
    }
  }
}
