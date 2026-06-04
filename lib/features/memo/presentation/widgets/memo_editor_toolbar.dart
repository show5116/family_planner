import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

import 'package:family_planner/core/constants/app_sizes.dart';

/// 메모 전용 Quill 툴바
///
/// 일반 서식 + 체크리스트 토글 버튼을 포함합니다.
class MemoEditorToolbar extends StatelessWidget {
  final QuillController controller;
  final bool isUploadingImage;
  final VoidCallback? onImagePressed;

  const MemoEditorToolbar({
    super.key,
    required this.controller,
    this.isUploadingImage = false,
    this.onImagePressed,
  });

  void _toggleChecklist() {
    final style = controller.getSelectionStyle();
    final currentList = style.attributes['list']?.value as String?;
    if (currentList == 'unchecked' || currentList == 'checked') {
      // 이미 체크리스트면 해제
      controller.formatSelection(
        const Attribute('list', AttributeScope.block, null),
      );
    } else {
      controller.formatSelection(Attribute.unchecked);
    }
  }

  bool get _isChecklistActive {
    final val = controller.getSelectionStyle().attributes['list']?.value;
    return val == 'unchecked' || val == 'checked';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spaceS,
          vertical: AppSizes.spaceXS,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // 이미지
              if (onImagePressed != null) ...[
                _ToolbarBtn(
                  icon: isUploadingImage
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.image, size: 18),
                  tooltip: '이미지',
                  onPressed: isUploadingImage ? null : onImagePressed,
                ),
                _divider(context),
              ],

              // 체크리스트 토글 ← 핵심 버튼
              ListenableBuilder(
                listenable: controller,
                builder: (_, _) => _ToolbarBtn(
                  icon: Icon(
                    Icons.checklist,
                    size: 18,
                    color: _isChecklistActive
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                  tooltip: '체크리스트',
                  isActive: _isChecklistActive,
                  onPressed: _toggleChecklist,
                ),
              ),

              _divider(context),

              // 굵게
              _QuillFormatBtn(
                controller: controller,
                attribute: Attribute.bold,
                icon: Icons.format_bold,
                tooltip: '굵게',
              ),

              // 기울임
              _QuillFormatBtn(
                controller: controller,
                attribute: Attribute.italic,
                icon: Icons.format_italic,
                tooltip: '기울임',
              ),

              // 취소선
              _QuillFormatBtn(
                controller: controller,
                attribute: Attribute.strikeThrough,
                icon: Icons.strikethrough_s,
                tooltip: '취소선',
              ),

              _divider(context),

              // H1
              _QuillHeaderBtn(
                controller: controller,
                level: 1,
                label: 'H1',
                tooltip: '제목 1',
              ),

              // H2 (섹션 구분자로도 사용)
              _QuillHeaderBtn(
                controller: controller,
                level: 2,
                label: 'H2',
                tooltip: '제목 2 (체크리스트 섹션)',
              ),

              _divider(context),

              // 불릿 리스트
              _QuillFormatBtn(
                controller: controller,
                attribute: Attribute.ul,
                icon: Icons.format_list_bulleted,
                tooltip: '글머리 기호',
              ),

              // 번호 리스트
              _QuillFormatBtn(
                controller: controller,
                attribute: Attribute.ol,
                icon: Icons.format_list_numbered,
                tooltip: '번호 목록',
              ),

              _divider(context),

              // 실행 취소
              IconButton(
                icon: const Icon(Icons.undo, size: 18),
                tooltip: '실행 취소',
                onPressed: () => controller.undo(),
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(),
              ),

              // 다시 실행
              IconButton(
                icon: const Icon(Icons.redo, size: 18),
                tooltip: '다시 실행',
                onPressed: () => controller.redo(),
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _divider(BuildContext context) => Container(
        width: 1,
        height: 20,
        margin: const EdgeInsets.symmetric(horizontal: AppSizes.spaceS),
        color: Theme.of(context).dividerColor,
      );
}

class _ToolbarBtn extends StatelessWidget {
  final Widget icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final bool isActive;

  const _ToolbarBtn({
    required this.icon,
    required this.tooltip,
    this.onPressed,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: isActive
              ? BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(4),
                )
              : null,
          child: icon,
        ),
      ),
    );
  }
}

class _QuillFormatBtn extends StatelessWidget {
  final QuillController controller;
  final Attribute attribute;
  final IconData icon;
  final String tooltip;

  const _QuillFormatBtn({
    required this.controller,
    required this.attribute,
    required this.icon,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (_, _) {
        final isActive =
            controller.getSelectionStyle().attributes.containsKey(attribute.key);
        return _ToolbarBtn(
          icon: Icon(icon, size: 18),
          tooltip: tooltip,
          isActive: isActive,
          onPressed: () => controller.formatSelection(attribute),
        );
      },
    );
  }
}

class _QuillHeaderBtn extends StatelessWidget {
  final QuillController controller;
  final int level;
  final String label;
  final String tooltip;

  const _QuillHeaderBtn({
    required this.controller,
    required this.level,
    required this.label,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (_, _) {
        final current =
            controller.getSelectionStyle().attributes['header']?.value;
        final isActive = current == level;
        return _ToolbarBtn(
          icon: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isActive ? Theme.of(context).colorScheme.primary : null,
            ),
          ),
          tooltip: tooltip,
          isActive: isActive,
          onPressed: () {
            if (isActive) {
              controller.formatSelection(
                const Attribute('header', AttributeScope.block, null),
              );
            } else {
              controller.formatSelection(Attribute.fromKeyValue('header', level));
            }
          },
        );
      },
    );
  }
}
