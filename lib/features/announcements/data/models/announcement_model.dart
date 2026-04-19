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

/// 작성자 정보 모델
@freezed
class AnnouncementAuthor with _$AnnouncementAuthor {
  const factory AnnouncementAuthor({
    required String id,
    required String name,
  }) = _AnnouncementAuthor;

  factory AnnouncementAuthor.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementAuthorFromJson(json);
}

/// 공지사항 카테고리
enum AnnouncementCategory {
  announcement,
  event,
  update;
}

/// 공지사항 카테고리 JsonConverter (대소문자 무관)
class AnnouncementCategoryConverter
    implements JsonConverter<AnnouncementCategory?, String?> {
  const AnnouncementCategoryConverter();

  @override
  AnnouncementCategory? fromJson(String? json) {
    if (json == null) return null;

    // 대소문자 구분 없이 변환
    switch (json.toLowerCase()) {
      case 'announcement':
        return AnnouncementCategory.announcement;
      case 'event':
        return AnnouncementCategory.event;
      case 'update':
        return AnnouncementCategory.update;
      default:
        return null;
    }
  }

  @override
  String? toJson(AnnouncementCategory? category) {
    if (category == null) return null;

    // 항상 대문자로 전송 (백엔드 요구사항)
    switch (category) {
      case AnnouncementCategory.announcement:
        return 'ANNOUNCEMENT';
      case AnnouncementCategory.event:
        return 'EVENT';
      case AnnouncementCategory.update:
        return 'UPDATE';
    }
  }
}

/// 공지사항 모델
@freezed
class AnnouncementModel with _$AnnouncementModel {
  const factory AnnouncementModel({
    required String id,
    required String title,
    required String content,
    @AnnouncementCategoryConverter() AnnouncementCategory? category,
    @Default(false) bool isPinned,
    required AnnouncementAuthor author,
    @Default(false) bool isRead,
    @Default(0) int readCount,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AnnouncementModel;

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    AnnouncementCategory? parseCategory(String? v) {
      if (v == null) return null;
      switch (v.toLowerCase()) {
        case 'announcement': return AnnouncementCategory.announcement;
        case 'event': return AnnouncementCategory.event;
        case 'update': return AnnouncementCategory.update;
        default: return null;
      }
    }

    return AnnouncementModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      category: parseCategory(json['category'] as String?),
      isPinned: json['isPinned'] as bool? ?? false,
      author: AnnouncementAuthor.fromJson(json['author'] as Map<String, dynamic>),
      isRead: json['isRead'] as bool? ?? false,
      readCount: json['readCount'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
      updatedAt: DateTime.parse(json['updatedAt'] as String).toLocal(),
    );
  }
}

/// 공지사항 목록 응답 모델
class AnnouncementListResponse {
  final List<AnnouncementModel> items;
  final int total;
  final int page;
  final int limit;

  const AnnouncementListResponse({
    this.items = const [],
    this.total = 0,
    this.page = 1,
    this.limit = 20,
  });

  factory AnnouncementListResponse.fromJson(Map<String, dynamic> json) {
    return AnnouncementListResponse(
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => AnnouncementModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 20,
    );
  }
}
