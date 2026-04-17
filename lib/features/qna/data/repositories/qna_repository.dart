import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/services/api_client.dart';
import 'package:family_planner/features/qna/data/models/qna_model.dart';
import 'package:family_planner/features/qna/data/dto/qna_dto.dart';

/// QnA Repository Provider
final qnaRepositoryProvider = Provider<QnaRepository>((ref) {
  return QnaRepository();
});

/// QnA Repository
class QnaRepository {
  final Dio _dio = ApiClient.instance.dio;

  QnaRepository();

  /// 질문 목록 조회 (통합)
  /// filter: 'public' (공개 질문), 'my' (내 질문), 'all' (모든 질문 - ADMIN 전용)
  Future<QuestionListResponse> getQuestions({
    int page = 1,
    int limit = 20,
    String? filter, // 'public', 'my', 'all'
    QuestionStatus? status,
    QuestionCategory? category,
    String? search,
  }) async {
    try {
      final response = await _dio.get('/qna/questions', queryParameters: {
        'page': page,
        'limit': limit,
        if (filter != null) 'filter': filter,
        if (status != null) 'status': status.name.toUpperCase(),
        if (category != null) 'category': category.name.toUpperCase(),
        if (search != null && search.isNotEmpty) 'search': search,
      });

      return QuestionListResponse.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('❌ [QnaRepository] 질문 목록 조회 실패: ${e.message}');
      throw Exception('질문 목록 조회 실패: ${e.message}');
    }
  }

  /// 질문 상세 조회
  Future<QuestionModel> getQuestionById(String id) async {
    try {
      final response = await _dio.get('/qna/questions/$id');
      return QuestionModel.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('❌ [QnaRepository] 질문 상세 조회 실패: ${e.message}');
      if (e.response?.statusCode == 404) {
        throw Exception('질문을 찾을 수 없습니다');
      }
      throw Exception('질문 조회 실패: ${e.message}');
    }
  }

  /// 질문 작성
  Future<QuestionModel> createQuestion(CreateQuestionDto dto) async {
    try {
      final response = await _dio.post('/qna/questions', data: dto.toJson());
      return QuestionModel.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('❌ [QnaRepository] 질문 작성 실패: ${e.message}');
      throw Exception('질문 작성 실패: ${e.message}');
    }
  }

  /// 질문 수정
  Future<QuestionModel> updateQuestion(String id, CreateQuestionDto dto) async {
    try {
      final response = await _dio.put('/qna/questions/$id', data: dto.toJson());
      return QuestionModel.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('❌ [QnaRepository] 질문 수정 실패: ${e.message}');
      throw Exception('질문 수정 실패: ${e.message}');
    }
  }

  /// 질문 삭제
  Future<void> deleteQuestion(String id) async {
    try {
      await _dio.delete('/qna/questions/$id');
    } on DioException catch (e) {
      debugPrint('❌ [QnaRepository] 질문 삭제 실패: ${e.message}');
      throw Exception('질문 삭제 실패: ${e.message}');
    }
  }

  /// 질문 해결완료 처리 (본인만)
  Future<void> resolveQuestion(String id) async {
    try {
      await _dio.post('/qna/questions/$id/resolve');
    } on DioException catch (e) {
      debugPrint('❌ [QnaRepository] 질문 해결완료 실패: ${e.message}');
      throw Exception('해결완료 처리 실패: ${e.message}');
    }
  }

  /// 답변 작성 (ADMIN 전용)
  Future<AnswerModel> createAnswer(String questionId, CreateAnswerDto dto) async {
    try {
      final response = await _dio.post(
        '/qna/admin/questions/$questionId/answers',
        data: dto.toJson(),
      );
      return AnswerModel.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('❌ [QnaRepository] 답변 작성 실패: ${e.message}');
      throw Exception('답변 작성 실패: ${e.message}');
    }
  }

  /// 답변 수정 (ADMIN 전용)
  Future<AnswerModel> updateAnswer(String questionId, String answerId, CreateAnswerDto dto) async {
    try {
      final response = await _dio.put(
        '/qna/admin/questions/$questionId/answers/$answerId',
        data: dto.toJson(),
      );
      return AnswerModel.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('❌ [QnaRepository] 답변 수정 실패: ${e.message}');
      throw Exception('답변 수정 실패: ${e.message}');
    }
  }

  /// 답변 삭제 (ADMIN 전용)
  Future<void> deleteAnswer(String questionId, String answerId) async {
    try {
      await _dio.delete('/qna/admin/questions/$questionId/answers/$answerId');
    } on DioException catch (e) {
      debugPrint('❌ [QnaRepository] 답변 삭제 실패: ${e.message}');
      throw Exception('답변 삭제 실패: ${e.message}');
    }
  }
}
