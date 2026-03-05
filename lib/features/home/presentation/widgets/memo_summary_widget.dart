import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/home/providers/dashboard_provider.dart';
import 'package:family_planner/features/memo/data/models/memo_model.dart';
import 'package:family_planner/shared/widgets/dashboard_card.dart';

/// 메모 요약 위젯
class MemoSummaryWidget extends ConsumerWidget {
  const MemoSummaryWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memosAsync = ref.watch(dashboardMemosProvider);

    return DashboardCard(
      title: '고정된 메모',
      icon: Icons.note_outlined,
      action: TextButton(
        onPressed: () => context.push(AppRoutes.memo),
        child: const Text('전체보기'),
      ),
      onTap: () => context.push(AppRoutes.memo),
      child: memosAsync.when(
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.all(AppSizes.spaceM),
            child: CircularProgressIndicator(),
          ),
        ),
        error: (_, _) => const _EmptyState(),
        data: (memos) {
          if (memos.isEmpty) return const _EmptyState();
          return Column(
            children: memos
                .map((memo) => _MemoItem(memo: memo))
                .toList(),
          );
        },
      ),
    );
  }
}

class _MemoItem extends StatelessWidget {
  const _MemoItem({required this.memo});

  final MemoModel memo;

  String _stripMarkdown(String text) {
    return text
        .replaceAll(RegExp(r'^#+\s+', multiLine: true), '')
        .replaceAll(RegExp(r'\*\*([^*]+)\*\*'), r'$1')
        .replaceAll(RegExp(r'\*([^*]+)\*'), r'$1')
        .replaceAll(RegExp(r'```[^`]*```'), '')
        .replaceAll(RegExp(r'`([^`]+)`'), r'$1')
        .replaceAll(RegExp(r'^[\-\*\+]\s+', multiLine: true), '')
        .replaceAll(RegExp(r'\n+'), ' ')
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
