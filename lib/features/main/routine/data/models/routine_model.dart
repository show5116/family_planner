/// 루틴 반복 타입
enum RoutineFrequencyType {
  daily,
  weekly,
  monthly;

  static RoutineFrequencyType fromString(String? value) {
    switch (value) {
      case 'DAILY':
        return RoutineFrequencyType.daily;
      case 'MONTHLY':
        return RoutineFrequencyType.monthly;
      case 'WEEKLY':
      default:
        return RoutineFrequencyType.weekly;
    }
  }

  String toJsonString() {
    switch (this) {
      case RoutineFrequencyType.daily:
        return 'DAILY';
      case RoutineFrequencyType.weekly:
        return 'WEEKLY';
      case RoutineFrequencyType.monthly:
        return 'MONTHLY';
    }
  }
}

/// 주 반복 세부 방식 (frequencyType=WEEKLY일 때 사용)
enum RoutineWeeklyMode {
  countOnly,
  fixedDays;

  static RoutineWeeklyMode? fromString(String? value) {
    switch (value) {
      case 'FIXED_DAYS':
        return RoutineWeeklyMode.fixedDays;
      case 'COUNT_ONLY':
        return RoutineWeeklyMode.countOnly;
      default:
        return null;
    }
  }

  String toJsonString() {
    switch (this) {
      case RoutineWeeklyMode.countOnly:
        return 'COUNT_ONLY';
      case RoutineWeeklyMode.fixedDays:
        return 'FIXED_DAYS';
    }
  }
}

/// 루틴 중요도
enum RoutineImportance {
  low,
  medium,
  high;

  static RoutineImportance fromString(String? value) {
    switch (value) {
      case 'LOW':
        return RoutineImportance.low;
      case 'HIGH':
        return RoutineImportance.high;
      case 'MEDIUM':
      default:
        return RoutineImportance.medium;
    }
  }

  String toJsonString() {
    switch (this) {
      case RoutineImportance.low:
        return 'LOW';
      case RoutineImportance.medium:
        return 'MEDIUM';
      case RoutineImportance.high:
        return 'HIGH';
    }
  }
}

/// 시간대 분류 (알림과 무관한 분류용)
enum RoutineTimeFilter {
  morning,
  afternoon,
  evening;

  static RoutineTimeFilter? fromString(String? value) {
    switch (value) {
      case 'MORNING':
        return RoutineTimeFilter.morning;
      case 'AFTERNOON':
        return RoutineTimeFilter.afternoon;
      case 'EVENING':
        return RoutineTimeFilter.evening;
      default:
        return null;
    }
  }

  String toJsonString() {
    switch (this) {
      case RoutineTimeFilter.morning:
        return 'MORNING';
      case RoutineTimeFilter.afternoon:
        return 'AFTERNOON';
      case RoutineTimeFilter.evening:
        return 'EVENING';
    }
  }
}

/// 기록 방식 (BOOLEAN=단순 체크, TEXT=텍스트, TIME=시각, NUMERIC=수치)
enum RoutineRecordType {
  boolean_,
  text,
  time,
  numeric;

  static RoutineRecordType fromString(String? value) {
    switch (value) {
      case 'TEXT':
        return RoutineRecordType.text;
      case 'TIME':
        return RoutineRecordType.time;
      case 'NUMERIC':
        return RoutineRecordType.numeric;
      case 'BOOLEAN':
      default:
        return RoutineRecordType.boolean_;
    }
  }

  String toJsonString() {
    switch (this) {
      case RoutineRecordType.boolean_:
        return 'BOOLEAN';
      case RoutineRecordType.text:
        return 'TEXT';
      case RoutineRecordType.time:
        return 'TIME';
      case RoutineRecordType.numeric:
        return 'NUMERIC';
    }
  }
}

/// 루틴 상태
enum RoutineStatus {
  active,
  paused,
  ended;

  static RoutineStatus fromString(String? value) {
    switch (value) {
      case 'PAUSED':
        return RoutineStatus.paused;
      case 'ENDED':
        return RoutineStatus.ended;
      case 'ACTIVE':
      default:
        return RoutineStatus.active;
    }
  }

  String toJsonString() {
    switch (this) {
      case RoutineStatus.active:
        return 'ACTIVE';
      case RoutineStatus.paused:
        return 'PAUSED';
      case RoutineStatus.ended:
        return 'ENDED';
    }
  }
}

/// 조회 기준 날짜의 실제 체크 기록값 (recordType별 값 중 하나만 유효)
class RoutineCheckedLog {
  final String? note;
  final String? textValue;
  final num? numericValue;
  final String? timeValue;

  const RoutineCheckedLog({
    this.note,
    this.textValue,
    this.numericValue,
    this.timeValue,
  });

  factory RoutineCheckedLog.fromJson(Map<String, dynamic> json) {
    return RoutineCheckedLog(
      note: json['note'] as String?,
      textValue: json['textValue'] as String?,
      numericValue: json['numericValue'] as num?,
      timeValue: json['timeValue'] as String?,
    );
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

/// 습관 모델 (여러 습관을 묶으면 루틴(RoutineGroup)이 된다)
class Routine {
  final String id;
  final String title;
  final String? emoji;
  final String? color;
  final String? memo;
  final RoutineImportance importance;
  final RoutineTimeFilter? timeFilter;

  /// 1:N 카테고리 다중 선택
  final List<String> categoryIds;
  final RoutineRecordType recordType;
  final RoutineStatus status;
  final RoutineFrequencyType frequencyType;
  final RoutineWeeklyMode? weeklyMode;
  final int? targetCount;
  final List<int>? targetDays;
  final DateTime startDate;
  final DateTime? endDate;
  final int sortOrder;
  final bool checkedToday;

  /// 조회 기준 날짜(GET routines의 date 쿼리, 미지정 시 오늘)의 실제 기록값.
  /// 체크 안 했으면 null.
  final RoutineCheckedLog? checkedLog;
  final String? routineGroupId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Routine({
    required this.id,
    required this.title,
    this.emoji,
    this.color,
    this.memo,
    required this.importance,
    this.timeFilter,
    this.categoryIds = const [],
    required this.recordType,
    required this.status,
    required this.frequencyType,
    this.weeklyMode,
    this.targetCount,
    this.targetDays,
    required this.startDate,
    this.endDate,
    required this.sortOrder,
    required this.checkedToday,
    this.checkedLog,
    this.routineGroupId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Routine.fromJson(Map<String, dynamic> json) {
    return Routine(
      id: json['id'] as String,
      title: json['title'] as String,
      emoji: json['emoji'] as String?,
      color: json['color'] as String?,
      memo: json['memo'] as String?,
      importance: RoutineImportance.fromString(json['importance'] as String?),
      timeFilter: RoutineTimeFilter.fromString(json['timeFilter'] as String?),
      categoryIds: (json['categoryIds'] as List<dynamic>? ?? const [])
          .map((e) => e as String)
          .toList(),
      recordType: RoutineRecordType.fromString(json['recordType'] as String?),
      status: RoutineStatus.fromString(json['status'] as String?),
      frequencyType: RoutineFrequencyType.fromString(
        json['frequencyType'] as String?,
      ),
      weeklyMode: RoutineWeeklyMode.fromString(json['weeklyMode'] as String?),
      targetCount: json['targetCount'] as int?,
      targetDays: (json['targetDays'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      startDate: DateTime.parse(json['startDate'] as String).toLocal(),
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String).toLocal()
          : null,
      sortOrder: json['sortOrder'] as int? ?? 0,
      checkedToday: json['checkedToday'] as bool? ?? false,
      checkedLog: json['checkedLog'] != null
          ? RoutineCheckedLog.fromJson(
              json['checkedLog'] as Map<String, dynamic>,
            )
          : null,
      routineGroupId: json['routineGroupId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
      updatedAt: DateTime.parse(json['updatedAt'] as String).toLocal(),
    );
  }

  Routine copyWith({
    String? title,
    String? emoji,
    String? color,
    String? memo,
    RoutineImportance? importance,
    RoutineTimeFilter? timeFilter,
    List<String>? categoryIds,
    int? targetCount,
    List<int>? targetDays,
    DateTime? endDate,
    RoutineStatus? status,
    int? sortOrder,
    bool? checkedToday,
    RoutineCheckedLog? checkedLog,
    bool clearCheckedLog = false,
    String? routineGroupId,
  }) {
    return Routine(
      id: id,
      title: title ?? this.title,
      emoji: emoji ?? this.emoji,
      color: color ?? this.color,
      memo: memo ?? this.memo,
      importance: importance ?? this.importance,
      timeFilter: timeFilter ?? this.timeFilter,
      categoryIds: categoryIds ?? this.categoryIds,
      recordType: recordType,
      status: status ?? this.status,
      frequencyType: frequencyType,
      weeklyMode: weeklyMode,
      targetCount: targetCount ?? this.targetCount,
      targetDays: targetDays ?? this.targetDays,
      startDate: startDate,
      endDate: endDate ?? this.endDate,
      sortOrder: sortOrder ?? this.sortOrder,
      checkedToday: checkedToday ?? this.checkedToday,
      checkedLog: clearCheckedLog ? null : (checkedLog ?? this.checkedLog),
      routineGroupId: routineGroupId ?? this.routineGroupId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

/// 루틴(습관 묶음)의 오늘 진행 상황
class RoutineGroupProgress {
  final int checked;
  final int total;

  const RoutineGroupProgress({required this.checked, required this.total});

  factory RoutineGroupProgress.fromJson(Map<String, dynamic> json) {
    return RoutineGroupProgress(
      checked: json['checked'] as int? ?? 0,
      total: json['total'] as int? ?? 0,
    );
  }
}

/// 루틴(습관 묶음) 모델
class RoutineGroup {
  final String id;
  final String title;
  final String? emoji;
  final String? color;
  final int sortOrder;
  final RoutineGroupProgress todayProgress;
  final DateTime createdAt;
  final DateTime updatedAt;

  const RoutineGroup({
    required this.id,
    required this.title,
    this.emoji,
    this.color,
    required this.sortOrder,
    required this.todayProgress,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RoutineGroup.fromJson(Map<String, dynamic> json) {
    return RoutineGroup(
      id: json['id'] as String,
      title: json['title'] as String,
      emoji: json['emoji'] as String?,
      color: json['color'] as String?,
      sortOrder: json['sortOrder'] as int? ?? 0,
      todayProgress: RoutineGroupProgress.fromJson(
        json['todayProgress'] as Map<String, dynamic>? ?? const {},
      ),
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
      updatedAt: DateTime.parse(json['updatedAt'] as String).toLocal(),
    );
  }

  RoutineGroup copyWith({
    String? title,
    String? emoji,
    String? color,
    int? sortOrder,
    RoutineGroupProgress? todayProgress,
  }) {
    return RoutineGroup(
      id: id,
      title: title ?? this.title,
      emoji: emoji ?? this.emoji,
      color: color ?? this.color,
      sortOrder: sortOrder ?? this.sortOrder,
      todayProgress: todayProgress ?? this.todayProgress,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

/// 루틴(습관 묶음) 상세 - 소속 습관 목록 포함
class RoutineGroupDetail {
  final RoutineGroup group;
  final List<Routine> routines;

  const RoutineGroupDetail({required this.group, required this.routines});

  factory RoutineGroupDetail.fromJson(Map<String, dynamic> json) {
    return RoutineGroupDetail(
      group: RoutineGroup.fromJson(json),
      routines: (json['routines'] as List<dynamic>? ?? [])
          .map((e) => Routine.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// 루틴 카테고리 (단순 태그, 진행률 없음 — RoutineGroup(습관 묶음)과 구분되는 별개 개념)
class RoutineCategory {
  final String id;
  final String title;
  final String? emoji;
  final String? color;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  const RoutineCategory({
    required this.id,
    required this.title,
    this.emoji,
    this.color,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RoutineCategory.fromJson(Map<String, dynamic> json) {
    return RoutineCategory(
      id: json['id'] as String,
      title: json['title'] as String,
      emoji: json['emoji'] as String?,
      color: json['color'] as String?,
      sortOrder: json['sortOrder'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
      updatedAt: DateTime.parse(json['updatedAt'] as String).toLocal(),
    );
  }

  RoutineCategory copyWith({
    String? title,
    String? emoji,
    String? color,
    int? sortOrder,
  }) {
    return RoutineCategory(
      id: id,
      title: title ?? this.title,
      emoji: emoji ?? this.emoji,
      color: color ?? this.color,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

/// 루틴 카테고리 상세 - 소속 습관 목록 포함
class RoutineCategoryDetail {
  final RoutineCategory category;
  final List<Routine> routines;

  const RoutineCategoryDetail({required this.category, required this.routines});

  factory RoutineCategoryDetail.fromJson(Map<String, dynamic> json) {
    return RoutineCategoryDetail(
      category: RoutineCategory.fromJson(json),
      routines: (json['routines'] as List<dynamic>? ?? [])
          .map((e) => Routine.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// 루틴 체크 로그
class RoutineLog {
  final String id;
  final String routineId;
  final DateTime checkedDate;
  final String? note;
  final String? textValue;
  final num? numericValue;
  final String? timeValue;
  final DateTime createdAt;
  final List<UserRoutineBadge> newlyEarnedBadges;

  const RoutineLog({
    required this.id,
    required this.routineId,
    required this.checkedDate,
    this.note,
    this.textValue,
    this.numericValue,
    this.timeValue,
    required this.createdAt,
    this.newlyEarnedBadges = const [],
  });

  factory RoutineLog.fromJson(Map<String, dynamic> json) {
    return RoutineLog(
      id: json['id'] as String,
      routineId: json['routineId'] as String,
      checkedDate: DateTime.parse(json['checkedDate'] as String).toLocal(),
      note: json['note'] as String?,
      textValue: json['textValue'] as String?,
      numericValue: json['numericValue'] as num?,
      timeValue: json['timeValue'] as String?,
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

/// 가족그룹 멤버별 공유 습관 목록 (가족그룹 공유 기능용, RoutineGroup(습관 묶음)과 무관)
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
