// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'memo_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ChecklistItem _$ChecklistItemFromJson(Map<String, dynamic> json) {
  return _ChecklistItem.fromJson(json);
}

/// @nodoc
mixin _$ChecklistItem {
  String get id => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  bool get isChecked => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ChecklistItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChecklistItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChecklistItemCopyWith<ChecklistItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChecklistItemCopyWith<$Res> {
  factory $ChecklistItemCopyWith(
    ChecklistItem value,
    $Res Function(ChecklistItem) then,
  ) = _$ChecklistItemCopyWithImpl<$Res, ChecklistItem>;
  @useResult
  $Res call({
    String id,
    String content,
    bool isChecked,
    int order,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$ChecklistItemCopyWithImpl<$Res, $Val extends ChecklistItem>
    implements $ChecklistItemCopyWith<$Res> {
  _$ChecklistItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChecklistItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? content = null,
    Object? isChecked = null,
    Object? order = null,
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
            isChecked: null == isChecked
                ? _value.isChecked
                : isChecked // ignore: cast_nullable_to_non_nullable
                      as bool,
            order: null == order
                ? _value.order
                : order // ignore: cast_nullable_to_non_nullable
                      as int,
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
abstract class _$$ChecklistItemImplCopyWith<$Res>
    implements $ChecklistItemCopyWith<$Res> {
  factory _$$ChecklistItemImplCopyWith(
    _$ChecklistItemImpl value,
    $Res Function(_$ChecklistItemImpl) then,
  ) = __$$ChecklistItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String content,
    bool isChecked,
    int order,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$ChecklistItemImplCopyWithImpl<$Res>
    extends _$ChecklistItemCopyWithImpl<$Res, _$ChecklistItemImpl>
    implements _$$ChecklistItemImplCopyWith<$Res> {
  __$$ChecklistItemImplCopyWithImpl(
    _$ChecklistItemImpl _value,
    $Res Function(_$ChecklistItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChecklistItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? content = null,
    Object? isChecked = null,
    Object? order = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$ChecklistItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        isChecked: null == isChecked
            ? _value.isChecked
            : isChecked // ignore: cast_nullable_to_non_nullable
                  as bool,
        order: null == order
            ? _value.order
            : order // ignore: cast_nullable_to_non_nullable
                  as int,
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
class _$ChecklistItemImpl implements _ChecklistItem {
  const _$ChecklistItemImpl({
    required this.id,
    required this.content,
    required this.isChecked,
    required this.order,
    required this.createdAt,
    required this.updatedAt,
  });

  factory _$ChecklistItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChecklistItemImplFromJson(json);

  @override
  final String id;
  @override
  final String content;
  @override
  final bool isChecked;
  @override
  final int order;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'ChecklistItem(id: $id, content: $content, isChecked: $isChecked, order: $order, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChecklistItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.isChecked, isChecked) ||
                other.isChecked == isChecked) &&
            (identical(other.order, order) || other.order == order) &&
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
    isChecked,
    order,
    createdAt,
    updatedAt,
  );

  /// Create a copy of ChecklistItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChecklistItemImplCopyWith<_$ChecklistItemImpl> get copyWith =>
      __$$ChecklistItemImplCopyWithImpl<_$ChecklistItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChecklistItemImplToJson(this);
  }
}

abstract class _ChecklistItem implements ChecklistItem {
  const factory _ChecklistItem({
    required final String id,
    required final String content,
    required final bool isChecked,
    required final int order,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$ChecklistItemImpl;

  factory _ChecklistItem.fromJson(Map<String, dynamic> json) =
      _$ChecklistItemImpl.fromJson;

  @override
  String get id;
  @override
  String get content;
  @override
  bool get isChecked;
  @override
  int get order;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of ChecklistItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChecklistItemImplCopyWith<_$ChecklistItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MemoAuthor _$MemoAuthorFromJson(Map<String, dynamic> json) {
  return _MemoAuthor.fromJson(json);
}

/// @nodoc
mixin _$MemoAuthor {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  /// Serializes this MemoAuthor to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MemoAuthor
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MemoAuthorCopyWith<MemoAuthor> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MemoAuthorCopyWith<$Res> {
  factory $MemoAuthorCopyWith(
    MemoAuthor value,
    $Res Function(MemoAuthor) then,
  ) = _$MemoAuthorCopyWithImpl<$Res, MemoAuthor>;
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class _$MemoAuthorCopyWithImpl<$Res, $Val extends MemoAuthor>
    implements $MemoAuthorCopyWith<$Res> {
  _$MemoAuthorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MemoAuthor
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
abstract class _$$MemoAuthorImplCopyWith<$Res>
    implements $MemoAuthorCopyWith<$Res> {
  factory _$$MemoAuthorImplCopyWith(
    _$MemoAuthorImpl value,
    $Res Function(_$MemoAuthorImpl) then,
  ) = __$$MemoAuthorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class __$$MemoAuthorImplCopyWithImpl<$Res>
    extends _$MemoAuthorCopyWithImpl<$Res, _$MemoAuthorImpl>
    implements _$$MemoAuthorImplCopyWith<$Res> {
  __$$MemoAuthorImplCopyWithImpl(
    _$MemoAuthorImpl _value,
    $Res Function(_$MemoAuthorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MemoAuthor
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null}) {
    return _then(
      _$MemoAuthorImpl(
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
class _$MemoAuthorImpl implements _MemoAuthor {
  const _$MemoAuthorImpl({required this.id, required this.name});

  factory _$MemoAuthorImpl.fromJson(Map<String, dynamic> json) =>
      _$$MemoAuthorImplFromJson(json);

  @override
  final String id;
  @override
  final String name;

  @override
  String toString() {
    return 'MemoAuthor(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MemoAuthorImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  /// Create a copy of MemoAuthor
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MemoAuthorImplCopyWith<_$MemoAuthorImpl> get copyWith =>
      __$$MemoAuthorImplCopyWithImpl<_$MemoAuthorImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MemoAuthorImplToJson(this);
  }
}

abstract class _MemoAuthor implements MemoAuthor {
  const factory _MemoAuthor({
    required final String id,
    required final String name,
  }) = _$MemoAuthorImpl;

  factory _MemoAuthor.fromJson(Map<String, dynamic> json) =
      _$MemoAuthorImpl.fromJson;

  @override
  String get id;
  @override
  String get name;

  /// Create a copy of MemoAuthor
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MemoAuthorImplCopyWith<_$MemoAuthorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MemoTag _$MemoTagFromJson(Map<String, dynamic> json) {
  return _MemoTag.fromJson(json);
}

/// @nodoc
mixin _$MemoTag {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;

  /// Serializes this MemoTag to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MemoTag
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MemoTagCopyWith<MemoTag> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MemoTagCopyWith<$Res> {
  factory $MemoTagCopyWith(MemoTag value, $Res Function(MemoTag) then) =
      _$MemoTagCopyWithImpl<$Res, MemoTag>;
  @useResult
  $Res call({String id, String name, String? color});
}

/// @nodoc
class _$MemoTagCopyWithImpl<$Res, $Val extends MemoTag>
    implements $MemoTagCopyWith<$Res> {
  _$MemoTagCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MemoTag
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null, Object? color = freezed}) {
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
            color: freezed == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MemoTagImplCopyWith<$Res> implements $MemoTagCopyWith<$Res> {
  factory _$$MemoTagImplCopyWith(
    _$MemoTagImpl value,
    $Res Function(_$MemoTagImpl) then,
  ) = __$$MemoTagImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String? color});
}

/// @nodoc
class __$$MemoTagImplCopyWithImpl<$Res>
    extends _$MemoTagCopyWithImpl<$Res, _$MemoTagImpl>
    implements _$$MemoTagImplCopyWith<$Res> {
  __$$MemoTagImplCopyWithImpl(
    _$MemoTagImpl _value,
    $Res Function(_$MemoTagImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MemoTag
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null, Object? color = freezed}) {
    return _then(
      _$MemoTagImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        color: freezed == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MemoTagImpl implements _MemoTag {
  const _$MemoTagImpl({required this.id, required this.name, this.color});

  factory _$MemoTagImpl.fromJson(Map<String, dynamic> json) =>
      _$$MemoTagImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? color;

  @override
  String toString() {
    return 'MemoTag(id: $id, name: $name, color: $color)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MemoTagImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.color, color) || other.color == color));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, color);

  /// Create a copy of MemoTag
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MemoTagImplCopyWith<_$MemoTagImpl> get copyWith =>
      __$$MemoTagImplCopyWithImpl<_$MemoTagImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MemoTagImplToJson(this);
  }
}

abstract class _MemoTag implements MemoTag {
  const factory _MemoTag({
    required final String id,
    required final String name,
    final String? color,
  }) = _$MemoTagImpl;

  factory _MemoTag.fromJson(Map<String, dynamic> json) = _$MemoTagImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get color;

  /// Create a copy of MemoTag
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MemoTagImplCopyWith<_$MemoTagImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MemoAttachment _$MemoAttachmentFromJson(Map<String, dynamic> json) {
  return _MemoAttachment.fromJson(json);
}

/// @nodoc
mixin _$MemoAttachment {
  String get id => throw _privateConstructorUsedError;
  String get fileName => throw _privateConstructorUsedError;
  String get fileUrl => throw _privateConstructorUsedError;
  int get fileSize => throw _privateConstructorUsedError;
  String get mimeType => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this MemoAttachment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MemoAttachment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MemoAttachmentCopyWith<MemoAttachment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MemoAttachmentCopyWith<$Res> {
  factory $MemoAttachmentCopyWith(
    MemoAttachment value,
    $Res Function(MemoAttachment) then,
  ) = _$MemoAttachmentCopyWithImpl<$Res, MemoAttachment>;
  @useResult
  $Res call({
    String id,
    String fileName,
    String fileUrl,
    int fileSize,
    String mimeType,
    DateTime createdAt,
  });
}

/// @nodoc
class _$MemoAttachmentCopyWithImpl<$Res, $Val extends MemoAttachment>
    implements $MemoAttachmentCopyWith<$Res> {
  _$MemoAttachmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MemoAttachment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fileName = null,
    Object? fileUrl = null,
    Object? fileSize = null,
    Object? mimeType = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            fileName: null == fileName
                ? _value.fileName
                : fileName // ignore: cast_nullable_to_non_nullable
                      as String,
            fileUrl: null == fileUrl
                ? _value.fileUrl
                : fileUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            fileSize: null == fileSize
                ? _value.fileSize
                : fileSize // ignore: cast_nullable_to_non_nullable
                      as int,
            mimeType: null == mimeType
                ? _value.mimeType
                : mimeType // ignore: cast_nullable_to_non_nullable
                      as String,
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
abstract class _$$MemoAttachmentImplCopyWith<$Res>
    implements $MemoAttachmentCopyWith<$Res> {
  factory _$$MemoAttachmentImplCopyWith(
    _$MemoAttachmentImpl value,
    $Res Function(_$MemoAttachmentImpl) then,
  ) = __$$MemoAttachmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String fileName,
    String fileUrl,
    int fileSize,
    String mimeType,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$MemoAttachmentImplCopyWithImpl<$Res>
    extends _$MemoAttachmentCopyWithImpl<$Res, _$MemoAttachmentImpl>
    implements _$$MemoAttachmentImplCopyWith<$Res> {
  __$$MemoAttachmentImplCopyWithImpl(
    _$MemoAttachmentImpl _value,
    $Res Function(_$MemoAttachmentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MemoAttachment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fileName = null,
    Object? fileUrl = null,
    Object? fileSize = null,
    Object? mimeType = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$MemoAttachmentImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        fileName: null == fileName
            ? _value.fileName
            : fileName // ignore: cast_nullable_to_non_nullable
                  as String,
        fileUrl: null == fileUrl
            ? _value.fileUrl
            : fileUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        fileSize: null == fileSize
            ? _value.fileSize
            : fileSize // ignore: cast_nullable_to_non_nullable
                  as int,
        mimeType: null == mimeType
            ? _value.mimeType
            : mimeType // ignore: cast_nullable_to_non_nullable
                  as String,
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
class _$MemoAttachmentImpl implements _MemoAttachment {
  const _$MemoAttachmentImpl({
    required this.id,
    required this.fileName,
    required this.fileUrl,
    required this.fileSize,
    required this.mimeType,
    required this.createdAt,
  });

  factory _$MemoAttachmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$MemoAttachmentImplFromJson(json);

  @override
  final String id;
  @override
  final String fileName;
  @override
  final String fileUrl;
  @override
  final int fileSize;
  @override
  final String mimeType;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'MemoAttachment(id: $id, fileName: $fileName, fileUrl: $fileUrl, fileSize: $fileSize, mimeType: $mimeType, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MemoAttachmentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl) &&
            (identical(other.fileSize, fileSize) ||
                other.fileSize == fileSize) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    fileName,
    fileUrl,
    fileSize,
    mimeType,
    createdAt,
  );

  /// Create a copy of MemoAttachment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MemoAttachmentImplCopyWith<_$MemoAttachmentImpl> get copyWith =>
      __$$MemoAttachmentImplCopyWithImpl<_$MemoAttachmentImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MemoAttachmentImplToJson(this);
  }
}

abstract class _MemoAttachment implements MemoAttachment {
  const factory _MemoAttachment({
    required final String id,
    required final String fileName,
    required final String fileUrl,
    required final int fileSize,
    required final String mimeType,
    required final DateTime createdAt,
  }) = _$MemoAttachmentImpl;

  factory _MemoAttachment.fromJson(Map<String, dynamic> json) =
      _$MemoAttachmentImpl.fromJson;

  @override
  String get id;
  @override
  String get fileName;
  @override
  String get fileUrl;
  @override
  int get fileSize;
  @override
  String get mimeType;
  @override
  DateTime get createdAt;

  /// Create a copy of MemoAttachment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MemoAttachmentImplCopyWith<_$MemoAttachmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MemoModel _$MemoModelFromJson(Map<String, dynamic> json) {
  return _MemoModel.fromJson(json);
}

/// @nodoc
mixin _$MemoModel {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  MemoFormat? get format => throw _privateConstructorUsedError;
  MemoType? get type => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  MemoVisibility? get visibility => throw _privateConstructorUsedError;
  String? get groupId => throw _privateConstructorUsedError;
  MemoAuthor get user => throw _privateConstructorUsedError;
  List<MemoTag> get tags => throw _privateConstructorUsedError;
  List<MemoAttachment> get attachments => throw _privateConstructorUsedError;
  List<ChecklistItem> get checklistItems => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this MemoModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MemoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MemoModelCopyWith<MemoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MemoModelCopyWith<$Res> {
  factory $MemoModelCopyWith(MemoModel value, $Res Function(MemoModel) then) =
      _$MemoModelCopyWithImpl<$Res, MemoModel>;
  @useResult
  $Res call({
    String id,
    String title,
    String content,
    MemoFormat? format,
    MemoType? type,
    String? category,
    MemoVisibility? visibility,
    String? groupId,
    MemoAuthor user,
    List<MemoTag> tags,
    List<MemoAttachment> attachments,
    List<ChecklistItem> checklistItems,
    DateTime createdAt,
    DateTime updatedAt,
  });

  $MemoAuthorCopyWith<$Res> get user;
}

/// @nodoc
class _$MemoModelCopyWithImpl<$Res, $Val extends MemoModel>
    implements $MemoModelCopyWith<$Res> {
  _$MemoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MemoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? content = null,
    Object? format = freezed,
    Object? type = freezed,
    Object? category = freezed,
    Object? visibility = freezed,
    Object? groupId = freezed,
    Object? user = null,
    Object? tags = null,
    Object? attachments = null,
    Object? checklistItems = null,
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
            format: freezed == format
                ? _value.format
                : format // ignore: cast_nullable_to_non_nullable
                      as MemoFormat?,
            type: freezed == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as MemoType?,
            category: freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String?,
            visibility: freezed == visibility
                ? _value.visibility
                : visibility // ignore: cast_nullable_to_non_nullable
                      as MemoVisibility?,
            groupId: freezed == groupId
                ? _value.groupId
                : groupId // ignore: cast_nullable_to_non_nullable
                      as String?,
            user: null == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as MemoAuthor,
            tags: null == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<MemoTag>,
            attachments: null == attachments
                ? _value.attachments
                : attachments // ignore: cast_nullable_to_non_nullable
                      as List<MemoAttachment>,
            checklistItems: null == checklistItems
                ? _value.checklistItems
                : checklistItems // ignore: cast_nullable_to_non_nullable
                      as List<ChecklistItem>,
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

  /// Create a copy of MemoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MemoAuthorCopyWith<$Res> get user {
    return $MemoAuthorCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MemoModelImplCopyWith<$Res>
    implements $MemoModelCopyWith<$Res> {
  factory _$$MemoModelImplCopyWith(
    _$MemoModelImpl value,
    $Res Function(_$MemoModelImpl) then,
  ) = __$$MemoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String content,
    MemoFormat? format,
    MemoType? type,
    String? category,
    MemoVisibility? visibility,
    String? groupId,
    MemoAuthor user,
    List<MemoTag> tags,
    List<MemoAttachment> attachments,
    List<ChecklistItem> checklistItems,
    DateTime createdAt,
    DateTime updatedAt,
  });

  @override
  $MemoAuthorCopyWith<$Res> get user;
}

/// @nodoc
class __$$MemoModelImplCopyWithImpl<$Res>
    extends _$MemoModelCopyWithImpl<$Res, _$MemoModelImpl>
    implements _$$MemoModelImplCopyWith<$Res> {
  __$$MemoModelImplCopyWithImpl(
    _$MemoModelImpl _value,
    $Res Function(_$MemoModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MemoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? content = null,
    Object? format = freezed,
    Object? type = freezed,
    Object? category = freezed,
    Object? visibility = freezed,
    Object? groupId = freezed,
    Object? user = null,
    Object? tags = null,
    Object? attachments = null,
    Object? checklistItems = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$MemoModelImpl(
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
        format: freezed == format
            ? _value.format
            : format // ignore: cast_nullable_to_non_nullable
                  as MemoFormat?,
        type: freezed == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as MemoType?,
        category: freezed == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String?,
        visibility: freezed == visibility
            ? _value.visibility
            : visibility // ignore: cast_nullable_to_non_nullable
                  as MemoVisibility?,
        groupId: freezed == groupId
            ? _value.groupId
            : groupId // ignore: cast_nullable_to_non_nullable
                  as String?,
        user: null == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as MemoAuthor,
        tags: null == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<MemoTag>,
        attachments: null == attachments
            ? _value._attachments
            : attachments // ignore: cast_nullable_to_non_nullable
                  as List<MemoAttachment>,
        checklistItems: null == checklistItems
            ? _value._checklistItems
            : checklistItems // ignore: cast_nullable_to_non_nullable
                  as List<ChecklistItem>,
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
class _$MemoModelImpl implements _MemoModel {
  const _$MemoModelImpl({
    required this.id,
    required this.title,
    this.content = '',
    this.format,
    this.type,
    this.category,
    this.visibility,
    this.groupId,
    required this.user,
    final List<MemoTag> tags = const [],
    final List<MemoAttachment> attachments = const [],
    final List<ChecklistItem> checklistItems = const [],
    required this.createdAt,
    required this.updatedAt,
  }) : _tags = tags,
       _attachments = attachments,
       _checklistItems = checklistItems;

  factory _$MemoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MemoModelImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  @JsonKey()
  final String content;
  @override
  final MemoFormat? format;
  @override
  final MemoType? type;
  @override
  final String? category;
  @override
  final MemoVisibility? visibility;
  @override
  final String? groupId;
  @override
  final MemoAuthor user;
  final List<MemoTag> _tags;
  @override
  @JsonKey()
  List<MemoTag> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  final List<MemoAttachment> _attachments;
  @override
  @JsonKey()
  List<MemoAttachment> get attachments {
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attachments);
  }

  final List<ChecklistItem> _checklistItems;
  @override
  @JsonKey()
  List<ChecklistItem> get checklistItems {
    if (_checklistItems is EqualUnmodifiableListView) return _checklistItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_checklistItems);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'MemoModel(id: $id, title: $title, content: $content, format: $format, type: $type, category: $category, visibility: $visibility, groupId: $groupId, user: $user, tags: $tags, attachments: $attachments, checklistItems: $checklistItems, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MemoModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.format, format) || other.format == format) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.visibility, visibility) ||
                other.visibility == visibility) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.user, user) || other.user == user) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality().equals(
              other._attachments,
              _attachments,
            ) &&
            const DeepCollectionEquality().equals(
              other._checklistItems,
              _checklistItems,
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
    title,
    content,
    format,
    type,
    category,
    visibility,
    groupId,
    user,
    const DeepCollectionEquality().hash(_tags),
    const DeepCollectionEquality().hash(_attachments),
    const DeepCollectionEquality().hash(_checklistItems),
    createdAt,
    updatedAt,
  );

  /// Create a copy of MemoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MemoModelImplCopyWith<_$MemoModelImpl> get copyWith =>
      __$$MemoModelImplCopyWithImpl<_$MemoModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MemoModelImplToJson(this);
  }
}

abstract class _MemoModel implements MemoModel {
  const factory _MemoModel({
    required final String id,
    required final String title,
    final String content,
    final MemoFormat? format,
    final MemoType? type,
    final String? category,
    final MemoVisibility? visibility,
    final String? groupId,
    required final MemoAuthor user,
    final List<MemoTag> tags,
    final List<MemoAttachment> attachments,
    final List<ChecklistItem> checklistItems,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$MemoModelImpl;

  factory _MemoModel.fromJson(Map<String, dynamic> json) =
      _$MemoModelImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get content;
  @override
  MemoFormat? get format;
  @override
  MemoType? get type;
  @override
  String? get category;
  @override
  MemoVisibility? get visibility;
  @override
  String? get groupId;
  @override
  MemoAuthor get user;
  @override
  List<MemoTag> get tags;
  @override
  List<MemoAttachment> get attachments;
  @override
  List<ChecklistItem> get checklistItems;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of MemoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MemoModelImplCopyWith<_$MemoModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MemoListResponse _$MemoListResponseFromJson(Map<String, dynamic> json) {
  return _MemoListResponse.fromJson(json);
}

/// @nodoc
mixin _$MemoListResponse {
  List<MemoModel> get items => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  int get totalPages => throw _privateConstructorUsedError;

  /// Serializes this MemoListResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MemoListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MemoListResponseCopyWith<MemoListResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MemoListResponseCopyWith<$Res> {
  factory $MemoListResponseCopyWith(
    MemoListResponse value,
    $Res Function(MemoListResponse) then,
  ) = _$MemoListResponseCopyWithImpl<$Res, MemoListResponse>;
  @useResult
  $Res call({
    List<MemoModel> items,
    int total,
    int page,
    int limit,
    int totalPages,
  });
}

/// @nodoc
class _$MemoListResponseCopyWithImpl<$Res, $Val extends MemoListResponse>
    implements $MemoListResponseCopyWith<$Res> {
  _$MemoListResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MemoListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? total = null,
    Object? page = null,
    Object? limit = null,
    Object? totalPages = null,
  }) {
    return _then(
      _value.copyWith(
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<MemoModel>,
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
abstract class _$$MemoListResponseImplCopyWith<$Res>
    implements $MemoListResponseCopyWith<$Res> {
  factory _$$MemoListResponseImplCopyWith(
    _$MemoListResponseImpl value,
    $Res Function(_$MemoListResponseImpl) then,
  ) = __$$MemoListResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<MemoModel> items,
    int total,
    int page,
    int limit,
    int totalPages,
  });
}

/// @nodoc
class __$$MemoListResponseImplCopyWithImpl<$Res>
    extends _$MemoListResponseCopyWithImpl<$Res, _$MemoListResponseImpl>
    implements _$$MemoListResponseImplCopyWith<$Res> {
  __$$MemoListResponseImplCopyWithImpl(
    _$MemoListResponseImpl _value,
    $Res Function(_$MemoListResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MemoListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? total = null,
    Object? page = null,
    Object? limit = null,
    Object? totalPages = null,
  }) {
    return _then(
      _$MemoListResponseImpl(
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<MemoModel>,
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
class _$MemoListResponseImpl implements _MemoListResponse {
  const _$MemoListResponseImpl({
    final List<MemoModel> items = const [],
    this.total = 0,
    this.page = 1,
    this.limit = 20,
    this.totalPages = 0,
  }) : _items = items;

  factory _$MemoListResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$MemoListResponseImplFromJson(json);

  final List<MemoModel> _items;
  @override
  @JsonKey()
  List<MemoModel> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  @JsonKey()
  final int total;
  @override
  @JsonKey()
  final int page;
  @override
  @JsonKey()
  final int limit;
  @override
  @JsonKey()
  final int totalPages;

  @override
  String toString() {
    return 'MemoListResponse(items: $items, total: $total, page: $page, limit: $limit, totalPages: $totalPages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MemoListResponseImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_items),
    total,
    page,
    limit,
    totalPages,
  );

  /// Create a copy of MemoListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MemoListResponseImplCopyWith<_$MemoListResponseImpl> get copyWith =>
      __$$MemoListResponseImplCopyWithImpl<_$MemoListResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MemoListResponseImplToJson(this);
  }
}

abstract class _MemoListResponse implements MemoListResponse {
  const factory _MemoListResponse({
    final List<MemoModel> items,
    final int total,
    final int page,
    final int limit,
    final int totalPages,
  }) = _$MemoListResponseImpl;

  factory _MemoListResponse.fromJson(Map<String, dynamic> json) =
      _$MemoListResponseImpl.fromJson;

  @override
  List<MemoModel> get items;
  @override
  int get total;
  @override
  int get page;
  @override
  int get limit;
  @override
  int get totalPages;

  /// Create a copy of MemoListResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MemoListResponseImplCopyWith<_$MemoListResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
