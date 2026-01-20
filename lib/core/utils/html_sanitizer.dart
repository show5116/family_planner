/// HTML 새니타이저 유틸리티
///
/// XSS 공격을 방지하기 위한 HTML 콘텐츠 정제 기능 제공
library;

/// 허용된 HTML 태그 목록
const _allowedTags = {
  'p',
  'br',
  'strong',
  'b',
  'em',
  'i',
  'u',
  's',
  'strike',
  'del',
  'h1',
  'h2',
  'h3',
  'h4',
  'h5',
  'h6',
  'ul',
  'ol',
  'li',
  'blockquote',
  'a',
  'code',
  'pre',
  'hr',
  'div',
  'span',
  'img',
};

/// 허용된 HTML 속성 목록 (태그별)
const _allowedAttributes = {
  'a': {'href', 'title', 'target', 'rel'},
  'div': {'class', 'style'},
  'span': {'class', 'style'},
  'p': {'class', 'style'},
  'h1': {'class', 'style'},
  'h2': {'class', 'style'},
  'h3': {'class', 'style'},
  'h4': {'class', 'style'},
  'h5': {'class', 'style'},
  'h6': {'class', 'style'},
  'img': {'src', 'alt', 'width', 'height'},
};

/// 허용된 CSS 속성 목록
const _allowedStyleProperties = {
  'color',
  'background-color',
  'font-size',
  'font-weight',
  'font-style',
  'text-decoration',
  'text-align',
  'margin',
  'padding',
  'border',
  'border-radius',
};

/// 허용된 프로토콜 목록
const _allowedProtocols = {
  'http',
  'https',
  'mailto',
};

/// HTML 새니타이저 클래스
class HtmlSanitizer {
  /// HTML 콘텐츠를 새니타이징 (위험한 요소 제거)
  ///
  /// [html] 새니타이징할 HTML 문자열
  /// [allowedTags] 허용할 태그 목록 (null인 경우 기본 목록 사용)
  /// [allowedAttributes] 허용할 속성 목록 (null인 경우 기본 목록 사용)
  /// Returns: 새니타이징된 HTML 문자열
  static String sanitize(
    String html, {
    Set<String>? allowedTags,
    Map<String, Set<String>>? allowedAttributes,
  }) {
    if (html.isEmpty) return html;

    final tags = allowedTags ?? _allowedTags;
    final attrs = allowedAttributes ?? _allowedAttributes;

    // 1. 스크립트 태그 완전 제거
    html = _removeScriptTags(html);

    // 2. 이벤트 핸들러 속성 제거 (on* 속성)
    html = _removeEventHandlers(html);

    // 3. 위험한 프로토콜 제거
    html = _sanitizeLinks(html);

    // 4. 허용되지 않은 태그 제거
    html = _removeDisallowedTags(html, tags);

    // 5. 허용되지 않은 속성 제거
    html = _removeDisallowedAttributes(html, attrs);

    // 6. 스타일 속성 새니타이징
    html = _sanitizeStyles(html);

    // 7. HTML 엔티티 디코딩 방지 (이중 인코딩 방지)
    html = _preventDoubleEncoding(html);

    return html;
  }

  /// 스크립트 태그 제거
  static String _removeScriptTags(String html) {
    // <script> 태그와 내용 제거
    html = html.replaceAll(
      RegExp(r'<script[^>]*>.*?</script>', caseSensitive: false),
      '',
    );

    // <iframe> 태그 제거
    html = html.replaceAll(
      RegExp(r'<iframe[^>]*>.*?</iframe>', caseSensitive: false),
      '',
    );

    // <object> 태그 제거
    html = html.replaceAll(
      RegExp(r'<object[^>]*>.*?</object>', caseSensitive: false),
      '',
    );

    // <embed> 태그 제거
    html = html.replaceAll(
      RegExp(r'<embed[^>]*>', caseSensitive: false),
      '',
    );

    return html;
  }

  /// 이벤트 핸들러 속성 제거
  static String _removeEventHandlers(String html) {
    // on* 이벤트 핸들러 제거 (onclick, onload, onerror 등)
    html = html.replaceAll(
      RegExp(r'''\s*on\w+\s*=\s*["']?[^"'>\s]*["']?''', caseSensitive: false),
      '',
    );

    return html;
  }

  /// 링크 새니타이징
  static String _sanitizeLinks(String html) {
    // javascript: 프로토콜 제거
    html = html.replaceAll(
      RegExp(r'''href\s*=\s*["']?\s*javascript:''', caseSensitive: false),
      'href="#"',
    );

    // data: 프로토콜 제거 (Base64 인코딩된 스크립트 공격 방지)
    html = html.replaceAll(
      RegExp(r'''href\s*=\s*["']?\s*data:''', caseSensitive: false),
      'href="#"',
    );

    // vbscript: 프로토콜 제거
    html = html.replaceAll(
      RegExp(r'''href\s*=\s*["']?\s*vbscript:''', caseSensitive: false),
      'href="#"',
    );

    return html;
  }

  /// 허용되지 않은 태그 제거
  static String _removeDisallowedTags(String html, Set<String> allowedTags) {
    // 모든 태그 찾기
    final tagPattern = RegExp(r'</?(\w+)[^>]*>');
    final matches = tagPattern.allMatches(html);

    for (final match in matches.toList().reversed) {
      final tagName = match.group(1)?.toLowerCase();
      if (tagName != null && !allowedTags.contains(tagName)) {
        // 허용되지 않은 태그는 제거 (내용은 유지)
        final fullTag = match.group(0)!;
        html = html.replaceFirst(fullTag, '');
      }
    }

    return html;
  }

  /// 허용되지 않은 속성 제거
  static String _removeDisallowedAttributes(
    String html,
    Map<String, Set<String>> allowedAttributes,
  ) {
    // 태그와 속성 파싱
    final tagPattern = RegExp(r'<(\w+)([^>]*)>');
    final matches = tagPattern.allMatches(html);

    for (final match in matches.toList().reversed) {
      final tagName = match.group(1)?.toLowerCase();
      final attributesStr = match.group(2) ?? '';

      if (tagName == null) continue;

      final allowedAttrs = allowedAttributes[tagName] ?? {};
      final cleanedAttrs = _cleanAttributes(attributesStr, allowedAttrs);

      final originalTag = match.group(0)!;
      final newTag = '<$tagName$cleanedAttrs>';

      html = html.replaceFirst(originalTag, newTag);
    }

    return html;
  }

  /// 속성 정제
  static String _cleanAttributes(String attributesStr, Set<String> allowedAttrs) {
    if (attributesStr.trim().isEmpty) return '';

    // 따옴표로 감싸진 속성값과 그렇지 않은 속성값 모두 처리
    final attrPattern = RegExp(r'''(\w+)\s*=\s*(?:"([^"]*)"|'([^']*)'|([^\s>]+))''');
    final matches = attrPattern.allMatches(attributesStr);

    final cleanedAttrs = <String>[];
    for (final match in matches) {
      final attrName = match.group(1)?.toLowerCase();
      // 따옴표로 감싸진 값 또는 그렇지 않은 값 추출
      final attrValue = match.group(2) ?? match.group(3) ?? match.group(4);

      if (attrName != null &&
          attrValue != null &&
          allowedAttrs.contains(attrName)) {
        cleanedAttrs.add('$attrName="$attrValue"');
      }
    }

    return cleanedAttrs.isEmpty ? '' : ' ${cleanedAttrs.join(' ')}';
  }

  /// 스타일 속성 새니타이징
  static String _sanitizeStyles(String html) {
    final stylePattern = RegExp(r'''style\s*=\s*["']([^"']*)["']''');
    final matches = stylePattern.allMatches(html);

    for (final match in matches.toList().reversed) {
      final styleValue = match.group(1);
      if (styleValue == null) continue;

      final cleanedStyle = _cleanStyleValue(styleValue);
      final originalAttr = match.group(0)!;
      final newAttr = cleanedStyle.isEmpty ? '' : 'style="$cleanedStyle"';

      html = html.replaceFirst(originalAttr, newAttr);
    }

    return html;
  }

  /// 스타일 값 정제
  static String _cleanStyleValue(String styleValue) {
    final properties = styleValue.split(';');
    final cleanedProperties = <String>[];

    for (final property in properties) {
      final parts = property.split(':');
      if (parts.length != 2) continue;

      final propName = parts[0].trim().toLowerCase();
      final propValue = parts[1].trim();

      // 허용된 CSS 속성만 유지
      if (_allowedStyleProperties.contains(propName)) {
        // expression(), url() 등 위험한 CSS 함수 제거
        if (!propValue.contains(RegExp(r'expression|url|import', caseSensitive: false))) {
          cleanedProperties.add('$propName: $propValue');
        }
      }
    }

    return cleanedProperties.join('; ');
  }

  /// 이중 인코딩 방지
  static String _preventDoubleEncoding(String html) {
    // &lt; &gt; 등이 이미 인코딩된 경우 다시 인코딩하지 않도록 처리
    return html;
  }

  /// HTML 엔티티 이스케이프
  ///
  /// 특수 문자를 HTML 엔티티로 변환하여 XSS 방지
  static String escapeHtml(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#x27;')
        .replaceAll('/', '&#x2F;');
  }

  /// HTML 엔티티 언이스케이프
  static String unescapeHtml(String html) {
    return html
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#x27;', "'")
        .replaceAll('&#x2F;', '/');
  }

  /// 텍스트를 HTML 단락으로 변환
  ///
  /// 줄바꿈을 <p> 태그로 변환하고 특수 문자를 이스케이프
  static String textToHtml(String text) {
    if (text.isEmpty) return '';

    // 특수 문자 이스케이프
    final escaped = escapeHtml(text);

    // 빈 줄로 구분된 단락 생성
    final paragraphs = escaped.split(RegExp(r'\n\s*\n'));
    final htmlParagraphs = paragraphs
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .map((p) {
      // 단일 줄바꿈은 <br>로 변환
      final withBreaks = p.replaceAll('\n', '<br>');
      return '<p>$withBreaks</p>';
    });

    return htmlParagraphs.join('\n');
  }

  /// HTML을 텍스트로 변환 (태그 제거)
  static String htmlToText(String html) {
    if (html.isEmpty) return '';

    // HTML 태그 제거
    var text = html.replaceAll(RegExp(r'<[^>]*>'), '');

    // HTML 엔티티 디코딩
    text = unescapeHtml(text);

    // 연속된 공백 정리
    text = text.replaceAll(RegExp(r'\s+'), ' ');

    return text.trim();
  }
}
