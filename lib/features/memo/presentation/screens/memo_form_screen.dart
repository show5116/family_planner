import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/memo/providers/memo_provider.dart';
import 'package:family_planner/features/memo/data/dto/memo_dto.dart';
import 'package:family_planner/features/memo/presentation/widgets/memo_tag_chips.dart';
import 'package:family_planner/shared/widgets/editor/rich_text_editor.dart';
import 'package:family_planner/core/services/storage_service.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 메모 작성/수정 화면
class MemoFormScreen extends ConsumerStatefulWidget {
  /// null이면 작성, 값이 있으면 수정
  final String? memoId;

  const MemoFormScreen({
    super.key,
    this.memoId,
  });

  @override
  ConsumerState<MemoFormScreen> createState() => _MemoFormScreenState();
}

class _MemoFormScreenState extends ConsumerState<MemoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _categoryController = TextEditingController();
  List<String> _tags = [];
  bool _isLoading = false;

  bool get _isEditMode => widget.memoId != null;

  @override
  void initState() {
    super.initState();

    if (_isEditMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadMemoData();
      });
    }
  }

  /// 기존 메모 데이터 로드 (수정 모드)
  Future<void> _loadMemoData() async {
    final memoAsync = ref.read(memoDetailProvider(widget.memoId!));

    memoAsync.when(
      data: (memo) {
        setState(() {
          _titleController.text = memo.title;
          _contentController.text = memo.content;
          _categoryController.text = memo.category ?? '';
          _tags = memo.tags.map((t) => t.name).toList();
        });
      },
      loading: () {},
      error: (error, stack) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.memo_loadError}: $error')),
        );
      },
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title:
            Text(_isEditMode ? l10n.memo_edit : l10n.memo_create),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(AppSizes.spaceM),
              child: SizedBox(
                width: AppSizes.iconMedium,
                height: AppSizes.iconMedium,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSizes.spaceS),
              child: FilledButton(
                onPressed: _handleSubmit,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                    _isEditMode ? l10n.common_edit : l10n.common_create),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSizes.spaceL),
          children: [
            // 제목 입력
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: l10n.memo_title,
                hintText: l10n.memo_titleHint,
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.memo_titleRequired;
                }
                if (value.trim().length < 2) {
                  return l10n.memo_titleMinLength;
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppSizes.spaceL),

            // 카테고리 입력
            TextFormField(
              controller: _categoryController,
              decoration: InputDecoration(
                labelText: l10n.memo_category,
                hintText: l10n.memo_categoryHint,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppSizes.spaceL),

            // 태그 입력
            Text(
              l10n.memo_tags,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: AppSizes.spaceS),
            MemoTagInput(
              initialTags: _tags,
              onChanged: (tags) {
                _tags = tags;
              },
            ),
            const SizedBox(height: AppSizes.spaceL),

            // 내용 입력 - 리치 텍스트 에디터
            RichTextEditor(
              controller: _contentController,
              labelText: l10n.memo_content,
              hintText: l10n.memo_contentHint,
              minLines: 15,
              maxLines: 30,
              imageUploadType: EditorImageType.memos,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.memo_contentRequired;
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 등록/수정 처리
  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final l10n = AppLocalizations.of(context)!;

    setState(() {
      _isLoading = true;
    });

    try {
      final notifier = ref.read(memoManagementProvider.notifier);
      final tagDtos = _tags
          .map((name) => CreateMemoTagDto(name: name))
          .toList();
      final category = _categoryController.text.trim();

      if (_isEditMode) {
        final dto = UpdateMemoDto(
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
          category: category.isEmpty ? null : category,
          tags: tagDtos.isEmpty ? null : tagDtos,
        );
        final result =
            await notifier.updateMemo(widget.memoId!, dto);

        if (!mounted) return;

        if (result != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.memo_updateSuccess)),
          );
          context.pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.memo_updateError)),
          );
        }
      } else {
        final dto = CreateMemoDto(
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
          category: category.isEmpty ? null : category,
          tags: tagDtos.isEmpty ? null : tagDtos,
        );
        final result = await notifier.createMemo(dto);

        if (!mounted) return;

        if (result != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.memo_createSuccess)),
          );
          context.pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.memo_createError)),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${l10n.common_error}: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
