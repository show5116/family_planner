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
  /// [page]: 페이지 번호 (기본값: 1)
  /// [limit]: 페이지당 개수 (기본값: 20)
  /// [category]: 카테고리 필터
  /// [tag]: 태그 이름 필터
  /// [search]: 검색어 (제목/내용)
  Future<MemoListResponse> getMemos({
    int page = 1,
    int limit = 20,
    String? category,
    String? tag,
    String? search,
  }) async {
    try {
      debugPrint('🔵 [MemoRepository] 메모 목록 조회 시작 (page: $page)');
      final response = await _dio.get('/memos', queryParameters: {
        'page': page,
        'limit': limit,
        if (category != null && category.isNotEmpty) 'category': category,
        if (tag != null && tag.isNotEmpty) 'tag': tag,
        if (search != null && search.isNotEmpty) 'search': search,
      });

      final data = response.data as Map<String, dynamic>;
      final meta = data['meta'] as Map<String, dynamic>;

      final result = MemoListResponse(
        items: (data['data'] as List<dynamic>)
            .map((e) => MemoModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        total: meta['total'] as int,
        page: meta['page'] as int,
        limit: meta['limit'] as int,
        totalPages: meta['totalPages'] as int,
      );
      debugPrint('✅ [MemoRepository] 메모 목록 조회 성공: ${result.items.length}건');
      return result;
    } on DioException catch (e) {
      debugPrint('❌ [MemoRepository] 메모 목록 조회 실패: ${e.message}');
      throw Exception('메모 목록 조회 실패: ${e.message}');
    }
  }

  /// 메모 상세 조회
  Future<MemoModel> getMemoById(String id) async {
    try {
      debugPrint('🔵 [MemoRepository] 메모 상세 조회: $id');
      final response = await _dio.get('/memos/$id');
      final result = MemoModel.fromJson(response.data);
      debugPrint('✅ [MemoRepository] 메모 상세 조회 성공: ${result.title}');
      return result;
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
      debugPrint('🔵 [MemoRepository] 메모 생성 시작');
      final response = await _dio.post('/memos', data: dto.toJson());
      final result = MemoModel.fromJson(response.data);
      debugPrint('✅ [MemoRepository] 메모 생성 성공: ${result.id}');
      return result;
    } on DioException catch (e) {
      debugPrint('❌ [MemoRepository] 메모 생성 실패: ${e.message}');
      throw Exception('메모 작성 실패: ${e.message}');
    }
  }

  /// 메모 수정
  Future<MemoModel> updateMemo(String id, UpdateMemoDto dto) async {
    try {
      debugPrint('🔵 [MemoRepository] 메모 수정 시작: $id');
      final response = await _dio.patch('/memos/$id', data: dto.toJson());
      final result = MemoModel.fromJson(response.data);
      debugPrint('✅ [MemoRepository] 메모 수정 성공: ${result.id}');
      return result;
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
      debugPrint('🔵 [MemoRepository] 메모 삭제 시작: $id');
      await _dio.delete('/memos/$id');
      debugPrint('✅ [MemoRepository] 메모 삭제 성공: $id');
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
}
