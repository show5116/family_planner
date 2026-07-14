/// 루틴 반복 타입 (1차: WEEKLY_COUNT만 지원)
enum RoutineFrequencyType {
  weeklyCount,
  daily,
  daysOfWeek;

  static RoutineFrequencyType fromString(String? value) {
    switch (value) {
      case 'DAILY':
        return RoutineFrequencyType.daily;
      case 'DAYS_OF_WEEK':
        return RoutineFrequencyType.daysOfWeek;
      case 'WEEKLY_COUNT':
      default:
        return RoutineFrequencyType.weeklyCount;
    }
  }

  String toJsonString() {
    switch (this) {
      case RoutineFrequencyType.daily:
        return 'DAILY';
      case RoutineFrequencyType.daysOfWeek:
        return 'DAYS_OF_WEEK';
      case RoutineFrequencyType.weeklyCount:
        return 'WEEKLY_COUNT';
    }
  }
}

/// 이번 주 진행 상황 (체크 횟수 / 목표 횟수)
class ThisWeekProgress {
  final int checked;
  final int target;

  const ThisWeekProgress({required this.checked, required this.target});

  factory ThisWeekProgress.fromJson(Map<String, dynamic> json) {
    return ThisWeekProgress(
      checked: json['checked'] as int? ?? 0,
      target: json['target'] as int? ?? 0,
    );
  }
}

/// 루틴 모델
class Routine {
  final String id;
  final String title;
  final String? emoji;
  final String? color;
  final RoutineFrequencyType frequencyType;
  final int? targetCount;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;
  final int sortOrder;
  final bool checkedToday;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Routine({
    required this.id,
    required this.title,
    this.emoji,
    this.color,
    required this.frequencyType,
    this.targetCount,
    required this.startDate,
    this.endDate,
    required this.isActive,
    required this.sortOrder,
    required this.checkedToday,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Routine.fromJson(Map<String, dynamic> json) {
    return Routine(
      id: json['id'] as String,
      title: json['title'] as String,
      emoji: json['emoji'] as String?,
      color: json['color'] as String?,
      frequencyType: RoutineFrequencyType.fromString(
        json['frequencyType'] as String?,
      ),
      targetCount: json['targetCount'] as int?,
      startDate: DateTime.parse(json['startDate'] as String).toLocal(),
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String).toLocal()
          : null,
      isActive: json['isActive'] as bool? ?? true,
      sortOrder: json['sortOrder'] as int? ?? 0,
      checkedToday: json['checkedToday'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
      updatedAt: DateTime.parse(json['updatedAt'] as String).toLocal(),
    );
  }

  Routine copyWith({
    String? title,
    String? emoji,
    String? color,
    int? targetCount,
    DateTime? endDate,
    bool? isActive,
    int? sortOrder,
    bool? checkedToday,
  }) {
    return Routine(
      id: id,
      title: title ?? this.title,
      emoji: emoji ?? this.emoji,
      color: color ?? this.color,
      frequencyType: frequencyType,
      targetCount: targetCount ?? this.targetCount,
      startDate: startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      sortOrder: sortOrder ?? this.sortOrder,
      checkedToday: checkedToday ?? this.checkedToday,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

/// 루틴 체크 로그
class RoutineLog {
  final String id;
  final String routineId;
  final DateTime checkedDate;
  final String? note;
  final DateTime createdAt;
  final List<UserRoutineBadge> newlyEarnedBadges;

  const RoutineLog({
    required this.id,
    required this.routineId,
    required this.checkedDate,
    this.note,
    required this.createdAt,
    this.newlyEarnedBadges = const [],
  });

  factory RoutineLog.fromJson(Map<String, dynamic> json) {
    return RoutineLog(
      id: json['id'] as String,
      routineId: json['routineId'] as String,
      checkedDate: DateTime.parse(json['checkedDate'] as String).toLocal(),
      note: json['note'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
      newlyEarnedBadges: (json['newlyEarnedBadges'] as List<dynamic>? ?? [])
          .map((e) => UserRoutineBadge.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// 배지 판정 기준 타입
enum BadgeCriteriaType {
  streakDays,
  streakWeeks,
  totalChecks;

  static BadgeCriteriaType fromString(String? value) {
    switch (value) {
      case 'STREAK_WEEKS':
        return BadgeCriteriaType.streakWeeks;
      case 'TOTAL_CHECKS':
        return BadgeCriteriaType.totalChecks;
      case 'STREAK_DAYS':
      default:
        return BadgeCriteriaType.streakDays;
    }
  }
}

/// 배지 카탈로그 항목
class RoutineBadge {
  final String id;
  final String code;
  final String title;
  final String? description;
  final String? iconEmoji;
  final BadgeCriteriaType criteriaType;
  final int criteriaValue;

  const RoutineBadge({
    required this.id,
    required this.code,
    required this.title,
    this.description,
    this.iconEmoji,
    required this.criteriaType,
    required this.criteriaValue,
  });

  factory RoutineBadge.fromJson(Map<String, dynamic> json) {
    return RoutineBadge(
      id: json['id'] as String,
      code: json['code'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      iconEmoji: json['iconEmoji'] as String?,
      criteriaType: BadgeCriteriaType.fromString(
        json['criteriaType'] as String?,
      ),
      criteriaValue: json['criteriaValue'] as int? ?? 0,
    );
  }
}

/// 사용자가 획득한 배지 기록
class UserRoutineBadge {
  final String id;
  final String badgeId;
  final RoutineBadge badge;
  final String? routineId;
  final String? routineTitle;
  final DateTime earnedAt;

  const UserRoutineBadge({
    required this.id,
    required this.badgeId,
    required this.badge,
    this.routineId,
    this.routineTitle,
    required this.earnedAt,
  });

  factory UserRoutineBadge.fromJson(Map<String, dynamic> json) {
    return UserRoutineBadge(
      id: json['id'] as String,
      badgeId: json['badgeId'] as String,
      badge: RoutineBadge.fromJson(json['badge'] as Map<String, dynamic>),
      routineId: json['routineId'] as String?,
      routineTitle: json['routineTitle'] as String?,
      earnedAt: DateTime.parse(json['earnedAt'] as String).toLocal(),
    );
  }
}

/// 루틴 ↔ 그룹 공유
class RoutineShare {
  final String id;
  final String routineId;
  final String groupId;
  final String groupName;
  final DateTime createdAt;

  const RoutineShare({
    required this.id,
    required this.routineId,
    required this.groupId,
    required this.groupName,
    required this.createdAt,
  });

  factory RoutineShare.fromJson(Map<String, dynamic> json) {
    return RoutineShare(
      id: json['id'] as String,
      routineId: json['routineId'] as String,
      groupId: json['groupId'] as String,
      groupName: json['groupName'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
    );
  }
}

/// 달력 히트맵 (기간 내 체크된 날짜 목록)
class RoutineHeatmap {
  final String routineId;
  final String from;
  final String to;
  final List<String> checkedDates; // YYYY-MM-DD

  const RoutineHeatmap({
    required this.routineId,
    required this.from,
    required this.to,
    required this.checkedDates,
  });

  factory RoutineHeatmap.fromJson(Map<String, dynamic> json) {
    return RoutineHeatmap(
      routineId: json['routineId'] as String,
      from: json['from'] as String,
      to: json['to'] as String,
      checkedDates: (json['checkedDates'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList(),
    );
  }
}

/// 스트릭 (현재/최장, 주 단위 + 일 단위)
class RoutineStreak {
  final String routineId;
  final int currentStreakWeeks;
  final int longestStreakWeeks;
  final int currentStreakDays;
  final int longestStreakDays;
  final ThisWeekProgress thisWeekProgress;

  const RoutineStreak({
    required this.routineId,
    required this.currentStreakWeeks,
    required this.longestStreakWeeks,
    required this.currentStreakDays,
    required this.longestStreakDays,
    required this.thisWeekProgress,
  });

  factory RoutineStreak.fromJson(Map<String, dynamic> json) {
    return RoutineStreak(
      routineId: json['routineId'] as String,
      currentStreakWeeks: json['currentStreakWeeks'] as int? ?? 0,
      longestStreakWeeks: json['longestStreakWeeks'] as int? ?? 0,
      currentStreakDays: json['currentStreakDays'] as int? ?? 0,
      longestStreakDays: json['longestStreakDays'] as int? ?? 0,
      thisWeekProgress: ThisWeekProgress.fromJson(
        json['thisWeekProgress'] as Map<String, dynamic>? ?? const {},
      ),
    );
  }
}

/// 달성률 조회 기간 단위
enum RoutineRatePeriod {
  week,
  month,
  custom;

  String toJsonString() => name;
}

/// 기간별 달성률
class RoutineRate {
  final String routineId;
  final String period;
  final String from;
  final String to;
  final int targetCount;
  final int totalChecked;
  final int expectedCount;
  final num achievementRate;

  const RoutineRate({
    required this.routineId,
    required this.period,
    required this.from,
    required this.to,
    required this.targetCount,
    required this.totalChecked,
    required this.expectedCount,
    required this.achievementRate,
  });

  factory RoutineRate.fromJson(Map<String, dynamic> json) {
    return RoutineRate(
      routineId: json['routineId'] as String,
      period: json['period'] as String,
      from: json['from'] as String,
      to: json['to'] as String,
      targetCount: json['targetCount'] as int? ?? 0,
      totalChecked: json['totalChecked'] as int? ?? 0,
      expectedCount: json['expectedCount'] as int? ?? 0,
      achievementRate: json['achievementRate'] as num? ?? 0,
    );
  }
}

/// 대시보드 위젯용 루틴 요약 항목
class RoutineSummaryItem {
  final String routineId;
  final String title;
  final String? emoji;
  final bool checkedToday;
  final int currentStreakDays;
  final ThisWeekProgress thisWeekProgress;

  const RoutineSummaryItem({
    required this.routineId,
    required this.title,
    this.emoji,
    required this.checkedToday,
    required this.currentStreakDays,
    required this.thisWeekProgress,
  });

  factory RoutineSummaryItem.fromJson(Map<String, dynamic> json) {
    return RoutineSummaryItem(
      routineId: json['routineId'] as String,
      title: json['title'] as String,
      emoji: json['emoji'] as String?,
      checkedToday: json['checkedToday'] as bool? ?? false,
      currentStreakDays: json['currentStreakDays'] as int? ?? 0,
      thisWeekProgress: ThisWeekProgress.fromJson(
        json['thisWeekProgress'] as Map<String, dynamic>? ?? const {},
      ),
    );
  }

  RoutineSummaryItem copyWith({bool? checkedToday}) {
    return RoutineSummaryItem(
      routineId: routineId,
      title: title,
      emoji: emoji,
      checkedToday: checkedToday ?? this.checkedToday,
      currentStreakDays: currentStreakDays,
      thisWeekProgress: thisWeekProgress,
    );
  }
}

/// 그룹원별 공유 루틴 목록
class RoutineGroupMemberRoutines {
  final String userId;
  final String userName;
  final List<Routine> routines;

  const RoutineGroupMemberRoutines({
    required this.userId,
    required this.userName,
    required this.routines,
  });

  factory RoutineGroupMemberRoutines.fromJson(Map<String, dynamic> json) {
    return RoutineGroupMemberRoutines(
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      routines: (json['routines'] as List<dynamic>? ?? [])
          .map((e) => Routine.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// 랭킹보드 집계 기간
enum LeaderboardPeriod {
  week,
  month;

  String toJsonString() => name;
}

/// 랭킹보드 정렬 기준
enum LeaderboardMetric {
  checkCount,
  achievementRate;

  String toJsonString() => name;
}

/// 랭킹보드 항목
class LeaderboardEntry {
  final int rank;
  final String userId;
  final String userName;
  final int checkCount;
  final num achievementRate;

  const LeaderboardEntry({
    required this.rank,
    required this.userId,
    required this.userName,
    required this.checkCount,
    required this.achievementRate,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      rank: json['rank'] as int,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      checkCount: json['checkCount'] as int? ?? 0,
      achievementRate: json['achievementRate'] as num? ?? 0,
    );
  }
}

/// 그룹 랭킹보드
class RoutineLeaderboard {
  final String groupId;
  final String period;
  final String metric;
  final List<LeaderboardEntry> rankings;

  const RoutineLeaderboard({
    required this.groupId,
    required this.period,
    required this.metric,
    required this.rankings,
  });

  factory RoutineLeaderboard.fromJson(Map<String, dynamic> json) {
    return RoutineLeaderboard(
      groupId: json['groupId'] as String,
      period: json['period'] as String,
      metric: json['metric'] as String,
      rankings: (json['rankings'] as List<dynamic>? ?? [])
          .map((e) => LeaderboardEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
