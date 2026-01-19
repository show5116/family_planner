import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/features/qna/data/models/qna_model.dart';
import 'package:family_planner/features/qna/data/repositories/qna_repository.dart';
import 'package:family_planner/features/qna/data/dto/qna_dto.dart';

/// QnA Service Provider
final qnaServiceProvider = Provider<QnaService>((ref) {
  final repository = ref.watch(qnaRepositoryProvider);
  return QnaService(repository);
});

/// QnA Service
///
/// Q&A 관련 비즈니스 로직을 처리합니다.
/// Repository는 단순 API 호출만, Service는 비즈니스 로직을 담당합니다.
class QnaService {
  final QnaRepository _repository;

  QnaService(this._repository);

  /// 질문 목록 조회
  ///
  /// [filter]: 'public' (공개 질문), 'my' (내 질문), 'all' (모든 질문 - ADMIN 전용)
  /// [page]: 페이지 번호 (1부터 시작)
  /// [limit]: 페이지당 항목 수
  /// [status]: 상태 필터
  /// [category]: 카테고리 필터
  /// [search]: 검색어
  Future<QuestionListResponse> getQuestions({
    String? filter,
    int page = 1,
    int limit = 20,
    QuestionStatus? status,
    QuestionCategory? category,
    String? search,
  }) async {
    debugPrint('🔵 [QnaService] 질문 목록 조회 - filter: $filter, page: $page');

    final response = await _repository.getQuestions(
      filter: filter,
      page: page,
      limit: limit,
      status: status,
      category: category,
      search: search,
    );

    debugPrint('✅ [QnaService] 질문 ${response.data.length}개 조회 완료');
    return response;
  }

  /// 질문 상세 조회
  Future<QuestionModel> getQuestionById(String id) async {
    debugPrint('🔵 [QnaService] 질문 상세 조회 - id: $id');

    final question = await _repository.getQuestionById(id);

    debugPrint('✅ [QnaService] 질문 조회 완료: ${question.title}');
    return question;
  }

  /// 질문 작성
  ///
  /// 새 질문을 작성합니다.
  /// 작성된 질문은 기본적으로 PENDING 상태입니다.
  Future<QuestionModel> createQuestion(CreateQuestionDto dto) async {
    debugPrint('🔵 [QnaService] 질문 작성 - title: ${dto.title}');

    // 제목/내용 유효성 검사
    _validateQuestionContent(dto.title, dto.content);

    final question = await _repository.createQuestion(dto);

    debugPrint('✅ [QnaService] 질문 작성 완료 - id: ${question.id}');
    return question;
  }

  /// 질문 수정
  ///
  /// PENDING 상태의 질문만 수정 가능합니다.
  Future<QuestionModel> updateQuestion(String id, CreateQuestionDto dto) async {
    debugPrint('🔵 [QnaService] 질문 수정 - id: $id');

    // 제목/내용 유효성 검사
    _validateQuestionContent(dto.title, dto.content);

    final question = await _repository.updateQuestion(id, dto);

    debugPrint('✅ [QnaService] 질문 수정 완료');
    return question;
  }

  /// 질문 삭제
  Future<void> deleteQuestion(String id) async {
    debugPrint('🔵 [QnaService] 질문 삭제 - id: $id');

    await _repository.deleteQuestion(id);

    debugPrint('✅ [QnaService] 질문 삭제 완료');
  }

  /// 질문 해결완료 처리
  Future<void> resolveQuestion(String id) async {
    debugPrint('🔵 [QnaService] 질문 해결완료 - id: $id');

    await _repository.resolveQuestion(id);

    debugPrint('✅ [QnaService] 질문 해결완료 완료');
  }

  /// 답변 작성 (ADMIN 전용)
  Future<AnswerModel> createAnswer(String questionId, CreateAnswerDto dto) async {
    debugPrint('🔵 [QnaService] 답변 작성 - questionId: $questionId');

    final answer = await _repository.createAnswer(questionId, dto);

    debugPrint('✅ [QnaService] 답변 작성 완료 - id: ${answer.id}');
    return answer;
  }

  /// 질문 내용 유효성 검사
  void _validateQuestionContent(String title, String content) {
    if (title.trim().length < 5) {
      throw Exception('제목은 5자 이상 입력해주세요');
    }
    if (title.length > 200) {
      throw Exception('제목은 200자를 초과할 수 없습니다');
    }
    if (content.trim().length < 10) {
      throw Exception('내용은 10자 이상 입력해주세요');
    }
    if (content.length > 5000) {
      throw Exception('내용은 5000자를 초과할 수 없습니다');
    }
  }
}
