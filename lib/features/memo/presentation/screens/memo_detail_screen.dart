import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/memo/data/models/memo_model.dart';
import 'package:family_planner/features/memo/providers/memo_provider.dart';
import 'package:family_planner/features/memo/presentation/widgets/memo_tag_chips.dart';
import 'package:family_planner/features/memo/presentation/widgets/memo_delete_dialog.dart';
import 'package:family_planner/shared/widgets/app_error_state.dart';
import 'package:family_planner/shared/widgets/rich_text_viewer.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 메모 상세 화면
class MemoDetailScreen extends ConsumerStatefulWidget {
  final String memoId;

  const MemoDetailScreen({
    super.key,
    required this.memoId,
  });

  @override
  ConsumerState<MemoDetailScreen> createState() => _MemoDetailScreenState();
}

class _MemoDetailScreenState extends ConsumerState<MemoDetailScreen> {
  bool _checklistInitialized = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final memoAsync = ref.watch(memoDetailProvider(widget.memoId));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(l10n.memo_detail),
        actions: [
          memoAsync.whenData((memo) => memo).valueOrNull != null
              ? IconButton(
                  icon: Icon(
                    memoAsync.value!.isPinned
                        ? Icons.push_pin
                        : Icons.push_pin_outlined,
                    color: memoAsync.value!.isPinned
                        ? AppColors.primary
                        : null,
                  ),
                  tooltip: memoAsync.value!.isPinned ? '핀 해제' : '대시보드에 고정',
                  onPressed: () async {
                    await ref
                        .read(memoPinProvider.notifier)
                        .togglePin(widget.memoId);
                  },
                )
              : const SizedBox.shrink(),
          _buildMenu(context, ref, l10n),
        ],
      ),
      body: memoAsync.when(
        data: (memo) {
          // 체크리스트 타입이면 provider 초기화 (최초 1회)
          if (memo.type == MemoType.checklist && !_checklistInitialized) {
            _checklistInitialized = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref
                  .read(checklistProvider(widget.memoId).notifier)
                  .init(memo.checklistItems);
            });
          }

          final dateFormat = DateFormat('yyyy.MM.dd HH:mm');

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.spaceL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 제목
                Text(
                  memo.title,
                  style:
                      Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                ),
                const SizedBox(height: AppSizes.spaceS),

                // 메타 정보
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: AppSizes.iconSmall,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: AppSizes.spaceXS),
                    Text(
                      memo.user.name,
                      style:
                          Theme.of(context).textTheme.bodySmall?.copyWith(
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
                      dateFormat.format(memo.updatedAt),
                      style:
                          Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                    ),
                  ],
                ),

                // 태그
                if (memo.tags.isNotEmpty) ...[
                  const SizedBox(height: AppSizes.spaceM),
                  MemoTagChips(tags: memo.tags),
                ],

                const SizedBox(height: AppSizes.spaceL),
                const Divider(),
                const SizedBox(height: AppSizes.spaceL),

                // 내용: 타입에 따라 분기
                if (memo.type == MemoType.checklist)
                  _ChecklistView(memoId: widget.memoId)
                else
                  RichTextViewer(content: memo.content),
              ],
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

  Widget _buildMenu(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    return PopupMenuButton<String>(
      onSelected: (value) => _handleMenuAction(context, ref, l10n, value),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              const Icon(Icons.edit, size: AppSizes.iconSmall),
              const SizedBox(width: AppSizes.spaceS),
              Text(l10n.common_edit),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              const Icon(Icons.delete,
                  size: AppSizes.iconSmall, color: AppColors.error),
              const SizedBox(width: AppSizes.spaceS),
              Text(l10n.common_delete,
                  style: const TextStyle(color: AppColors.error)),
            ],
          ),
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
    } else if (value == 'delete') {
      MemoDeleteDialog.show(context, ref, widget.memoId);
    }
  }
}

/// 체크리스트 뷰 위젯
class _ChecklistView extends ConsumerWidget {
  final String memoId;

  const _ChecklistView({required this.memoId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final checklistAsync = ref.watch(checklistProvider(memoId));

    return checklistAsync.when(
      data: (items) => _buildContent(context, ref, l10n, items),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text('$e',
          style: const TextStyle(color: AppColors.error)),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    List<ChecklistItem> items,
  ) {
    final notifier = ref.read(checklistProvider(memoId).notifier);
    final checked = items.where((i) => i.isChecked).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 헤더: 진행률 + 전체 초기화 버튼
        Row(
          children: [
            Icon(Icons.checklist,
                size: AppSizes.iconSmall, color: AppColors.primary),
            const SizedBox(width: AppSizes.spaceXS),
            Text(
              l10n.memo_checklistProgress(checked, items.length),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const Spacer(),
            if (items.isNotEmpty) ...[
              if (items.any((i) => !i.isChecked))
                TextButton.icon(
                  onPressed: () => notifier.toggleAll(checkAll: true),
                  icon: const Icon(Icons.check_box, size: AppSizes.iconSmall),
                  label: Text(l10n.memo_checklistSelectAll),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                  ),
                ),
              if (items.any((i) => i.isChecked))
                TextButton.icon(
                  onPressed: () => notifier.toggleAll(checkAll: false),
                  icon: const Icon(Icons.refresh, size: AppSizes.iconSmall),
                  label: Text(l10n.memo_checklistReset),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                  ),
                ),
            ],
          ],
        ),
        const SizedBox(height: AppSizes.spaceS),

        // 항목 목록
        if (items.isEmpty)
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: AppSizes.spaceM),
            child: Text(
              l10n.memo_checklistEmpty,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          )
        else
          ...items.map((item) => _ChecklistItemTile(
                item: item,
                memoId: memoId,
                notifier: notifier,
              )),

        const SizedBox(height: AppSizes.spaceM),

        // 항목 추가 버튼
        _AddChecklistItemRow(memoId: memoId, notifier: notifier, l10n: l10n),
      ],
    );
  }

}

/// 체크리스트 단일 항목 타일
class _ChecklistItemTile extends ConsumerStatefulWidget {
  final ChecklistItem item;
  final String memoId;
  final ChecklistNotifier notifier;

  const _ChecklistItemTile({
    required this.item,
    required this.memoId,
    required this.notifier,
  });

  @override
  ConsumerState<_ChecklistItemTile> createState() =>
      _ChecklistItemTileState();
}

class _ChecklistItemTileState extends ConsumerState<_ChecklistItemTile> {
  bool _isEditing = false;
  late final TextEditingController _editController;

  @override
  void initState() {
    super.initState();
    _editController = TextEditingController(text: widget.item.content);
  }

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final item = widget.item;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          // 체크박스
          Checkbox(
            value: item.isChecked,
            onChanged: (_) => widget.notifier.toggleItem(item.id),
          ),

          // 내용 (탭 시 편집 모드)
          Expanded(
            child: _isEditing
                ? TextField(
                    controller: _editController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onSubmitted: (_) => _saveEdit(),
                  )
                : GestureDetector(
                    onTap: () => setState(() => _isEditing = true),
                    child: Text(
                      item.content,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            decoration: item.isChecked
                                ? TextDecoration.lineThrough
                                : null,
                            color: item.isChecked
                                ? AppColors.textSecondary
                                : null,
                          ),
                    ),
                  ),
          ),

          // 편집 중: 저장/취소 / 아닐 때: 삭제
          if (_isEditing) ...[
            IconButton(
              icon: const Icon(Icons.check, size: AppSizes.iconSmall),
              onPressed: _saveEdit,
              tooltip: l10n.common_confirm,
            ),
            IconButton(
              icon: const Icon(Icons.close, size: AppSizes.iconSmall),
              onPressed: () {
                setState(() {
                  _isEditing = false;
                  _editController.text = item.content;
                });
              },
              tooltip: l10n.common_cancel,
            ),
          ] else
            IconButton(
              icon: const Icon(Icons.delete_outline,
                  size: AppSizes.iconSmall, color: AppColors.textSecondary),
              onPressed: () => widget.notifier.deleteItem(item.id),
              tooltip: l10n.memo_checklistDeleteItem,
            ),
        ],
      ),
    );
  }

  Future<void> _saveEdit() async {
    final newContent = _editController.text.trim();
    if (newContent.isNotEmpty && newContent != widget.item.content) {
      await widget.notifier.updateItem(widget.item.id, newContent);
    }
    if (mounted) setState(() => _isEditing = false);
  }
}

/// 항목 추가 입력 행
class _AddChecklistItemRow extends StatefulWidget {
  final String memoId;
  final ChecklistNotifier notifier;
  final AppLocalizations l10n;

  const _AddChecklistItemRow({
    required this.memoId,
    required this.notifier,
    required this.l10n,
  });

  @override
  State<_AddChecklistItemRow> createState() => _AddChecklistItemRowState();
}

class _AddChecklistItemRowState extends State<_AddChecklistItemRow> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.notifier.addItem(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: widget.l10n.memo_checklistAddHint,
              border: const OutlineInputBorder(),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spaceM,
                vertical: AppSizes.spaceS,
              ),
            ),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
          ),
        ),
        const SizedBox(width: AppSizes.spaceS),
        IconButton.filled(
          onPressed: _submit,
          icon: const Icon(Icons.add),
          tooltip: widget.l10n.memo_checklistAdd,
        ),
      ],
    );
  }
}
