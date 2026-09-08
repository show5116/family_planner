import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/qna/data/models/qna_model.dart';
import 'package:family_planner/features/qna/providers/qna_provider.dart';
import 'package:family_planner/features/qna/utils/qna_utils.dart';
import 'package:family_planner/features/qna/presentation/widgets/question_card.dart';
import 'package:family_planner/shared/widgets/app_tab_bar.dart';
import 'package:family_planner/core/utils/user_utils.dart';

/// Q&A 목록 화면 (통합)
class QuestionsScreen extends ConsumerStatefulWidget {
  const QuestionsScreen({super.key});

  @override
  ConsumerState<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends ConsumerState<QuestionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  bool _showMyQuestionsOnly = false;
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

  /// 공개 질문 필터 (admin은 all, 일반 사용자는 public)
  String get _publicFilter {
    final isAdmin = ref.read(isAdminProvider);
    return isAdmin ? 'all' : 'public';
  }

  /// 현재 선택된 필터
  String get _currentFilter => _showMyQuestionsOnly ? 'my' : _publicFilter;

  void _onTabChanged() {
    final status = _getStatusFromTab(_tabController.index);
    setState(() {
      _selectedStatus = status;
    });
    ref
        .read(questionsProvider(filter: _publicFilter).notifier)
        .setStatusFilter(status);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      ref.read(questionsProvider(filter: _publicFilter).notifier).loadMore();
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
    final l10n = AppLocalizations.of(context)!;
    // 단일 Provider 인스턴스 사용 (filter는 초기값)
    final questionsAsync = ref.watch(questionsProvider(filter: _publicFilter));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Q&A'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          // 내 질문만 보기 토글
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.qna_myQuestionsOnly,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _showMyQuestionsOnly
                          ? Colors.white
                          : Colors.white70,
                      fontWeight: _showMyQuestionsOnly
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
              ),
              Switch(
                value: _showMyQuestionsOnly,
                activeThumbColor: Colors.white,
                activeTrackColor: Colors.white38,
                inactiveThumbColor: Colors.white70,
                inactiveTrackColor: Colors.white24,
                onChanged: (value) {
                  setState(() {
                    _showMyQuestionsOnly = value;
                  });
                  // 토글 시 filter만 변경 (같은 Provider 인스턴스 유지)
                  ref
                      .read(questionsProvider(filter: _publicFilter).notifier)
                      .setFilter(_currentFilter);
                },
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
          // 카테고리 필터
          PopupMenuButton<QuestionCategory?>(
            icon: const Icon(Icons.filter_list),
            tooltip: l10n.qna_categoryFilter,
            onSelected: (category) {
              setState(() {
                _selectedCategory = category;
              });
              ref
                  .read(questionsProvider(filter: _publicFilter).notifier)
                  .setCategoryFilter(category);
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: null,
                child: Text(l10n.qna_allCategories),
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
            tooltip: l10n.common_search,
            onPressed: _showSearchDialog,
          ),
        ],
        bottom: AppTabBar(
          controller: _tabController,
          tabs: [
            l10n.qna_statusAll,
            l10n.qna_tab_pending,
            l10n.qna_tab_answered,
            l10n.qna_tab_resolved,
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
                      l10n.qna_searchLabel(_searchQuery!),
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
                          .read(questionsProvider(filter: _publicFilter).notifier)
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
                    await ref
                        .read(questionsProvider(filter: _publicFilter).notifier)
                        .refresh();
                  },
                  child: ListView.separated(
                    controller: _scrollController,
                    padding: EdgeInsets.only(
                      left: AppSizes.spaceM,
                      right: AppSizes.spaceM,
                      top: AppSizes.spaceM,
                      bottom: AppSizes.spaceM + MediaQuery.paddingOf(context).bottom + 80,
                    ),
                    itemCount: questions.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: AppSizes.spaceM),
                    itemBuilder: (context, index) {
                      final question = questions[index];
                      return QuestionCard(
                        question: question,
                        showVisibility: _currentFilter == 'my',
                      );
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push('/qna/create');
        },
        icon: const Icon(Icons.add),
        label: Text(l10n.qna_writeQuestion),
      ),
    );
  }

  /// 검색 다이얼로그
  void _showSearchDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.qna_search),
        content: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: l10n.qna_searchByTitleOrContent,
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
            child: Text(l10n.common_cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _performSearch(_searchController.text);
            },
            child: Text(l10n.common_search),
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
    ref
        .read(questionsProvider(filter: _publicFilter).notifier)
        .setSearchQuery(query.trim());
  }

  /// 빈 상태 위젯
  Widget _buildEmptyState() {
    final l10n = AppLocalizations.of(context)!;
    String message;
    const icon = Icons.question_answer_outlined;

    if (_searchQuery != null && _searchQuery!.isNotEmpty) {
      message = l10n.common_noSearchResults;
    } else if (_selectedStatus != null) {
      message = l10n.qna_emptyByStatus(_selectedStatus!.displayName);
    } else if (_selectedCategory != null) {
      message = l10n.qna_emptyByCategory(_selectedCategory!.displayName);
    } else {
      message = l10n.qna_emptyMine;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: AppSizes.iconXLarge * 2,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: AppSizes.spaceL),
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// 에러 상태 위젯
  Widget _buildErrorState(String error) {
    final l10n = AppLocalizations.of(context)!;
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
            l10n.qna_listLoadError,
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
              ref.invalidate(questionsProvider(filter: _publicFilter));
            },
            icon: const Icon(Icons.refresh),
            label: Text(l10n.common_retry),
          ),
        ],
      ),
    );
  }
}
