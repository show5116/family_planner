/// 이미지 형식 — **파일명이 아니라 바이트로** 판정한다
///
/// 확장자는 거짓일 수 있다. 메신저로 받은 `.jpg`가 실제로는 WebP이거나,
/// 이름만 바꾼 스크린샷이거나, 공유 인텐트로 들어온 `image/*`가 그렇다.
/// 형식을 잘못 신고하면 서버 검증에서 막히거나, 더 나쁘게는 저장된 뒤에야
/// "표시할 수 없는 파일"이 된다.
library;

import 'package:flutter/foundation.dart';

/// 판별 가능한 이미지 컨테이너
enum ImageFormat {
  jpeg('image/jpeg', 'jpg'),
  png('image/png', 'png'),
  gif('image/gif', 'gif'),
  webp('image/webp', 'webp'),
  bmp('image/bmp', 'bmp'),

  /// HEIC/HEIF/AVIF 계열 (ISO-BMFF)
  heic('image/heic', 'heic'),

  /// 판별하지 못한 바이트
  unknown('application/octet-stream', '');

  const ImageFormat(this.mimeType, this.extension);

  final String mimeType;
  final String extension;

  /// **Flutter 내장 디코더가 화면에 그릴 수 있는가**
  ///
  /// HEIC는 플랫폼 코덱(Android `BitmapFactory` / iOS Core Image)으로 *변환*은
  /// 되지만 Flutter가 *표시*하지는 못한다. 그래서 저장소에 HEIC를 올려두면
  /// 뷰어가 모든 플랫폼에서 깨진다 — 올리기 전에 바꿔야 하는 진짜 이유다.
  bool get isDisplayable => switch (this) {
        ImageFormat.jpeg ||
        ImageFormat.png ||
        ImageFormat.gif ||
        ImageFormat.webp ||
        ImageFormat.bmp =>
          true,
        ImageFormat.heic || ImageFormat.unknown => false,
      };
}

/// 앞부분 바이트로 이미지 형식을 판정한다 (매직 넘버)
///
/// 판별에 필요한 건 12바이트뿐이라 큰 파일이어도 비용이 없다.
ImageFormat sniffImageFormat(Uint8List bytes) {
  if (bytes.length < 12) return ImageFormat.unknown;

  // JPEG — FF D8 FF
  if (bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF) {
    return ImageFormat.jpeg;
  }

  // PNG — 89 50 4E 47 0D 0A 1A 0A
  const png = [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A];
  if (_matchesBytes(bytes, 0, png)) return ImageFormat.png;

  // GIF — 'GIF87a' / 'GIF89a'
  if (_matchesAscii(bytes, 0, 'GIF8')) return ImageFormat.gif;

  // WebP — 'RIFF' ???? 'WEBP'
  if (_matchesAscii(bytes, 0, 'RIFF') && _matchesAscii(bytes, 8, 'WEBP')) {
    return ImageFormat.webp;
  }

  // BMP — 'BM'
  if (_matchesAscii(bytes, 0, 'BM')) return ImageFormat.bmp;

  // ISO-BMFF — [4..8]이 'ftyp'이고 [8..12]가 HEIF 계열 브랜드
  if (_matchesAscii(bytes, 4, 'ftyp') && _isHeifBrand(bytes)) {
    return ImageFormat.heic;
  }

  return ImageFormat.unknown;
}

/// 바이트에서 읽어낸 MIME (판별 실패 시 null)
///
/// 서버에 신고할 값은 **언제나 여기서** 가져온다. 변환을 거쳤다면 변환 결과를
/// 다시 넣어 판정한다 — 추론이 아니라 관측이어야 검증과 어긋나지 않는다.
String? sniffImageMime(Uint8List bytes) {
  final format = sniffImageFormat(bytes);
  return format == ImageFormat.unknown ? null : format.mimeType;
}

/// HEIF 계열 브랜드인지 ([8..12]의 major brand)
///
/// `ftyp`만 보면 MP4·MOV도 걸리므로 브랜드까지 확인한다.
bool _isHeifBrand(Uint8List bytes) {
  const brands = {
    'heic', 'heix', 'heim', 'heis', // 이미지
    'hevc', 'hevx', 'hevm', 'hevs', // 시퀀스
    'mif1', 'msf1', // 일반 HEIF
    'avif', 'avis', // AVIF (같은 컨테이너, Flutter가 못 그리는 것도 같다)
  };

  final brand = String.fromCharCodes(bytes.sublist(8, 12));
  return brands.contains(brand);
}

bool _matchesBytes(Uint8List bytes, int offset, List<int> pattern) {
  if (bytes.length < offset + pattern.length) return false;
  for (var i = 0; i < pattern.length; i++) {
    if (bytes[offset + i] != pattern[i]) return false;
  }
  return true;
}

bool _matchesAscii(Uint8List bytes, int offset, String pattern) =>
    _matchesBytes(bytes, offset, pattern.codeUnits);
