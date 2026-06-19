import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/memo/data/models/memo_model.dart';
import 'package:family_planner/features/memo/data/dto/memo_dto.dart';
import 'package:family_planner/features/memo/data/utils/memo_editor_converter.dart';
import 'package:family_planner/features/memo/presentation/widgets/link_preview_embed.dart';
import 'package:family_planner/features/memo/providers/memo_provider.dart';
import 'package:family_planner/features/memo/presentation/widgets/memo_tag_chips.dart';
import 'package:family_planner/features/memo/presentation/screens/memo_form_screen.dart';
import 'package:family_planner/features/memo/presentation/widgets/memo_delete_dialog.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/shared/widgets/app_error_state.dart';
import 'package:family_planner/l10n/app_localizations.dart';

class MemoDetailScreen extends ConsumerStatefulWidget {
  final String memoId;

  const MemoDetailScreen({super.key, required this.memoId});

  @override
  ConsumerState<MemoDetailScreen> createState() => _MemoDetailScreenState();
}

class _MemoDetailScreenState extends ConsumerState<MemoDetailScreen> {
  QuillController? _quillController;
  String? _loadedContent;
  bool _hasUnsavedChanges = false;
  bool _isSaving = false;
  bool _pendingSave = false;
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    if (_hasUnsavedChanges && !_isSaving) {
      _save(); // fire-and-forget: ref is still valid at dispose time
    }
    _quillController?.dispose();
    super.dispose();
  }

  void _initController(MemoModel memo) {
    if (_loadedContent == memo.content) return;
    _loadedContent = memo.content;
    _hasUnsavedChanges = false;

    final doc = memo.format == MemoFormat.delta
        ? MemoEditorConverter.toDocument(memo.content)
        : Document();
    _quillController?.dispose();
    _quillController = QuillController(
      document: doc,
      selection: const TextSelection.collapsed(offset: 0),
      readOnly: true,
    );
  }

  void _onCheckboxChanged() {
    _scheduleAutoSave();
  }

  void _scheduleAutoSave() {
    if (!_hasUnsavedChanges) {
      setState(() => _hasUnsavedChanges = true);
    }
    if (_isSaving) {
      // API 호출 중이면 타이머 대신 플래그만 세움 — 완료 후 자동 재실행
      _pendingSave = true;
      return;
    }
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 1500), () {
      if (mounted && _hasUnsavedChanges) _save();
    });
  }

  Future<void> _save() async {
    final controller = _quillController;
    if (controller == null || _isSaving) return;

    _isSaving = true;
    if (mounted) setState(() {});
    try {
      final deltaJson = MemoEditorConverter.fromDocument(controller.document);
      final result = await ref.read(memoManagementProvider.notifier).updateMemo(
            widget.memoId,
            UpdateMemoDto(content: deltaJson, format: 'DELTA'),
            refreshDetail: false,
          );
      if (result != null) {
        // refreshDetail: false이므로 provider는 구버전 유지 → _loadedContent 갱신 금지
        // (_loadedContent != memo.content 불일치로 _initController가 컨트롤러를 재초기화하는 것 방지)
        _hasUnsavedChanges = false;
        if (mounted) setState(() {});
      }
    } finally {
      _isSaving = false;
      if (_pendingSave && mounted) {
        _pendingSave = false;
        _scheduleAutoSave();
      } else if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final memoAsync = ref.watch(memoDetailProvider(widget.memoId));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(l10n.memo_detail),
        actions: [
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.spaceM),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
            ),

          memoAsync.valueOrNull != null
              ? IconButton(
                  icon: Icon(
                    memoAsync.value!.isPinned
                        ? Icons.push_pin
                        : Icons.push_pin_outlined,
                    color: memoAsync.value!.isPinned ? Colors.amber : Colors.white,
                  ),
                  tooltip: memoAsync.value!.isPinned ? '핀 해제' : '대시보드에 고정',
                  onPressed: () =>
                      ref.read(memoPinProvider.notifier).togglePin(widget.memoId),
                )
              : const SizedBox.shrink(),
          _buildMenu(context, ref, l10n),
        ],
      ),
      body: memoAsync.when(
        data: (memo) {
          _initController(memo);
          final controller = _quillController;
          final dateFormat = DateFormat('yyyy.MM.dd HH:mm');
          final checked = memo.checklistMeta.checked;
          final total = memo.checklistMeta.total;

          return SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.spaceL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    memo.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: AppSizes.spaceS),

                  Row(
                    children: [
                      Icon(Icons.person_outline,
                          size: AppSizes.iconSmall,
                          color: AppColors.textSecondary),
                      const SizedBox(width: AppSizes.spaceXS),
                      Text(memo.user.name,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                              )),
                      const SizedBox(width: AppSizes.spaceM),
                      Icon(Icons.access_time,
                          size: AppSizes.iconSmall,
                          color: AppColors.textSecondary),
                      const SizedBox(width: AppSizes.spaceXS),
                      Text(dateFormat.format(memo.updatedAt),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                              )),
                    ],
                  ),

                  if (memo.tags.isNotEmpty) ...[
                    const SizedBox(height: AppSizes.spaceM),
                    MemoTagChips(tags: memo.tags),
                  ],

                  if (total > 0) ...[
                    const SizedBox(height: AppSizes.spaceM),
                    _ChecklistProgressBar(
                      checked: controller != null
                          ? _countChecked(controller)
                          : checked,
                      total: total,
                      controller: controller,
                      onPatchAll: (checkAll) => _patchAll(checkAll, controller),
                    ),
                  ],

                  const SizedBox(height: AppSizes.spaceL),
                  const Divider(),
                  const SizedBox(height: AppSizes.spaceM),

                  if (controller != null)
                    _MemoViewer(
                      key: ValueKey(memo.content),
                      controller: controller,
                      onCheckboxChanged: _onCheckboxChanged,
                    )
                  else
                    const Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => AppErrorState(
          error: error,
          title: l10n.memo_loadError,
          onRetry: () => ref.invalidate(memoDetailProvider(widget.memoId)),
        ),
      ),
    );
  }

  /// 컨트롤러에서 현재 체크된 항목 수 계산 (미저장 상태 진행률 표시용)
  int _countChecked(QuillController? controller) {
    if (controller == null) return 0;
    try {
      final ops = controller.document.toDelta().toJson() as List;
      return ops.where((op) {
        final attrs = ((op as Map)['attributes'] as Map?);
        return attrs?['list'] == 'checked';
      }).length;
    } catch (_) {
      return 0;
    }
  }

  /// 전체 선택/해제 — 컨트롤러만 업데이트하고 저장 버튼 활성화
  void _patchAll(bool checkAll, QuillController? controller) {
    if (controller == null) return;
    try {
      final ops = controller.document.toDelta().toJson() as List;
      int offset = 0;
      for (final raw in ops) {
        final op = raw as Map;
        final insert = op['insert'] as String? ?? '';
        final attrs = (op['attributes'] as Map?)?.cast<String, dynamic>() ?? {};
        final list = attrs['list'] as String?;
        if (list == 'unchecked' || list == 'checked') {
          final lineEnd = offset + insert.length - 1;
          controller.formatText(
            lineEnd,
            0,
            Attribute.fromKeyValue('list', checkAll ? 'checked' : 'unchecked'),
          );
        }
        offset += insert.length;
      }
      _scheduleAutoSave();
    } catch (_) {}
  }

  Widget _buildMenu(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    return PopupMenuButton<String>(
      onSelected: (value) => _handleMenuAction(context, ref, l10n, value),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(children: [
            const Icon(Icons.edit, size: AppSizes.iconSmall),
            const SizedBox(width: AppSizes.spaceS),
            Text(l10n.common_edit),
          ]),
        ),
        PopupMenuItem(
          value: 'duplicate',
          child: Row(children: [
            const Icon(Icons.copy, size: AppSizes.iconSmall),
            const SizedBox(width: AppSizes.spaceS),
            Text(l10n.memo_duplicate),
          ]),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(children: [
            const Icon(Icons.delete,
                size: AppSizes.iconSmall, color: AppColors.error),
            const SizedBox(width: AppSizes.spaceS),
            Text(l10n.common_delete,
                style: const TextStyle(color: AppColors.error)),
          ]),
        ),
      ],
    );
  }

  Future<void> _handleMenuAction(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    String value,
  ) async {
    if (value == 'edit') {
      context.push('/memo/${widget.memoId}/edit');
    } else if (value == 'duplicate') {
      final memo = ref.read(memoDetailProvider(widget.memoId)).valueOrNull;
      if (memo == null || !context.mounted) return;
      context.push(
        AppRoutes.memoAdd,
        extra: MemoDuplicateData(
          title: '${memo.title} (복사본)',
          content: memo.content,
          tags: memo.tags.map((t) => t.name).toList(),
        ),
      );
    } else if (value == 'delete') {
      MemoDeleteDialog.show(context, ref, widget.memoId);
    }
  }
}

/// 체크리스트 진행률 바 + 전체 선택/해제
class _ChecklistProgressBar extends StatelessWidget {
  final int checked;
  final int total;
  final QuillController? controller;
  final void Function(bool checkAll) onPatchAll;

  const _ChecklistProgressBar({
    required this.checked,
    required this.total,
    required this.controller,
    required this.onPatchAll,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Icon(Icons.checklist, size: AppSizes.iconSmall, color: AppColors.primary),
        const SizedBox(width: AppSizes.spaceXS),
        Text(
          l10n.memo_checklistProgress(checked, total),
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: AppColors.textSecondary),
        ),
        const Spacer(),
        if (checked < total)
          TextButton.icon(
            onPressed: () => onPatchAll(true),
            icon: const Icon(Icons.check_box, size: AppSizes.iconSmall),
            label: Text(l10n.memo_checklistSelectAll),
            style: TextButton.styleFrom(foregroundColor: AppColors.textSecondary),
          ),
        if (checked > 0)
          TextButton.icon(
            onPressed: () => onPatchAll(false),
            icon: const Icon(Icons.refresh, size: AppSizes.iconSmall),
            label: Text(l10n.memo_checklistReset),
            style: TextButton.styleFrom(foregroundColor: AppColors.textSecondary),
          ),
      ],
    );
  }
}

/// Quill 읽기 전용 뷰어
///
/// 체크박스 탭 시 컨트롤러만 업데이트하고 onCheckboxChanged로 상위에 알림.
/// API 호출은 상위의 저장 버튼에서 일괄 처리.
class _MemoViewer extends StatefulWidget {
  final QuillController controller;
  final VoidCallback onCheckboxChanged;

  const _MemoViewer({
    super.key,
    required this.controller,
    required this.onCheckboxChanged,
  });

  @override
  State<_MemoViewer> createState() => _MemoViewerState();
}

class _MemoViewerState extends State<_MemoViewer> {
  int _nodeOffset(dynamic node) {
    try {
      final offset = (node as dynamic).documentOffset as int;
      final length = (node as dynamic).length as int;
      return offset + length - 1;
    } catch (_) {
      return 0;
    }
  }

  void _onCheckboxTap(bool newValue, int offset) {
    widget.controller.formatText(
      offset,
      0,
      Attribute.fromKeyValue('list', newValue ? 'checked' : 'unchecked'),
    );
    widget.onCheckboxChanged();
  }

  @override
  Widget build(BuildContext context) {
    return QuillEditor(
      controller: widget.controller,
      focusNode: FocusNode(),
      scrollController: ScrollController(),
      config: QuillEditorConfig(
        autoFocus: false,
        expands: false,
        scrollable: false,
        padding: EdgeInsets.zero,
        showCursor: false,
        checkBoxReadOnly: false,
        embedBuilders: [
          LinkPreviewEmbedBuilder(readOnly: true),
        ],
        customLeadingBlockBuilder: (node, config) {
          final listAttr = config.attribute.value as String?;
          if (listAttr != 'unchecked' && listAttr != 'checked') return null;
          return QuillCheckboxPoint(
            size: config.lineSize ?? 18,
            value: config.value,
            enabled: true,
            onChanged: (val) => _onCheckboxTap(val, _nodeOffset(node)),
          );
        },
      ),
    );
  }
}
