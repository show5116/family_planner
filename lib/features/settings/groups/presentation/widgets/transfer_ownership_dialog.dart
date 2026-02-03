import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/settings/groups/models/group_member.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';

/// 그룹장 양도 다이얼로그
class TransferOwnershipDialog {
  static Future<void> show(
    BuildContext context,
    WidgetRef ref,
    String groupId,
    GroupMember member,
  ) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('그룹장 양도'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${member.user?.name ?? 'Unknown'}님에게 그룹장 권한을 양도하시겠습니까?'),
            const SizedBox(height: 16),
            _buildWarningBox(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.common_cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('양도하기'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await ref.read(groupNotifierProvider.notifier).transferOwnership(
              groupId,
              member.user!.id,
            );
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${member.user?.name}님에게 그룹장 권한이 양도되었습니다'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('그룹장 양도 실패: $e')),
          );
        }
      }
    }
  }

  static Widget _buildWarningBox() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning, size: 20, color: Colors.orange[700]),
              const SizedBox(width: 8),
              Text(
                '주의사항',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '• 양도 후 귀하는 기본 역할로 변경됩니다\n• 이 작업은 되돌릴 수 없습니다\n• 새 그룹장만 다시 권한을 양도할 수 있습니다',
            style: TextStyle(
              fontSize: 13,
              color: Colors.orange[900],
            ),
          ),
        ],
      ),
    );
  }
}
