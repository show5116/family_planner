import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/services/api_client.dart';
import 'package:family_planner/features/ai_chat/data/models/ai_chat_model.dart';

final aiChatRepositoryProvider = Provider<AiChatRepository>((ref) {
  return AiChatRepository();
});

class AiChatRepository {
  final Dio _dio = ApiClient.instance.dio;

  Future<AiChatResponse> sendMessage(AiChatRequestDto dto) async {
    try {
      final response = await _dio.post('/ai/chat', data: dto.toJson());
      return AiChatResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('❌ [AiChatRepository] 메시지 전송 실패: ${e.message}');
      throw Exception('AI 채팅 오류: ${e.message}');
    }
  }
}
