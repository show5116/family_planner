import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/main/diary/providers/diary_provider.dart';
import 'package:family_planner/features/main/diary/providers/quick_capture_provider.dart';

/// 빠른 기록 바 — 하단 고정 입력창
///
/// 이 기능의 핵심. 한 줄 쓰고 보내면 화면 전환 없이 그날 일기에 이어붙는다.
/// 기분·날씨·공개범위를 여기서 묻지 않는다 — 묻는 순간 빠른 기록이 아니게 된다.
class QuickCaptureBar extends ConsumerStatefulWidget {
  const QuickCaptureBar({super.key});

  @override
  ConsumerState<QuickCaptureBar> createState() => _QuickCaptureBarState();
}

class _QuickCaptureBarState extends ConsumerState<QuickCaptureBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    // 낙관적으로 입력창을 먼저 비운다 — 실패하면 아래에서 되돌린다
    _controller.clear();

    final ok = await ref.read(quickCaptureProvider.notifier).send(text);

    if (!ok && mounted) {
      // 조용히 날리지 않는다: 입력을 되돌리고 사용자가 다시 시도할 수 있게 한다
      _controller.text = text;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: text.length),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final captureState = ref.watch(quickCaptureProvider);

    // 오늘 일기가 이미 있으면 "이어서 기록"임을 문구로 알린다
    final hasTodayDiary =
        ref.watch(todayDiaryProvider).valueOrNull != null;
    final hint = hasTodayDiary
        ? l10n.diary_capture_hint_continue
        : l10n.diary_capture_hint;

    return Material(
      color: colorScheme.surface,
      elevation: AppSizes.elevation3,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (captureState.hasFailure) _FailureBanner(
              onRetry: () => ref.read(quickCaptureProvider.notifier).retry(),
              onDismiss: () =>
                  ref.read(quickCaptureProvider.notifier).dismissFailure(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.spaceM,
                AppSizes.spaceS,
                AppSizes.spaceS,
                AppSizes.spaceS,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      minLines: 1,
                      maxLines: 4,
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      style: theme.textTheme.bodyMedium,
                      decoration: InputDecoration(
                        hintText: hint,
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: AppSizes.spaceS,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.spaceS),
                  _SendButton(
                    isSending: captureState.isSending,
                    onPressed: _send,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({required this.isSending, required this.onPressed});

  final bool isSending;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    if (isSending) {
      return const SizedBox(
        width: AppSizes.minTouchTarget,
        height: AppSizes.minTouchTarget,
        child: Center(
          child: SizedBox(
            width: AppSizes.iconSmall,
            height: AppSizes.iconSmall,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    return IconButton(
      onPressed: onPressed,
      icon: const Icon(Icons.arrow_upward),
      tooltip: l10n.diary_capture_send,
      style: IconButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
    );
  }
}

/// 전송 실패 안내
///
/// 스낵바 대신 바 위에 붙여둔다 — 스낵바는 사라지면 재시도 경로도 함께 사라진다.
class _FailureBanner extends StatelessWidget {
  const _FailureBanner({required this.onRetry, required this.onDismiss});

  final VoidCallback onRetry;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      color: AppColors.error.withValues(alpha: 0.1),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceM,
        vertical: AppSizes.spaceS,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            size: AppSizes.iconSmall,
            color: AppColors.error,
          ),
          const SizedBox(width: AppSizes.spaceS),
          Expanded(
            child: Text(
              l10n.diary_capture_failed,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: Text(l10n.diary_capture_retry),
          ),
          IconButton(
            onPressed: onDismiss,
            icon: const Icon(Icons.close, size: AppSizes.iconSmall),
            tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}
