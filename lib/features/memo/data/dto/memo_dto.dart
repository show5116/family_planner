/// 메모 생성 DTO
class CreateMemoDto {
  final String title;
  final String content;
  final String? type; // 'NOTE' | 'CHECKLIST'
  final String? category;
  final List<CreateMemoTagDto>? tags;

  CreateMemoDto({
    required this.title,
    required this.content,
    this.type,
    this.category,
    this.tags,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      if (type != null) 'type': type,
      if (category != null && category!.isNotEmpty) 'category': category,
      if (tags != null && tags!.isNotEmpty)
        'tags': tags!.map((e) => e.toJson()).toList(),
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
  final String? category;
  final List<CreateMemoTagDto>? tags;

  UpdateMemoDto({
    this.title,
    this.content,
    this.category,
    this.tags,
  });

  Map<String, dynamic> toJson() {
    return {
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (category != null) 'category': category,
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
