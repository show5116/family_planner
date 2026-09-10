import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/features/main/diary/data/models/diary_models.dart';
import 'package:family_planner/features/main/diary/data/repositories/diary_repository.dart';
import 'package:family_planner/features/main/diary/data/utils/diary_date.dart';

// ── 필터 상태 ────────────────────────────────────────────────────────────────

/// 목록에서 선택된 그룹 필터 (null이면 그룹으로 좁히지 않음)
final diarySelectedGroupIdProvider = StateProvider<String?>((ref) => null);

/// 공개 범위 필터 (null이면 전체)
///
/// "내 일기만 보기"를 위해 필요하다. 그룹 일기가 섞여 있는 줄 모르고 쓰면
/// 사생활 사고가 나므로, 걸러낼 수단이 항상 있어야 한다.
final diaryVisibilityFilterProvider =
    StateProvider<DiaryVisibility?>((ref) => null);

/// 목록 검색어
final diarySearchQueryProvider = StateProvider<String>((ref) => '');

/// 검색·필터가 걸려 있는지
///
/// 빈 목록의 문구를 가르는 데 쓴다. 필터 때문에 비었는데 "첫 기록을 남겨보세요"라고
/// 하면 이미 쓴 일기가 사라진 줄 알게 된다.
final diaryHasActiveFilterProvider = Provider<bool>((ref) {
  return ref.watch(diarySearchQueryProvider).isNotEmpty ||
      ref.watch(diarySelectedGroupIdProvider) != null ||
      ref.watch(diaryVisibilityFilterProvider) != null;
});

// ── 타임라인 목록 ────────────────────────────────────────────────────────────

/// 무한 스크롤 목록 상태
class DiaryListState {
  final List<DiaryModel> items;
  final int page;
  final bool hasMore;
  final bool isLoadingMore;

  const DiaryListState({
    this.items = const [],
    this.page = 1,
    this.hasMore = false,
    this.isLoadingMore = false,
  });

  DiaryListState copyWith({
    List<DiaryModel>? items,
    int? page,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return DiaryListState(
      items: items ?? this.items,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

final diaryListProvider =
    AsyncNotifierProvider<DiaryListNotifier, DiaryListState>(
        DiaryListNotifier.new);

class DiaryListNotifier extends AsyncNotifier<DiaryListState> {
  @override
  Future<DiaryListState> build() async {
    final groupId = ref.watch(diarySelectedGroupIdProvider);
    final visibility = ref.watch(diaryVisibilityFilterProvider);
    final search = ref.watch(diarySearchQueryProvider);

    final result = await ref.read(diaryRepositoryProvider).getDiaries(
          page: 1,
          groupId: groupId,
          visibility: visibility,
          search: search,
        );

    return DiaryListState(
      items: result.items,
      page: result.page,
      hasMore: result.hasMore,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => future);
  }

  /// 다음 페이지 로드 (무한 스크롤)
  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));

    try {
      final result = await ref.read(diaryRepositoryProvider).getDiaries(
            page: current.page + 1,
            groupId: ref.read(diarySelectedGroupIdProvider),
            visibility: ref.read(diaryVisibilityFilterProvider),
            search: ref.read(diarySearchQueryProvider),
          );

      state = AsyncData(current.copyWith(
        items: [...current.items, ...result.items],
        page: result.page,
        hasMore: result.hasMore,
        isLoadingMore: false,
      ));
    } catch (_) {
      // 추가 로드 실패는 목록 전체를 에러로 만들지 않는다 (이미 보던 것은 유지)
      state = AsyncData(current.copyWith(isLoadingMore: false));
      rethrow;
    }
  }

  /// 목록에 일기를 추가하거나 갱신한다 (날짜 역순 유지)
  ///
  /// 빠른 기록·생성·수정 후 목록을 다시 받아오지 않고 화면만 맞추기 위한 것.
  void upsert(DiaryModel diary) {
    final current = state.value;
    if (current == null) return;

    final index = current.items.indexWhere((d) => d.id == diary.id);
    final next = [...current.items];

    if (index >= 0) {
      next[index] = diary;
    } else {
      next.add(diary);
      // 날짜 역순 — 과거 날짜에 기록했을 수도 있으므로 정렬을 다시 맞춘다
      next.sort((a, b) => b.date.compareTo(a.date));
    }

    state = AsyncData(current.copyWith(items: next));
  }

  /// 목록에서 일기를 제거한다
  void removeById(String id) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(current.copyWith(
      items: current.items.where((d) => d.id != id).toList(),
    ));
  }
}

// ── 상세 ────────────────────────────────────────────────────────────────────

final diaryDetailProvider =
    FutureProvider.family<DiaryModel, String>((ref, id) async {
  return ref.read(diaryRepositoryProvider).getDiary(id);
});

/// 오늘 일기 (빠른 기록 바의 placeholder 분기에 쓴다)
final todayDiaryProvider = FutureProvider<DiaryModel?>((ref) async {
  return ref.read(diaryRepositoryProvider).getDiaryByDate(diaryToday());
});

// ── 회고 · 연속 작성 ─────────────────────────────────────────────────────────

final diaryFlashbackProvider =
    FutureProvider<List<DiaryFlashbackItem>>((ref) async {
  return ref.read(diaryRepositoryProvider).getFlashback();
});

final diaryStreakProvider = FutureProvider<DiaryStreak>((ref) async {
  return ref.read(diaryRepositoryProvider).getStreak();
});

// ── 캘린더 ──────────────────────────────────────────────────────────────────

/// 캘린더에서 보고 있는 달
final diaryCalendarMonthProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month);
});

final diaryCalendarProvider =
    FutureProvider<List<DiaryCalendarDay>>((ref) async {
  final month = ref.watch(diaryCalendarMonthProvider);
  final groupId = ref.watch(diarySelectedGroupIdProvider);

  return ref.read(diaryRepositoryProvider).getCalendar(
        year: month.year,
        month: month.month,
        groupId: groupId,
      );
});

// ── 생성 · 수정 · 삭제 ───────────────────────────────────────────────────────

final diaryManagementProvider =
    AsyncNotifierProvider<DiaryManagementNotifier, void>(
        DiaryManagementNotifier.new);

class DiaryManagementNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<DiaryModel> create(CreateDiaryDto dto) async {
    final created =
        await ref.read(diaryRepositoryProvider).createDiary(dto);
    _invalidateAfterWrite();
    ref.read(diaryListProvider.notifier).upsert(created);
    return created;
  }

  Future<DiaryModel> edit(String id, UpdateDiaryDto dto) async {
    final updated =
        await ref.read(diaryRepositoryProvider).updateDiary(id, dto);
    _invalidateAfterWrite();
    ref.read(diaryListProvider.notifier).upsert(updated);
    ref.invalidate(diaryDetailProvider(id));
    return updated;
  }

  Future<void> delete(String id) async {
    await ref.read(diaryRepositoryProvider).deleteDiary(id);
    _invalidateAfterWrite();
    ref.read(diaryListProvider.notifier).removeById(id);
  }

  Future<DiaryModel> restore(String id) async {
    final restored =
        await ref.read(diaryRepositoryProvider).restoreDiary(id);
    _invalidateAfterWrite();
    ref.read(diaryListProvider.notifier).upsert(restored);
    return restored;
  }

  /// 쓰기 후 파생 상태를 함께 갱신한다
  ///
  /// 목록은 낙관적으로 직접 손보므로 여기서 invalidate하지 않는다
  /// (스크롤 위치와 이미 불러온 페이지가 날아가기 때문).
  void _invalidateAfterWrite() {
    ref.invalidate(todayDiaryProvider);
    ref.invalidate(diaryCalendarProvider);
    ref.invalidate(diaryStreakProvider);
  }
}
