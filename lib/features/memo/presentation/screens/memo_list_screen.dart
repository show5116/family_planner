import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/memo/providers/memo_provider.dart';
import 'package:family_planner/features/memo/presentation/widgets/memo_card.dart';
import 'package:family_planner/shared/widgets/app_empty_state.dart';
import 'package:family_planner/shared/widgets/app_error_state.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 메모 목록 화면
class MemoListScreen extends ConsumerStatefulWidget {
  const MemoListScreen({super.key});

  @override
  ConsumerState<MemoListScreen> createState() => _MemoListScreenState();
}

class _MemoListScreenState extends ConsumerState<MemoListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
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
        _searchController.clear();
        ref.read(memoListProvider.notifier).setSearch(null);
      }
    });
  }

  void _onSearchSubmitted(String query) {
    ref.read(memoListProvider.notifier).setSearch(query);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final memosAsync = ref.watch(memoListProvider);

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: l10n.memo_searchHint,
                  border: InputBorder.none,
                ),
                onSubmitted: _onSearchSubmitted,
              )
            : Text(l10n.memo_title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: l10n.memo_create,
            onPressed: () => context.push(AppRoutes.memoAdd),
          ),
        ],
      ),
      body: RefreshIndicator(
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
    );
  }
}
