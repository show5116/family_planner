import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_delta_from_html/flutter_quill_delta_from_html.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/services/storage_service.dart';

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

class _RichTextEditorState extends State<RichTextEditor> {
  late QuillController _quillController;
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _imagePicker = ImagePicker();
  bool _isUploadingImage = false;
  String? _validationError;

  @override
  void initState() {
    super.initState();
    _initQuillController();

    // TextEditingController의 변경사항을 감지
    widget.controller.addListener(_onExternalControllerChange);
  }

  /// Quill 컨트롤러 초기화
  void _initQuillController() {
    final initialHtml = widget.controller.text;

    if (initialHtml.isNotEmpty) {
      // HTML을 Delta로 변환
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

    // Quill 컨트롤러의 변경사항을 TextEditingController에 동기화
    _quillController.addListener(_syncToTextController);
  }

  /// 외부 TextEditingController 변경 감지
  void _onExternalControllerChange() {
    // 외부에서 controller.text가 변경된 경우 (수정 모드에서 데이터 로드 등)
    // Quill 문서와 동기화되어 있지 않으면 업데이트
    final currentHtml = _getHtml();
    if (widget.controller.text != currentHtml && widget.controller.text.isNotEmpty) {
      try {
        final converter = HtmlToDelta();
        final delta = converter.convert(widget.controller.text);
        _quillController.document = Document.fromDelta(delta);
      } catch (e) {
        debugPrint('⚠️ [RichTextEditor] 외부 HTML 동기화 실패: $e');
      }
    }
  }

  /// Quill 문서를 TextEditingController에 동기화
  void _syncToTextController() {
    final html = _getHtml();
    if (widget.controller.text != html) {
      widget.controller.text = html;
    }
  }

  /// Delta를 HTML로 변환
  String _getHtml() {
    final delta = _quillController.document.toDelta();
    final converter = QuillDeltaToHtmlConverter(
      delta.toJson(),
      ConverterOptions(
        converterOptions: OpConverterOptions(
          inlineStylesFlag: true,
        ),
      ),
    );
    return converter.convert();
  }

  /// 일반 텍스트 가져오기 (유효성 검사용)
  String _getPlainText() {
    return _quillController.document.toPlainText().trim();
  }

  @override
  void dispose() {
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
      return _buildSimpleToolbar();
    }
    return _buildFullToolbar();
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
            // 이미지 첨부
            if (widget.imageUploadType != null) ...[
              _isUploadingImage
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : _ToolbarButton(
                      icon: Icons.image,
                      tooltip: '이미지 첨부',
                      onPressed: _handleImageUpload,
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
              isActive: _quillController.getSelectionStyle().attributes.containsKey('bold'),
              onPressed: () => _quillController.formatSelection(Attribute.bold),
            ),
            const SizedBox(width: AppSizes.spaceS),

            // 리스트
            _ToolbarButton(
              icon: Icons.format_list_bulleted,
              tooltip: '글머리 기호',
              isActive: _quillController.getSelectionStyle().attributes.containsKey('list'),
              onPressed: () => _quillController.formatSelection(Attribute.ul),
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

  /// 전체 툴바 (공지사항용)
  Widget _buildFullToolbar() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spaceS,
          vertical: AppSizes.spaceXS,
        ),
        child: QuillSimpleToolbar(
          controller: _quillController,
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
            customButtons: widget.imageUploadType != null
                ? [
                    QuillToolbarCustomButtonOptions(
                      icon: _isUploadingImage
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.image, size: 18),
                      tooltip: '이미지 첨부',
                      onPressed: _handleImageUpload,
                    ),
                  ]
                : [],
          ),
        ),
      ),
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
          final plainText = _getPlainText();
          final error = widget.validator!(plainText);
          setState(() => _validationError = error);
          return error;
        }
        return null;
      },
      builder: (field) {
        return Container(
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
              placeholder: widget.hintText,
              readOnlyMouseCursor: SystemMouseCursors.text,
              scrollable: true,
              enableInteractiveSelection: true,
              embedBuilders: [
                // 이미지 임베드 빌더
                _ImageEmbedBuilder(),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 이미지 업로드 처리
  Future<void> _handleImageUpload() async {
    if (widget.imageUploadType == null) return;

    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );

      if (image == null) return;

      setState(() => _isUploadingImage = true);

      final originalBytes = await image.readAsBytes();
      final fileName = image.name;

      // 클라이언트 사이드 이미지 압축
      final compressedBytes = await _compressImage(originalBytes, fileName);

      debugPrint('🖼️ [RichTextEditor] 이미지 압축 완료 - 원본: ${originalBytes.length} bytes, 압축: ${compressedBytes.length} bytes');

      // 이미지 업로드
      final result = await StorageService.instance.uploadEditorImage(
        fileBytes: compressedBytes,
        fileName: fileName,
        type: widget.imageUploadType!,
      );

      // 에디터에 이미지 삽입
      _insertImage(result.url);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('이미지가 업로드되었습니다'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('이미지 업로드 실패: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUploadingImage = false);
      }
    }
  }

  /// 이미지 압축
  Future<List<int>> _compressImage(Uint8List bytes, String fileName) async {
    if (kIsWeb) return bytes;

    final extension = fileName.split('.').last.toLowerCase();
    if (extension == 'gif' || extension == 'svg') return bytes;

    try {
      final compressedBytes = await FlutterImageCompress.compressWithList(
        bytes,
        minWidth: 1200,
        minHeight: 1200,
        quality: 85,
        format: _getCompressFormat(extension),
      );

      if (compressedBytes.length >= bytes.length) return bytes;
      return compressedBytes;
    } catch (e) {
      debugPrint('⚠️ [RichTextEditor] 이미지 압축 실패, 원본 사용: $e');
      return bytes;
    }
  }

  /// 압축 포맷 결정
  CompressFormat _getCompressFormat(String extension) {
    switch (extension) {
      case 'png':
        return CompressFormat.png;
      case 'webp':
        return CompressFormat.webp;
      case 'heic':
        return CompressFormat.heic;
      default:
        return CompressFormat.jpeg;
    }
  }

  /// 이미지 삽입
  void _insertImage(String imageUrl) {
    final index = _quillController.selection.baseOffset;
    _quillController.document.insert(index, BlockEmbed.image(imageUrl));
    _quillController.updateSelection(
      TextSelection.collapsed(offset: index + 1),
      ChangeSource.local,
    );
  }
}

/// 이미지 임베드 빌더
class _ImageEmbedBuilder extends EmbedBuilder {
  @override
  String get key => BlockEmbed.imageType;

  @override
  Widget build(
    BuildContext context,
    EmbedContext embedContext,
  ) {
    final imageUrl = embedContext.node.value.data;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSizes.spaceS),
      constraints: const BoxConstraints(maxWidth: double.infinity),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        child: Image.network(
          imageUrl,
          fit: BoxFit.contain,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              height: 200,
              color: Colors.grey[200],
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 100,
              color: Colors.grey[200],
              child: const Center(
                child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
              ),
            );
          },
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
