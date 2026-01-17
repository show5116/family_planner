import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:family_planner/features/qna/data/models/qna_model.dart';
import 'package:family_planner/features/qna/data/dto/qna_dto.dart';
import 'package:family_planner/features/qna/services/qna_service.dart';

part 'qna_provider.g.dart';

/// 질문 목록 Provider (통합)
///
/// autoDispose: 화면을 벗어나면 캐시 삭제 → 항상 최신 데이터 보장
/// keepAlive: 페이징 중에는 캐시 유지
@riverpod
class Questions extends _$Questions {
  int _page = 1;
  bool _hasMore = true;
  String? _filter;
  QuestionStatus? _statusFilter;
  QuestionCategory? _categoryFilter;
  String? _searchQuery;

  @override
  Future<List<QuestionListItem>> build({String? filter}) async {
    _filter = filter;
    _page = 1;
    _hasMore = true;
    return _fetchQuestions();
  }

  /// 질문 목록 조회
  Future<List<QuestionListItem>> _fetchQuestions() async {
    final service = ref.read(qnaServiceProvider);
    final response = await service.getQuestions(
      filter: _filter,
      page: _page,
      limit: 20,
      status: _statusFilter,
      category: _categoryFilter,
      search: _searchQuery,
    );

    _hasMore = response.data.length >= 20;
    return response.data;
  }

  /// 다음 페이지 로드
  Future<void> loadMore() async {
    if (!_hasMore || state.isLoading) return;

    final currentItems = state.value ?? [];
    _page++;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final newItems = await _fetchQuestions();
      return [...currentItems, ...newItems];
    });
  }

  /// 새로고침
  Future<void> refresh() async {
    _page = 1;
    _hasMore = true;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fetchQuestions);
  }

  /// 필터 변경
  Future<void> setFilter(String? filter) async {
    _filter = filter;
    await refresh();
  }

  /// 상태 필터 변경
  Future<void> setStatusFilter(QuestionStatus? status) async {
    _statusFilter = status;
    await refresh();
  }

  /// 카테고리 필터 변경
  Future<void> setCategoryFilter(QuestionCategory? category) async {
    _categoryFilter = category;
    await refresh();
  }

  /// 검색어 변경
  Future<void> setSearchQuery(String? query) async {
    _searchQuery = query;
    await refresh();
  }

  /// 더 불러올 항목이 있는지
  bool get hasMore => _hasMore;
}

/// 질문 상세 Provider
///
/// autoDispose: 상세 화면을 벗어나면 캐시 삭제
@riverpod
Future<QuestionModel> questionDetail(Ref ref, String id) async {
  final service = ref.watch(qnaServiceProvider);
  return await service.getQuestionById(id);
}

/// 질문 관리 Provider (작성, 수정, 삭제)
///
/// 상태를 저장하지 않고 단순 액션 처리용
@riverpod
class QuestionManagement extends _$QuestionManagement {
  @override
  FutureOr<void> build() {
    return null;
  }

  /// 질문 작성
  Future<QuestionModel> createQuestion(CreateQuestionDto dto) async {
    final service = ref.read(qnaServiceProvider);
    final question = await service.createQuestion(dto);

    // 목록 캐시 무효화
    ref.invalidate(questionsProvider(filter: 'my'));
    ref.invalidate(questionsProvider(filter: 'public'));

    return question;
  }

  /// 질문 수정
  Future<QuestionModel> updateQuestion(String id, CreateQuestionDto dto) async {
    final service = ref.read(qnaServiceProvider);
    final question = await service.updateQuestion(id, dto);

    // 관련 캐시 무효화
    ref.invalidate(questionDetailProvider(id));
    ref.invalidate(questionsProvider(filter: 'my'));
    ref.invalidate(questionsProvider(filter: 'public'));

    return question;
  }

  /// 질문 삭제
  Future<void> deleteQuestion(String id) async {
    final service = ref.read(qnaServiceProvider);
    await service.deleteQuestion(id);

    // 관련 캐시 무효화
    ref.invalidate(questionsProvider(filter: 'my'));
    ref.invalidate(questionsProvider(filter: 'public'));
  }

  /// 답변 작성 (ADMIN 전용)
  Future<AnswerModel> createAnswer(String questionId, CreateAnswerDto dto) async {
    final service = ref.read(qnaServiceProvider);
    final answer = await service.createAnswer(questionId, dto);

    // 관련 캐시 무효화
    ref.invalidate(questionDetailProvider(questionId));
    ref.invalidate(questionsProvider(filter: 'my'));
    ref.invalidate(questionsProvider(filter: 'public'));

    return answer;
  }
}
