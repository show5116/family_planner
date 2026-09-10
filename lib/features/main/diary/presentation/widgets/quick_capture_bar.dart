import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/main/diary/data/utils/diary_date.dart';
import 'package:family_planner/features/main/diary/presentation/widgets/media_attach_flow.dart';
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

  /// 사진 첨부 흐름이 도는 중 (선택 → 압축 선택 → 업로드)
  bool _isAttaching = false;

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

  /// 사진만 던지기 — 텍스트가 입력돼 있으면 함께 보낸다
  ///
  /// 업로드가 끝나야 append에 실을 mediaId가 생기므로, 여기서는 낙관적 갱신을
  /// 하지 않고 업로드 완료 후에 보낸다.
  ///
  /// EXIF 촬영일이 오늘과 다르면 첨부 흐름이 어느 날 일기에 넣을지 물어보고,
  /// 그 결과를 [DiaryAttachResult.date]로 돌려준다. 글도 같은 날짜로 보내야
  /// 사진과 글이 다른 날에 흩어지지 않는다.
  Future<void> _attachPhoto() async {
    if (_isAttaching) return;
    setState(() => _isAttaching = true);

    try {
      final result = await attachDiaryMedia(
        context,
        ref,
        date: diaryToday(),
        askCaptureDate: true,
      );

      if (!mounted) return;
      if (result.isEmpty) {
        showAttachFailureIfAny(context, ref);
        return;
      }

      final text = _controller.text.trim();
      _controller.clear();

      final ok = await ref.read(quickCaptureProvider.notifier).send(
            text,
            date: result.date,
            mediaIds: result.mediaIds,
          );

      if (!ok && mounted && text.isNotEmpty) {
        _controller.text = text;
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: text.length),
        );
      }
    } finally {
      if (mounted) setState(() => _isAttaching = false);
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
                  _AttachButton(
                    isBusy: _isAttaching,
                    onPressed: _attachPhoto,
                  ),
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

/// 사진 첨부 버튼
///
/// 텍스트 없이 사진만 던지는 것도 허용한다 — 이쪽이 더 잦은 사용 방식이다.
class _AttachButton extends StatelessWidget {
  const _AttachButton({required this.isBusy, required this.onPressed});

  final bool isBusy;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    if (isBusy) {
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
      icon: const Icon(Icons.add_a_photo_outlined),
      tooltip: l10n.diary_add_photo,
      color: colorScheme.onSurfaceVariant,
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
