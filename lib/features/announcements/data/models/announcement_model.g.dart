// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AttachmentImpl _$$AttachmentImplFromJson(Map<String, dynamic> json) =>
    _$AttachmentImpl(
      url: json['url'] as String,
      name: json['name'] as String,
      size: (json['size'] as num).toInt(),
    );

Map<String, dynamic> _$$AttachmentImplToJson(_$AttachmentImpl instance) =>
    <String, dynamic>{
      'url': instance.url,
      'name': instance.name,
      'size': instance.size,
    };

_$AnnouncementAuthorImpl _$$AnnouncementAuthorImplFromJson(
  Map<String, dynamic> json,
) => _$AnnouncementAuthorImpl(
  id: json['id'] as String,
  name: json['name'] as String,
);

Map<String, dynamic> _$$AnnouncementAuthorImplToJson(
  _$AnnouncementAuthorImpl instance,
) => <String, dynamic>{'id': instance.id, 'name': instance.name};

_$AnnouncementModelImpl _$$AnnouncementModelImplFromJson(
  Map<String, dynamic> json,
) => _$AnnouncementModelImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  content: json['content'] as String,
  category: $enumDecodeNullable(
    _$AnnouncementCategoryEnumMap,
    json['category'],
  ),
  isPinned: json['isPinned'] as bool? ?? false,
  author: AnnouncementAuthor.fromJson(json['author'] as Map<String, dynamic>),
  isRead: json['isRead'] as bool? ?? false,
  readCount: (json['readCount'] as num?)?.toInt() ?? 0,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$AnnouncementModelImplToJson(
  _$AnnouncementModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'content': instance.content,
  'category': _$AnnouncementCategoryEnumMap[instance.category],
  'isPinned': instance.isPinned,
  'author': instance.author,
  'isRead': instance.isRead,
  'readCount': instance.readCount,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

const _$AnnouncementCategoryEnumMap = {
  AnnouncementCategory.announcement: 'announcement',
  AnnouncementCategory.event: 'event',
  AnnouncementCategory.update: 'update',
};

_$AnnouncementListResponseImpl _$$AnnouncementListResponseImplFromJson(
  Map<String, dynamic> json,
) => _$AnnouncementListResponseImpl(
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => AnnouncementModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  total: (json['total'] as num?)?.toInt() ?? 0,
  page: (json['page'] as num?)?.toInt() ?? 1,
  limit: (json['limit'] as num?)?.toInt() ?? 20,
);

Map<String, dynamic> _$$AnnouncementListResponseImplToJson(
  _$AnnouncementListResponseImpl instance,
) => <String, dynamic>{
  'items': instance.items,
  'total': instance.total,
  'page': instance.page,
  'limit': instance.limit,
};
