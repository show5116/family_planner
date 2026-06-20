import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';

import 'package:family_planner/features/memo/data/models/memo_model.dart';
import 'package:family_planner/features/memo/data/utils/memo_editor_converter.dart';
import 'package:family_planner/features/memo/providers/memo_provider.dart';
import 'package:family_planner/features/memo/presentation/widgets/memo_card.dart';
import 'package:family_planner/features/onboarding/presentation/widgets/feature_coach_mark.dart';
import 'package:family_planner/shared/widgets/group_filter_bar.dart';
import 'package:family_planner/features/onboarding/services/onboarding_service.dart';
import 'package:family_planner/shared/widgets/app_bar_more_menu.dart';
import 'package:family_planner/shared/widgets/app_empty_state.dart';
import 'package:family_planner/shared/widgets/app_error_state.dart';
import 'package:family_planner/shared/widgets/app_search_bar.dart';
import 'package:family_planner/l10n/app_localizations.dart';

part '_memo_list_onboarding.dart';

/// 메모 목록 화면
class MemoListScreen extends ConsumerStatefulWidget {
  const MemoListScreen({super.key});

  @override
  ConsumerState<MemoListScreen> createState() => _MemoListScreenState();
}

class _MemoListScreenState extends ConsumerState<MemoListScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isSearching = false;
  bool _pinnedCollapsed = false;

  String? _selectedTag;

  // 온보딩 데모 상태
  bool _isDemo = false;
  final _noteCardKey = GlobalKey();
  final _checklistCardKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeStartOnboarding());
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

  void _selectTag(String? tag) {
    if (_selectedTag == tag) return;
    setState(() => _selectedTag = tag);
    ref.read(memoListProvider.notifier).setTag(tag);
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

    final hasSelection = _selectedTag != null;

    return SizedBox(
      height: 40,
      child: Row(
        children: [
          // 리셋 버튼
          Padding(
            padding: const EdgeInsets.only(left: AppSizes.spaceM),
            child: IconButton(
              tooltip: '태그 필터 초기화',
              onPressed: () => _selectTag(null),
              icon: Icon(
                Icons.filter_alt_off_outlined,
                size: AppSizes.iconSmall,
                color: hasSelection
                    ? Theme.of(context).colorScheme.primary
                    : AppColors.textSecondary.withValues(alpha: 0.4),
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
            ),
          ),
          const SizedBox(width: AppSizes.spaceXS),
          // 구분선
          Container(
            width: 1,
            height: 18,
            color: Theme.of(context).dividerColor,
          ),
          // 태그 칩 1줄 가로 스크롤
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceS),
              itemCount: tags.length,
              separatorBuilder: (_, _) => const SizedBox(width: AppSizes.spaceS),
              itemBuilder: (_, index) => Center(
                child: _chip(
                  label: tags[index],
                  selected: _selectedTag == tags[index],
                  onTap: () => _selectTag(tags[index]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final memosAsync = ref.watch(memoListProvider);

    final selectedFilter = ref.watch(memoSelectedFilterProvider);
    final tagsAsync = ref.watch(
      memoTagsProvider(
        groupId: (selectedFilter != null && selectedFilter != '__personal__')
            ? selectedFilter
            : null,
        personal: selectedFilter == '__personal__' ? true : null,
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
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: l10n.common_search,
            onPressed: _toggleSearch,
          ),
          AppBarMoreMenu(onReplayOnboarding: _replayOnboarding),
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
          if (!_isDemo)
            ColoredBox(
              color: Theme.of(context).colorScheme.surfaceContainerLowest,
              child: const _MemoGroupFilterBar(),
            ),
          if (!_isDemo) _buildTagChips(tagsAsync.valueOrNull ?? []),
          Expanded(
            child: _isDemo
                ? _buildDemoList()
                : RefreshIndicator(
                    onRefresh: () => ref.read(memoListProvider.notifier).refresh(),
                    child: memosAsync.when(
                      data: (memos) {
                        if (memos.isEmpty) {
                          return AppEmptyState(
                            icon: Icons.note_outlined,
                            message: l10n.memo_empty,
                          );
                        }

                        final pinned = memos.where((m) => m.isPinned).toList();
                        final normal = memos.where((m) => !m.isPinned).toList();
                        final hasPinned = pinned.isNotEmpty;
                        const collapseThreshold = 3;
                        final showCollapse = hasPinned && pinned.length > collapseThreshold;
                        final visiblePinned = (showCollapse && _pinnedCollapsed)
                            ? pinned.take(collapseThreshold).toList()
                            : pinned;

                        // 섹션 구조를 flat list로 변환
                        // _SectionHeader / MemoModel / _LoadMore 세 가지 타입
                        final items = <Object>[];
                        if (hasPinned) {
                          items.add(_SectionHeader(
                            label: '📌 고정된 메모',
                            trailing: showCollapse
                                ? _pinnedCollapsed
                                    ? '펼치기 (${pinned.length - collapseThreshold}개 더)'
                                    : '접기'
                                : null,
                            onTrailingTap: showCollapse
                                ? () => setState(
                                    () => _pinnedCollapsed = !_pinnedCollapsed)
                                : null,
                          ));
                          items.addAll(visiblePinned);
                          if (normal.isNotEmpty) {
                            items.add(const _SectionHeader(label: '메모'));
                          }
                        }
                        items.addAll(normal);

                        final notifier = ref.read(memoListProvider.notifier);
                        if (notifier.hasMore) items.add(_LoadMore());

                        return ListView.separated(
                          controller: _scrollController,
                          padding: const EdgeInsets.fromLTRB(
                            AppSizes.spaceM,
                            AppSizes.spaceM,
                            AppSizes.spaceM,
                            96,
                          ),
                          itemCount: items.length,
                          separatorBuilder: (_, i) {
                            // 섹션 헤더 앞뒤는 간격 없음
                            final next = i + 1 < items.length ? items[i + 1] : null;
                            if (items[i] is _SectionHeader || next is _SectionHeader) {
                              return const SizedBox.shrink();
                            }
                            return const SizedBox(height: AppSizes.spaceM);
                          },
                          itemBuilder: (context, index) {
                            final item = items[index];
                            if (item is _SectionHeader) {
                              return _buildSectionHeader(context, item);
                            }
                            if (item is _LoadMore) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: AppSizes.spaceL),
                                child: Center(
                                    child: CircularProgressIndicator()),
                              );
                            }
                            return MemoCard(memo: item as dynamic);
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
      floatingActionButton: _isDemo
          ? null
          : FloatingActionButton(
              onPressed: () => context.push(AppRoutes.memoAdd),
              tooltip: l10n.memo_create,
              child: const Icon(Icons.add),
            ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, _SectionHeader header) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppSizes.spaceM,
        bottom: AppSizes.spaceS,
      ),
      child: Row(
        children: [
          Text(
            header.label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          if (header.trailing != null) ...[
            const Spacer(),
            GestureDetector(
              onTap: header.onTrailingTap,
              child: Row(
                children: [
                  Text(
                    header.trailing!,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const SizedBox(width: 2),
                  Icon(
                    _pinnedCollapsed
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── 메모 그룹 필터 바 ────────────────────────────────────────────────────────

class _MemoGroupFilterBar extends ConsumerWidget {
  const _MemoGroupFilterBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GroupFilterBar(
      filterMode: FilterMode.withAll,
      savedKey: 'memo_group_filter',
      onMultiFilterChanged: (sel) {
        final notifier = ref.read(memoListProvider.notifier);
        if (sel.isAll) {
          notifier.setFilter(groupId: null, visibility: null);
          ref.read(memoSelectedFilterProvider.notifier).state = null;
        } else if (sel.includePersonal && (sel.groupIds?.isEmpty ?? true)) {
          notifier.setFilter(groupId: null, visibility: 'PRIVATE');
          ref.read(memoSelectedFilterProvider.notifier).state = '__personal__';
        } else {
          // 여러 그룹 선택 시: 단일 필터만 지원하므로 선택된 그룹이 1개면 해당 그룹, 복수면 전체
          final ids = sel.groupIds ?? [];
          final groupId = ids.length == 1 ? ids.first : null;
          final visibility = sel.includePersonal && ids.isEmpty ? 'PRIVATE' : null;
          notifier.setFilter(groupId: groupId, visibility: visibility);
          ref.read(memoSelectedFilterProvider.notifier).state =
              groupId ?? (visibility != null ? '__personal__' : null);
        }
      },
    );
  }
}

// ── 섹션 구분용 내부 모델 ────────────────────────────────────────────────────

class _SectionHeader {
  final String label;
  final String? trailing;
  final VoidCallback? onTrailingTap;

  const _SectionHeader({
    required this.label,
    this.trailing,
    this.onTrailingTap,
  });
}

class _LoadMore {}
