import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

import 'package:family_planner/core/constants/app_sizes.dart';

/// 간소화 툴바 (Q&A용)
///
/// 굵게, 리스트, 이미지만 지원하는 간단한 툴바입니다.
class SimpleEditorToolbar extends StatelessWidget {
  final QuillController controller;
  final bool isUploadingImage;
  final VoidCallback? onImagePressed;

  const SimpleEditorToolbar({
    super.key,
    required this.controller,
    this.isUploadingImage = false,
    this.onImagePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spaceM,
          vertical: AppSizes.spaceS,
        ),
        child: Row(
          children: [
            // 이미지 첨부
            if (onImagePressed != null) ...[
              isUploadingImage
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : _ToolbarButton(
                      icon: Icons.image,
                      tooltip: '이미지 첨부',
                      onPressed: onImagePressed!,
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
              isActive:
                  controller.getSelectionStyle().attributes.containsKey('bold'),
              onPressed: () => controller.formatSelection(Attribute.bold),
            ),
            const SizedBox(width: AppSizes.spaceS),

            // 리스트
            _ToolbarButton(
              icon: Icons.format_list_bulleted,
              tooltip: '글머리 기호',
              isActive:
                  controller.getSelectionStyle().attributes.containsKey('list'),
              onPressed: () => controller.formatSelection(Attribute.ul),
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
}

/// 전체 툴바 (공지사항용)
///
/// QuillSimpleToolbar를 래핑하여 전체 서식 옵션을 제공합니다.
class FullEditorToolbar extends StatelessWidget {
  final QuillController controller;
  final bool isUploadingImage;
  final VoidCallback? onImagePressed;

  const FullEditorToolbar({
    super.key,
    required this.controller,
    this.isUploadingImage = false,
    this.onImagePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spaceS,
          vertical: AppSizes.spaceXS,
        ),
        child: QuillSimpleToolbar(
          controller: controller,
          config: QuillSimpleToolbarConfig(
            showDividers: true,
            showFontFamily: false,
            showFontSize: false,
            showBoldButton: true,
            showItalicButton: true,
            showUnderLineButton: true,
            showStrikeThrough: true,
            showInlineCode: false,
            showColorButton: false,
            showBackgroundColorButton: false,
            showClearFormat: true,
            showAlignmentButtons: true,
            showLeftAlignment: true,
            showCenterAlignment: true,
            showRightAlignment: true,
            showJustifyAlignment: false,
            showHeaderStyle: true,
            showListNumbers: true,
            showListBullets: true,
            showListCheck: false,
            showCodeBlock: false,
            showQuote: true,
            showIndent: false,
            showLink: true,
            showUndo: true,
            showRedo: true,
            showDirection: false,
            showSearchButton: false,
            showSubscript: false,
            showSuperscript: false,
            customButtons: onImagePressed != null
                ? [
                    QuillToolbarCustomButtonOptions(
                      icon: isUploadingImage
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.image, size: 18),
                      tooltip: '이미지 첨부',
                      onPressed: onImagePressed,
                    ),
                  ]
                : [],
          ),
        ),
      ),
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
