import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/qna/data/models/qna_model.dart';
import 'package:family_planner/features/qna/data/dto/qna_dto.dart';
import 'package:family_planner/features/qna/providers/qna_provider.dart';
import 'package:family_planner/features/qna/utils/qna_utils.dart';
import 'package:family_planner/shared/widgets/rich_text_editor.dart';
import 'package:family_planner/core/services/storage_service.dart';

/// 질문 작성/수정 화면
class QuestionFormScreen extends ConsumerStatefulWidget {
  /// 수정할 질문 ID (null이면 신규 작성)
  final String? questionId;

  /// 수정할 질문 데이터 (수정 모드)
  final QuestionModel? question;

  const QuestionFormScreen({
    super.key,
    this.questionId,
    this.question,
  });

  @override
  ConsumerState<QuestionFormScreen> createState() => _QuestionFormScreenState();
}

class _QuestionFormScreenState extends ConsumerState<QuestionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  QuestionCategory _selectedCategory = QuestionCategory.etc;
  QuestionVisibility _selectedVisibility = QuestionVisibility.private;

  bool get _isEditMode => widget.question != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      _titleController.text = widget.question!.title;
      _contentController.text = widget.question!.content;
      _selectedCategory = widget.question!.category;
      _selectedVisibility = widget.question!.visibility;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? '질문 수정' : '질문 작성'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.spaceL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 안내 메시지
              if (!_isEditMode) ...[
                _buildInfoCard(),
                const SizedBox(height: AppSizes.spaceL),
              ],

              // 카테고리 선택
              _buildCategorySection(),
              const SizedBox(height: AppSizes.spaceL),

              // 공개/비공개 선택
              _buildVisibilitySection(),
              const SizedBox(height: AppSizes.spaceL),

              // 제목 입력
              _buildTitleField(),
              const SizedBox(height: AppSizes.spaceL),

              // 내용 입력 (리치 텍스트 에디터 - 간소화 모드)
              RichTextEditor(
                controller: _contentController,
                labelText: '내용',
                hintText: '질문 내용을 자세히 작성해주세요.\n스크린샷이 있으면 더 빠른 답변이 가능합니다.',
                minLines: 15,
                maxLines: 30,
                simpleMode: true,
                imageUploadType: EditorImageType.qna,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '내용을 입력해주세요';
                  }
                  if (value.trim().length < 10) {
                    return '내용은 10자 이상 입력해주세요';
                  }
                  if (value.length > 5000) {
                    return '내용은 5000자를 초과할 수 없습니다';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSizes.spaceXL),

              // 제출 버튼
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleSubmit,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSizes.spaceM),
                    child: Text(
                      _isEditMode ? '수정 완료' : '질문 등록',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 안내 카드
  Widget _buildInfoCard() {
    return Card(
      color: AppColors.primary.withValues(alpha: 0.08),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        side: BorderSide(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.spaceS),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              ),
              child: const Icon(
                Icons.lightbulb_outline,
                color: AppColors.primary,
                size: AppSizes.iconMedium,
              ),
            ),
            const SizedBox(width: AppSizes.spaceM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '질문 작성 안내',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: AppSizes.spaceXS),
                  Text(
                    '• 질문은 관리자가 확인 후 답변드립니다.\n• 답변은 알림으로 안내됩니다.\n• 대기 중 상태에서만 수정/삭제 가능합니다.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.primary.withValues(alpha: 0.8),
                          height: 1.5,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 카테고리 선택 섹션
  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '카테고리',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AppSizes.spaceM),
        Wrap(
          spacing: AppSizes.spaceS,
          runSpacing: AppSizes.spaceS,
          children: QuestionCategory.values.map((category) {
            final isSelected = _selectedCategory == category;
            return ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    category.icon,
                    size: AppSizes.iconSmall,
                    color: isSelected ? Colors.white : category.color,
                  ),
                  const SizedBox(width: AppSizes.spaceXS),
                  Text(category.displayName),
                ],
              ),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedCategory = category;
                  });
                }
              },
              selectedColor: category.color,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : null,
                fontWeight: isSelected ? FontWeight.bold : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// 공개/비공개 선택 섹션
  Widget _buildVisibilitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '공개 설정',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AppSizes.spaceM),
        ...QuestionVisibility.values.map((visibility) {
          return RadioListTile<QuestionVisibility>(
            title: Row(
              children: [
                Icon(
                  visibility.icon,
                  size: AppSizes.iconSmall,
                  color: visibility.color,
                ),
                const SizedBox(width: AppSizes.spaceS),
                Text(visibility.displayName),
              ],
            ),
            subtitle: Text(
              visibility.description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            value: visibility,
            groupValue: _selectedVisibility,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedVisibility = value;
                });
              }
            },
            contentPadding: EdgeInsets.zero,
          );
        }),
      ],
    );
  }

  /// 제목 입력 필드
  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      decoration: const InputDecoration(
        labelText: '제목',
        hintText: '질문 제목을 입력하세요',
        border: OutlineInputBorder(),
      ),
      maxLength: 200,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '제목을 입력해주세요';
        }
        if (value.trim().length < 5) {
          return '제목은 5자 이상 입력해주세요';
        }
        return null;
      },
    );
  }

  /// 제출 처리
  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final dto = CreateQuestionDto(
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      category: _selectedCategory,
      visibility: _selectedVisibility,
    );

    try {
      if (_isEditMode) {
        // 수정
        await ref
            .read(questionManagementProvider.notifier)
            .updateQuestion(widget.questionId!, dto);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('질문이 수정되었습니다')),
          );
          context.pop();
        }
      } else {
        // 신규 작성
        await ref.read(questionManagementProvider.notifier).createQuestion(dto);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('질문이 등록되었습니다.\n답변은 알림으로 안내드립니다.'),
              duration: Duration(seconds: 3),
            ),
          );
          context.pop();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditMode ? '질문 수정 실패: $e' : '질문 등록 실패: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}
