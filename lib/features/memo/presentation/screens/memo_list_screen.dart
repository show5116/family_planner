import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/memo/providers/memo_provider.dart';
import 'package:family_planner/features/memo/presentation/widgets/memo_card.dart';
import 'package:family_planner/features/ai_chat/presentation/widgets/ai_chat_icon_button.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/shared/widgets/app_empty_state.dart';
import 'package:family_planner/shared/widgets/app_error_state.dart';
import 'package:family_planner/shared/widgets/app_search_bar.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 메모 목록 화면
class MemoListScreen extends ConsumerStatefulWidget {
  const MemoListScreen({super.key});

  @override
  ConsumerState<MemoListScreen> createState() => _MemoListScreenState();
}

// 필터 타입
enum _MemoFilter { all, private, group }

class _MemoListScreenState extends ConsumerState<MemoListScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isSearching = false;
  _MemoFilter _filter = _MemoFilter.all;
  String? _selectedGroupId;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      final notifier = ref.read(memoListProvider.notifier);
      if (notifier.hasMore) {
        notifier.loadMore();
      }
    }
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        ref.read(memoListProvider.notifier).setSearch(null);
      }
    });
  }

  void _applyFilter(_MemoFilter filter, {String? groupId}) {
    setState(() {
      _filter = filter;
      _selectedGroupId = groupId;
    });
    final notifier = ref.read(memoListProvider.notifier);
    switch (filter) {
      case _MemoFilter.all:
        notifier.setVisibility(null);
      case _MemoFilter.private:
        notifier.setVisibility('PRIVATE');
      case _MemoFilter.group:
        notifier.setGroupId(groupId);
    }
  }

  Widget _buildFilterChips(BuildContext context) {
    final groups = ref.watch(myGroupsProvider).valueOrNull ?? [];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceM,
        vertical: AppSizes.spaceS,
      ),
      child: Row(
        children: [
          FilterChip(
            label: const Text('전체'),
            selected: _filter == _MemoFilter.all,
            onSelected: (_) => _applyFilter(_MemoFilter.all),
          ),
          const SizedBox(width: AppSizes.spaceS),
          FilterChip(
            label: const Text('나만 보기'),
            selected: _filter == _MemoFilter.private,
            onSelected: (_) => _applyFilter(_MemoFilter.private),
          ),
          ...groups.map((group) {
            final isSelected =
                _filter == _MemoFilter.group && _selectedGroupId == group.id;
            return Padding(
              padding: const EdgeInsets.only(left: AppSizes.spaceS),
              child: FilterChip(
                label: Text(group.name),
                selected: isSelected,
                onSelected: (_) =>
                    _applyFilter(_MemoFilter.group, groupId: group.id),
              ),
            );
          }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final memosAsync = ref.watch(memoListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.memo_title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          const AiChatIconButton(),
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: l10n.common_search,
            onPressed: _toggleSearch,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: l10n.memo_create,
            onPressed: () => context.push(AppRoutes.memoAdd),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isSearching)
            AppSearchBar(
              hintText: l10n.memo_searchHint,
              onSearch: (query) {
                ref.read(memoListProvider.notifier).setSearch(query);
              },
              onClose: _toggleSearch,
            ),
          _buildFilterChips(context),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref.read(memoListProvider.notifier).refresh(),
              child: memosAsync.when(
                data: (memos) {
                  if (memos.isEmpty) {
                    return AppEmptyState(
                      icon: Icons.note_outlined,
                      message: l10n.memo_empty,
                    );
                  }

                  return ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(AppSizes.spaceM),
                    itemCount: memos.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: AppSizes.spaceM),
                    itemBuilder: (context, index) {
                      final memo = memos[index];
                      return MemoCard(memo: memo);
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => AppErrorState(
                  error: error,
                  title: l10n.memo_loadError,
                  onRetry: () => ref.read(memoListProvider.notifier).refresh(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
