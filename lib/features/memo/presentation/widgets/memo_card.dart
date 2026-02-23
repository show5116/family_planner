import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/memo/data/models/memo_model.dart';
import 'package:family_planner/features/memo/presentation/widgets/memo_tag_chips.dart';

/// 메모 카드 위젯
class MemoCard extends StatelessWidget {
  final MemoModel memo;

  const MemoCard({
    super.key,
    required this.memo,
  });

  /// 마크다운 구조 제거 (미리보기용)
  String _stripMarkdown(String markdown) {
    return markdown
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
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy.MM.dd');

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
              // 헤더: 날짜 + 카테고리
              _buildHeader(context, dateFormat),
              const SizedBox(height: AppSizes.spaceS),

              // 제목
              _buildTitle(context),
              const SizedBox(height: AppSizes.spaceS),

              // 내용 미리보기
              if (memo.content.isNotEmpty) ...[
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

  Widget _buildHeader(BuildContext context, DateFormat dateFormat) {
    return Row(
      children: [
        Icon(
          Icons.note_outlined,
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
        if (memo.category != null && memo.category!.isNotEmpty)
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
              memo.category!,
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
      _stripMarkdown(memo.content),
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
