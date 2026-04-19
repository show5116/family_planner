import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';

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

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    NotificationCategory parseCategory(String? v) {
      switch (v) {
        case 'SCHEDULE': return NotificationCategory.schedule;
        case 'TODO': return NotificationCategory.todo;
        case 'HOUSEHOLD': return NotificationCategory.household;
        case 'ASSET': return NotificationCategory.asset;
        case 'CHILDCARE': return NotificationCategory.childcare;
        case 'GROUP': return NotificationCategory.group;
        default: return NotificationCategory.system;
      }
    }

    return NotificationModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      category: parseCategory(json['category'] as String?),
      title: json['title'] as String,
      body: json['body'] as String,
      data: json['data'] as Map<String, dynamic>?,
      isRead: json['isRead'] as bool? ?? false,
      sentAt: DateTime.parse(json['sentAt'] as String).toLocal(),
      readAt: json['readAt'] != null
          ? DateTime.parse(json['readAt'] as String).toLocal()
          : null,
    );
  }
}
