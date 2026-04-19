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

/// 메모 타입
enum MemoType {
  @JsonValue('NOTE')
  note,
  @JsonValue('CHECKLIST')
  checklist;
}

/// 체크리스트 항목 모델
@freezed
class ChecklistItem with _$ChecklistItem {
  const factory ChecklistItem({
    required String id,
    required String content,
    required bool isChecked,
    required int order,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ChecklistItem;

  factory ChecklistItem.fromJson(Map<String, dynamic> json) {
    return ChecklistItem(
      id: json['id'] as String,
      content: json['content'] as String,
      isChecked: json['isChecked'] as bool,
      order: json['order'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
      updatedAt: DateTime.parse(json['updatedAt'] as String).toLocal(),
    );
  }
}

/// 메모 공개 범위
enum MemoVisibility {
  @JsonValue('PRIVATE')
  private_,
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

  factory MemoAttachment.fromJson(Map<String, dynamic> json) {
    return MemoAttachment(
      id: json['id'] as String,
      fileName: json['fileName'] as String,
      fileUrl: json['fileUrl'] as String,
      fileSize: json['fileSize'] as int,
      mimeType: json['mimeType'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
    );
  }
}

/// 메모 모델
@freezed
class MemoModel with _$MemoModel {
  const factory MemoModel({
    required String id,
    required String title,
    @Default('') String content,
    MemoFormat? format,
    MemoType? type,
    MemoVisibility? visibility,
    @Default(false) bool isPinned,
    String? groupId,
    required MemoAuthor user,
    @Default([]) List<MemoTag> tags,
    @Default([]) List<MemoAttachment> attachments,
    @Default([]) List<ChecklistItem> checklistItems,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _MemoModel;

  factory MemoModel.fromJson(Map<String, dynamic> json) {
    MemoFormat? parseFormat(dynamic v) {
      switch (v as String?) {
        case 'TEXT': return MemoFormat.text;
        case 'MARKDOWN': return MemoFormat.markdown;
        case 'HTML': return MemoFormat.html;
        default: return null;
      }
    }

    MemoType? parseType(dynamic v) {
      switch (v as String?) {
        case 'NOTE': return MemoType.note;
        case 'CHECKLIST': return MemoType.checklist;
        default: return null;
      }
    }

    MemoVisibility? parseVisibility(dynamic v) {
      switch (v as String?) {
        case 'PRIVATE': return MemoVisibility.private_;
        case 'GROUP': return MemoVisibility.group;
        default: return null;
      }
    }

    return MemoModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String? ?? '',
      format: parseFormat(json['format']),
      type: parseType(json['type']),
      visibility: parseVisibility(json['visibility']),
      isPinned: json['isPinned'] as bool? ?? false,
      groupId: json['groupId'] as String?,
      user: MemoAuthor.fromJson(json['user'] as Map<String, dynamic>),
      tags: (json['tags'] as List<dynamic>? ?? [])
          .map((e) => MemoTag.fromJson(e as Map<String, dynamic>))
          .toList(),
      attachments: (json['attachments'] as List<dynamic>? ?? [])
          .map((e) => MemoAttachment.fromJson(e as Map<String, dynamic>))
          .toList(),
      checklistItems: (json['checklistItems'] as List<dynamic>? ?? [])
          .map((e) => ChecklistItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
      updatedAt: DateTime.parse(json['updatedAt'] as String).toLocal(),
    );
  }
}

/// 메모 목록 응답 모델
class MemoListResponse {
  final List<MemoModel> items;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const MemoListResponse({
    this.items = const [],
    this.total = 0,
    this.page = 1,
    this.limit = 20,
    this.totalPages = 0,
  });

  factory MemoListResponse.fromJson(Map<String, dynamic> json) {
    return MemoListResponse(
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => MemoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 20,
      totalPages: json['totalPages'] as int? ?? 0,
    );
  }
}
