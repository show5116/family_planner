import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/memo/providers/memo_provider.dart';
import 'package:family_planner/features/memo/data/models/memo_model.dart';
import 'package:family_planner/features/memo/data/dto/memo_dto.dart';
import 'package:family_planner/features/memo/data/utils/memo_editor_converter.dart';
import 'package:family_planner/features/memo/presentation/widgets/memo_tag_chips.dart';
import 'package:family_planner/features/memo/presentation/widgets/memo_editor_toolbar.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/features/settings/groups/providers/default_group_provider.dart';
import 'package:family_planner/core/widgets/group_dropdown.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/core/mixins/interstitial_ad_mixin.dart';

class MemoFormScreen extends ConsumerStatefulWidget {
  final String? memoId;

  const MemoFormScreen({super.key, this.memoId});

  @override
  ConsumerState<MemoFormScreen> createState() => _MemoFormScreenState();
}

class _MemoFormScreenState extends ConsumerState<MemoFormScreen>
    with InterstitialAdMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _focusNode = FocusNode();
  final _scrollController = ScrollController();

  late QuillController _quillController;

  List<String> _tags = [];
  String? _selectedGroupId;
  bool _isLoading = false;
  bool _isInitialized = false;

  bool get _isEditMode => widget.memoId != null;

  @override
  void initState() {
    super.initState();
    _quillController = QuillController.basic();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_isEditMode) {
        _loadMemoData();
      } else {
        _autoSelectGroup();
        setState(() => _isInitialized = true);
      }
    });
  }

  void _autoSelectGroup() {
    final filterValue = ref.read(memoSelectedFilterProvider);
    if (filterValue != null &&
        filterValue != '__personal__' &&
        filterValue.isNotEmpty) {
      _selectedGroupId = filterValue;
    } else {
      _selectedGroupId = ref.read(defaultGroupProvider);
    }
  }

  Future<void> _loadMemoData() async {
    final memoAsync = ref.read(memoDetailProvider(widget.memoId!));
    memoAsync.when(
      data: (memo) {
        final doc = memo.format == MemoFormat.delta
            ? MemoEditorConverter.toDocument(memo.content)
            : Document(); // 구버전 HTML 포맷은 빈 문서로 시작
        setState(() {
          _titleController.text = memo.title;
          _tags = memo.tags.map((t) => t.name).toList();
          _selectedGroupId =
              memo.visibility == MemoVisibility.group ? memo.groupId : null;
          _quillController.dispose();
          _quillController = QuillController(
            document: doc,
            selection: const TextSelection.collapsed(offset: 0),
          );
          _isInitialized = true;
        });
      },
      loading: () {},
      error: (e, _) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppLocalizations.of(context)!.memo_loadError}: $e')),
        );
      },
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    _quillController.dispose();
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
            if (_isInitialized)
              MemoEditorToolbar(controller: _quillController),

            Expanded(
              child: _isInitialized
                  ? ListView(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(AppSizes.spaceL),
                      children: [
                        _buildGroupSelector(l10n),
                        const SizedBox(height: AppSizes.spaceL),
                        _buildTitleField(l10n),
                        const SizedBox(height: AppSizes.spaceL),
                        _buildTagSection(l10n),
                        const SizedBox(height: AppSizes.spaceL),
                        Text(l10n.memo_content,
                            style: Theme.of(context).textTheme.titleSmall),
                        const SizedBox(height: AppSizes.spaceS),
                        _buildEditor(context, l10n),
                      ],
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),

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
                    onChanged: (value) => setState(() => _selectedGroupId = value),
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

  Widget _buildTitleField(AppLocalizations l10n) {
    return TextFormField(
      controller: _titleController,
      decoration: InputDecoration(
        labelText: l10n.memo_title,
        hintText: l10n.memo_titleHint,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return l10n.memo_titleRequired;
        if (value.trim().length < 2) return l10n.memo_titleMinLength;
        return null;
      },
      textInputAction: TextInputAction.next,
    );
  }

  Widget _buildTagSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.memo_tags, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: AppSizes.spaceS),
        MemoTagInput(
          initialTags: _tags,
          onChanged: (tags) => _tags = tags,
        ),
      ],
    );
  }

  Widget _buildEditor(BuildContext context, AppLocalizations l10n) {
    return Container(
      constraints: const BoxConstraints(minHeight: 300),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
      ),
      child: QuillEditor(
        controller: _quillController,
        focusNode: _focusNode,
        scrollController: ScrollController(),
        config: QuillEditorConfig(
          autoFocus: false,
          expands: false,
          scrollable: false,
          padding: const EdgeInsets.all(AppSizes.spaceM),
          placeholder: l10n.memo_contentHint,
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context)!;
    setState(() => _isLoading = true);

    try {
      final deltaJson = MemoEditorConverter.fromDocument(_quillController.document);
      final isGroup = _selectedGroupId != null;
      final visibilityStr = isGroup ? 'GROUP' : 'PRIVATE';
      final tagDtos = _tags.map((name) => CreateMemoTagDto(name: name)).toList();
      final notifier = ref.read(memoManagementProvider.notifier);

      if (_isEditMode) {
        final dto = UpdateMemoDto(
          title: _titleController.text.trim(),
          content: deltaJson,
          format: 'DELTA',
          visibility: visibilityStr,
          groupId: isGroup ? _selectedGroupId : null,
          tags: tagDtos.isEmpty ? null : tagDtos,
        );
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
        final dto = CreateMemoDto(
          title: _titleController.text.trim(),
          content: deltaJson.isEmpty ? null : deltaJson,
          format: 'DELTA',
          visibility: visibilityStr,
          groupId: isGroup ? _selectedGroupId : null,
          tags: tagDtos.isEmpty ? null : tagDtos,
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${AppLocalizations.of(context)!.common_error}: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
