import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/services/api_client.dart';
import 'package:family_planner/features/memo/data/models/link_preview_model.dart';

final linkPreviewRepositoryProvider =
    Provider<LinkPreviewRepository>((_) => LinkPreviewRepository());

class LinkPreviewRepository {
  final Dio _dio = ApiClient.instance.dio;

  Future<LinkPreviewModel?> fetchPreview(String url) async {
    try {
      final response = await _dio.get(
        '/link-preview',
        queryParameters: {'url': url},
      );
      return LinkPreviewModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [LinkPreview] fetch 실패: ${e.message}');
      return null;
    }
  }
}
