// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
