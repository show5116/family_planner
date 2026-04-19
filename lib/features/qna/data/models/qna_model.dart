import 'package:freezed_annotation/freezed_annotation.dart';

part 'qna_model.freezed.dart';
part 'qna_model.g.dart';

/// 질문 카테고리
enum QuestionCategory {
  @JsonValue('BUG')
  bug, // 버그 신고
  @JsonValue('FEATURE')
  feature, // 기능 제안/개선
  @JsonValue('USAGE')
  usage, // 사용법 문의
  @JsonValue('ACCOUNT')
  account, // 계정 문제
  @JsonValue('PAYMENT')
  payment, // 결제/요금제
  @JsonValue('ETC')
  etc, // 기타
}

/// 질문 상태
enum QuestionStatus {
  @JsonValue('PENDING')
  pending, // 대기 중 (답변 대기)
  @JsonValue('ANSWERED')
  answered, // 답변 완료
  @JsonValue('RESOLVED')
  resolved, // 해결 완료
}

/// 질문 공개 여부
enum QuestionVisibility {
  @JsonValue('PUBLIC')
  public, // 공개
  @JsonValue('PRIVATE')
  private, // 비공개
}

/// 첨부파일 모델 (공지사항과 동일)
@freezed
class Attachment with _$Attachment {
  const factory Attachment({
    required String url,
    required String name,
    required int size,
  }) = _Attachment;

  factory Attachment.fromJson(Map<String, dynamic> json) =>
      _$AttachmentFromJson(json);
}

/// 사용자 정보 모델 (작성자용)
@freezed
class QuestionUser with _$QuestionUser {
  const factory QuestionUser({
    required String id,
    required String name,
  }) = _QuestionUser;

  factory QuestionUser.fromJson(Map<String, dynamic> json) =>
      _$QuestionUserFromJson(json);
}

/// 답변 모델
@freezed
class AnswerModel with _$AnswerModel {
  const factory AnswerModel({
    required String id,
    required String content,
    String? adminId,
    QuestionUser? admin,
    List<Attachment>? attachments,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AnswerModel;

  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(
      id: json['id'] as String,
      content: json['content'] as String,
      adminId: json['adminId'] as String?,
      admin: json['admin'] != null
          ? QuestionUser.fromJson(json['admin'] as Map<String, dynamic>)
          : null,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => Attachment.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
      updatedAt: DateTime.parse(json['updatedAt'] as String).toLocal(),
    );
  }
}

/// 질문 상세 모델 (상세 조회, 작성, 수정, 해결시 사용)
@freezed
class QuestionModel with _$QuestionModel {
  const factory QuestionModel({
    required String id,
    required String title,
    required String content,
    @Default(QuestionCategory.etc) QuestionCategory category,
    @Default(QuestionStatus.pending) QuestionStatus status,
    @Default(QuestionVisibility.public) QuestionVisibility visibility,
    QuestionUser? user,
    List<Attachment>? attachments,
    @Default([]) List<AnswerModel> answers,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _QuestionModel;

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    QuestionCategory parseCategory(String? v) {
      switch (v) {
        case 'BUG': return QuestionCategory.bug;
        case 'FEATURE': return QuestionCategory.feature;
        case 'USAGE': return QuestionCategory.usage;
        case 'ACCOUNT': return QuestionCategory.account;
        case 'PAYMENT': return QuestionCategory.payment;
        default: return QuestionCategory.etc;
      }
    }

    QuestionStatus parseStatus(String? v) {
      switch (v) {
        case 'ANSWERED': return QuestionStatus.answered;
        case 'RESOLVED': return QuestionStatus.resolved;
        default: return QuestionStatus.pending;
      }
    }

    QuestionVisibility parseVisibility(String? v) {
      return v == 'PRIVATE' ? QuestionVisibility.private : QuestionVisibility.public;
    }

    return QuestionModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      category: parseCategory(json['category'] as String?),
      status: parseStatus(json['status'] as String?),
      visibility: parseVisibility(json['visibility'] as String?),
      user: json['user'] != null
          ? QuestionUser.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => Attachment.fromJson(e as Map<String, dynamic>))
          .toList(),
      answers: (json['answers'] as List<dynamic>? ?? [])
          .map((e) => AnswerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
      updatedAt: DateTime.parse(json['updatedAt'] as String).toLocal(),
    );
  }
}

/// 질문 목록 항목 모델 (목록 조회시 사용)
@freezed
class QuestionListItem with _$QuestionListItem {
  const factory QuestionListItem({
    required String id,
    required String title,
    String? content,
    QuestionCategory? category,
    QuestionStatus? status,
    QuestionVisibility? visibility,
    required int answerCount,
    QuestionUser? user,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _QuestionListItem;

  factory QuestionListItem.fromJson(Map<String, dynamic> json) {
    QuestionCategory? parseCategory(String? v) {
      switch (v) {
        case 'BUG': return QuestionCategory.bug;
        case 'FEATURE': return QuestionCategory.feature;
        case 'USAGE': return QuestionCategory.usage;
        case 'ACCOUNT': return QuestionCategory.account;
        case 'PAYMENT': return QuestionCategory.payment;
        case 'ETC': return QuestionCategory.etc;
        default: return null;
      }
    }

    QuestionStatus? parseStatus(String? v) {
      switch (v) {
        case 'PENDING': return QuestionStatus.pending;
        case 'ANSWERED': return QuestionStatus.answered;
        case 'RESOLVED': return QuestionStatus.resolved;
        default: return null;
      }
    }

    QuestionVisibility? parseVisibility(String? v) {
      switch (v) {
        case 'PUBLIC': return QuestionVisibility.public;
        case 'PRIVATE': return QuestionVisibility.private;
        default: return null;
      }
    }

    return QuestionListItem(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String?,
      category: parseCategory(json['category'] as String?),
      status: parseStatus(json['status'] as String?),
      visibility: parseVisibility(json['visibility'] as String?),
      answerCount: json['answerCount'] as int,
      user: json['user'] != null
          ? QuestionUser.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
      updatedAt: DateTime.parse(json['updatedAt'] as String).toLocal(),
    );
  }
}

/// 페이지네이션 메타 정보
@freezed
class PaginationMeta with _$PaginationMeta {
  const factory PaginationMeta({
    required int total,
    required int page,
    required int limit,
    required int totalPages,
  }) = _PaginationMeta;

  factory PaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$PaginationMetaFromJson(json);
}

/// 질문 목록 응답 모델
class QuestionListResponse {
  final List<QuestionListItem> data;
  final PaginationMeta meta;

  const QuestionListResponse({this.data = const [], required this.meta});

  factory QuestionListResponse.fromJson(Map<String, dynamic> json) {
    return QuestionListResponse(
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => QuestionListItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );
  }
}

/// QnA 통계 모델 (관리자용)
@freezed
class QnaStatistics with _$QnaStatistics {
  const factory QnaStatistics({
    required int totalQuestions,
    required int pendingCount,
    required int answeredCount,
    required Map<String, int> categoryStats,
  }) = _QnaStatistics;

  factory QnaStatistics.fromJson(Map<String, dynamic> json) =>
      _$QnaStatisticsFromJson(json);
}
