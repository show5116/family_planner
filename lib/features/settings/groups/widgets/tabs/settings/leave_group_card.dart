import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';

/// 그룹 나가기 카드
class LeaveGroupCard extends ConsumerWidget {
  final Group group;

  const LeaveGroupCard({
    super.key,
    required this.group,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      color: Colors.orange.shade50,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.exit_to_app, color: Colors.orange.shade700),
                const SizedBox(width: AppSizes.spaceS),
                Text(
                  '그룹 나가기',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spaceS),
            Text(
              '그룹을 나가면 더 이상 그룹의 데이터에 접근할 수 없습니다.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.orange.shade700,
              ),
            ),
            const SizedBox(height: AppSizes.spaceM),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showLeaveGroupDialog(context, ref, l10n),
                icon: const Icon(Icons.exit_to_app),
                label: const Text('그룹 나가기'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 그룹 나가기 다이얼로그 표시
  Future<void> _showLeaveGroupDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('그룹 나가기'),
        content: Text(
          '정말로 "${group.name}" 그룹을 나가시겠습니까?\n\n'
          '그룹을 나가면 더 이상 그룹의 데이터에 접근할 수 없으며, '
          '다시 참여하려면 초대 코드가 필요합니다.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.group_cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('나가기'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await ref.read(groupNotifierProvider.notifier).leaveGroup(group.id);
        if (context.mounted) {
          // 그룹 상세 화면 닫기
          Navigator.pop(context);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('그룹에서 나갔습니다')));
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
