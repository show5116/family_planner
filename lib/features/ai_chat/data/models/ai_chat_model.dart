/// AI 챗봇 메시지 역할
enum AiMessageRole { user, assistant }

/// AI 채팅 메시지 모델
class AiChatMessage {
  final AiMessageRole role;
  final String content;
  final DateTime createdAt;

  const AiChatMessage({
    required this.role,
    required this.content,
    required this.createdAt,
  });

  factory AiChatMessage.user(String content) => AiChatMessage(
        role: AiMessageRole.user,
        content: content,
        createdAt: DateTime.now(),
      );

  factory AiChatMessage.assistant(String content) => AiChatMessage(
        role: AiMessageRole.assistant,
        content: content,
        createdAt: DateTime.now(),
      );
}

/// AI 채팅 응답 모델
class AiChatResponse {
  final String message;
  final String roomId;
  final String? agent;

  const AiChatResponse({
    required this.message,
    required this.roomId,
    this.agent,
  });

  factory AiChatResponse.fromJson(Map<String, dynamic> json) {
    return AiChatResponse(
      message: json['message'] as String? ?? '',
      roomId: json['room_id'] as String? ?? '',
      agent: json['agent'] as String?,
    );
  }
}

/// AI 채팅 요청 DTO
class AiChatRequestDto {
  final String message;
  final String? roomId;
  final String? targetAgent;

  const AiChatRequestDto({
    required this.message,
    this.roomId,
    this.targetAgent,
  });

  Map<String, dynamic> toJson() => {
        'message': message,
        if (roomId != null) 'room_id': roomId,
        if (targetAgent != null) 'target_agent': targetAgent,
      };
}
