import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:family_planner/features/main/task/data/models/holiday_model.dart';
import 'package:family_planner/features/main/task/data/repositories/holiday_repository.dart';

part 'holiday_provider.g.dart';

/// 특정 연월의 공휴일 목록 Provider
/// 캐시 우선 조회, 만료 시 백그라운드 재검증
@riverpod
Future<List<HolidayModel>> holidays(Ref ref, int year, int month) async {
  final repository = ref.watch(holidayRepositoryProvider);
  return repository.getHolidays(year, month);
}

/// 특정 날짜가 공휴일인지 확인하는 Provider
/// date 형식: 'YYYY-MM-DD'
@riverpod
AsyncValue<HolidayModel?> holidayForDate(Ref ref, DateTime date) {
  final year = date.year;
  final month = date.month;
  final dateStr =
      '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  return ref.watch(holidaysProvider(year, month)).whenData(
        (holidays) => holidays.where((h) => h.date == dateStr).firstOrNull,
      );
}

/// 특정 연월의 공휴일을 날짜 문자열 기준 Map으로 제공하는 Provider
/// 캘린더 렌더링 시 O(1) 조회용
@riverpod
AsyncValue<Map<String, HolidayModel>> holidayMapForMonth(
  Ref ref,
  int year,
  int month,
) {
  return ref.watch(holidaysProvider(year, month)).whenData(
        (holidays) => {for (final h in holidays) h.date: h},
      );
}
