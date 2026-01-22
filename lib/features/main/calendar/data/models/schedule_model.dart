import 'package:freezed_annotation/freezed_annotation.dart';

part 'schedule_model.freezed.dart';
part 'schedule_model.g.dart';

/// 일정 공유 범위
enum ScheduleShareType {
  @JsonValue('PRIVATE')
  private, // 본인만
  @JsonValue('FAMILY')
  family, // 가족 전체
  @JsonValue('SPECIFIC')
  specific, // 특정 인원
}

/// 반복 타입
enum RecurrenceType {
  @JsonValue('NONE')
  none,
  @JsonValue('DAILY')
  daily,
  @JsonValue('WEEKLY')
  weekly,
  @JsonValue('MONTHLY')
  monthly,
  @JsonValue('YEARLY')
  yearly,
}

/// 일정 작성자 정보
@freezed
class ScheduleAuthor with _$ScheduleAuthor {
  const factory ScheduleAuthor({
    required String id,
    required String name,
    String? profileImage,
  }) = _ScheduleAuthor;

  factory ScheduleAuthor.fromJson(Map<String, dynamic> json) =>
      _$ScheduleAuthorFromJson(json);
}

/// 일정 공유 대상 멤버
@freezed
class ScheduleShareMember with _$ScheduleShareMember {
  const factory ScheduleShareMember({
    required String id,
    required String name,
    String? profileImage,
  }) = _ScheduleShareMember;

  factory ScheduleShareMember.fromJson(Map<String, dynamic> json) =>
      _$ScheduleShareMemberFromJson(json);
}

/// 반복 설정
@freezed
class RecurrenceRule with _$RecurrenceRule {
  const factory RecurrenceRule({
    required RecurrenceType type,
    @Default(1) int interval, // 반복 간격 (예: 2주마다 = weekly + interval 2)
    DateTime? endDate, // 반복 종료일 (null이면 무한 반복)
    @Default([]) List<int> daysOfWeek, // 주간 반복 시 요일 (1=월, 7=일)
    int? dayOfMonth, // 월간 반복 시 날짜
    int? monthOfYear, // 연간 반복 시 월
  }) = _RecurrenceRule;

  factory RecurrenceRule.fromJson(Map<String, dynamic> json) =>
      _$RecurrenceRuleFromJson(json);
}

/// 알림 설정
@freezed
class ScheduleReminder with _$ScheduleReminder {
  const factory ScheduleReminder({
    required String id,
    required int minutesBefore, // 몇 분 전 알림 (0=정시, 60=1시간 전)
    @Default(true) bool isEnabled,
  }) = _ScheduleReminder;

  factory ScheduleReminder.fromJson(Map<String, dynamic> json) =>
      _$ScheduleReminderFromJson(json);
}

/// 일정 모델
@freezed
class ScheduleModel with _$ScheduleModel {
  const ScheduleModel._();

  const factory ScheduleModel({
    required String id,
    required String title,
    String? description,
    String? location,
    required DateTime startDate,
    DateTime? endDate, // null이면 종일 일정 또는 시간 미지정
    @Default(false) bool isAllDay,
    @Default(ScheduleShareType.family) ScheduleShareType shareType,
    @Default([]) List<ScheduleShareMember> sharedWith, // shareType이 specific일 때
    RecurrenceRule? recurrence,
    @Default([]) List<ScheduleReminder> reminders,
    String? color, // 일정 색상 (hex)
    required ScheduleAuthor author,
    required String groupId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ScheduleModel;

  factory ScheduleModel.fromJson(Map<String, dynamic> json) =>
      _$ScheduleModelFromJson(json);

  /// 일정 색상 (Color 타입)
  int get colorValue {
    if (color == null) return 0xFF2196F3; // 기본 파란색
    final hex = color!.replaceFirst('#', '');
    return int.parse('FF$hex', radix: 16);
  }
}

/// 일정 목록 응답 모델
@freezed
class ScheduleListResponse with _$ScheduleListResponse {
  const factory ScheduleListResponse({
    @Default([]) List<ScheduleModel> items,
    @Default(0) int total,
  }) = _ScheduleListResponse;

  factory ScheduleListResponse.fromJson(Map<String, dynamic> json) =>
      _$ScheduleListResponseFromJson(json);
}

/// 월간 일정 조회 요청 파라미터
@freezed
class MonthlyScheduleParams with _$MonthlyScheduleParams {
  const factory MonthlyScheduleParams({
    required int year,
    required int month,
    String? memberId, // 특정 멤버 일정만 필터링
  }) = _MonthlyScheduleParams;

  factory MonthlyScheduleParams.fromJson(Map<String, dynamic> json) =>
      _$MonthlyScheduleParamsFromJson(json);
}
