// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ScheduleAuthor _$ScheduleAuthorFromJson(Map<String, dynamic> json) {
  return _ScheduleAuthor.fromJson(json);
}

/// @nodoc
mixin _$ScheduleAuthor {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get profileImage => throw _privateConstructorUsedError;

  /// Serializes this ScheduleAuthor to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScheduleAuthor
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScheduleAuthorCopyWith<ScheduleAuthor> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScheduleAuthorCopyWith<$Res> {
  factory $ScheduleAuthorCopyWith(
    ScheduleAuthor value,
    $Res Function(ScheduleAuthor) then,
  ) = _$ScheduleAuthorCopyWithImpl<$Res, ScheduleAuthor>;
  @useResult
  $Res call({String id, String name, String? profileImage});
}

/// @nodoc
class _$ScheduleAuthorCopyWithImpl<$Res, $Val extends ScheduleAuthor>
    implements $ScheduleAuthorCopyWith<$Res> {
  _$ScheduleAuthorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScheduleAuthor
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? profileImage = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            profileImage: freezed == profileImage
                ? _value.profileImage
                : profileImage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ScheduleAuthorImplCopyWith<$Res>
    implements $ScheduleAuthorCopyWith<$Res> {
  factory _$$ScheduleAuthorImplCopyWith(
    _$ScheduleAuthorImpl value,
    $Res Function(_$ScheduleAuthorImpl) then,
  ) = __$$ScheduleAuthorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String? profileImage});
}

/// @nodoc
class __$$ScheduleAuthorImplCopyWithImpl<$Res>
    extends _$ScheduleAuthorCopyWithImpl<$Res, _$ScheduleAuthorImpl>
    implements _$$ScheduleAuthorImplCopyWith<$Res> {
  __$$ScheduleAuthorImplCopyWithImpl(
    _$ScheduleAuthorImpl _value,
    $Res Function(_$ScheduleAuthorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ScheduleAuthor
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? profileImage = freezed,
  }) {
    return _then(
      _$ScheduleAuthorImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        profileImage: freezed == profileImage
            ? _value.profileImage
            : profileImage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ScheduleAuthorImpl implements _ScheduleAuthor {
  const _$ScheduleAuthorImpl({
    required this.id,
    required this.name,
    this.profileImage,
  });

  factory _$ScheduleAuthorImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScheduleAuthorImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? profileImage;

  @override
  String toString() {
    return 'ScheduleAuthor(id: $id, name: $name, profileImage: $profileImage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScheduleAuthorImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.profileImage, profileImage) ||
                other.profileImage == profileImage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, profileImage);

  /// Create a copy of ScheduleAuthor
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScheduleAuthorImplCopyWith<_$ScheduleAuthorImpl> get copyWith =>
      __$$ScheduleAuthorImplCopyWithImpl<_$ScheduleAuthorImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ScheduleAuthorImplToJson(this);
  }
}

abstract class _ScheduleAuthor implements ScheduleAuthor {
  const factory _ScheduleAuthor({
    required final String id,
    required final String name,
    final String? profileImage,
  }) = _$ScheduleAuthorImpl;

  factory _ScheduleAuthor.fromJson(Map<String, dynamic> json) =
      _$ScheduleAuthorImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get profileImage;

  /// Create a copy of ScheduleAuthor
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScheduleAuthorImplCopyWith<_$ScheduleAuthorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ScheduleShareMember _$ScheduleShareMemberFromJson(Map<String, dynamic> json) {
  return _ScheduleShareMember.fromJson(json);
}

/// @nodoc
mixin _$ScheduleShareMember {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get profileImage => throw _privateConstructorUsedError;

  /// Serializes this ScheduleShareMember to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScheduleShareMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScheduleShareMemberCopyWith<ScheduleShareMember> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScheduleShareMemberCopyWith<$Res> {
  factory $ScheduleShareMemberCopyWith(
    ScheduleShareMember value,
    $Res Function(ScheduleShareMember) then,
  ) = _$ScheduleShareMemberCopyWithImpl<$Res, ScheduleShareMember>;
  @useResult
  $Res call({String id, String name, String? profileImage});
}

/// @nodoc
class _$ScheduleShareMemberCopyWithImpl<$Res, $Val extends ScheduleShareMember>
    implements $ScheduleShareMemberCopyWith<$Res> {
  _$ScheduleShareMemberCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScheduleShareMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? profileImage = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            profileImage: freezed == profileImage
                ? _value.profileImage
                : profileImage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ScheduleShareMemberImplCopyWith<$Res>
    implements $ScheduleShareMemberCopyWith<$Res> {
  factory _$$ScheduleShareMemberImplCopyWith(
    _$ScheduleShareMemberImpl value,
    $Res Function(_$ScheduleShareMemberImpl) then,
  ) = __$$ScheduleShareMemberImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String? profileImage});
}

/// @nodoc
class __$$ScheduleShareMemberImplCopyWithImpl<$Res>
    extends _$ScheduleShareMemberCopyWithImpl<$Res, _$ScheduleShareMemberImpl>
    implements _$$ScheduleShareMemberImplCopyWith<$Res> {
  __$$ScheduleShareMemberImplCopyWithImpl(
    _$ScheduleShareMemberImpl _value,
    $Res Function(_$ScheduleShareMemberImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ScheduleShareMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? profileImage = freezed,
  }) {
    return _then(
      _$ScheduleShareMemberImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        profileImage: freezed == profileImage
            ? _value.profileImage
            : profileImage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ScheduleShareMemberImpl implements _ScheduleShareMember {
  const _$ScheduleShareMemberImpl({
    required this.id,
    required this.name,
    this.profileImage,
  });

  factory _$ScheduleShareMemberImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScheduleShareMemberImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? profileImage;

  @override
  String toString() {
    return 'ScheduleShareMember(id: $id, name: $name, profileImage: $profileImage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScheduleShareMemberImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.profileImage, profileImage) ||
                other.profileImage == profileImage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, profileImage);

  /// Create a copy of ScheduleShareMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScheduleShareMemberImplCopyWith<_$ScheduleShareMemberImpl> get copyWith =>
      __$$ScheduleShareMemberImplCopyWithImpl<_$ScheduleShareMemberImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ScheduleShareMemberImplToJson(this);
  }
}

abstract class _ScheduleShareMember implements ScheduleShareMember {
  const factory _ScheduleShareMember({
    required final String id,
    required final String name,
    final String? profileImage,
  }) = _$ScheduleShareMemberImpl;

  factory _ScheduleShareMember.fromJson(Map<String, dynamic> json) =
      _$ScheduleShareMemberImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get profileImage;

  /// Create a copy of ScheduleShareMember
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScheduleShareMemberImplCopyWith<_$ScheduleShareMemberImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RecurrenceRule _$RecurrenceRuleFromJson(Map<String, dynamic> json) {
  return _RecurrenceRule.fromJson(json);
}

/// @nodoc
mixin _$RecurrenceRule {
  RecurrenceType get type => throw _privateConstructorUsedError;
  int get interval =>
      throw _privateConstructorUsedError; // 반복 간격 (예: 2주마다 = weekly + interval 2)
  DateTime? get endDate =>
      throw _privateConstructorUsedError; // 반복 종료일 (null이면 무한 반복)
  List<int> get daysOfWeek =>
      throw _privateConstructorUsedError; // 주간 반복 시 요일 (1=월, 7=일)
  int? get dayOfMonth => throw _privateConstructorUsedError; // 월간 반복 시 날짜
  int? get monthOfYear => throw _privateConstructorUsedError;

  /// Serializes this RecurrenceRule to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecurrenceRule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecurrenceRuleCopyWith<RecurrenceRule> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecurrenceRuleCopyWith<$Res> {
  factory $RecurrenceRuleCopyWith(
    RecurrenceRule value,
    $Res Function(RecurrenceRule) then,
  ) = _$RecurrenceRuleCopyWithImpl<$Res, RecurrenceRule>;
  @useResult
  $Res call({
    RecurrenceType type,
    int interval,
    DateTime? endDate,
    List<int> daysOfWeek,
    int? dayOfMonth,
    int? monthOfYear,
  });
}

/// @nodoc
class _$RecurrenceRuleCopyWithImpl<$Res, $Val extends RecurrenceRule>
    implements $RecurrenceRuleCopyWith<$Res> {
  _$RecurrenceRuleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecurrenceRule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? interval = null,
    Object? endDate = freezed,
    Object? daysOfWeek = null,
    Object? dayOfMonth = freezed,
    Object? monthOfYear = freezed,
  }) {
    return _then(
      _value.copyWith(
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as RecurrenceType,
            interval: null == interval
                ? _value.interval
                : interval // ignore: cast_nullable_to_non_nullable
                      as int,
            endDate: freezed == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            daysOfWeek: null == daysOfWeek
                ? _value.daysOfWeek
                : daysOfWeek // ignore: cast_nullable_to_non_nullable
                      as List<int>,
            dayOfMonth: freezed == dayOfMonth
                ? _value.dayOfMonth
                : dayOfMonth // ignore: cast_nullable_to_non_nullable
                      as int?,
            monthOfYear: freezed == monthOfYear
                ? _value.monthOfYear
                : monthOfYear // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RecurrenceRuleImplCopyWith<$Res>
    implements $RecurrenceRuleCopyWith<$Res> {
  factory _$$RecurrenceRuleImplCopyWith(
    _$RecurrenceRuleImpl value,
    $Res Function(_$RecurrenceRuleImpl) then,
  ) = __$$RecurrenceRuleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    RecurrenceType type,
    int interval,
    DateTime? endDate,
    List<int> daysOfWeek,
    int? dayOfMonth,
    int? monthOfYear,
  });
}

/// @nodoc
class __$$RecurrenceRuleImplCopyWithImpl<$Res>
    extends _$RecurrenceRuleCopyWithImpl<$Res, _$RecurrenceRuleImpl>
    implements _$$RecurrenceRuleImplCopyWith<$Res> {
  __$$RecurrenceRuleImplCopyWithImpl(
    _$RecurrenceRuleImpl _value,
    $Res Function(_$RecurrenceRuleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecurrenceRule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? interval = null,
    Object? endDate = freezed,
    Object? daysOfWeek = null,
    Object? dayOfMonth = freezed,
    Object? monthOfYear = freezed,
  }) {
    return _then(
      _$RecurrenceRuleImpl(
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as RecurrenceType,
        interval: null == interval
            ? _value.interval
            : interval // ignore: cast_nullable_to_non_nullable
                  as int,
        endDate: freezed == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        daysOfWeek: null == daysOfWeek
            ? _value._daysOfWeek
            : daysOfWeek // ignore: cast_nullable_to_non_nullable
                  as List<int>,
        dayOfMonth: freezed == dayOfMonth
            ? _value.dayOfMonth
            : dayOfMonth // ignore: cast_nullable_to_non_nullable
                  as int?,
        monthOfYear: freezed == monthOfYear
            ? _value.monthOfYear
            : monthOfYear // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RecurrenceRuleImpl implements _RecurrenceRule {
  const _$RecurrenceRuleImpl({
    required this.type,
    this.interval = 1,
    this.endDate,
    final List<int> daysOfWeek = const [],
    this.dayOfMonth,
    this.monthOfYear,
  }) : _daysOfWeek = daysOfWeek;

  factory _$RecurrenceRuleImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecurrenceRuleImplFromJson(json);

  @override
  final RecurrenceType type;
  @override
  @JsonKey()
  final int interval;
  // 반복 간격 (예: 2주마다 = weekly + interval 2)
  @override
  final DateTime? endDate;
  // 반복 종료일 (null이면 무한 반복)
  final List<int> _daysOfWeek;
  // 반복 종료일 (null이면 무한 반복)
  @override
  @JsonKey()
  List<int> get daysOfWeek {
    if (_daysOfWeek is EqualUnmodifiableListView) return _daysOfWeek;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_daysOfWeek);
  }

  // 주간 반복 시 요일 (1=월, 7=일)
  @override
  final int? dayOfMonth;
  // 월간 반복 시 날짜
  @override
  final int? monthOfYear;

  @override
  String toString() {
    return 'RecurrenceRule(type: $type, interval: $interval, endDate: $endDate, daysOfWeek: $daysOfWeek, dayOfMonth: $dayOfMonth, monthOfYear: $monthOfYear)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecurrenceRuleImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.interval, interval) ||
                other.interval == interval) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            const DeepCollectionEquality().equals(
              other._daysOfWeek,
              _daysOfWeek,
            ) &&
            (identical(other.dayOfMonth, dayOfMonth) ||
                other.dayOfMonth == dayOfMonth) &&
            (identical(other.monthOfYear, monthOfYear) ||
                other.monthOfYear == monthOfYear));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    type,
    interval,
    endDate,
    const DeepCollectionEquality().hash(_daysOfWeek),
    dayOfMonth,
    monthOfYear,
  );

  /// Create a copy of RecurrenceRule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecurrenceRuleImplCopyWith<_$RecurrenceRuleImpl> get copyWith =>
      __$$RecurrenceRuleImplCopyWithImpl<_$RecurrenceRuleImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RecurrenceRuleImplToJson(this);
  }
}

abstract class _RecurrenceRule implements RecurrenceRule {
  const factory _RecurrenceRule({
    required final RecurrenceType type,
    final int interval,
    final DateTime? endDate,
    final List<int> daysOfWeek,
    final int? dayOfMonth,
    final int? monthOfYear,
  }) = _$RecurrenceRuleImpl;

  factory _RecurrenceRule.fromJson(Map<String, dynamic> json) =
      _$RecurrenceRuleImpl.fromJson;

  @override
  RecurrenceType get type;
  @override
  int get interval; // 반복 간격 (예: 2주마다 = weekly + interval 2)
  @override
  DateTime? get endDate; // 반복 종료일 (null이면 무한 반복)
  @override
  List<int> get daysOfWeek; // 주간 반복 시 요일 (1=월, 7=일)
  @override
  int? get dayOfMonth; // 월간 반복 시 날짜
  @override
  int? get monthOfYear;

  /// Create a copy of RecurrenceRule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecurrenceRuleImplCopyWith<_$RecurrenceRuleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ScheduleReminder _$ScheduleReminderFromJson(Map<String, dynamic> json) {
  return _ScheduleReminder.fromJson(json);
}

/// @nodoc
mixin _$ScheduleReminder {
  String get id => throw _privateConstructorUsedError;
  int get minutesBefore =>
      throw _privateConstructorUsedError; // 몇 분 전 알림 (0=정시, 60=1시간 전)
  bool get isEnabled => throw _privateConstructorUsedError;

  /// Serializes this ScheduleReminder to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScheduleReminder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScheduleReminderCopyWith<ScheduleReminder> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScheduleReminderCopyWith<$Res> {
  factory $ScheduleReminderCopyWith(
    ScheduleReminder value,
    $Res Function(ScheduleReminder) then,
  ) = _$ScheduleReminderCopyWithImpl<$Res, ScheduleReminder>;
  @useResult
  $Res call({String id, int minutesBefore, bool isEnabled});
}

/// @nodoc
class _$ScheduleReminderCopyWithImpl<$Res, $Val extends ScheduleReminder>
    implements $ScheduleReminderCopyWith<$Res> {
  _$ScheduleReminderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScheduleReminder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? minutesBefore = null,
    Object? isEnabled = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            minutesBefore: null == minutesBefore
                ? _value.minutesBefore
                : minutesBefore // ignore: cast_nullable_to_non_nullable
                      as int,
            isEnabled: null == isEnabled
                ? _value.isEnabled
                : isEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ScheduleReminderImplCopyWith<$Res>
    implements $ScheduleReminderCopyWith<$Res> {
  factory _$$ScheduleReminderImplCopyWith(
    _$ScheduleReminderImpl value,
    $Res Function(_$ScheduleReminderImpl) then,
  ) = __$$ScheduleReminderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, int minutesBefore, bool isEnabled});
}

/// @nodoc
class __$$ScheduleReminderImplCopyWithImpl<$Res>
    extends _$ScheduleReminderCopyWithImpl<$Res, _$ScheduleReminderImpl>
    implements _$$ScheduleReminderImplCopyWith<$Res> {
  __$$ScheduleReminderImplCopyWithImpl(
    _$ScheduleReminderImpl _value,
    $Res Function(_$ScheduleReminderImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ScheduleReminder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? minutesBefore = null,
    Object? isEnabled = null,
  }) {
    return _then(
      _$ScheduleReminderImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        minutesBefore: null == minutesBefore
            ? _value.minutesBefore
            : minutesBefore // ignore: cast_nullable_to_non_nullable
                  as int,
        isEnabled: null == isEnabled
            ? _value.isEnabled
            : isEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ScheduleReminderImpl implements _ScheduleReminder {
  const _$ScheduleReminderImpl({
    required this.id,
    required this.minutesBefore,
    this.isEnabled = true,
  });

  factory _$ScheduleReminderImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScheduleReminderImplFromJson(json);

  @override
  final String id;
  @override
  final int minutesBefore;
  // 몇 분 전 알림 (0=정시, 60=1시간 전)
  @override
  @JsonKey()
  final bool isEnabled;

  @override
  String toString() {
    return 'ScheduleReminder(id: $id, minutesBefore: $minutesBefore, isEnabled: $isEnabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScheduleReminderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.minutesBefore, minutesBefore) ||
                other.minutesBefore == minutesBefore) &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, minutesBefore, isEnabled);

  /// Create a copy of ScheduleReminder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScheduleReminderImplCopyWith<_$ScheduleReminderImpl> get copyWith =>
      __$$ScheduleReminderImplCopyWithImpl<_$ScheduleReminderImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ScheduleReminderImplToJson(this);
  }
}

abstract class _ScheduleReminder implements ScheduleReminder {
  const factory _ScheduleReminder({
    required final String id,
    required final int minutesBefore,
    final bool isEnabled,
  }) = _$ScheduleReminderImpl;

  factory _ScheduleReminder.fromJson(Map<String, dynamic> json) =
      _$ScheduleReminderImpl.fromJson;

  @override
  String get id;
  @override
  int get minutesBefore; // 몇 분 전 알림 (0=정시, 60=1시간 전)
  @override
  bool get isEnabled;

  /// Create a copy of ScheduleReminder
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScheduleReminderImplCopyWith<_$ScheduleReminderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ScheduleModel _$ScheduleModelFromJson(Map<String, dynamic> json) {
  return _ScheduleModel.fromJson(json);
}

/// @nodoc
mixin _$ScheduleModel {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate =>
      throw _privateConstructorUsedError; // null이면 종일 일정 또는 시간 미지정
  bool get isAllDay => throw _privateConstructorUsedError;
  ScheduleShareType get shareType => throw _privateConstructorUsedError;
  List<ScheduleShareMember> get sharedWith =>
      throw _privateConstructorUsedError; // shareType이 specific일 때
  RecurrenceRule? get recurrence => throw _privateConstructorUsedError;
  List<ScheduleReminder> get reminders => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError; // 일정 색상 (hex)
  ScheduleAuthor get author => throw _privateConstructorUsedError;
  String get groupId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ScheduleModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScheduleModelCopyWith<ScheduleModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScheduleModelCopyWith<$Res> {
  factory $ScheduleModelCopyWith(
    ScheduleModel value,
    $Res Function(ScheduleModel) then,
  ) = _$ScheduleModelCopyWithImpl<$Res, ScheduleModel>;
  @useResult
  $Res call({
    String id,
    String title,
    String? description,
    String? location,
    DateTime startDate,
    DateTime? endDate,
    bool isAllDay,
    ScheduleShareType shareType,
    List<ScheduleShareMember> sharedWith,
    RecurrenceRule? recurrence,
    List<ScheduleReminder> reminders,
    String? color,
    ScheduleAuthor author,
    String groupId,
    DateTime createdAt,
    DateTime updatedAt,
  });

  $RecurrenceRuleCopyWith<$Res>? get recurrence;
  $ScheduleAuthorCopyWith<$Res> get author;
}

/// @nodoc
class _$ScheduleModelCopyWithImpl<$Res, $Val extends ScheduleModel>
    implements $ScheduleModelCopyWith<$Res> {
  _$ScheduleModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? location = freezed,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? isAllDay = null,
    Object? shareType = null,
    Object? sharedWith = null,
    Object? recurrence = freezed,
    Object? reminders = null,
    Object? color = freezed,
    Object? author = null,
    Object? groupId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            location: freezed == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String?,
            startDate: null == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endDate: freezed == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            isAllDay: null == isAllDay
                ? _value.isAllDay
                : isAllDay // ignore: cast_nullable_to_non_nullable
                      as bool,
            shareType: null == shareType
                ? _value.shareType
                : shareType // ignore: cast_nullable_to_non_nullable
                      as ScheduleShareType,
            sharedWith: null == sharedWith
                ? _value.sharedWith
                : sharedWith // ignore: cast_nullable_to_non_nullable
                      as List<ScheduleShareMember>,
            recurrence: freezed == recurrence
                ? _value.recurrence
                : recurrence // ignore: cast_nullable_to_non_nullable
                      as RecurrenceRule?,
            reminders: null == reminders
                ? _value.reminders
                : reminders // ignore: cast_nullable_to_non_nullable
                      as List<ScheduleReminder>,
            color: freezed == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as String?,
            author: null == author
                ? _value.author
                : author // ignore: cast_nullable_to_non_nullable
                      as ScheduleAuthor,
            groupId: null == groupId
                ? _value.groupId
                : groupId // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }

  /// Create a copy of ScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RecurrenceRuleCopyWith<$Res>? get recurrence {
    if (_value.recurrence == null) {
      return null;
    }

    return $RecurrenceRuleCopyWith<$Res>(_value.recurrence!, (value) {
      return _then(_value.copyWith(recurrence: value) as $Val);
    });
  }

  /// Create a copy of ScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ScheduleAuthorCopyWith<$Res> get author {
    return $ScheduleAuthorCopyWith<$Res>(_value.author, (value) {
      return _then(_value.copyWith(author: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ScheduleModelImplCopyWith<$Res>
    implements $ScheduleModelCopyWith<$Res> {
  factory _$$ScheduleModelImplCopyWith(
    _$ScheduleModelImpl value,
    $Res Function(_$ScheduleModelImpl) then,
  ) = __$$ScheduleModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String? description,
    String? location,
    DateTime startDate,
    DateTime? endDate,
    bool isAllDay,
    ScheduleShareType shareType,
    List<ScheduleShareMember> sharedWith,
    RecurrenceRule? recurrence,
    List<ScheduleReminder> reminders,
    String? color,
    ScheduleAuthor author,
    String groupId,
    DateTime createdAt,
    DateTime updatedAt,
  });

  @override
  $RecurrenceRuleCopyWith<$Res>? get recurrence;
  @override
  $ScheduleAuthorCopyWith<$Res> get author;
}

/// @nodoc
class __$$ScheduleModelImplCopyWithImpl<$Res>
    extends _$ScheduleModelCopyWithImpl<$Res, _$ScheduleModelImpl>
    implements _$$ScheduleModelImplCopyWith<$Res> {
  __$$ScheduleModelImplCopyWithImpl(
    _$ScheduleModelImpl _value,
    $Res Function(_$ScheduleModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? location = freezed,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? isAllDay = null,
    Object? shareType = null,
    Object? sharedWith = null,
    Object? recurrence = freezed,
    Object? reminders = null,
    Object? color = freezed,
    Object? author = null,
    Object? groupId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$ScheduleModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        location: freezed == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String?,
        startDate: null == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endDate: freezed == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        isAllDay: null == isAllDay
            ? _value.isAllDay
            : isAllDay // ignore: cast_nullable_to_non_nullable
                  as bool,
        shareType: null == shareType
            ? _value.shareType
            : shareType // ignore: cast_nullable_to_non_nullable
                  as ScheduleShareType,
        sharedWith: null == sharedWith
            ? _value._sharedWith
            : sharedWith // ignore: cast_nullable_to_non_nullable
                  as List<ScheduleShareMember>,
        recurrence: freezed == recurrence
            ? _value.recurrence
            : recurrence // ignore: cast_nullable_to_non_nullable
                  as RecurrenceRule?,
        reminders: null == reminders
            ? _value._reminders
            : reminders // ignore: cast_nullable_to_non_nullable
                  as List<ScheduleReminder>,
        color: freezed == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as String?,
        author: null == author
            ? _value.author
            : author // ignore: cast_nullable_to_non_nullable
                  as ScheduleAuthor,
        groupId: null == groupId
            ? _value.groupId
            : groupId // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ScheduleModelImpl extends _ScheduleModel {
  const _$ScheduleModelImpl({
    required this.id,
    required this.title,
    this.description,
    this.location,
    required this.startDate,
    this.endDate,
    this.isAllDay = false,
    this.shareType = ScheduleShareType.family,
    final List<ScheduleShareMember> sharedWith = const [],
    this.recurrence,
    final List<ScheduleReminder> reminders = const [],
    this.color,
    required this.author,
    required this.groupId,
    required this.createdAt,
    required this.updatedAt,
  }) : _sharedWith = sharedWith,
       _reminders = reminders,
       super._();

  factory _$ScheduleModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScheduleModelImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String? description;
  @override
  final String? location;
  @override
  final DateTime startDate;
  @override
  final DateTime? endDate;
  // null이면 종일 일정 또는 시간 미지정
  @override
  @JsonKey()
  final bool isAllDay;
  @override
  @JsonKey()
  final ScheduleShareType shareType;
  final List<ScheduleShareMember> _sharedWith;
  @override
  @JsonKey()
  List<ScheduleShareMember> get sharedWith {
    if (_sharedWith is EqualUnmodifiableListView) return _sharedWith;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sharedWith);
  }

  // shareType이 specific일 때
  @override
  final RecurrenceRule? recurrence;
  final List<ScheduleReminder> _reminders;
  @override
  @JsonKey()
  List<ScheduleReminder> get reminders {
    if (_reminders is EqualUnmodifiableListView) return _reminders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reminders);
  }

  @override
  final String? color;
  // 일정 색상 (hex)
  @override
  final ScheduleAuthor author;
  @override
  final String groupId;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'ScheduleModel(id: $id, title: $title, description: $description, location: $location, startDate: $startDate, endDate: $endDate, isAllDay: $isAllDay, shareType: $shareType, sharedWith: $sharedWith, recurrence: $recurrence, reminders: $reminders, color: $color, author: $author, groupId: $groupId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScheduleModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.isAllDay, isAllDay) ||
                other.isAllDay == isAllDay) &&
            (identical(other.shareType, shareType) ||
                other.shareType == shareType) &&
            const DeepCollectionEquality().equals(
              other._sharedWith,
              _sharedWith,
            ) &&
            (identical(other.recurrence, recurrence) ||
                other.recurrence == recurrence) &&
            const DeepCollectionEquality().equals(
              other._reminders,
              _reminders,
            ) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    description,
    location,
    startDate,
    endDate,
    isAllDay,
    shareType,
    const DeepCollectionEquality().hash(_sharedWith),
    recurrence,
    const DeepCollectionEquality().hash(_reminders),
    color,
    author,
    groupId,
    createdAt,
    updatedAt,
  );

  /// Create a copy of ScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScheduleModelImplCopyWith<_$ScheduleModelImpl> get copyWith =>
      __$$ScheduleModelImplCopyWithImpl<_$ScheduleModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScheduleModelImplToJson(this);
  }
}

abstract class _ScheduleModel extends ScheduleModel {
  const factory _ScheduleModel({
    required final String id,
    required final String title,
    final String? description,
    final String? location,
    required final DateTime startDate,
    final DateTime? endDate,
    final bool isAllDay,
    final ScheduleShareType shareType,
    final List<ScheduleShareMember> sharedWith,
    final RecurrenceRule? recurrence,
    final List<ScheduleReminder> reminders,
    final String? color,
    required final ScheduleAuthor author,
    required final String groupId,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$ScheduleModelImpl;
  const _ScheduleModel._() : super._();

  factory _ScheduleModel.fromJson(Map<String, dynamic> json) =
      _$ScheduleModelImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String? get description;
  @override
  String? get location;
  @override
  DateTime get startDate;
  @override
  DateTime? get endDate; // null이면 종일 일정 또는 시간 미지정
  @override
  bool get isAllDay;
  @override
  ScheduleShareType get shareType;
  @override
  List<ScheduleShareMember> get sharedWith; // shareType이 specific일 때
  @override
  RecurrenceRule? get recurrence;
  @override
  List<ScheduleReminder> get reminders;
  @override
  String? get color; // 일정 색상 (hex)
  @override
  ScheduleAuthor get author;
  @override
  String get groupId;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of ScheduleModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScheduleModelImplCopyWith<_$ScheduleModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ScheduleListResponse _$ScheduleListResponseFromJson(Map<String, dynamic> json) {
  return _ScheduleListResponse.fromJson(json);
}

/// @nodoc
mixin _$ScheduleListResponse {
  List<ScheduleModel> get items => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;

  /// Serializes this ScheduleListResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScheduleListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScheduleListResponseCopyWith<ScheduleListResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScheduleListResponseCopyWith<$Res> {
  factory $ScheduleListResponseCopyWith(
    ScheduleListResponse value,
    $Res Function(ScheduleListResponse) then,
  ) = _$ScheduleListResponseCopyWithImpl<$Res, ScheduleListResponse>;
  @useResult
  $Res call({List<ScheduleModel> items, int total});
}

/// @nodoc
class _$ScheduleListResponseCopyWithImpl<
  $Res,
  $Val extends ScheduleListResponse
>
    implements $ScheduleListResponseCopyWith<$Res> {
  _$ScheduleListResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScheduleListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? items = null, Object? total = null}) {
    return _then(
      _value.copyWith(
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<ScheduleModel>,
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ScheduleListResponseImplCopyWith<$Res>
    implements $ScheduleListResponseCopyWith<$Res> {
  factory _$$ScheduleListResponseImplCopyWith(
    _$ScheduleListResponseImpl value,
    $Res Function(_$ScheduleListResponseImpl) then,
  ) = __$$ScheduleListResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<ScheduleModel> items, int total});
}

/// @nodoc
class __$$ScheduleListResponseImplCopyWithImpl<$Res>
    extends _$ScheduleListResponseCopyWithImpl<$Res, _$ScheduleListResponseImpl>
    implements _$$ScheduleListResponseImplCopyWith<$Res> {
  __$$ScheduleListResponseImplCopyWithImpl(
    _$ScheduleListResponseImpl _value,
    $Res Function(_$ScheduleListResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ScheduleListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? items = null, Object? total = null}) {
    return _then(
      _$ScheduleListResponseImpl(
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<ScheduleModel>,
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ScheduleListResponseImpl implements _ScheduleListResponse {
  const _$ScheduleListResponseImpl({
    final List<ScheduleModel> items = const [],
    this.total = 0,
  }) : _items = items;

  factory _$ScheduleListResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScheduleListResponseImplFromJson(json);

  final List<ScheduleModel> _items;
  @override
  @JsonKey()
  List<ScheduleModel> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  @JsonKey()
  final int total;

  @override
  String toString() {
    return 'ScheduleListResponse(items: $items, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScheduleListResponseImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.total, total) || other.total == total));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_items),
    total,
  );

  /// Create a copy of ScheduleListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScheduleListResponseImplCopyWith<_$ScheduleListResponseImpl>
  get copyWith =>
      __$$ScheduleListResponseImplCopyWithImpl<_$ScheduleListResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ScheduleListResponseImplToJson(this);
  }
}

abstract class _ScheduleListResponse implements ScheduleListResponse {
  const factory _ScheduleListResponse({
    final List<ScheduleModel> items,
    final int total,
  }) = _$ScheduleListResponseImpl;

  factory _ScheduleListResponse.fromJson(Map<String, dynamic> json) =
      _$ScheduleListResponseImpl.fromJson;

  @override
  List<ScheduleModel> get items;
  @override
  int get total;

  /// Create a copy of ScheduleListResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScheduleListResponseImplCopyWith<_$ScheduleListResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}

MonthlyScheduleParams _$MonthlyScheduleParamsFromJson(
  Map<String, dynamic> json,
) {
  return _MonthlyScheduleParams.fromJson(json);
}

/// @nodoc
mixin _$MonthlyScheduleParams {
  int get year => throw _privateConstructorUsedError;
  int get month => throw _privateConstructorUsedError;
  String? get memberId => throw _privateConstructorUsedError;

  /// Serializes this MonthlyScheduleParams to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MonthlyScheduleParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MonthlyScheduleParamsCopyWith<MonthlyScheduleParams> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MonthlyScheduleParamsCopyWith<$Res> {
  factory $MonthlyScheduleParamsCopyWith(
    MonthlyScheduleParams value,
    $Res Function(MonthlyScheduleParams) then,
  ) = _$MonthlyScheduleParamsCopyWithImpl<$Res, MonthlyScheduleParams>;
  @useResult
  $Res call({int year, int month, String? memberId});
}

/// @nodoc
class _$MonthlyScheduleParamsCopyWithImpl<
  $Res,
  $Val extends MonthlyScheduleParams
>
    implements $MonthlyScheduleParamsCopyWith<$Res> {
  _$MonthlyScheduleParamsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MonthlyScheduleParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? year = null,
    Object? month = null,
    Object? memberId = freezed,
  }) {
    return _then(
      _value.copyWith(
            year: null == year
                ? _value.year
                : year // ignore: cast_nullable_to_non_nullable
                      as int,
            month: null == month
                ? _value.month
                : month // ignore: cast_nullable_to_non_nullable
                      as int,
            memberId: freezed == memberId
                ? _value.memberId
                : memberId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MonthlyScheduleParamsImplCopyWith<$Res>
    implements $MonthlyScheduleParamsCopyWith<$Res> {
  factory _$$MonthlyScheduleParamsImplCopyWith(
    _$MonthlyScheduleParamsImpl value,
    $Res Function(_$MonthlyScheduleParamsImpl) then,
  ) = __$$MonthlyScheduleParamsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int year, int month, String? memberId});
}

/// @nodoc
class __$$MonthlyScheduleParamsImplCopyWithImpl<$Res>
    extends
        _$MonthlyScheduleParamsCopyWithImpl<$Res, _$MonthlyScheduleParamsImpl>
    implements _$$MonthlyScheduleParamsImplCopyWith<$Res> {
  __$$MonthlyScheduleParamsImplCopyWithImpl(
    _$MonthlyScheduleParamsImpl _value,
    $Res Function(_$MonthlyScheduleParamsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MonthlyScheduleParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? year = null,
    Object? month = null,
    Object? memberId = freezed,
  }) {
    return _then(
      _$MonthlyScheduleParamsImpl(
        year: null == year
            ? _value.year
            : year // ignore: cast_nullable_to_non_nullable
                  as int,
        month: null == month
            ? _value.month
            : month // ignore: cast_nullable_to_non_nullable
                  as int,
        memberId: freezed == memberId
            ? _value.memberId
            : memberId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MonthlyScheduleParamsImpl implements _MonthlyScheduleParams {
  const _$MonthlyScheduleParamsImpl({
    required this.year,
    required this.month,
    this.memberId,
  });

  factory _$MonthlyScheduleParamsImpl.fromJson(Map<String, dynamic> json) =>
      _$$MonthlyScheduleParamsImplFromJson(json);

  @override
  final int year;
  @override
  final int month;
  @override
  final String? memberId;

  @override
  String toString() {
    return 'MonthlyScheduleParams(year: $year, month: $month, memberId: $memberId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MonthlyScheduleParamsImpl &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, year, month, memberId);

  /// Create a copy of MonthlyScheduleParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MonthlyScheduleParamsImplCopyWith<_$MonthlyScheduleParamsImpl>
  get copyWith =>
      __$$MonthlyScheduleParamsImplCopyWithImpl<_$MonthlyScheduleParamsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MonthlyScheduleParamsImplToJson(this);
  }
}

abstract class _MonthlyScheduleParams implements MonthlyScheduleParams {
  const factory _MonthlyScheduleParams({
    required final int year,
    required final int month,
    final String? memberId,
  }) = _$MonthlyScheduleParamsImpl;

  factory _MonthlyScheduleParams.fromJson(Map<String, dynamic> json) =
      _$MonthlyScheduleParamsImpl.fromJson;

  @override
  int get year;
  @override
  int get month;
  @override
  String? get memberId;

  /// Create a copy of MonthlyScheduleParams
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MonthlyScheduleParamsImplCopyWith<_$MonthlyScheduleParamsImpl>
  get copyWith => throw _privateConstructorUsedError;
}
