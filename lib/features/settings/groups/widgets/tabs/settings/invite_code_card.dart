import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';

/// 초대 코드 카드
class InviteCodeCard extends StatelessWidget {
  final Group group;
  final bool canManage;
  final VoidCallback onRegenerateCode;

  const InviteCodeCard({
    super.key,
    required this.group,
    required this.canManage,
    required this.onRegenerateCode,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.group_inviteCode,
              style: theme.textTheme.titleSmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(AppSizes.spaceM),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      group.inviteCode,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.spaceS),
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () => _copyInviteCode(context, l10n),
                ),
              ],
            ),
            if (canManage) ...[
              const SizedBox(height: AppSizes.spaceS),
              TextButton.icon(
                onPressed: onRegenerateCode,
                icon: const Icon(Icons.refresh),
                label: Text(l10n.group_regenerateCode),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _copyInviteCode(BuildContext context, AppLocalizations l10n) {
    Clipboard.setData(ClipboardData(text: group.inviteCode));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.group_codeCopied)));
  }
}
