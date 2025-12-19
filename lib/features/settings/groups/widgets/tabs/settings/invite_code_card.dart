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

  bool get _isExpired => DateTime.now().isAfter(group.inviteCodeExpiresAt);

  String _getRemainingTime(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final difference = group.inviteCodeExpiresAt.difference(now);

    if (difference.isNegative) {
      return l10n.group_codeExpired;
    }

    final days = difference.inDays;
    final hours = difference.inHours % 24;
    final minutes = difference.inMinutes % 60;

    if (days > 0) {
      return l10n.group_codeExpiresInDays(days);
    } else if (hours > 0) {
      return l10n.group_codeExpiresInHours(hours);
    } else {
      return l10n.group_codeExpiresInMinutes(minutes);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    // 초대 코드가 만료된 경우
    if (_isExpired) {
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
              Container(
                padding: const EdgeInsets.all(AppSizes.spaceM),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red[700]),
                    const SizedBox(width: AppSizes.spaceS),
                    Expanded(
                      child: Text(
                        l10n.group_codeExpired,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.red[700],
                        ),
                      ),
                    ),
                  ],
                ),
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

    // 초대 코드가 유효한 경우
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
            const SizedBox(height: AppSizes.spaceS),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: AppSizes.spaceXS),
                Text(
                  _getRemainingTime(context),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
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
