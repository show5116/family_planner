import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:family_planner/features/main/routine/data/models/routine_model.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 목표 조정 제안의 방향
enum RoutineGoalSuggestionKind { raise, lower }

/// 목표 조정 제안 내용. [suggestedCount]로 바꾸자고 물어본다.
class RoutineGoalSuggestion {
  final RoutineGoalSuggestionKind kind;
  final int currentCount;
  final int suggestedCount;
  final int averageCheckedCount;

  const RoutineGoalSuggestion({
    required this.kind,
    required this.currentCount,
    required this.suggestedCount,
    required this.averageCheckedCount,
  });
}

/// 최근 14일 기록을 보고 목표를 올리거나 내리자고 제안할지 판단한다.
///
/// 이 기능의 핵심은 "사용자가 스스로 목표를 조정하러 설정 화면에 들어가지
/// 않는다"는 전제다. 잘하고 있으면 올리자고, 버거워 보이면 낮추자고 시스템이
/// 먼저 말을 건다. 특히 하향 제안은 포기 방지 장치라 상향만큼 중요하다.
///
/// COUNT 모드가 아니거나 표본이 부족하면 null(제안 없음).
RoutineGoalSuggestion? evaluateGoalSuggestion({
  required RoutineSettings settings,
  required RoutineDailyStreak streak,

  /// 일일 목표 집계에 **포함된** 습관 수. 상향 제안의 상한이 된다 —
  /// 포함 습관보다 큰 목표는 영원히 달성할 수 없기 때문이다.
  required int includedRoutines,
}) {
  if (!settings.isCountMode) return null;
  final current = settings.dailyGoalCount;
  if (current == null || current < 1) return null;

  final recent = streak.recent14Days;
  // 표본이 너무 적으면(막 시작했거나 대부분 쉬는 날) 판단하지 않는다.
  if (recent.totalDays < 7) return null;

  // 상향: 14일 중 10일 이상 목표를 "초과" 달성.
  if (recent.exceededDays >= 10) {
    // 평균 수행량과 목표+2 중 낮은 쪽으로 제안해 무리한 상향을 피한다.
    final average = recent.averageCheckedCount.round();
    // 포함 습관 수를 넘어서는 목표는 달성 자체가 불가능하므로 제안하지 않는다.
    if (includedRoutines > 0 && current >= includedRoutines) return null;
    final suggested = (average < current + 2 ? average : current + 2).clamp(
      current + 1,
      includedRoutines > 0 ? includedRoutines : current + 2,
    );
    if (suggested <= current) return null;
    return RoutineGoalSuggestion(
      kind: RoutineGoalSuggestionKind.raise,
      currentCount: current,
      suggestedCount: suggested,
      averageCheckedCount: average,
    );
  }

  // 하향: 달성률이 30% 미만이면 목표가 버거운 상태로 본다.
  final achievedRatio = recent.achievedDays / recent.totalDays;
  if (achievedRatio < 0.3) {
    // 이미 목표가 1이면 더 낮출 수 없다(clamp 범위가 뒤집히므로 먼저 걸러낸다).
    if (current <= 1) return null;
    final average = recent.averageCheckedCount.round();
    // 평균 수행량 언저리로 낮춰야 "이 정도면 할 만하다"는 감각이 생긴다.
    final suggested = (average > 0 ? average : current - 2).clamp(
      1,
      current - 1,
    );
    if (suggested >= current) return null;
    return RoutineGoalSuggestion(
      kind: RoutineGoalSuggestionKind.lower,
      currentCount: current,
      suggestedCount: suggested,
      averageCheckedCount: average,
    );
  }

  return null;
}

/// 제안을 너무 자주 띄우지 않기 위한 쿨다운 저장소. 거절해도 2주 뒤에
/// 다시 묻는다 — 그때는 상황이 달라져 있을 수 있기 때문이다.
class RoutineGoalSuggestionCooldown {
  static const _key = 'routine_goal_suggestion_last_shown';
  static const _cooldown = Duration(days: 14);

  static Future<bool> canShow() async {
    final prefs = await SharedPreferences.getInstance();
    final millis = prefs.getInt(_key);
    if (millis == null) return true;
    final last = DateTime.fromMillisecondsSinceEpoch(millis);
    return DateTime.now().difference(last) >= _cooldown;
  }

  static Future<void> markShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, DateTime.now().millisecondsSinceEpoch);
  }
}

/// 목표 조정 제안 다이얼로그. 수락하면 새 목표 개수를 반환하고,
/// 거절하거나 닫으면 null을 반환한다.
Future<int?> showRoutineGoalSuggestionDialog(
  BuildContext context,
  RoutineGoalSuggestion suggestion,
) {
  final l10n = AppLocalizations.of(context)!;
  final isRaise = suggestion.kind == RoutineGoalSuggestionKind.raise;

  return showDialog<int>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        isRaise
            ? l10n.routine_daily_goal_raise_title
            : l10n.routine_daily_goal_lower_title,
      ),
      content: Text(
        isRaise
            ? l10n.routine_daily_goal_raise_body(
                suggestion.averageCheckedCount,
                suggestion.currentCount,
                suggestion.suggestedCount,
              )
            : l10n.routine_daily_goal_lower_body(
                suggestion.currentCount,
                suggestion.suggestedCount,
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.routine_daily_goal_keep),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, suggestion.suggestedCount),
          child: Text(
            isRaise
                ? l10n.routine_daily_goal_raise_accept
                : l10n.routine_daily_goal_lower_accept,
          ),
        ),
      ],
    ),
  );
}
