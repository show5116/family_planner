import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/memo/providers/memo_provider.dart';
import 'package:family_planner/features/memo/data/dto/memo_dto.dart';
import 'package:family_planner/features/memo/data/models/memo_model.dart';
import 'package:family_planner/features/memo/presentation/widgets/memo_tag_chips.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/core/widgets/group_dropdown.dart';
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
  MemoType _memoType = MemoType.note;
  MemoVisibility _visibility = MemoVisibility.private_;
  String? _selectedGroupId;

  // 체크리스트 항목 (작성 시 로컬 상태로 관리)
  final List<_ChecklistDraft> _checklistDrafts = [];
  final _checklistInputController = TextEditingController();

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
          _memoType = memo.type ?? MemoType.note;
          _visibility = memo.visibility ?? MemoVisibility.private_;
          _selectedGroupId = memo.groupId;
          _checklistDrafts.clear();
          for (final item in memo.checklistItems) {
            _checklistDrafts.add(_ChecklistDraft(
              id: item.id,
              content: item.content,
              isChecked: item.isChecked,
            ));
          }
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
    _checklistInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(_isEditMode ? l10n.memo_edit : l10n.memo_create),
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
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceS),
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

            // 메모 유형 선택 (수정 모드에서는 변경 불가)
            if (!_isEditMode) ...[
              Text(
                l10n.memo_typeSelect,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: AppSizes.spaceS),
              SegmentedButton<MemoType>(
                segments: [
                  ButtonSegment(
                    value: MemoType.note,
                    label: Text(l10n.memo_typeNote),
                    icon: const Icon(Icons.notes),
                  ),
                  ButtonSegment(
                    value: MemoType.checklist,
                    label: Text(l10n.memo_typeChecklist),
                    icon: const Icon(Icons.checklist),
                  ),
                ],
                selected: {_memoType},
                onSelectionChanged: (selected) {
                  setState(() {
                    _memoType = selected.first;
                  });
                },
              ),
              const SizedBox(height: AppSizes.spaceL),
            ],

            // 공개 범위 선택
            Text(
              l10n.memo_visibility,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: AppSizes.spaceS),
            SegmentedButton<MemoVisibility>(
              segments: [
                ButtonSegment(
                  value: MemoVisibility.private_,
                  label: Text(l10n.memo_visibilityPrivate),
                  icon: const Icon(Icons.lock_outline),
                ),
                ButtonSegment(
                  value: MemoVisibility.family,
                  label: Text(l10n.memo_visibilityFamily),
                  icon: const Icon(Icons.people_outline),
                ),
                ButtonSegment(
                  value: MemoVisibility.group,
                  label: Text(l10n.memo_visibilityGroup),
                  icon: const Icon(Icons.group_outlined),
                ),
              ],
              selected: {_visibility},
              onSelectionChanged: (selected) {
                setState(() {
                  _visibility = selected.first;
                  if (_visibility != MemoVisibility.group) {
                    _selectedGroupId = null;
                  }
                });
              },
            ),

            // 그룹 선택 (visibility=GROUP 일 때만 표시)
            if (_visibility == MemoVisibility.group) ...[
              const SizedBox(height: AppSizes.spaceM),
              Text(
                l10n.memo_groupSelect,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: AppSizes.spaceS),
              ref.watch(myGroupsProvider).when(
                data: (groups) => Card(
                  elevation: 0,
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest
                      .withValues(alpha: 0.3),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.spaceM,
                      vertical: AppSizes.spaceS,
                    ),
                    child: GroupDropdown(
                      groups: groups,
                      selectedGroupId: _selectedGroupId,
                      onChanged: (value) {
                        setState(() => _selectedGroupId = value);
                      },
                      style: GroupDropdownStyle.form,
                    ),
                  ),
                ),
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (_, _) => Text(l10n.common_error),
              ),
            ],
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

            // 내용 영역: 유형에 따라 에디터 or 체크리스트
            if (_memoType == MemoType.note)
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
              )
            else
              _buildChecklistEditor(l10n),
          ],
        ),
      ),
    );
  }

  /// 체크리스트 편집 UI
  Widget _buildChecklistEditor(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.memo_checklist,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: AppSizes.spaceS),

        // 항목 목록
        if (_checklistDrafts.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceM),
            child: Text(
              l10n.memo_checklistEmpty,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          )
        else
          ReorderableListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _checklistDrafts.length,
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (newIndex > oldIndex) newIndex--;
                final item = _checklistDrafts.removeAt(oldIndex);
                _checklistDrafts.insert(newIndex, item);
              });
            },
            itemBuilder: (context, index) {
              final draft = _checklistDrafts[index];
              return _ChecklistDraftTile(
                key: ValueKey(draft.key),
                draft: draft,
                onDelete: () {
                  setState(() {
                    _checklistDrafts.removeAt(index);
                  });
                },
                onChanged: (value) {
                  draft.content = value;
                },
              );
            },
          ),

        const SizedBox(height: AppSizes.spaceS),

        // 항목 추가 입력창
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _checklistInputController,
                decoration: InputDecoration(
                  hintText: l10n.memo_checklistAddHint,
                  border: const OutlineInputBorder(),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.spaceM,
                    vertical: AppSizes.spaceS,
                  ),
                ),
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _addChecklistDraft(),
              ),
            ),
            const SizedBox(width: AppSizes.spaceS),
            IconButton.filled(
              onPressed: _addChecklistDraft,
              icon: const Icon(Icons.add),
              tooltip: l10n.memo_checklistAdd,
            ),
          ],
        ),
      ],
    );
  }

  void _addChecklistDraft() {
    final text = _checklistInputController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _checklistDrafts.add(_ChecklistDraft(content: text));
    });
    _checklistInputController.clear();
  }

  /// 등록/수정 처리
  Future<void> _handleSubmit() async {
    // 체크리스트 타입일 때 항목 필수 검사
    if (_memoType == MemoType.checklist && _checklistDrafts.isEmpty) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.memo_checklistEmpty)),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context)!;
    setState(() => _isLoading = true);

    try {
      final notifier = ref.read(memoManagementProvider.notifier);
      final tagDtos = _tags.map((name) => CreateMemoTagDto(name: name)).toList();
      final category = _categoryController.text.trim();

      if (_isEditMode) {
        final dto = UpdateMemoDto(
          title: _titleController.text.trim(),
          content: _memoType == MemoType.note
              ? _contentController.text.trim()
              : '',
          category: category.isEmpty ? null : category,
          tags: tagDtos.isEmpty ? null : tagDtos,
        );
        final result = await notifier.updateMemo(widget.memoId!, dto);

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
          content: _memoType == MemoType.note
              ? _contentController.text.trim()
              : '',
          type: _memoType == MemoType.checklist ? 'CHECKLIST' : 'NOTE',
          category: category.isEmpty ? null : category,
          tags: tagDtos.isEmpty ? null : tagDtos,
        );
        final result = await notifier.createMemo(dto);

        if (!mounted) return;

        if (result != null) {
          // 체크리스트 항목 생성
          if (_memoType == MemoType.checklist &&
              _checklistDrafts.isNotEmpty) {
            final checklistNotifier =
                ref.read(checklistProvider(result.id).notifier);
            for (var i = 0; i < _checklistDrafts.length; i++) {
              await checklistNotifier.addItem(_checklistDrafts[i].content);
            }
          }

          if (!mounted) return;
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
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${l10n.common_error}: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

/// 작성 시 로컬에서 관리하는 체크리스트 항목
class _ChecklistDraft {
  final String key;
  final String? id; // 수정 모드일 때 서버 ID
  String content;
  bool isChecked;

  _ChecklistDraft({
    this.id,
    required this.content,
    this.isChecked = false,
  }) : key = id ?? UniqueKey().toString();
}

/// 체크리스트 드래프트 타일
class _ChecklistDraftTile extends StatefulWidget {
  final _ChecklistDraft draft;
  final VoidCallback onDelete;
  final ValueChanged<String> onChanged;

  const _ChecklistDraftTile({
    super.key,
    required this.draft,
    required this.onDelete,
    required this.onChanged,
  });

  @override
  State<_ChecklistDraftTile> createState() => _ChecklistDraftTileState();
}

class _ChecklistDraftTileState extends State<_ChecklistDraftTile> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.draft.content);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: AppSizes.spaceS),
      leading: const Icon(Icons.drag_handle, color: AppColors.textSecondary),
      title: TextField(
        controller: _controller,
        decoration: const InputDecoration(border: InputBorder.none),
        onChanged: widget.onChanged,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.close, size: AppSizes.iconSmall),
        onPressed: widget.onDelete,
      ),
    );
  }
}
