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
    required String adminId,
    required QuestionUser admin,
    List<Attachment>? attachments,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AnswerModel;

  factory AnswerModel.fromJson(Map<String, dynamic> json) =>
      _$AnswerModelFromJson(json);
}

/// 질문 상세 모델 (상세 조회, 작성, 수정, 해결시 사용)
@freezed
class QuestionModel with _$QuestionModel {
  const factory QuestionModel({
    required String id,
    required String title,
    required String content,
    required QuestionCategory category,
    required QuestionStatus status,
    required QuestionVisibility visibility,
    QuestionUser? user,
    List<Attachment>? attachments,
    @Default([]) List<AnswerModel> answers,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _QuestionModel;

  factory QuestionModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionModelFromJson(json);
}

/// 질문 목록 항목 모델 (목록 조회시 사용)
@freezed
class QuestionListItem with _$QuestionListItem {
  const factory QuestionListItem({
    required String id,
    required String title,
    required String content,
    required QuestionCategory category,
    required QuestionStatus status,
    required QuestionVisibility visibility,
    required int answerCount,
    QuestionUser? user,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _QuestionListItem;

  factory QuestionListItem.fromJson(Map<String, dynamic> json) =>
      _$QuestionListItemFromJson(json);
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
@freezed
class QuestionListResponse with _$QuestionListResponse {
  const factory QuestionListResponse({
    required List<QuestionListItem> data,
    required PaginationMeta meta,
  }) = _QuestionListResponse;

  factory QuestionListResponse.fromJson(Map<String, dynamic> json) =>
      _$QuestionListResponseFromJson(json);
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
