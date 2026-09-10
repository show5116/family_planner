import 'dart:ui' as ui;

import 'package:exif/exif.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import 'package:family_planner/core/utils/image_format.dart';
import 'package:family_planner/features/main/diary/data/models/diary_media_models.dart';
import 'package:family_planner/features/main/diary/data/utils/media_compressor.dart';

/// 파일 선택 결과
///
/// 못 올리는 파일을 조용히 버리지 않는다 — 사용자는 3장을 골랐는데 2장만
/// 올라간 이유를 알아야 한다.
class PickResult {
  /// 업로드 가능한 형식임이 보장된 항목
  final List<PickedMedia> items;

  /// 형식을 바꾸지 못해 뺀 파일 이름
  final List<String> rejectedFileNames;

  const PickResult({this.items = const [], this.rejectedFileNames = const []});

  bool get isEmpty => items.isEmpty && rejectedFileNames.isEmpty;
  bool get hasRejected => rejectedFileNames.isNotEmpty;
}

/// 사용자가 고른 파일 (압축 전)
///
/// 압축 여부는 사용자가 시트에서 고르므로, 여기서는 바이트와 메타데이터만
/// 들고 온다. 가로세로는 서버가 그리드 비율을 잡는 데 쓰므로 미리 읽어둔다.
///
/// [bytes]는 **서버가 받아주는 형식임이 보장된다** — 선택 시점에 한 번
/// 정규화하므로 아래쪽 코드는 형식을 신경 쓸 필요가 없다.
class PickedMedia {
  final Uint8List bytes;
  final String fileName;
  final String mimeType;
  final MediaType type;
  final int? width;
  final int? height;

  /// EXIF에 적힌 촬영 시각 (없으면 null)
  ///
  /// "어제 사진을 오늘 올리는" 경우를 알아채는 데만 쓴다. 스크린샷이나 남이 보낸
  /// 이미지는 EXIF가 없거나 엉뚱하므로, 이 값으로 **자동 분류하지 않고 물어본다**.
  final DateTime? capturedAt;

  const PickedMedia({
    required this.bytes,
    required this.fileName,
    required this.mimeType,
    required this.type,
    this.width,
    this.height,
    this.capturedAt,
  });

  int get size => bytes.length;
}

/// 다이어리 미디어 선택
///
/// Phase 2는 이미지 전용이다 (영상은 `video_compress` 도입 후 Phase 3).
class DiaryMediaPicker {
  DiaryMediaPicker._();

  static final ImagePicker _picker = ImagePicker();

  /// 갤러리에서 여러 장 고르기
  static Future<PickResult> pickImages() async {
    final files = await _picker.pickMultiImage();
    return _readAll(files);
  }

  /// 카메라로 한 장 찍기
  static Future<PickResult> takePhoto() async {
    final file = await _picker.pickImage(source: ImageSource.camera);
    if (file == null) return const PickResult();
    return _readAll([file]);
  }

  /// 고른 파일을 읽고 **업로드 가능한 형식으로 정규화**한다
  ///
  /// 정규화를 여기 한 곳에서 하는 이유: 압축·시트·업로드가 각자 형식을 신경 쓰면
  /// 나중에 한 곳만 고쳐지는 사고가 난다. 경계에서 한 번 보장하고 끝낸다.
  static Future<PickResult> _readAll(List<XFile> files) async {
    final items = <PickedMedia>[];
    final rejected = <String>[];

    for (final file in files) {
      try {
        final original = await file.readAsBytes();

        // EXIF는 **변환 전 원본**에서 읽는다 — 재인코딩하면 날아간다
        final capturedAt = await _resolveCapturedAt(original);

        final bytes = await MediaCompressor.toUploadable(original);
        if (bytes == null) {
          // 서버가 400을 주게 두지 않는다. 여기서 빼고 사용자에게 알린다.
          debugPrint('⚠️ [DiaryMediaPicker] 형식 변환 실패로 제외: ${file.name}');
          rejected.add(file.name);
          continue;
        }

        // 크기는 **변환 후** 바이트에서 읽는다.
        // Flutter 디코더는 HEIC를 못 열어서 원본으로는 읽히지 않는다.
        final size = await _resolveSize(bytes);
        final format = sniffImageFormat(bytes);

        items.add(PickedMedia(
          bytes: bytes,
          fileName: _fileNameFor(file.name, format),
          // 파일명이나 플랫폼 값이 아니라 **바이트에서 읽어낸** 형식을 신고한다
          mimeType: format.mimeType,
          type: MediaType.image,
          width: size?.width.round(),
          height: size?.height.round(),
          capturedAt: capturedAt,
        ));
      } catch (e) {
        // 한 장 읽기에 실패해도 나머지는 올릴 수 있어야 한다
        debugPrint('⚠️ [DiaryMediaPicker] 파일 읽기 실패: $e');
        rejected.add(file.name);
      }
    }

    return PickResult(items: items, rejectedFileNames: rejected);
  }

  /// 실제 형식에 맞춘 파일명
  ///
  /// 변환했는데 이름이 `IMG_1234.heic`으로 남아 있으면, 나중에 확장자를 보고
  /// 판단하는 코드(다운로드·내보내기)가 다시 속는다.
  static String _fileNameFor(String fileName, ImageFormat format) {
    if (format.extension.isEmpty) return fileName;

    final dot = fileName.lastIndexOf('.');
    final base = dot > 0 ? fileName.substring(0, dot) : fileName;
    final current = dot > 0 ? fileName.substring(dot + 1).toLowerCase() : '';

    // jpg/jpeg처럼 같은 형식을 가리키면 원래 이름을 존중한다
    if (current == format.extension) return fileName;
    if (format == ImageFormat.jpeg && current == 'jpeg') return fileName;

    return '$base.${format.extension}';
  }

  /// 이미지 크기를 읽는다 (실패하면 null — 크기는 부가 정보다)
  static Future<ui.Size?> _resolveSize(Uint8List bytes) async {
    try {
      final descriptor = await ui.ImageDescriptor.encoded(
        await ui.ImmutableBuffer.fromUint8List(bytes),
      );
      final size = ui.Size(
        descriptor.width.toDouble(),
        descriptor.height.toDouble(),
      );
      descriptor.dispose();
      return size;
    } catch (e) {
      debugPrint('⚠️ [DiaryMediaPicker] 이미지 크기 확인 실패: $e');
      return null;
    }
  }

  /// EXIF에서 촬영 시각을 읽는다 (없거나 못 읽으면 null)
  ///
  /// EXIF는 타임존 정보를 담지 않는다 — 찍은 기기의 벽시계 시각이다.
  /// 그래서 UTC 변환 없이 **로컬 시각 그대로** 해석한다. 사용자가 "9월 1일에
  /// 찍었다"고 기억하는 것도 그 벽시계 기준이다.
  static Future<DateTime?> _resolveCapturedAt(Uint8List bytes) async {
    try {
      final tags = await readExifFromBytes(bytes);
      if (tags.isEmpty) return null;

      // DateTimeOriginal(촬영 시각)이 정확하다. DateTimeDigitized는 스캔·복사
      // 시각이라 어긋날 수 있어 차선으로만 쓴다.
      final raw = (tags['EXIF DateTimeOriginal'] ??
              tags['EXIF DateTimeDigitized'] ??
              tags['Image DateTime'])
          ?.printable
          .trim();
      if (raw == null || raw.isEmpty) return null;

      return _parseExifDateTime(raw);
    } catch (e) {
      debugPrint('⚠️ [DiaryMediaPicker] EXIF 읽기 실패: $e');
      return null;
    }
  }

  /// EXIF 날짜 형식 파싱 ('YYYY:MM:DD HH:MM:SS')
  ///
  /// 값이 비어 있는 카메라가 있어 ('0000:00:00 00:00:00') 결과를 검증한다.
  static DateTime? _parseExifDateTime(String raw) {
    final match = RegExp(
      r'^(\d{4}):(\d{2}):(\d{2})[ T](\d{2}):(\d{2}):(\d{2})',
    ).firstMatch(raw);
    if (match == null) return null;

    final year = int.parse(match.group(1)!);
    final month = int.parse(match.group(2)!);
    final day = int.parse(match.group(3)!);
    if (year < 1900 || month < 1 || month > 12 || day < 1 || day > 31) {
      return null;
    }

    return DateTime(
      year,
      month,
      day,
      int.parse(match.group(4)!),
      int.parse(match.group(5)!),
      int.parse(match.group(6)!),
    );
  }
}
