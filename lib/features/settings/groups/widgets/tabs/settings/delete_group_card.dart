import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';

/// 그룹 삭제 카드
class DeleteGroupCard extends ConsumerWidget {
  final Group group;

  const DeleteGroupCard({
    super.key,
    required this.group,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning, color: Colors.red.shade700),
                const SizedBox(width: AppSizes.spaceS),
                Text(
                  '위험 구역',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spaceS),
            Text(
              '그룹을 삭제하면 모든 데이터가 영구적으로 삭제됩니다.',
              style: TextStyle(fontSize: 14, color: Colors.red.shade700),
            ),
            const SizedBox(height: AppSizes.spaceM),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showDeleteGroupDialog(context, ref, l10n),
                icon: const Icon(Icons.delete),
                label: Text(l10n.group_deleteGroup),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 그룹 삭제 다이얼로그 표시
  Future<void> _showDeleteGroupDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.group_deleteConfirmTitle),
        content: Text(l10n.group_deleteConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.group_cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.group_delete),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await ref.read(groupNotifierProvider.notifier).deleteGroup(group.id);
        if (context.mounted) {
          Navigator.pop(context); // 그룹 상세 화면 닫기
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.group_deleteSuccess)));
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('오류: $e')));
        }
      }
    }
  }
}
