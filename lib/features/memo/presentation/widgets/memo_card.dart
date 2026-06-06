import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/auth/providers/auth_provider.dart';
import 'package:family_planner/features/memo/data/models/memo_model.dart';
import 'package:family_planner/features/memo/data/utils/memo_editor_converter.dart';
import 'package:family_planner/features/memo/presentation/widgets/memo_tag_chips.dart';
import 'package:family_planner/features/memo/providers/memo_provider.dart';
import 'package:family_planner/core/utils/color_utils.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 메모 카드 위젯
class MemoCard extends ConsumerWidget {
  final MemoModel memo;
  final bool isDemo;

  const MemoCard({
    super.key,
    required this.memo,
    this.isDemo = false,
  });


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormat = DateFormat('yyyy.MM.dd');
    final groups = ref.watch(myGroupsProvider).valueOrNull ?? [];
    final matchedGroup = memo.groupId != null
        ? groups.where((g) => g.id == memo.groupId).firstOrNull
        : null;
    final userInfo = ref.watch(authProvider).user;
    final myPersonalColor = ColorUtils.personalColor(userInfo?['personalColor'] as String?);

    final card = Card(
      elevation: AppSizes.elevation1,
      surfaceTintColor: Colors.transparent,
      child: InkWell(
        onTap: isDemo ? null : () => context.push('/memo/${memo.id}'),
        onLongPress: isDemo ? null : () => _showActionSheet(context, ref),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 헤더: 날짜 + 그룹
              _buildHeader(context, ref, dateFormat, matchedGroup, myPersonalColor),
              const SizedBox(height: AppSizes.spaceS),

              // 제목
              _buildTitle(context),
              const SizedBox(height: AppSizes.spaceS),

              // 체크리스트 진행률 또는 내용 미리보기
              Builder(builder: (context) {
                final total = memo.checklistMeta.total;
                final checked = memo.checklistMeta.checked;
                if (total > 0) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildChecklistProgress(context, checked, total),
                      const SizedBox(height: AppSizes.spaceS),
                    ],
                  );
                }
                if (memo.content.isNotEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildContentPreview(context),
                      const SizedBox(height: AppSizes.spaceS),
                    ],
                  );
                }
                return const SizedBox.shrink();
              }),

              // 태그
              if (memo.tags.isNotEmpty) ...[
                const SizedBox(height: AppSizes.spaceXS),
                MemoTagChips(tags: memo.tags),
              ],
            ],
          ),
        ),
      ),
    );

    if (isDemo) return card;

    return Dismissible(
      key: ValueKey(memo.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) {
            final l10n = AppLocalizations.of(ctx)!;
            return AlertDialog(
              title: Text(l10n.memo_deleteDialogTitle),
              content: Text(l10n.memo_deleteDialogMessage),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: Text(l10n.common_cancel),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  style: FilledButton.styleFrom(backgroundColor: Colors.red),
                  child: Text(l10n.common_delete),
                ),
              ],
            );
          },
        ) ?? false;
      },
      onDismissed: (_) {
        ref.read(memoManagementProvider.notifier).deleteMemo(memo.id);
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSizes.spaceL),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      child: card,
    );
  }

  void _showActionSheet(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: Text(l10n.common_edit),
              onTap: () {
                Navigator.of(context).pop();
                context.push('/memo/${memo.id}/edit');
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: Text(l10n.common_delete,
                  style: const TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.of(context).pop();
                showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(l10n.memo_deleteDialogTitle),
                    content: Text(l10n.memo_deleteDialogMessage),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: Text(l10n.common_cancel),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        style: FilledButton.styleFrom(
                            backgroundColor: Colors.red),
                        child: Text(l10n.common_delete),
                      ),
                    ],
                  ),
                ).then((confirmed) {
                  if (confirmed == true) {
                    ref
                        .read(memoManagementProvider.notifier)
                        .deleteMemo(memo.id);
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChecklistProgress(BuildContext context, int checked, int total) {
    final l10n = AppLocalizations.of(context)!;
    final progress = total == 0 ? 0.0 : checked / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.checklist,
                size: AppSizes.iconSmall, color: AppColors.primary),
            const SizedBox(width: AppSizes.spaceXS),
            Text(
              l10n.memo_checklistProgress(checked, total),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: AppColors.primary.withValues(alpha: 0.15),
          color: AppColors.primary,
          minHeight: 4,
          borderRadius: BorderRadius.circular(2),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, DateFormat dateFormat, Group? group, Color personalColor) {
    final badgeColor = group != null
        ? ColorUtils.groupColor(group)
        : personalColor;

    return Row(
      children: [
        Icon(
          memo.checklistMeta.total > 0
              ? Icons.checklist_outlined
              : Icons.note_outlined,
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
        if (memo.user.name.isNotEmpty) ...[
          const SizedBox(width: AppSizes.spaceXS),
          const Text('·', style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(width: AppSizes.spaceXS),
          Text(
            memo.user.name,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
        const Spacer(),
        const SizedBox(width: AppSizes.spaceXS),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spaceS,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: badgeColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          ),
          child: Text(
            group?.name ?? '나만 보기',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: badgeColor,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
        const SizedBox(width: AppSizes.spaceS),
        _PinButton(memoId: memo.id, isPinned: memo.isPinned),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      memo.title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildContentPreview(BuildContext context) {
    return Text(
      MemoEditorConverter.plainTextPreview(memo.content),
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

}

class _PinButton extends ConsumerWidget {
  const _PinButton({required this.memoId, required this.isPinned});

  final String memoId;
  final bool isPinned;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pinState = ref.watch(memoPinProvider);
    final isLoading = pinState.isLoading;

    ref.listen(memoPinProvider, (_, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('핀 설정에 실패했습니다')),
        );
      }
    });

    if (isLoading) {
      return const SizedBox(
        width: 44,
        height: 44,
        child: Center(
          child: SizedBox(
            width: AppSizes.iconSmall,
            height: AppSizes.iconSmall,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () async {
        final updated =
            await ref.read(memoPinProvider.notifier).togglePin(memoId);
        if (!context.mounted || updated == null) return;
        final msg = updated.isPinned
            ? '메모가 상단에 고정되고, 대시보드에 추가되었습니다.'
            : '고정이 해제되었습니다.';
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(SnackBar(
            content: Text(msg),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ));
      },
      child: SizedBox(
        width: 44,
        height: 44,
        child: Center(
          child: Icon(
            isPinned ? Icons.push_pin : Icons.push_pin_outlined,
            size: AppSizes.iconSmall,
            color: isPinned ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
