import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';

import 'package:family_planner/core/services/api_service_base.dart';
import 'package:family_planner/core/constants/api_constants.dart';

/// 에디터 이미지 업로드 타입
enum EditorImageType {
  qna,
  announcements,
}

/// 에디터 이미지 업로드 응답
class EditorImageUploadResponse {
  /// 파일 키 (R2 스토리지 경로)
  final String key;

  /// 파일 URL
  final String url;

  EditorImageUploadResponse({
    required this.key,
    required this.url,
  });

  factory EditorImageUploadResponse.fromJson(Map<String, dynamic> json) {
    return EditorImageUploadResponse(
      key: json['key'] as String,
      url: json['url'] as String,
    );
  }
}

/// Storage Service
///
/// 파일 업로드/다운로드 관련 API를 처리합니다.
class StorageService extends ApiServiceBase {
  static StorageService? _instance;

  StorageService._internal();

  /// 싱글톤 인스턴스
  static StorageService get instance {
    _instance ??= StorageService._internal();
    return _instance!;
  }

  /// 에디터 이미지 업로드
  ///
  /// Q&A 또는 공지사항 에디터에서 이미지를 업로드합니다.
  ///
  /// [fileBytes]: 업로드할 이미지 파일의 바이트 데이터
  /// [fileName]: 파일 이름
  /// [type]: 이미지 타입 (qna, announcements)
  /// Returns: EditorImageUploadResponse (key, url)
  Future<EditorImageUploadResponse> uploadEditorImage({
    required List<int> fileBytes,
    required String fileName,
    required EditorImageType type,
  }) async {
    try {
      debugPrint('🔵 [StorageService] 에디터 이미지 업로드 - type: ${type.name}, fileName: $fileName');

      // 파일 확장자로 MIME 타입 결정
      final mimeType = _getMimeType(fileName);

      // FormData 생성 (웹과 모바일 모두 지원)
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          fileBytes,
          filename: fileName,
          contentType: MediaType.parse(mimeType),
        ),
      });

      final response = await apiClient.post(
        ApiConstants.editorUpload,
        data: formData,
        queryParameters: {'type': type.name},
      );

      final data = handleResponse<Map<String, dynamic>>(response);
      final result = EditorImageUploadResponse.fromJson(data);

      debugPrint('✅ [StorageService] 이미지 업로드 완료 - url: ${result.url}');
      return result;
    } catch (e) {
      debugPrint('❌ [StorageService] 이미지 업로드 실패: $e');
      throw handleError(e);
    }
  }

  /// 파일 확장자로 MIME 타입 결정
  String _getMimeType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'bmp':
        return 'image/bmp';
      case 'svg':
        return 'image/svg+xml';
      default:
        return 'image/jpeg'; // 기본값
    }
  }
}
