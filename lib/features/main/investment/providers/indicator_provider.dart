import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:family_planner/features/main/investment/data/models/indicator_model.dart';
import 'package:family_planner/features/main/investment/data/repositories/indicator_repository.dart';

part 'indicator_provider.g.dart';

/// 전체 지표 목록 Provider
@riverpod
class Indicators extends _$Indicators {
  @override
  Future<List<IndicatorModel>> build() async {
    final repository = ref.watch(indicatorRepositoryProvider);
    final list = await repository.getIndicators();
    return _sorted(list);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final list = await ref.read(indicatorRepositoryProvider).getIndicators();
      return _sorted(list);
    });
  }

  List<IndicatorModel> _sorted(List<IndicatorModel> list) {
    final sorted = [...list];
    sorted.sort((a, b) {
      if (a.isBookmarked == b.isBookmarked) return 0;
      return a.isBookmarked ? -1 : 1;
    });
    return sorted;
  }

  /// 즐겨찾기 토글 (로컬 상태 즉시 반영)
  Future<void> toggleBookmark(String symbol) async {
    if (!state.hasValue) return;
    final current = state.value!;
    final index = current.indexWhere((e) => e.symbol == symbol);
    if (index == -1) return;

    final isBookmarked = current[index].isBookmarked;
    final repository = ref.read(indicatorRepositoryProvider);

    try {
      final updated = isBookmarked
          ? await repository.removeBookmark(symbol)
          : await repository.addBookmark(symbol);

      final newList = current.map((e) => e.symbol == symbol ? updated : e).toList();
      state = AsyncValue.data(_sorted(newList));
    } catch (_) {
      // 에러 시 이전 상태 복원 (state를 error로 만들지 않음)
      state = AsyncValue.data(current);
    }
  }
}

/// 지표 시세 히스토리 Provider (symbol별)
@riverpod
Future<IndicatorHistoryModel> indicatorHistory(
  Ref ref,
  String symbol, {
  int days = 30,
}) async {
  final repository = ref.watch(indicatorRepositoryProvider);
  return repository.getIndicatorHistory(symbol, days: days);
}

/// 즐겨찾기 지표 목록 Provider
@riverpod
class BookmarkedIndicators extends _$BookmarkedIndicators {
  @override
  Future<List<IndicatorModel>> build() async {
    final repository = ref.watch(indicatorRepositoryProvider);
    return repository.getBookmarkedIndicators();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(indicatorRepositoryProvider).getBookmarkedIndicators(),
    );
  }
}
