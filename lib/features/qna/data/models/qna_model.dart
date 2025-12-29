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
  resolved, // 해결 완료 (사용자 확인)
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

/// 답변 모델
@freezed
class AnswerModel with _$AnswerModel {
  const factory AnswerModel({
    required String id,
    required String questionId,
    required String adminId,
    required String adminName,
    required String content,
    List<Attachment>? attachments,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AnswerModel;

  factory AnswerModel.fromJson(Map<String, dynamic> json) =>
      _$AnswerModelFromJson(json);
}

/// 질문 모델
@freezed
class QuestionModel with _$QuestionModel {
  const factory QuestionModel({
    required String id,
    required String userId,
    required String userName,
    required String title,
    required String content,
    required QuestionCategory category,
    required QuestionStatus status,
    required QuestionVisibility visibility,
    List<Attachment>? attachments,
    @Default([]) List<AnswerModel> answers,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _QuestionModel;

  factory QuestionModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionModelFromJson(json);
}

/// 질문 목록 응답 모델
@freezed
class QuestionListResponse with _$QuestionListResponse {
  const factory QuestionListResponse({
    required List<QuestionModel> items,
    required int total,
    required int page,
    required int limit,
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
    required int resolvedCount,
    required Map<String, int> categoryStats,
  }) = _QnaStatistics;

  factory QnaStatistics.fromJson(Map<String, dynamic> json) =>
      _$QnaStatisticsFromJson(json);
}
