import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:family_planner/features/main/task/data/models/holiday_model.dart';
import 'package:family_planner/features/main/task/data/repositories/holiday_repository.dart';

part 'holiday_provider.g.dart';

@riverpod
Future<List<HolidayModel>> holidays(Ref ref, int year, int month) async {
  final repository = ref.watch(holidayRepositoryProvider);
  return repository.getHolidays(year, month);
}

@riverpod
Future<List<SpecialDayModel>> specialDays(Ref ref, int year, int month) async {
  final repository = ref.watch(holidayRepositoryProvider);
  return repository.getSpecialDays(year, month);
}

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

@riverpod
AsyncValue<Map<String, SpecialDayModel>> specialDayMapForMonth(
  Ref ref,
  int year,
  int month,
) {
  return ref.watch(specialDaysProvider(year, month)).whenData(
        (days) => {for (final d in days) d.date: d},
      );
}
