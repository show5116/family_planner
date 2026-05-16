import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/memo/providers/memo_provider.dart';
import 'package:family_planner/features/memo/data/repositories/memo_repository.dart';
import 'package:family_planner/features/memo/data/dto/memo_dto.dart';
import 'package:family_planner/features/memo/data/models/memo_model.dart';
import 'package:family_planner/features/memo/presentation/widgets/memo_tag_chips.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/features/settings/groups/providers/default_group_provider.dart';
import 'package:family_planner/core/widgets/group_dropdown.dart';
import 'package:family_planner/shared/widgets/editor/rich_text_editor.dart';
import 'package:family_planner/core/services/storage_service.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/core/mixins/interstitial_ad_mixin.dart';

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

class _MemoFormScreenState extends ConsumerState<MemoFormScreen>
    with InterstitialAdMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  List<String> _tags = [];
  MemoType _memoType = MemoType.note;
  // null = 개인(PRIVATE), non-null = 그룹(GROUP)
  String? _selectedGroupId;

  // 체크리스트 항목 (작성 시 로컬 상태로 관리)
  final List<_ChecklistDraft> _checklistDrafts = [];
  final List<TextEditingController> _draftControllers = [];
  // 수정 모드에서 원본 항목 (diff 비교용): {id: originalContent}
  final Map<String, String> _originalChecklistItems = {};
  final _checklistInputController = TextEditingController();
  final _checklistFocusNode = FocusNode();

  bool _isLoading = false;

  bool get _isEditMode => widget.memoId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadMemoData();
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _autoSelectGroup();
      });
    }
  }

  /// 신규 메모 작성 시 현재 필터 기반 그룹 자동 선택
  void _autoSelectGroup() {
    final filterValue = ref.read(memoSelectedFilterProvider);
    String? autoGroupId;
    if (filterValue != null &&
        filterValue != '__personal__' &&
        filterValue.isNotEmpty) {
      autoGroupId = filterValue;
    } else {
      autoGroupId = ref.read(defaultGroupProvider);
    }
    if (mounted) {
      setState(() => _selectedGroupId = autoGroupId);
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
          _tags = memo.tags.map((t) => t.name).toList();
          _memoType = memo.type ?? MemoType.note;
          // 수정 모드: visibility가 GROUP이면 groupId 사용, 아니면 null(개인)
          _selectedGroupId =
              (memo.visibility == MemoVisibility.group) ? memo.groupId : null;
          _checklistDrafts.clear();
          for (final c in _draftControllers) {
            c.dispose();
          }
          _draftControllers.clear();
          _originalChecklistItems.clear();
          for (final item in memo.checklistItems) {
            _checklistDrafts.add(_ChecklistDraft(
              id: item.id,
              content: item.content,
              isChecked: item.isChecked,
            ));
            _draftControllers.add(TextEditingController(text: item.content));
            _originalChecklistItems[item.id] = item.content;
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
    _checklistInputController.dispose();
    _checklistFocusNode.dispose();
    for (final c in _draftControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? l10n.memo_edit : l10n.memo_create),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppSizes.spaceL),
                children: [
                  // 그룹 선택 (최상단)
                  _buildGroupSelector(l10n),
                  const SizedBox(height: AppSizes.spaceL),

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
            // 하단 버튼
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.spaceL),
                child: SizedBox(
                  width: double.infinity,
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : FilledButton(
                          onPressed: _handleSubmit,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
                            _isEditMode ? l10n.common_edit : l10n.common_create,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 그룹 선택 드롭다운 (일정 화면 GroupSelector와 동일한 스타일)
  Widget _buildGroupSelector(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.schedule_group,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AppSizes.spaceS),
        Card(
          elevation: 0,
          color: Theme.of(context)
              .colorScheme
              .surfaceContainerHighest
              .withValues(alpha: 0.3),
          child: ref.watch(myGroupsProvider).when(
            data: (groups) => Padding(
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
                showPersonalOption: true,
              ),
            ),
            loading: () => const Padding(
              padding: EdgeInsets.all(AppSizes.spaceM),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, _) => Padding(
              padding: const EdgeInsets.all(AppSizes.spaceM),
              child: Text(l10n.common_error),
            ),
          ),
        ),
      ],
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
            buildDefaultDragHandles: false,
            itemCount: _checklistDrafts.length,
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (newIndex > oldIndex) newIndex--;
                final item = _checklistDrafts.removeAt(oldIndex);
                _checklistDrafts.insert(newIndex, item);
                final ctrl = _draftControllers.removeAt(oldIndex);
                _draftControllers.insert(newIndex, ctrl);
              });
            },
            itemBuilder: (context, index) {
              final draft = _checklistDrafts[index];
              return _ChecklistDraftTile(
                key: ValueKey(draft.key),
                index: index,
                controller: _draftControllers[index],
                onDelete: () {
                  setState(() {
                    _checklistDrafts.removeAt(index);
                    _draftControllers.removeAt(index).dispose();
                  });
                },
                onChanged: (value) {
                  _checklistDrafts[index].content = value;
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
                focusNode: _checklistFocusNode,
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
      _draftControllers.add(TextEditingController(text: text));
    });
    _checklistInputController.clear();
    _checklistFocusNode.requestFocus();
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

    // _selectedGroupId != null → GROUP, null → PRIVATE
    final isGroup = _selectedGroupId != null;
    final visibilityStr = isGroup ? 'GROUP' : 'PRIVATE';

    try {
      final notifier = ref.read(memoManagementProvider.notifier);
      final tagDtos = _tags.map((name) => CreateMemoTagDto(name: name)).toList();

      if (_isEditMode) {
        final dto = UpdateMemoDto(
          title: _titleController.text.trim(),
          content: _memoType == MemoType.note
              ? _contentController.text.trim()
              : '',
          visibility: visibilityStr,
          groupId: isGroup ? _selectedGroupId : null,
          tags: tagDtos.isEmpty ? null : tagDtos,
        );

        // 체크리스트 diff 처리
        if (_memoType == MemoType.checklist) {
          final repository = ref.read(memoRepositoryProvider);
          final memoId = widget.memoId!;
          final currentIds = _checklistDrafts
              .where((d) => d.id != null)
              .map((d) => d.id!)
              .toSet();

          // 삭제: 원본에 있지만 현재 없는 항목
          for (final originalId in _originalChecklistItems.keys) {
            if (!currentIds.contains(originalId)) {
              await repository.deleteChecklistItem(memoId, originalId);
            }
          }

          for (int i = 0; i < _checklistDrafts.length; i++) {
            final draft = _checklistDrafts[i];
            if (draft.id == null) {
              // 추가: id 없는 새 항목
              await repository.addChecklistItem(
                memoId,
                CreateChecklistItemDto(content: draft.content, order: i),
              );
            } else if (_originalChecklistItems[draft.id] != draft.content) {
              // 수정: 내용이 바뀐 항목
              await repository.updateChecklistItem(
                memoId,
                draft.id!,
                UpdateChecklistItemDto(content: draft.content, order: i),
              );
            }
          }
        }

        final result = await notifier.updateMemo(widget.memoId!, dto);

        if (!mounted) return;
        if (result != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.memo_updateSuccess)),
          );
          showInterstitialThenNavigate(() { if (mounted) context.pop(); });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.memo_updateError)),
          );
        }
      } else {
        final checklistDtos = _memoType == MemoType.checklist
            ? _checklistDrafts
                .asMap()
                .entries
                .map((e) => CreateChecklistItemDto(
                      content: e.value.content,
                      order: e.key,
                    ))
                .toList()
            : null;

        final dto = CreateMemoDto(
          title: _titleController.text.trim(),
          content: _memoType == MemoType.note
              ? _contentController.text.trim()
              : null,
          type: _memoType == MemoType.checklist ? 'CHECKLIST' : 'NOTE',
          visibility: visibilityStr,
          groupId: isGroup ? _selectedGroupId : null,
          tags: tagDtos.isEmpty ? null : tagDtos,
          checklistItems: checklistDtos,
        );
        final result = await notifier.createMemo(dto);

        if (!mounted) return;

        if (result != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.memo_createSuccess)),
          );
          showInterstitialThenNavigate(() { if (mounted) context.pop(); });
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
class _ChecklistDraftTile extends StatelessWidget {
  final int index;
  final TextEditingController controller;
  final VoidCallback onDelete;
  final ValueChanged<String> onChanged;

  const _ChecklistDraftTile({
    super.key,
    required this.index,
    required this.controller,
    required this.onDelete,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: AppSizes.spaceS),
      leading: ReorderableDragStartListener(
        index: index,
        child: const Icon(Icons.drag_handle, color: AppColors.textSecondary),
      ),
      title: TextField(
        controller: controller,
        decoration: const InputDecoration(border: InputBorder.none),
        onChanged: onChanged,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.close, size: AppSizes.iconSmall),
        onPressed: onDelete,
      ),
    );
  }
}
