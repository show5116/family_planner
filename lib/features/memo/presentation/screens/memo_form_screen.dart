import 'dart:async';
import 'dart:convert';

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
import 'package:family_planner/features/memo/data/repositories/link_preview_repository.dart';
import 'package:family_planner/features/memo/data/repositories/memo_repository.dart';
import 'package:family_planner/features/memo/presentation/widgets/memo_tag_chips.dart';
import 'package:family_planner/features/memo/presentation/widgets/memo_editor_toolbar.dart';
import 'package:family_planner/features/memo/presentation/widgets/link_preview_embed.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/features/settings/groups/providers/default_group_provider.dart';
import 'package:family_planner/core/widgets/group_dropdown.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/core/mixins/interstitial_ad_mixin.dart';

/// 복제 시 초기값으로 전달하는 데이터 클래스
class MemoDuplicateData {
  final String title;
  final String? content;
  final List<String> tags;

  const MemoDuplicateData({
    required this.title,
    this.content,
    this.tags = const [],
  });
}

class MemoFormScreen extends ConsumerStatefulWidget {
  final String? memoId;
  /// 복제 시 초기 데이터 (생성 모드에서만 사용)
  final MemoDuplicateData? initialData;

  const MemoFormScreen({super.key, this.memoId, this.initialData});

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
  // 이미 프리뷰 생성 중인 URL (중복 요청 방지)
  final Set<String> _fetchingUrls = {};
  // 이미 프리뷰가 삽입된 URL (재감지 방지)
  final Set<String> _insertedPreviewUrls = {};
  // compose()로 직접 삽입 중인지 여부 (리스너 루프 방지) — 변경 가능해야 함
  // ignore: prefer_final_fields
  bool _isComposing = false;

  List<String> _tags = [];
  String? _selectedGroupId;
  bool _isLoading = false;
  bool _isInitialized = false;

  // 편집 잠금
  // ignore: prefer_final_fields
  bool _lockAcquired = false;
  Timer? _heartbeatTimer;

  Future<void> _acquireLock() async {
    if (!_isEditMode) return;
    try {
      final repo = ref.read(memoRepositoryProvider);
      await repo.acquireLock(widget.memoId!);
      _lockAcquired = true;
      _heartbeatTimer = Timer.periodic(const Duration(seconds: 30), (_) {
        ref.read(memoRepositoryProvider).heartbeat(widget.memoId!);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
        );
        context.pop();
      }
    }
  }

  void _releaseLock() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    if (_lockAcquired && widget.memoId != null) {
      _lockAcquired = false;
      ref.read(memoRepositoryProvider).releaseLock(widget.memoId!);
    }
  }

bool get _isEditMode => widget.memoId != null;

  @override
  void initState() {
    super.initState();
    _quillController = QuillController.basic();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_isEditMode) {
        _loadMemoData();
        _acquireLock();
      } else {
        _autoSelectGroup();
        _applyInitialData();
        _attachEnterListener();
        setState(() => _isInitialized = true);
      }
    });
  }

  void _applyInitialData() {
    final data = widget.initialData;
    if (data == null) return;
    _titleController.text = data.title;
    _tags = List.of(data.tags);
    if (data.content != null && data.content!.isNotEmpty) {
      final doc = MemoEditorConverter.toDocument(data.content!);
      _quillController.dispose();
      _quillController = QuillController(
        document: doc,
        selection: const TextSelection.collapsed(offset: 0),
      );
      _preloadInsertedUrls(data.content);
    }
  }

  void _attachEnterListener() {
    _quillController.changes.listen(_onDocumentChange);
  }

  void _onDocumentChange(DocChange change) {
    // _isComposing 중 발생하는 변경은 무시 (compose()로 embed 삽입 시 루프 방지)
    if (_isComposing) return;

    final ops = change.change.toJson();
    final isEnter = ops.any((op) {
      final insert = (op as Map)['insert'];
      return insert is String && insert.contains('\n');
    });
    if (!isEnter) return;

    _detectLinkOnPreviousLine();
  }

  void _detectLinkOnPreviousLine() {
    final cursor = _quillController.selection.baseOffset;
    if (cursor <= 0) return;

    final ops = _quillController.document.toDelta().toJson() as List;

    // 문서를 문자 단위로 펼쳐서 각 위치의 (char, link) 정보를 수집
    // 엔터 직전 줄 = cursor-1 위치의 \n 부터 그 앞 \n 사이의 구간
    final List<({String ch, String? link})> chars = [];
    for (final raw in ops) {
      final op = raw as Map;
      final insert = op['insert'];
      if (insert is Map) {
        chars.add((ch: '\x00', link: null)); // embed는 비문자로 표시
        continue;
      }
      if (insert is! String) continue;
      final link = ((op['attributes'] as Map?)?.cast<String, dynamic>() ?? {})['link'] as String?;
      for (final ch in insert.split('')) {
        chars.add((ch: ch, link: link));
      }
    }

    // cursor-1 이 엔터 직후이므로, 엔터가 삽입된 위치 = cursor-1
    final newlinePos = cursor - 1;
    if (newlinePos < 0 || newlinePos >= chars.length) return;
    if (chars[newlinePos].ch != '\n') return; // 직전이 \n이 아니면 엔터가 아님

    // 그 \n 바로 앞 줄의 시작을 찾는다
    int lineStart = 0;
    for (int i = newlinePos - 1; i >= 0; i--) {
      if (chars[i].ch == '\n') {
        lineStart = i + 1;
        break;
      }
    }

    // lineStart ~ newlinePos-1 구간에서 link 탐색
    String? linkUrl;
    for (int i = lineStart; i < newlinePos; i++) {
      final link = chars[i].link;
      if (link != null) {
        linkUrl = link;
        break;
      }
    }

    if (linkUrl == null) return;
    if (_fetchingUrls.contains(linkUrl) || _insertedPreviewUrls.contains(linkUrl)) return;
    _fetchingUrls.add(linkUrl);
    _insertLinkPreview(linkUrl, cursor);
  }

  Future<void> _insertLinkPreview(String url, int insertOffset) async {
    final repo = ref.read(linkPreviewRepositoryProvider);
    final preview = await repo.fetchPreview(url);
    _fetchingUrls.remove(url);
    if (preview == null || !preview.hasContent || !mounted) return;

    _insertedPreviewUrls.add(url);

    _isComposing = true;
    try {
      // replaceText는 나머지 문서를 자동 retain — compose()와 달리 assertion 없음
      _quillController.replaceText(
        insertOffset,
        0,
        BlockEmbed.custom(
          CustomBlockEmbed(kLinkPreviewEmbedKey, jsonEncode(preview.toJson())),
        ),
        TextSelection.collapsed(offset: insertOffset + 1),
      );
    } finally {
      _isComposing = false;
    }
  }

  /// 선택된 텍스트에 하이퍼링크를 적용 (툴바 버튼용)
  /// 텍스트가 선택된 경우에만 호출됨
  void _applyHyperlink(String url) {
    final sel = _quillController.selection;
    if (sel.isCollapsed) return;
    _quillController.formatText(sel.start, sel.end - sel.start, LinkAttribute(url));
  }

  /// embedData: 삭제할 임베드의 JSON 문자열 (link_preview_embed에서 전달)
  void _deleteLinkPreview(String embedData) {
    final ops = _quillController.document.toDelta().toJson() as List;
    int p = 0;

    // 1) Delta를 순회해서 해당 embed의 정확한 위치를 찾는다
    int? embedPos;
    int linkStart = -1;
    int linkEnd = -1;

    for (final raw in ops) {
      final op = raw as Map;
      final insert = op['insert'];

      if (insert is Map) {
        // embed op — 데이터 일치 여부 확인
        final embedVal = insert[kLinkPreviewEmbedKey];
        if (embedVal != null && embedVal.toString() == embedData) {
          embedPos = p;
        }
        p += 1;
      } else if (insert is String) {
        final attrs = (op['attributes'] as Map?)?.cast<String, dynamic>() ?? {};
        final hasLink = attrs['link'] != null;

        for (int i = 0; i < insert.length; i++) {
          if (embedPos != null) break; // embed 이미 찾음 — link 탐색 불필요
          final ch = insert[i];
          if (ch == '\n') {
            // 새 줄 시작 → 링크 범위 리셋
            linkStart = -1;
            linkEnd = -1;
          } else if (hasLink) {
            if (linkStart == -1) linkStart = p + i;
            linkEnd = p + i + 1;
          }
        }
        p += insert.length;
      } else {
        p += 1;
      }

      if (embedPos != null) break;
    }

    if (embedPos == null) return;

    _isComposing = true;
    try {
      // embed + 뒤따르는 \n 삭제 (뒤의 \n이 없을 수도 있으므로 1글자만 삭제)
      _quillController.replaceText(
        embedPos,
        1,
        '',
        TextSelection.collapsed(offset: embedPos),
      );

      // 직전 줄에 link attribute가 있으면 plain text로 되돌리기
      final hasPrevLink = linkStart != -1 && linkEnd > linkStart;
      if (hasPrevLink) {
        _quillController.formatText(
          linkStart,
          linkEnd - linkStart,
          const LinkAttribute(null),
        );
      }
    } finally {
      _isComposing = false;
    }
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

  /// Delta JSON에서 이미 존재하는 link-preview embed의 URL을 추출해
  /// _insertedPreviewUrls에 등록 (수정 모드 진입 시 재감지 방지)
  void _preloadInsertedUrls(String? deltaJson) {
    if (deltaJson == null || deltaJson.isEmpty) return;
    try {
      final ops = (jsonDecode(deltaJson) as List);
      for (final raw in ops) {
        final insert = (raw as Map)['insert'];
        if (insert is Map) {
          final embedRaw = insert[kLinkPreviewEmbedKey];
          if (embedRaw != null) {
            try {
              final map = jsonDecode(embedRaw.toString()) as Map<String, dynamic>;
              final url = map['url'] as String?;
              if (url != null) _insertedPreviewUrls.add(url);
            } catch (_) {}
          }
        }
      }
    } catch (_) {}
  }

  Future<void> _loadMemoData() async {
    final memoAsync = ref.read(memoDetailProvider(widget.memoId!));
    memoAsync.when(
      data: (memo) {
        final doc = memo.format == MemoFormat.delta
            ? MemoEditorConverter.toDocument(memo.content)
            : Document(); // 구버전 HTML 포맷은 빈 문서로 시작
        _preloadInsertedUrls(memo.content); // 기존 embed URL 등록
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
        _attachEnterListener();
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
    _releaseLock();
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
              MemoEditorToolbar(
                controller: _quillController,
                onLinkPreview: _applyHyperlink,
              ),

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
                    personalLabel: AppLocalizations.of(context)!.memo_personal,
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
    // 현재 선택된 그룹 기준으로 기존 태그 목록을 자동완성 후보로 제공
    final isGroup = _selectedGroupId != null;
    final suggestedTags = ref.watch(
      memoTagsProvider(
        groupId: isGroup ? _selectedGroupId : null,
        personal: isGroup ? null : true,
      ),
    ).valueOrNull ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.memo_tags, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: AppSizes.spaceS),
        MemoTagInput(
          initialTags: _tags,
          onChanged: (tags) => _tags = tags,
          suggestedTags: suggestedTags,
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
          embedBuilders: [
            LinkPreviewEmbedBuilder(
              readOnly: false,
              onDelete: _deleteLinkPreview,
            ),
          ],
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
        final result = await notifier.updateMemo(widget.memoId!, dto, refreshList: true);
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
