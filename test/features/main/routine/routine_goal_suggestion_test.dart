import 'package:flutter_test/flutter_test.dart';

import 'package:family_planner/features/main/routine/data/models/routine_model.dart';
import 'package:family_planner/features/main/routine/presentation/widgets/routine_goal_suggestion_dialog.dart';

RoutineDailyStreak _streak({
  required int achievedDays,
  required int exceededDays,
  required int totalDays,
  num averageCheckedCount = 0,
}) {
  return RoutineDailyStreak(
    currentStreakDays: 0,
    longestStreakDays: 0,
    todayAchieved: false,
    todayCheckedCount: 0,
    todayTargetCount: 0,
    recent14Days: RoutineRecent14Days(
      achievedDays: achievedDays,
      exceededDays: exceededDays,
      totalDays: totalDays,
      averageCheckedCount: averageCheckedCount,
    ),
  );
}

const _countSettings = RoutineSettings(
  dailyGoalMode: RoutineDailyGoalMode.count,
  dailyGoalCount: 5,
);

void main() {
  group('evaluateGoalSuggestion', () {
    test('ALL 모드면 제안하지 않는다', () {
      final result = evaluateGoalSuggestion(
        settings: const RoutineSettings(
          dailyGoalMode: RoutineDailyGoalMode.all,
        ),
        streak: _streak(
          achievedDays: 12,
          exceededDays: 12,
          totalDays: 14,
          averageCheckedCount: 9,
        ),
        includedRoutines: 10,
      );
      expect(result, isNull);
    });

    test('표본(집계 대상 일수)이 7일 미만이면 제안하지 않는다', () {
      final result = evaluateGoalSuggestion(
        settings: _countSettings,
        streak: _streak(
          achievedDays: 6,
          exceededDays: 6,
          totalDays: 6,
          averageCheckedCount: 9,
        ),
        includedRoutines: 10,
      );
      expect(result, isNull);
    });

    test('14일 중 10일 이상 초과 달성하면 상향을 제안한다', () {
      final result = evaluateGoalSuggestion(
        settings: _countSettings,
        streak: _streak(
          achievedDays: 12,
          exceededDays: 11,
          totalDays: 14,
          averageCheckedCount: 6,
        ),
        includedRoutines: 10,
      );
      expect(result, isNotNull);
      expect(result!.kind, RoutineGoalSuggestionKind.raise);
      expect(result.currentCount, 5);
      // 평균(6)이 목표+2(7)보다 작으므로 평균을 따른다.
      expect(result.suggestedCount, 6);
    });

    test('상향 제안은 포함 습관 수를 넘지 않는다', () {
      final result = evaluateGoalSuggestion(
        settings: _countSettings,
        streak: _streak(
          achievedDays: 13,
          exceededDays: 13,
          totalDays: 14,
          // 평균이 포함 습관 수보다 크게 나와도 상한에 걸려야 한다.
          averageCheckedCount: 20,
        ),
        includedRoutines: 6,
      );
      expect(result, isNotNull);
      expect(result!.suggestedCount, 6);
    });

    test('이미 목표가 포함 습관 수와 같으면 상향을 제안하지 않는다', () {
      final result = evaluateGoalSuggestion(
        settings: _countSettings,
        streak: _streak(
          achievedDays: 13,
          exceededDays: 13,
          totalDays: 14,
          averageCheckedCount: 8,
        ),
        includedRoutines: 5,
      );
      expect(result, isNull);
    });

    test('달성률이 30% 미만이면 하향을 제안한다', () {
      final result = evaluateGoalSuggestion(
        settings: _countSettings,
        streak: _streak(
          achievedDays: 3,
          exceededDays: 0,
          totalDays: 14,
          averageCheckedCount: 2,
        ),
        includedRoutines: 10,
      );
      expect(result, isNotNull);
      expect(result!.kind, RoutineGoalSuggestionKind.lower);
      expect(result.currentCount, 5);
      expect(result.suggestedCount, 2);
    });

    test('달성률이 보통이면(30~) 아무 제안도 하지 않는다', () {
      final result = evaluateGoalSuggestion(
        settings: _countSettings,
        streak: _streak(
          achievedDays: 8,
          exceededDays: 2,
          totalDays: 14,
          averageCheckedCount: 5,
        ),
        includedRoutines: 10,
      );
      expect(result, isNull);
    });

    test('목표가 1이면 더 낮출 수 없어 하향을 제안하지 않는다', () {
      final result = evaluateGoalSuggestion(
        settings: const RoutineSettings(
          dailyGoalMode: RoutineDailyGoalMode.count,
          dailyGoalCount: 1,
        ),
        streak: _streak(
          achievedDays: 1,
          exceededDays: 0,
          totalDays: 14,
          averageCheckedCount: 0,
        ),
        includedRoutines: 10,
      );
      expect(result, isNull);
    });
  });
}
