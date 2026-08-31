import 'package:dart_quill_delta/dart_quill_delta.dart';
import 'package:flutter_quill_delta_from_html/flutter_quill_delta_from_html.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

import 'package:family_planner/core/utils/html_sanitizer.dart';

String toHtml(Delta delta) => QuillDeltaToHtmlConverter(
      delta.toJson(),
      ConverterOptions(
        converterOptions: OpConverterOptions(inlineStylesFlag: true),
      ),
    ).convert();

void main() {
  test('색상/배경색/폰트크기 → HTML → 새니타이즈 → Delta 라운드트립', () {
    final delta = Delta()
      ..insert('빨강', {'color': '#ff0000'})
      ..insert('노랑배경', {'background': '#ffff00'})
      ..insert('큰글씨', {'size': 'large'})
      ..insert('huge글씨', {'size': 'huge'})
      ..insert('\n');

    final html = toHtml(delta);

    final sanitized = HtmlSanitizer.sanitize(html);

    // 새니타이저가 색상/크기를 살려두는지
    expect(sanitized, contains('color'));
    expect(sanitized.toLowerCase(), contains('ff0000'));
    expect(sanitized, contains('font-size'));

    // 다시 Delta로 (수정 모드 진입 시나리오)
    final back = HtmlToDelta().convert(sanitized);
    final attrs = back
        .toJson()
        .map((op) => op['attributes'])
        .whereType<Map<String, dynamic>>()
        .toList();

    expect(attrs.any((a) => a.containsKey('color')), isTrue,
        reason: '수정 모드에서 색상이 복원되어야 함');
    expect(attrs.any((a) => a.containsKey('size')), isTrue,
        reason: '수정 모드에서 폰트 크기가 복원되어야 함');
  });
}
