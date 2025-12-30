import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/qna/data/models/qna_model.dart';
import 'package:family_planner/features/qna/providers/qna_provider.dart';
import 'package:family_planner/features/qna/utils/qna_utils.dart';

/// 내 질문 목록 화면
class MyQuestionsScreen extends ConsumerStatefulWidget {
  const MyQuestionsScreen({super.key});

  @override
  ConsumerState<MyQuestionsScreen> createState() => _MyQuestionsScreenState();
}

class _MyQuestionsScreenState extends ConsumerState<MyQuestionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  QuestionStatus? _selectedStatus;
  QuestionCategory? _selectedCategory;

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
    super.dispose();
  }

  void _onTabChanged() {
    final status = _getStatusFromTab(_tabController.index);
    setState(() {
      _selectedStatus = status;
    });
    ref.read(myQuestionsProvider.notifier).setStatusFilter(status);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      ref.read(myQuestionsProvider.notifier).loadMore();
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
    final questionsAsync = ref.watch(myQuestionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('내 질문'),
        actions: [
          // 카테고리 필터
          PopupMenuButton<QuestionCategory?>(
            icon: const Icon(Icons.filter_list),
            tooltip: '카테고리 필터',
            onSelected: (category) {
              setState(() {
                _selectedCategory = category;
              });
              ref.read(myQuestionsProvider.notifier).setCategoryFilter(category);
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
      body: questionsAsync.when(
        data: (questions) {
          if (questions.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(myQuestionsProvider.notifier).refresh();
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push('/qna/create');
        },
        icon: const Icon(Icons.add),
        label: const Text('질문 작성'),
      ),
    );
  }

  /// 빈 상태 위젯
  Widget _buildEmptyState() {
    String message;
    if (_selectedStatus != null) {
      message = '${_selectedStatus!.displayName} 상태의 질문이 없습니다';
    } else if (_selectedCategory != null) {
      message = '${_selectedCategory!.displayName} 카테고리의 질문이 없습니다';
    } else {
      message = '아직 작성한 질문이 없습니다';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.question_answer_outlined,
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
          const SizedBox(height: AppSizes.spaceM),
          if (_selectedStatus == null && _selectedCategory == null)
            Text(
              '궁금한 점을 질문해보세요!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
            '질문 목록을 불러올 수 없습니다',
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
              ref.invalidate(myQuestionsProvider);
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
          context.push('/qna/my-questions/${question.id}');
        },
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 헤더 (카테고리, 상태, 공개여부)
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
                  const SizedBox(width: AppSizes.spaceS),

                  // 공개여부
                  Icon(
                    question.visibility.icon,
                    size: AppSizes.iconSmall,
                    color: question.visibility.color,
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

              // 작성일
              Row(
                children: [
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
