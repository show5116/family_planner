// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChecklistItemImpl _$$ChecklistItemImplFromJson(Map<String, dynamic> json) =>
    _$ChecklistItemImpl(
      id: json['id'] as String,
      content: json['content'] as String,
      isChecked: json['isChecked'] as bool,
      order: (json['order'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ChecklistItemImplToJson(_$ChecklistItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'isChecked': instance.isChecked,
      'order': instance.order,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_$MemoAuthorImpl _$$MemoAuthorImplFromJson(Map<String, dynamic> json) =>
    _$MemoAuthorImpl(id: json['id'] as String, name: json['name'] as String);

Map<String, dynamic> _$$MemoAuthorImplToJson(_$MemoAuthorImpl instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

_$MemoTagImpl _$$MemoTagImplFromJson(Map<String, dynamic> json) =>
    _$MemoTagImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      color: json['color'] as String?,
    );

Map<String, dynamic> _$$MemoTagImplToJson(_$MemoTagImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'color': instance.color,
    };

_$MemoAttachmentImpl _$$MemoAttachmentImplFromJson(Map<String, dynamic> json) =>
    _$MemoAttachmentImpl(
      id: json['id'] as String,
      fileName: json['fileName'] as String,
      fileUrl: json['fileUrl'] as String,
      fileSize: (json['fileSize'] as num).toInt(),
      mimeType: json['mimeType'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$MemoAttachmentImplToJson(
  _$MemoAttachmentImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'fileName': instance.fileName,
  'fileUrl': instance.fileUrl,
  'fileSize': instance.fileSize,
  'mimeType': instance.mimeType,
  'createdAt': instance.createdAt.toIso8601String(),
};

_$MemoModelImpl _$$MemoModelImplFromJson(Map<String, dynamic> json) =>
    _$MemoModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String? ?? '',
      format: $enumDecodeNullable(_$MemoFormatEnumMap, json['format']),
      type: $enumDecodeNullable(_$MemoTypeEnumMap, json['type']),
      visibility: $enumDecodeNullable(
        _$MemoVisibilityEnumMap,
        json['visibility'],
      ),
      isPinned: json['isPinned'] as bool? ?? false,
      groupId: json['groupId'] as String?,
      user: MemoAuthor.fromJson(json['user'] as Map<String, dynamic>),
      tags:
          (json['tags'] as List<dynamic>?)
              ?.map((e) => MemoTag.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      attachments:
          (json['attachments'] as List<dynamic>?)
              ?.map((e) => MemoAttachment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      checklistItems:
          (json['checklistItems'] as List<dynamic>?)
              ?.map((e) => ChecklistItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$MemoModelImplToJson(_$MemoModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'format': _$MemoFormatEnumMap[instance.format],
      'type': _$MemoTypeEnumMap[instance.type],
      'visibility': _$MemoVisibilityEnumMap[instance.visibility],
      'isPinned': instance.isPinned,
      'groupId': instance.groupId,
      'user': instance.user,
      'tags': instance.tags,
      'attachments': instance.attachments,
      'checklistItems': instance.checklistItems,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$MemoFormatEnumMap = {
  MemoFormat.text: 'TEXT',
  MemoFormat.markdown: 'MARKDOWN',
  MemoFormat.html: 'HTML',
};

const _$MemoTypeEnumMap = {
  MemoType.note: 'NOTE',
  MemoType.checklist: 'CHECKLIST',
};

const _$MemoVisibilityEnumMap = {
  MemoVisibility.private_: 'PRIVATE',
  MemoVisibility.group: 'GROUP',
};

_$MemoListResponseImpl _$$MemoListResponseImplFromJson(
  Map<String, dynamic> json,
) => _$MemoListResponseImpl(
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => MemoModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  total: (json['total'] as num?)?.toInt() ?? 0,
  page: (json['page'] as num?)?.toInt() ?? 1,
  limit: (json['limit'] as num?)?.toInt() ?? 20,
  totalPages: (json['totalPages'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$MemoListResponseImplToJson(
  _$MemoListResponseImpl instance,
) => <String, dynamic>{
  'items': instance.items,
  'total': instance.total,
  'page': instance.page,
  'limit': instance.limit,
  'totalPages': instance.totalPages,
};
