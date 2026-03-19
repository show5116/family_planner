import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/memo/data/models/memo_model.dart';
import 'package:family_planner/features/memo/presentation/widgets/memo_tag_chips.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 메모 카드 위젯
class MemoCard extends ConsumerWidget {
  final MemoModel memo;

  const MemoCard({
    super.key,
    required this.memo,
  });

  /// HTML 태그 및 마크다운 구조 제거 (미리보기용)
  String _stripContent(String content) {
    return content
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll(RegExp(r'^#+\s+', multiLine: true), '')
        .replaceAll(RegExp(r'\*\*([^*]+)\*\*'), r'$1')
        .replaceAll(RegExp(r'__([^_]+)__'), r'$1')
        .replaceAll(RegExp(r'\*([^*]+)\*'), r'$1')
        .replaceAll(RegExp(r'_([^_]+)_'), r'$1')
        .replaceAll(RegExp(r'\[([^\]]+)\]\([^)]+\)'), r'$1')
        .replaceAll(RegExp(r'```[^`]*```'), '')
        .replaceAll(RegExp(r'`([^`]+)`'), r'$1')
        .replaceAll(RegExp(r'^[\-\*\+]\s+', multiLine: true), '')
        .replaceAll(RegExp(r'^\d+\.\s+', multiLine: true), '')
        .replaceAll(RegExp(r'^>\s+', multiLine: true), '')
        .replaceAll(RegExp(r'^[\-\*]{3,}$', multiLine: true), '')
        .replaceAll(RegExp(r'\n+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormat = DateFormat('yyyy.MM.dd');
    final groups = ref.watch(myGroupsProvider).valueOrNull ?? [];
    final groupName = memo.groupId != null
        ? groups.where((g) => g.id == memo.groupId).firstOrNull?.name
        : null;

    return Card(
      elevation: AppSizes.elevation1,
      surfaceTintColor: Colors.transparent,
      child: InkWell(
        onTap: () => context.push('/memo/${memo.id}'),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 헤더: 날짜 + 그룹
              _buildHeader(context, dateFormat, groupName),
              const SizedBox(height: AppSizes.spaceS),

              // 제목
              _buildTitle(context),
              const SizedBox(height: AppSizes.spaceS),

              // 체크리스트 진행률 또는 내용 미리보기
              if (memo.type == MemoType.checklist) ...[
                _buildChecklistProgress(context),
                const SizedBox(height: AppSizes.spaceS),
              ] else if (memo.content.isNotEmpty) ...[
                _buildContentPreview(context),
                const SizedBox(height: AppSizes.spaceS),
              ],

              // 태그
              MemoTagChips(tags: memo.tags),

              // 작성자
              if (memo.user.name.isNotEmpty) ...[
                const SizedBox(height: AppSizes.spaceS),
                _buildAuthor(context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChecklistProgress(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final total = memo.checklistItems.length;
    final checked = memo.checklistItems.where((i) => i.isChecked).length;
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

  Widget _buildHeader(BuildContext context, DateFormat dateFormat, String? groupName) {
    return Row(
      children: [
        Icon(
          memo.type == MemoType.checklist
              ? Icons.checklist
              : Icons.note_outlined,
          size: AppSizes.iconSmall,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: AppSizes.spaceXS),
        Expanded(
          child: Text(
            dateFormat.format(memo.updatedAt),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ),
        const SizedBox(width: AppSizes.spaceXS),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spaceS,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          ),
          child: Text(
            groupName ?? '나만 보기',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
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
      _stripContent(memo.content),
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildAuthor(BuildContext context) {
    return Text(
      memo.user.name,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
    );
  }
}
