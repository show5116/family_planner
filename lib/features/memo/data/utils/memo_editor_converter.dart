import 'dart:convert';

import 'package:flutter_quill/flutter_quill.dart';

/// MemoEditorConverter
///
/// Quill Document ↔ Delta JSON 문자열 변환.
/// content 필드에 Delta JSON을 통째로 저장하는 방식에 대응합니다.
class MemoEditorConverter {
  MemoEditorConverter._();

  /// Delta JSON 문자열 → Quill Document
  static Document toDocument(String deltaJson) {
    if (deltaJson.isEmpty) return Document();
    try {
      final ops = jsonDecode(deltaJson);
      if (ops is List) {
        return Document.fromJson(ops);
      }
      // {ops: [...]} 형태도 허용
      if (ops is Map && ops['ops'] is List) {
        return Document.fromJson(ops['ops'] as List);
      }
      return Document();
    } catch (_) {
      // 파싱 실패 시 plain text로 fallback
      try {
        return Document()..insert(0, deltaJson);
      } catch (_) {
        return Document();
      }
    }
  }

  /// Quill Document → Delta JSON 문자열
  static String fromDocument(Document document) {
    try {
      final ops = document.toDelta().toJson();
      return jsonEncode(ops);
    } catch (_) {
      return '';
    }
  }

  /// Delta JSON 문자열에서 체크리스트 진행률 추출 (목록 카드용)
  /// 반환: (checked, total)
  static (int checked, int total) checklistProgress(String deltaJson) {
    if (deltaJson.isEmpty) return (0, 0);
    try {
      final decoded = jsonDecode(deltaJson);
      final ops = decoded is List
          ? decoded
          : (decoded is Map ? decoded['ops'] as List? ?? [] : []);

      int total = 0;
      int checked = 0;
      for (final raw in ops) {
        final op = raw as Map;
        final attrs = (op['attributes'] as Map?)?.cast<String, dynamic>() ?? {};
        final list = attrs['list'] as String?;
        if (list == 'unchecked') total++;
        if (list == 'checked') {
          total++;
          checked++;
        }
      }
      return (checked, total);
    } catch (_) {
      return (0, 0);
    }
  }

  /// Delta JSON 문자열에서 plain text 미리보기 추출 (목록 카드용)
  static String plainTextPreview(String deltaJson, {int maxLength = 100}) {
    if (deltaJson.isEmpty) return '';
    try {
      final decoded = jsonDecode(deltaJson);
      final ops = decoded is List
          ? decoded
          : (decoded is Map ? decoded['ops'] as List? ?? [] : []);

      final buffer = StringBuffer();
      for (final raw in ops) {
        final insert = (raw as Map)['insert'];
        if (insert is String) buffer.write(insert);
        if (buffer.length >= maxLength) break;
      }
      return buffer
          .toString()
          .replaceAll('\n', ' ')
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim()
          .substring(0, buffer.length.clamp(0, maxLength));
    } catch (_) {
      return '';
    }
  }
}
