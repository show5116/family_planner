// ignore_for_file: avoid_print
//
// 이모지 데이터셋 생성 스크립트 (1회성, 필요 시 재실행 가능).
//
// CLDR(Unicode Common Locale Data Repository) 공식 이모지 이름/키워드
// 데이터(ko/en/ja/zh)와, emoji_picker_flutter 패키지의 카테고리 분류
// 데이터를 병합해 lib/shared/widgets/emoji_data/emoji_dataset.dart에
// const List<EmojiEntry>를 정적으로 출력한다.
//
// 실행 전 준비물 (tool/emoji_data_cache/ 안에 위치):
//   - {lang}_annotations.json, {lang}_annotations_derived.json (lang: ko/en/ja/zh)
//     https://raw.githubusercontent.com/unicode-org/cldr-json/main/cldr-json/
//       cldr-annotations-full/annotations/{lang}/annotations.json
//       cldr-annotations-derived-full/annotationsDerived/{lang}/annotations.json
//   - emoji_set_en_source.dart
//     (emoji_picker_flutter pub cache의 lib/locales/emoji_set_en.dart 복사본,
//      카테고리 분류 소스로만 사용)
//
// 실행: dart run tool/generate_emoji_data.dart
import 'dart:convert';
import 'dart:io';

const _cacheDir = 'tool/emoji_data_cache';
const _outputDir = 'lib/shared/widgets/emoji_data';
const _langs = ['ko', 'en', 'ja', 'zh'];

/// VS16(variation selector) 등 표기 차이를 제거해 이모지 문자를 비교 가능하게 정규화
String _normalize(String s) => s.replaceAll('️', '');

void main() {
  final categoryMap = _parseCategorySource();
  print('카테고리 소스에서 ${categoryMap.length}개 이모지 파싱 완료');

  final langData = <String, Map<String, _NameKeywords>>{};
  for (final lang in _langs) {
    langData[lang] = _loadLangAnnotations(lang);
    print('[$lang] 이름/키워드 ${langData[lang]!.length}개 로드');
  }

  final entries = <_EmojiRecord>[];
  var missingCount = 0;
  categoryMap.forEach((char, category) {
    final norm = _normalize(char);
    final perLang = <String, _NameKeywords>{};
    for (final lang in _langs) {
      final data = langData[lang]!;
      final found = data[char] ?? data[norm];
      if (found == null) missingCount++;
      perLang[lang] = found ?? _NameKeywords(name: char, keywords: const []);
    }
    entries.add(_EmojiRecord(char: char, category: category, perLang: perLang));
  });

  print('총 ${entries.length}개 이모지, 언어별 매칭 실패 $missingCount건 '
      '(${_langs.length}개 언어 합산, 전체 대비 '
      '${(missingCount / (entries.length * _langs.length) * 100).toStringAsFixed(2)}%)');

  final buffer = StringBuffer();
  buffer.writeln('// GENERATED FILE - DO NOT EDIT BY HAND.');
  buffer.writeln('// tool/generate_emoji_data.dart 로 생성됨. 재생성: dart run tool/generate_emoji_data.dart');
  buffer.writeln();
  buffer.writeln("import 'emoji_entry.dart';");
  buffer.writeln();
  buffer.writeln('const List<EmojiEntry> emojiDataset = [');
  for (final e in entries) {
    buffer.writeln('  EmojiEntry(');
    buffer.writeln("    char: ${_dartString(e.char)},");
    buffer.writeln('    category: EmojiCategory.${e.category},');
    for (final lang in _langs) {
      final nk = e.perLang[lang]!;
      buffer.writeln("    name${_cap(lang)}: ${_dartString(nk.name)},");
      buffer.writeln(
          "    keywords${_cap(lang)}: [${nk.keywords.map(_dartString).join(', ')}],");
    }
    buffer.writeln('  ),');
  }
  buffer.writeln('];');

  final outFile = File('$_outputDir/emoji_dataset.dart');
  outFile.createSync(recursive: true);
  outFile.writeAsStringSync(buffer.toString());
  print('작성 완료: ${outFile.path} (${entries.length}개 항목)');
}

String _cap(String s) => s[0].toUpperCase() + s.substring(1);

String _dartString(String s) {
  final escaped = s
      .replaceAll(r'\', r'\\')
      .replaceAll("'", r"\'")
      .replaceAll('\$', r'\$')
      .replaceAll('\n', r'\n');
  return "'$escaped'";
}

class _NameKeywords {
  final String name;
  final List<String> keywords;
  _NameKeywords({required this.name, required this.keywords});
}

class _EmojiRecord {
  final String char;
  final String category;
  final Map<String, _NameKeywords> perLang;
  _EmojiRecord({required this.char, required this.category, required this.perLang});
}

/// emoji_set_en_source.dart(emoji_picker_flutter 패키지 소스)를 정규식으로 파싱해
/// "이모지 문자 → 카테고리(소문자)" 맵을 만든다.
Map<String, String> _parseCategorySource() {
  final file = File('$_cacheDir/emoji_set_en_source.dart');
  if (!file.existsSync()) {
    stderr.writeln(
        '오류: ${file.path} 가 없습니다. emoji_picker_flutter pub cache의 '
        'lib/locales/emoji_set_en.dart를 이 경로로 복사한 뒤 다시 실행하세요.');
    exit(1);
  }
  final src = file.readAsStringSync();

  final catRe = RegExp(r'CategoryEmoji\(Category\.([A-Z]+),');
  final emojiRe = RegExp(r"Emoji\(\s*'([^']+)',");

  final catMarkers = <MapEntry<int, String>>[];
  for (final m in catRe.allMatches(src)) {
    catMarkers.add(MapEntry(m.start, m.group(1)!.toLowerCase()));
  }

  final result = <String, String>{};
  for (final m in emojiRe.allMatches(src)) {
    final idx = m.start;
    var category = catMarkers.first.value;
    for (final marker in catMarkers) {
      if (marker.key <= idx) {
        category = marker.value;
      } else {
        break;
      }
    }
    final char = m.group(1)!.trim();
    if (char.isEmpty) continue;
    result[char] = category;
  }
  return result;
}

/// {lang}_annotations.json + {lang}_annotations_derived.json을 합쳐
/// "이모지 문자 → {name, keywords}" 맵을 만든다(원본 키 + VS16 제거 정규화 키 둘 다 색인).
Map<String, _NameKeywords> _loadLangAnnotations(String lang) {
  final result = <String, _NameKeywords>{};

  void ingest(String path, String annotationsKey) {
    final file = File(path);
    if (!file.existsSync()) {
      stderr.writeln('오류: $path 가 없습니다. CLDR 데이터를 먼저 다운로드하세요.');
      exit(1);
    }
    final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    final root = json[annotationsKey] as Map<String, dynamic>;
    final annotations = root['annotations'] as Map<String, dynamic>;
    annotations.forEach((char, value) {
      final map = value as Map<String, dynamic>;
      final tts = (map['tts'] as List<dynamic>?)?.cast<String>() ?? const [];
      final defaultList =
          (map['default'] as List<dynamic>?)?.cast<String>() ?? const [];
      final name = tts.isNotEmpty ? tts.first : (defaultList.isNotEmpty ? defaultList.first : char);
      final nk = _NameKeywords(name: name, keywords: defaultList);
      result[char] = nk;
      final norm = _normalize(char);
      result.putIfAbsent(norm, () => nk);
    });
  }

  ingest('$_cacheDir/${lang}_annotations.json', 'annotations');
  ingest('$_cacheDir/${lang}_annotations_derived.json', 'annotationsDerived');

  return result;
}
