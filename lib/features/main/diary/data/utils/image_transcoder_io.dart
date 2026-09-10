import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:family_planner/core/utils/image_format.dart';

/// 이미지를 다시 인코딩한다 (실패하면 null)
///
/// [maxDimension]이 0 이하면 크기를 줄이지 않고 형식만 바꾼다.
/// 원본보다 크게 늘리지는 않는다.
Future<Uint8List?> reencodeImage(
  Uint8List bytes, {
  required ImageFormat target,
  required int maxDimension,
  required int quality,
}) async {
  // flutter_image_compress는 원본보다 확대하지 않으므로, 축소를 원하지 않을 때는
  // 충분히 큰 값을 주면 된다.
  final limit = maxDimension > 0 ? maxDimension : 20000;

  try {
    final result = await FlutterImageCompress.compressWithList(
      bytes,
      minWidth: limit,
      minHeight: limit,
      quality: quality,
      format: switch (target) {
        ImageFormat.png => CompressFormat.png,
        ImageFormat.webp => CompressFormat.webp,
        _ => CompressFormat.jpeg,
      },
    );
    return result;
  } catch (e) {
    debugPrint('⚠️ [ImageTranscoder] 재인코딩 실패: $e');
    return null;
  }
}
