import 'package:dart_quill_delta/dart_quill_delta.dart';
import 'package:flutter_quill_delta_from_html/flutter_quill_delta_from_html.dart';
import 'package:markdown/markdown.dart' as md;

/// 마크다운으로 보이는 텍스트인지 추정
///
/// 헤딩, 리스트, 인용, 코드펜스, 굵게, 링크 중 하나라도 있으면 true
bool looksLikeMarkdown(String text) {
  if (text.trim().isEmpty) return false;

  const patterns = [
    r'^\s{0,3}#{1,6}\s+\S', // 헤딩
    r'^\s*[-*+]\s+\S', // 순서 없는 리스트
    r'^\s*\d+\.\s+\S', // 순서 있는 리스트
    r'^\s*>\s+\S', // 인용
    r'^\s*```', // 코드 펜스
    r'\*\*[^*\n]+\*\*', // 굵게
    r'\[[^\]\n]+\]\([^)\s]+\)', // 링크
  ];

  for (final pattern in patterns) {
    if (RegExp(pattern, multiLine: true).hasMatch(text)) {
      return true;
    }
  }
  return false;
}

/// 마크다운 텍스트를 HTML로 변환
String markdownToHtml(String markdownText) {
  return md.markdownToHtml(
    markdownText,
    extensionSet: md.ExtensionSet.gitHubWeb,
  );
}

/// 마크다운 텍스트를 Quill Delta로 변환
///
/// 변환 경로는 Markdown → HTML → Delta 입니다.
/// 에디터의 저장 포맷(HTML)을 그대로 유지하기 위해 HTML을 중간 단계로 거칩니다.
/// 변환에 실패하면 null을 반환합니다.
Delta? markdownToDelta(String markdownText) {
  if (markdownText.trim().isEmpty) return null;

  try {
    return HtmlToDelta().convert(markdownToHtml(markdownText));
  } catch (e) {
    return null;
  }
}
