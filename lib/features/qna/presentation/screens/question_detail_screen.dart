import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/auth/providers/auth_provider.dart';
import 'package:family_planner/features/qna/data/models/qna_model.dart';
import 'package:family_planner/features/qna/data/dto/qna_dto.dart';
import 'package:family_planner/features/qna/providers/qna_provider.dart';
import 'package:family_planner/shared/widgets/rich_text_viewer.dart';
import 'package:family_planner/shared/widgets/rich_text_editor.dart';
import 'package:family_planner/core/services/storage_service.dart';
import 'package:family_planner/core/utils/user_utils.dart';

// 분리된 위젯 import
import 'package:family_planner/features/qna/presentation/widgets/question_info.dart';
import 'package:family_planner/features/qna/presentation/widgets/answer_card.dart';
import 'package:family_planner/features/qna/presentation/widgets/answer_form.dart';

/// 질문 상세 화면
class QuestionDetailScreen extends ConsumerStatefulWidget {
  final String questionId;

  const QuestionDetailScreen({
    super.key,
    required this.questionId,
  });

  @override
  ConsumerState<QuestionDetailScreen> createState() =>
      _QuestionDetailScreenState();
}

class _QuestionDetailScreenState extends ConsumerState<QuestionDetailScreen> {
  final _answerController = TextEditingController();
  bool _isSubmittingAnswer = false;

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final questionAsync = ref.watch(questionDetailProvider(widget.questionId));
    final authState = ref.watch(authProvider);
    final currentUserId = authState.user?['id']?.toString();
    final isAdmin = ref.watch(isAdminProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('질문 상세'),
        actions: [
          questionAsync.when(
            data: (question) {
              // 본인 질문인 경우에만 메뉴 표시
              if (currentUserId == question.user?.id) {
                return _buildQuestionMenu(context, question);
              }
              return const SizedBox.shrink();
            },
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: questionAsync.when(
        data: (question) => _buildContent(context, question, currentUserId, isAdmin),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildErrorState(context, error.toString()),
      ),
    );
  }

  /// 질문 메뉴 (수정/해결완료/삭제)
  Widget _buildQuestionMenu(BuildContext context, QuestionModel question) {
    return PopupMenuButton<String>(
      onSelected: (value) async {
        if (value == 'edit') {
          if (question.status == QuestionStatus.resolved) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('해결 완료된 질문은 수정할 수 없습니다')),
            );
          } else {
            context.push('/qna/${question.id}/edit', extra: question);
          }
        } else if (value == 'resolve') {
          _showResolveConfirmDialog(context, question.id);
        } else if (value == 'delete') {
          _showDeleteConfirmDialog(context, widget.questionId);
        }
      },
      itemBuilder: (context) => [
        if (question.status != QuestionStatus.resolved)
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
        if (question.status == QuestionStatus.answered)
          const PopupMenuItem(
            value: 'resolve',
            child: Row(
              children: [
                Icon(Icons.check_circle, size: AppSizes.iconSmall, color: AppColors.success),
                SizedBox(width: AppSizes.spaceS),
                Text('해결완료', style: TextStyle(color: AppColors.success)),
              ],
            ),
          ),
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
    );
  }

  /// 메인 콘텐츠
  Widget _buildContent(
    BuildContext context,
    QuestionModel question,
    String? currentUserId,
    bool isAdmin,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.spaceL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 질문 정보
          QuestionInfo(question: question),
          const SizedBox(height: AppSizes.spaceL),

          const Divider(),
          const SizedBox(height: AppSizes.spaceL),

          // 질문 내용 (HTML 렌더링)
          RichTextViewer(content: question.content),

          // 첨부파일
          if (question.attachments?.isNotEmpty == true) ...[
            const SizedBox(height: AppSizes.spaceXL),
            const Divider(),
            const SizedBox(height: AppSizes.spaceL),
            _buildAttachmentsSection(context, question.attachments!),
          ],

          // 답변 목록
          if (question.answers.isNotEmpty) ...[
            const SizedBox(height: AppSizes.spaceXL),
            const Divider(),
            const SizedBox(height: AppSizes.spaceL),
            _buildAnswersSection(context, question, isAdmin),
          ],

          // 해결 완료 버튼 (질문자 본인 + 답변완료 상태일 때만)
          if (currentUserId == question.user?.id &&
              question.status == QuestionStatus.answered) ...[
            const SizedBox(height: AppSizes.spaceXL),
            const Divider(),
            const SizedBox(height: AppSizes.spaceL),
            ResolveSection(
              onResolve: () => _showResolveConfirmDialog(context, question.id),
            ),
          ],

          // 운영자 답변 작성 섹션
          if (isAdmin) ...[
            const SizedBox(height: AppSizes.spaceXL),
            const Divider(),
            const SizedBox(height: AppSizes.spaceL),
            AnswerForm(
              controller: _answerController,
              isSubmitting: _isSubmittingAnswer,
              onSubmit: () => _submitAnswer(question.id),
            ),
          ],
        ],
      ),
    );
  }

  /// 첨부파일 섹션
  Widget _buildAttachmentsSection(BuildContext context, List<Attachment> attachments) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '첨부파일',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AppSizes.spaceM),
        ...attachments.map((attachment) {
          return Card(
            margin: const EdgeInsets.only(bottom: AppSizes.spaceS),
            child: ListTile(
              leading: const Icon(Icons.attach_file),
              title: Text(attachment.name),
              subtitle: Text('${(attachment.size / 1024).toStringAsFixed(1)} KB'),
              trailing: IconButton(
                icon: const Icon(Icons.download),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('파일 다운로드 기능은 추후 구현 예정입니다')),
                  );
                },
              ),
            ),
          );
        }),
      ],
    );
  }

  /// 답변 목록 섹션
  Widget _buildAnswersSection(BuildContext context, QuestionModel question, bool isAdmin) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          return AnswerCard(
            answer: answer,
            isAdmin: isAdmin,
            onEdit: isAdmin ? () => _showEditAnswerDialog(context, question.id, answer) : null,
            onDelete: isAdmin ? () => _showDeleteAnswerDialog(context, question.id, answer.id) : null,
          );
        }),
      ],
    );
  }

  /// 에러 상태 위젯
  Widget _buildErrorState(BuildContext context, String error) {
    return Center(
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
            error,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// 답변 제출
  Future<void> _submitAnswer(String questionId) async {
    final content = _answerController.text.trim();
    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('답변 내용을 입력해주세요'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isSubmittingAnswer = true);

    try {
      final dto = CreateAnswerDto(content: content);
      await ref.read(questionManagementProvider.notifier).createAnswer(questionId, dto);

      if (mounted) {
        _answerController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('답변이 등록되었습니다'),
            backgroundColor: AppColors.success,
          ),
        );
        ref.invalidate(questionDetailProvider(questionId));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('답변 등록 실패: $e'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmittingAnswer = false);
      }
    }
  }

  /// 해결완료 확인 다이얼로그
  void _showResolveConfirmDialog(BuildContext context, String questionId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('해결완료 처리'),
        content: const Text('이 질문을 해결완료로 처리하시겠습니까?\n해결완료 후에는 질문을 수정할 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              try {
                await ref.read(questionManagementProvider.notifier).resolveQuestion(questionId);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('질문이 해결완료 처리되었습니다'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('해결완료 처리 실패: $e'), backgroundColor: AppColors.error),
                  );
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.success),
            child: const Text('해결완료'),
          ),
        ],
      ),
    );
  }

  /// 삭제 확인 다이얼로그
  void _showDeleteConfirmDialog(BuildContext context, String questionId) {
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
                await ref.read(questionManagementProvider.notifier).deleteQuestion(questionId);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('질문이 삭제되었습니다')),
                  );
                  context.pop();
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('질문 삭제 실패: $e'), backgroundColor: AppColors.error),
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

  /// 답변 수정 다이얼로그
  void _showEditAnswerDialog(BuildContext context, String questionId, AnswerModel answer) {
    final editController = TextEditingController(text: answer.content);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('답변 수정'),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: RichTextEditor(
            controller: editController,
            labelText: '',
            hintText: '답변 내용을 입력하세요',
            minLines: 8,
            simpleMode: true,
            imageUploadType: EditorImageType.qna,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              editController.dispose();
            },
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              final content = editController.text.trim();
              if (content.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('답변 내용을 입력해주세요'), backgroundColor: AppColors.error),
                );
                return;
              }

              Navigator.of(dialogContext).pop();
              editController.dispose();

              try {
                final dto = CreateAnswerDto(content: content);
                await ref.read(questionManagementProvider.notifier).updateAnswer(questionId, answer.id, dto);

                if (mounted) {
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    const SnackBar(content: Text('답변이 수정되었습니다'), backgroundColor: AppColors.success),
                  );
                  ref.invalidate(questionDetailProvider(questionId));
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    SnackBar(content: Text('답변 수정 실패: $e'), backgroundColor: AppColors.error),
                  );
                }
              }
            },
            child: const Text('수정'),
          ),
        ],
      ),
    );
  }

  /// 답변 삭제 확인 다이얼로그
  void _showDeleteAnswerDialog(BuildContext context, String questionId, String answerId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('답변 삭제'),
        content: const Text('이 답변을 삭제하시겠습니까?\n삭제된 답변은 복구할 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              try {
                await ref.read(questionManagementProvider.notifier).deleteAnswer(questionId, answerId);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('답변이 삭제되었습니다'), backgroundColor: AppColors.success),
                  );
                  ref.invalidate(questionDetailProvider(questionId));
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('답변 삭제 실패: $e'), backgroundColor: AppColors.error),
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
