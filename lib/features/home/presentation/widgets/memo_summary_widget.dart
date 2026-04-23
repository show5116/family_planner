import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/providers/dashboard_widget_settings_provider.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/home/providers/dashboard_provider.dart';
import 'package:family_planner/features/memo/data/models/memo_model.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/shared/widgets/dashboard_card.dart';

/// 메모 요약 위젯
class MemoSummaryWidget extends ConsumerStatefulWidget {
  const MemoSummaryWidget({
    super.key,
    this.initialSelectedGroupId,
    this.initialPersonalOnly = false,
  });

  final String? initialSelectedGroupId;
  final bool initialPersonalOnly;

  @override
  ConsumerState<MemoSummaryWidget> createState() => _MemoSummaryWidgetState();
}

class _MemoSummaryWidgetState extends ConsumerState<MemoSummaryWidget> {
  String? _selectedGroupId;
  bool _personalOnly = false;

  @override
  void initState() {
    super.initState();
    _selectedGroupId = widget.initialSelectedGroupId;
    _personalOnly = widget.initialPersonalOnly;
  }

  Future<void> _saveFilter() async {
    final current = ref.read(dashboardWidgetSettingsProvider).valueOrNull;
    if (current == null) return;
    await ref.read(dashboardWidgetSettingsProvider.notifier).save(
          current.copyWith(
            memoSelectedGroupId: _selectedGroupId,
            memoPersonalOnly: _personalOnly,
          ),
        );
  }

  Future<void> _showFilterSheet(List<Group> groups) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusMedium),
        ),
      ),
      builder: (context) => _MemoGroupPickerSheet(
        groups: groups,
        selectedGroupId: _selectedGroupId,
        personalOnly: _personalOnly,
        onApply: (groupId, personalOnly) {
          setState(() {
            _selectedGroupId = groupId;
            _personalOnly = personalOnly;
          });
          _saveFilter();
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final groups = ref.watch(myGroupsProvider).valueOrNull ?? [];
    final memosAsync = ref.watch(
      dashboardMemosProvider(
        selectedGroupId: _selectedGroupId,
        personalOnly: _personalOnly,
      ),
    );

    final hasActiveFilter = _selectedGroupId != null || _personalOnly;

    const title = '고정된 메모';

    return DashboardCard(
      title: title,
      icon: Icons.note_outlined,
      action: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (groups.isNotEmpty)
            IconButton(
              iconSize: 20,
              visualDensity: VisualDensity.compact,
              tooltip: '필터',
              icon: Badge(
                isLabelVisible: hasActiveFilter,
                smallSize: 7,
                child: Icon(
                  Icons.tune,
                  color: hasActiveFilter
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              onPressed: () => _showFilterSheet(groups),
            ),
          TextButton(
            onPressed: () => context.push(AppRoutes.memo),
            child: const Text('전체보기'),
          ),
        ],
      ),
      onTap: () => context.push(AppRoutes.memo),
      child: memosAsync.when(
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.all(AppSizes.spaceM),
            child: CircularProgressIndicator(),
          ),
        ),
        error: (e, _) => const _EmptyState(),
        data: (memos) {
          if (memos.isEmpty) return const _EmptyState();
          return Column(
            children: memos.map((memo) => _MemoItem(memo: memo)).toList(),
          );
        },
      ),
    );
  }
}

/// 메모 위젯 필터 바텀시트
class _MemoGroupPickerSheet extends StatefulWidget {
  const _MemoGroupPickerSheet({
    required this.groups,
    required this.selectedGroupId,
    required this.personalOnly,
    required this.onApply,
  });

  final List<Group> groups;
  final String? selectedGroupId;
  final bool personalOnly;
  final void Function(String? groupId, bool personalOnly) onApply;

  @override
  State<_MemoGroupPickerSheet> createState() => _MemoGroupPickerSheetState();
}

class _MemoGroupPickerSheetState extends State<_MemoGroupPickerSheet> {
  static const _allGroupsValue = '__all__';
  static const _personalOnlyValue = '__personal__';
  late String _value;

  @override
  void initState() {
    super.initState();
    if (widget.personalOnly) {
      _value = _personalOnlyValue;
    } else {
      _value = widget.selectedGroupId ?? _allGroupsValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: AppSizes.spaceM),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.spaceL, AppSizes.spaceM, AppSizes.spaceL, AppSizes.spaceS,
            ),
            child: Text('필터', style: Theme.of(context).textTheme.titleLarge),
          ),
          const Divider(),
          RadioGroup<String>(
            groupValue: _value,
            onChanged: (v) => setState(() => _value = v!),
            child: Column(
              children: [
                const RadioListTile<String>(
                  title: Text('전체 그룹'),
                  value: _allGroupsValue,
                ),
                const RadioListTile<String>(
                  title: Text('개인 메모만'),
                  value: _personalOnlyValue,
                ),
                ...widget.groups.map((group) => RadioListTile<String>(
                      title: Text(group.name),
                      value: group.id,
                    )),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.spaceS),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.spaceL, 0, AppSizes.spaceL, AppSizes.spaceL,
            ),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => widget.onApply(
                  _value == _allGroupsValue || _value == _personalOnlyValue
                      ? null
                      : _value,
                  _value == _personalOnlyValue,
                ),
                child: const Text('적용'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MemoItem extends StatelessWidget {
  const _MemoItem({required this.memo});

  final MemoModel memo;

  String _stripMarkdown(String text) {
    return text
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll(RegExp(r'^#+\s+', multiLine: true), '')
        .replaceAll(RegExp(r'\*\*([^*]+)\*\*'), r'$1')
        .replaceAll(RegExp(r'__([^_]+)__'), r'$1')
        .replaceAll(RegExp(r'\*([^*]+)\*'), r'$1')
        .replaceAll(RegExp(r'_([^_]+)_'), r'$1')
        .replaceAll(RegExp(r'\[([^\]]+)\]\([^)]+\)'), r'$1')
        .replaceAll(RegExp(r'```[^`]*```'), '')
        .replaceAll(RegExp(r'`([^`]+)`'), r'$1')
        .replaceAll(RegExp(r'^[\-\*\+]\s+', multiLine: true), '')
        .replaceAll(RegExp(r'^\d+\.\s+', multiLine: true), '')
        .replaceAll(RegExp(r'^>\s+', multiLine: true), '')
        .replaceAll(RegExp(r'^[\-\*]{3,}$', multiLine: true), '')
        .replaceAll(RegExp(r'\n+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    final isChecklist = memo.type == MemoType.checklist;
    final checkedCount = memo.checklistItems.where((i) => i.isChecked).length;
    final totalCount = memo.checklistItems.length;
    final dateText = DateFormat('MM.dd').format(memo.updatedAt);

    return InkWell(
      onTap: () => context.push('/memo/${memo.id}'),
      borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceS),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              isChecklist ? Icons.checklist : Icons.note_outlined,
              size: AppSizes.iconSmall,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: AppSizes.spaceS),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    memo.title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  if (isChecklist && totalCount > 0)
                    Text(
                      '$checkedCount/$totalCount 완료',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    )
                  else if (memo.content.isNotEmpty)
                    Text(
                      _stripMarkdown(memo.content),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            const SizedBox(width: AppSizes.spaceS),
            Text(
              dateText,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.push_pin_outlined,
            size: 48,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: AppSizes.spaceS),
          Text(
            '고정된 메모가 없습니다',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}
