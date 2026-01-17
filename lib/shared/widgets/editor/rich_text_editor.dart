import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_delta_from_html/flutter_quill_delta_from_html.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/services/storage_service.dart';

import 'components/editor_toolbar.dart';
import 'components/image_embed_builder.dart';
import 'mixins/editor_image_handler.dart';

/// 리치 텍스트 에디터 위젯 (flutter_quill 기반)
///
/// 진정한 WYSIWYG 에디터로, 보이는 대로 편집됩니다.
/// 내부적으로 Delta 포맷을 사용하며, HTML로 변환하여 저장합니다.
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
  /// 텍스트 입력 컨트롤러 (HTML 형식으로 동기화)
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

  /// 이미지 업로드 타입 (null이면 이미지 버튼 숨김)
  final EditorImageType? imageUploadType;

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
    this.imageUploadType,
  });

  @override
  State<RichTextEditor> createState() => _RichTextEditorState();
}

class _RichTextEditorState extends State<RichTextEditor>
    with EditorImageHandler<RichTextEditor> {
  late QuillController _quillController;
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  String? _validationError;

  /// Debounce를 위한 타이머 (HTML 변환 지연)
  Timer? _debounceTimer;

  /// Debounce 지연 시간 (500ms)
  static const _debounceDuration = Duration(milliseconds: 500);

  /// 에디터 컨테이너의 GlobalKey (스크롤 처리용)
  final GlobalKey _editorKey = GlobalKey();

  // EditorImageHandler mixin 구현
  @override
  QuillController get quillController => _quillController;

  @override
  EditorImageType? get imageUploadType => widget.imageUploadType;

  @override
  void onImageUploadStateChanged(bool uploading) {
    setState(() => isUploadingImage = uploading);
  }

  @override
  void initState() {
    super.initState();
    _initQuillController();

    // TextEditingController의 변경사항을 감지
    widget.controller.addListener(_onExternalControllerChange);

    // 포커스 변경 감지 - 키보드가 올라올 때 에디터가 보이도록 스크롤
    _focusNode.addListener(_onFocusChange);
  }

  /// 포커스 변경 시 에디터가 보이도록 스크롤
  void _onFocusChange() {
    if (_focusNode.hasFocus && _editorKey.currentContext != null) {
      // 약간의 딜레이 후 스크롤 (키보드 애니메이션 대기)
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!mounted || _editorKey.currentContext == null) return;

        Scrollable.ensureVisible(
          _editorKey.currentContext!,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          alignment: 0.3,
        );
      });
    }
  }

  /// Quill 컨트롤러 초기화
  void _initQuillController() {
    final initialHtml = widget.controller.text;

    if (initialHtml.isNotEmpty) {
      try {
        final converter = HtmlToDelta();
        final delta = converter.convert(initialHtml);
        _quillController = QuillController(
          document: Document.fromDelta(delta),
          selection: const TextSelection.collapsed(offset: 0),
        );
      } catch (e) {
        debugPrint('⚠️ [RichTextEditor] HTML 파싱 실패, 빈 문서로 시작: $e');
        _quillController = QuillController.basic();
      }
    } else {
      _quillController = QuillController.basic();
    }

    // 리스너 등록 전 초기 동기화 시도 (에러 무시)
    try {
      _getHtml();
    } catch (e) {
      debugPrint('⚠️ [RichTextEditor] 초기 HTML 변환 실패 (무시됨): $e');
    }

    _quillController.addListener(_syncToTextController);
  }

  /// 외부 TextEditingController 변경 감지
  void _onExternalControllerChange() {
    final currentHtml = _getHtml();
    if (widget.controller.text != currentHtml &&
        widget.controller.text.isNotEmpty) {
      try {
        final converter = HtmlToDelta();
        final delta = converter.convert(widget.controller.text);
        _quillController.document = Document.fromDelta(delta);
      } catch (e) {
        debugPrint('⚠️ [RichTextEditor] 외부 HTML 동기화 실패: $e');
      }
    }
  }

  /// Quill 문서를 TextEditingController에 동기화 (Debounce 적용)
  void _syncToTextController() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounceDuration, () {
      if (!mounted) return;
      final html = _getHtml();
      if (widget.controller.text != html) {
        widget.controller.text = html;
      }
    });
  }

  /// 즉시 동기화 (저장 전 호출용)
  void syncNow() {
    _debounceTimer?.cancel();
    final html = _getHtml();
    if (widget.controller.text != html) {
      widget.controller.text = html;
    }
  }

  /// Delta를 HTML로 변환
  String _getHtml() {
    try {
      // 빈 문서인 경우 빈 문자열 반환
      final plainText = _quillController.document.toPlainText();
      if (plainText.trim().isEmpty) {
        return '';
      }

      final delta = _quillController.document.toDelta();
      final deltaJson = delta.toJson();
      final converter = QuillDeltaToHtmlConverter(
        deltaJson,
        ConverterOptions(
          converterOptions: OpConverterOptions(
            inlineStylesFlag: true,
          ),
        ),
      );
      return converter.convert();
    } catch (e) {
      debugPrint('⚠️ [RichTextEditor] Delta to HTML 변환 실패: $e');
      // 변환 실패 시 plain text 반환
      return _quillController.document.toPlainText();
    }
  }

  /// 일반 텍스트 가져오기 (유효성 검사용)
  String _getPlainText() {
    return _quillController.document.toPlainText().trim();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _focusNode.removeListener(_onFocusChange);
    widget.controller.removeListener(_onExternalControllerChange);
    _quillController.removeListener(_syncToTextController);
    _quillController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
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

        // 유효성 검사 에러 메시지
        if (_validationError != null) ...[
          const SizedBox(height: AppSizes.spaceXS),
          Text(
            _validationError!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.error,
                ),
          ),
        ],
      ],
    );
  }

  /// 툴바 위젯
  Widget _buildToolbar() {
    if (widget.simpleMode) {
      return SimpleEditorToolbar(
        controller: _quillController,
        isUploadingImage: isUploadingImage,
        onImagePressed:
            widget.imageUploadType != null ? handleImageUpload : null,
      );
    }
    return FullEditorToolbar(
      controller: _quillController,
      isUploadingImage: isUploadingImage,
      onImagePressed: widget.imageUploadType != null ? handleImageUpload : null,
    );
  }

  /// 에디터 위젯
  Widget _buildEditor() {
    final lineHeight = Theme.of(context).textTheme.bodyMedium?.fontSize ?? 16;
    final minHeight = lineHeight * widget.minLines + AppSizes.spaceM * 2;

    return FormField<String>(
      initialValue: _getPlainText(),
      validator: (value) {
        if (widget.validator != null) {
          syncNow();
          final plainText = _getPlainText();
          final error = widget.validator!(plainText);
          setState(() => _validationError = error);
          return error;
        }
        return null;
      },
      builder: (field) {
        return Container(
          key: _editorKey,
          constraints: BoxConstraints(minHeight: minHeight),
          decoration: BoxDecoration(
            border: Border.all(
              color: _validationError != null
                  ? AppColors.error
                  : Theme.of(context).dividerColor,
            ),
            borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          ),
          child: QuillEditor(
            controller: _quillController,
            focusNode: _focusNode,
            scrollController: _scrollController,
            config: QuillEditorConfig(
              autoFocus: false,
              expands: false,
              padding: const EdgeInsets.all(AppSizes.spaceM),
              // flutter_quill 버그: placeholder에 줄바꿈이 있으면 JSON 파싱 에러 발생
              placeholder: widget.hintText.replaceAll('\n', ' '),
              readOnlyMouseCursor: SystemMouseCursors.text,
              scrollable: false,
              enableInteractiveSelection: true,
              embedBuilders: [
                ImageEmbedBuilder(),
              ],
            ),
          ),
        );
      },
    );
  }
}
