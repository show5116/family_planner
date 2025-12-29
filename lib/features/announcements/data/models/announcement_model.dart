import 'package:freezed_annotation/freezed_annotation.dart';

part 'announcement_model.freezed.dart';
part 'announcement_model.g.dart';

/// 첨부파일 모델
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

/// 공지사항 모델
@freezed
class AnnouncementModel with _$AnnouncementModel {
  const factory AnnouncementModel({
    required String id,
    required String authorId,
    required String authorName,
    required String title,
    required String content,
    @Default(false) bool isPinned,
    List<Attachment>? attachments,
    @Default(false) bool isRead,
    @Default(0) int readCount,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AnnouncementModel;

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementModelFromJson(json);
}

/// 공지사항 목록 응답 모델
@freezed
class AnnouncementListResponse with _$AnnouncementListResponse {
  const factory AnnouncementListResponse({
    required List<AnnouncementModel> items,
    required int total,
    required int page,
    required int limit,
  }) = _AnnouncementListResponse;

  factory AnnouncementListResponse.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementListResponseFromJson(json);
}
