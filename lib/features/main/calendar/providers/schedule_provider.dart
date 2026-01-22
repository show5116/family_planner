import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:family_planner/features/main/calendar/data/models/schedule_model.dart';
import 'package:family_planner/features/main/calendar/data/repositories/schedule_repository.dart';

part 'schedule_provider.g.dart';

/// 현재 선택된 날짜 Provider
final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

/// 현재 보고 있는 월 Provider (캘린더 페이지 이동용)
final focusedMonthProvider = StateProvider<DateTime>((ref) => DateTime.now());

/// 월간 일정 Provider
@riverpod
class MonthlySchedules extends _$MonthlySchedules {
  @override
  Future<List<ScheduleModel>> build(int year, int month) async {
    final repository = ref.watch(scheduleRepositoryProvider);
    return await repository.getMonthlySchedules(year: year, month: month);
  }

  /// 일정 새로고침
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(scheduleRepositoryProvider);
      return await repository.getMonthlySchedules(year: year, month: month);
    });
  }

  /// 일정 추가 후 갱신
  void addSchedule(ScheduleModel schedule) {
    if (!state.hasValue) return;

    final schedules = List<ScheduleModel>.from(state.value!);
    schedules.add(schedule);
    state = AsyncValue.data(schedules);
  }

  /// 일정 수정 후 갱신
  void updateSchedule(ScheduleModel schedule) {
    if (!state.hasValue) return;

    final schedules = List<ScheduleModel>.from(state.value!);
    final index = schedules.indexWhere((s) => s.id == schedule.id);
    if (index != -1) {
      schedules[index] = schedule;
      state = AsyncValue.data(schedules);
    }
  }

  /// 일정 삭제 후 갱신
  void removeSchedule(String scheduleId) {
    if (!state.hasValue) return;

    final schedules = List<ScheduleModel>.from(state.value!);
    schedules.removeWhere((s) => s.id == scheduleId);
    state = AsyncValue.data(schedules);
  }
}

/// 선택된 날짜의 일정 Provider
@riverpod
Future<List<ScheduleModel>> selectedDateSchedules(
  SelectedDateSchedulesRef ref,
) async {
  final selectedDate = ref.watch(selectedDateProvider);
  final schedules = ref.watch(
    monthlySchedulesProvider(selectedDate.year, selectedDate.month),
  );

  return schedules.maybeWhen(
    data: (list) {
      // 선택된 날짜의 일정만 필터링
      return list.where((schedule) {
        final startDate = DateTime(
          schedule.startDate.year,
          schedule.startDate.month,
          schedule.startDate.day,
        );
        final endDate = schedule.endDate != null
            ? DateTime(
                schedule.endDate!.year,
                schedule.endDate!.month,
                schedule.endDate!.day,
              )
            : startDate;

        final selected = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
        );

        // 선택된 날짜가 일정 기간에 포함되는지 확인
        return !selected.isBefore(startDate) && !selected.isAfter(endDate);
      }).toList();
    },
    orElse: () => <ScheduleModel>[],
  );
}

/// 특정 날짜의 일정 개수 Provider (캘린더 마커용)
@riverpod
Map<DateTime, int> scheduleCountByDate(
  ScheduleCountByDateRef ref,
  int year,
  int month,
) {
  final schedules = ref.watch(monthlySchedulesProvider(year, month));

  return schedules.maybeWhen(
    data: (list) {
      final Map<DateTime, int> countMap = {};

      for (final schedule in list) {
        final startDate = DateTime(
          schedule.startDate.year,
          schedule.startDate.month,
          schedule.startDate.day,
        );
        final endDate = schedule.endDate != null
            ? DateTime(
                schedule.endDate!.year,
                schedule.endDate!.month,
                schedule.endDate!.day,
              )
            : startDate;

        // 일정이 걸쳐있는 모든 날짜에 카운트 증가
        for (var date = startDate;
            !date.isAfter(endDate);
            date = date.add(const Duration(days: 1))) {
          countMap[date] = (countMap[date] ?? 0) + 1;
        }
      }

      return countMap;
    },
    orElse: () => <DateTime, int>{},
  );
}

/// 일정 상세 Provider
@riverpod
Future<ScheduleModel> scheduleDetail(
  ScheduleDetailRef ref,
  String id,
) async {
  final repository = ref.watch(scheduleRepositoryProvider);
  return await repository.getScheduleById(id);
}

/// 일정 관리 Notifier
class ScheduleManagementNotifier extends StateNotifier<AsyncValue<void>> {
  final ScheduleRepository _repository;
  final Ref _ref;

  ScheduleManagementNotifier(this._repository, this._ref)
      : super(const AsyncValue.data(null));

  /// 일정 생성
  Future<ScheduleModel?> createSchedule(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      final schedule = await _repository.createSchedule(data);

      // 해당 월의 일정 목록 갱신
      _ref
          .read(monthlySchedulesProvider(
            schedule.startDate.year,
            schedule.startDate.month,
          ).notifier)
          .addSchedule(schedule);

      state = const AsyncValue.data(null);
      return schedule;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// 일정 수정
  Future<ScheduleModel?> updateSchedule(
    String id,
    Map<String, dynamic> data,
  ) async {
    state = const AsyncValue.loading();
    try {
      final schedule = await _repository.updateSchedule(id, data);

      // 해당 월의 일정 목록 갱신
      _ref
          .read(monthlySchedulesProvider(
            schedule.startDate.year,
            schedule.startDate.month,
          ).notifier)
          .updateSchedule(schedule);

      // 상세 Provider 무효화
      _ref.invalidate(scheduleDetailProvider(id));

      state = const AsyncValue.data(null);
      return schedule;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// 일정 삭제
  Future<bool> deleteSchedule(String id, DateTime scheduleDate) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteSchedule(id);

      // 해당 월의 일정 목록 갱신
      _ref
          .read(monthlySchedulesProvider(
            scheduleDate.year,
            scheduleDate.month,
          ).notifier)
          .removeSchedule(id);

      // 상세 Provider 무효화
      _ref.invalidate(scheduleDetailProvider(id));

      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

/// 일정 관리 Provider
final scheduleManagementProvider =
    StateNotifierProvider<ScheduleManagementNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(scheduleRepositoryProvider);
  return ScheduleManagementNotifier(repository, ref);
});
