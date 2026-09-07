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
import 'package:family_planner/features/main/diary/presentation/widgets/flashback_card.dart';
import 'package:family_planner/features/main/diary/presentation/widgets/quick_capture_bar.dart';
import 'package:family_planner/features/main/diary/providers/diary_provider.dart';
import 'package:family_planner/shared/widgets/app_empty_state.dart';
import 'package:family_planner/features/onboarding/presentation/widgets/feature_coach_mark.dart';
import 'package:family_planner/features/onboarding/services/onboarding_service.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/shared/widgets/app_bar_more_menu.dart';
import 'package:family_planner/shared/widgets/app_error_state.dart';

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

enum _DiaryView { timeline, calendar }

class _DiaryTimelineScreenState extends ConsumerState<DiaryTimelineScreen> {
  final ScrollController _scrollController = ScrollController();
  _DiaryView _view = _DiaryView.timeline;

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
          IconButton(
            icon: Icon(
              _view == _DiaryView.timeline
                  ? Icons.calendar_month_outlined
                  : Icons.view_agenda_outlined,
            ),
            tooltip: _view == _DiaryView.timeline
                ? l10n.diary_view_calendar
                : l10n.diary_view_timeline,
            onPressed: () => setState(() {
              _view = _view == _DiaryView.timeline
                  ? _DiaryView.calendar
                  : _DiaryView.timeline;
            }),
          ),
          AppBarMoreMenu(onReplayOnboarding: _replayOnboarding),
        ],
      ),
      body: _view == _DiaryView.calendar
          ? DiaryCalendarView(onDayTap: _onCalendarDayTap)
          : listState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
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
            child: AppEmptyState(
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
