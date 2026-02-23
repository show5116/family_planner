import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/features/memo/providers/memo_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 메모 삭제 확인 다이얼로그
class MemoDeleteDialog {
  /// 삭제 다이얼로그 표시
  static Future<void> show(
    BuildContext context,
    WidgetRef ref,
    String memoId, {
    bool popAfterDelete = true,
  }) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.memo_deleteDialogTitle),
        content: Text(l10n.memo_deleteDialogMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.common_cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text(l10n.common_delete),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    if (!context.mounted) return;

    final success =
        await ref.read(memoManagementProvider.notifier).deleteMemo(memoId);

    if (!context.mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.memo_deleteSuccess)),
      );
      if (popAfterDelete) {
        context.pop();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.memo_deleteError)),
      );
    }
  }
}
