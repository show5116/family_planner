import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:family_planner/core/utils/image_format.dart';

/// 헤더만 있으면 판정된다 — 뒤는 아무 값이나 채운다
Uint8List _header(List<int> head, {int length = 32}) {
  final bytes = Uint8List(length);
  for (var i = 0; i < head.length && i < length; i++) {
    bytes[i] = head[i];
  }
  return bytes;
}

Uint8List _isoBmff(String brand) {
  final bytes = Uint8List(32);
  // [0..4] box size (아무 값), [4..8] 'ftyp', [8..12] major brand
  bytes.setRange(4, 8, 'ftyp'.codeUnits);
  bytes.setRange(8, 12, brand.codeUnits);
  return bytes;
}

void main() {
  group('sniffImageFormat', () {
    test('JPEG 헤더를 판정한다', () {
      expect(
        sniffImageFormat(_header([0xFF, 0xD8, 0xFF, 0xE0])),
        ImageFormat.jpeg,
      );
    });

    test('PNG 헤더를 판정한다', () {
      expect(
        sniffImageFormat(
          _header([0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]),
        ),
        ImageFormat.png,
      );
    });

    test('GIF 헤더를 판정한다', () {
      expect(sniffImageFormat(_header('GIF89a'.codeUnits)), ImageFormat.gif);
      expect(sniffImageFormat(_header('GIF87a'.codeUnits)), ImageFormat.gif);
    });

    test('WebP는 RIFF와 WEBP를 함께 확인한다', () {
      final webp = Uint8List(32);
      webp.setRange(0, 4, 'RIFF'.codeUnits);
      webp.setRange(8, 12, 'WEBP'.codeUnits);
      expect(sniffImageFormat(webp), ImageFormat.webp);

      // RIFF만 있고 WEBP가 아니면(WAV 등) WebP가 아니다
      final wav = Uint8List(32);
      wav.setRange(0, 4, 'RIFF'.codeUnits);
      wav.setRange(8, 12, 'WAVE'.codeUnits);
      expect(sniffImageFormat(wav), ImageFormat.unknown);
    });

    test('BMP 헤더를 판정한다', () {
      expect(sniffImageFormat(_header('BM'.codeUnits)), ImageFormat.bmp);
    });

    test('HEIF 계열 브랜드를 판정한다', () {
      for (final brand in ['heic', 'heix', 'mif1', 'msf1', 'hevc', 'avif']) {
        expect(sniffImageFormat(_isoBmff(brand)), ImageFormat.heic,
            reason: 'brand=$brand');
      }
    });

    test('ftyp이지만 HEIF가 아닌 브랜드는 걸러낸다', () {
      // MP4·MOV도 ftyp을 쓴다. 브랜드까지 봐야 오탐이 없다.
      for (final brand in ['isom', 'mp42', 'qt  ']) {
        expect(sniffImageFormat(_isoBmff(brand)), ImageFormat.unknown,
            reason: 'brand=$brand');
      }
    });

    test('너무 짧은 데이터는 unknown이다', () {
      expect(sniffImageFormat(Uint8List.fromList([0xFF, 0xD8])),
          ImageFormat.unknown);
      expect(sniffImageFormat(Uint8List(0)), ImageFormat.unknown);
    });

    test('알 수 없는 바이트는 unknown이다', () {
      expect(sniffImageFormat(Uint8List(32)), ImageFormat.unknown);
    });
  });

  group('sniffImageMime', () {
    test('판정된 형식의 MIME을 준다', () {
      expect(
        sniffImageMime(_header([0xFF, 0xD8, 0xFF])),
        'image/jpeg',
      );
    });

    test('판정하지 못하면 null이다 — 추측하지 않는다', () {
      expect(sniffImageMime(Uint8List(32)), isNull);
    });
  });

  group('isDisplayable', () {
    test('Flutter가 그릴 수 있는 형식만 true다', () {
      expect(ImageFormat.jpeg.isDisplayable, isTrue);
      expect(ImageFormat.png.isDisplayable, isTrue);
      expect(ImageFormat.gif.isDisplayable, isTrue);
      expect(ImageFormat.webp.isDisplayable, isTrue);
      expect(ImageFormat.bmp.isDisplayable, isTrue);
    });

    test('HEIC는 변환 대상이다 — 저장하면 뷰어가 깨진다', () {
      expect(ImageFormat.heic.isDisplayable, isFalse);
      expect(ImageFormat.unknown.isDisplayable, isFalse);
    });
  });
}
