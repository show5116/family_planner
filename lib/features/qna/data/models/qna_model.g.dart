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

_$AnswerModelImpl _$$AnswerModelImplFromJson(Map<String, dynamic> json) =>
    _$AnswerModelImpl(
      id: json['id'] as String,
      questionId: json['questionId'] as String,
      adminId: json['adminId'] as String,
      adminName: json['adminName'] as String,
      content: json['content'] as String,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => Attachment.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$AnswerModelImplToJson(_$AnswerModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'questionId': instance.questionId,
      'adminId': instance.adminId,
      'adminName': instance.adminName,
      'content': instance.content,
      'attachments': instance.attachments,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_$QuestionModelImpl _$$QuestionModelImplFromJson(Map<String, dynamic> json) =>
    _$QuestionModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      category: $enumDecode(_$QuestionCategoryEnumMap, json['category']),
      status: $enumDecode(_$QuestionStatusEnumMap, json['status']),
      visibility: $enumDecode(_$QuestionVisibilityEnumMap, json['visibility']),
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
      'userId': instance.userId,
      'userName': instance.userName,
      'title': instance.title,
      'content': instance.content,
      'category': _$QuestionCategoryEnumMap[instance.category]!,
      'status': _$QuestionStatusEnumMap[instance.status]!,
      'visibility': _$QuestionVisibilityEnumMap[instance.visibility]!,
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

_$QuestionListResponseImpl _$$QuestionListResponseImplFromJson(
  Map<String, dynamic> json,
) => _$QuestionListResponseImpl(
  items: (json['items'] as List<dynamic>)
      .map((e) => QuestionModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  total: (json['total'] as num).toInt(),
  page: (json['page'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
);

Map<String, dynamic> _$$QuestionListResponseImplToJson(
  _$QuestionListResponseImpl instance,
) => <String, dynamic>{
  'items': instance.items,
  'total': instance.total,
  'page': instance.page,
  'limit': instance.limit,
};

_$QnaStatisticsImpl _$$QnaStatisticsImplFromJson(Map<String, dynamic> json) =>
    _$QnaStatisticsImpl(
      totalQuestions: (json['totalQuestions'] as num).toInt(),
      pendingCount: (json['pendingCount'] as num).toInt(),
      answeredCount: (json['answeredCount'] as num).toInt(),
      resolvedCount: (json['resolvedCount'] as num).toInt(),
      categoryStats: Map<String, int>.from(json['categoryStats'] as Map),
    );

Map<String, dynamic> _$$QnaStatisticsImplToJson(_$QnaStatisticsImpl instance) =>
    <String, dynamic>{
      'totalQuestions': instance.totalQuestions,
      'pendingCount': instance.pendingCount,
      'answeredCount': instance.answeredCount,
      'resolvedCount': instance.resolvedCount,
      'categoryStats': instance.categoryStats,
    };
