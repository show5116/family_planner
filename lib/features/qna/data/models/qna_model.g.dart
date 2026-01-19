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

_$AnswerModelImpl _$$AnswerModelImplFromJson(Map<String, dynamic> json) =>
    _$AnswerModelImpl(
      id: json['id'] as String,
      content: json['content'] as String,
      adminId: json['adminId'] as String,
      admin: QuestionUser.fromJson(json['admin'] as Map<String, dynamic>),
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => Attachment.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$AnswerModelImplToJson(_$AnswerModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'adminId': instance.adminId,
      'admin': instance.admin,
      'attachments': instance.attachments,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_$QuestionModelImpl _$$QuestionModelImplFromJson(Map<String, dynamic> json) =>
    _$QuestionModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      category: $enumDecode(_$QuestionCategoryEnumMap, json['category']),
      status: $enumDecode(_$QuestionStatusEnumMap, json['status']),
      visibility: $enumDecode(_$QuestionVisibilityEnumMap, json['visibility']),
      user: json['user'] == null
          ? null
          : QuestionUser.fromJson(json['user'] as Map<String, dynamic>),
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => Attachment.fromJson(e as Map<String, dynamic>))
          .toList(),
      answers:
          (json['answers'] as List<dynamic>?)
              ?.map((e) => AnswerModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$QuestionModelImplToJson(_$QuestionModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'category': _$QuestionCategoryEnumMap[instance.category]!,
      'status': _$QuestionStatusEnumMap[instance.status]!,
      'visibility': _$QuestionVisibilityEnumMap[instance.visibility]!,
      'user': instance.user,
      'attachments': instance.attachments,
      'answers': instance.answers,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$QuestionCategoryEnumMap = {
  QuestionCategory.bug: 'BUG',
  QuestionCategory.feature: 'FEATURE',
  QuestionCategory.usage: 'USAGE',
  QuestionCategory.account: 'ACCOUNT',
  QuestionCategory.payment: 'PAYMENT',
  QuestionCategory.etc: 'ETC',
};

const _$QuestionStatusEnumMap = {
  QuestionStatus.pending: 'PENDING',
  QuestionStatus.answered: 'ANSWERED',
  QuestionStatus.resolved: 'RESOLVED',
};

const _$QuestionVisibilityEnumMap = {
  QuestionVisibility.public: 'PUBLIC',
  QuestionVisibility.private: 'PRIVATE',
};

_$QuestionListItemImpl _$$QuestionListItemImplFromJson(
  Map<String, dynamic> json,
) => _$QuestionListItemImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  content: json['content'] as String,
  category: $enumDecode(_$QuestionCategoryEnumMap, json['category']),
  status: $enumDecode(_$QuestionStatusEnumMap, json['status']),
  visibility: $enumDecode(_$QuestionVisibilityEnumMap, json['visibility']),
  answerCount: (json['answerCount'] as num).toInt(),
  user: json['user'] == null
      ? null
      : QuestionUser.fromJson(json['user'] as Map<String, dynamic>),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$QuestionListItemImplToJson(
  _$QuestionListItemImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'content': instance.content,
  'category': _$QuestionCategoryEnumMap[instance.category]!,
  'status': _$QuestionStatusEnumMap[instance.status]!,
  'visibility': _$QuestionVisibilityEnumMap[instance.visibility]!,
  'answerCount': instance.answerCount,
  'user': instance.user,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

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

_$QuestionListResponseImpl _$$QuestionListResponseImplFromJson(
  Map<String, dynamic> json,
) => _$QuestionListResponseImpl(
  data: (json['data'] as List<dynamic>)
      .map((e) => QuestionListItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$QuestionListResponseImplToJson(
  _$QuestionListResponseImpl instance,
) => <String, dynamic>{'data': instance.data, 'meta': instance.meta};

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
