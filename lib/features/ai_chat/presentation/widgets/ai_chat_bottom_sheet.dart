import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/ai_chat/data/models/ai_chat_model.dart';
import 'package:family_planner/features/ai_chat/providers/ai_chat_provider.dart';

/// 추천 질문 목록. 번역이 필요해 const로 둘 수 없다.
List<String> _suggestedQuestions(AppLocalizations l10n) => [
  l10n.ai_suggest1,
  l10n.ai_suggest2,
  l10n.ai_suggest3,
  l10n.ai_suggest4,
  l10n.ai_suggest5,
  l10n.ai_suggest6,
];

/// AI 챗봇 바텀 시트
///
/// 사용법:
/// ```dart
/// AiChatBottomSheet.show(context);
/// ```
class AiChatBottomSheet extends ConsumerStatefulWidget {
  const AiChatBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => const AiChatBottomSheet(),
    );
  }

  @override
  ConsumerState<AiChatBottomSheet> createState() => _AiChatBottomSheetState();
}

class _AiChatBottomSheetState extends ConsumerState<AiChatBottomSheet> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isSending = false;

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty || _isSending) return;
    _textController.clear();
    setState(() => _isSending = true);

    await ref.read(aiChatProvider.notifier).sendMessage(text);

    if (mounted) {
      setState(() => _isSending = false);
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(aiChatProvider);
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (_, sc) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppSizes.radiusXLarge),
            ),
          ),
          child: Column(
            children: [
              _buildHandle(),
              _buildHeader(context, theme),
              const Divider(height: 1),
              Expanded(
                child: messages.isEmpty
                    ? _buildEmptyState(theme)
                    : _buildMessageList(messages, theme),
              ),
              _buildSuggestedQuestions(theme),
              _buildInputBar(theme),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHandle() {
    return Padding(
      padding: const EdgeInsets.only(top: AppSizes.spaceS),
      child: Center(
        child: Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceM,
        vertical: AppSizes.spaceS,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSizes.spaceS),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.ai_assistant,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                l10n.ai_ask_anything,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            tooltip: l10n.ai_reset_chat,
            onPressed: () => ref.read(aiChatProvider.notifier).reset(),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            tooltip: l10n.common_close,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
          ),
          const SizedBox(height: AppSizes.spaceM),
          Text(
            l10n.ai_greeting,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSizes.spaceXS),
          Text(
            l10n.ai_greeting_desc,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList(List<AiChatMessage> messages, ThemeData theme) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceM,
        vertical: AppSizes.spaceS,
      ),
      itemCount: messages.length + (_isSending ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == messages.length) {
          return _buildTypingIndicator(theme);
        }
        return _buildMessageBubble(messages[index], theme);
      },
    );
  }

  Widget _buildSessionDivider(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(child: Divider(color: theme.colorScheme.outlineVariant)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              l10n.ai_new_chat,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(child: Divider(color: theme.colorScheme.outlineVariant)),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(AiChatMessage message, ThemeData theme) {
    final isUser = message.role == AiMessageRole.user;

    return Column(
      children: [
        if (message.isSessionStart) _buildSessionDivider(theme),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment:
                isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isUser) ...[
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: AppColors.primary,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 6),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.spaceM,
                    vertical: AppSizes.spaceS,
                  ),
                  decoration: BoxDecoration(
                    color: isUser
                        ? AppColors.primary
                        : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(AppSizes.radiusMedium),
                      topRight: const Radius.circular(AppSizes.radiusMedium),
                      bottomLeft:
                          Radius.circular(isUser ? AppSizes.radiusMedium : 4),
                      bottomRight:
                          Radius.circular(isUser ? 4 : AppSizes.radiusMedium),
                    ),
                  ),
                  child: Text(
                    message.content,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isUser ? Colors.white : theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
              if (isUser) const SizedBox(width: 34),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTypingIndicator(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: AppColors.primary,
              size: 16,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppSizes.radiusMedium),
                topRight: Radius.circular(AppSizes.radiusMedium),
                bottomRight: Radius.circular(AppSizes.radiusMedium),
                bottomLeft: Radius.circular(4),
              ),
            ),
            child: Row(
              children: [
                _buildDot(theme),
                const SizedBox(width: 4),
                _buildDot(theme),
                const SizedBox(width: 4),
                _buildDot(theme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(ThemeData theme) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.4, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: theme.colorScheme.onSurfaceVariant,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestedQuestions(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    final messages = ref.watch(aiChatProvider);
    if (messages.isNotEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceM),
      child: Wrap(
        spacing: AppSizes.spaceXS,
        runSpacing: AppSizes.spaceXS,
        children: _suggestedQuestions(l10n).map((question) {
          return ActionChip(
            label: Text(question, style: theme.textTheme.bodySmall),
            onPressed: () => _sendMessage(question),
            backgroundColor: AppColors.primary.withValues(alpha: 0.08),
            side: BorderSide(color: AppColors.primary.withValues(alpha: 0.3)),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInputBar(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceM,
        vertical: AppSizes.spaceS,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(color: theme.dividerColor),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: l10n.ai_message_hint,
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spaceM,
                  vertical: AppSizes.spaceS,
                ),
                isDense: true,
              ),
              minLines: 1,
              maxLines: 4,
              textInputAction: TextInputAction.send,
              onSubmitted: _sendMessage,
            ),
          ),
          const SizedBox(width: AppSizes.spaceS),
          FilledButton.icon(
            onPressed:
                _isSending ? null : () => _sendMessage(_textController.text),
            icon: _isSending
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send, size: 18),
            label: Text(l10n.ai_send),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spaceM,
                vertical: AppSizes.spaceS,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
