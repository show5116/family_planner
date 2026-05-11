/// 가계부 자동 등록 설정 모델
class HouseholdAutoSettingsModel {
  /// 푸시 자동 등록 기능 on/off
  final bool pushAutoRegisterEnabled;

  /// 자동 등록 시 사용할 그룹 ID (null이면 개인 모드)
  final String? defaultGroupId;

  const HouseholdAutoSettingsModel({
    this.pushAutoRegisterEnabled = false,
    this.defaultGroupId,
  });

  HouseholdAutoSettingsModel copyWith({
    bool? pushAutoRegisterEnabled,
    Object? defaultGroupId = _sentinel,
  }) {
    return HouseholdAutoSettingsModel(
      pushAutoRegisterEnabled: pushAutoRegisterEnabled ?? this.pushAutoRegisterEnabled,
      defaultGroupId: defaultGroupId == _sentinel
          ? this.defaultGroupId
          : defaultGroupId as String?,
    );
  }
}

// sentinel for nullable copyWith
const Object _sentinel = Object();
