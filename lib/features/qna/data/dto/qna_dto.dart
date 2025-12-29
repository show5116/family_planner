import 'package:family_planner/features/qna/data/models/qna_model.dart';

/// 질문 작성/수정 DTO
class CreateQuestionDto {
  final String title;
  final String content;
  final QuestionCategory category;
  final QuestionVisibility? visibility;
  final List<AttachmentDto>? attachments;

  CreateQuestionDto({
    required this.title,
    required this.content,
    required this.category,
    this.visibility,
    this.attachments,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'category': category.name.toUpperCase(),
      if (visibility != null) 'visibility': visibility!.name.toUpperCase(),
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

/// 답변 작성 DTO (관리자용)
class CreateAnswerDto {
  final String content;
  final List<AttachmentDto>? attachments;

  CreateAnswerDto({
    required this.content,
    this.attachments,
  });

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      if (attachments != null)
        'attachments': attachments!.map((e) => e.toJson()).toList(),
    };
  }
}
