import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
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

  /// 스타일 시트 (선택사항)
  final MarkdownStyleSheet? styleSheet;

  /// 링크 탭 핸들러 (선택사항)
  final void Function(String)? onLinkTap;

  const RichTextViewer({
    super.key,
    required this.content,
    this.styleSheet,
    this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    // HTML 새니타이징
    final sanitizedHtml = HtmlSanitizer.sanitize(content);

    // HTML을 마크다운으로 변환하여 렌더링
    // (Flutter에서 순수 HTML 렌더링은 제한적이므로 마크다운 사용)
    final markdown = _htmlToMarkdown(sanitizedHtml);

    return Markdown(
      data: markdown,
      styleSheet: styleSheet ?? MarkdownStyleSheet.fromTheme(Theme.of(context)),
      onTapLink: (text, href, title) {
        if (href != null) {
          if (onLinkTap != null) {
            onLinkTap!(href);
          } else {
            _launchUrl(href);
          }
        }
      },
      sizedImageBuilder: (config) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Image.network(
            config.uri.toString(),
            width: config.width,
            height: config.height,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.broken_image, color: Colors.grey),
                    SizedBox(width: 8),
                    Text('이미지를 불러올 수 없습니다'),
                  ],
                ),
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                ),
              );
            },
          ),
        );
      },
      shrinkWrap: true,
      selectable: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  /// HTML을 마크다운으로 변환
  String _htmlToMarkdown(String html) {
    var markdown = html;

    // 제목 태그 변환
    markdown = markdown.replaceAllMapped(
      RegExp(r'<h1[^>]*>(.*?)</h1>', dotAll: true),
      (match) => '# ${match.group(1)}\n\n',
    );
    markdown = markdown.replaceAllMapped(
      RegExp(r'<h2[^>]*>(.*?)</h2>', dotAll: true),
      (match) => '## ${match.group(1)}\n\n',
    );
    markdown = markdown.replaceAllMapped(
      RegExp(r'<h3[^>]*>(.*?)</h3>', dotAll: true),
      (match) => '### ${match.group(1)}\n\n',
    );
    markdown = markdown.replaceAllMapped(
      RegExp(r'<h4[^>]*>(.*?)</h4>', dotAll: true),
      (match) => '#### ${match.group(1)}\n\n',
    );
    markdown = markdown.replaceAllMapped(
      RegExp(r'<h5[^>]*>(.*?)</h5>', dotAll: true),
      (match) => '##### ${match.group(1)}\n\n',
    );
    markdown = markdown.replaceAllMapped(
      RegExp(r'<h6[^>]*>(.*?)</h6>', dotAll: true),
      (match) => '###### ${match.group(1)}\n\n',
    );

    // 단락 태그 변환
    markdown = markdown.replaceAllMapped(
      RegExp(r'<p[^>]*>(.*?)</p>', dotAll: true),
      (match) => '${match.group(1)}\n\n',
    );

    // 굵게
    markdown = markdown.replaceAllMapped(
      RegExp(r'<(?:strong|b)[^>]*>(.*?)</(?:strong|b)>', dotAll: true),
      (match) => '**${match.group(1)}**',
    );

    // 기울임
    markdown = markdown.replaceAllMapped(
      RegExp(r'<(?:em|i)[^>]*>(.*?)</(?:em|i)>', dotAll: true),
      (match) => '*${match.group(1)}*',
    );

    // 취소선
    markdown = markdown.replaceAllMapped(
      RegExp(r'<(?:s|strike|del)[^>]*>(.*?)</(?:s|strike|del)>', dotAll: true),
      (match) => '~~${match.group(1)}~~',
    );

    // 코드
    markdown = markdown.replaceAllMapped(
      RegExp(r'<code[^>]*>(.*?)</code>', dotAll: true),
      (match) => '`${match.group(1)}`',
    );

    // 인용
    markdown = markdown.replaceAllMapped(
      RegExp(r'<blockquote[^>]*>(.*?)</blockquote>', dotAll: true),
      (match) => '> ${match.group(1)}\n\n',
    );

    // 링크
    markdown = markdown.replaceAllMapped(
      RegExp(r'''<a[^>]*href=["']([^"']*)["'][^>]*>(.*?)</a>''', dotAll: true),
      (match) => '[${match.group(2)}](${match.group(1)})',
    );

    // 이미지
    markdown = markdown.replaceAllMapped(
      RegExp(r'''<img[^>]*src=["']([^"']*)["'][^>]*>''', dotAll: true),
      (match) {
        final src = match.group(1) ?? '';
        // alt 속성 추출 시도
        final altMatch = RegExp(r'''alt=["']([^"']*)["']''').firstMatch(match.group(0) ?? '');
        final alt = altMatch?.group(1) ?? '';
        return '![$alt]($src)\n\n';
      },
    );

    // 순서 없는 리스트
    markdown = markdown.replaceAllMapped(
      RegExp(r'<ul[^>]*>(.*?)</ul>', dotAll: true),
      (match) {
        final items = match.group(1) ?? '';
        final listItems = RegExp(r'<li[^>]*>(.*?)</li>', dotAll: true)
            .allMatches(items)
            .map((m) => '- ${m.group(1)}')
            .join('\n');
        return '$listItems\n\n';
      },
    );

    // 순서 있는 리스트
    markdown = markdown.replaceAllMapped(
      RegExp(r'<ol[^>]*>(.*?)</ol>', dotAll: true),
      (match) {
        final items = match.group(1) ?? '';
        var index = 1;
        final listItems = RegExp(r'<li[^>]*>(.*?)</li>', dotAll: true)
            .allMatches(items)
            .map((m) => '${index++}. ${m.group(1)}')
            .join('\n');
        return '$listItems\n\n';
      },
    );

    // 구분선
    markdown = markdown.replaceAll(RegExp(r'<hr[^>]*>'), '---\n\n');

    // 줄바꿈
    markdown = markdown.replaceAll(RegExp(r'<br[^>]*>'), '\n');

    // 남은 HTML 태그 제거
    markdown = markdown.replaceAll(RegExp(r'<[^>]*>'), '');

    // HTML 엔티티 디코딩
    markdown = HtmlSanitizer.unescapeHtml(markdown);

    // 연속된 줄바꿈 정리
    markdown = markdown.replaceAll(RegExp(r'\n{3,}'), '\n\n');

    return markdown.trim();
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
