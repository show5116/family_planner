import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/auth/providers/auth_provider.dart';
import 'package:family_planner/features/qna/data/models/qna_model.dart';
import 'package:family_planner/features/qna/providers/qna_provider.dart';
import 'package:family_planner/features/qna/utils/qna_utils.dart';
import 'package:family_planner/shared/widgets/rich_text_viewer.dart';

/// 질문 상세 화면
class QuestionDetailScreen extends ConsumerWidget {
  final String questionId;

  const QuestionDetailScreen({
    super.key,
    required this.questionId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questionAsync = ref.watch(questionDetailProvider(questionId));
    final authState = ref.watch(authProvider);
    final currentUserId = authState.user?['id'] as String?;

    return Scaffold(
      appBar: AppBar(
        title: const Text('질문 상세'),
        actions: [
          questionAsync.when(
            data: (question) {
              // 본인 질문인 경우에만 메뉴 표시
              if (currentUserId == question.user.id) {
                return PopupMenuButton<String>(
                  onSelected: (value) async {
                    if (value == 'edit') {
                      // 수정 (PENDING 상태만 가능)
                      if (question.status == QuestionStatus.pending) {
                        context.push(
                          '/qna/${question.id}/edit',
                          extra: question,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('답변 완료 후에는 수정할 수 없습니다'),
                          ),
                        );
                      }
                    } else if (value == 'delete') {
                      _showDeleteConfirmDialog(context, ref, questionId);
                    }
                  },
                  itemBuilder: (context) => [
                    if (question.status == QuestionStatus.pending)
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
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete,
                              size: AppSizes.iconSmall, color: AppColors.error),
                          SizedBox(width: AppSizes.spaceS),
                          Text('삭제', style: TextStyle(color: AppColors.error)),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: questionAsync.when(
        data: (question) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.spaceL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 질문 정보
                _buildQuestionInfo(context, question),
                const SizedBox(height: AppSizes.spaceL),

                const Divider(),
                const SizedBox(height: AppSizes.spaceL),

                // 질문 내용 (HTML 렌더링)
                RichTextViewer(
                  content: question.content,
                ),

                // 첨부파일
                if (question.attachments?.isNotEmpty == true) ...[
                  const SizedBox(height: AppSizes.spaceXL),
                  const Divider(),
                  const SizedBox(height: AppSizes.spaceL),
                  Text(
                    '첨부파일',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: AppSizes.spaceM),
                  ...question.attachments!.map((attachment) {
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
                  }),
                ],

                // 답변 목록
                if (question.answers.isNotEmpty) ...[
                  const SizedBox(height: AppSizes.spaceXL),
                  const Divider(),
                  const SizedBox(height: AppSizes.spaceL),
                  Row(
                    children: [
                      const Icon(
                        Icons.chat_bubble,
                        color: AppColors.primary,
                        size: AppSizes.iconMedium,
                      ),
                      const SizedBox(width: AppSizes.spaceS),
                      Text(
                        '답변 (${question.answers.length})',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.spaceL),
                  ...question.answers.map((answer) {
                    return _buildAnswerCard(context, answer);
                  }),
                ],
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: AppSizes.iconXLarge * 2,
                color: AppColors.error,
              ),
              const SizedBox(height: AppSizes.spaceL),
              Text(
                '질문을 불러올 수 없습니다',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSizes.spaceS),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 질문 정보 위젯
  Widget _buildQuestionInfo(BuildContext context, QuestionModel question) {
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
            _buildBadge(
              context,
              icon: question.category.icon,
              label: question.category.displayName,
              color: question.category.color,
            ),
            // 상태
            _buildBadge(
              context,
              icon: question.status.icon,
              label: question.status.displayName,
              color: question.status.color,
            ),
            // 공개여부
            _buildBadge(
              context,
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
              question.user.name,
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

  /// 뱃지 위젯
  Widget _buildBadge(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceS,
        vertical: AppSizes.spaceXS,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: AppSizes.iconSmall,
            color: color,
          ),
          const SizedBox(width: AppSizes.spaceXS),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  /// 답변 카드 위젯
  Widget _buildAnswerCard(BuildContext context, AnswerModel answer) {
    final dateFormat = DateFormat('yyyy년 MM월 dd일 HH:mm');

    return Card(
      color: AppColors.primary.withValues(alpha: 0.03),
      margin: const EdgeInsets.only(bottom: AppSizes.spaceM),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 관리자 정보
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
                  answer.admin.name,
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
              ],
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
              }),
            ],
          ],
        ),
      ),
    );
  }

  /// 삭제 확인 다이얼로그
  void _showDeleteConfirmDialog(
    BuildContext context,
    WidgetRef ref,
    String questionId,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('질문 삭제'),
        content: const Text('이 질문을 삭제하시겠습니까?\n삭제된 질문은 복구할 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();

              try {
                await ref
                    .read(questionManagementProvider.notifier)
                    .deleteQuestion(questionId);

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('질문이 삭제되었습니다')),
                  );
                  context.pop();
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('질문 삭제 실패: $e'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }
}
