import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/features/settings/groups/models/group_report.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';

/// 그룹원 신고 다이얼로그
class ReportMemberDialog extends ConsumerStatefulWidget {
  final String groupId;
  final String userId;
  final String userName;

  const ReportMemberDialog({
    super.key,
    required this.groupId,
    required this.userId,
    required this.userName,
  });

  @override
  ConsumerState<ReportMemberDialog> createState() => _ReportMemberDialogState();
}

class _ReportMemberDialogState extends ConsumerState<ReportMemberDialog> {
  ReportReason? _selectedReason;
  final _detailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _detailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    if (_selectedReason == null) return;

    setState(() => _isLoading = true);
    try {
      await ref
          .read(groupNotifierProvider.notifier)
          .reportMember(
            widget.groupId,
            widget.userId,
            reason: _selectedReason!,
            detail: _detailController.text.trim().isEmpty
                ? null
                : _detailController.text.trim(),
          );
      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.report_submitted)));
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.report_submit_failed}\n$e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.report_title),
          Text(
            widget.userName,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.report_reason, style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            RadioGroup<ReportReason>(
              groupValue: _selectedReason,
              onChanged: (v) => setState(() => _selectedReason = v),
              child: Column(
                children: ReportReason.values
                    .map(
                      (reason) => RadioListTile<ReportReason>(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text(reason.label),
                        value: reason,
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 12),
            Text(l10n.report_detail, style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            TextField(
              controller: _detailController,
              maxLines: 3,
              maxLength: 200,
              decoration: InputDecoration(
                hintText: l10n.report_detail_hint,
                border: const OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(false),
          child: Text(l10n.common_cancel),
        ),
        FilledButton(
          onPressed: (_selectedReason == null || _isLoading) ? null : _submit,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.report_submit),
        ),
      ],
    );
  }
}
