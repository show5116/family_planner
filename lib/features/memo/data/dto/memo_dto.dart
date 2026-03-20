/// 메모 생성 DTO
class CreateMemoDto {
  final String title;
  final String? content;
  final String? type;       // 'NOTE' | 'CHECKLIST'
  final String? visibility; // 'PRIVATE' | 'GROUP'
  final String? groupId;    // visibility=GROUP 일 때 필수
  final List<CreateMemoTagDto>? tags;
  final List<CreateChecklistItemDto>? checklistItems;

  CreateMemoDto({
    required this.title,
    this.content,
    this.type,
    this.visibility,
    this.groupId,
    this.tags,
    this.checklistItems,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      if (content != null && content!.isNotEmpty) 'content': content,
      if (type != null) 'type': type,
      if (visibility != null) 'visibility': visibility,
      if (groupId != null && groupId!.isNotEmpty) 'groupId': groupId,
      if (tags != null && tags!.isNotEmpty)
        'tags': tags!.map((e) => e.toJson()).toList(),
      if (checklistItems != null && checklistItems!.isNotEmpty)
        'checklistItems': checklistItems!.map((e) => e.toJson()).toList(),
    };
  }
}

/// 체크리스트 항목 생성 DTO
class CreateChecklistItemDto {
  final String content;
  final int? order;

  CreateChecklistItemDto({required this.content, this.order});

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      if (order != null) 'order': order,
    };
  }
}

/// 체크리스트 항목 수정 DTO
class UpdateChecklistItemDto {
  final String? content;
  final int? order;

  UpdateChecklistItemDto({this.content, this.order});

  Map<String, dynamic> toJson() {
    return {
      if (content != null) 'content': content,
      if (order != null) 'order': order,
    };
  }
}

/// 메모 수정 DTO
class UpdateMemoDto {
  final String? title;
  final String? content;
  final String? visibility; // 'PRIVATE' | 'GROUP'
  final String? groupId;
  final List<CreateMemoTagDto>? tags;

  UpdateMemoDto({
    this.title,
    this.content,
    this.visibility,
    this.groupId,
    this.tags,
  });

  Map<String, dynamic> toJson() {
    return {
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (visibility != null) 'visibility': visibility,
      if (groupId != null) 'groupId': groupId,
      if (tags != null) 'tags': tags!.map((e) => e.toJson()).toList(),
    };
  }
}

/// 태그 생성 DTO
class CreateMemoTagDto {
  final String name;
  final String? color;

  CreateMemoTagDto({
    required this.name,
    this.color,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (color != null) 'color': color,
    };
  }
}
