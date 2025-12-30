import 'package:flutter/material.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';

/// 마크다운 에디터 위젯
///
/// 텍스트 입력과 마크다운 미리보기를 제공하는 공통 에디터 컴포넌트
///
/// 사용 예시:
/// ```dart
/// MarkdownEditor(
///   controller: _contentController,
///   labelText: '내용',
///   hintText: '내용을 입력하세요',
///   minLines: 10,
///   maxLines: 20,
///   showPreview: true,
/// )
/// ```
class MarkdownEditor extends StatefulWidget {
  /// 텍스트 입력 컨트롤러
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

  /// 미리보기 표시 여부
  final bool showPreview;

  /// 툴바 표시 여부
  final bool showToolbar;

  /// 가이드 표시 여부
  final bool showGuide;

  /// 읽기 전용 여부
  final bool readOnly;

  const MarkdownEditor({
    super.key,
    required this.controller,
    this.labelText = '내용',
    this.hintText = '내용을 입력하세요',
    this.minLines = 10,
    this.maxLines,
    this.validator,
    this.showPreview = false,
    this.showToolbar = true,
    this.showGuide = true,
    this.readOnly = false,
  });

  @override
  State<MarkdownEditor> createState() => _MarkdownEditorState();
}

class _MarkdownEditorState extends State<MarkdownEditor> {
  bool _isPreviewMode = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 툴바
        if (widget.showToolbar && !widget.readOnly) ...[
          _buildToolbar(),
          const SizedBox(height: AppSizes.spaceM),
        ],

        // 에디터 또는 미리보기
        if (widget.showPreview)
          _buildEditorWithPreview()
        else
          _buildEditor(),

        // 마크다운 가이드
        if (widget.showGuide && !_isPreviewMode) ...[
          const SizedBox(height: AppSizes.spaceM),
          _buildMarkdownGuide(),
        ],
      ],
    );
  }

  /// 툴바 위젯
  Widget _buildToolbar() {
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
            // 제목
            _ToolbarButton(
              icon: Icons.title,
              tooltip: '제목 (# 제목)',
              onPressed: () => _insertMarkdown('# ', ''),
            ),
            // 굵게
            _ToolbarButton(
              icon: Icons.format_bold,
              tooltip: '굵게 (**텍스트**)',
              onPressed: () => _insertMarkdown('**', '**'),
            ),
            // 기울임
            _ToolbarButton(
              icon: Icons.format_italic,
              tooltip: '기울임 (*텍스트*)',
              onPressed: () => _insertMarkdown('*', '*'),
            ),
            // 취소선
            _ToolbarButton(
              icon: Icons.format_strikethrough,
              tooltip: '취소선 (~~텍스트~~)',
              onPressed: () => _insertMarkdown('~~', '~~'),
            ),
            const VerticalDivider(width: 1),
            // 리스트
            _ToolbarButton(
              icon: Icons.format_list_bulleted,
              tooltip: '리스트 (- 항목)',
              onPressed: () => _insertMarkdown('- ', ''),
            ),
            // 번호 리스트
            _ToolbarButton(
              icon: Icons.format_list_numbered,
              tooltip: '번호 리스트 (1. 항목)',
              onPressed: () => _insertMarkdown('1. ', ''),
            ),
            const VerticalDivider(width: 1),
            // 링크
            _ToolbarButton(
              icon: Icons.link,
              tooltip: '링크 ([텍스트](URL))',
              onPressed: () => _insertMarkdown('[', '](URL)'),
            ),
            // 코드
            _ToolbarButton(
              icon: Icons.code,
              tooltip: '코드 (`코드`)',
              onPressed: () => _insertMarkdown('`', '`'),
            ),
            // 인용
            _ToolbarButton(
              icon: Icons.format_quote,
              tooltip: '인용 (> 텍스트)',
              onPressed: () => _insertMarkdown('> ', ''),
            ),
            if (widget.showPreview) ...[
              const VerticalDivider(width: 1),
              // 미리보기 토글
              _ToolbarButton(
                icon: _isPreviewMode ? Icons.edit : Icons.visibility,
                tooltip: _isPreviewMode ? '편집 모드' : '미리보기',
                onPressed: () {
                  setState(() {
                    _isPreviewMode = !_isPreviewMode;
                  });
                },
                isActive: _isPreviewMode,
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 에디터 위젯
  Widget _buildEditor() {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        border: const OutlineInputBorder(),
        alignLabelWithHint: true,
      ),
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      validator: widget.validator,
      readOnly: widget.readOnly,
    );
  }

  /// 에디터와 미리보기 탭
  Widget _buildEditorWithPreview() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
      ),
      child: Column(
        children: [
          // 탭 헤더
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppSizes.radiusSmall),
                topRight: Radius.circular(AppSizes.radiusSmall),
              ),
            ),
            child: Row(
              children: [
                _TabButton(
                  label: '편집',
                  isSelected: !_isPreviewMode,
                  onPressed: () {
                    setState(() {
                      _isPreviewMode = false;
                    });
                  },
                ),
                _TabButton(
                  label: '미리보기',
                  isSelected: _isPreviewMode,
                  onPressed: () {
                    setState(() {
                      _isPreviewMode = true;
                    });
                  },
                ),
              ],
            ),
          ),

          // 내용 영역
          Container(
            constraints: BoxConstraints(
              minHeight: widget.minLines * 20.0,
              maxHeight: widget.maxLines != null
                  ? widget.maxLines! * 20.0
                  : double.infinity,
            ),
            padding: const EdgeInsets.all(AppSizes.spaceM),
            child: _isPreviewMode
                ? _buildPreview()
                : TextFormField(
                    controller: widget.controller,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '마크다운 형식으로 작성하세요...',
                    ),
                    minLines: widget.minLines,
                    maxLines: widget.maxLines,
                    validator: widget.validator,
                    readOnly: widget.readOnly,
                  ),
          ),
        ],
      ),
    );
  }

  /// 미리보기 위젯 (간단한 텍스트 표시)
  ///
  /// TODO: flutter_markdown 패키지를 추가하여 실제 마크다운 렌더링 구현
  Widget _buildPreview() {
    final text = widget.controller.text;

    if (text.isEmpty) {
      return Center(
        child: Text(
          '미리볼 내용이 없습니다',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }

  /// 마크다운 가이드 위젯
  Widget _buildMarkdownGuide() {
    return Card(
      color: AppColors.info.withValues(alpha: 0.05),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  size: AppSizes.iconSmall,
                  color: AppColors.info,
                ),
                const SizedBox(width: AppSizes.spaceS),
                Text(
                  '마크다운 사용 가이드',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.info,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spaceS),
            Text(
              '# 제목 1\n## 제목 2\n**굵게** *기울임* ~~취소선~~\n- 리스트 항목\n1. 번호 리스트\n> 인용문\n`코드`\n[링크](URL)',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                  ),
            ),
          ],
        ),
      ),
    );
  }

  /// 마크다운 삽입
  void _insertMarkdown(String prefix, String suffix) {
    final controller = widget.controller;
    final selection = controller.selection;
    final text = controller.text;

    if (selection.baseOffset == -1) {
      // 커서가 없는 경우 끝에 추가
      controller.text = text + prefix + suffix;
      controller.selection = TextSelection.collapsed(
        offset: text.length + prefix.length,
      );
    } else {
      // 선택된 텍스트가 있는 경우
      final selectedText = selection.textInside(text);
      final newText = text.replaceRange(
        selection.start,
        selection.end,
        prefix + selectedText + suffix,
      );

      controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(
          offset: selection.start + prefix.length + selectedText.length,
        ),
      );
    }
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

/// 탭 버튼
class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spaceM,
          vertical: AppSizes.spaceS,
        ),
        decoration: BoxDecoration(
          border: isSelected
              ? Border(
                  bottom: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                )
              : null,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
        ),
      ),
    );
  }
}
