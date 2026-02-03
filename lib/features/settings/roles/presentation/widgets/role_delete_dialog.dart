import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/features/settings/roles/providers/common_role_provider.dart';

/// 역할 삭제 확인 다이얼로그
class RoleDeleteDialog {
  static void show(
    BuildContext context,
    WidgetRef ref,
    String roleId,
    String roleName,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('역할 삭제'),
        content: Text('$roleName 역할을 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => _handleDelete(dialogContext, context, ref, roleId),
            child: const Text('삭제', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  static Future<void> _handleDelete(
    BuildContext dialogContext,
    BuildContext context,
    WidgetRef ref,
    String roleId,
  ) async {
    Navigator.pop(dialogContext);
    try {
      await ref.read(commonRoleProvider.notifier).deleteRole(roleId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('역할이 삭제되었습니다')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('삭제 실패: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
