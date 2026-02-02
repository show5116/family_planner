import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/shared/widgets/rich_text_editor.dart';
import 'package:family_planner/core/services/storage_service.dart';

/// 운영자 답변 작성 폼
class AnswerForm extends StatelessWidget {
  final TextEditingController controller;
  final bool isSubmitting;
  final VoidCallback onSubmit;

  const AnswerForm({
    super.key,
    required this.controller,
    required this.isSubmitting,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더
            Row(
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
                  '답변 작성',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spaceL),

            // 답변 에디터
            RichTextEditor(
              controller: controller,
              labelText: '',
              hintText: '답변 내용을 입력하세요',
              minLines: 8,
              simpleMode: true,
              imageUploadType: EditorImageType.qna,
            ),
            const SizedBox(height: AppSizes.spaceL),

            // 제출 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isSubmitting ? null : onSubmit,
                icon: isSubmitting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send),
                label: Text(isSubmitting ? '답변 등록 중...' : '답변 등록'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 해결 완료 섹션 위젯
class ResolveSection extends StatelessWidget {
  final VoidCallback onResolve;

  const ResolveSection({
    super.key,
    required this.onResolve,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.spaceL),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        border: Border.all(
          color: AppColors.success.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.check_circle_outline,
                color: AppColors.success,
                size: AppSizes.iconMedium,
              ),
              const SizedBox(width: AppSizes.spaceS),
              Text(
                '문제가 해결되셨나요?',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.success,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spaceS),
          Text(
            '답변이 도움이 되셨다면 해결 완료로 변경해주세요.\n1주일간 상태를 변경하지 않으면 자동으로 해결 완료로 변경됩니다.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: AppSizes.spaceL),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onResolve,
              icon: const Icon(Icons.check_circle),
              label: const Text('해결 완료'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
