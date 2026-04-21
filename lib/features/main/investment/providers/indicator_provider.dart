import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:family_planner/features/main/investment/data/models/indicator_model.dart';
import 'package:family_planner/features/main/investment/data/models/market_briefing_model.dart';
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

  /// 즐겨찾기 순서 변경 (로컬 상태 즉시 반영 후 API 저장)
  Future<void> reorderBookmarks(int oldIndex, int newIndex) async {
    if (!state.hasValue) return;
    final current = state.value!;

    final bookmarked = current.where((e) => e.isBookmarked).toList();
    final unbookmarked = current.where((e) => !e.isBookmarked).toList();

    final reordered = [...bookmarked];
    final item = reordered.removeAt(oldIndex);
    reordered.insert(newIndex, item);

    state = AsyncValue.data([...reordered, ...unbookmarked]);

    try {
      await ref.read(indicatorRepositoryProvider).reorderBookmarks(
            reordered.map((e) => e.symbol).toList(),
          );
    } catch (_) {
      state = AsyncValue.data(current);
    }
  }

  /// 즐겨찾기 토글 (낙관적 즉시 반영 → API → 재조회 확정)
  Future<void> toggleBookmark(String symbol) async {
    if (!state.hasValue) return;
    final current = state.value!;
    final index = current.indexWhere((e) => e.symbol == symbol);
    if (index == -1) return;

    final isBookmarked = current[index].isBookmarked;
    final repository = ref.read(indicatorRepositoryProvider);

    // 낙관적 업데이트: 즉시 UI 반영
    final optimistic = current.map((e) {
      if (e.symbol != symbol) return e;
      return e.copyWith(isBookmarked: !isBookmarked);
    }).toList();
    state = AsyncValue.data(_sorted(optimistic));

    try {
      if (isBookmarked) {
        await repository.removeBookmark(symbol);
      } else {
        await repository.addBookmark(symbol);
      }
      // 서버 기준으로 확정
      final refreshed = await repository.getIndicators();
      state = AsyncValue.data(_sorted(refreshed));
      // 대시보드 즐겨찾기 위젯도 갱신
      ref.read(bookmarkedIndicatorsProvider.notifier).refresh();
    } catch (_) {
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

  // days=1: 주말/공휴일 대비 여유분(3일)으로 요청 후 마지막 거래일만 필터링 (KST 기준)
  if (days == 1) {
    final raw = await repository.getIndicatorHistory(symbol, days: 3);
    if (raw.history.isEmpty) return raw;

    DateTime kstDate(DateTime dt) {
      final kst = dt.toUtc().add(const Duration(hours: 9));
      return DateTime(kst.year, kst.month, kst.day);
    }

    bool isMarketHour(DateTime dt) {
      final kst = dt.toUtc().add(const Duration(hours: 9));
      return kst.hour >= 9 && kst.hour < 16;
    }

    // 장 시간(09:00~16:00 KST) 데이터가 있는 마지막 날을 기준으로 필터링
    // (장 마감 후 새벽에 종가가 다시 기록되어 날짜가 넘어가는 케이스 방지)
    final marketPoints = raw.history.where((p) => isMarketHour(p.recordedAt));
    final basePoints = marketPoints.isNotEmpty ? marketPoints : raw.history;
    final lastDate = basePoints
        .map((p) => p.recordedAt)
        .reduce((a, b) => a.isAfter(b) ? a : b);
    final lastDay = kstDate(lastDate);

    final filteredHistory = raw.history
        .where((p) => kstDate(p.recordedAt) == lastDay)
        .toList();

    final filteredSpread = raw.spreadHistory
        .where((p) => kstDate(p.recordedAt) == lastDay)
        .toList();

    return IndicatorHistoryModel(
      symbol: raw.symbol,
      nameKo: raw.nameKo,
      history: filteredHistory,
      spreadHistory: filteredSpread,
    );
  }

  return repository.getIndicatorHistory(symbol, days: days);
}

/// 스파크라인용 당일 히스토리 Provider (symbol별, days=1)
@riverpod
Future<List<double>> indicatorSparkline(Ref ref, String symbol) async {
  final repository = ref.watch(indicatorRepositoryProvider);
  // days=3: 주말/공휴일에도 직전 거래일 데이터가 포함되도록 여유분 확보
  final history = await repository.getIndicatorHistory(symbol, days: 3);
  if (history.history.isEmpty) return [];

  // 가장 최근 거래일 하루치만 필터링 (KST 기준: UTC+9)
  DateTime kstDate(DateTime dt) {
    final kst = dt.toUtc().add(const Duration(hours: 9));
    return DateTime(kst.year, kst.month, kst.day);
  }

  bool isMarketHour(DateTime dt) {
    final kst = dt.toUtc().add(const Duration(hours: 9));
    return kst.hour >= 9 && kst.hour < 16;
  }

  // 장 시간 데이터 기준으로 마지막 날을 결정 (새벽 종가 재기록으로 날짜 넘어가는 케이스 방지)
  final marketPoints = history.history.where((p) => isMarketHour(p.recordedAt));
  final basePoints = marketPoints.isNotEmpty ? marketPoints : history.history;
  final lastDate = basePoints
      .map((p) => p.recordedAt)
      .reduce((a, b) => a.isAfter(b) ? a : b);
  final lastDay = kstDate(lastDate);
  final dayPoints = history.history
      .where((p) => kstDate(p.recordedAt) == lastDay)
      .map((p) => p.price)
      .toList();

  if (dayPoints.isEmpty) return [];
  final deduped = <double>[dayPoints.first];
  for (var i = 1; i < dayPoints.length; i++) {
    if (dayPoints[i] != dayPoints[i - 1]) {
      deduped.add(dayPoints[i]);
    }
  }
  return deduped;
}

/// [어드민] 과거 데이터 일괄 초기화 Provider
@riverpod
Future<InitHistoryResult> initIndicatorHistory(
  Ref ref, {
  int? days,
}) async {
  final repository = ref.read(indicatorRepositoryProvider);
  return repository.initHistory(days: days);
}

/// AI 시황 브리핑 Provider
@riverpod
class MarketBriefing extends _$MarketBriefing {
  @override
  Future<MarketBriefingModel> build() async {
    final repository = ref.watch(indicatorRepositoryProvider);
    return repository.getMarketBriefing();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(indicatorRepositoryProvider).getMarketBriefing(),
    );
  }
}

/// 즐겨찾기 지표 목록 Provider
@Riverpod(keepAlive: true)
class BookmarkedIndicators extends _$BookmarkedIndicators {
  Timer? _cacheTimer;

  @override
  Future<List<IndicatorModel>> build() async {
    _cacheTimer?.cancel();
    _cacheTimer = Timer(const Duration(minutes: 5), () => ref.invalidateSelf());

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
