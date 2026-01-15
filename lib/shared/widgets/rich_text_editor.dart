import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/utils/html_sanitizer.dart';

/// 리치 텍스트 에디터 위젯
///
/// 일반 사용자를 위한 WYSIWYG 스타일의 텍스트 에디터
/// HTML 형식으로 저장되며 XSS 공격으로부터 안전
///
/// 사용 예시:
/// ```dart
/// RichTextEditor(
///   controller: _contentController,
///   labelText: '내용',
///   hintText: '내용을 입력하세요',
///   minLines: 10,
/// )
/// ```
class RichTextEditor extends StatefulWidget {
  /// 텍스트 입력 컨트롤러 (HTML 형식)
  final TextEditingController controller;

  /// 라벨 텍스트
  final String labelText;

  /// 힌트 텍스트
  final String hintText;

  /// 최소 라인 수
  final int minLines;

  /// 최대 라인 수
  final int? maxLines;

  /// 유효성 검사 함수
  final String? Function(String?)? validator;

  /// 읽기 전용 여부
  final bool readOnly;

  /// 간소화 모드 (Q&A용: 굵게, 리스트, 이미지만 표시)
  final bool simpleMode;

  /// 이미지 첨부 콜백 (null이면 이미지 버튼 숨김)
  final VoidCallback? onImageAttach;

  const RichTextEditor({
    super.key,
    required this.controller,
    this.labelText = '내용',
    this.hintText = '내용을 입력하세요',
    this.minLines = 10,
    this.maxLines,
    this.validator,
    this.readOnly = false,
    this.simpleMode = false,
    this.onImageAttach,
  });

  @override
  State<RichTextEditor> createState() => _RichTextEditorState();
}

class _RichTextEditorState extends State<RichTextEditor> {
  // 현재 선택된 텍스트 스타일
  bool _isBold = false;
  bool _isItalic = false;
  bool _isUnderline = false;
  bool _isStrikethrough = false;
  String _currentHeading = 'normal';
  TextAlign _textAlign = TextAlign.left;

  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 라벨
        if (widget.labelText.isNotEmpty) ...[
          Text(
            widget.labelText,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: AppSizes.spaceS),
        ],

        // 툴바
        if (!widget.readOnly) ...[
          _buildToolbar(),
          const SizedBox(height: AppSizes.spaceS),
        ],

        // 에디터
        _buildEditor(),
      ],
    );
  }

  /// 툴바 위젯
  Widget _buildToolbar() {
    // 간소화 모드: 이미지, 굵게, 리스트만 표시
    if (widget.simpleMode) {
      return _buildSimpleToolbar();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spaceS,
          vertical: AppSizes.spaceXS,
        ),
        child: Wrap(
          spacing: AppSizes.spaceXS,
          runSpacing: AppSizes.spaceXS,
          children: [
            // 제목 스타일
            _buildHeadingDropdown(),
            const VerticalDivider(width: 1),

            // 굵게
            _ToolbarButton(
              icon: Icons.format_bold,
              tooltip: '굵게',
              isActive: _isBold,
              onPressed: () => _toggleStyle('bold'),
            ),

            // 기울임
            _ToolbarButton(
              icon: Icons.format_italic,
              tooltip: '기울임',
              isActive: _isItalic,
              onPressed: () => _toggleStyle('italic'),
            ),

            // 밑줄
            _ToolbarButton(
              icon: Icons.format_underlined,
              tooltip: '밑줄',
              isActive: _isUnderline,
              onPressed: () => _toggleStyle('underline'),
            ),

            // 취소선
            _ToolbarButton(
              icon: Icons.format_strikethrough,
              tooltip: '취소선',
              isActive: _isStrikethrough,
              onPressed: () => _toggleStyle('strikethrough'),
            ),

            const VerticalDivider(width: 1),

            // 왼쪽 정렬
            _ToolbarButton(
              icon: Icons.format_align_left,
              tooltip: '왼쪽 정렬',
              isActive: _textAlign == TextAlign.left,
              onPressed: () => _setTextAlign(TextAlign.left),
            ),

            // 가운데 정렬
            _ToolbarButton(
              icon: Icons.format_align_center,
              tooltip: '가운데 정렬',
              isActive: _textAlign == TextAlign.center,
              onPressed: () => _setTextAlign(TextAlign.center),
            ),

            // 오른쪽 정렬
            _ToolbarButton(
              icon: Icons.format_align_right,
              tooltip: '오른쪽 정렬',
              isActive: _textAlign == TextAlign.right,
              onPressed: () => _setTextAlign(TextAlign.right),
            ),

            const VerticalDivider(width: 1),

            // 리스트
            _ToolbarButton(
              icon: Icons.format_list_bulleted,
              tooltip: '글머리 기호',
              onPressed: () => _insertList('ul'),
            ),

            // 번호 리스트
            _ToolbarButton(
              icon: Icons.format_list_numbered,
              tooltip: '번호 매기기',
              onPressed: () => _insertList('ol'),
            ),

            const VerticalDivider(width: 1),

            // 링크
            _ToolbarButton(
              icon: Icons.link,
              tooltip: '링크',
              onPressed: _insertLink,
            ),

            // 인용
            _ToolbarButton(
              icon: Icons.format_quote,
              tooltip: '인용',
              onPressed: _insertQuote,
            ),

            // 구분선
            _ToolbarButton(
              icon: Icons.horizontal_rule,
              tooltip: '구분선',
              onPressed: _insertHorizontalRule,
            ),
          ],
        ),
      ),
    );
  }

  /// 간소화 툴바 (Q&A용)
  Widget _buildSimpleToolbar() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spaceM,
          vertical: AppSizes.spaceS,
        ),
        child: Row(
          children: [
            // 이미지 첨부 (가장 먼저 배치)
            if (widget.onImageAttach != null) ...[
              _ToolbarButton(
                icon: Icons.image,
                tooltip: '이미지 첨부',
                onPressed: widget.onImageAttach!,
              ),
              const SizedBox(width: AppSizes.spaceM),
              Container(
                width: 1,
                height: 24,
                color: Theme.of(context).dividerColor,
              ),
              const SizedBox(width: AppSizes.spaceM),
            ],

            // 굵게
            _ToolbarButton(
              icon: Icons.format_bold,
              tooltip: '굵게',
              isActive: _isBold,
              onPressed: () => _toggleStyle('bold'),
            ),
            const SizedBox(width: AppSizes.spaceS),

            // 리스트
            _ToolbarButton(
              icon: Icons.format_list_bulleted,
              tooltip: '글머리 기호',
              onPressed: () => _insertList('ul'),
            ),

            const Spacer(),

            // 도움말 텍스트
            Text(
              '간단한 서식만 지원됩니다',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  /// 제목 드롭다운
  Widget _buildHeadingDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceS),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
      ),
      child: DropdownButton<String>(
        value: _currentHeading,
        underline: const SizedBox(),
        isDense: true,
        items: const [
          DropdownMenuItem(value: 'normal', child: Text('본문')),
          DropdownMenuItem(value: 'h1', child: Text('제목 1')),
          DropdownMenuItem(value: 'h2', child: Text('제목 2')),
          DropdownMenuItem(value: 'h3', child: Text('제목 3')),
        ],
        onChanged: (value) {
          if (value != null) {
            setState(() {
              _currentHeading = value;
            });
            _applyHeading(value);
          }
        },
      ),
    );
  }

  /// 에디터 위젯
  Widget _buildEditor() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
      ),
      padding: const EdgeInsets.all(AppSizes.spaceM),
      child: TextFormField(
        controller: widget.controller,
        focusNode: _focusNode,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: widget.hintText,
        ),
        minLines: widget.minLines,
        maxLines: widget.maxLines,
        validator: widget.validator,
        readOnly: widget.readOnly,
        style: _buildTextStyle(),
        textAlign: _textAlign,
      ),
    );
  }

  /// 현재 텍스트 스타일 빌드
  TextStyle _buildTextStyle() {
    var style = Theme.of(context).textTheme.bodyMedium!;

    if (_isBold) {
      style = style.copyWith(fontWeight: FontWeight.bold);
    }

    if (_isItalic) {
      style = style.copyWith(fontStyle: FontStyle.italic);
    }

    final decorations = <TextDecoration>[];
    if (_isUnderline) decorations.add(TextDecoration.underline);
    if (_isStrikethrough) decorations.add(TextDecoration.lineThrough);

    if (decorations.isNotEmpty) {
      style = style.copyWith(
        decoration: TextDecoration.combine(decorations),
      );
    }

    // 제목 스타일
    switch (_currentHeading) {
      case 'h1':
        style = Theme.of(context).textTheme.displaySmall!;
        break;
      case 'h2':
        style = Theme.of(context).textTheme.headlineMedium!;
        break;
      case 'h3':
        style = Theme.of(context).textTheme.titleLarge!;
        break;
    }

    return style;
  }

  /// 스타일 토글
  void _toggleStyle(String style) {
    setState(() {
      switch (style) {
        case 'bold':
          _isBold = !_isBold;
          break;
        case 'italic':
          _isItalic = !_isItalic;
          break;
        case 'underline':
          _isUnderline = !_isUnderline;
          break;
        case 'strikethrough':
          _isStrikethrough = !_isStrikethrough;
          break;
      }
    });

    _applyStyleToSelection(style);
  }

  /// 선택된 텍스트에 스타일 적용
  void _applyStyleToSelection(String style) {
    final controller = widget.controller;
    final selection = controller.selection;

    if (!selection.isValid || selection.isCollapsed) return;

    final selectedText = selection.textInside(controller.text);
    String styledText;

    switch (style) {
      case 'bold':
        styledText = _isBold ? '<strong>$selectedText</strong>' : selectedText;
        break;
      case 'italic':
        styledText = _isItalic ? '<em>$selectedText</em>' : selectedText;
        break;
      case 'underline':
        styledText = _isUnderline ? '<u>$selectedText</u>' : selectedText;
        break;
      case 'strikethrough':
        styledText =
            _isStrikethrough ? '<s>$selectedText</s>' : selectedText;
        break;
      default:
        styledText = selectedText;
    }

    final newText = controller.text.replaceRange(
      selection.start,
      selection.end,
      styledText,
    );

    controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: selection.start + styledText.length),
    );
  }

  /// 제목 스타일 적용
  void _applyHeading(String heading) {
    final controller = widget.controller;
    final selection = controller.selection;

    if (!selection.isValid) return;

    // 현재 줄 찾기
    final text = controller.text;
    final lineStart = text.lastIndexOf('\n', selection.start - 1) + 1;
    final lineEnd = text.indexOf('\n', selection.end);
    final actualLineEnd = lineEnd == -1 ? text.length : lineEnd;

    final lineText = text.substring(lineStart, actualLineEnd);
    String styledText;

    if (heading == 'normal') {
      styledText = '<p>$lineText</p>';
    } else {
      styledText = '<$heading>$lineText</$heading>';
    }

    final newText = text.replaceRange(lineStart, actualLineEnd, styledText);
    controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: lineStart + styledText.length),
    );
  }

  /// 텍스트 정렬 설정
  void _setTextAlign(TextAlign align) {
    setState(() {
      _textAlign = align;
    });
  }

  /// 리스트 삽입
  void _insertList(String listType) {
    final controller = widget.controller;
    final selection = controller.selection;
    final offset = selection.baseOffset;

    final listHtml = listType == 'ul'
        ? '<ul>\n  <li>항목 1</li>\n  <li>항목 2</li>\n</ul>'
        : '<ol>\n  <li>항목 1</li>\n  <li>항목 2</li>\n</ol>';

    final newText = controller.text.substring(0, offset) +
        listHtml +
        controller.text.substring(offset);

    controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: offset + listHtml.length),
    );
  }

  /// 링크 삽입
  void _insertLink() {
    showDialog<Map<String, String>>(
      context: context,
      builder: (context) => _LinkDialog(),
    ).then((result) {
      if (result != null) {
        final text = result['text'] ?? '';
        final url = result['url'] ?? '';
        final linkHtml = '<a href="${HtmlSanitizer.escapeHtml(url)}">$text</a>';

        final controller = widget.controller;
        final selection = controller.selection;
        final offset = selection.baseOffset;

        final newText = controller.text.substring(0, offset) +
            linkHtml +
            controller.text.substring(offset);

        controller.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: offset + linkHtml.length),
        );
      }
    });
  }

  /// 인용 삽입
  void _insertQuote() {
    final controller = widget.controller;
    final selection = controller.selection;
    final offset = selection.baseOffset;

    const quoteHtml = '<blockquote>인용문을 입력하세요</blockquote>';

    final newText = controller.text.substring(0, offset) +
        quoteHtml +
        controller.text.substring(offset);

    controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: offset + quoteHtml.length),
    );
  }

  /// 구분선 삽입
  void _insertHorizontalRule() {
    final controller = widget.controller;
    final selection = controller.selection;
    final offset = selection.baseOffset;

    const hrHtml = '<hr>';

    final newText = controller.text.substring(0, offset) +
        hrHtml +
        controller.text.substring(offset);

    controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: offset + hrHtml.length),
    );
  }
}

/// 툴바 버튼
class _ToolbarButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final bool isActive;

  const _ToolbarButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        child: Container(
          padding: const EdgeInsets.all(AppSizes.spaceS),
          decoration: BoxDecoration(
            color: isActive
                ? Theme.of(context).colorScheme.primaryContainer
                : null,
            borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          ),
          child: Icon(
            icon,
            size: AppSizes.iconSmall,
            color: isActive
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).iconTheme.color,
          ),
        ),
      ),
    );
  }
}

/// 링크 삽입 다이얼로그
class _LinkDialog extends StatefulWidget {
  @override
  State<_LinkDialog> createState() => _LinkDialogState();
}

class _LinkDialogState extends State<_LinkDialog> {
  final _textController = TextEditingController();
  final _urlController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('링크 삽입'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _textController,
            decoration: const InputDecoration(
              labelText: '링크 텍스트',
              hintText: '표시할 텍스트',
            ),
          ),
          const SizedBox(height: AppSizes.spaceM),
          TextField(
            controller: _urlController,
            decoration: const InputDecoration(
              labelText: 'URL',
              hintText: 'https://example.com',
            ),
            keyboardType: TextInputType.url,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(context, {
              'text': _textController.text,
              'url': _urlController.text,
            });
          },
          child: const Text('삽입'),
        ),
      ],
    );
  }
}
