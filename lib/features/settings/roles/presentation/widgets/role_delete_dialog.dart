import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/features/settings/roles/providers/common_role_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 역할 삭제 확인 다이얼로그
class RoleDeleteDialog {
  static void show(
    BuildContext context,
    WidgetRef ref,
    String roleId,
    String roleName,
  ) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.role_delete),
        content: Text(l10n.role_delete_message(roleName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.common_cancel),
          ),
          TextButton(
            onPressed: () => _handleDelete(dialogContext, context, ref, roleId),
            child: Text(
              l10n.common_delete,
              style: const TextStyle(color: Colors.red),
            ),
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
    final l10n = AppLocalizations.of(context)!;
    Navigator.pop(dialogContext);
    try {
      await ref.read(commonRoleProvider.notifier).deleteRole(roleId);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.role_deleted)));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.common_deleteFailed}\n$e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
