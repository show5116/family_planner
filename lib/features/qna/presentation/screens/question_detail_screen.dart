import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
    final questionAsync = ref.watch(questionDetailProvider(widget.questionId));
    final authState = ref.watch(authProvider);
    final currentUserId = authState.userId;
    final isAdmin = ref.watch(isAdminProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.qna_questionDetail),
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
    final l10n = AppLocalizations.of(context)!;
    return PopupMenuButton<String>(
      onSelected: (value) async {
        if (value == 'edit') {
          if (question.status == QuestionStatus.resolved) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.qna_cannotEditResolved)),
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
          PopupMenuItem(
            value: 'edit',
            child: Row(
              children: [
                Icon(Icons.edit, size: AppSizes.iconSmall),
                SizedBox(width: AppSizes.spaceS),
                Text(l10n.common_edit),
              ],
            ),
          ),
        if (question.status == QuestionStatus.answered)
          PopupMenuItem(
            value: 'resolve',
            child: Row(
              children: [
                Icon(Icons.check_circle, size: AppSizes.iconSmall, color: AppColors.success),
                SizedBox(width: AppSizes.spaceS),
                Text(l10n.qna_resolve,
                    style: const TextStyle(color: AppColors.success)),
              ],
            ),
          ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, size: AppSizes.iconSmall, color: AppColors.error),
              SizedBox(width: AppSizes.spaceS),
              Text(l10n.common_delete,
                  style: const TextStyle(color: AppColors.error)),
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
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.qna_attachments,
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
                    SnackBar(content: Text(l10n.qna_downloadNotReady)),
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
    final l10n = AppLocalizations.of(context)!;
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
              l10n.qna_answersCount(question.answers.length),
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
    final l10n = AppLocalizations.of(context)!;
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
            l10n.qna_loadError,
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
    final l10n = AppLocalizations.of(context)!;
    final content = _answerController.text.trim();
    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.qna_answerRequired),
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
          SnackBar(
            content: Text(l10n.qna_answerSuccess),
            backgroundColor: AppColors.success,
          ),
        );
        ref.invalidate(questionDetailProvider(questionId));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('${l10n.qna_answerError}\n$e'),
              backgroundColor: AppColors.error),
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
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.qna_resolveTitle),
        content: Text(l10n.qna_resolveMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.common_cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              try {
                await ref.read(questionManagementProvider.notifier).resolveQuestion(questionId);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.qna_resolveSuccess),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('${l10n.qna_resolveError}\n$e'),
                        backgroundColor: AppColors.error),
                  );
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.success),
            child: Text(l10n.qna_resolve),
          ),
        ],
      ),
    );
  }

  /// 삭제 확인 다이얼로그
  void _showDeleteConfirmDialog(BuildContext context, String questionId) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.qna_deleteDialogTitle),
        content: Text(l10n.qna_deleteDialogMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.common_cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              try {
                await ref.read(questionManagementProvider.notifier).deleteQuestion(questionId);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.qna_deleteSuccess)),
                  );
                  context.pop();
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('${l10n.qna_deleteError}\n$e'),
                        backgroundColor: AppColors.error),
                  );
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(l10n.common_delete),
          ),
        ],
      ),
    );
  }

  /// 답변 수정 다이얼로그
  void _showEditAnswerDialog(BuildContext context, String questionId, AnswerModel answer) {
    final l10n = AppLocalizations.of(context)!;
    final editController = TextEditingController(text: answer.content);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.qna_editAnswer),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: RichTextEditor(
            controller: editController,
            labelText: '',
            hintText: l10n.qna_answerContentHint,
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
            child: Text(l10n.common_cancel),
          ),
          TextButton(
            onPressed: () async {
              final content = editController.text.trim();
              if (content.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(l10n.qna_answerRequired),
                      backgroundColor: AppColors.error),
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
                    SnackBar(
                        content: Text(l10n.qna_answerUpdateSuccess),
                        backgroundColor: AppColors.success),
                  );
                  ref.invalidate(questionDetailProvider(questionId));
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    SnackBar(
                        content: Text('${l10n.qna_answerUpdateError}\n$e'),
                        backgroundColor: AppColors.error),
                  );
                }
              }
            },
            child: Text(l10n.common_edit),
          ),
        ],
      ),
    );
  }

  /// 답변 삭제 확인 다이얼로그
  void _showDeleteAnswerDialog(BuildContext context, String questionId, String answerId) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.qna_deleteAnswer),
        content: Text(l10n.qna_deleteAnswerMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.common_cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              try {
                await ref.read(questionManagementProvider.notifier).deleteAnswer(questionId, answerId);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(l10n.qna_answerDeleteSuccess),
                        backgroundColor: AppColors.success),
                  );
                  ref.invalidate(questionDetailProvider(questionId));
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('${l10n.qna_answerDeleteError}\n$e'),
                        backgroundColor: AppColors.error),
                  );
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(l10n.common_delete),
          ),
        ],
      ),
    );
  }
}
