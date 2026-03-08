import 'package:flutter/material.dart';

import 'package:family_planner/features/ai_chat/presentation/widgets/ai_chat_bottom_sheet.dart';

/// AppBar actions에 삽입하는 AI 챗봇 아이콘 버튼
class AiChatIconButton extends StatelessWidget {
  const AiChatIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.auto_awesome),
      tooltip: 'AI 어시스턴트',
      onPressed: () => AiChatBottomSheet.show(context),
    );
  }
}
