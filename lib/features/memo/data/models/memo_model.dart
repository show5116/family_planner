import 'package:freezed_annotation/freezed_annotation.dart';

part 'memo_model.freezed.dart';
part 'memo_model.g.dart';

/// 메모 형식
enum MemoFormat {
  @JsonValue('TEXT')
  text,
  @JsonValue('MARKDOWN')
  markdown,
  @JsonValue('HTML')
  html;
}

/// 메모 공개 범위
enum MemoVisibility {
  @JsonValue('PRIVATE')
  private_,
  @JsonValue('FAMILY')
  family,
  @JsonValue('GROUP')
  group;
}

/// 메모 작성자 정보
@freezed
class MemoAuthor with _$MemoAuthor {
  const factory MemoAuthor({
    required String id,
    required String name,
  }) = _MemoAuthor;

  factory MemoAuthor.fromJson(Map<String, dynamic> json) =>
      _$MemoAuthorFromJson(json);
}

/// 메모 태그 모델
@freezed
class MemoTag with _$MemoTag {
  const factory MemoTag({
    required String id,
    required String name,
    String? color,
  }) = _MemoTag;

  factory MemoTag.fromJson(Map<String, dynamic> json) =>
      _$MemoTagFromJson(json);
}

/// 메모 첨부파일 모델
@freezed
class MemoAttachment with _$MemoAttachment {
  const factory MemoAttachment({
    required String id,
    required String fileName,
    required String fileUrl,
    required int fileSize,
    required String mimeType,
    required DateTime createdAt,
  }) = _MemoAttachment;

  factory MemoAttachment.fromJson(Map<String, dynamic> json) =>
      _$MemoAttachmentFromJson(json);
}

/// 메모 모델
@freezed
class MemoModel with _$MemoModel {
  const factory MemoModel({
    required String id,
    required String title,
    @Default('') String content,
    MemoFormat? format,
    String? category,
    MemoVisibility? visibility,
    String? groupId,
    required MemoAuthor user,
    @Default([]) List<MemoTag> tags,
    @Default([]) List<MemoAttachment> attachments,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _MemoModel;

  factory MemoModel.fromJson(Map<String, dynamic> json) =>
      _$MemoModelFromJson(json);
}

/// 메모 목록 응답 모델
@freezed
class MemoListResponse with _$MemoListResponse {
  const factory MemoListResponse({
    @Default([]) List<MemoModel> items,
    @Default(0) int total,
    @Default(1) int page,
    @Default(20) int limit,
    @Default(0) int totalPages,
  }) = _MemoListResponse;

  factory MemoListResponse.fromJson(Map<String, dynamic> json) =>
      _$MemoListResponseFromJson(json);
}
