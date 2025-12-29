/// 공지사항 작성/수정 DTO
class CreateAnnouncementDto {
  final String title;
  final String content;
  final bool? isPinned;
  final List<AttachmentDto>? attachments;

  CreateAnnouncementDto({
    required this.title,
    required this.content,
    this.isPinned,
    this.attachments,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      if (isPinned != null) 'isPinned': isPinned,
      if (attachments != null)
        'attachments': attachments!.map((e) => e.toJson()).toList(),
    };
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
