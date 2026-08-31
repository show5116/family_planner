import 'package:flutter_test/flutter_test.dart';

import 'package:family_planner/shared/widgets/editor/utils/markdown_to_delta.dart';

void main() {
  group('looksLikeMarkdown', () {
    test('헤딩/리스트/굵게/링크를 감지한다', () {
      expect(looksLikeMarkdown('## 주요 변경사항'), isTrue);
      expect(looksLikeMarkdown('- 목록 항목'), isTrue);
      expect(looksLikeMarkdown('1. 첫 번째'), isTrue);
      expect(looksLikeMarkdown('> 인용문'), isTrue);
      expect(looksLikeMarkdown('**굵게**'), isTrue);
      expect(looksLikeMarkdown('[링크](https://example.com)'), isTrue);
    });

    test('일반 텍스트는 감지하지 않는다', () {
      expect(looksLikeMarkdown('안녕하세요. 공지사항입니다.'), isFalse);
      expect(looksLikeMarkdown(''), isFalse);
      expect(looksLikeMarkdown('   '), isFalse);
    });
  });

  group('markdownToDelta', () {
    test('빈 문자열은 null을 반환한다', () {
      expect(markdownToDelta(''), isNull);
      expect(markdownToDelta('   '), isNull);
    });

    test('릴리즈 노트 형식의 마크다운을 변환한다', () {
      const source = '''
## 주요 변경사항

### ✨ 새로운 기능

**루틴(습관 관리)** — 이번 버전의 핵심 신규 기능
- **루틴/습관 관리**: 여러 습관을 하나의 "루틴"으로 묶어 관리합니다.
- **일일 목표**: "하루에 N개 달성"을 목표로 설정합니다.

### 🐛 버그 수정
1. 날씨 위치 권한 처리 개선
2. [문서](https://example.com) 링크 수정
''';

      final delta = markdownToDelta(source);
      expect(delta, isNotNull);

      final json = delta!.toJson();
      final plain = json
          .map((op) => op['insert'])
          .whereType<String>()
          .join();

      // 본문 텍스트가 보존되었는지
      expect(plain, contains('주요 변경사항'));
      expect(plain, contains('루틴/습관 관리'));
      expect(plain, contains('날씨 위치 권한 처리 개선'));

      // 마크다운 기호가 그대로 남아있지 않은지
      expect(plain, isNot(contains('## ')));
      expect(plain, isNot(contains('**')));

      // 서식 속성이 실제로 적용되었는지
      final attrs = json
          .map((op) => op['attributes'])
          .whereType<Map<String, dynamic>>()
          .toList();
      expect(attrs.any((a) => a.containsKey('header')), isTrue,
          reason: '헤딩 서식이 적용되어야 함');
      expect(attrs.any((a) => a.containsKey('bold')), isTrue,
          reason: '굵게 서식이 적용되어야 함');
      expect(attrs.any((a) => a['list'] == 'bullet'), isTrue,
          reason: '글머리 기호 목록이 적용되어야 함');
      expect(attrs.any((a) => a['list'] == 'ordered'), isTrue,
          reason: '번호 목록이 적용되어야 함');
      expect(attrs.any((a) => a.containsKey('link')), isTrue,
          reason: '링크 서식이 적용되어야 함');
    });
  });
}
