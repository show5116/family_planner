import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:family_planner/core/utils/html_sanitizer.dart';

/// 리치 텍스트 뷰어 위젯
///
/// HTML 콘텐츠를 안전하게 렌더링하는 위젯
/// XSS 공격을 방지하기 위해 자동으로 새니타이징 수행
///
/// 사용 예시:
/// ```dart
/// RichTextViewer(
///   content: htmlContent,
/// )
/// ```
class RichTextViewer extends StatelessWidget {
  /// 표시할 HTML 콘텐츠
  final String content;

  /// 링크 탭 핸들러 (선택사항)
  final void Function(String)? onLinkTap;

  const RichTextViewer({
    super.key,
    required this.content,
    this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    // HTML 새니타이징
    final sanitizedHtml = HtmlSanitizer.sanitize(content);

    return Html(
      data: sanitizedHtml,
      style: {
        'body': Style(
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
        ),
        'p': Style(
          margin: Margins.only(bottom: 8),
        ),
        'strong': Style(
          fontWeight: FontWeight.bold,
        ),
        'b': Style(
          fontWeight: FontWeight.bold,
        ),
        'em': Style(
          fontStyle: FontStyle.italic,
        ),
        'i': Style(
          fontStyle: FontStyle.italic,
        ),
        'img': Style(
          margin: Margins.symmetric(vertical: 8),
        ),
      },
      onLinkTap: (url, attributes, element) {
        if (url != null) {
          if (onLinkTap != null) {
            onLinkTap!(url);
          } else {
            _launchUrl(url);
          }
        }
      },
      onAnchorTap: (url, attributes, element) {
        if (url != null) {
          if (onLinkTap != null) {
            onLinkTap!(url);
          } else {
            _launchUrl(url);
          }
        }
      },
    );
  }

  /// URL 실행
  Future<void> _launchUrl(String urlString) async {
    try {
      final uri = Uri.parse(urlString);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      // URL 실행 실패 시 무시
      debugPrint('Failed to launch URL: $urlString, error: $e');
    }
  }
}
