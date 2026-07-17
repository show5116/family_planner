/// 이모지 카테고리 (emoji_picker_flutter의 8개 카테고리 분류를 그대로 이관)
enum EmojiCategory {
  smileys,
  animals,
  foods,
  travel,
  activities,
  objects,
  symbols,
  flags,
}

/// 이모지 1개에 대한 문자 + 카테고리 + 4개 언어(ko/en/ja/zh) 이름/검색 키워드.
/// `tool/generate_emoji_data.dart`가 CLDR 데이터를 변환해 만드는
/// `emoji_dataset.dart`의 레코드 타입.
class EmojiEntry {
  final String char;
  final EmojiCategory category;
  final String nameKo;
  final String nameEn;
  final String nameJa;
  final String nameZh;
  final List<String> keywordsKo;
  final List<String> keywordsEn;
  final List<String> keywordsJa;
  final List<String> keywordsZh;

  const EmojiEntry({
    required this.char,
    required this.category,
    required this.nameKo,
    required this.nameEn,
    required this.nameJa,
    required this.nameZh,
    required this.keywordsKo,
    required this.keywordsEn,
    required this.keywordsJa,
    required this.keywordsZh,
  });

  /// languageCode(ko/en/ja/zh, 그 외는 en 폴백)에 해당하는 대표 이름
  String nameFor(String languageCode) => switch (languageCode) {
        'ko' => nameKo,
        'ja' => nameJa,
        'zh' => nameZh,
        _ => nameEn,
      };

  /// languageCode에 해당하는 검색 키워드 목록
  List<String> keywordsFor(String languageCode) => switch (languageCode) {
        'ko' => keywordsKo,
        'ja' => keywordsJa,
        'zh' => keywordsZh,
        _ => keywordsEn,
      };

  /// 주어진 검색어가 이 이모지의 이름/키워드(languageCode 기준)에 포함되는지
  bool matches(String query, String languageCode) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    if (nameFor(languageCode).toLowerCase().contains(q)) return true;
    return keywordsFor(languageCode)
        .any((k) => k.toLowerCase().contains(q));
  }
}
