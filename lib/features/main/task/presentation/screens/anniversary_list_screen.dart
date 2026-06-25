import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/task/data/models/anniversary_model.dart';
import 'package:family_planner/features/main/task/providers/anniversary_provider.dart';
import 'package:family_planner/features/main/task/providers/task_provider.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/shared/widgets/group_filter_bar.dart';
import 'package:family_planner/features/main/task/presentation/screens/anniversary/anniversary_detail_screen.dart';
import 'package:family_planner/features/main/task/presentation/screens/anniversary/anniversary_form_dialog.dart';

/// 기념일 관리 화면
class AnniversaryListScreen extends ConsumerStatefulWidget {
  const AnniversaryListScreen({super.key});

  @override
  ConsumerState<AnniversaryListScreen> createState() =>
      _AnniversaryListScreenState();
}

class _AnniversaryListScreenState extends ConsumerState<AnniversaryListScreen> {
  @override
  void initState() {
    super.initState();
    // 그룹이 선택되지 않은 경우 첫 그룹 자동 선택
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentId = ref.read(selectedGroupIdProvider);
      if (currentId == null) {
        final groups = ref.read(myGroupsProvider).valueOrNull ?? [];
        if (groups.isNotEmpty) {
          ref.read(selectedGroupIdProvider.notifier).state = groups.first.id;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedGroupId = ref.watch(selectedGroupIdProvider);

    // 그룹 로드 완료 시 아직 미선택이면 첫 그룹 자동 선택
    ref.listen(myGroupsProvider, (_, next) {
      if (next.hasValue && ref.read(selectedGroupIdProvider) == null) {
        final groups = next.valueOrNull ?? [];
        if (groups.isNotEmpty) {
          ref.read(selectedGroupIdProvider.notifier).state = groups.first.id;
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('기념일 관리'),
      ),
      body: Column(
        children: [
          GroupFilterBar(
            selectedGroupId: selectedGroupId,
            onChanged: (value) {
              ref.read(selectedGroupIdProvider.notifier).state = value;
            },
          ),

          // 기념일 목록
          Expanded(
            child: selectedGroupId == null
                ? const Center(child: CircularProgressIndicator())
                : _AnniversaryList(groupId: selectedGroupId),
          ),
        ],
      ),
      floatingActionButton: selectedGroupId != null
          ? FloatingActionButton(
              heroTag: 'anniversary_fab',
              onPressed: () => AnniversaryFormDialog.show(
                context,
                groupId: selectedGroupId,
              ),
              tooltip: '기념일 추가',
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

/// 그룹별 기념일 목록
class _AnniversaryList extends ConsumerWidget {
  final String groupId;

  const _AnniversaryList({required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listAsync = ref.watch(anniversaryManagementProvider(groupId));

    return listAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('불러오기 실패: $e'),
            const SizedBox(height: AppSizes.spaceM),
            FilledButton(
              onPressed: () => ref
                  .read(anniversaryManagementProvider(groupId).notifier)
                  .refresh(),
              child: const Text('다시 시도'),
            ),
          ],
        ),
      ),
      data: (list) {
        if (list.isEmpty) {
          return _EmptyList(groupId: groupId);
        }

        // 다음 기념일까지 남은 일수 기준 정렬
        final sorted = [...list]
          ..sort((a, b) {
            final aNext = a.daysUntilNext ?? 999;
            final bNext = b.daysUntilNext ?? 999;
            return aNext.compareTo(bNext);
          });

        return ListView.separated(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          itemCount: sorted.length,
          separatorBuilder: (_, _) =>
              const SizedBox(height: AppSizes.spaceS),
          itemBuilder: (context, index) => _AnniversaryTile(
            anniversary: sorted[index],
            groupId: groupId,
          ),
        );
      },
    );
  }
}

/// 빈 상태
class _EmptyList extends ConsumerWidget {
  final String groupId;

  const _EmptyList({required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.celebration_outlined,
            size: 64,
            color: theme.colorScheme.outlineVariant,
          ),
          const SizedBox(height: AppSizes.spaceM),
          Text(
            '등록된 기념일이 없습니다',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSizes.spaceL),
          FilledButton.icon(
            onPressed: () => AnniversaryFormDialog.show(
              context,
              groupId: groupId,
            ),
            icon: const Icon(Icons.add),
            label: const Text('기념일 추가'),
          ),
        ],
      ),
    );
  }
}

/// 기념일 목록 아이템
class _AnniversaryTile extends ConsumerWidget {
  final AnniversaryModel anniversary;
  final String groupId;

  const _AnniversaryTile({
    required this.anniversary,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final daysUntil = anniversary.daysUntilNext;
    final daysSince = anniversary.daysSince;

    String dDayLabel;
    Color dDayColor;
    if (daysUntil == 0) {
      dDayLabel = 'D-Day';
      dDayColor = AppColors.error;
    } else if (daysUntil != null && daysUntil <= 7) {
      dDayLabel = 'D-$daysUntil';
      dDayColor = Colors.orange;
    } else if (daysUntil != null) {
      dDayLabel = 'D-$daysUntil';
      dDayColor = theme.colorScheme.primary;
    } else {
      dDayLabel = '';
      dDayColor = theme.colorScheme.primary;
    }

    final dateStr =
        '${anniversary.date.year}.${anniversary.date.month.toString().padLeft(2, '0')}.${anniversary.date.day.toString().padLeft(2, '0')}';

    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => AnniversaryDetailScreen(
              anniversary: anniversary,
              groupId: groupId,
            ),
          ),
        ),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          ),
          alignment: Alignment.center,
          child: Text(
            anniversary.emoji ?? '🎂',
            style: const TextStyle(fontSize: 22),
          ),
        ),
        title: Text(
          anniversary.title,
          style: theme.textTheme.bodyLarge,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(dateStr, style: theme.textTheme.bodySmall),
            Text(
              daysSince >= 0 ? 'D+$daysSince' : 'D$daysSince',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (dDayLabel.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spaceS,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: dDayColor.withValues(alpha: 0.12),
                  borderRadius:
                      BorderRadius.circular(AppSizes.radiusSmall),
                ),
                child: Text(
                  dDayLabel,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: dDayColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(width: AppSizes.spaceXS),
            PopupMenuButton<_TileAction>(
              icon: const Icon(Icons.more_vert, size: 20),
              onSelected: (action) => _handleAction(context, ref, action),
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: _TileAction.edit,
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined, size: 18),
                      SizedBox(width: 8),
                      Text('수정'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: _TileAction.delete,
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline,
                          size: 18, color: AppColors.error),
                      SizedBox(width: 8),
                      Text('삭제',
                          style: TextStyle(color: AppColors.error)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleAction(
    BuildContext context,
    WidgetRef ref,
    _TileAction action,
  ) async {
    switch (action) {
      case _TileAction.edit:
        await AnniversaryFormDialog.show(
          context,
          groupId: groupId,
          anniversary: anniversary,
        );
      case _TileAction.delete:
        final result = await showDialog<_DeleteResult>(
          context: context,
          builder: (ctx) => _DeleteDialog(title: anniversary.title),
        );
        if (result == null || !context.mounted) return;
        final success = await ref
            .read(anniversaryManagementProvider(groupId).notifier)
            .delete(anniversary.id, deleteWithTasks: result.deleteWithTasks);
        if (!context.mounted) return;
        if (!success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('삭제에 실패했습니다')),
          );
        }
    }
  }
}

enum _TileAction { edit, delete }

class _DeleteResult {
  final bool deleteWithTasks;
  const _DeleteResult({required this.deleteWithTasks});
}

/// 기념일 삭제 확인 다이얼로그 (연동 Task 삭제 여부 선택 포함)
class _DeleteDialog extends StatefulWidget {
  final String title;
  const _DeleteDialog({required this.title});

  @override
  State<_DeleteDialog> createState() => _DeleteDialogState();
}

class _DeleteDialogState extends State<_DeleteDialog> {
  bool _deleteWithTasks = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('기념일 삭제'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('"${widget.title}"을(를) 삭제하시겠습니까?'),
          const SizedBox(height: AppSizes.spaceM),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            title: const Text('연동된 기념일 일정도 함께 삭제'),
            subtitle: const Text('체크 해제 시 일정은 유지됩니다'),
            value: _deleteWithTasks,
            onChanged: (v) => setState(() => _deleteWithTasks = v ?? false),
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: const Text('취소'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context)
              .pop(_DeleteResult(deleteWithTasks: _deleteWithTasks)),
          style: TextButton.styleFrom(foregroundColor: AppColors.error),
          child: const Text('삭제'),
        ),
      ],
    );
  }
}
