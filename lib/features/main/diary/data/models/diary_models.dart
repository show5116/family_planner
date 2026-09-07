/// 다이어리 모델
///
/// 서버는 `date`를 'YYYY-MM-DD' **문자열**로 주고받는다.
/// DateTime으로 파싱하면 기기 타임존에 따라 하루가 밀리므로,
/// 모델에서도 문자열 그대로 보관하고 표시할 때만 변환한다.
library;

/// 일기 저장 포맷
///
/// 값은 서버가 받는 문자열과 같아야 한다 (DELTA · PLAIN · MARKDOWN).
enum DiaryFormat {
  delta,
  plain,
  markdown;

  static DiaryFormat fromJson(String? value) {
    switch (value) {
      case 'PLAIN':
        return DiaryFormat.plain;
      case 'MARKDOWN':
        return DiaryFormat.markdown;
      default:
        return DiaryFormat.delta;
    }
  }

  String toJson() => switch (this) {
        DiaryFormat.delta => 'DELTA',
        DiaryFormat.plain => 'PLAIN',
        DiaryFormat.markdown => 'MARKDOWN',
      };
}

/// 일기 공개 범위
enum DiaryVisibility {
  private,
  group;

  static DiaryVisibility fromJson(String? value) =>
      value == 'GROUP' ? DiaryVisibility.group : DiaryVisibility.private;

  String toJson() => this == DiaryVisibility.group ? 'GROUP' : 'PRIVATE';

  bool get isShared => this == DiaryVisibility.group;
}

/// 일기 작성자 정보
class DiaryAuthor {
  final String id;
  final String name;

  const DiaryAuthor({required this.id, required this.name});

  factory DiaryAuthor.fromJson(Map<String, dynamic> json) {
    return DiaryAuthor(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }
}

/// 일기 모델
class DiaryModel {
  final String id;

  /// 'YYYY-MM-DD' — 파싱하지 않고 문자열 그대로 보관한다
  final String date;
  final String? title;

  /// format=DELTA면 Quill Delta JSON 문자열
  final String content;
  final String? plainText;
  final DiaryFormat format;
  final DiaryVisibility visibility;
  final String? mood;
  final String? weather;
  final String? groupId;
  final DiaryAuthor? user;

  /// Phase 1에서는 항상 false (Phase 2에서 미디어 첨부 시 사용)
  final bool hasMedia;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DiaryModel({
    required this.id,
    required this.date,
    this.title,
    required this.content,
    this.plainText,
    this.format = DiaryFormat.delta,
    this.visibility = DiaryVisibility.private,
    this.mood,
    this.weather,
    this.groupId,
    this.user,
    this.hasMedia = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DiaryModel.fromJson(Map<String, dynamic> json) {
    return DiaryModel(
      id: json['id'] as String,
      date: json['date'] as String,
      title: json['title'] as String?,
      content: json['content'] as String? ?? '',
      plainText: json['plainText'] as String?,
      format: DiaryFormat.fromJson(json['format'] as String?),
      visibility: DiaryVisibility.fromJson(json['visibility'] as String?),
      mood: json['mood'] as String?,
      weather: json['weather'] as String?,
      groupId: json['groupId'] as String?,
      user: json['user'] != null
          ? DiaryAuthor.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      hasMedia: json['hasMedia'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
      updatedAt: DateTime.parse(json['updatedAt'] as String).toLocal(),
    );
  }

  DiaryModel copyWith({
    String? title,
    String? content,
    String? plainText,
    DiaryFormat? format,
    DiaryVisibility? visibility,
    String? mood,
    String? weather,
    String? groupId,
    bool clearGroupId = false,
    bool? hasMedia,
    DateTime? updatedAt,
  }) {
    return DiaryModel(
      id: id,
      date: date,
      title: title ?? this.title,
      content: content ?? this.content,
      plainText: plainText ?? this.plainText,
      format: format ?? this.format,
      visibility: visibility ?? this.visibility,
      mood: mood ?? this.mood,
      weather: weather ?? this.weather,
      groupId: clearGroupId ? null : (groupId ?? this.groupId),
      user: user,
      hasMedia: hasMedia ?? this.hasMedia,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// 일기 목록 조회 결과 (페이지네이션 포함)
class DiaryListResult {
  final List<DiaryModel> items;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const DiaryListResult({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  bool get hasMore => page < totalPages;

  factory DiaryListResult.fromJson(Map<String, dynamic> json) {
    final meta = json['meta'] as Map<String, dynamic>? ?? const {};
    return DiaryListResult(
      items: (json['data'] as List<dynamic>? ?? [])
          .map((e) => DiaryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: meta['total'] as int? ?? 0,
      page: meta['page'] as int? ?? 1,
      limit: meta['limit'] as int? ?? 20,
      totalPages: meta['totalPages'] as int? ?? 1,
    );
  }

  static const empty = DiaryListResult(
    items: [],
    total: 0,
    page: 1,
    limit: 20,
    totalPages: 1,
  );
}

/// 빠른 기록으로 추가된 조각
class AppendedFragment {
  final String text;
  final String? capturedAt;

  const AppendedFragment({required this.text, this.capturedAt});

  factory AppendedFragment.fromJson(Map<String, dynamic> json) {
    return AppendedFragment(
      text: json['text'] as String? ?? '',
      capturedAt: json['capturedAt'] as String?,
    );
  }
}

/// 빠른 기록 결과
///
/// [created]가 true면 이 요청으로 일기가 새로 만들어진 것이다.
/// 목록에 카드를 새로 추가할지, 기존 카드를 갱신할지 판단하는 데 쓴다.
class AppendResult {
  final String id;
  final String date;
  final bool created;
  final AppendedFragment appended;
  final DateTime updatedAt;

  const AppendResult({
    required this.id,
    required this.date,
    required this.created,
    required this.appended,
    required this.updatedAt,
  });

  factory AppendResult.fromJson(Map<String, dynamic> json) {
    return AppendResult(
      id: json['id'] as String,
      date: json['date'] as String,
      created: json['created'] as bool? ?? false,
      appended: AppendedFragment.fromJson(
        json['appended'] as Map<String, dynamic>? ?? const {},
      ),
      updatedAt: DateTime.parse(json['updatedAt'] as String).toLocal(),
    );
  }
}

/// 캘린더 한 칸 (그룹 조회 시 같은 날짜가 여러 건일 수 있다)
class DiaryCalendarDay {
  final String date;
  final String diaryId;
  final String userId;
  final String authorName;
  final String? mood;
  final bool hasMedia;

  const DiaryCalendarDay({
    required this.date,
    required this.diaryId,
    required this.userId,
    required this.authorName,
    this.mood,
    this.hasMedia = false,
  });

  factory DiaryCalendarDay.fromJson(Map<String, dynamic> json) {
    return DiaryCalendarDay(
      date: json['date'] as String,
      diaryId: json['diaryId'] as String,
      userId: json['userId'] as String? ?? '',
      authorName: json['authorName'] as String? ?? '',
      mood: json['mood'] as String?,
      hasMedia: json['hasMedia'] as bool? ?? false,
    );
  }
}

/// 연속 작성 현황
class DiaryStreak {
  final int currentStreak;
  final int thisMonthCount;
  final int longestStreak;

  const DiaryStreak({
    this.currentStreak = 0,
    this.thisMonthCount = 0,
    this.longestStreak = 0,
  });

  factory DiaryStreak.fromJson(Map<String, dynamic> json) {
    return DiaryStreak(
      currentStreak: json['currentStreak'] as int? ?? 0,
      thisMonthCount: json['thisMonthCount'] as int? ?? 0,
      longestStreak: json['longestStreak'] as int? ?? 0,
    );
  }
}

/// 회고 항목 ("n개월 전 오늘")
class DiaryFlashbackItem {
  final String id;
  final String date;

  /// 서버가 만들어 내려주는 라벨 ("1년 전 오늘" 등)
  final String label;
  final String? title;
  final String? excerpt;
  final String? mood;

  const DiaryFlashbackItem({
    required this.id,
    required this.date,
    required this.label,
    this.title,
    this.excerpt,
    this.mood,
  });

  factory DiaryFlashbackItem.fromJson(Map<String, dynamic> json) {
    return DiaryFlashbackItem(
      id: json['id'] as String,
      date: json['date'] as String,
      label: json['label'] as String? ?? '',
      title: json['title'] as String?,
      excerpt: json['excerpt'] as String?,
      mood: json['mood'] as String?,
    );
  }
}

// ── 요청 DTO ─────────────────────────────────────────────────────────────────

/// 일기 생성 요청
class CreateDiaryDto {
  final String? date;
  final String? title;
  final String? content;
  final DiaryFormat? format;
  final DiaryVisibility? visibility;
  final String? groupId;
  final String? mood;
  final String? weather;

  const CreateDiaryDto({
    this.date,
    this.title,
    this.content,
    this.format,
    this.visibility,
    this.groupId,
    this.mood,
    this.weather,
  });

  Map<String, dynamic> toJson() => {
        if (date != null) 'date': date,
        if (title != null) 'title': title,
        if (content != null) 'content': content,
        if (format != null) 'format': format!.toJson(),
        if (visibility != null) 'visibility': visibility!.toJson(),
        if (groupId != null) 'groupId': groupId,
        if (mood != null) 'mood': mood,
        if (weather != null) 'weather': weather,
      };
}

/// 일기 수정 요청
///
/// 필드를 비우려면 `clearXxx`를 쓴다 (null과 "변경 없음"을 구분하기 위함).
class UpdateDiaryDto {
  final String? title;
  final String? content;
  final DiaryFormat? format;
  final DiaryVisibility? visibility;
  final String? groupId;
  final String? mood;
  final String? weather;
  final bool clearTitle;
  final bool clearMood;
  final bool clearWeather;

  const UpdateDiaryDto({
    this.title,
    this.content,
    this.format,
    this.visibility,
    this.groupId,
    this.mood,
    this.weather,
    this.clearTitle = false,
    this.clearMood = false,
    this.clearWeather = false,
  });

  Map<String, dynamic> toJson() => {
        if (clearTitle) 'title': null else if (title != null) 'title': title,
        if (content != null) 'content': content,
        if (format != null) 'format': format!.toJson(),
        if (visibility != null) 'visibility': visibility!.toJson(),
        if (groupId != null) 'groupId': groupId,
        if (clearMood) 'mood': null else if (mood != null) 'mood': mood,
        if (clearWeather)
          'weather': null
        else if (weather != null)
          'weather': weather,
      };
}

/// 빠른 기록 요청
///
/// [visibility]와 [groupId]는 **일기가 새로 생성될 때만** 적용된다.
/// 이미 그날 일기가 있으면 서버가 기존 공개 범위를 유지한다.
class AppendDiaryDto {
  final String? date;
  final String text;
  final String? capturedAt;
  final DiaryVisibility? visibility;
  final String? groupId;

  const AppendDiaryDto({
    this.date,
    required this.text,
    this.capturedAt,
    this.visibility,
    this.groupId,
  });

  Map<String, dynamic> toJson() => {
        if (date != null) 'date': date,
        'text': text,
        if (capturedAt != null) 'capturedAt': capturedAt,
        if (visibility != null) 'visibility': visibility!.toJson(),
        if (groupId != null) 'groupId': groupId,
      };
}
