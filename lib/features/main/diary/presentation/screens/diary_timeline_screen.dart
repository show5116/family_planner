import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/main/diary/data/models/diary_models.dart';
import 'package:family_planner/features/main/diary/data/utils/diary_date.dart';
import 'package:family_planner/features/main/diary/presentation/widgets/diary_calendar_view.dart';
import 'package:family_planner/features/main/diary/presentation/widgets/diary_card.dart';
import 'package:family_planner/features/main/diary/presentation/widgets/diary_photo_grid.dart';
import 'package:family_planner/features/main/diary/presentation/widgets/flashback_card.dart';
import 'package:family_planner/features/main/diary/presentation/widgets/quick_capture_bar.dart';
import 'package:family_planner/features/main/diary/providers/diary_provider.dart';
import 'package:family_planner/shared/widgets/app_empty_state.dart';
import 'package:family_planner/features/onboarding/presentation/widgets/feature_coach_mark.dart';
import 'package:family_planner/features/onboarding/services/onboarding_service.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/shared/widgets/app_bar_more_menu.dart';
import 'package:family_planner/shared/widgets/app_error_state.dart';
import 'package:family_planner/shared/widgets/app_search_bar.dart';
import 'package:family_planner/shared/widgets/group_filter_bar.dart';

part '_diary_onboarding.dart';

/// 다이어리 메인 — 타임라인 + 빠른 기록 바
///
/// 읽기(들춰보기)와 쓰기(던지기)를 한 화면에서 처리한다. FAB를 두지 않는 이유는
/// 하단 입력창이 그 역할을 대신하기 때문이다.
class DiaryTimelineScreen extends ConsumerStatefulWidget {
  const DiaryTimelineScreen({super.key});

  @override
  ConsumerState<DiaryTimelineScreen> createState() =>
      _DiaryTimelineScreenState();
}

/// 뷰 3종 — 기본은 타임라인
///
/// 캘린더를 기본에서 뺀 이유: 캘린더는 **날짜를 이미 알 때** 쓰는 뷰다.
/// 대부분의 열람은 "그냥 보고 싶어서"이므로 타임라인이 기본이어야 한다.
enum _DiaryView { timeline, photos, calendar }

class _DiaryTimelineScreenState extends ConsumerState<DiaryTimelineScreen> {
  final ScrollController _scrollController = ScrollController();
  _DiaryView _view = _DiaryView.timeline;
  bool _isSearching = false;

  // 코치마크 타겟
  final GlobalKey _captureBarKey = GlobalKey();
  final GlobalKey _firstCardKey = GlobalKey();
  final GlobalKey _flashbackKey = GlobalKey();

  /// 코치마크 타겟으로 삼을 첫 카드 (렌더 중에 정해진다)
  _DiaryEntry? _firstDiaryEntry;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _maybeStartOnboarding();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 300) {
      ref.read(diaryListProvider.notifier).loadMore();
    }
  }

  /// 검색창 열고 닫기
  ///
  /// 닫을 때 검색어를 비운다 — 창만 접히고 결과가 걸러진 채 남아 있으면
  /// 목록이 왜 비어 보이는지 알 수 없다.
  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        ref.read(diarySearchQueryProvider.notifier).state = '';
      }
    });
  }

  /// 다음 뷰로 넘긴다 (타임라인 → 사진 → 캘린더 → 타임라인)
  ///
  /// 뷰가 3종이라 아이콘 하나로 토글하면 어디로 가는지 알 수 없다.
  /// 버튼 아이콘이 **다음에 갈 뷰**를 가리키게 해서 방향을 드러낸다.
  void _cycleView() {
    setState(() {
      _view = switch (_view) {
        _DiaryView.timeline => _DiaryView.photos,
        _DiaryView.photos => _DiaryView.calendar,
        _DiaryView.calendar => _DiaryView.timeline,
      };
    });
  }

  IconData get _viewIcon => switch (_view) {
        _DiaryView.timeline => Icons.photo_library_outlined,
        _DiaryView.photos => Icons.calendar_month_outlined,
        _DiaryView.calendar => Icons.view_agenda_outlined,
      };

  String _viewTooltip(AppLocalizations l10n) => switch (_view) {
        _DiaryView.timeline => l10n.diary_view_photos,
        _DiaryView.photos => l10n.diary_view_calendar,
        _DiaryView.calendar => l10n.diary_view_timeline,
      };

  /// 코치마크 다시 보기 (더보기 메뉴)
  void _replayOnboarding() {
    setState(() => _view = _DiaryView.timeline);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showCoachMark(forceShow: true);
    });
  }

  Future<void> _refresh() async {
    ref.invalidate(diaryFlashbackProvider);
    await ref.read(diaryListProvider.notifier).refresh();
  }

  void _openDetail(String id) {
    context.push('${AppRoutes.diary}/$id');
  }

  /// 캘린더에서 날짜를 눌렀을 때
  ///
  /// 기록이 하나면 바로 상세로, 여러 명이 쓴 날이면 골라서 열게 한다.
  void _onCalendarDayTap(String date, List<DiaryCalendarDay> entries) {
    if (entries.isEmpty) return;
    if (entries.length == 1) {
      _openDetail(entries.first.diaryId);
      return;
    }
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: entries
              .map(
                (e) => ListTile(
                  leading: Text(
                    e.mood ?? '',
                    style: const TextStyle(fontSize: 20),
                  ),
                  title: Text(e.authorName),
                  onTap: () {
                    Navigator.pop(context);
                    _openDetail(e.diaryId);
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final listState = ref.watch(diaryListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.diary_title),
        actions: [
          // 캘린더는 날짜로 찾는 뷰라 검색이 겹친다 — 목록 계열에서만 연다
          if (_view != _DiaryView.calendar)
            IconButton(
              icon: const Icon(Icons.search),
              tooltip: l10n.common_search,
              onPressed: _toggleSearch,
            ),
          IconButton(
            icon: Icon(_viewIcon),
            tooltip: _viewTooltip(l10n),
            onPressed: _cycleView,
          ),
          AppBarMoreMenu(
            onReplayOnboarding: _replayOnboarding,
            extraItems: [
              MoreMenuItem(
                id: 'diary-storage',
                icon: Icons.sd_storage_outlined,
                label: l10n.diary_storage_manage,
                onTap: (context) => context.push(AppRoutes.diaryStorage),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isSearching && _view != _DiaryView.calendar)
            AppSearchBar(
              hintText: l10n.diary_search_hint,
              initialQuery: ref.read(diarySearchQueryProvider),
              onSearch: (query) {
                ref.read(diarySearchQueryProvider.notifier).state = query ?? '';
              },
              onClose: _toggleSearch,
            ),
          // 그룹 일기가 섞여 있는 줄 모르고 쓰면 사생활 사고가 난다.
          // 걸러낼 수단은 뷰와 무관하게 항상 보여야 한다.
          ColoredBox(
            color: Theme.of(context).colorScheme.surfaceContainerLowest,
            child: const _DiaryGroupFilterBar(),
          ),
          Expanded(
            child: switch (_view) {
              _DiaryView.calendar =>
                DiaryCalendarView(onDayTap: _onCalendarDayTap),
              _DiaryView.photos => DiaryPhotoGrid(onDiaryTap: _openDetail),
              _DiaryView.timeline => listState.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, _) => AppErrorState(
                    error: error,
                    title: l10n.diary_load_error,
                    onRetry: _refresh,
                  ),
                  data: (state) => RefreshIndicator(
                    onRefresh: _refresh,
                    child: _buildTimeline(state),
                  ),
                ),
            },
          ),
        ],
      ),
      bottomNavigationBar: QuickCaptureBar(key: _captureBarKey),
    );
  }

  Widget _buildTimeline(DiaryListState state) {
    final l10n = AppLocalizations.of(context)!;
    final flashback = ref.watch(diaryFlashbackProvider).valueOrNull;
    final flashbackItem =
        (flashback != null && flashback.isNotEmpty) ? flashback.first : null;

    // 빈 상태에서도 스크롤이 가능해야 당겨서 새로고침이 동작한다
    if (state.items.isEmpty) {
      return ListView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          if (flashbackItem != null)
            FlashbackCard(
              key: _flashbackKey,
              item: flashbackItem,
              onTap: () => _openDetail(flashbackItem.id),
            ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.5,
            child: ref.watch(diaryHasActiveFilterProvider)
                // 필터 때문에 비었는데 "첫 기록을 남겨보세요"라고 하면
                // 이미 쓴 일기가 사라진 줄 알게 된다
                ? AppEmptyState(
                    icon: Icons.search_off,
                    message: l10n.diary_search_empty,
                  )
                : AppEmptyState(
                    icon: Icons.auto_stories_outlined,
                    message: l10n.diary_empty,
                    subtitle: l10n.diary_empty_subtitle,
                  ),
          ),
        ],
      );
    }

    final entries = _buildEntries(state.items);
    _firstDiaryEntry =
        entries.whereType<_DiaryEntry>().firstOrNull;

    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: AppSizes.spaceL),
      itemCount: entries.length +
          (flashbackItem != null ? 1 : 0) +
          (state.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        var cursor = index;

        if (flashbackItem != null) {
          if (cursor == 0) {
            return FlashbackCard(
              key: _flashbackKey,
              item: flashbackItem,
              onTap: () => _openDetail(flashbackItem.id),
            );
          }
          cursor -= 1;
        }

        if (cursor >= entries.length) {
          return const Padding(
            padding: EdgeInsets.all(AppSizes.spaceM),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final entry = entries[cursor];
        return switch (entry) {
          _MonthHeader(:final label) => _MonthDivider(label: label),
          // 첫 카드에만 코치마크 타겟 키를 단다
          _DiaryEntry(:final diary) => DiaryCard(
              key: identical(entry, _firstDiaryEntry) ? _firstCardKey : null,
              diary: diary,
              onTap: () => _openDetail(diary.id),
            ),
        };
      },
    );
  }

  /// 월 구분선을 끼워 넣은 표시용 목록을 만든다
  List<_TimelineEntry> _buildEntries(List<DiaryModel> items) {
    final entries = <_TimelineEntry>[];
    String? currentMonth;

    for (final diary in items) {
      // 'YYYY-MM-DD'에서 'YYYY-MM'만 잘라 월이 바뀌는 지점을 찾는다
      final month = diary.date.substring(0, 7);
      if (month != currentMonth) {
        currentMonth = month;
        entries.add(_MonthHeader(label: _formatMonth(diary.date)));
      }
      entries.add(_DiaryEntry(diary: diary));
    }

    return entries;
  }

  String _formatMonth(String date) {
    // 로케일을 고정하지 않는다 — 기기 언어에 맞춰 월 표기가 달라져야 한다
    final locale = Localizations.localeOf(context).toLanguageTag();
    return DateFormat.yMMMM(locale).format(parseDiaryDate(date));
  }
}

// ── 그룹 필터 바 ────────────────────────────────────────────────────────────

/// 다이어리 그룹 필터
///
/// 서버 목록 API는 `groupId` **또는** `visibility` 하나로만 좁힐 수 있어서,
/// 다중 선택은 단일 필터로 접어 넘긴다 (메모 화면과 같은 방식).
class _DiaryGroupFilterBar extends ConsumerWidget {
  const _DiaryGroupFilterBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GroupFilterBar(
      filterMode: FilterMode.withAll,
      savedKey: 'diary_group_filter',
      onMultiFilterChanged: (selection) {
        final groupId = ref.read(diarySelectedGroupIdProvider.notifier);
        final visibility = ref.read(diaryVisibilityFilterProvider.notifier);

        if (selection.isAll) {
          groupId.state = null;
          visibility.state = null;
          return;
        }

        final ids = selection.groupIds ?? const <String>[];

        // 개인만 골랐으면 비공개 일기로 좁힌다 ("내 일기만 보기")
        if (selection.includePersonal && ids.isEmpty) {
          groupId.state = null;
          visibility.state = DiaryVisibility.private;
          return;
        }

        // 그룹을 하나만 골랐을 때만 그 그룹으로 좁힌다.
        // 여러 개를 고르면 서버가 표현할 수 없어 전체로 둔다.
        groupId.state = ids.length == 1 ? ids.first : null;
        visibility.state = null;
      },
    );
  }
}

// ── 타임라인 표시 항목 ───────────────────────────────────────────────────────

sealed class _TimelineEntry {
  const _TimelineEntry();
}

class _MonthHeader extends _TimelineEntry {
  const _MonthHeader({required this.label});
  final String label;
}

class _DiaryEntry extends _TimelineEntry {
  const _DiaryEntry({required this.diary});
  final DiaryModel diary;
}

class _MonthDivider extends StatelessWidget {
  const _MonthDivider({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.spaceM,
        AppSizes.spaceL,
        AppSizes.spaceM,
        AppSizes.spaceS,
      ),
      child: Row(
        children: [
          Text(
            label,
            style: theme.textTheme.titleSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: AppSizes.spaceM),
          Expanded(
            child: Divider(
              color: colorScheme.outlineVariant,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
