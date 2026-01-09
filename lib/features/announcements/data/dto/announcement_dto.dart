import 'package:family_planner/features/announcements/data/models/announcement_model.dart';

/// 공지사항 작성/수정 DTO
class CreateAnnouncementDto {
  final String title;
  final String content;
  final AnnouncementCategory? category;
  final bool? isPinned;
  final List<AttachmentDto>? attachments;

  CreateAnnouncementDto({
    required this.title,
    required this.content,
    this.category,
    this.isPinned,
    this.attachments,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      if (category != null) 'category': _categoryToString(category!),
      if (isPinned != null) 'isPinned': isPinned,
      if (attachments != null)
        'attachments': attachments!.map((e) => e.toJson()).toList(),
    };
  }

  /// 카테고리 enum을 대문자 문자열로 변환 (백엔드 요구사항)
  String _categoryToString(AnnouncementCategory category) {
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

/// 첨부파일 DTO
class AttachmentDto {
  final String url;
  final String name;
  final int size;

  AttachmentDto({
    required this.url,
    required this.name,
    required this.size,
  });

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'name': name,
      'size': size,
    };
  }
}

/// 공지사항 고정/해제 DTO
class TogglePinDto {
  final bool isPinned;

  TogglePinDto({required this.isPinned});

  Map<String, dynamic> toJson() {
    return {
      'isPinned': isPinned,
    };
  }
}
