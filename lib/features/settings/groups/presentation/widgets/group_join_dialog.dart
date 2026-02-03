import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';

/// 그룹 가입 다이얼로그
class GroupJoinDialog {
  static void show(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final formKey = GlobalKey<FormState>();
    final codeController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.group_joinGroup),
        content: SizedBox(
          width: double.maxFinite,
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: codeController,
                    decoration: InputDecoration(
                      labelText: l10n.group_enterInviteCode,
                      border: const OutlineInputBorder(),
                      hintText: 'ABC123XY',
                    ),
                    textCapitalization: TextCapitalization.characters,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.group_inviteCodeRequired;
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.group_cancel),
          ),
          ElevatedButton(
            onPressed: () => _handleJoin(
              dialogContext,
              context,
              ref,
              l10n,
              formKey,
              codeController,
            ),
            child: Text(l10n.group_join),
          ),
        ],
      ),
    );
  }

  static Future<void> _handleJoin(
    BuildContext dialogContext,
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    GlobalKey<FormState> formKey,
    TextEditingController codeController,
  ) async {
    if (formKey.currentState!.validate()) {
      try {
        final result = await ref.read(groupNotifierProvider.notifier).joinGroup(
              codeController.text.trim(),
            );

        if (dialogContext.mounted) {
          Navigator.pop(dialogContext);
          final message = result['message'] as String? ?? l10n.group_joinSuccess;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        }
      } catch (e) {
        if (dialogContext.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('오류: ${e.toString()}')),
          );
        }
      }
    }
  }
}
