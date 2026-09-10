import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/services/storage_service.dart';
import 'package:family_planner/core/utils/image_format.dart';

/// 에디터 이미지 핸들러 Mixin
///
/// 이미지 선택, 압축, 업로드, 삽입 로직을 캡슐화합니다.
/// StatefulWidget에서 사용하며, QuillController와 EditorImageType이 필요합니다.
mixin EditorImageHandler<T extends StatefulWidget> on State<T> {
  /// 이미지 피커 인스턴스
  final ImagePicker imagePicker = ImagePicker();

  /// 이미지 업로드 진행 중 여부
  bool isUploadingImage = false;

  /// QuillController (구현 클래스에서 제공)
  QuillController get quillController;

  /// 이미지 업로드 타입 (구현 클래스에서 제공)
  EditorImageType? get imageUploadType;

  /// 이미지 업로드 상태 변경 시 호출 (setState 래퍼)
  void onImageUploadStateChanged(bool uploading);

  /// 이미지 업로드 처리
  Future<void> handleImageUpload() async {
    if (imageUploadType == null) return;

    try {
      final XFile? image = await imagePicker.pickImage(
        source: ImageSource.gallery,
      );

      if (image == null) return;

      onImageUploadStateChanged(true);

      final originalBytes = await image.readAsBytes();

      // 압축 + 형식 정규화 (Flutter가 못 그리는 형식을 올리면 본문에서 깨진다)
      final prepared = await _prepareForUpload(originalBytes, image.name);
      if (prepared == null) {
        throw Exception('지원하지 않는 이미지 형식입니다');
      }

      debugPrint(
          '🖼️ [EditorImageHandler] 이미지 준비 완료 - 원본: ${originalBytes.length} bytes, 업로드: ${prepared.bytes.length} bytes (${prepared.fileName})');

      // 이미지 업로드
      final result = await StorageService.instance.uploadEditorImage(
        fileBytes: prepared.bytes,
        fileName: prepared.fileName,
        type: imageUploadType!,
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
        onImageUploadStateChanged(false);
      }
    }
  }

  /// 업로드용으로 준비한 이미지 (형식 정규화 + 압축)
  ///
  /// 형식을 바꾸지 못하면 null — 올려봐야 본문에서 깨지므로 올리지 않는다.
  Future<_PreparedEditorImage?> _prepareForUpload(
    Uint8List bytes,
    String fileName,
  ) async {
    // 형식은 파일명이 아니라 **바이트로** 판정한다. 확장자는 거짓일 수 있다.
    var source = sniffImageFormat(bytes);

    if (kIsWeb) {
      // 웹은 변환·압축 수단이 없다. 그릴 수 있는 형식일 때만 올린다.
      if (!source.isDisplayable) return null;
      return _PreparedEditorImage(
        bytes: bytes,
        fileName: _renamed(fileName, source),
      );
    }

    var working = bytes;

    // HEIC 계열은 플랫폼 코덱으로 변환은 되지만 **Flutter가 표시하지 못한다.**
    // 그대로 올리면 본문에 깨진 이미지가 박힌 채로 저장된다.
    if (!source.isDisplayable) {
      final converted = await _transcodeToJpeg(bytes);
      if (converted == null) return null;
      working = converted;
      source = ImageFormat.jpeg;
    }

    // GIF는 압축하면 애니메이션이 날아간다
    if (source == ImageFormat.gif) {
      return _PreparedEditorImage(
        bytes: working,
        fileName: _renamed(fileName, source),
      );
    }

    try {
      final compressed = await FlutterImageCompress.compressWithList(
        working,
        minWidth: 1200,
        minHeight: 1200,
        quality: 85,
        format: _compressFormatFor(source),
      );

      // 압축이 오히려 커지는 경우가 있다 (이미 최적화된 파일 등)
      final resultBytes =
          compressed.length < working.length ? compressed : working;

      return _PreparedEditorImage(
        bytes: resultBytes,
        fileName: _renamed(fileName, sniffImageFormat(resultBytes)),
      );
    } catch (e) {
      debugPrint('⚠️ [EditorImageHandler] 이미지 압축 실패, 원본 사용: $e');
      return _PreparedEditorImage(
        bytes: working,
        fileName: _renamed(fileName, source),
      );
    }
  }

  /// 그릴 수 없는 형식을 JPEG로 바꾼다 (실패하면 null)
  Future<Uint8List?> _transcodeToJpeg(Uint8List bytes) async {
    try {
      final converted = await FlutterImageCompress.compressWithList(
        bytes,
        minWidth: 1200,
        minHeight: 1200,
        quality: 85,
        format: CompressFormat.jpeg,
      );

      // 변환 결과도 바이트로 확인한다 — 디코딩에 실패하면 빈 데이터가 온다
      if (sniffImageFormat(converted) != ImageFormat.jpeg) return null;
      return converted;
    } catch (e) {
      // 안드로이드 HEIF 디코딩은 API 28부터라 구형 기기에서 실제로 실패한다
      debugPrint('⚠️ [EditorImageHandler] 형식 변환 실패: $e');
      return null;
    }
  }

  /// 실제 형식에 맞춘 파일명
  ///
  /// 서버는 확장자로 Content-Type을 정한다. 변환했는데 이름이 `.heic`으로
  /// 남아 있으면 JPEG를 HEIC라고 저장하게 된다.
  String _renamed(String fileName, ImageFormat format) {
    if (format.extension.isEmpty) return fileName;

    final dot = fileName.lastIndexOf('.');
    final base = dot > 0 ? fileName.substring(0, dot) : fileName;
    final current = dot > 0 ? fileName.substring(dot + 1).toLowerCase() : '';

    if (current == format.extension) return fileName;
    if (format == ImageFormat.jpeg && current == 'jpeg') return fileName;

    return '$base.${format.extension}';
  }

  /// 원본 형식을 유지하는 압축 포맷 (PNG·WebP만 유지, 나머지는 JPEG)
  ///
  /// **heic는 일부러 없다** — 만들어봐야 Flutter가 그리지 못한다.
  CompressFormat _compressFormatFor(ImageFormat source) => switch (source) {
        ImageFormat.png => CompressFormat.png,
        ImageFormat.webp => CompressFormat.webp,
        _ => CompressFormat.jpeg,
      };

  /// 이미지 삽입
  void _insertImage(String imageUrl) {
    final index = quillController.selection.baseOffset;
    quillController.document.insert(index, BlockEmbed.image(imageUrl));
    quillController.updateSelection(
      TextSelection.collapsed(offset: index + 1),
      ChangeSource.local,
    );
  }
}

/// 업로드 직전의 이미지 (형식·이름이 실제 바이트와 일치한다)
class _PreparedEditorImage {
  const _PreparedEditorImage({required this.bytes, required this.fileName});

  final Uint8List bytes;
  final String fileName;
}
