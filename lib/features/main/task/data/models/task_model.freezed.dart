// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) {
  return _CategoryModel.fromJson(json);
}

/// @nodoc
mixin _$CategoryModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String? get groupId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get emoji => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this CategoryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoryModelCopyWith<CategoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryModelCopyWith<$Res> {
  factory $CategoryModelCopyWith(
    CategoryModel value,
    $Res Function(CategoryModel) then,
  ) = _$CategoryModelCopyWithImpl<$Res, CategoryModel>;
  @useResult
  $Res call({
    String id,
    String userId,
    String? groupId,
    String name,
    String? description,
    String? emoji,
    String? color,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$CategoryModelCopyWithImpl<$Res, $Val extends CategoryModel>
    implements $CategoryModelCopyWith<$Res> {
  _$CategoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? groupId = freezed,
    Object? name = null,
    Object? description = freezed,
    Object? emoji = freezed,
    Object? color = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            groupId: freezed == groupId
                ? _value.groupId
                : groupId // ignore: cast_nullable_to_non_nullable
                      as String?,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            emoji: freezed == emoji
                ? _value.emoji
                : emoji // ignore: cast_nullable_to_non_nullable
                      as String?,
            color: freezed == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as String?,
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
}

/// @nodoc
abstract class _$$CategoryModelImplCopyWith<$Res>
    implements $CategoryModelCopyWith<$Res> {
  factory _$$CategoryModelImplCopyWith(
    _$CategoryModelImpl value,
    $Res Function(_$CategoryModelImpl) then,
  ) = __$$CategoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String? groupId,
    String name,
    String? description,
    String? emoji,
    String? color,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$CategoryModelImplCopyWithImpl<$Res>
    extends _$CategoryModelCopyWithImpl<$Res, _$CategoryModelImpl>
    implements _$$CategoryModelImplCopyWith<$Res> {
  __$$CategoryModelImplCopyWithImpl(
    _$CategoryModelImpl _value,
    $Res Function(_$CategoryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? groupId = freezed,
    Object? name = null,
    Object? description = freezed,
    Object? emoji = freezed,
    Object? color = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$CategoryModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        groupId: freezed == groupId
            ? _value.groupId
            : groupId // ignore: cast_nullable_to_non_nullable
                  as String?,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        emoji: freezed == emoji
            ? _value.emoji
            : emoji // ignore: cast_nullable_to_non_nullable
                  as String?,
        color: freezed == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as String?,
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
class _$CategoryModelImpl implements _CategoryModel {
  const _$CategoryModelImpl({
    required this.id,
    required this.userId,
    this.groupId,
    required this.name,
    this.description,
    this.emoji,
    this.color,
    required this.createdAt,
    required this.updatedAt,
  });

  factory _$CategoryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String? groupId;
  @override
  final String name;
  @override
  final String? description;
  @override
  final String? emoji;
  @override
  final String? color;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'CategoryModel(id: $id, userId: $userId, groupId: $groupId, name: $name, description: $description, emoji: $emoji, color: $color, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.emoji, emoji) || other.emoji == emoji) &&
            (identical(other.color, color) || other.color == color) &&
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
    userId,
    groupId,
    name,
    description,
    emoji,
    color,
    createdAt,
    updatedAt,
  );

  /// Create a copy of CategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryModelImplCopyWith<_$CategoryModelImpl> get copyWith =>
      __$$CategoryModelImplCopyWithImpl<_$CategoryModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryModelImplToJson(this);
  }
}

abstract class _CategoryModel implements CategoryModel {
  const factory _CategoryModel({
    required final String id,
    required final String userId,
    final String? groupId,
    required final String name,
    final String? description,
    final String? emoji,
    final String? color,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$CategoryModelImpl;

  factory _CategoryModel.fromJson(Map<String, dynamic> json) =
      _$CategoryModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String? get groupId;
  @override
  String get name;
  @override
  String? get description;
  @override
  String? get emoji;
  @override
  String? get color;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of CategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryModelImplCopyWith<_$CategoryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RecurringModel _$RecurringModelFromJson(Map<String, dynamic> json) {
  return _RecurringModel.fromJson(json);
}

/// @nodoc
mixin _$RecurringModel {
  String get id => throw _privateConstructorUsedError;
  String get ruleType => throw _privateConstructorUsedError;
  Map<String, dynamic>? get ruleConfig => throw _privateConstructorUsedError;
  String get generationType => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this RecurringModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecurringModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecurringModelCopyWith<RecurringModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecurringModelCopyWith<$Res> {
  factory $RecurringModelCopyWith(
    RecurringModel value,
    $Res Function(RecurringModel) then,
  ) = _$RecurringModelCopyWithImpl<$Res, RecurringModel>;
  @useResult
  $Res call({
    String id,
    String ruleType,
    Map<String, dynamic>? ruleConfig,
    String generationType,
    bool isActive,
  });
}

/// @nodoc
class _$RecurringModelCopyWithImpl<$Res, $Val extends RecurringModel>
    implements $RecurringModelCopyWith<$Res> {
  _$RecurringModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecurringModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ruleType = null,
    Object? ruleConfig = freezed,
    Object? generationType = null,
    Object? isActive = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            ruleType: null == ruleType
                ? _value.ruleType
                : ruleType // ignore: cast_nullable_to_non_nullable
                      as String,
            ruleConfig: freezed == ruleConfig
                ? _value.ruleConfig
                : ruleConfig // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            generationType: null == generationType
                ? _value.generationType
                : generationType // ignore: cast_nullable_to_non_nullable
                      as String,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RecurringModelImplCopyWith<$Res>
    implements $RecurringModelCopyWith<$Res> {
  factory _$$RecurringModelImplCopyWith(
    _$RecurringModelImpl value,
    $Res Function(_$RecurringModelImpl) then,
  ) = __$$RecurringModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String ruleType,
    Map<String, dynamic>? ruleConfig,
    String generationType,
    bool isActive,
  });
}

/// @nodoc
class __$$RecurringModelImplCopyWithImpl<$Res>
    extends _$RecurringModelCopyWithImpl<$Res, _$RecurringModelImpl>
    implements _$$RecurringModelImplCopyWith<$Res> {
  __$$RecurringModelImplCopyWithImpl(
    _$RecurringModelImpl _value,
    $Res Function(_$RecurringModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecurringModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ruleType = null,
    Object? ruleConfig = freezed,
    Object? generationType = null,
    Object? isActive = null,
  }) {
    return _then(
      _$RecurringModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        ruleType: null == ruleType
            ? _value.ruleType
            : ruleType // ignore: cast_nullable_to_non_nullable
                  as String,
        ruleConfig: freezed == ruleConfig
            ? _value._ruleConfig
            : ruleConfig // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        generationType: null == generationType
            ? _value.generationType
            : generationType // ignore: cast_nullable_to_non_nullable
                  as String,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RecurringModelImpl implements _RecurringModel {
  const _$RecurringModelImpl({
    required this.id,
    required this.ruleType,
    final Map<String, dynamic>? ruleConfig,
    required this.generationType,
    this.isActive = true,
  }) : _ruleConfig = ruleConfig;

  factory _$RecurringModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecurringModelImplFromJson(json);

  @override
  final String id;
  @override
  final String ruleType;
  final Map<String, dynamic>? _ruleConfig;
  @override
  Map<String, dynamic>? get ruleConfig {
    final value = _ruleConfig;
    if (value == null) return null;
    if (_ruleConfig is EqualUnmodifiableMapView) return _ruleConfig;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String generationType;
  @override
  @JsonKey()
  final bool isActive;

  @override
  String toString() {
    return 'RecurringModel(id: $id, ruleType: $ruleType, ruleConfig: $ruleConfig, generationType: $generationType, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecurringModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ruleType, ruleType) ||
                other.ruleType == ruleType) &&
            const DeepCollectionEquality().equals(
              other._ruleConfig,
              _ruleConfig,
            ) &&
            (identical(other.generationType, generationType) ||
                other.generationType == generationType) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    ruleType,
    const DeepCollectionEquality().hash(_ruleConfig),
    generationType,
    isActive,
  );

  /// Create a copy of RecurringModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecurringModelImplCopyWith<_$RecurringModelImpl> get copyWith =>
      __$$RecurringModelImplCopyWithImpl<_$RecurringModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RecurringModelImplToJson(this);
  }
}

abstract class _RecurringModel implements RecurringModel {
  const factory _RecurringModel({
    required final String id,
    required final String ruleType,
    final Map<String, dynamic>? ruleConfig,
    required final String generationType,
    final bool isActive,
  }) = _$RecurringModelImpl;

  factory _RecurringModel.fromJson(Map<String, dynamic> json) =
      _$RecurringModelImpl.fromJson;

  @override
  String get id;
  @override
  String get ruleType;
  @override
  Map<String, dynamic>? get ruleConfig;
  @override
  String get generationType;
  @override
  bool get isActive;

  /// Create a copy of RecurringModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecurringModelImplCopyWith<_$RecurringModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TaskReminderResponse _$TaskReminderResponseFromJson(Map<String, dynamic> json) {
  return _TaskReminderResponse.fromJson(json);
}

/// @nodoc
mixin _$TaskReminderResponse {
  String get id => throw _privateConstructorUsedError;
  String get reminderType => throw _privateConstructorUsedError;
  int get offsetMinutes => throw _privateConstructorUsedError;
  DateTime? get sentAt => throw _privateConstructorUsedError;

  /// Serializes this TaskReminderResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaskReminderResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskReminderResponseCopyWith<TaskReminderResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskReminderResponseCopyWith<$Res> {
  factory $TaskReminderResponseCopyWith(
    TaskReminderResponse value,
    $Res Function(TaskReminderResponse) then,
  ) = _$TaskReminderResponseCopyWithImpl<$Res, TaskReminderResponse>;
  @useResult
  $Res call({
    String id,
    String reminderType,
    int offsetMinutes,
    DateTime? sentAt,
  });
}

/// @nodoc
class _$TaskReminderResponseCopyWithImpl<
  $Res,
  $Val extends TaskReminderResponse
>
    implements $TaskReminderResponseCopyWith<$Res> {
  _$TaskReminderResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskReminderResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reminderType = null,
    Object? offsetMinutes = null,
    Object? sentAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            reminderType: null == reminderType
                ? _value.reminderType
                : reminderType // ignore: cast_nullable_to_non_nullable
                      as String,
            offsetMinutes: null == offsetMinutes
                ? _value.offsetMinutes
                : offsetMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            sentAt: freezed == sentAt
                ? _value.sentAt
                : sentAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TaskReminderResponseImplCopyWith<$Res>
    implements $TaskReminderResponseCopyWith<$Res> {
  factory _$$TaskReminderResponseImplCopyWith(
    _$TaskReminderResponseImpl value,
    $Res Function(_$TaskReminderResponseImpl) then,
  ) = __$$TaskReminderResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String reminderType,
    int offsetMinutes,
    DateTime? sentAt,
  });
}

/// @nodoc
class __$$TaskReminderResponseImplCopyWithImpl<$Res>
    extends _$TaskReminderResponseCopyWithImpl<$Res, _$TaskReminderResponseImpl>
    implements _$$TaskReminderResponseImplCopyWith<$Res> {
  __$$TaskReminderResponseImplCopyWithImpl(
    _$TaskReminderResponseImpl _value,
    $Res Function(_$TaskReminderResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TaskReminderResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reminderType = null,
    Object? offsetMinutes = null,
    Object? sentAt = freezed,
  }) {
    return _then(
      _$TaskReminderResponseImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        reminderType: null == reminderType
            ? _value.reminderType
            : reminderType // ignore: cast_nullable_to_non_nullable
                  as String,
        offsetMinutes: null == offsetMinutes
            ? _value.offsetMinutes
            : offsetMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        sentAt: freezed == sentAt
            ? _value.sentAt
            : sentAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskReminderResponseImpl implements _TaskReminderResponse {
  const _$TaskReminderResponseImpl({
    required this.id,
    required this.reminderType,
    required this.offsetMinutes,
    this.sentAt,
  });

  factory _$TaskReminderResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskReminderResponseImplFromJson(json);

  @override
  final String id;
  @override
  final String reminderType;
  @override
  final int offsetMinutes;
  @override
  final DateTime? sentAt;

  @override
  String toString() {
    return 'TaskReminderResponse(id: $id, reminderType: $reminderType, offsetMinutes: $offsetMinutes, sentAt: $sentAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskReminderResponseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.reminderType, reminderType) ||
                other.reminderType == reminderType) &&
            (identical(other.offsetMinutes, offsetMinutes) ||
                other.offsetMinutes == offsetMinutes) &&
            (identical(other.sentAt, sentAt) || other.sentAt == sentAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, reminderType, offsetMinutes, sentAt);

  /// Create a copy of TaskReminderResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskReminderResponseImplCopyWith<_$TaskReminderResponseImpl>
  get copyWith =>
      __$$TaskReminderResponseImplCopyWithImpl<_$TaskReminderResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskReminderResponseImplToJson(this);
  }
}

abstract class _TaskReminderResponse implements TaskReminderResponse {
  const factory _TaskReminderResponse({
    required final String id,
    required final String reminderType,
    required final int offsetMinutes,
    final DateTime? sentAt,
  }) = _$TaskReminderResponseImpl;

  factory _TaskReminderResponse.fromJson(Map<String, dynamic> json) =
      _$TaskReminderResponseImpl.fromJson;

  @override
  String get id;
  @override
  String get reminderType;
  @override
  int get offsetMinutes;
  @override
  DateTime? get sentAt;

  /// Create a copy of TaskReminderResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskReminderResponseImplCopyWith<_$TaskReminderResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}

TaskHistoryModel _$TaskHistoryModelFromJson(Map<String, dynamic> json) {
  return _TaskHistoryModel.fromJson(json);
}

/// @nodoc
mixin _$TaskHistoryModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String? get action => throw _privateConstructorUsedError;
  Map<String, dynamic>? get changes => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this TaskHistoryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaskHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskHistoryModelCopyWith<TaskHistoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskHistoryModelCopyWith<$Res> {
  factory $TaskHistoryModelCopyWith(
    TaskHistoryModel value,
    $Res Function(TaskHistoryModel) then,
  ) = _$TaskHistoryModelCopyWithImpl<$Res, TaskHistoryModel>;
  @useResult
  $Res call({
    String id,
    String userId,
    String? action,
    Map<String, dynamic>? changes,
    DateTime createdAt,
  });
}

/// @nodoc
class _$TaskHistoryModelCopyWithImpl<$Res, $Val extends TaskHistoryModel>
    implements $TaskHistoryModelCopyWith<$Res> {
  _$TaskHistoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? action = freezed,
    Object? changes = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            action: freezed == action
                ? _value.action
                : action // ignore: cast_nullable_to_non_nullable
                      as String?,
            changes: freezed == changes
                ? _value.changes
                : changes // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TaskHistoryModelImplCopyWith<$Res>
    implements $TaskHistoryModelCopyWith<$Res> {
  factory _$$TaskHistoryModelImplCopyWith(
    _$TaskHistoryModelImpl value,
    $Res Function(_$TaskHistoryModelImpl) then,
  ) = __$$TaskHistoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String? action,
    Map<String, dynamic>? changes,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$TaskHistoryModelImplCopyWithImpl<$Res>
    extends _$TaskHistoryModelCopyWithImpl<$Res, _$TaskHistoryModelImpl>
    implements _$$TaskHistoryModelImplCopyWith<$Res> {
  __$$TaskHistoryModelImplCopyWithImpl(
    _$TaskHistoryModelImpl _value,
    $Res Function(_$TaskHistoryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TaskHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? action = freezed,
    Object? changes = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _$TaskHistoryModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        action: freezed == action
            ? _value.action
            : action // ignore: cast_nullable_to_non_nullable
                  as String?,
        changes: freezed == changes
            ? _value._changes
            : changes // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskHistoryModelImpl implements _TaskHistoryModel {
  const _$TaskHistoryModelImpl({
    required this.id,
    required this.userId,
    this.action,
    final Map<String, dynamic>? changes,
    required this.createdAt,
  }) : _changes = changes;

  factory _$TaskHistoryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskHistoryModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String? action;
  final Map<String, dynamic>? _changes;
  @override
  Map<String, dynamic>? get changes {
    final value = _changes;
    if (value == null) return null;
    if (_changes is EqualUnmodifiableMapView) return _changes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'TaskHistoryModel(id: $id, userId: $userId, action: $action, changes: $changes, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskHistoryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.action, action) || other.action == action) &&
            const DeepCollectionEquality().equals(other._changes, _changes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    action,
    const DeepCollectionEquality().hash(_changes),
    createdAt,
  );

  /// Create a copy of TaskHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskHistoryModelImplCopyWith<_$TaskHistoryModelImpl> get copyWith =>
      __$$TaskHistoryModelImplCopyWithImpl<_$TaskHistoryModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskHistoryModelImplToJson(this);
  }
}

abstract class _TaskHistoryModel implements TaskHistoryModel {
  const factory _TaskHistoryModel({
    required final String id,
    required final String userId,
    final String? action,
    final Map<String, dynamic>? changes,
    required final DateTime createdAt,
  }) = _$TaskHistoryModelImpl;

  factory _TaskHistoryModel.fromJson(Map<String, dynamic> json) =
      _$TaskHistoryModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String? get action;
  @override
  Map<String, dynamic>? get changes;
  @override
  DateTime get createdAt;

  /// Create a copy of TaskHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskHistoryModelImplCopyWith<_$TaskHistoryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ParticipantUserModel _$ParticipantUserModelFromJson(Map<String, dynamic> json) {
  return _ParticipantUserModel.fromJson(json);
}

/// @nodoc
mixin _$ParticipantUserModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get profileImageKey => throw _privateConstructorUsedError;

  /// Serializes this ParticipantUserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ParticipantUserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ParticipantUserModelCopyWith<ParticipantUserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ParticipantUserModelCopyWith<$Res> {
  factory $ParticipantUserModelCopyWith(
    ParticipantUserModel value,
    $Res Function(ParticipantUserModel) then,
  ) = _$ParticipantUserModelCopyWithImpl<$Res, ParticipantUserModel>;
  @useResult
  $Res call({String id, String name, String? profileImageKey});
}

/// @nodoc
class _$ParticipantUserModelCopyWithImpl<
  $Res,
  $Val extends ParticipantUserModel
>
    implements $ParticipantUserModelCopyWith<$Res> {
  _$ParticipantUserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ParticipantUserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? profileImageKey = freezed,
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
            profileImageKey: freezed == profileImageKey
                ? _value.profileImageKey
                : profileImageKey // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ParticipantUserModelImplCopyWith<$Res>
    implements $ParticipantUserModelCopyWith<$Res> {
  factory _$$ParticipantUserModelImplCopyWith(
    _$ParticipantUserModelImpl value,
    $Res Function(_$ParticipantUserModelImpl) then,
  ) = __$$ParticipantUserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String? profileImageKey});
}

/// @nodoc
class __$$ParticipantUserModelImplCopyWithImpl<$Res>
    extends _$ParticipantUserModelCopyWithImpl<$Res, _$ParticipantUserModelImpl>
    implements _$$ParticipantUserModelImplCopyWith<$Res> {
  __$$ParticipantUserModelImplCopyWithImpl(
    _$ParticipantUserModelImpl _value,
    $Res Function(_$ParticipantUserModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ParticipantUserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? profileImageKey = freezed,
  }) {
    return _then(
      _$ParticipantUserModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        profileImageKey: freezed == profileImageKey
            ? _value.profileImageKey
            : profileImageKey // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ParticipantUserModelImpl implements _ParticipantUserModel {
  const _$ParticipantUserModelImpl({
    required this.id,
    required this.name,
    this.profileImageKey,
  });

  factory _$ParticipantUserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ParticipantUserModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? profileImageKey;

  @override
  String toString() {
    return 'ParticipantUserModel(id: $id, name: $name, profileImageKey: $profileImageKey)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ParticipantUserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.profileImageKey, profileImageKey) ||
                other.profileImageKey == profileImageKey));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, profileImageKey);

  /// Create a copy of ParticipantUserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ParticipantUserModelImplCopyWith<_$ParticipantUserModelImpl>
  get copyWith =>
      __$$ParticipantUserModelImplCopyWithImpl<_$ParticipantUserModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ParticipantUserModelImplToJson(this);
  }
}

abstract class _ParticipantUserModel implements ParticipantUserModel {
  const factory _ParticipantUserModel({
    required final String id,
    required final String name,
    final String? profileImageKey,
  }) = _$ParticipantUserModelImpl;

  factory _ParticipantUserModel.fromJson(Map<String, dynamic> json) =
      _$ParticipantUserModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get profileImageKey;

  /// Create a copy of ParticipantUserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ParticipantUserModelImplCopyWith<_$ParticipantUserModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

TaskParticipantModel _$TaskParticipantModelFromJson(Map<String, dynamic> json) {
  return _TaskParticipantModel.fromJson(json);
}

/// @nodoc
mixin _$TaskParticipantModel {
  String get id => throw _privateConstructorUsedError;
  String get taskId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  ParticipantUserModel? get user => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this TaskParticipantModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaskParticipantModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskParticipantModelCopyWith<TaskParticipantModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskParticipantModelCopyWith<$Res> {
  factory $TaskParticipantModelCopyWith(
    TaskParticipantModel value,
    $Res Function(TaskParticipantModel) then,
  ) = _$TaskParticipantModelCopyWithImpl<$Res, TaskParticipantModel>;
  @useResult
  $Res call({
    String id,
    String taskId,
    String userId,
    ParticipantUserModel? user,
    DateTime createdAt,
  });

  $ParticipantUserModelCopyWith<$Res>? get user;
}

/// @nodoc
class _$TaskParticipantModelCopyWithImpl<
  $Res,
  $Val extends TaskParticipantModel
>
    implements $TaskParticipantModelCopyWith<$Res> {
  _$TaskParticipantModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskParticipantModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? taskId = null,
    Object? userId = null,
    Object? user = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            taskId: null == taskId
                ? _value.taskId
                : taskId // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            user: freezed == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as ParticipantUserModel?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }

  /// Create a copy of TaskParticipantModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ParticipantUserModelCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $ParticipantUserModelCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TaskParticipantModelImplCopyWith<$Res>
    implements $TaskParticipantModelCopyWith<$Res> {
  factory _$$TaskParticipantModelImplCopyWith(
    _$TaskParticipantModelImpl value,
    $Res Function(_$TaskParticipantModelImpl) then,
  ) = __$$TaskParticipantModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String taskId,
    String userId,
    ParticipantUserModel? user,
    DateTime createdAt,
  });

  @override
  $ParticipantUserModelCopyWith<$Res>? get user;
}

/// @nodoc
class __$$TaskParticipantModelImplCopyWithImpl<$Res>
    extends _$TaskParticipantModelCopyWithImpl<$Res, _$TaskParticipantModelImpl>
    implements _$$TaskParticipantModelImplCopyWith<$Res> {
  __$$TaskParticipantModelImplCopyWithImpl(
    _$TaskParticipantModelImpl _value,
    $Res Function(_$TaskParticipantModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TaskParticipantModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? taskId = null,
    Object? userId = null,
    Object? user = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _$TaskParticipantModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        taskId: null == taskId
            ? _value.taskId
            : taskId // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        user: freezed == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as ParticipantUserModel?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskParticipantModelImpl implements _TaskParticipantModel {
  const _$TaskParticipantModelImpl({
    required this.id,
    required this.taskId,
    required this.userId,
    this.user,
    required this.createdAt,
  });

  factory _$TaskParticipantModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskParticipantModelImplFromJson(json);

  @override
  final String id;
  @override
  final String taskId;
  @override
  final String userId;
  @override
  final ParticipantUserModel? user;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'TaskParticipantModel(id: $id, taskId: $taskId, userId: $userId, user: $user, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskParticipantModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.taskId, taskId) || other.taskId == taskId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, taskId, userId, user, createdAt);

  /// Create a copy of TaskParticipantModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskParticipantModelImplCopyWith<_$TaskParticipantModelImpl>
  get copyWith =>
      __$$TaskParticipantModelImplCopyWithImpl<_$TaskParticipantModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskParticipantModelImplToJson(this);
  }
}

abstract class _TaskParticipantModel implements TaskParticipantModel {
  const factory _TaskParticipantModel({
    required final String id,
    required final String taskId,
    required final String userId,
    final ParticipantUserModel? user,
    required final DateTime createdAt,
  }) = _$TaskParticipantModelImpl;

  factory _TaskParticipantModel.fromJson(Map<String, dynamic> json) =
      _$TaskParticipantModelImpl.fromJson;

  @override
  String get id;
  @override
  String get taskId;
  @override
  String get userId;
  @override
  ParticipantUserModel? get user;
  @override
  DateTime get createdAt;

  /// Create a copy of TaskParticipantModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskParticipantModelImplCopyWith<_$TaskParticipantModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}

TaskModel _$TaskModelFromJson(Map<String, dynamic> json) {
  return _TaskModel.fromJson(json);
}

/// @nodoc
mixin _$TaskModel {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String? get groupId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  TaskType? get type => throw _privateConstructorUsedError;
  TaskPriority? get priority => throw _privateConstructorUsedError;
  CategoryModel? get category => throw _privateConstructorUsedError;
  DateTime? get scheduledAt => throw _privateConstructorUsedError;
  DateTime? get dueAt => throw _privateConstructorUsedError;
  int? get daysUntilDue => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  RecurringModel? get recurring => throw _privateConstructorUsedError;
  List<TaskParticipantModel> get participants =>
      throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this TaskModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaskModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskModelCopyWith<TaskModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskModelCopyWith<$Res> {
  factory $TaskModelCopyWith(TaskModel value, $Res Function(TaskModel) then) =
      _$TaskModelCopyWithImpl<$Res, TaskModel>;
  @useResult
  $Res call({
    String id,
    String userId,
    String? groupId,
    String title,
    String? description,
    String? location,
    TaskType? type,
    TaskPriority? priority,
    CategoryModel? category,
    DateTime? scheduledAt,
    DateTime? dueAt,
    int? daysUntilDue,
    bool isCompleted,
    DateTime? completedAt,
    RecurringModel? recurring,
    List<TaskParticipantModel> participants,
    DateTime createdAt,
    DateTime updatedAt,
  });

  $CategoryModelCopyWith<$Res>? get category;
  $RecurringModelCopyWith<$Res>? get recurring;
}

/// @nodoc
class _$TaskModelCopyWithImpl<$Res, $Val extends TaskModel>
    implements $TaskModelCopyWith<$Res> {
  _$TaskModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? groupId = freezed,
    Object? title = null,
    Object? description = freezed,
    Object? location = freezed,
    Object? type = freezed,
    Object? priority = freezed,
    Object? category = freezed,
    Object? scheduledAt = freezed,
    Object? dueAt = freezed,
    Object? daysUntilDue = freezed,
    Object? isCompleted = null,
    Object? completedAt = freezed,
    Object? recurring = freezed,
    Object? participants = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            groupId: freezed == groupId
                ? _value.groupId
                : groupId // ignore: cast_nullable_to_non_nullable
                      as String?,
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
            type: freezed == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as TaskType?,
            priority: freezed == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as TaskPriority?,
            category: freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as CategoryModel?,
            scheduledAt: freezed == scheduledAt
                ? _value.scheduledAt
                : scheduledAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            dueAt: freezed == dueAt
                ? _value.dueAt
                : dueAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            daysUntilDue: freezed == daysUntilDue
                ? _value.daysUntilDue
                : daysUntilDue // ignore: cast_nullable_to_non_nullable
                      as int?,
            isCompleted: null == isCompleted
                ? _value.isCompleted
                : isCompleted // ignore: cast_nullable_to_non_nullable
                      as bool,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            recurring: freezed == recurring
                ? _value.recurring
                : recurring // ignore: cast_nullable_to_non_nullable
                      as RecurringModel?,
            participants: null == participants
                ? _value.participants
                : participants // ignore: cast_nullable_to_non_nullable
                      as List<TaskParticipantModel>,
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

  /// Create a copy of TaskModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CategoryModelCopyWith<$Res>? get category {
    if (_value.category == null) {
      return null;
    }

    return $CategoryModelCopyWith<$Res>(_value.category!, (value) {
      return _then(_value.copyWith(category: value) as $Val);
    });
  }

  /// Create a copy of TaskModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RecurringModelCopyWith<$Res>? get recurring {
    if (_value.recurring == null) {
      return null;
    }

    return $RecurringModelCopyWith<$Res>(_value.recurring!, (value) {
      return _then(_value.copyWith(recurring: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TaskModelImplCopyWith<$Res>
    implements $TaskModelCopyWith<$Res> {
  factory _$$TaskModelImplCopyWith(
    _$TaskModelImpl value,
    $Res Function(_$TaskModelImpl) then,
  ) = __$$TaskModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String? groupId,
    String title,
    String? description,
    String? location,
    TaskType? type,
    TaskPriority? priority,
    CategoryModel? category,
    DateTime? scheduledAt,
    DateTime? dueAt,
    int? daysUntilDue,
    bool isCompleted,
    DateTime? completedAt,
    RecurringModel? recurring,
    List<TaskParticipantModel> participants,
    DateTime createdAt,
    DateTime updatedAt,
  });

  @override
  $CategoryModelCopyWith<$Res>? get category;
  @override
  $RecurringModelCopyWith<$Res>? get recurring;
}

/// @nodoc
class __$$TaskModelImplCopyWithImpl<$Res>
    extends _$TaskModelCopyWithImpl<$Res, _$TaskModelImpl>
    implements _$$TaskModelImplCopyWith<$Res> {
  __$$TaskModelImplCopyWithImpl(
    _$TaskModelImpl _value,
    $Res Function(_$TaskModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TaskModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? groupId = freezed,
    Object? title = null,
    Object? description = freezed,
    Object? location = freezed,
    Object? type = freezed,
    Object? priority = freezed,
    Object? category = freezed,
    Object? scheduledAt = freezed,
    Object? dueAt = freezed,
    Object? daysUntilDue = freezed,
    Object? isCompleted = null,
    Object? completedAt = freezed,
    Object? recurring = freezed,
    Object? participants = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$TaskModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        groupId: freezed == groupId
            ? _value.groupId
            : groupId // ignore: cast_nullable_to_non_nullable
                  as String?,
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
        type: freezed == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as TaskType?,
        priority: freezed == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as TaskPriority?,
        category: freezed == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as CategoryModel?,
        scheduledAt: freezed == scheduledAt
            ? _value.scheduledAt
            : scheduledAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        dueAt: freezed == dueAt
            ? _value.dueAt
            : dueAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        daysUntilDue: freezed == daysUntilDue
            ? _value.daysUntilDue
            : daysUntilDue // ignore: cast_nullable_to_non_nullable
                  as int?,
        isCompleted: null == isCompleted
            ? _value.isCompleted
            : isCompleted // ignore: cast_nullable_to_non_nullable
                  as bool,
        completedAt: freezed == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        recurring: freezed == recurring
            ? _value.recurring
            : recurring // ignore: cast_nullable_to_non_nullable
                  as RecurringModel?,
        participants: null == participants
            ? _value._participants
            : participants // ignore: cast_nullable_to_non_nullable
                  as List<TaskParticipantModel>,
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
class _$TaskModelImpl extends _TaskModel {
  const _$TaskModelImpl({
    required this.id,
    required this.userId,
    this.groupId,
    required this.title,
    this.description,
    this.location,
    this.type,
    this.priority,
    this.category,
    this.scheduledAt,
    this.dueAt,
    this.daysUntilDue,
    this.isCompleted = false,
    this.completedAt,
    this.recurring,
    final List<TaskParticipantModel> participants = const [],
    required this.createdAt,
    required this.updatedAt,
  }) : _participants = participants,
       super._();

  factory _$TaskModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskModelImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String? groupId;
  @override
  final String title;
  @override
  final String? description;
  @override
  final String? location;
  @override
  final TaskType? type;
  @override
  final TaskPriority? priority;
  @override
  final CategoryModel? category;
  @override
  final DateTime? scheduledAt;
  @override
  final DateTime? dueAt;
  @override
  final int? daysUntilDue;
  @override
  @JsonKey()
  final bool isCompleted;
  @override
  final DateTime? completedAt;
  @override
  final RecurringModel? recurring;
  final List<TaskParticipantModel> _participants;
  @override
  @JsonKey()
  List<TaskParticipantModel> get participants {
    if (_participants is EqualUnmodifiableListView) return _participants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_participants);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'TaskModel(id: $id, userId: $userId, groupId: $groupId, title: $title, description: $description, location: $location, type: $type, priority: $priority, category: $category, scheduledAt: $scheduledAt, dueAt: $dueAt, daysUntilDue: $daysUntilDue, isCompleted: $isCompleted, completedAt: $completedAt, recurring: $recurring, participants: $participants, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.scheduledAt, scheduledAt) ||
                other.scheduledAt == scheduledAt) &&
            (identical(other.dueAt, dueAt) || other.dueAt == dueAt) &&
            (identical(other.daysUntilDue, daysUntilDue) ||
                other.daysUntilDue == daysUntilDue) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.recurring, recurring) ||
                other.recurring == recurring) &&
            const DeepCollectionEquality().equals(
              other._participants,
              _participants,
            ) &&
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
    userId,
    groupId,
    title,
    description,
    location,
    type,
    priority,
    category,
    scheduledAt,
    dueAt,
    daysUntilDue,
    isCompleted,
    completedAt,
    recurring,
    const DeepCollectionEquality().hash(_participants),
    createdAt,
    updatedAt,
  );

  /// Create a copy of TaskModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskModelImplCopyWith<_$TaskModelImpl> get copyWith =>
      __$$TaskModelImplCopyWithImpl<_$TaskModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskModelImplToJson(this);
  }
}

abstract class _TaskModel extends TaskModel {
  const factory _TaskModel({
    required final String id,
    required final String userId,
    final String? groupId,
    required final String title,
    final String? description,
    final String? location,
    final TaskType? type,
    final TaskPriority? priority,
    final CategoryModel? category,
    final DateTime? scheduledAt,
    final DateTime? dueAt,
    final int? daysUntilDue,
    final bool isCompleted,
    final DateTime? completedAt,
    final RecurringModel? recurring,
    final List<TaskParticipantModel> participants,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$TaskModelImpl;
  const _TaskModel._() : super._();

  factory _TaskModel.fromJson(Map<String, dynamic> json) =
      _$TaskModelImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String? get groupId;
  @override
  String get title;
  @override
  String? get description;
  @override
  String? get location;
  @override
  TaskType? get type;
  @override
  TaskPriority? get priority;
  @override
  CategoryModel? get category;
  @override
  DateTime? get scheduledAt;
  @override
  DateTime? get dueAt;
  @override
  int? get daysUntilDue;
  @override
  bool get isCompleted;
  @override
  DateTime? get completedAt;
  @override
  RecurringModel? get recurring;
  @override
  List<TaskParticipantModel> get participants;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of TaskModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskModelImplCopyWith<_$TaskModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$TaskDetailModel {
  TaskModel get task => throw _privateConstructorUsedError;
  List<TaskReminderResponse> get reminders =>
      throw _privateConstructorUsedError;
  List<TaskHistoryModel> get histories => throw _privateConstructorUsedError;

  /// Create a copy of TaskDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskDetailModelCopyWith<TaskDetailModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskDetailModelCopyWith<$Res> {
  factory $TaskDetailModelCopyWith(
    TaskDetailModel value,
    $Res Function(TaskDetailModel) then,
  ) = _$TaskDetailModelCopyWithImpl<$Res, TaskDetailModel>;
  @useResult
  $Res call({
    TaskModel task,
    List<TaskReminderResponse> reminders,
    List<TaskHistoryModel> histories,
  });

  $TaskModelCopyWith<$Res> get task;
}

/// @nodoc
class _$TaskDetailModelCopyWithImpl<$Res, $Val extends TaskDetailModel>
    implements $TaskDetailModelCopyWith<$Res> {
  _$TaskDetailModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? task = null,
    Object? reminders = null,
    Object? histories = null,
  }) {
    return _then(
      _value.copyWith(
            task: null == task
                ? _value.task
                : task // ignore: cast_nullable_to_non_nullable
                      as TaskModel,
            reminders: null == reminders
                ? _value.reminders
                : reminders // ignore: cast_nullable_to_non_nullable
                      as List<TaskReminderResponse>,
            histories: null == histories
                ? _value.histories
                : histories // ignore: cast_nullable_to_non_nullable
                      as List<TaskHistoryModel>,
          )
          as $Val,
    );
  }

  /// Create a copy of TaskDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TaskModelCopyWith<$Res> get task {
    return $TaskModelCopyWith<$Res>(_value.task, (value) {
      return _then(_value.copyWith(task: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TaskDetailModelImplCopyWith<$Res>
    implements $TaskDetailModelCopyWith<$Res> {
  factory _$$TaskDetailModelImplCopyWith(
    _$TaskDetailModelImpl value,
    $Res Function(_$TaskDetailModelImpl) then,
  ) = __$$TaskDetailModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    TaskModel task,
    List<TaskReminderResponse> reminders,
    List<TaskHistoryModel> histories,
  });

  @override
  $TaskModelCopyWith<$Res> get task;
}

/// @nodoc
class __$$TaskDetailModelImplCopyWithImpl<$Res>
    extends _$TaskDetailModelCopyWithImpl<$Res, _$TaskDetailModelImpl>
    implements _$$TaskDetailModelImplCopyWith<$Res> {
  __$$TaskDetailModelImplCopyWithImpl(
    _$TaskDetailModelImpl _value,
    $Res Function(_$TaskDetailModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TaskDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? task = null,
    Object? reminders = null,
    Object? histories = null,
  }) {
    return _then(
      _$TaskDetailModelImpl(
        task: null == task
            ? _value.task
            : task // ignore: cast_nullable_to_non_nullable
                  as TaskModel,
        reminders: null == reminders
            ? _value._reminders
            : reminders // ignore: cast_nullable_to_non_nullable
                  as List<TaskReminderResponse>,
        histories: null == histories
            ? _value._histories
            : histories // ignore: cast_nullable_to_non_nullable
                  as List<TaskHistoryModel>,
      ),
    );
  }
}

/// @nodoc

class _$TaskDetailModelImpl implements _TaskDetailModel {
  const _$TaskDetailModelImpl({
    required this.task,
    final List<TaskReminderResponse> reminders = const [],
    final List<TaskHistoryModel> histories = const [],
  }) : _reminders = reminders,
       _histories = histories;

  @override
  final TaskModel task;
  final List<TaskReminderResponse> _reminders;
  @override
  @JsonKey()
  List<TaskReminderResponse> get reminders {
    if (_reminders is EqualUnmodifiableListView) return _reminders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reminders);
  }

  final List<TaskHistoryModel> _histories;
  @override
  @JsonKey()
  List<TaskHistoryModel> get histories {
    if (_histories is EqualUnmodifiableListView) return _histories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_histories);
  }

  @override
  String toString() {
    return 'TaskDetailModel(task: $task, reminders: $reminders, histories: $histories)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskDetailModelImpl &&
            (identical(other.task, task) || other.task == task) &&
            const DeepCollectionEquality().equals(
              other._reminders,
              _reminders,
            ) &&
            const DeepCollectionEquality().equals(
              other._histories,
              _histories,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    task,
    const DeepCollectionEquality().hash(_reminders),
    const DeepCollectionEquality().hash(_histories),
  );

  /// Create a copy of TaskDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskDetailModelImplCopyWith<_$TaskDetailModelImpl> get copyWith =>
      __$$TaskDetailModelImplCopyWithImpl<_$TaskDetailModelImpl>(
        this,
        _$identity,
      );
}

abstract class _TaskDetailModel implements TaskDetailModel {
  const factory _TaskDetailModel({
    required final TaskModel task,
    final List<TaskReminderResponse> reminders,
    final List<TaskHistoryModel> histories,
  }) = _$TaskDetailModelImpl;

  @override
  TaskModel get task;
  @override
  List<TaskReminderResponse> get reminders;
  @override
  List<TaskHistoryModel> get histories;

  /// Create a copy of TaskDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskDetailModelImplCopyWith<_$TaskDetailModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TaskListResponse _$TaskListResponseFromJson(Map<String, dynamic> json) {
  return _TaskListResponse.fromJson(json);
}

/// @nodoc
mixin _$TaskListResponse {
  List<TaskModel> get data => throw _privateConstructorUsedError;
  PaginationMeta get meta => throw _privateConstructorUsedError;

  /// Serializes this TaskListResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaskListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskListResponseCopyWith<TaskListResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskListResponseCopyWith<$Res> {
  factory $TaskListResponseCopyWith(
    TaskListResponse value,
    $Res Function(TaskListResponse) then,
  ) = _$TaskListResponseCopyWithImpl<$Res, TaskListResponse>;
  @useResult
  $Res call({List<TaskModel> data, PaginationMeta meta});

  $PaginationMetaCopyWith<$Res> get meta;
}

/// @nodoc
class _$TaskListResponseCopyWithImpl<$Res, $Val extends TaskListResponse>
    implements $TaskListResponseCopyWith<$Res> {
  _$TaskListResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? data = null, Object? meta = null}) {
    return _then(
      _value.copyWith(
            data: null == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as List<TaskModel>,
            meta: null == meta
                ? _value.meta
                : meta // ignore: cast_nullable_to_non_nullable
                      as PaginationMeta,
          )
          as $Val,
    );
  }

  /// Create a copy of TaskListResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PaginationMetaCopyWith<$Res> get meta {
    return $PaginationMetaCopyWith<$Res>(_value.meta, (value) {
      return _then(_value.copyWith(meta: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TaskListResponseImplCopyWith<$Res>
    implements $TaskListResponseCopyWith<$Res> {
  factory _$$TaskListResponseImplCopyWith(
    _$TaskListResponseImpl value,
    $Res Function(_$TaskListResponseImpl) then,
  ) = __$$TaskListResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<TaskModel> data, PaginationMeta meta});

  @override
  $PaginationMetaCopyWith<$Res> get meta;
}

/// @nodoc
class __$$TaskListResponseImplCopyWithImpl<$Res>
    extends _$TaskListResponseCopyWithImpl<$Res, _$TaskListResponseImpl>
    implements _$$TaskListResponseImplCopyWith<$Res> {
  __$$TaskListResponseImplCopyWithImpl(
    _$TaskListResponseImpl _value,
    $Res Function(_$TaskListResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TaskListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? data = null, Object? meta = null}) {
    return _then(
      _$TaskListResponseImpl(
        data: null == data
            ? _value._data
            : data // ignore: cast_nullable_to_non_nullable
                  as List<TaskModel>,
        meta: null == meta
            ? _value.meta
            : meta // ignore: cast_nullable_to_non_nullable
                  as PaginationMeta,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskListResponseImpl implements _TaskListResponse {
  const _$TaskListResponseImpl({
    final List<TaskModel> data = const [],
    required this.meta,
  }) : _data = data;

  factory _$TaskListResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskListResponseImplFromJson(json);

  final List<TaskModel> _data;
  @override
  @JsonKey()
  List<TaskModel> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final PaginationMeta meta;

  @override
  String toString() {
    return 'TaskListResponse(data: $data, meta: $meta)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskListResponseImpl &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.meta, meta) || other.meta == meta));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_data),
    meta,
  );

  /// Create a copy of TaskListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskListResponseImplCopyWith<_$TaskListResponseImpl> get copyWith =>
      __$$TaskListResponseImplCopyWithImpl<_$TaskListResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskListResponseImplToJson(this);
  }
}

abstract class _TaskListResponse implements TaskListResponse {
  const factory _TaskListResponse({
    final List<TaskModel> data,
    required final PaginationMeta meta,
  }) = _$TaskListResponseImpl;

  factory _TaskListResponse.fromJson(Map<String, dynamic> json) =
      _$TaskListResponseImpl.fromJson;

  @override
  List<TaskModel> get data;
  @override
  PaginationMeta get meta;

  /// Create a copy of TaskListResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskListResponseImplCopyWith<_$TaskListResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PaginationMeta _$PaginationMetaFromJson(Map<String, dynamic> json) {
  return _PaginationMeta.fromJson(json);
}

/// @nodoc
mixin _$PaginationMeta {
  int get page => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  int get totalPages => throw _privateConstructorUsedError;

  /// Serializes this PaginationMeta to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaginationMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaginationMetaCopyWith<PaginationMeta> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginationMetaCopyWith<$Res> {
  factory $PaginationMetaCopyWith(
    PaginationMeta value,
    $Res Function(PaginationMeta) then,
  ) = _$PaginationMetaCopyWithImpl<$Res, PaginationMeta>;
  @useResult
  $Res call({int page, int limit, int total, int totalPages});
}

/// @nodoc
class _$PaginationMetaCopyWithImpl<$Res, $Val extends PaginationMeta>
    implements $PaginationMetaCopyWith<$Res> {
  _$PaginationMetaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaginationMeta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = null,
    Object? limit = null,
    Object? total = null,
    Object? totalPages = null,
  }) {
    return _then(
      _value.copyWith(
            page: null == page
                ? _value.page
                : page // ignore: cast_nullable_to_non_nullable
                      as int,
            limit: null == limit
                ? _value.limit
                : limit // ignore: cast_nullable_to_non_nullable
                      as int,
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as int,
            totalPages: null == totalPages
                ? _value.totalPages
                : totalPages // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PaginationMetaImplCopyWith<$Res>
    implements $PaginationMetaCopyWith<$Res> {
  factory _$$PaginationMetaImplCopyWith(
    _$PaginationMetaImpl value,
    $Res Function(_$PaginationMetaImpl) then,
  ) = __$$PaginationMetaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int page, int limit, int total, int totalPages});
}

/// @nodoc
class __$$PaginationMetaImplCopyWithImpl<$Res>
    extends _$PaginationMetaCopyWithImpl<$Res, _$PaginationMetaImpl>
    implements _$$PaginationMetaImplCopyWith<$Res> {
  __$$PaginationMetaImplCopyWithImpl(
    _$PaginationMetaImpl _value,
    $Res Function(_$PaginationMetaImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaginationMeta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = null,
    Object? limit = null,
    Object? total = null,
    Object? totalPages = null,
  }) {
    return _then(
      _$PaginationMetaImpl(
        page: null == page
            ? _value.page
            : page // ignore: cast_nullable_to_non_nullable
                  as int,
        limit: null == limit
            ? _value.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int,
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int,
        totalPages: null == totalPages
            ? _value.totalPages
            : totalPages // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PaginationMetaImpl implements _PaginationMeta {
  const _$PaginationMetaImpl({
    this.page = 1,
    this.limit = 20,
    this.total = 0,
    this.totalPages = 0,
  });

  factory _$PaginationMetaImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaginationMetaImplFromJson(json);

  @override
  @JsonKey()
  final int page;
  @override
  @JsonKey()
  final int limit;
  @override
  @JsonKey()
  final int total;
  @override
  @JsonKey()
  final int totalPages;

  @override
  String toString() {
    return 'PaginationMeta(page: $page, limit: $limit, total: $total, totalPages: $totalPages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginationMetaImpl &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, page, limit, total, totalPages);

  /// Create a copy of PaginationMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginationMetaImplCopyWith<_$PaginationMetaImpl> get copyWith =>
      __$$PaginationMetaImplCopyWithImpl<_$PaginationMetaImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PaginationMetaImplToJson(this);
  }
}

abstract class _PaginationMeta implements PaginationMeta {
  const factory _PaginationMeta({
    final int page,
    final int limit,
    final int total,
    final int totalPages,
  }) = _$PaginationMetaImpl;

  factory _PaginationMeta.fromJson(Map<String, dynamic> json) =
      _$PaginationMetaImpl.fromJson;

  @override
  int get page;
  @override
  int get limit;
  @override
  int get total;
  @override
  int get totalPages;

  /// Create a copy of PaginationMeta
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaginationMetaImplCopyWith<_$PaginationMetaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateTaskDto _$CreateTaskDtoFromJson(Map<String, dynamic> json) {
  return _CreateTaskDto.fromJson(json);
}

/// @nodoc
mixin _$CreateTaskDto {
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  TaskType? get type => throw _privateConstructorUsedError;
  TaskPriority? get priority => throw _privateConstructorUsedError;
  String get categoryId => throw _privateConstructorUsedError;
  String? get groupId => throw _privateConstructorUsedError;
  String? get scheduledAt => throw _privateConstructorUsedError;
  String? get dueAt => throw _privateConstructorUsedError;
  RecurringRuleDto? get recurring => throw _privateConstructorUsedError;
  List<TaskReminderDto>? get reminders => throw _privateConstructorUsedError;
  List<String>? get participantIds => throw _privateConstructorUsedError;

  /// Serializes this CreateTaskDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateTaskDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateTaskDtoCopyWith<CreateTaskDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateTaskDtoCopyWith<$Res> {
  factory $CreateTaskDtoCopyWith(
    CreateTaskDto value,
    $Res Function(CreateTaskDto) then,
  ) = _$CreateTaskDtoCopyWithImpl<$Res, CreateTaskDto>;
  @useResult
  $Res call({
    String title,
    String? description,
    String? location,
    TaskType? type,
    TaskPriority? priority,
    String categoryId,
    String? groupId,
    String? scheduledAt,
    String? dueAt,
    RecurringRuleDto? recurring,
    List<TaskReminderDto>? reminders,
    List<String>? participantIds,
  });

  $RecurringRuleDtoCopyWith<$Res>? get recurring;
}

/// @nodoc
class _$CreateTaskDtoCopyWithImpl<$Res, $Val extends CreateTaskDto>
    implements $CreateTaskDtoCopyWith<$Res> {
  _$CreateTaskDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateTaskDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = freezed,
    Object? location = freezed,
    Object? type = freezed,
    Object? priority = freezed,
    Object? categoryId = null,
    Object? groupId = freezed,
    Object? scheduledAt = freezed,
    Object? dueAt = freezed,
    Object? recurring = freezed,
    Object? reminders = freezed,
    Object? participantIds = freezed,
  }) {
    return _then(
      _value.copyWith(
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
            type: freezed == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as TaskType?,
            priority: freezed == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as TaskPriority?,
            categoryId: null == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                      as String,
            groupId: freezed == groupId
                ? _value.groupId
                : groupId // ignore: cast_nullable_to_non_nullable
                      as String?,
            scheduledAt: freezed == scheduledAt
                ? _value.scheduledAt
                : scheduledAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            dueAt: freezed == dueAt
                ? _value.dueAt
                : dueAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            recurring: freezed == recurring
                ? _value.recurring
                : recurring // ignore: cast_nullable_to_non_nullable
                      as RecurringRuleDto?,
            reminders: freezed == reminders
                ? _value.reminders
                : reminders // ignore: cast_nullable_to_non_nullable
                      as List<TaskReminderDto>?,
            participantIds: freezed == participantIds
                ? _value.participantIds
                : participantIds // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
          )
          as $Val,
    );
  }

  /// Create a copy of CreateTaskDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RecurringRuleDtoCopyWith<$Res>? get recurring {
    if (_value.recurring == null) {
      return null;
    }

    return $RecurringRuleDtoCopyWith<$Res>(_value.recurring!, (value) {
      return _then(_value.copyWith(recurring: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CreateTaskDtoImplCopyWith<$Res>
    implements $CreateTaskDtoCopyWith<$Res> {
  factory _$$CreateTaskDtoImplCopyWith(
    _$CreateTaskDtoImpl value,
    $Res Function(_$CreateTaskDtoImpl) then,
  ) = __$$CreateTaskDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String title,
    String? description,
    String? location,
    TaskType? type,
    TaskPriority? priority,
    String categoryId,
    String? groupId,
    String? scheduledAt,
    String? dueAt,
    RecurringRuleDto? recurring,
    List<TaskReminderDto>? reminders,
    List<String>? participantIds,
  });

  @override
  $RecurringRuleDtoCopyWith<$Res>? get recurring;
}

/// @nodoc
class __$$CreateTaskDtoImplCopyWithImpl<$Res>
    extends _$CreateTaskDtoCopyWithImpl<$Res, _$CreateTaskDtoImpl>
    implements _$$CreateTaskDtoImplCopyWith<$Res> {
  __$$CreateTaskDtoImplCopyWithImpl(
    _$CreateTaskDtoImpl _value,
    $Res Function(_$CreateTaskDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateTaskDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = freezed,
    Object? location = freezed,
    Object? type = freezed,
    Object? priority = freezed,
    Object? categoryId = null,
    Object? groupId = freezed,
    Object? scheduledAt = freezed,
    Object? dueAt = freezed,
    Object? recurring = freezed,
    Object? reminders = freezed,
    Object? participantIds = freezed,
  }) {
    return _then(
      _$CreateTaskDtoImpl(
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
        type: freezed == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as TaskType?,
        priority: freezed == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as TaskPriority?,
        categoryId: null == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as String,
        groupId: freezed == groupId
            ? _value.groupId
            : groupId // ignore: cast_nullable_to_non_nullable
                  as String?,
        scheduledAt: freezed == scheduledAt
            ? _value.scheduledAt
            : scheduledAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        dueAt: freezed == dueAt
            ? _value.dueAt
            : dueAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        recurring: freezed == recurring
            ? _value.recurring
            : recurring // ignore: cast_nullable_to_non_nullable
                  as RecurringRuleDto?,
        reminders: freezed == reminders
            ? _value._reminders
            : reminders // ignore: cast_nullable_to_non_nullable
                  as List<TaskReminderDto>?,
        participantIds: freezed == participantIds
            ? _value._participantIds
            : participantIds // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateTaskDtoImpl implements _CreateTaskDto {
  const _$CreateTaskDtoImpl({
    required this.title,
    this.description,
    this.location,
    this.type,
    this.priority,
    required this.categoryId,
    this.groupId,
    this.scheduledAt,
    this.dueAt,
    this.recurring,
    final List<TaskReminderDto>? reminders,
    final List<String>? participantIds,
  }) : _reminders = reminders,
       _participantIds = participantIds;

  factory _$CreateTaskDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateTaskDtoImplFromJson(json);

  @override
  final String title;
  @override
  final String? description;
  @override
  final String? location;
  @override
  final TaskType? type;
  @override
  final TaskPriority? priority;
  @override
  final String categoryId;
  @override
  final String? groupId;
  @override
  final String? scheduledAt;
  @override
  final String? dueAt;
  @override
  final RecurringRuleDto? recurring;
  final List<TaskReminderDto>? _reminders;
  @override
  List<TaskReminderDto>? get reminders {
    final value = _reminders;
    if (value == null) return null;
    if (_reminders is EqualUnmodifiableListView) return _reminders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _participantIds;
  @override
  List<String>? get participantIds {
    final value = _participantIds;
    if (value == null) return null;
    if (_participantIds is EqualUnmodifiableListView) return _participantIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'CreateTaskDto(title: $title, description: $description, location: $location, type: $type, priority: $priority, categoryId: $categoryId, groupId: $groupId, scheduledAt: $scheduledAt, dueAt: $dueAt, recurring: $recurring, reminders: $reminders, participantIds: $participantIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateTaskDtoImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.scheduledAt, scheduledAt) ||
                other.scheduledAt == scheduledAt) &&
            (identical(other.dueAt, dueAt) || other.dueAt == dueAt) &&
            (identical(other.recurring, recurring) ||
                other.recurring == recurring) &&
            const DeepCollectionEquality().equals(
              other._reminders,
              _reminders,
            ) &&
            const DeepCollectionEquality().equals(
              other._participantIds,
              _participantIds,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    title,
    description,
    location,
    type,
    priority,
    categoryId,
    groupId,
    scheduledAt,
    dueAt,
    recurring,
    const DeepCollectionEquality().hash(_reminders),
    const DeepCollectionEquality().hash(_participantIds),
  );

  /// Create a copy of CreateTaskDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateTaskDtoImplCopyWith<_$CreateTaskDtoImpl> get copyWith =>
      __$$CreateTaskDtoImplCopyWithImpl<_$CreateTaskDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateTaskDtoImplToJson(this);
  }
}

abstract class _CreateTaskDto implements CreateTaskDto {
  const factory _CreateTaskDto({
    required final String title,
    final String? description,
    final String? location,
    final TaskType? type,
    final TaskPriority? priority,
    required final String categoryId,
    final String? groupId,
    final String? scheduledAt,
    final String? dueAt,
    final RecurringRuleDto? recurring,
    final List<TaskReminderDto>? reminders,
    final List<String>? participantIds,
  }) = _$CreateTaskDtoImpl;

  factory _CreateTaskDto.fromJson(Map<String, dynamic> json) =
      _$CreateTaskDtoImpl.fromJson;

  @override
  String get title;
  @override
  String? get description;
  @override
  String? get location;
  @override
  TaskType? get type;
  @override
  TaskPriority? get priority;
  @override
  String get categoryId;
  @override
  String? get groupId;
  @override
  String? get scheduledAt;
  @override
  String? get dueAt;
  @override
  RecurringRuleDto? get recurring;
  @override
  List<TaskReminderDto>? get reminders;
  @override
  List<String>? get participantIds;

  /// Create a copy of CreateTaskDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateTaskDtoImplCopyWith<_$CreateTaskDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UpdateTaskDto _$UpdateTaskDtoFromJson(Map<String, dynamic> json) {
  return _UpdateTaskDto.fromJson(json);
}

/// @nodoc
mixin _$UpdateTaskDto {
  String? get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  TaskType? get type => throw _privateConstructorUsedError;
  TaskPriority? get priority => throw _privateConstructorUsedError;
  String? get scheduledAt => throw _privateConstructorUsedError;
  String? get dueAt => throw _privateConstructorUsedError;
  List<String>? get participantIds => throw _privateConstructorUsedError;

  /// Serializes this UpdateTaskDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateTaskDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateTaskDtoCopyWith<UpdateTaskDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateTaskDtoCopyWith<$Res> {
  factory $UpdateTaskDtoCopyWith(
    UpdateTaskDto value,
    $Res Function(UpdateTaskDto) then,
  ) = _$UpdateTaskDtoCopyWithImpl<$Res, UpdateTaskDto>;
  @useResult
  $Res call({
    String? title,
    String? description,
    String? location,
    TaskType? type,
    TaskPriority? priority,
    String? scheduledAt,
    String? dueAt,
    List<String>? participantIds,
  });
}

/// @nodoc
class _$UpdateTaskDtoCopyWithImpl<$Res, $Val extends UpdateTaskDto>
    implements $UpdateTaskDtoCopyWith<$Res> {
  _$UpdateTaskDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateTaskDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? description = freezed,
    Object? location = freezed,
    Object? type = freezed,
    Object? priority = freezed,
    Object? scheduledAt = freezed,
    Object? dueAt = freezed,
    Object? participantIds = freezed,
  }) {
    return _then(
      _value.copyWith(
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            location: freezed == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String?,
            type: freezed == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as TaskType?,
            priority: freezed == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as TaskPriority?,
            scheduledAt: freezed == scheduledAt
                ? _value.scheduledAt
                : scheduledAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            dueAt: freezed == dueAt
                ? _value.dueAt
                : dueAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            participantIds: freezed == participantIds
                ? _value.participantIds
                : participantIds // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UpdateTaskDtoImplCopyWith<$Res>
    implements $UpdateTaskDtoCopyWith<$Res> {
  factory _$$UpdateTaskDtoImplCopyWith(
    _$UpdateTaskDtoImpl value,
    $Res Function(_$UpdateTaskDtoImpl) then,
  ) = __$$UpdateTaskDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? title,
    String? description,
    String? location,
    TaskType? type,
    TaskPriority? priority,
    String? scheduledAt,
    String? dueAt,
    List<String>? participantIds,
  });
}

/// @nodoc
class __$$UpdateTaskDtoImplCopyWithImpl<$Res>
    extends _$UpdateTaskDtoCopyWithImpl<$Res, _$UpdateTaskDtoImpl>
    implements _$$UpdateTaskDtoImplCopyWith<$Res> {
  __$$UpdateTaskDtoImplCopyWithImpl(
    _$UpdateTaskDtoImpl _value,
    $Res Function(_$UpdateTaskDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateTaskDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? description = freezed,
    Object? location = freezed,
    Object? type = freezed,
    Object? priority = freezed,
    Object? scheduledAt = freezed,
    Object? dueAt = freezed,
    Object? participantIds = freezed,
  }) {
    return _then(
      _$UpdateTaskDtoImpl(
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        location: freezed == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: freezed == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as TaskType?,
        priority: freezed == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as TaskPriority?,
        scheduledAt: freezed == scheduledAt
            ? _value.scheduledAt
            : scheduledAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        dueAt: freezed == dueAt
            ? _value.dueAt
            : dueAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        participantIds: freezed == participantIds
            ? _value._participantIds
            : participantIds // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateTaskDtoImpl implements _UpdateTaskDto {
  const _$UpdateTaskDtoImpl({
    this.title,
    this.description,
    this.location,
    this.type,
    this.priority,
    this.scheduledAt,
    this.dueAt,
    final List<String>? participantIds,
  }) : _participantIds = participantIds;

  factory _$UpdateTaskDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateTaskDtoImplFromJson(json);

  @override
  final String? title;
  @override
  final String? description;
  @override
  final String? location;
  @override
  final TaskType? type;
  @override
  final TaskPriority? priority;
  @override
  final String? scheduledAt;
  @override
  final String? dueAt;
  final List<String>? _participantIds;
  @override
  List<String>? get participantIds {
    final value = _participantIds;
    if (value == null) return null;
    if (_participantIds is EqualUnmodifiableListView) return _participantIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'UpdateTaskDto(title: $title, description: $description, location: $location, type: $type, priority: $priority, scheduledAt: $scheduledAt, dueAt: $dueAt, participantIds: $participantIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateTaskDtoImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.scheduledAt, scheduledAt) ||
                other.scheduledAt == scheduledAt) &&
            (identical(other.dueAt, dueAt) || other.dueAt == dueAt) &&
            const DeepCollectionEquality().equals(
              other._participantIds,
              _participantIds,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    title,
    description,
    location,
    type,
    priority,
    scheduledAt,
    dueAt,
    const DeepCollectionEquality().hash(_participantIds),
  );

  /// Create a copy of UpdateTaskDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateTaskDtoImplCopyWith<_$UpdateTaskDtoImpl> get copyWith =>
      __$$UpdateTaskDtoImplCopyWithImpl<_$UpdateTaskDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateTaskDtoImplToJson(this);
  }
}

abstract class _UpdateTaskDto implements UpdateTaskDto {
  const factory _UpdateTaskDto({
    final String? title,
    final String? description,
    final String? location,
    final TaskType? type,
    final TaskPriority? priority,
    final String? scheduledAt,
    final String? dueAt,
    final List<String>? participantIds,
  }) = _$UpdateTaskDtoImpl;

  factory _UpdateTaskDto.fromJson(Map<String, dynamic> json) =
      _$UpdateTaskDtoImpl.fromJson;

  @override
  String? get title;
  @override
  String? get description;
  @override
  String? get location;
  @override
  TaskType? get type;
  @override
  TaskPriority? get priority;
  @override
  String? get scheduledAt;
  @override
  String? get dueAt;
  @override
  List<String>? get participantIds;

  /// Create a copy of UpdateTaskDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateTaskDtoImplCopyWith<_$UpdateTaskDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RecurringRuleDto _$RecurringRuleDtoFromJson(Map<String, dynamic> json) {
  return _RecurringRuleDto.fromJson(json);
}

/// @nodoc
mixin _$RecurringRuleDto {
  RecurringRuleType get ruleType => throw _privateConstructorUsedError;
  Map<String, dynamic>? get ruleConfig => throw _privateConstructorUsedError;
  RecurringGenerationType? get generationType =>
      throw _privateConstructorUsedError;

  /// Serializes this RecurringRuleDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecurringRuleDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecurringRuleDtoCopyWith<RecurringRuleDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecurringRuleDtoCopyWith<$Res> {
  factory $RecurringRuleDtoCopyWith(
    RecurringRuleDto value,
    $Res Function(RecurringRuleDto) then,
  ) = _$RecurringRuleDtoCopyWithImpl<$Res, RecurringRuleDto>;
  @useResult
  $Res call({
    RecurringRuleType ruleType,
    Map<String, dynamic>? ruleConfig,
    RecurringGenerationType? generationType,
  });
}

/// @nodoc
class _$RecurringRuleDtoCopyWithImpl<$Res, $Val extends RecurringRuleDto>
    implements $RecurringRuleDtoCopyWith<$Res> {
  _$RecurringRuleDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecurringRuleDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ruleType = null,
    Object? ruleConfig = freezed,
    Object? generationType = freezed,
  }) {
    return _then(
      _value.copyWith(
            ruleType: null == ruleType
                ? _value.ruleType
                : ruleType // ignore: cast_nullable_to_non_nullable
                      as RecurringRuleType,
            ruleConfig: freezed == ruleConfig
                ? _value.ruleConfig
                : ruleConfig // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            generationType: freezed == generationType
                ? _value.generationType
                : generationType // ignore: cast_nullable_to_non_nullable
                      as RecurringGenerationType?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RecurringRuleDtoImplCopyWith<$Res>
    implements $RecurringRuleDtoCopyWith<$Res> {
  factory _$$RecurringRuleDtoImplCopyWith(
    _$RecurringRuleDtoImpl value,
    $Res Function(_$RecurringRuleDtoImpl) then,
  ) = __$$RecurringRuleDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    RecurringRuleType ruleType,
    Map<String, dynamic>? ruleConfig,
    RecurringGenerationType? generationType,
  });
}

/// @nodoc
class __$$RecurringRuleDtoImplCopyWithImpl<$Res>
    extends _$RecurringRuleDtoCopyWithImpl<$Res, _$RecurringRuleDtoImpl>
    implements _$$RecurringRuleDtoImplCopyWith<$Res> {
  __$$RecurringRuleDtoImplCopyWithImpl(
    _$RecurringRuleDtoImpl _value,
    $Res Function(_$RecurringRuleDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecurringRuleDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ruleType = null,
    Object? ruleConfig = freezed,
    Object? generationType = freezed,
  }) {
    return _then(
      _$RecurringRuleDtoImpl(
        ruleType: null == ruleType
            ? _value.ruleType
            : ruleType // ignore: cast_nullable_to_non_nullable
                  as RecurringRuleType,
        ruleConfig: freezed == ruleConfig
            ? _value._ruleConfig
            : ruleConfig // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        generationType: freezed == generationType
            ? _value.generationType
            : generationType // ignore: cast_nullable_to_non_nullable
                  as RecurringGenerationType?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RecurringRuleDtoImpl implements _RecurringRuleDto {
  const _$RecurringRuleDtoImpl({
    required this.ruleType,
    final Map<String, dynamic>? ruleConfig,
    this.generationType,
  }) : _ruleConfig = ruleConfig;

  factory _$RecurringRuleDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecurringRuleDtoImplFromJson(json);

  @override
  final RecurringRuleType ruleType;
  final Map<String, dynamic>? _ruleConfig;
  @override
  Map<String, dynamic>? get ruleConfig {
    final value = _ruleConfig;
    if (value == null) return null;
    if (_ruleConfig is EqualUnmodifiableMapView) return _ruleConfig;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final RecurringGenerationType? generationType;

  @override
  String toString() {
    return 'RecurringRuleDto(ruleType: $ruleType, ruleConfig: $ruleConfig, generationType: $generationType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecurringRuleDtoImpl &&
            (identical(other.ruleType, ruleType) ||
                other.ruleType == ruleType) &&
            const DeepCollectionEquality().equals(
              other._ruleConfig,
              _ruleConfig,
            ) &&
            (identical(other.generationType, generationType) ||
                other.generationType == generationType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    ruleType,
    const DeepCollectionEquality().hash(_ruleConfig),
    generationType,
  );

  /// Create a copy of RecurringRuleDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecurringRuleDtoImplCopyWith<_$RecurringRuleDtoImpl> get copyWith =>
      __$$RecurringRuleDtoImplCopyWithImpl<_$RecurringRuleDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RecurringRuleDtoImplToJson(this);
  }
}

abstract class _RecurringRuleDto implements RecurringRuleDto {
  const factory _RecurringRuleDto({
    required final RecurringRuleType ruleType,
    final Map<String, dynamic>? ruleConfig,
    final RecurringGenerationType? generationType,
  }) = _$RecurringRuleDtoImpl;

  factory _RecurringRuleDto.fromJson(Map<String, dynamic> json) =
      _$RecurringRuleDtoImpl.fromJson;

  @override
  RecurringRuleType get ruleType;
  @override
  Map<String, dynamic>? get ruleConfig;
  @override
  RecurringGenerationType? get generationType;

  /// Create a copy of RecurringRuleDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecurringRuleDtoImplCopyWith<_$RecurringRuleDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TaskReminderDto _$TaskReminderDtoFromJson(Map<String, dynamic> json) {
  return _TaskReminderDto.fromJson(json);
}

/// @nodoc
mixin _$TaskReminderDto {
  TaskReminderType get reminderType => throw _privateConstructorUsedError;
  int get offsetMinutes => throw _privateConstructorUsedError;

  /// Serializes this TaskReminderDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaskReminderDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskReminderDtoCopyWith<TaskReminderDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskReminderDtoCopyWith<$Res> {
  factory $TaskReminderDtoCopyWith(
    TaskReminderDto value,
    $Res Function(TaskReminderDto) then,
  ) = _$TaskReminderDtoCopyWithImpl<$Res, TaskReminderDto>;
  @useResult
  $Res call({TaskReminderType reminderType, int offsetMinutes});
}

/// @nodoc
class _$TaskReminderDtoCopyWithImpl<$Res, $Val extends TaskReminderDto>
    implements $TaskReminderDtoCopyWith<$Res> {
  _$TaskReminderDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskReminderDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? reminderType = null, Object? offsetMinutes = null}) {
    return _then(
      _value.copyWith(
            reminderType: null == reminderType
                ? _value.reminderType
                : reminderType // ignore: cast_nullable_to_non_nullable
                      as TaskReminderType,
            offsetMinutes: null == offsetMinutes
                ? _value.offsetMinutes
                : offsetMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TaskReminderDtoImplCopyWith<$Res>
    implements $TaskReminderDtoCopyWith<$Res> {
  factory _$$TaskReminderDtoImplCopyWith(
    _$TaskReminderDtoImpl value,
    $Res Function(_$TaskReminderDtoImpl) then,
  ) = __$$TaskReminderDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({TaskReminderType reminderType, int offsetMinutes});
}

/// @nodoc
class __$$TaskReminderDtoImplCopyWithImpl<$Res>
    extends _$TaskReminderDtoCopyWithImpl<$Res, _$TaskReminderDtoImpl>
    implements _$$TaskReminderDtoImplCopyWith<$Res> {
  __$$TaskReminderDtoImplCopyWithImpl(
    _$TaskReminderDtoImpl _value,
    $Res Function(_$TaskReminderDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TaskReminderDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? reminderType = null, Object? offsetMinutes = null}) {
    return _then(
      _$TaskReminderDtoImpl(
        reminderType: null == reminderType
            ? _value.reminderType
            : reminderType // ignore: cast_nullable_to_non_nullable
                  as TaskReminderType,
        offsetMinutes: null == offsetMinutes
            ? _value.offsetMinutes
            : offsetMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskReminderDtoImpl implements _TaskReminderDto {
  const _$TaskReminderDtoImpl({
    required this.reminderType,
    this.offsetMinutes = 0,
  });

  factory _$TaskReminderDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskReminderDtoImplFromJson(json);

  @override
  final TaskReminderType reminderType;
  @override
  @JsonKey()
  final int offsetMinutes;

  @override
  String toString() {
    return 'TaskReminderDto(reminderType: $reminderType, offsetMinutes: $offsetMinutes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskReminderDtoImpl &&
            (identical(other.reminderType, reminderType) ||
                other.reminderType == reminderType) &&
            (identical(other.offsetMinutes, offsetMinutes) ||
                other.offsetMinutes == offsetMinutes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, reminderType, offsetMinutes);

  /// Create a copy of TaskReminderDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskReminderDtoImplCopyWith<_$TaskReminderDtoImpl> get copyWith =>
      __$$TaskReminderDtoImplCopyWithImpl<_$TaskReminderDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskReminderDtoImplToJson(this);
  }
}

abstract class _TaskReminderDto implements TaskReminderDto {
  const factory _TaskReminderDto({
    required final TaskReminderType reminderType,
    final int offsetMinutes,
  }) = _$TaskReminderDtoImpl;

  factory _TaskReminderDto.fromJson(Map<String, dynamic> json) =
      _$TaskReminderDtoImpl.fromJson;

  @override
  TaskReminderType get reminderType;
  @override
  int get offsetMinutes;

  /// Create a copy of TaskReminderDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskReminderDtoImplCopyWith<_$TaskReminderDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
