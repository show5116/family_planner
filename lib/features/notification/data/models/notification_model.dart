import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

/// 알림 카테고리
enum NotificationCategory {
  @JsonValue('SCHEDULE')
  schedule, // 일정
  @JsonValue('TODO')
  todo, // 할 일
  @JsonValue('HOUSEHOLD')
  household, // 가계부
  @JsonValue('ASSET')
  asset, // 자산
  @JsonValue('CHILDCARE')
  childcare, // 육아
  @JsonValue('GROUP')
  group, // 그룹
  @JsonValue('SYSTEM')
  system, // 시스템
}

/// 알림 모델
@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required String id,
    required String userId,
    required NotificationCategory category,
    required String title,
    required String body,
    Map<String, dynamic>? data,
    @Default(false) bool isRead,
    required DateTime sentAt,
    DateTime? readAt,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}
