import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/qna/data/models/qna_model.dart';
import 'package:family_planner/shared/widgets/rich_text_viewer.dart';

/// 답변 카드 위젯
class AnswerCard extends StatelessWidget {
  final AnswerModel answer;
  final bool isAdmin;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AnswerCard({
    super.key,
    required this.answer,
    required this.isAdmin,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy년 MM월 dd일 HH:mm');

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.spaceM),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 관리자 정보
            _AnswerCardHeader(
              answer: answer,
              dateFormat: dateFormat,
              isAdmin: isAdmin,
              onEdit: onEdit,
              onDelete: onDelete,
            ),
            const SizedBox(height: AppSizes.spaceL),

            // 답변 내용 (HTML 렌더링)
            RichTextViewer(
              content: answer.content,
            ),

            // 첨부파일
            if (answer.attachments?.isNotEmpty == true) ...[
              const SizedBox(height: AppSizes.spaceL),
              const Divider(),
              const SizedBox(height: AppSizes.spaceM),
              ...answer.attachments!.map((attachment) {
                return _AttachmentItem(attachment: attachment);
              }),
            ],
          ],
        ),
      ),
    );
  }
}

/// 답변 카드 헤더
class _AnswerCardHeader extends StatelessWidget {
  final AnswerModel answer;
  final DateFormat dateFormat;
  final bool isAdmin;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _AnswerCardHeader({
    required this.answer,
    required this.dateFormat,
    required this.isAdmin,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spaceS,
            vertical: AppSizes.spaceXS,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          ),
          child: Text(
            'ADMIN',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        const SizedBox(width: AppSizes.spaceS),
        Text(
          answer.admin?.name ?? '관리자',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const Spacer(),
        Icon(
          Icons.access_time,
          size: AppSizes.iconSmall,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: AppSizes.spaceXS),
        Text(
          dateFormat.format(answer.createdAt),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        // 운영자용 수정/삭제 메뉴
        if (isAdmin && (onEdit != null || onDelete != null)) ...[
          const SizedBox(width: AppSizes.spaceS),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              size: AppSizes.iconSmall,
              color: AppColors.textSecondary,
            ),
            padding: EdgeInsets.zero,
            onSelected: (value) {
              if (value == 'edit') {
                onEdit?.call();
              } else if (value == 'delete') {
                onDelete?.call();
              }
            },
            itemBuilder: (context) => [
              if (onEdit != null)
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: AppSizes.iconSmall),
                      SizedBox(width: AppSizes.spaceS),
                      Text('수정'),
                    ],
                  ),
                ),
              if (onDelete != null)
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: AppSizes.iconSmall, color: AppColors.error),
                      SizedBox(width: AppSizes.spaceS),
                      Text('삭제', style: TextStyle(color: AppColors.error)),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

/// 첨부파일 아이템
class _AttachmentItem extends StatelessWidget {
  final Attachment attachment;

  const _AttachmentItem({required this.attachment});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.spaceS),
      child: ListTile(
        leading: const Icon(Icons.attach_file),
        title: Text(attachment.name),
        subtitle: Text(
          '${(attachment.size / 1024).toStringAsFixed(1)} KB',
        ),
        trailing: IconButton(
          icon: const Icon(Icons.download),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('파일 다운로드 기능은 추후 구현 예정입니다'),
              ),
            );
          },
        ),
      ),
    );
  }
}
