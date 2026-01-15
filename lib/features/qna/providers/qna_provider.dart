import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:family_planner/features/qna/data/models/qna_model.dart';
import 'package:family_planner/features/qna/data/repositories/qna_repository.dart';
import 'package:family_planner/features/qna/data/dto/qna_dto.dart';

part 'qna_provider.g.dart';

/// 질문 목록 Provider (통합)
@riverpod
class Questions extends _$Questions {
  int _page = 1;
  bool _hasMore = true;
  String? _filter; // 'public', 'my', 'all'
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
    final repo = ref.read(qnaRepositoryProvider);
    final response = await repo.getQuestions(
      page: _page,
      limit: 20,
      filter: _filter,
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
@riverpod
Future<QuestionModel> questionDetail(QuestionDetailRef ref, String id) async {
  final repo = ref.watch(qnaRepositoryProvider);
  return await repo.getQuestionById(id);
}

/// 질문 관리 Provider (작성, 수정, 삭제)
@riverpod
class QuestionManagement extends _$QuestionManagement {
  @override
  FutureOr<void> build() {}

  /// 질문 작성
  Future<QuestionModel> createQuestion(CreateQuestionDto dto) async {
    state = const AsyncValue.loading();
    return await AsyncValue.guard(() async {
      final repo = ref.read(qnaRepositoryProvider);
      final question = await repo.createQuestion(dto);

      // 내 질문 목록 새로고침
      ref.invalidate(questionsProvider(filter: 'my'));

      return question;
    }).then((result) {
      state = result;
      return result.requireValue;
    });
  }

  /// 질문 수정
  Future<QuestionModel> updateQuestion(String id, CreateQuestionDto dto) async {
    state = const AsyncValue.loading();
    return await AsyncValue.guard(() async {
      final repo = ref.read(qnaRepositoryProvider);
      final question = await repo.updateQuestion(id, dto);

      // 관련 Provider 무효화
      ref.invalidate(questionDetailProvider(id));
      ref.invalidate(questionsProvider(filter: 'my'));

      return question;
    }).then((result) {
      state = result;
      return result.requireValue;
    });
  }

  /// 질문 삭제
  Future<void> deleteQuestion(String id) async {
    state = const AsyncValue.loading();
    await AsyncValue.guard(() async {
      final repo = ref.read(qnaRepositoryProvider);
      await repo.deleteQuestion(id);

      // 관련 Provider 무효화
      ref.invalidate(questionsProvider(filter: 'my'));
      ref.invalidate(questionsProvider(filter: 'public'));
    }).then((result) {
      state = result;
    });
  }

  /// 답변 작성 (ADMIN 전용)
  Future<AnswerModel> createAnswer(String questionId, CreateAnswerDto dto) async {
    state = const AsyncValue.loading();
    return await AsyncValue.guard(() async {
      final repo = ref.read(qnaRepositoryProvider);
      final answer = await repo.createAnswer(questionId, dto);

      // 관련 Provider 무효화
      ref.invalidate(questionDetailProvider(questionId));
      ref.invalidate(questionsProvider(filter: 'my'));
      ref.invalidate(questionsProvider(filter: 'public'));

      return answer;
    }).then((result) {
      state = result;
      return result.requireValue;
    });
  }
}
