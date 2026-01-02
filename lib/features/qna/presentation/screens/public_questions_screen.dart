import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/qna/data/models/qna_model.dart';
import 'package:family_planner/features/qna/providers/qna_provider.dart';
import 'package:family_planner/features/qna/utils/qna_utils.dart';

/// 공개 Q&A 목록 화면
class PublicQuestionsScreen extends ConsumerStatefulWidget {
  const PublicQuestionsScreen({super.key});

  @override
  ConsumerState<PublicQuestionsScreen> createState() =>
      _PublicQuestionsScreenState();
}

class _PublicQuestionsScreenState extends ConsumerState<PublicQuestionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  QuestionStatus? _selectedStatus;
  QuestionCategory? _selectedCategory;
  String? _searchQuery;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_onTabChanged);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    final status = _getStatusFromTab(_tabController.index);
    setState(() {
      _selectedStatus = status;
    });
    ref.read(publicQuestionsProvider.notifier).setStatusFilter(status);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      ref.read(publicQuestionsProvider.notifier).loadMore();
    }
  }

  QuestionStatus? _getStatusFromTab(int index) {
    switch (index) {
      case 0:
        return null; // 전체
      case 1:
        return QuestionStatus.pending;
      case 2:
        return QuestionStatus.answered;
      case 3:
        return QuestionStatus.resolved;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final questionsAsync = ref.watch(publicQuestionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('공개 Q&A'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          // 카테고리 필터
          PopupMenuButton<QuestionCategory?>(
            icon: const Icon(Icons.filter_list),
            tooltip: '카테고리 필터',
            onSelected: (category) {
              setState(() {
                _selectedCategory = category;
              });
              ref
                  .read(publicQuestionsProvider.notifier)
                  .setCategoryFilter(category);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: null,
                child: Text('전체 카테고리'),
              ),
              const PopupMenuDivider(),
              ...QuestionCategory.values.map((category) {
                return PopupMenuItem(
                  value: category,
                  child: Row(
                    children: [
                      Icon(
                        category.icon,
                        size: AppSizes.iconSmall,
                        color: category.color,
                      ),
                      const SizedBox(width: AppSizes.spaceS),
                      Text(category.displayName),
                    ],
                  ),
                );
              }),
            ],
          ),
          // 검색 버튼
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: '검색',
            onPressed: _showSearchDialog,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '전체'),
            Tab(text: '대기중'),
            Tab(text: '답변완료'),
            Tab(text: '해결완료'),
          ],
        ),
      ),
      body: Column(
        children: [
          // 검색어 표시
          if (_searchQuery != null && _searchQuery!.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(AppSizes.spaceM),
              color: AppColors.info.withValues(alpha: 0.05),
              child: Row(
                children: [
                  const Icon(
                    Icons.search,
                    size: AppSizes.iconSmall,
                    color: AppColors.info,
                  ),
                  const SizedBox(width: AppSizes.spaceS),
                  Expanded(
                    child: Text(
                      '검색: $_searchQuery',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.info,
                          ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      size: AppSizes.iconSmall,
                      color: AppColors.info,
                    ),
                    onPressed: () {
                      setState(() {
                        _searchQuery = null;
                        _searchController.clear();
                      });
                      ref
                          .read(publicQuestionsProvider.notifier)
                          .setSearchQuery(null);
                    },
                  ),
                ],
              ),
            ),

          // 질문 목록
          Expanded(
            child: questionsAsync.when(
              data: (questions) {
                if (questions.isEmpty) {
                  return _buildEmptyState();
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await ref.read(publicQuestionsProvider.notifier).refresh();
                  },
                  child: ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(AppSizes.spaceM),
                    itemCount: questions.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: AppSizes.spaceM),
                    itemBuilder: (context, index) {
                      final question = questions[index];
                      return _QuestionCard(question: question);
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => _buildErrorState(error.toString()),
            ),
          ),
        ],
      ),
    );
  }

  /// 검색 다이얼로그
  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('질문 검색'),
        content: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: '제목 또는 내용으로 검색',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
          onSubmitted: (value) {
            Navigator.of(context).pop();
            _performSearch(value);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _performSearch(_searchController.text);
            },
            child: const Text('검색'),
          ),
        ],
      ),
    );
  }

  /// 검색 실행
  void _performSearch(String query) {
    if (query.trim().isEmpty) return;

    setState(() {
      _searchQuery = query.trim();
    });
    ref.read(publicQuestionsProvider.notifier).setSearchQuery(query.trim());
  }

  /// 빈 상태 위젯
  Widget _buildEmptyState() {
    String message;
    if (_searchQuery != null && _searchQuery!.isNotEmpty) {
      message = '검색 결과가 없습니다';
    } else if (_selectedStatus != null) {
      message = '${_selectedStatus!.displayName} 상태의 공개 질문이 없습니다';
    } else if (_selectedCategory != null) {
      message = '${_selectedCategory!.displayName} 카테고리의 공개 질문이 없습니다';
    } else {
      message = '아직 공개된 질문이 없습니다';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.public_off,
            size: AppSizes.iconXLarge * 2,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: AppSizes.spaceL),
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }

  /// 에러 상태 위젯
  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: AppSizes.iconXLarge * 2,
            color: AppColors.error,
          ),
          const SizedBox(height: AppSizes.spaceL),
          Text(
            '공개 질문 목록을 불러올 수 없습니다',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSizes.spaceS),
          Text(
            error,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.spaceL),
          ElevatedButton.icon(
            onPressed: () {
              ref.invalidate(publicQuestionsProvider);
            },
            icon: const Icon(Icons.refresh),
            label: const Text('다시 시도'),
          ),
        ],
      ),
    );
  }
}

/// 질문 카드 위젯
class _QuestionCard extends ConsumerWidget {
  final QuestionModel question;

  const _QuestionCard({required this.question});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormat = DateFormat('yyyy.MM.dd HH:mm');

    return Card(
      child: InkWell(
        onTap: () {
          context.push('/qna/public/${question.id}');
        },
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 헤더 (카테고리, 상태)
              Row(
                children: [
                  // 카테고리
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.spaceS,
                      vertical: AppSizes.spaceXS,
                    ),
                    decoration: BoxDecoration(
                      color: question.category.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          question.category.icon,
                          size: AppSizes.iconSmall,
                          color: question.category.color,
                        ),
                        const SizedBox(width: AppSizes.spaceXS),
                        Text(
                          question.category.displayName,
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: question.category.color,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSizes.spaceS),

                  // 상태
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.spaceS,
                      vertical: AppSizes.spaceXS,
                    ),
                    decoration: BoxDecoration(
                      color: question.status.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          question.status.icon,
                          size: AppSizes.iconSmall,
                          color: question.status.color,
                        ),
                        const SizedBox(width: AppSizes.spaceXS),
                        Text(
                          question.status.displayName,
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: question.status.color,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // 답변 개수
                  if (question.answers.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.spaceS,
                        vertical: AppSizes.spaceXS,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius:
                            BorderRadius.circular(AppSizes.radiusSmall),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.chat_bubble_outline,
                            size: AppSizes.iconSmall,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: AppSizes.spaceXS),
                          Text(
                            '${question.answers.length}',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSizes.spaceM),

              // 제목
              Text(
                question.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSizes.spaceS),

              // 내용 미리보기
              Text(
                question.content,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSizes.spaceM),

              // 작성자 및 작성일
              Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    size: AppSizes.iconSmall,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: AppSizes.spaceXS),
                  Text(
                    question.userName,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(width: AppSizes.spaceM),
                  Icon(
                    Icons.access_time,
                    size: AppSizes.iconSmall,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: AppSizes.spaceXS),
                  Text(
                    dateFormat.format(question.createdAt),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
