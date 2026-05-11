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
    @Default(true) bool assetEnabled,
    @Default(true) bool childcareEnabled,
    @Default(true) bool groupEnabled,
    @Default(true) bool savingsEnabled,
    @Default(true) bool systemEnabled,
    @Default(true) bool weatherEnabled,
    // 날씨 알림을 받을 시간 (시 단위, 기본 오전 7시)
    @Default(7) int weatherAlertHour,
  }) = _NotificationSettingsModel;

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsModelFromJson(json);
}
