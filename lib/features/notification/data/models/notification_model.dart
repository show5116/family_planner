import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

/// 알림 타입
enum NotificationType {
  @JsonValue('schedule')
  schedule, // 일정
  @JsonValue('todo')
  todo, // 할 일
  @JsonValue('household')
  household, // 가계부
  @JsonValue('groupInvite')
  groupInvite, // 그룹 초대
  @JsonValue('announcement')
  announcement, // 공지사항
}

/// 알림 모델
@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required String id,
    required String title,
    required String body,
    required NotificationType type,
    required DateTime timestamp,
    @Default(false) bool isRead,
    Map<String, dynamic>? data,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}
