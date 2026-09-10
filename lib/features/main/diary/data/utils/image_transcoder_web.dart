import 'dart:async';
import 'dart:js_interop';

import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;

import 'package:family_planner/core/utils/image_format.dart';

/// 이미지를 다시 인코딩한다 (실패하면 null)
///
/// 브라우저 캔버스를 쓴다 — 디코딩·리샘플링·인코딩이 전부 네이티브라
/// 큰 사진도 UI를 막지 않는다.
///
/// 브라우저가 못 여는 형식(Chrome·Firefox의 HEIC)은 `createImageBitmap`이
/// 던지므로 null이 되고, 호출부가 그 파일을 빼고 사용자에게 알린다.
Future<Uint8List?> reencodeImage(
  Uint8List bytes, {
  required ImageFormat target,
  required int maxDimension,
  required int quality,
}) async {
  web.ImageBitmap? bitmap;

  try {
    final blob = web.Blob(
      [bytes.toJS].toJS,
      web.BlobPropertyBag(type: 'application/octet-stream'),
    );

    // ★ imageOrientation: 'from-image'가 없으면 EXIF 회전이 무시되어
    //   세로로 찍은 사진이 눕는다. 모바일에서는 플랫폼 코덱이 알아서
    //   처리해주기 때문에 웹에서만 터지는 함정이다.
    bitmap = await web.window
        .createImageBitmap(
          blob,
          web.ImageBitmapOptions(imageOrientation: 'from-image'),
        )
        .toDart;

    final (width, height) = _fit(bitmap.width, bitmap.height, maxDimension);

    final canvas = web.document.createElement('canvas') as web.HTMLCanvasElement
      ..width = width
      ..height = height;

    final context = canvas.getContext('2d') as web.CanvasRenderingContext2D?;
    if (context == null) {
      debugPrint('⚠️ [ImageTranscoder] 2d 컨텍스트를 얻지 못했다');
      return null;
    }

    context.drawImage(bitmap, 0, 0, width.toDouble(), height.toDouble());

    final encoded = await _toBlob(canvas, target.mimeType, quality / 100);
    if (encoded == null) return null;

    final buffer = await encoded.arrayBuffer().toDart;
    return buffer.toDart.asUint8List();
  } catch (e) {
    // 브라우저가 못 여는 형식이면 여기로 온다 (Chrome·Firefox의 HEIC 등)
    debugPrint('⚠️ [ImageTranscoder] 재인코딩 실패: $e');
    return null;
  } finally {
    bitmap?.close();
  }
}

/// 긴 변이 [maxDimension]을 넘지 않도록 줄인다 (확대하지 않는다)
///
/// [maxDimension]이 0 이하면 원본 크기를 유지한다.
(int, int) _fit(int width, int height, int maxDimension) {
  if (maxDimension <= 0) return (width, height);

  final longest = width > height ? width : height;
  if (longest <= maxDimension) return (width, height);

  final scale = maxDimension / longest;
  return (
    (width * scale).round().clamp(1, maxDimension),
    (height * scale).round().clamp(1, maxDimension),
  );
}

/// `toBlob`은 콜백 기반이라 Future로 감싼다
///
/// `OffscreenCanvas.convertToBlob`이 더 깔끔하지만 Safari 16.4 미만이 못 쓴다.
/// 여기서 형식을 하나 놓치면 그 브라우저 사용자는 첨부를 통째로 못 하게 되므로
/// 넓게 지원되는 쪽을 쓴다.
Future<web.Blob?> _toBlob(
  web.HTMLCanvasElement canvas,
  String mimeType,
  double quality,
) {
  final completer = Completer<web.Blob?>();

  canvas.toBlob(
    (web.Blob? blob) {
      if (!completer.isCompleted) completer.complete(blob);
    }.toJS,
    mimeType,
    quality.toJS,
  );

  return completer.future.timeout(
    const Duration(seconds: 20),
    onTimeout: () {
      debugPrint('⚠️ [ImageTranscoder] 인코딩 타임아웃');
      return null;
    },
  );
}
