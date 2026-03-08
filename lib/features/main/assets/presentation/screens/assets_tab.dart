import 'package:flutter/material.dart';

import 'package:family_planner/features/ai_chat/presentation/widgets/ai_chat_icon_button.dart';

/// 자산 관리 탭
class AssetsTab extends StatelessWidget {
  const AssetsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('자산'),
        actions: const [AiChatIconButton()],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_wallet,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              '자산 관리',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            const Text('자산 관리 기능이 여기에 표시됩니다'),
          ],
        ),
      ),
    );
  }
}
