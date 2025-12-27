import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_settings_model.freezed.dart';
part 'notification_settings_model.g.dart';

/// 알림 설정 모델
@freezed
class NotificationSettingsModel with _$NotificationSettingsModel {
  const factory NotificationSettingsModel({
    @Default(true) bool scheduleEnabled,
    @Default(true) bool todoEnabled,
    @Default(true) bool householdEnabled,
    @Default(true) bool groupInviteEnabled,
    @Default(true) bool announcementEnabled,
  }) = _NotificationSettingsModel;

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsModelFromJson(json);
}
