import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:family_planner/core/utils/image_format.dart';

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

  /// [bytes]에서 **읽어낸** MIME
  ///
  /// 파일명에서 추측한 값이 아니다. 압축이 형식을 바꿀 수 있어서, 신고값은
  /// 언제나 결과 바이트를 다시 판정해 가져온다.
  final String mimeType;

  const CompressionResult({
    required this.bytes,
    required this.originalSize,
    required this.compressed,
    required this.mimeType,
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
        mimeType: sniffImageMime(bytes) ?? ImageFormat.jpeg.mimeType,
      );
}

/// 다이어리 미디어 압축
///
/// 한도가 용량 기준이므로 압축은 사용자에게 직접 이득이 된다. 다만 원본을 남기고
/// 싶은 사람도 있으므로 **강제하지 않는다** — 업로드 전 시트에서 고르게 하고,
/// 이 유틸은 "압축하면 얼마가 되는지"를 실제로 계산해 보여주는 데 쓴다.
///
/// 형식 판정은 전부 [sniffImageFormat]으로 한다. 파일명은 믿지 않는다.
class MediaCompressor {
  MediaCompressor._();

  /// 이미지 최대 변 (px)
  static const int maxDimension = 1920;

  /// JPEG/WebP 품질
  static const int quality = 80;

  /// 썸네일 최대 변 (px) — 서버와 합의한 규격
  static const int thumbnailDimension = 640;

  /// 썸네일 품질 — 서버와 합의한 규격
  static const int thumbnailQuality = 80;

  /// 형식만 바꿀 때의 품질 (해상도는 유지한다)
  static const int transcodeQuality = 95;

  /// 축소를 일으키지 않을 만큼 큰 값
  ///
  /// `flutter_image_compress`는 원본보다 크게 늘리지 않으므로, 이 값을 주면
  /// "줄이지 말라"는 뜻이 된다. 형식만 바꿀 때 쓴다.
  static const int _noDownscale = 20000;

  /// 서버가 받아주는 이미지 형식
  ///
  /// 백엔드 `ALLOWED_MIME_TYPES`와 같아야 한다. **HEIC는 없다** —
  /// 애초에 Flutter가 HEIC를 그리지 못하므로 저장해두면 뷰어가 깨진다.
  static const Set<ImageFormat> allowedFormats = {
    ImageFormat.jpeg,
    ImageFormat.png,
    ImageFormat.webp,
    ImageFormat.gif,
  };

  /// 압축하지 않는 형식 (GIF는 애니메이션이 날아간다)
  static const Set<ImageFormat> _skipCompression = {ImageFormat.gif};

  /// 이미지 압축
  ///
  /// 실패하거나 이득이 없으면 **원본을 그대로 반환**한다. 압축 실패로 업로드
  /// 자체를 막지 않는다 — 한도가 있으므로 원본을 올려도 무방하다.
  ///
  /// 입력은 [toUploadable]을 통과한 바이트여야 한다(선택 시점에 보장한다).
  static Future<CompressionResult> compressImage(Uint8List bytes) async {
    final source = sniffImageFormat(bytes);

    // 웹에서는 flutter_image_compress가 동작하지 않는다.
    // presigned 직접 업로드라 서버가 대신 압축해줄 수도 없으므로 원본을 쓴다.
    if (kIsWeb || _skipCompression.contains(source)) {
      return CompressionResult.original(bytes);
    }

    try {
      final compressed = await FlutterImageCompress.compressWithList(
        bytes,
        minWidth: maxDimension,
        minHeight: maxDimension,
        quality: quality,
        format: _compressFormatFor(source),
      );

      // 압축이 오히려 커지는 경우가 있다 (이미 최적화된 파일 등)
      if (compressed.length >= bytes.length) {
        return CompressionResult.original(bytes);
      }

      return CompressionResult(
        bytes: compressed,
        originalSize: bytes.length,
        compressed: true,
        // 결과 바이트를 다시 판정한다 — 요청한 포맷과 실제가 다를 수 있다
        mimeType: sniffImageMime(compressed) ?? ImageFormat.jpeg.mimeType,
      );
    } catch (e) {
      debugPrint('⚠️ [MediaCompressor] 이미지 압축 실패, 원본 사용: $e');
      return CompressionResult.original(bytes);
    }
  }

  /// 서버가 받지 않는 형식을 JPEG로 바꾼다 (해상도는 그대로)
  ///
  /// HEIC·AVIF·BMP처럼 화이트리스트 밖의 형식이 대상이다.
  /// 이미 받아주는 형식이면 **손대지 않고 그대로** 돌려준다.
  ///
  /// **변환하지 못하면 null이다.** 이때 호출자는 그 파일을 빼고 사용자에게
  /// 알려야 한다 — 원본을 그대로 올리면 서버가 400으로 막고, 사용자는 왜
  /// 실패했는지 알 수 없다. 안드로이드 HEIF 디코딩은 API 28부터라
  /// (이 앱의 `minSdk`는 24) 실제로 실패할 수 있는 경로다.
  static Future<Uint8List?> toUploadable(Uint8List bytes) async {
    final source = sniffImageFormat(bytes);
    if (allowedFormats.contains(source)) return bytes;

    // 웹에는 변환 수단이 없다 (Phase 2 미디어는 모바일 전용)
    if (kIsWeb) return null;

    try {
      final converted = await FlutterImageCompress.compressWithList(
        bytes,
        minWidth: _noDownscale,
        minHeight: _noDownscale,
        quality: transcodeQuality,
        format: CompressFormat.jpeg,
      );

      // 변환 결과도 바이트로 확인한다 — 디코딩에 실패하면 빈 데이터가 온다
      if (sniffImageFormat(converted) != ImageFormat.jpeg) {
        debugPrint('⚠️ [MediaCompressor] 변환 결과가 JPEG가 아님 (${source.name})');
        return null;
      }

      return converted;
    } catch (e) {
      debugPrint('⚠️ [MediaCompressor] 형식 변환 실패 (${source.name}): $e');
      return null;
    }
  }

  /// 업로드용 썸네일 (JPEG, 최대 변 640px, 품질 80 — 서버와 합의한 규격)
  ///
  /// 실패하면 null. 썸네일이 없어도 서버는 확정을 성공시키므로 업로드를 막지 않는다.
  static Future<Uint8List?> makeThumbnail(Uint8List bytes) async {
    if (kIsWeb) return null;

    try {
      return await FlutterImageCompress.compressWithList(
        bytes,
        minWidth: thumbnailDimension,
        minHeight: thumbnailDimension,
        quality: thumbnailQuality,
        format: CompressFormat.jpeg,
      );
    } catch (e) {
      debugPrint('⚠️ [MediaCompressor] 썸네일 생성 실패: $e');
      return null;
    }
  }

  /// 원본 형식을 유지하는 압축 포맷 (PNG·WebP만 유지, 나머지는 JPEG)
  static CompressFormat _compressFormatFor(ImageFormat source) =>
      switch (source) {
        ImageFormat.png => CompressFormat.png,
        ImageFormat.webp => CompressFormat.webp,
        _ => CompressFormat.jpeg,
      };
}
