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

_$AnnouncementModelImpl _$$AnnouncementModelImplFromJson(
  Map<String, dynamic> json,
) => _$AnnouncementModelImpl(
  id: json['id'] as String,
  authorId: json['authorId'] as String,
  authorName: json['authorName'] as String,
  title: json['title'] as String,
  content: json['content'] as String,
  isPinned: json['isPinned'] as bool? ?? false,
  attachments: (json['attachments'] as List<dynamic>?)
      ?.map((e) => Attachment.fromJson(e as Map<String, dynamic>))
      .toList(),
  isRead: json['isRead'] as bool? ?? false,
  readCount: (json['readCount'] as num?)?.toInt() ?? 0,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$AnnouncementModelImplToJson(
  _$AnnouncementModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'authorId': instance.authorId,
  'authorName': instance.authorName,
  'title': instance.title,
  'content': instance.content,
  'isPinned': instance.isPinned,
  'attachments': instance.attachments,
  'isRead': instance.isRead,
  'readCount': instance.readCount,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

_$AnnouncementListResponseImpl _$$AnnouncementListResponseImplFromJson(
  Map<String, dynamic> json,
) => _$AnnouncementListResponseImpl(
  items: (json['items'] as List<dynamic>)
      .map((e) => AnnouncementModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  total: (json['total'] as num).toInt(),
  page: (json['page'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
);

Map<String, dynamic> _$$AnnouncementListResponseImplToJson(
  _$AnnouncementListResponseImpl instance,
) => <String, dynamic>{
  'items': instance.items,
  'total': instance.total,
  'page': instance.page,
  'limit': instance.limit,
};
