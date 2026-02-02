import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/qna/data/models/qna_model.dart';
import 'package:family_planner/shared/widgets/status_badge.dart';
import 'package:family_planner/features/qna/utils/qna_utils.dart';
import 'package:family_planner/shared/widgets/editor/utils/html_utils.dart';

/// 질문 카드 위젯
class QuestionCard extends ConsumerWidget {
  final QuestionListItem question;
  final bool showVisibility;

  const QuestionCard({
    super.key,
    required this.question,
    this.showVisibility = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormat = DateFormat('yyyy.MM.dd HH:mm');

    return Card(
      child: InkWell(
        onTap: () {
          context.push('/qna/questions/${question.id}');
        },
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 헤더 (카테고리, 상태, 공개여부)
              _QuestionCardHeader(
                question: question,
                showVisibility: showVisibility,
              ),
              const SizedBox(height: AppSizes.spaceM),

              // 제목
              Text(
                question.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSizes.spaceS),

              // 내용 미리보기
              Text(
                stripHtmlTags(question.content),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSizes.spaceM),

              // 작성자 및 작성일
              _QuestionCardFooter(
                question: question,
                dateFormat: dateFormat,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 질문 카드 헤더 (카테고리, 상태, 공개여부, 답변수)
class _QuestionCardHeader extends StatelessWidget {
  final QuestionListItem question;
  final bool showVisibility;

  const _QuestionCardHeader({
    required this.question,
    required this.showVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 카테고리
        StatusBadge(
          icon: question.category.icon,
          label: question.category.displayName,
          color: question.category.color,
        ),
        const SizedBox(width: AppSizes.spaceS),

        // 상태
        StatusBadge(
          icon: question.status.icon,
          label: question.status.displayName,
          color: question.status.color,
        ),

        // 공개여부 (내 질문에만 표시)
        if (showVisibility) ...[
          const SizedBox(width: AppSizes.spaceS),
          Icon(
            question.visibility.icon,
            size: AppSizes.iconSmall,
            color: question.visibility.color,
          ),
        ],

        const Spacer(),

        // 답변 개수
        if (question.answerCount > 0)
          StatusBadge(
            icon: Icons.chat_bubble_outline,
            label: '${question.answerCount}',
            color: AppColors.primary,
          ),
      ],
    );
  }
}

/// 질문 카드 푸터 (작성자, 작성일)
class _QuestionCardFooter extends StatelessWidget {
  final QuestionListItem question;
  final DateFormat dateFormat;

  const _QuestionCardFooter({
    required this.question,
    required this.dateFormat,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.person_outline,
          size: AppSizes.iconSmall,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: AppSizes.spaceXS),
        Text(
          question.user?.name ?? '익명',
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
          dateFormat.format(question.createdAt),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
      ],
    );
  }
}
