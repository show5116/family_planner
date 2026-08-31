import 'package:dart_quill_delta/dart_quill_delta.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/shared/widgets/editor/utils/markdown_to_delta.dart';

/// 마크다운 원문을 붙여넣어 에디터 내용으로 변환하는 다이얼로그
///
/// 마크다운 → HTML → Delta 순으로 변환하여 Quill 문서에 삽입합니다.
/// 저장 포맷(HTML)은 그대로 유지됩니다.
class MarkdownImportDialog extends StatefulWidget {
  /// 변환 결과를 삽입할 Quill 컨트롤러
  final QuillController controller;

  const MarkdownImportDialog({
    super.key,
    required this.controller,
  });

  /// 다이얼로그를 표시합니다.
  static Future<void> show(
    BuildContext context,
    QuillController controller,
  ) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => MarkdownImportDialog(controller: controller),
    );
  }

  @override
  State<MarkdownImportDialog> createState() => _MarkdownImportDialogState();
}

class _MarkdownImportDialogState extends State<MarkdownImportDialog> {
  final _textController = TextEditingController();
  bool _replaceExisting = true;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    // 클립보드에 마크다운으로 보이는 텍스트가 있으면 미리 채워줌
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _prefillFromClipboard();
    });
  }

  /// 클립보드 내용 미리 채우기
  Future<void> _prefillFromClipboard() async {
    try {
      final data = await Clipboard.getData(Clipboard.kTextPlain);
      final text = data?.text;
      if (!mounted || text == null || !looksLikeMarkdown(text)) return;
      if (_textController.text.isNotEmpty) return;

      _textController.text = text;
    } catch (e) {
      debugPrint('⚠️ [MarkdownImportDialog] 클립보드 읽기 실패 (무시됨): $e');
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(l10n.announcement_markdownImportTitle),
      content: SizedBox(
        width: AppSizes.breakpointMobile,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.announcement_markdownImportDescription,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.hintColor,
                ),
              ),
              const SizedBox(height: AppSizes.spaceM),

              // 마크다운 원문 입력
              TextField(
                controller: _textController,
                minLines: 8,
                maxLines: 16,
                autofocus: true,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                ),
                decoration: InputDecoration(
                  hintText: l10n.announcement_markdownImportHint,
                  border: const OutlineInputBorder(),
                  errorText: _errorText,
                ),
                onChanged: (_) {
                  if (_errorText != null) {
                    setState(() => _errorText = null);
                  }
                },
              ),
              const SizedBox(height: AppSizes.spaceS),

              // 기존 내용 대체 여부
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  l10n.announcement_markdownImportReplace,
                  style: theme.textTheme.bodyMedium,
                ),
                subtitle: Text(
                  l10n.announcement_markdownImportReplaceDescription,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
                value: _replaceExisting,
                onChanged: (value) {
                  setState(() => _replaceExisting = value);
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.common_cancel),
        ),
        FilledButton(
          onPressed: _handleConvert,
          child: Text(l10n.announcement_markdownImportConvert),
        ),
      ],
    );
  }

  /// 마크다운 변환 후 에디터에 삽입
  void _handleConvert() {
    final l10n = AppLocalizations.of(context)!;
    final source = _textController.text;

    if (source.trim().isEmpty) {
      setState(() => _errorText = l10n.announcement_markdownImportEmpty);
      return;
    }

    final delta = markdownToDelta(source);
    if (delta == null) {
      setState(() => _errorText = l10n.announcement_markdownImportFailed);
      return;
    }

    if (_replaceExisting) {
      widget.controller.document = Document.fromDelta(delta);
      widget.controller.updateSelection(
        TextSelection.collapsed(
          offset: widget.controller.document.length - 1,
        ),
        ChangeSource.local,
      );
    } else {
      final index = widget.controller.selection.baseOffset;
      widget.controller.replaceText(
        index,
        widget.controller.selection.extentOffset - index,
        Delta()..concat(delta),
        TextSelection.collapsed(offset: index),
      );
    }

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.announcement_markdownImportSuccess)),
    );
  }
}
