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
  Future<QuestionListResponse> getQuestions({
    String? filter,
    int page = 1,
    int limit = 20,
    QuestionStatus? status,
    QuestionCategory? category,
    String? search,
  }) async {
    return await _repository.getQuestions(
      filter: filter,
      page: page,
      limit: limit,
      status: status,
      category: category,
      search: search,
    );
  }

  /// 질문 상세 조회
  Future<QuestionModel> getQuestionById(String id) async {
    return await _repository.getQuestionById(id);
  }

  /// 질문 작성
  Future<QuestionModel> createQuestion(CreateQuestionDto dto) async {
    _validateQuestionContent(dto.title, dto.content);
    return await _repository.createQuestion(dto);
  }

  /// 질문 수정
  Future<QuestionModel> updateQuestion(String id, CreateQuestionDto dto) async {
    _validateQuestionContent(dto.title, dto.content);
    return await _repository.updateQuestion(id, dto);
  }

  /// 질문 삭제
  Future<void> deleteQuestion(String id) async {
    await _repository.deleteQuestion(id);
  }

  /// 질문 해결완료 처리
  Future<void> resolveQuestion(String id) async {
    await _repository.resolveQuestion(id);
  }

  /// 답변 작성 (ADMIN 전용)
  Future<AnswerModel> createAnswer(String questionId, CreateAnswerDto dto) async {
    return await _repository.createAnswer(questionId, dto);
  }

  /// 답변 수정 (ADMIN 전용)
  Future<AnswerModel> updateAnswer(String questionId, String answerId, CreateAnswerDto dto) async {
    return await _repository.updateAnswer(questionId, answerId, dto);
  }

  /// 답변 삭제 (ADMIN 전용)
  Future<void> deleteAnswer(String questionId, String answerId) async {
    await _repository.deleteAnswer(questionId, answerId);
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
