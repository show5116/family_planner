import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/main/diary/data/models/diary_models.dart';
import 'package:family_planner/features/main/diary/data/utils/diary_date.dart';
import 'package:family_planner/features/main/diary/presentation/widgets/diary_media_grid.dart';
import 'package:family_planner/features/main/diary/providers/diary_provider.dart';
import 'package:family_planner/features/memo/data/utils/memo_editor_converter.dart';
import 'package:family_planner/shared/widgets/app_error_state.dart';

/// 일기 상세 화면
class DiaryDetailScreen extends ConsumerWidget {
  const DiaryDetailScreen({super.key, required this.diaryId});

  final String diaryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final detail = ref.watch(diaryDetailProvider(diaryId));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.diary_detail_title),
        actions: [
          if (detail.valueOrNull != null) ...[
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: l10n.diary_polish,
              onPressed: () => context.push(
                AppRoutes.diaryForm,
                extra: {'diaryId': diaryId},
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: MaterialLocalizations.of(context).deleteButtonTooltip,
              onPressed: () => _confirmDelete(
                context,
                ref,
                hasMedia: detail.valueOrNull?.media.isNotEmpty ?? false,
              ),
            ),
          ],
        ],
      ),
      body: detail.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => AppErrorState(
          error: error,
          title: l10n.diary_load_error,
          onRetry: () => ref.invalidate(diaryDetailProvider(diaryId)),
        ),
        data: (diary) => _DiaryBody(diary: diary),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref, {
    required bool hasMedia,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.diary_delete_confirm_title),
        // 본문은 30일 복구되지만 첨부는 즉시·영구 삭제다. 이 문구가 없으면 CS가 들어온다.
        content: Text(
          hasMedia
              ? '${l10n.diary_delete_confirm_message}\n\n'
                  '${l10n.diary_media_delete_permanent}'
              : l10n.diary_delete_confirm_message,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(MaterialLocalizations.of(context).deleteButtonTooltip),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    try {
      await ref.read(diaryManagementProvider.notifier).delete(diaryId);
      if (context.mounted) context.pop();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.diary_delete_failed}: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}

class _DiaryBody extends StatefulWidget {
  const _DiaryBody({required this.diary});

  final DiaryModel diary;

  @override
  State<_DiaryBody> createState() => _DiaryBodyState();
}

class _DiaryBodyState extends State<_DiaryBody> {
  QuillController? _controller;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  @override
  void didUpdateWidget(covariant _DiaryBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.diary.content != widget.diary.content) {
      _controller?.dispose();
      _initController();
    }
  }

  void _initController() {
    if (widget.diary.format != DiaryFormat.delta) return;
    _controller = QuillController(
      document: MemoEditorConverter.toDocument(widget.diary.content),
      selection: const TextSelection.collapsed(offset: 0),
      readOnly: true,
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final diary = widget.diary;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                DateFormat.yMMMMEEEEd(locale)
                    .format(parseDiaryDate(diary.date)),
                style: theme.textTheme.headlineSmall,
              ),
              if (diary.mood != null) ...[
                const SizedBox(width: AppSizes.spaceS),
                Text(diary.mood!, style: theme.textTheme.headlineSmall),
              ],
            ],
          ),
          if (diary.visibility.isShared && diary.user != null) ...[
            const SizedBox(height: AppSizes.spaceXS),
            Row(
              children: [
                Icon(
                  Icons.group_outlined,
                  size: AppSizes.iconSmall,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: AppSizes.spaceXS),
                Text(
                  l10n.diary_shared_by(diary.user!.name),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
          if (diary.title != null && diary.title!.isNotEmpty) ...[
            const SizedBox(height: AppSizes.spaceM),
            Text(diary.title!, style: theme.textTheme.titleLarge),
          ],
          if (diary.media.isNotEmpty) ...[
            const SizedBox(height: AppSizes.spaceM),
            DiaryMediaGallery(media: diary.media),
          ],
          const SizedBox(height: AppSizes.spaceM),
          _buildContent(theme),
        ],
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    final controller = _controller;

    if (controller == null) {
      // DELTA가 아닌 포맷은 평문으로 표시한다
      return Text(widget.diary.content, style: theme.textTheme.bodyLarge);
    }

    return QuillEditor.basic(
      controller: controller,
      config: const QuillEditorConfig(
        showCursor: false,
        padding: EdgeInsets.zero,
        autoFocus: false,
        expands: false,
        scrollable: false,
      ),
    );
  }
}
