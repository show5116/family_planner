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
