import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';

import 'package:family_planner/features/memo/data/models/memo_model.dart';
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

const _kTagChipLimit = 5;

// ── 온보딩용 샘플 메모 ────────────────────────────────────────────────────────

final _demoNow = DateTime(2025, 5, 10, 9, 0);

final _demoNoteMemo = MemoModel(
  id: '__demo_note__',
  title: '제주도 여행 준비',
  content: '항공권 예약 완료. 숙소는 한림읍 게스트하우스로 결정.\n렌터카 예약 필요. 우도, 성산일출봉 방문 예정.',
  type: MemoType.note,
  visibility: MemoVisibility.private_,
  user: const MemoAuthor(id: '__demo_user__', name: '나'),
  tags: const [MemoTag(id: '__t1__', name: '여행'), MemoTag(id: '__t2__', name: '제주')],
  createdAt: _demoNow,
  updatedAt: _demoNow,
);

final _demoChecklistMemo = MemoModel(
  id: '__demo_checklist__',
  title: '장보기 목록',
  content: '',
  type: MemoType.checklist,
  visibility: MemoVisibility.private_,
  user: const MemoAuthor(id: '__demo_user__', name: '나'),
  checklistItems: [
    ChecklistItem(
      id: '__ci1__', content: '우유 2개', isChecked: true, order: 0,
      createdAt: _demoNow, updatedAt: _demoNow,
    ),
    ChecklistItem(
      id: '__ci2__', content: '달걀 한 판', isChecked: true, order: 1,
      createdAt: _demoNow, updatedAt: _demoNow,
    ),
    ChecklistItem(
      id: '__ci3__', content: '두부', isChecked: false, order: 2,
      createdAt: _demoNow, updatedAt: _demoNow,
    ),
    ChecklistItem(
      id: '__ci4__', content: '사과 1kg', isChecked: false, order: 3,
      createdAt: _demoNow, updatedAt: _demoNow,
    ),
  ],
  createdAt: _demoNow,
  updatedAt: _demoNow,
);

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

  Future<void> _maybeStartOnboarding() async {
    final completed = await OnboardingService.isCoachMarkCompleted(CoachMarkKeys.memo);
    if (!mounted || completed) return;
    _startDemo();
  }

  void _startDemo() {
    setState(() => _isDemo = true);
    WidgetsBinding.instance.addPostFrameCallback((_) => _showPhase1());
  }

  void _endDemo() {
    if (mounted) setState(() => _isDemo = false);
  }

  void _replayOnboarding() {
    OnboardingService.resetCoachMark(CoachMarkKeys.memo);
    _startDemo();
  }

  TargetPosition? _keyToPosition(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return null;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return null;
    final offset = box.localToGlobal(Offset.zero);
    return TargetPosition(box.size, offset);
  }

  // ── 1단계: 일반 메모 설명 ────────────────────────────────────────────────

  Future<void> _showPhase1() async {
    if (!mounted) return;
    final notePos = _keyToPosition(_noteCardKey);
    final targets = <TargetFocus>[
      TargetFocus(
        identify: 'note_card',
        targetPosition: notePos,
        keyTarget: notePos == null ? _noteCardKey : null,
        shape: ShapeLightFocus.RRect,
        radius: 12,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '일반 메모',
              description: '자유롭게 텍스트를 작성할 수 있어요.\n마크다운 형식도 지원하며\n태그로 분류할 수 있습니다.',
              icon: Icons.note_outlined,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    ];
    await FeatureCoachMark.waitForTargets(targets, context);
    if (!mounted) return;
    TutorialCoachMark(
      targets: targets,
      colorShadow: const Color(0xFF212121),
      opacityShadow: 0.85,
      textSkip: '건너뛰기',
      alignSkip: Alignment.topRight,
      skipWidget: _skipWidget,
      onFinish: _showPhase2,
      onSkip: () { _completeOnboarding(); return true; },
      paddingFocus: 8,
      focusAnimationDuration: const Duration(milliseconds: 300),
      pulseAnimationDuration: const Duration(milliseconds: 800),
    ).show(context: context);
  }

  // ── 2단계: 체크리스트 메모 설명 ──────────────────────────────────────────

  Future<void> _showPhase2() async {
    if (!mounted) return;
    final checklistPos = _keyToPosition(_checklistCardKey);
    final targets = <TargetFocus>[
      TargetFocus(
        identify: 'checklist_card',
        targetPosition: checklistPos,
        keyTarget: checklistPos == null ? _checklistCardKey : null,
        shape: ShapeLightFocus.RRect,
        radius: 12,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '체크리스트 메모',
              description: '할 일 목록을 체크하며 관리해요.\n진행률이 카드에 바로 표시되고\n항목을 탭해서 완료 처리할 수 있어요.',
              icon: Icons.checklist,
              color: Colors.teal,
            ),
          ),
        ],
      ),
    ];
    await FeatureCoachMark.waitForTargets(targets, context);
    if (!mounted) return;
    TutorialCoachMark(
      targets: targets,
      colorShadow: const Color(0xFF212121),
      opacityShadow: 0.85,
      textSkip: '건너뛰기',
      alignSkip: Alignment.topRight,
      skipWidget: _skipWidget,
      onFinish: _showPhase3Detail,
      onSkip: () { _completeOnboarding(); return true; },
      paddingFocus: 8,
      focusAnimationDuration: const Duration(milliseconds: 300),
      pulseAnimationDuration: const Duration(milliseconds: 800),
    ).show(context: context);
  }

  // ── 3단계: 체크리스트 상세 화면 데모 ─────────────────────────────────────

  Future<void> _showPhase3Detail() async {
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _DemoChecklistDetailScreen(
          memo: _demoChecklistMemo,
          onDone: _completeOnboarding,
        ),
      ),
    );
    _completeOnboarding();
  }

  void _completeOnboarding() {
    OnboardingService.completeCoachMark(CoachMarkKeys.memo);
    _endDemo();
  }

  Widget get _skipWidget => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white30),
        ),
        child: const Text(
          '건너뛰기',
          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
        ),
      );

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
              label: _tagsExpanded ? '접기' : '+${tags.length - _kTagChipLimit}개 더',
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
          if (!_isDemo) const _MemoGroupFilterBar(),
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
      floatingActionButton: _isDemo
          ? null
          : FloatingActionButton(
              onPressed: () => context.push(AppRoutes.memoAdd),
              tooltip: l10n.memo_create,
              child: const Icon(Icons.add),
            ),
    );
  }

  Widget _buildDemoList() {
    return ListView(
      padding: const EdgeInsets.all(AppSizes.spaceM),
      children: [
        MemoCard(key: _noteCardKey, memo: _demoNoteMemo, isDemo: true),
        const SizedBox(height: AppSizes.spaceM),
        MemoCard(key: _checklistCardKey, memo: _demoChecklistMemo, isDemo: true),
      ],
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

// ── 데모 체크리스트 상세 화면 ─────────────────────────────────────────────────

class _DemoChecklistDetailScreen extends StatefulWidget {
  const _DemoChecklistDetailScreen({required this.memo, required this.onDone});

  final MemoModel memo;
  final VoidCallback onDone;

  @override
  State<_DemoChecklistDetailScreen> createState() =>
      _DemoChecklistDetailScreenState();
}

class _DemoChecklistDetailScreenState
    extends State<_DemoChecklistDetailScreen> {
  late List<ChecklistItem> _items;
  final _checkItemKey = GlobalKey();
  final _progressKey = GlobalKey();
  final _addRowKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.memo.checklistItems);
    WidgetsBinding.instance.addPostFrameCallback((_) => _showCoachMark());
  }

  Future<void> _showCoachMark() async {
    if (!mounted) return;
    final progressPos = _keyToPosition(_progressKey);
    final checkItemPos = _keyToPosition(_checkItemKey);
    final addRowPos = _keyToPosition(_addRowKey);

    final targets = <TargetFocus>[
      TargetFocus(
        identify: 'checklist_progress',
        targetPosition: progressPos,
        keyTarget: progressPos == null ? _progressKey : null,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '진행률',
              description: '완료된 항목 수를 한눈에 볼 수 있어요.\n전체 선택/초기화 버튼도 있습니다.',
              icon: Icons.checklist,
              color: Colors.teal,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'checklist_item',
        targetPosition: checkItemPos,
        keyTarget: checkItemPos == null ? _checkItemKey : null,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '항목 체크',
              description: '체크박스를 탭하면 완료 처리돼요.\n항목을 직접 탭하면 내용을 수정할 수 있어요.',
              icon: Icons.check_circle_outline,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'checklist_add',
        targetPosition: addRowPos,
        keyTarget: addRowPos == null ? _addRowKey : null,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '항목 추가',
              description: '언제든지 새 항목을 추가할 수 있어요.',
              icon: Icons.add_circle_outline,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    ];

    await FeatureCoachMark.waitForTargets(targets, context);
    if (!mounted) return;
    TutorialCoachMark(
      targets: targets,
      colorShadow: const Color(0xFF212121),
      opacityShadow: 0.85,
      textSkip: '건너뛰기',
      alignSkip: Alignment.topRight,
      skipWidget: _skipWidget,
      onFinish: () => Navigator.of(context).pop(),
      onSkip: () { Navigator.of(context).pop(); return true; },
      paddingFocus: 8,
      focusAnimationDuration: const Duration(milliseconds: 300),
      pulseAnimationDuration: const Duration(milliseconds: 800),
    ).show(context: context);
  }

  TargetPosition? _keyToPosition(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return null;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return null;
    final offset = box.localToGlobal(Offset.zero);
    return TargetPosition(box.size, offset);
  }

  Widget get _skipWidget => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white30),
        ),
        child: const Text(
          '건너뛰기',
          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
        ),
      );

  void _toggle(String id) {
    setState(() {
      _items = _items.map((item) {
        if (item.id == id) return item.copyWith(isChecked: !item.isChecked);
        return item;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final checked = _items.where((i) => i.isChecked).length;
    final total = _items.length;

    return Scaffold(
      appBar: AppBar(title: Text(widget.memo.title)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.spaceL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 제목
              Text(
                widget.memo.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppSizes.spaceL),
              const Divider(),
              const SizedBox(height: AppSizes.spaceM),

              // 진행률 헤더
              Row(
                key: _progressKey,
                children: [
                  Icon(Icons.checklist,
                      size: AppSizes.iconSmall, color: AppColors.primary),
                  const SizedBox(width: AppSizes.spaceXS),
                  Text(
                    '$checked / $total 완료',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () => setState(() {
                      _items = _items.map((i) => i.copyWith(isChecked: true)).toList();
                    }),
                    icon: const Icon(Icons.check_box, size: AppSizes.iconSmall),
                    label: const Text('전체 선택'),
                    style: TextButton.styleFrom(foregroundColor: AppColors.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.spaceS),

              // 체크리스트 항목
              ..._items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isFirst = index == 0;
                return Padding(
                  key: isFirst ? _checkItemKey : null,
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Checkbox(
                        value: item.isChecked,
                        onChanged: (_) => _toggle(item.id),
                      ),
                      Expanded(
                        child: Text(
                          item.content,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                decoration: item.isChecked
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: item.isChecked
                                    ? AppColors.textSecondary
                                    : null,
                              ),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: AppSizes.spaceM),

              // 항목 추가 행 (비활성)
              Row(
                key: _addRowKey,
                children: [
                  Expanded(
                    child: TextField(
                      enabled: false,
                      decoration: const InputDecoration(
                        hintText: '항목 입력',
                        border: OutlineInputBorder(),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: AppSizes.spaceM,
                          vertical: AppSizes.spaceS,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.spaceS),
                  IconButton.filled(
                    onPressed: null,
                    icon: const Icon(Icons.add),
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
