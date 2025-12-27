// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_settings_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

NotificationSettingsModel _$NotificationSettingsModelFromJson(
  Map<String, dynamic> json,
) {
  return _NotificationSettingsModel.fromJson(json);
}

/// @nodoc
mixin _$NotificationSettingsModel {
  bool get scheduleEnabled => throw _privateConstructorUsedError;
  bool get todoEnabled => throw _privateConstructorUsedError;
  bool get householdEnabled => throw _privateConstructorUsedError;
  bool get groupInviteEnabled => throw _privateConstructorUsedError;
  bool get announcementEnabled => throw _privateConstructorUsedError;

  /// Serializes this NotificationSettingsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationSettingsModelCopyWith<NotificationSettingsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationSettingsModelCopyWith<$Res> {
  factory $NotificationSettingsModelCopyWith(
    NotificationSettingsModel value,
    $Res Function(NotificationSettingsModel) then,
  ) = _$NotificationSettingsModelCopyWithImpl<$Res, NotificationSettingsModel>;
  @useResult
  $Res call({
    bool scheduleEnabled,
    bool todoEnabled,
    bool householdEnabled,
    bool groupInviteEnabled,
    bool announcementEnabled,
  });
}

/// @nodoc
class _$NotificationSettingsModelCopyWithImpl<
  $Res,
  $Val extends NotificationSettingsModel
>
    implements $NotificationSettingsModelCopyWith<$Res> {
  _$NotificationSettingsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? scheduleEnabled = null,
    Object? todoEnabled = null,
    Object? householdEnabled = null,
    Object? groupInviteEnabled = null,
    Object? announcementEnabled = null,
  }) {
    return _then(
      _value.copyWith(
            scheduleEnabled: null == scheduleEnabled
                ? _value.scheduleEnabled
                : scheduleEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            todoEnabled: null == todoEnabled
                ? _value.todoEnabled
                : todoEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            householdEnabled: null == householdEnabled
                ? _value.householdEnabled
                : householdEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            groupInviteEnabled: null == groupInviteEnabled
                ? _value.groupInviteEnabled
                : groupInviteEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            announcementEnabled: null == announcementEnabled
                ? _value.announcementEnabled
                : announcementEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NotificationSettingsModelImplCopyWith<$Res>
    implements $NotificationSettingsModelCopyWith<$Res> {
  factory _$$NotificationSettingsModelImplCopyWith(
    _$NotificationSettingsModelImpl value,
    $Res Function(_$NotificationSettingsModelImpl) then,
  ) = __$$NotificationSettingsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool scheduleEnabled,
    bool todoEnabled,
    bool householdEnabled,
    bool groupInviteEnabled,
    bool announcementEnabled,
  });
}

/// @nodoc
class __$$NotificationSettingsModelImplCopyWithImpl<$Res>
    extends
        _$NotificationSettingsModelCopyWithImpl<
          $Res,
          _$NotificationSettingsModelImpl
        >
    implements _$$NotificationSettingsModelImplCopyWith<$Res> {
  __$$NotificationSettingsModelImplCopyWithImpl(
    _$NotificationSettingsModelImpl _value,
    $Res Function(_$NotificationSettingsModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NotificationSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? scheduleEnabled = null,
    Object? todoEnabled = null,
    Object? householdEnabled = null,
    Object? groupInviteEnabled = null,
    Object? announcementEnabled = null,
  }) {
    return _then(
      _$NotificationSettingsModelImpl(
        scheduleEnabled: null == scheduleEnabled
            ? _value.scheduleEnabled
            : scheduleEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        todoEnabled: null == todoEnabled
            ? _value.todoEnabled
            : todoEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        householdEnabled: null == householdEnabled
            ? _value.householdEnabled
            : householdEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        groupInviteEnabled: null == groupInviteEnabled
            ? _value.groupInviteEnabled
            : groupInviteEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        announcementEnabled: null == announcementEnabled
            ? _value.announcementEnabled
            : announcementEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationSettingsModelImpl implements _NotificationSettingsModel {
  const _$NotificationSettingsModelImpl({
    this.scheduleEnabled = true,
    this.todoEnabled = true,
    this.householdEnabled = true,
    this.groupInviteEnabled = true,
    this.announcementEnabled = true,
  });

  factory _$NotificationSettingsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationSettingsModelImplFromJson(json);

  @override
  @JsonKey()
  final bool scheduleEnabled;
  @override
  @JsonKey()
  final bool todoEnabled;
  @override
  @JsonKey()
  final bool householdEnabled;
  @override
  @JsonKey()
  final bool groupInviteEnabled;
  @override
  @JsonKey()
  final bool announcementEnabled;

  @override
  String toString() {
    return 'NotificationSettingsModel(scheduleEnabled: $scheduleEnabled, todoEnabled: $todoEnabled, householdEnabled: $householdEnabled, groupInviteEnabled: $groupInviteEnabled, announcementEnabled: $announcementEnabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationSettingsModelImpl &&
            (identical(other.scheduleEnabled, scheduleEnabled) ||
                other.scheduleEnabled == scheduleEnabled) &&
            (identical(other.todoEnabled, todoEnabled) ||
                other.todoEnabled == todoEnabled) &&
            (identical(other.householdEnabled, householdEnabled) ||
                other.householdEnabled == householdEnabled) &&
            (identical(other.groupInviteEnabled, groupInviteEnabled) ||
                other.groupInviteEnabled == groupInviteEnabled) &&
            (identical(other.announcementEnabled, announcementEnabled) ||
                other.announcementEnabled == announcementEnabled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    scheduleEnabled,
    todoEnabled,
    householdEnabled,
    groupInviteEnabled,
    announcementEnabled,
  );

  /// Create a copy of NotificationSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationSettingsModelImplCopyWith<_$NotificationSettingsModelImpl>
  get copyWith =>
      __$$NotificationSettingsModelImplCopyWithImpl<
        _$NotificationSettingsModelImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationSettingsModelImplToJson(this);
  }
}

abstract class _NotificationSettingsModel implements NotificationSettingsModel {
  const factory _NotificationSettingsModel({
    final bool scheduleEnabled,
    final bool todoEnabled,
    final bool householdEnabled,
    final bool groupInviteEnabled,
    final bool announcementEnabled,
  }) = _$NotificationSettingsModelImpl;

  factory _NotificationSettingsModel.fromJson(Map<String, dynamic> json) =
      _$NotificationSettingsModelImpl.fromJson;

  @override
  bool get scheduleEnabled;
  @override
  bool get todoEnabled;
  @override
  bool get householdEnabled;
  @override
  bool get groupInviteEnabled;
  @override
  bool get announcementEnabled;

  /// Create a copy of NotificationSettingsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationSettingsModelImplCopyWith<_$NotificationSettingsModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
