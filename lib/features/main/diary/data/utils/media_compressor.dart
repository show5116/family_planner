import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

/// 압축 결과
///
/// [bytes]는 실제로 업로드할 데이터다. 압축이 이득이 없으면 원본이 그대로 담긴다.
class CompressionResult {
  /// 업로드할 바이트 (압축본 또는 원본)
  final Uint8List bytes;

  /// 압축 전 크기
  final int originalSize;

  /// 실제로 압축이 적용되었는지
  ///
  /// 압축을 시도했더라도 결과가 원본보다 크면 원본을 쓰므로 false가 된다.
  final bool compressed;

  const CompressionResult({
    required this.bytes,
    required this.originalSize,
    required this.compressed,
  });

  int get size => bytes.length;

  /// 절약된 바이트 (압축하지 않았으면 0)
  int get savedBytes => compressed ? originalSize - bytes.length : 0;

  /// 절약률 0.0 ~ 1.0
  double get savedRatio {
    if (!compressed || originalSize == 0) return 0;
    return savedBytes / originalSize;
  }

  /// 절약률 백분율 (표시용)
  int get savedPercent => (savedRatio * 100).round();

  factory CompressionResult.original(Uint8List bytes) => CompressionResult(
        bytes: bytes,
        originalSize: bytes.length,
        compressed: false,
      );
}

/// 다이어리 미디어 압축
///
/// 한도가 용량 기준이므로 압축은 사용자에게 직접 이득이 된다. 다만 원본을 남기고
/// 싶은 사람도 있으므로 **강제하지 않는다** — 업로드 전 시트에서 고르게 하고,
/// 이 유틸은 "압축하면 얼마가 되는지"를 실제로 계산해 보여주는 데 쓴다.
class MediaCompressor {
  MediaCompressor._();

  /// 이미지 최대 변 (px)
  static const int maxDimension = 1920;

  /// JPEG/WebP 품질
  static const int quality = 80;

  /// 압축하지 않는 확장자
  ///
  /// GIF는 애니메이션이 날아가고, SVG는 래스터화되면 의미가 없다.
  static const Set<String> _skipExtensions = {'gif', 'svg'};

  /// 이미지 압축
  ///
  /// 실패하거나 이득이 없으면 **원본을 그대로 반환**한다. 압축 실패로 업로드
  /// 자체를 막지 않는다 — 한도가 있으므로 원본을 올려도 무방하다.
  static Future<CompressionResult> compressImage(
    Uint8List bytes,
    String fileName,
  ) async {
    // 웹에서는 flutter_image_compress가 동작하지 않는다.
    // presigned 직접 업로드라 서버가 대신 압축해줄 수도 없으므로 원본을 쓴다.
    if (kIsWeb) return CompressionResult.original(bytes);

    final extension = _extensionOf(fileName);
    if (_skipExtensions.contains(extension)) {
      return CompressionResult.original(bytes);
    }

    try {
      final compressed = await FlutterImageCompress.compressWithList(
        bytes,
        minWidth: maxDimension,
        minHeight: maxDimension,
        quality: quality,
        format: _formatOf(extension),
      );

      // 압축이 오히려 커지는 경우가 있다 (이미 최적화된 파일 등)
      if (compressed.length >= bytes.length) {
        return CompressionResult.original(bytes);
      }

      return CompressionResult(
        bytes: compressed,
        originalSize: bytes.length,
        compressed: true,
      );
    } catch (e) {
      debugPrint('⚠️ [MediaCompressor] 이미지 압축 실패, 원본 사용: $e');
      return CompressionResult.original(bytes);
    }
  }

  static String _extensionOf(String fileName) {
    final parts = fileName.split('.');
    if (parts.length < 2) return '';
    return parts.last.toLowerCase();
  }

  static CompressFormat _formatOf(String extension) {
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
}

/// 바이트를 사람이 읽는 크기 문자열로 변환
///
/// 한도 안내에 계속 쓰이므로 표기를 한 곳에서 통일한다.
String formatBytes(int bytes, {int decimals = 1}) {
  if (bytes <= 0) return '0 B';

  const units = ['B', 'KB', 'MB', 'GB', 'TB'];
  var size = bytes.toDouble();
  var unitIndex = 0;

  while (size >= 1024 && unitIndex < units.length - 1) {
    size /= 1024;
    unitIndex++;
  }

  // B·KB는 소수점이 의미 없다
  final digits = unitIndex <= 1 ? 0 : decimals;
  return '${size.toStringAsFixed(digits)} ${units[unitIndex]}';
}
