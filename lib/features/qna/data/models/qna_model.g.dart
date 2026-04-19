// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qna_model.dart';

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

_$QuestionUserImpl _$$QuestionUserImplFromJson(Map<String, dynamic> json) =>
    _$QuestionUserImpl(id: json['id'] as String, name: json['name'] as String);

Map<String, dynamic> _$$QuestionUserImplToJson(_$QuestionUserImpl instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

_$PaginationMetaImpl _$$PaginationMetaImplFromJson(Map<String, dynamic> json) =>
    _$PaginationMetaImpl(
      total: (json['total'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
    );

Map<String, dynamic> _$$PaginationMetaImplToJson(
  _$PaginationMetaImpl instance,
) => <String, dynamic>{
  'total': instance.total,
  'page': instance.page,
  'limit': instance.limit,
  'totalPages': instance.totalPages,
};

_$QnaStatisticsImpl _$$QnaStatisticsImplFromJson(Map<String, dynamic> json) =>
    _$QnaStatisticsImpl(
      totalQuestions: (json['totalQuestions'] as num).toInt(),
      pendingCount: (json['pendingCount'] as num).toInt(),
      answeredCount: (json['answeredCount'] as num).toInt(),
      categoryStats: Map<String, int>.from(json['categoryStats'] as Map),
    );

Map<String, dynamic> _$$QnaStatisticsImplToJson(_$QnaStatisticsImpl instance) =>
    <String, dynamic>{
      'totalQuestions': instance.totalQuestions,
      'pendingCount': instance.pendingCount,
      'answeredCount': instance.answeredCount,
      'categoryStats': instance.categoryStats,
    };
