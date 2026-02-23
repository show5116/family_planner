import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/memo/providers/memo_provider.dart';
import 'package:family_planner/features/memo/presentation/widgets/memo_tag_chips.dart';
import 'package:family_planner/features/memo/presentation/widgets/memo_delete_dialog.dart';
import 'package:family_planner/shared/widgets/app_error_state.dart';
import 'package:family_planner/shared/widgets/rich_text_viewer.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 메모 상세 화면
class MemoDetailScreen extends ConsumerWidget {
  final String memoId;

  const MemoDetailScreen({
    super.key,
    required this.memoId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final memoAsync = ref.watch(memoDetailProvider(memoId));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.memo_detail),
        actions: [
          _buildMenu(context, ref, l10n),
        ],
      ),
      body: memoAsync.when(
        data: (memo) {
          final dateFormat = DateFormat('yyyy.MM.dd HH:mm');

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.spaceL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 카테고리
                if (memo.category != null && memo.category!.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.spaceS,
                      vertical: AppSizes.spaceXS,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius:
                          BorderRadius.circular(AppSizes.radiusSmall),
                    ),
                    child: Text(
                      memo.category!,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.spaceM),
                ],

                // 제목
                Text(
                  memo.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: AppSizes.spaceS),

                // 메타 정보
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: AppSizes.iconSmall,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: AppSizes.spaceXS),
                    Text(
                      memo.user.name,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                    const SizedBox(width: AppSizes.spaceM),
                    Icon(
                      Icons.access_time,
                      size: AppSizes.iconSmall,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: AppSizes.spaceXS),
                    Text(
                      dateFormat.format(memo.updatedAt),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),

                // 태그
                if (memo.tags.isNotEmpty) ...[
                  const SizedBox(height: AppSizes.spaceM),
                  MemoTagChips(tags: memo.tags),
                ],

                const SizedBox(height: AppSizes.spaceL),
                const Divider(),
                const SizedBox(height: AppSizes.spaceL),

                // 내용
                RichTextViewer(content: memo.content),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => AppErrorState(
          error: error,
          title: l10n.memo_loadError,
          onRetry: () => ref.invalidate(memoDetailProvider(memoId)),
        ),
      ),
    );
  }

  Widget _buildMenu(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    return PopupMenuButton<String>(
      onSelected: (value) => _handleMenuAction(context, ref, l10n, value),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              const Icon(Icons.edit, size: AppSizes.iconSmall),
              const SizedBox(width: AppSizes.spaceS),
              Text(l10n.common_edit),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              const Icon(Icons.delete,
                  size: AppSizes.iconSmall, color: AppColors.error),
              const SizedBox(width: AppSizes.spaceS),
              Text(l10n.common_delete,
                  style: const TextStyle(color: AppColors.error)),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _handleMenuAction(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    String value,
  ) async {
    if (value == 'edit') {
      context.push('/memo/$memoId/edit');
    } else if (value == 'delete') {
      MemoDeleteDialog.show(context, ref, memoId);
    }
  }
}
