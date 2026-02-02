import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/qna/data/models/qna_model.dart';
import 'package:family_planner/shared/widgets/status_badge.dart';
import 'package:family_planner/features/qna/utils/qna_utils.dart';

/// 질문 정보 위젯 (상세 화면용)
class QuestionInfo extends StatelessWidget {
  final QuestionModel question;

  const QuestionInfo({
    super.key,
    required this.question,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy년 MM월 dd일 HH:mm');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 카테고리, 상태, 공개여부 뱃지
        Wrap(
          spacing: AppSizes.spaceS,
          runSpacing: AppSizes.spaceS,
          children: [
            // 카테고리
            StatusBadge(
              icon: question.category.icon,
              label: question.category.displayName,
              color: question.category.color,
            ),
            // 상태
            StatusBadge(
              icon: question.status.icon,
              label: question.status.displayName,
              color: question.status.color,
            ),
            // 공개여부
            StatusBadge(
              icon: question.visibility.icon,
              label: question.visibility.displayName,
              color: question.visibility.color,
            ),
          ],
        ),
        const SizedBox(height: AppSizes.spaceL),

        // 제목
        Text(
          question.title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AppSizes.spaceM),

        // 작성자 및 작성일
        Row(
          children: [
            Icon(
              Icons.person_outline,
              size: AppSizes.iconSmall,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: AppSizes.spaceXS),
            Text(
              question.user?.name ?? '익명',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}
