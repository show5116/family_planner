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


// ── 온보딩용 샘플 메모 ────────────────────────────────────────────────────────

final _demoNow = DateTime(2025, 5, 10, 9, 0);

// 데모 일반 메모 Delta JSON (굵은 제목 + 일반 텍스트 혼합)
const _demoNoteDelta =
    '[{"insert":"항공권 예약 완료","attributes":{"bold":true}},'
    '{"insert":"\\n숙소는 한림읍 게스트하우스로 결정.\\n렌터카 예약 필요. 우도, 성산일출봉 방문 예정.\\n"}]';

final _demoNoteMemo = MemoModel(
  id: '__demo_note__',
  title: '제주도 여행 준비',
  content: _demoNoteDelta,
  format: MemoFormat.delta,
  visibility: MemoVisibility.private_,
  user: const MemoAuthor(id: '__demo_user__', name: '나'),
  tags: const [MemoTag(id: '__t1__', name: '여행'), MemoTag(id: '__t2__', name: '제주')],
  createdAt: _demoNow,
  updatedAt: _demoNow,
);

// 데모 체크리스트 Delta JSON (우유 2개✓, 달걀 한 판✓, 두부, 사과 1kg)
const _demoChecklistDelta =
    '[{"insert":"여권 / 신분증\\n","attributes":{"list":"checked"}},'
    '{"insert":"세면도구\\n","attributes":{"list":"checked"}},'
    '{"insert":"여벌 옷\\n","attributes":{"list":"unchecked"}},'
    '{"insert":"충전기\\n","attributes":{"list":"unchecked"}},'
    '{"insert":"상비약\\n","attributes":{"list":"unchecked"}}]';

final _demoChecklistMemo = MemoModel(
  id: '__demo_checklist__',
  title: '외박 준비물',
  content: _demoChecklistDelta,
  format: MemoFormat.delta,
  visibility: MemoVisibility.private_,
  user: const MemoAuthor(id: '__demo_user__', name: '나'),
  checklistMeta: const ChecklistMeta(total: 5, checked: 2),
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

  // ── 1단계: 일반 메모 설명 ────────────────────────────────────────────────

  Future<void> _showPhase1() async {
    if (!mounted) return;
    final targets = <TargetFocus>[
      TargetFocus(
        identify: 'note_card',
        keyTarget: _noteCardKey,
        shape: ShapeLightFocus.RRect,
        radius: 12,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '리치 텍스트 메모',
              description: '굵게, 기울임, 제목 등 서식을 자유롭게 적용할 수 있어요.\n태그로 분류하고 URL을 붙여넣으면\n링크 카드가 자동으로 생성됩니다.',
              icon: Icons.edit_note,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    ];
    await FeatureCoachMark.waitForTargets(targets, context);
    if (!mounted) return;
    TutorialCoachMark(
      targets: FeatureCoachMark.refreshPositions(targets),
      colorShadow: const Color(0xFF212121),
      opacityShadow: 0.85,
      textSkip: '건너뛰기',
      alignSkip: Alignment.bottomRight,
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
    final targets = <TargetFocus>[
      TargetFocus(
        identify: 'checklist_card',
        keyTarget: _checklistCardKey,
        shape: ShapeLightFocus.RRect,
        radius: 12,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '체크리스트',
              description: '메모 중간 어디에든 체크리스트를 삽입할 수 있어요.\n완료된 항목 수가 카드에 바로 표시되고\n상세 화면에서 탭해 체크할 수 있습니다.',
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
      targets: FeatureCoachMark.refreshPositions(targets),
      colorShadow: const Color(0xFF212121),
      opacityShadow: 0.85,
      textSkip: '건너뛰기',
      alignSkip: Alignment.bottomRight,
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
                        final collapseThreshold = 3;
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

// ── 데모 체크리스트 상세 화면 (실제 MemoDetailScreen과 동일한 구조) ──────────

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
  late QuillController _quillController;
  final _progressKey = GlobalKey();
  final _checkItemKey = GlobalKey();
  final _editBtnKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    final doc = MemoEditorConverter.toDocument(widget.memo.content);
    _quillController = QuillController(
      document: doc,
      selection: const TextSelection.collapsed(offset: 0),
      readOnly: true,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _showCoachMark());
  }

  @override
  void dispose() {
    _quillController.dispose();
    super.dispose();
  }

  Future<void> _showCoachMark() async {
    if (!mounted) return;
    final targets = <TargetFocus>[
      TargetFocus(
        identify: 'checklist_progress',
        keyTarget: _progressKey,
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
        keyTarget: _checkItemKey,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '항목 체크',
              description: '체크박스를 탭하면 완료 처리돼요.\n저장 버튼을 누르면 변경사항이 한 번에 저장됩니다.',
              icon: Icons.check_circle_outline,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'edit_btn',
        keyTarget: _editBtnKey,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '수정 모드',
              description: '수정 버튼을 누르면 에디터가 열려요.\n툴바의 체크리스트 버튼으로 항목을 자유롭게 추가·수정할 수 있습니다.',
              icon: Icons.edit_outlined,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    ];

    await FeatureCoachMark.waitForTargets(targets, context);
    if (!mounted) return;
    TutorialCoachMark(
      targets: FeatureCoachMark.refreshPositions(targets),
      colorShadow: const Color(0xFF212121),
      opacityShadow: 0.85,
      textSkip: '건너뛰기',
      alignSkip: Alignment.bottomRight,
      skipWidget: _skipWidget,
      onFinish: () => Navigator.of(context).pop(),
      onSkip: () { Navigator.of(context).pop(); return true; },
      paddingFocus: 8,
      focusAnimationDuration: const Duration(milliseconds: 300),
      pulseAnimationDuration: const Duration(milliseconds: 800),
    ).show(context: context);
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

  @override
  Widget build(BuildContext context) {
    final checked = widget.memo.checklistMeta.checked;
    final total = widget.memo.checklistMeta.total;

    return Scaffold(
      appBar: AppBar(
        title: const Text('메모 상세'),
        actions: [
          // 실제 MemoDetailScreen의 수정 메뉴 버튼과 동일한 위치에 key 부착
          IconButton(
            key: _editBtnKey,
            icon: const Icon(Icons.more_vert),
            onPressed: null, // 데모 — 비활성
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.spaceL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 제목 (실제 상세 화면과 동일)
              Text(
                widget.memo.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppSizes.spaceS),

              // 작성자 · 날짜
              Row(
                children: [
                  Icon(Icons.person_outline,
                      size: AppSizes.iconSmall, color: AppColors.textSecondary),
                  const SizedBox(width: AppSizes.spaceXS),
                  Text(widget.memo.user.name,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          )),
                ],
              ),

              const SizedBox(height: AppSizes.spaceM),

              // 체크리스트 진행률 바 (실제 _ChecklistProgressBar와 동일 구조)
              Row(
                key: _progressKey,
                children: [
                  Icon(Icons.checklist,
                      size: AppSizes.iconSmall, color: AppColors.primary),
                  const SizedBox(width: AppSizes.spaceXS),
                  Text(
                    '$checked/$total 완료',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: null,
                    icon: const Icon(Icons.check_box, size: AppSizes.iconSmall),
                    label: const Text('전체 선택'),
                    style: TextButton.styleFrom(
                        foregroundColor: AppColors.textSecondary),
                  ),
                ],
              ),

              const SizedBox(height: AppSizes.spaceL),
              const Divider(),
              const SizedBox(height: AppSizes.spaceM),

              // Quill 읽기 전용 뷰어 (실제 _MemoViewer와 동일)
              QuillEditor(
                key: _checkItemKey,
                controller: _quillController,
                focusNode: FocusNode(),
                scrollController: ScrollController(),
                config: const QuillEditorConfig(
                  autoFocus: false,
                  expands: false,
                  scrollable: false,
                  padding: EdgeInsets.zero,
                  showCursor: false,
                  checkBoxReadOnly: true,
                ),
              ),
            ],
          ),
        ),
      ),
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
