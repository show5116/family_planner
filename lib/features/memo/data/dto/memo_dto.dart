import 'dart:convert';

/// checklistMeta 계산 유틸
Map<String, dynamic>? _calcChecklistMeta(String? deltaJson) {
  if (deltaJson == null || deltaJson.isEmpty) return null;
  try {
    final ops = jsonDecode(deltaJson) as List;
    int total = 0, checked = 0;
    for (final op in ops) {
      final list = ((op as Map)['attributes'] as Map?)?['list'] as String?;
      if (list == 'unchecked') total++;
      if (list == 'checked') { total++; checked++; }
    }
    if (total == 0) return null;
    return {'total': total, 'checked': checked};
  } catch (_) {
    return null;
  }
}

/// 메모 생성 DTO
class CreateMemoDto {
  final String title;
  final String? content;
  final String? format;
  final String? visibility;
  final String? groupId;
  final List<CreateMemoTagDto>? tags;

  CreateMemoDto({
    required this.title,
    this.content,
    this.format,
    this.visibility,
    this.groupId,
    this.tags,
  });

  Map<String, dynamic> toJson() {
    final meta = _calcChecklistMeta(content);
    return {
      'title': title,
      if (content != null && content!.isNotEmpty) 'content': content,
      if (format != null) 'format': format,
      if (visibility != null) 'visibility': visibility,
      if (groupId != null && groupId!.isNotEmpty) 'groupId': groupId,
      if (tags != null && tags!.isNotEmpty)
        'tags': tags!.map((e) => e.toJson()).toList(),
      if (meta != null) 'checklistMeta': meta,
    };
  }
}

/// 메모 수정 DTO
class UpdateMemoDto {
  final String? title;
  final String? content;
  final String? format;
  final String? visibility;
  final String? groupId;
  final List<CreateMemoTagDto>? tags;

  UpdateMemoDto({
    this.title,
    this.content,
    this.format,
    this.visibility,
    this.groupId,
    this.tags,
  });

  Map<String, dynamic> toJson() {
    final meta = _calcChecklistMeta(content);
    return {
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (format != null) 'format': format,
      if (visibility != null) 'visibility': visibility,
      if (groupId != null) 'groupId': groupId,
      if (tags != null) 'tags': tags!.map((e) => e.toJson()).toList(),
      if (meta != null) 'checklistMeta': meta,
    };
  }
}

/// 태그 생성 DTO
class CreateMemoTagDto {
  final String name;
  final String? color;

  CreateMemoTagDto({required this.name, this.color});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (color != null) 'color': color,
    };
  }
}
