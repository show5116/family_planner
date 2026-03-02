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
    return repository.getIndicators();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(indicatorRepositoryProvider).getIndicators(),
    );
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

      state = AsyncValue.data(
        current.map((e) => e.symbol == symbol ? updated : e).toList(),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
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
