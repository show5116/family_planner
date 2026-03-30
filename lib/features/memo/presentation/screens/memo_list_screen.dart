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

const _kTagChipLimit = 5;

// 드롭다운 선택값: null=전체, 'PRIVATE'=나만 보기, 그 외=groupId
typedef _DropdownValue = String?;

/// 메모 목록 화면
class MemoListScreen extends ConsumerStatefulWidget {
  const MemoListScreen({super.key});

  @override
  ConsumerState<MemoListScreen> createState() => _MemoListScreenState();
}

class _MemoListScreenState extends ConsumerState<MemoListScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isSearching = false;
  bool _tagsExpanded = false;

  // 드롭다운: null=전체, 'PRIVATE'=나만 보기, 그 외=groupId
  _DropdownValue _dropdownValue;
  // 태그 칩 선택값
  String? _selectedTag;

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

  void _onDropdownChanged(_DropdownValue value) {
    setState(() {
      _dropdownValue = value;
      _selectedTag = null; // 드롭다운 바꾸면 태그 초기화
      _tagsExpanded = false;
    });
    final notifier = ref.read(memoListProvider.notifier);
    if (value == null) {
      notifier.setVisibility(null);
    } else if (value == 'PRIVATE') {
      notifier.setVisibility('PRIVATE');
    } else {
      notifier.setGroupId(value);
    }
    // 태그 필터도 초기화
    notifier.setTag(null);
  }

  void _selectTag(String? tag) {
    if (_selectedTag == tag) return;
    setState(() => _selectedTag = tag);
    ref.read(memoListProvider.notifier).setTag(tag);
  }

  Widget _buildDropdown(BuildContext context) {
    final groups = ref.watch(myGroupsProvider).valueOrNull ?? [];

    final items = <DropdownMenuItem<_DropdownValue>>[
      const DropdownMenuItem(value: null, child: Text('전체')),
      const DropdownMenuItem(value: 'PRIVATE', child: Text('나만 보기')),
      ...groups.map(
        (g) => DropdownMenuItem(value: g.id, child: Text(g.name)),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.spaceM,
        AppSizes.spaceS,
        AppSizes.spaceM,
        0,
      ),
      child: DropdownButtonFormField<_DropdownValue>(
        initialValue: _dropdownValue,
        decoration: const InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSizes.spaceM,
            vertical: AppSizes.spaceS,
          ),
          border: OutlineInputBorder(),
        ),
        items: items,
        onChanged: _onDropdownChanged,
      ),
    );
  }

  FilterChip _chip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      labelPadding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceXS),
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceXS),
    );
  }

  Widget _buildTagChips(List<String> tags) {
    if (tags.isEmpty) return const SizedBox.shrink();

    final showAll = _tagsExpanded || tags.length <= _kTagChipLimit;
    final visibleTags = showAll ? tags : tags.take(_kTagChipLimit).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceM,
        vertical: AppSizes.spaceXS,
      ),
      child: Wrap(
        spacing: AppSizes.spaceS,
        runSpacing: AppSizes.spaceXS,
        children: [
          _chip(
            label: '전체',
            selected: _selectedTag == null,
            onTap: () => _selectTag(null),
          ),
          ...visibleTags.map(
            (tag) => _chip(
              label: tag,
              selected: _selectedTag == tag,
              onTap: () => _selectTag(tag),
            ),
          ),
          if (tags.length > _kTagChipLimit)
            _chip(
              label: _tagsExpanded
                  ? '접기'
                  : '+${tags.length - _kTagChipLimit}개 더',
              selected: false,
              onTap: () => setState(() => _tagsExpanded = !_tagsExpanded),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final memosAsync = ref.watch(memoListProvider);

    // 드롭다운 선택에 따라 태그 API 파라미터 결정
    final tagsAsync = ref.watch(
      memoTagsProvider(
        groupId: (_dropdownValue != null && _dropdownValue != 'PRIVATE')
            ? _dropdownValue
            : null,
        personal: _dropdownValue == 'PRIVATE' ? true : null,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.memo_title),
        leading: context.canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              )
            : null,
        automaticallyImplyLeading: false,
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
          _buildDropdown(context),
          _buildTagChips(tagsAsync.valueOrNull ?? []),
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
