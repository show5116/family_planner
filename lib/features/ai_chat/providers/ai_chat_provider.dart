import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:family_planner/features/ai_chat/data/models/ai_chat_model.dart';
import 'package:family_planner/features/ai_chat/data/repositories/ai_chat_repository.dart';

part 'ai_chat_provider.g.dart';

/// 현재 채팅방 ID
final aiChatRoomIdProvider = StateProvider<String?>((ref) => null);

/// 채팅 메시지 목록 + 전송 로직
@riverpod
class AiChat extends _$AiChat {
  @override
  List<AiChatMessage> build() => [];

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // 사용자 메시지 즉시 추가
    state = [...state, AiChatMessage.user(text)];

    final roomId = ref.read(aiChatRoomIdProvider);
    final repository = ref.read(aiChatRepositoryProvider);

    try {
      final response = await repository.sendMessage(
        AiChatRequestDto(
          message: text,
          roomId: roomId,
        ),
      );

      // 처음 응답에서 room_id 저장
      if (roomId == null && response.roomId.isNotEmpty) {
        ref.read(aiChatRoomIdProvider.notifier).state = response.roomId;
      }

      state = [...state, AiChatMessage.assistant(response.message)];
    } catch (e) {
      state = [
        ...state,
        AiChatMessage.assistant('죄송합니다. 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.'),
      ];
    }
  }

  void reset() {
    state = [];
    ref.read(aiChatRoomIdProvider.notifier).state = null;
  }
}

/// AI 응답 로딩 상태
@riverpod
class AiChatLoading extends _$AiChatLoading {
  @override
  bool build() => false;

  void setLoading(bool value) => state = value;
}
