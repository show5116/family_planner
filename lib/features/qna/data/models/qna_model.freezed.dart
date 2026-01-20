// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'qna_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Attachment _$AttachmentFromJson(Map<String, dynamic> json) {
  return _Attachment.fromJson(json);
}

/// @nodoc
mixin _$Attachment {
  String get url => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get size => throw _privateConstructorUsedError;

  /// Serializes this Attachment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Attachment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AttachmentCopyWith<Attachment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AttachmentCopyWith<$Res> {
  factory $AttachmentCopyWith(
    Attachment value,
    $Res Function(Attachment) then,
  ) = _$AttachmentCopyWithImpl<$Res, Attachment>;
  @useResult
  $Res call({String url, String name, int size});
}

/// @nodoc
class _$AttachmentCopyWithImpl<$Res, $Val extends Attachment>
    implements $AttachmentCopyWith<$Res> {
  _$AttachmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Attachment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? url = null, Object? name = null, Object? size = null}) {
    return _then(
      _value.copyWith(
            url: null == url
                ? _value.url
                : url // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            size: null == size
                ? _value.size
                : size // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AttachmentImplCopyWith<$Res>
    implements $AttachmentCopyWith<$Res> {
  factory _$$AttachmentImplCopyWith(
    _$AttachmentImpl value,
    $Res Function(_$AttachmentImpl) then,
  ) = __$$AttachmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String url, String name, int size});
}

/// @nodoc
class __$$AttachmentImplCopyWithImpl<$Res>
    extends _$AttachmentCopyWithImpl<$Res, _$AttachmentImpl>
    implements _$$AttachmentImplCopyWith<$Res> {
  __$$AttachmentImplCopyWithImpl(
    _$AttachmentImpl _value,
    $Res Function(_$AttachmentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Attachment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? url = null, Object? name = null, Object? size = null}) {
    return _then(
      _$AttachmentImpl(
        url: null == url
            ? _value.url
            : url // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        size: null == size
            ? _value.size
            : size // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AttachmentImpl implements _Attachment {
  const _$AttachmentImpl({
    required this.url,
    required this.name,
    required this.size,
  });

  factory _$AttachmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$AttachmentImplFromJson(json);

  @override
  final String url;
  @override
  final String name;
  @override
  final int size;

  @override
  String toString() {
    return 'Attachment(url: $url, name: $name, size: $size)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AttachmentImpl &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.size, size) || other.size == size));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, url, name, size);

  /// Create a copy of Attachment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AttachmentImplCopyWith<_$AttachmentImpl> get copyWith =>
      __$$AttachmentImplCopyWithImpl<_$AttachmentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AttachmentImplToJson(this);
  }
}

abstract class _Attachment implements Attachment {
  const factory _Attachment({
    required final String url,
    required final String name,
    required final int size,
  }) = _$AttachmentImpl;

  factory _Attachment.fromJson(Map<String, dynamic> json) =
      _$AttachmentImpl.fromJson;

  @override
  String get url;
  @override
  String get name;
  @override
  int get size;

  /// Create a copy of Attachment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AttachmentImplCopyWith<_$AttachmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QuestionUser _$QuestionUserFromJson(Map<String, dynamic> json) {
  return _QuestionUser.fromJson(json);
}

/// @nodoc
mixin _$QuestionUser {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  /// Serializes this QuestionUser to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuestionUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuestionUserCopyWith<QuestionUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestionUserCopyWith<$Res> {
  factory $QuestionUserCopyWith(
    QuestionUser value,
    $Res Function(QuestionUser) then,
  ) = _$QuestionUserCopyWithImpl<$Res, QuestionUser>;
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class _$QuestionUserCopyWithImpl<$Res, $Val extends QuestionUser>
    implements $QuestionUserCopyWith<$Res> {
  _$QuestionUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuestionUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null}) {
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QuestionUserImplCopyWith<$Res>
    implements $QuestionUserCopyWith<$Res> {
  factory _$$QuestionUserImplCopyWith(
    _$QuestionUserImpl value,
    $Res Function(_$QuestionUserImpl) then,
  ) = __$$QuestionUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class __$$QuestionUserImplCopyWithImpl<$Res>
    extends _$QuestionUserCopyWithImpl<$Res, _$QuestionUserImpl>
    implements _$$QuestionUserImplCopyWith<$Res> {
  __$$QuestionUserImplCopyWithImpl(
    _$QuestionUserImpl _value,
    $Res Function(_$QuestionUserImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuestionUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null}) {
    return _then(
      _$QuestionUserImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$QuestionUserImpl implements _QuestionUser {
  const _$QuestionUserImpl({required this.id, required this.name});

  factory _$QuestionUserImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuestionUserImplFromJson(json);

  @override
  final String id;
  @override
  final String name;

  @override
  String toString() {
    return 'QuestionUser(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestionUserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  /// Create a copy of QuestionUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestionUserImplCopyWith<_$QuestionUserImpl> get copyWith =>
      __$$QuestionUserImplCopyWithImpl<_$QuestionUserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuestionUserImplToJson(this);
  }
}

abstract class _QuestionUser implements QuestionUser {
  const factory _QuestionUser({
    required final String id,
    required final String name,
  }) = _$QuestionUserImpl;

  factory _QuestionUser.fromJson(Map<String, dynamic> json) =
      _$QuestionUserImpl.fromJson;

  @override
  String get id;
  @override
  String get name;

  /// Create a copy of QuestionUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuestionUserImplCopyWith<_$QuestionUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AnswerModel _$AnswerModelFromJson(Map<String, dynamic> json) {
  return _AnswerModel.fromJson(json);
}

/// @nodoc
mixin _$AnswerModel {
  String get id => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String? get adminId => throw _privateConstructorUsedError;
  QuestionUser? get admin => throw _privateConstructorUsedError;
  List<Attachment>? get attachments => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this AnswerModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnswerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnswerModelCopyWith<AnswerModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnswerModelCopyWith<$Res> {
  factory $AnswerModelCopyWith(
    AnswerModel value,
    $Res Function(AnswerModel) then,
  ) = _$AnswerModelCopyWithImpl<$Res, AnswerModel>;
  @useResult
  $Res call({
    String id,
    String content,
    String? adminId,
    QuestionUser? admin,
    List<Attachment>? attachments,
    DateTime createdAt,
    DateTime updatedAt,
  });

  $QuestionUserCopyWith<$Res>? get admin;
}

/// @nodoc
class _$AnswerModelCopyWithImpl<$Res, $Val extends AnswerModel>
    implements $AnswerModelCopyWith<$Res> {
  _$AnswerModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnswerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? content = null,
    Object? adminId = freezed,
    Object? admin = freezed,
    Object? attachments = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            adminId: freezed == adminId
                ? _value.adminId
                : adminId // ignore: cast_nullable_to_non_nullable
                      as String?,
            admin: freezed == admin
                ? _value.admin
                : admin // ignore: cast_nullable_to_non_nullable
                      as QuestionUser?,
            attachments: freezed == attachments
                ? _value.attachments
                : attachments // ignore: cast_nullable_to_non_nullable
                      as List<Attachment>?,
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

  /// Create a copy of AnswerModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $QuestionUserCopyWith<$Res>? get admin {
    if (_value.admin == null) {
      return null;
    }

    return $QuestionUserCopyWith<$Res>(_value.admin!, (value) {
      return _then(_value.copyWith(admin: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AnswerModelImplCopyWith<$Res>
    implements $AnswerModelCopyWith<$Res> {
  factory _$$AnswerModelImplCopyWith(
    _$AnswerModelImpl value,
    $Res Function(_$AnswerModelImpl) then,
  ) = __$$AnswerModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String content,
    String? adminId,
    QuestionUser? admin,
    List<Attachment>? attachments,
    DateTime createdAt,
    DateTime updatedAt,
  });

  @override
  $QuestionUserCopyWith<$Res>? get admin;
}

/// @nodoc
class __$$AnswerModelImplCopyWithImpl<$Res>
    extends _$AnswerModelCopyWithImpl<$Res, _$AnswerModelImpl>
    implements _$$AnswerModelImplCopyWith<$Res> {
  __$$AnswerModelImplCopyWithImpl(
    _$AnswerModelImpl _value,
    $Res Function(_$AnswerModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AnswerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? content = null,
    Object? adminId = freezed,
    Object? admin = freezed,
    Object? attachments = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$AnswerModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        adminId: freezed == adminId
            ? _value.adminId
            : adminId // ignore: cast_nullable_to_non_nullable
                  as String?,
        admin: freezed == admin
            ? _value.admin
            : admin // ignore: cast_nullable_to_non_nullable
                  as QuestionUser?,
        attachments: freezed == attachments
            ? _value._attachments
            : attachments // ignore: cast_nullable_to_non_nullable
                  as List<Attachment>?,
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
class _$AnswerModelImpl implements _AnswerModel {
  const _$AnswerModelImpl({
    required this.id,
    required this.content,
    this.adminId,
    this.admin,
    final List<Attachment>? attachments,
    required this.createdAt,
    required this.updatedAt,
  }) : _attachments = attachments;

  factory _$AnswerModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnswerModelImplFromJson(json);

  @override
  final String id;
  @override
  final String content;
  @override
  final String? adminId;
  @override
  final QuestionUser? admin;
  final List<Attachment>? _attachments;
  @override
  List<Attachment>? get attachments {
    final value = _attachments;
    if (value == null) return null;
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'AnswerModel(id: $id, content: $content, adminId: $adminId, admin: $admin, attachments: $attachments, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnswerModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.adminId, adminId) || other.adminId == adminId) &&
            (identical(other.admin, admin) || other.admin == admin) &&
            const DeepCollectionEquality().equals(
              other._attachments,
              _attachments,
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
    content,
    adminId,
    admin,
    const DeepCollectionEquality().hash(_attachments),
    createdAt,
    updatedAt,
  );

  /// Create a copy of AnswerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnswerModelImplCopyWith<_$AnswerModelImpl> get copyWith =>
      __$$AnswerModelImplCopyWithImpl<_$AnswerModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnswerModelImplToJson(this);
  }
}

abstract class _AnswerModel implements AnswerModel {
  const factory _AnswerModel({
    required final String id,
    required final String content,
    final String? adminId,
    final QuestionUser? admin,
    final List<Attachment>? attachments,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$AnswerModelImpl;

  factory _AnswerModel.fromJson(Map<String, dynamic> json) =
      _$AnswerModelImpl.fromJson;

  @override
  String get id;
  @override
  String get content;
  @override
  String? get adminId;
  @override
  QuestionUser? get admin;
  @override
  List<Attachment>? get attachments;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of AnswerModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnswerModelImplCopyWith<_$AnswerModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QuestionModel _$QuestionModelFromJson(Map<String, dynamic> json) {
  return _QuestionModel.fromJson(json);
}

/// @nodoc
mixin _$QuestionModel {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  QuestionCategory get category => throw _privateConstructorUsedError;
  QuestionStatus get status => throw _privateConstructorUsedError;
  QuestionVisibility get visibility => throw _privateConstructorUsedError;
  QuestionUser? get user => throw _privateConstructorUsedError;
  List<Attachment>? get attachments => throw _privateConstructorUsedError;
  List<AnswerModel> get answers => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this QuestionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuestionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuestionModelCopyWith<QuestionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestionModelCopyWith<$Res> {
  factory $QuestionModelCopyWith(
    QuestionModel value,
    $Res Function(QuestionModel) then,
  ) = _$QuestionModelCopyWithImpl<$Res, QuestionModel>;
  @useResult
  $Res call({
    String id,
    String title,
    String content,
    QuestionCategory category,
    QuestionStatus status,
    QuestionVisibility visibility,
    QuestionUser? user,
    List<Attachment>? attachments,
    List<AnswerModel> answers,
    DateTime createdAt,
    DateTime updatedAt,
  });

  $QuestionUserCopyWith<$Res>? get user;
}

/// @nodoc
class _$QuestionModelCopyWithImpl<$Res, $Val extends QuestionModel>
    implements $QuestionModelCopyWith<$Res> {
  _$QuestionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuestionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? content = null,
    Object? category = null,
    Object? status = null,
    Object? visibility = null,
    Object? user = freezed,
    Object? attachments = freezed,
    Object? answers = null,
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
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as QuestionCategory,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as QuestionStatus,
            visibility: null == visibility
                ? _value.visibility
                : visibility // ignore: cast_nullable_to_non_nullable
                      as QuestionVisibility,
            user: freezed == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as QuestionUser?,
            attachments: freezed == attachments
                ? _value.attachments
                : attachments // ignore: cast_nullable_to_non_nullable
                      as List<Attachment>?,
            answers: null == answers
                ? _value.answers
                : answers // ignore: cast_nullable_to_non_nullable
                      as List<AnswerModel>,
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

  /// Create a copy of QuestionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $QuestionUserCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $QuestionUserCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$QuestionModelImplCopyWith<$Res>
    implements $QuestionModelCopyWith<$Res> {
  factory _$$QuestionModelImplCopyWith(
    _$QuestionModelImpl value,
    $Res Function(_$QuestionModelImpl) then,
  ) = __$$QuestionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String content,
    QuestionCategory category,
    QuestionStatus status,
    QuestionVisibility visibility,
    QuestionUser? user,
    List<Attachment>? attachments,
    List<AnswerModel> answers,
    DateTime createdAt,
    DateTime updatedAt,
  });

  @override
  $QuestionUserCopyWith<$Res>? get user;
}

/// @nodoc
class __$$QuestionModelImplCopyWithImpl<$Res>
    extends _$QuestionModelCopyWithImpl<$Res, _$QuestionModelImpl>
    implements _$$QuestionModelImplCopyWith<$Res> {
  __$$QuestionModelImplCopyWithImpl(
    _$QuestionModelImpl _value,
    $Res Function(_$QuestionModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuestionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? content = null,
    Object? category = null,
    Object? status = null,
    Object? visibility = null,
    Object? user = freezed,
    Object? attachments = freezed,
    Object? answers = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$QuestionModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as QuestionCategory,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as QuestionStatus,
        visibility: null == visibility
            ? _value.visibility
            : visibility // ignore: cast_nullable_to_non_nullable
                  as QuestionVisibility,
        user: freezed == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as QuestionUser?,
        attachments: freezed == attachments
            ? _value._attachments
            : attachments // ignore: cast_nullable_to_non_nullable
                  as List<Attachment>?,
        answers: null == answers
            ? _value._answers
            : answers // ignore: cast_nullable_to_non_nullable
                  as List<AnswerModel>,
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
class _$QuestionModelImpl implements _QuestionModel {
  const _$QuestionModelImpl({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.status,
    required this.visibility,
    this.user,
    final List<Attachment>? attachments,
    final List<AnswerModel> answers = const [],
    required this.createdAt,
    required this.updatedAt,
  }) : _attachments = attachments,
       _answers = answers;

  factory _$QuestionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuestionModelImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String content;
  @override
  final QuestionCategory category;
  @override
  final QuestionStatus status;
  @override
  final QuestionVisibility visibility;
  @override
  final QuestionUser? user;
  final List<Attachment>? _attachments;
  @override
  List<Attachment>? get attachments {
    final value = _attachments;
    if (value == null) return null;
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<AnswerModel> _answers;
  @override
  @JsonKey()
  List<AnswerModel> get answers {
    if (_answers is EqualUnmodifiableListView) return _answers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_answers);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'QuestionModel(id: $id, title: $title, content: $content, category: $category, status: $status, visibility: $visibility, user: $user, attachments: $attachments, answers: $answers, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.visibility, visibility) ||
                other.visibility == visibility) &&
            (identical(other.user, user) || other.user == user) &&
            const DeepCollectionEquality().equals(
              other._attachments,
              _attachments,
            ) &&
            const DeepCollectionEquality().equals(other._answers, _answers) &&
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
    content,
    category,
    status,
    visibility,
    user,
    const DeepCollectionEquality().hash(_attachments),
    const DeepCollectionEquality().hash(_answers),
    createdAt,
    updatedAt,
  );

  /// Create a copy of QuestionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestionModelImplCopyWith<_$QuestionModelImpl> get copyWith =>
      __$$QuestionModelImplCopyWithImpl<_$QuestionModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuestionModelImplToJson(this);
  }
}

abstract class _QuestionModel implements QuestionModel {
  const factory _QuestionModel({
    required final String id,
    required final String title,
    required final String content,
    required final QuestionCategory category,
    required final QuestionStatus status,
    required final QuestionVisibility visibility,
    final QuestionUser? user,
    final List<Attachment>? attachments,
    final List<AnswerModel> answers,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$QuestionModelImpl;

  factory _QuestionModel.fromJson(Map<String, dynamic> json) =
      _$QuestionModelImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get content;
  @override
  QuestionCategory get category;
  @override
  QuestionStatus get status;
  @override
  QuestionVisibility get visibility;
  @override
  QuestionUser? get user;
  @override
  List<Attachment>? get attachments;
  @override
  List<AnswerModel> get answers;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of QuestionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuestionModelImplCopyWith<_$QuestionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QuestionListItem _$QuestionListItemFromJson(Map<String, dynamic> json) {
  return _QuestionListItem.fromJson(json);
}

/// @nodoc
mixin _$QuestionListItem {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  QuestionCategory get category => throw _privateConstructorUsedError;
  QuestionStatus get status => throw _privateConstructorUsedError;
  QuestionVisibility get visibility => throw _privateConstructorUsedError;
  int get answerCount => throw _privateConstructorUsedError;
  QuestionUser? get user => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this QuestionListItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuestionListItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuestionListItemCopyWith<QuestionListItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestionListItemCopyWith<$Res> {
  factory $QuestionListItemCopyWith(
    QuestionListItem value,
    $Res Function(QuestionListItem) then,
  ) = _$QuestionListItemCopyWithImpl<$Res, QuestionListItem>;
  @useResult
  $Res call({
    String id,
    String title,
    String content,
    QuestionCategory category,
    QuestionStatus status,
    QuestionVisibility visibility,
    int answerCount,
    QuestionUser? user,
    DateTime createdAt,
    DateTime updatedAt,
  });

  $QuestionUserCopyWith<$Res>? get user;
}

/// @nodoc
class _$QuestionListItemCopyWithImpl<$Res, $Val extends QuestionListItem>
    implements $QuestionListItemCopyWith<$Res> {
  _$QuestionListItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuestionListItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? content = null,
    Object? category = null,
    Object? status = null,
    Object? visibility = null,
    Object? answerCount = null,
    Object? user = freezed,
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
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as QuestionCategory,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as QuestionStatus,
            visibility: null == visibility
                ? _value.visibility
                : visibility // ignore: cast_nullable_to_non_nullable
                      as QuestionVisibility,
            answerCount: null == answerCount
                ? _value.answerCount
                : answerCount // ignore: cast_nullable_to_non_nullable
                      as int,
            user: freezed == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as QuestionUser?,
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

  /// Create a copy of QuestionListItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $QuestionUserCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $QuestionUserCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$QuestionListItemImplCopyWith<$Res>
    implements $QuestionListItemCopyWith<$Res> {
  factory _$$QuestionListItemImplCopyWith(
    _$QuestionListItemImpl value,
    $Res Function(_$QuestionListItemImpl) then,
  ) = __$$QuestionListItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String content,
    QuestionCategory category,
    QuestionStatus status,
    QuestionVisibility visibility,
    int answerCount,
    QuestionUser? user,
    DateTime createdAt,
    DateTime updatedAt,
  });

  @override
  $QuestionUserCopyWith<$Res>? get user;
}

/// @nodoc
class __$$QuestionListItemImplCopyWithImpl<$Res>
    extends _$QuestionListItemCopyWithImpl<$Res, _$QuestionListItemImpl>
    implements _$$QuestionListItemImplCopyWith<$Res> {
  __$$QuestionListItemImplCopyWithImpl(
    _$QuestionListItemImpl _value,
    $Res Function(_$QuestionListItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuestionListItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? content = null,
    Object? category = null,
    Object? status = null,
    Object? visibility = null,
    Object? answerCount = null,
    Object? user = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$QuestionListItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as QuestionCategory,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as QuestionStatus,
        visibility: null == visibility
            ? _value.visibility
            : visibility // ignore: cast_nullable_to_non_nullable
                  as QuestionVisibility,
        answerCount: null == answerCount
            ? _value.answerCount
            : answerCount // ignore: cast_nullable_to_non_nullable
                  as int,
        user: freezed == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as QuestionUser?,
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
class _$QuestionListItemImpl implements _QuestionListItem {
  const _$QuestionListItemImpl({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.status,
    required this.visibility,
    required this.answerCount,
    this.user,
    required this.createdAt,
    required this.updatedAt,
  });

  factory _$QuestionListItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuestionListItemImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String content;
  @override
  final QuestionCategory category;
  @override
  final QuestionStatus status;
  @override
  final QuestionVisibility visibility;
  @override
  final int answerCount;
  @override
  final QuestionUser? user;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'QuestionListItem(id: $id, title: $title, content: $content, category: $category, status: $status, visibility: $visibility, answerCount: $answerCount, user: $user, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestionListItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.visibility, visibility) ||
                other.visibility == visibility) &&
            (identical(other.answerCount, answerCount) ||
                other.answerCount == answerCount) &&
            (identical(other.user, user) || other.user == user) &&
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
    content,
    category,
    status,
    visibility,
    answerCount,
    user,
    createdAt,
    updatedAt,
  );

  /// Create a copy of QuestionListItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestionListItemImplCopyWith<_$QuestionListItemImpl> get copyWith =>
      __$$QuestionListItemImplCopyWithImpl<_$QuestionListItemImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$QuestionListItemImplToJson(this);
  }
}

abstract class _QuestionListItem implements QuestionListItem {
  const factory _QuestionListItem({
    required final String id,
    required final String title,
    required final String content,
    required final QuestionCategory category,
    required final QuestionStatus status,
    required final QuestionVisibility visibility,
    required final int answerCount,
    final QuestionUser? user,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$QuestionListItemImpl;

  factory _QuestionListItem.fromJson(Map<String, dynamic> json) =
      _$QuestionListItemImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get content;
  @override
  QuestionCategory get category;
  @override
  QuestionStatus get status;
  @override
  QuestionVisibility get visibility;
  @override
  int get answerCount;
  @override
  QuestionUser? get user;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of QuestionListItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuestionListItemImplCopyWith<_$QuestionListItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PaginationMeta _$PaginationMetaFromJson(Map<String, dynamic> json) {
  return _PaginationMeta.fromJson(json);
}

/// @nodoc
mixin _$PaginationMeta {
  int get total => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
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
  $Res call({int total, int page, int limit, int totalPages});
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
    Object? total = null,
    Object? page = null,
    Object? limit = null,
    Object? totalPages = null,
  }) {
    return _then(
      _value.copyWith(
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as int,
            page: null == page
                ? _value.page
                : page // ignore: cast_nullable_to_non_nullable
                      as int,
            limit: null == limit
                ? _value.limit
                : limit // ignore: cast_nullable_to_non_nullable
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
  $Res call({int total, int page, int limit, int totalPages});
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
    Object? total = null,
    Object? page = null,
    Object? limit = null,
    Object? totalPages = null,
  }) {
    return _then(
      _$PaginationMetaImpl(
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int,
        page: null == page
            ? _value.page
            : page // ignore: cast_nullable_to_non_nullable
                  as int,
        limit: null == limit
            ? _value.limit
            : limit // ignore: cast_nullable_to_non_nullable
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
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory _$PaginationMetaImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaginationMetaImplFromJson(json);

  @override
  final int total;
  @override
  final int page;
  @override
  final int limit;
  @override
  final int totalPages;

  @override
  String toString() {
    return 'PaginationMeta(total: $total, page: $page, limit: $limit, totalPages: $totalPages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginationMetaImpl &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, total, page, limit, totalPages);

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
    required final int total,
    required final int page,
    required final int limit,
    required final int totalPages,
  }) = _$PaginationMetaImpl;

  factory _PaginationMeta.fromJson(Map<String, dynamic> json) =
      _$PaginationMetaImpl.fromJson;

  @override
  int get total;
  @override
  int get page;
  @override
  int get limit;
  @override
  int get totalPages;

  /// Create a copy of PaginationMeta
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaginationMetaImplCopyWith<_$PaginationMetaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QuestionListResponse _$QuestionListResponseFromJson(Map<String, dynamic> json) {
  return _QuestionListResponse.fromJson(json);
}

/// @nodoc
mixin _$QuestionListResponse {
  List<QuestionListItem> get data => throw _privateConstructorUsedError;
  PaginationMeta get meta => throw _privateConstructorUsedError;

  /// Serializes this QuestionListResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuestionListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuestionListResponseCopyWith<QuestionListResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestionListResponseCopyWith<$Res> {
  factory $QuestionListResponseCopyWith(
    QuestionListResponse value,
    $Res Function(QuestionListResponse) then,
  ) = _$QuestionListResponseCopyWithImpl<$Res, QuestionListResponse>;
  @useResult
  $Res call({List<QuestionListItem> data, PaginationMeta meta});

  $PaginationMetaCopyWith<$Res> get meta;
}

/// @nodoc
class _$QuestionListResponseCopyWithImpl<
  $Res,
  $Val extends QuestionListResponse
>
    implements $QuestionListResponseCopyWith<$Res> {
  _$QuestionListResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuestionListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? data = null, Object? meta = null}) {
    return _then(
      _value.copyWith(
            data: null == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as List<QuestionListItem>,
            meta: null == meta
                ? _value.meta
                : meta // ignore: cast_nullable_to_non_nullable
                      as PaginationMeta,
          )
          as $Val,
    );
  }

  /// Create a copy of QuestionListResponse
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
abstract class _$$QuestionListResponseImplCopyWith<$Res>
    implements $QuestionListResponseCopyWith<$Res> {
  factory _$$QuestionListResponseImplCopyWith(
    _$QuestionListResponseImpl value,
    $Res Function(_$QuestionListResponseImpl) then,
  ) = __$$QuestionListResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<QuestionListItem> data, PaginationMeta meta});

  @override
  $PaginationMetaCopyWith<$Res> get meta;
}

/// @nodoc
class __$$QuestionListResponseImplCopyWithImpl<$Res>
    extends _$QuestionListResponseCopyWithImpl<$Res, _$QuestionListResponseImpl>
    implements _$$QuestionListResponseImplCopyWith<$Res> {
  __$$QuestionListResponseImplCopyWithImpl(
    _$QuestionListResponseImpl _value,
    $Res Function(_$QuestionListResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuestionListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? data = null, Object? meta = null}) {
    return _then(
      _$QuestionListResponseImpl(
        data: null == data
            ? _value._data
            : data // ignore: cast_nullable_to_non_nullable
                  as List<QuestionListItem>,
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
class _$QuestionListResponseImpl implements _QuestionListResponse {
  const _$QuestionListResponseImpl({
    required final List<QuestionListItem> data,
    required this.meta,
  }) : _data = data;

  factory _$QuestionListResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuestionListResponseImplFromJson(json);

  final List<QuestionListItem> _data;
  @override
  List<QuestionListItem> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final PaginationMeta meta;

  @override
  String toString() {
    return 'QuestionListResponse(data: $data, meta: $meta)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestionListResponseImpl &&
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

  /// Create a copy of QuestionListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestionListResponseImplCopyWith<_$QuestionListResponseImpl>
  get copyWith =>
      __$$QuestionListResponseImplCopyWithImpl<_$QuestionListResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$QuestionListResponseImplToJson(this);
  }
}

abstract class _QuestionListResponse implements QuestionListResponse {
  const factory _QuestionListResponse({
    required final List<QuestionListItem> data,
    required final PaginationMeta meta,
  }) = _$QuestionListResponseImpl;

  factory _QuestionListResponse.fromJson(Map<String, dynamic> json) =
      _$QuestionListResponseImpl.fromJson;

  @override
  List<QuestionListItem> get data;
  @override
  PaginationMeta get meta;

  /// Create a copy of QuestionListResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuestionListResponseImplCopyWith<_$QuestionListResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}

QnaStatistics _$QnaStatisticsFromJson(Map<String, dynamic> json) {
  return _QnaStatistics.fromJson(json);
}

/// @nodoc
mixin _$QnaStatistics {
  int get totalQuestions => throw _privateConstructorUsedError;
  int get pendingCount => throw _privateConstructorUsedError;
  int get answeredCount => throw _privateConstructorUsedError;
  Map<String, int> get categoryStats => throw _privateConstructorUsedError;

  /// Serializes this QnaStatistics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QnaStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QnaStatisticsCopyWith<QnaStatistics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QnaStatisticsCopyWith<$Res> {
  factory $QnaStatisticsCopyWith(
    QnaStatistics value,
    $Res Function(QnaStatistics) then,
  ) = _$QnaStatisticsCopyWithImpl<$Res, QnaStatistics>;
  @useResult
  $Res call({
    int totalQuestions,
    int pendingCount,
    int answeredCount,
    Map<String, int> categoryStats,
  });
}

/// @nodoc
class _$QnaStatisticsCopyWithImpl<$Res, $Val extends QnaStatistics>
    implements $QnaStatisticsCopyWith<$Res> {
  _$QnaStatisticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QnaStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalQuestions = null,
    Object? pendingCount = null,
    Object? answeredCount = null,
    Object? categoryStats = null,
  }) {
    return _then(
      _value.copyWith(
            totalQuestions: null == totalQuestions
                ? _value.totalQuestions
                : totalQuestions // ignore: cast_nullable_to_non_nullable
                      as int,
            pendingCount: null == pendingCount
                ? _value.pendingCount
                : pendingCount // ignore: cast_nullable_to_non_nullable
                      as int,
            answeredCount: null == answeredCount
                ? _value.answeredCount
                : answeredCount // ignore: cast_nullable_to_non_nullable
                      as int,
            categoryStats: null == categoryStats
                ? _value.categoryStats
                : categoryStats // ignore: cast_nullable_to_non_nullable
                      as Map<String, int>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QnaStatisticsImplCopyWith<$Res>
    implements $QnaStatisticsCopyWith<$Res> {
  factory _$$QnaStatisticsImplCopyWith(
    _$QnaStatisticsImpl value,
    $Res Function(_$QnaStatisticsImpl) then,
  ) = __$$QnaStatisticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int totalQuestions,
    int pendingCount,
    int answeredCount,
    Map<String, int> categoryStats,
  });
}

/// @nodoc
class __$$QnaStatisticsImplCopyWithImpl<$Res>
    extends _$QnaStatisticsCopyWithImpl<$Res, _$QnaStatisticsImpl>
    implements _$$QnaStatisticsImplCopyWith<$Res> {
  __$$QnaStatisticsImplCopyWithImpl(
    _$QnaStatisticsImpl _value,
    $Res Function(_$QnaStatisticsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QnaStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalQuestions = null,
    Object? pendingCount = null,
    Object? answeredCount = null,
    Object? categoryStats = null,
  }) {
    return _then(
      _$QnaStatisticsImpl(
        totalQuestions: null == totalQuestions
            ? _value.totalQuestions
            : totalQuestions // ignore: cast_nullable_to_non_nullable
                  as int,
        pendingCount: null == pendingCount
            ? _value.pendingCount
            : pendingCount // ignore: cast_nullable_to_non_nullable
                  as int,
        answeredCount: null == answeredCount
            ? _value.answeredCount
            : answeredCount // ignore: cast_nullable_to_non_nullable
                  as int,
        categoryStats: null == categoryStats
            ? _value._categoryStats
            : categoryStats // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$QnaStatisticsImpl implements _QnaStatistics {
  const _$QnaStatisticsImpl({
    required this.totalQuestions,
    required this.pendingCount,
    required this.answeredCount,
    required final Map<String, int> categoryStats,
  }) : _categoryStats = categoryStats;

  factory _$QnaStatisticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$QnaStatisticsImplFromJson(json);

  @override
  final int totalQuestions;
  @override
  final int pendingCount;
  @override
  final int answeredCount;
  final Map<String, int> _categoryStats;
  @override
  Map<String, int> get categoryStats {
    if (_categoryStats is EqualUnmodifiableMapView) return _categoryStats;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_categoryStats);
  }

  @override
  String toString() {
    return 'QnaStatistics(totalQuestions: $totalQuestions, pendingCount: $pendingCount, answeredCount: $answeredCount, categoryStats: $categoryStats)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QnaStatisticsImpl &&
            (identical(other.totalQuestions, totalQuestions) ||
                other.totalQuestions == totalQuestions) &&
            (identical(other.pendingCount, pendingCount) ||
                other.pendingCount == pendingCount) &&
            (identical(other.answeredCount, answeredCount) ||
                other.answeredCount == answeredCount) &&
            const DeepCollectionEquality().equals(
              other._categoryStats,
              _categoryStats,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalQuestions,
    pendingCount,
    answeredCount,
    const DeepCollectionEquality().hash(_categoryStats),
  );

  /// Create a copy of QnaStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QnaStatisticsImplCopyWith<_$QnaStatisticsImpl> get copyWith =>
      __$$QnaStatisticsImplCopyWithImpl<_$QnaStatisticsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QnaStatisticsImplToJson(this);
  }
}

abstract class _QnaStatistics implements QnaStatistics {
  const factory _QnaStatistics({
    required final int totalQuestions,
    required final int pendingCount,
    required final int answeredCount,
    required final Map<String, int> categoryStats,
  }) = _$QnaStatisticsImpl;

  factory _QnaStatistics.fromJson(Map<String, dynamic> json) =
      _$QnaStatisticsImpl.fromJson;

  @override
  int get totalQuestions;
  @override
  int get pendingCount;
  @override
  int get answeredCount;
  @override
  Map<String, int> get categoryStats;

  /// Create a copy of QnaStatistics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QnaStatisticsImplCopyWith<_$QnaStatisticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
