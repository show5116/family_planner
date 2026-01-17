/// HTML 태그를 제거하고 순수 텍스트만 반환
String stripHtmlTags(String html) {
  // HTML 태그 제거
  final withoutTags = html.replaceAll(RegExp(r'<[^>]*>'), '');
  // HTML 엔티티 변환
  return withoutTags
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&amp;', '&')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&quot;', '"')
      .replaceAll('&#39;', "'")
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}
