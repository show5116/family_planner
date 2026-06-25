/// 기념일 오프셋 단위
enum AnniversaryOffsetType {
  days, // 일 기준 (N일 후)
  years, // 연 기준 (N주년)
}

/// milestone Task 자동 생성 설정
class MilestoneConfig {
  final bool? every100Days;
  final bool? everyYear;

  const MilestoneConfig({this.every100Days, this.everyYear});

  factory MilestoneConfig.fromJson(Map<String, dynamic> json) {
    return MilestoneConfig(
      every100Days: json['every100Days'] as bool?,
      everyYear: json['everyYear'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
        if (every100Days != null) 'every100Days': every100Days,
        if (everyYear != null) 'everyYear': everyYear,
      };
}

/// 기념일 모델
class AnniversaryModel {
  final String id;
  final String groupId;
  final String title;
  final DateTime date;
  final String? emoji;
  final MilestoneConfig? milestoneConfig;
  /// 오늘 기준 경과일 (D+N). 미래 기념일은 음수
  final int daysSince;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AnniversaryModel({
    required this.id,
    required this.groupId,
    required this.title,
    required this.date,
    this.emoji,
    this.milestoneConfig,
    required this.daysSince,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AnniversaryModel.fromJson(Map<String, dynamic> json) {
    return AnniversaryModel(
      id: json['id'] as String,
      groupId: json['groupId'] as String,
      title: json['title'] as String,
      date: DateTime.parse(json['date'] as String).toLocal(),
      emoji: json['emoji'] as String?,
      milestoneConfig: json['milestoneConfig'] != null
          ? MilestoneConfig.fromJson(
              json['milestoneConfig'] as Map<String, dynamic>)
          : null,
      daysSince: json['daysSince'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
      updatedAt: DateTime.parse(json['updatedAt'] as String).toLocal(),
    );
  }

  AnniversaryModel copyWith({
    String? id,
    String? groupId,
    String? title,
    DateTime? date,
    String? emoji,
    MilestoneConfig? milestoneConfig,
    int? daysSince,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AnniversaryModel(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      title: title ?? this.title,
      date: date ?? this.date,
      emoji: emoji ?? this.emoji,
      milestoneConfig: milestoneConfig ?? this.milestoneConfig,
      daysSince: daysSince ?? this.daysSince,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// 오늘부터 다음 기념일까지 D-day 계산 (양수: 남은 일수, 음수: 지난 일수)
  int? get daysUntilNext {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final thisYear = DateTime(today.year, date.month, date.day);
    final nextYear = DateTime(today.year + 1, date.month, date.day);
    final diff = thisYear.difference(todayDate).inDays;
    if (diff >= 0) return diff;
    return nextYear.difference(todayDate).inDays;
  }
}
