import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/services/storage_service.dart';

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
      final fileName = image.name;

      // 클라이언트 사이드 이미지 압축
      final compressedBytes = await _compressImage(originalBytes, fileName);

      debugPrint(
          '🖼️ [EditorImageHandler] 이미지 압축 완료 - 원본: ${originalBytes.length} bytes, 압축: ${compressedBytes.length} bytes');

      // 이미지 업로드
      final result = await StorageService.instance.uploadEditorImage(
        fileBytes: compressedBytes,
        fileName: fileName,
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
      debugPrint('⚠️ [EditorImageHandler] 이미지 압축 실패, 원본 사용: $e');
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
    final index = quillController.selection.baseOffset;
    quillController.document.insert(index, BlockEmbed.image(imageUrl));
    quillController.updateSelection(
      TextSelection.collapsed(offset: index + 1),
      ChangeSource.local,
    );
  }
}
