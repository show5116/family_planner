import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/features/settings/groups/providers/default_group_provider.dart';
import 'package:family_planner/features/settings/groups/presentation/screens/group_detail_screen.dart';

/// 그룹 카드 위젯
class GroupCard extends ConsumerWidget {
  final Group group;
  final bool isLast;

  const GroupCard({
    super.key,
    required this.group,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final groupColor = _parseGroupColor();
    final canInvite = group.hasPermission('INVITE_MEMBER');
    final isExpired = DateTime.now().isAfter(group.inviteCodeExpiresAt);
    final defaultGroupId = ref.watch(defaultGroupProvider);
    final isDefault = defaultGroupId == group.id;

    return Card(
      margin: EdgeInsets.only(
        bottom: isLast ? 96 : AppSizes.spaceM,
      ),
      child: InkWell(
        onTap: () => _navigateToDetail(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, theme, groupColor, isDefault, ref),
              if (group.description != null && group.description!.isNotEmpty)
                _buildDescription(theme),
              if (canInvite) ...[
                const SizedBox(height: AppSizes.spaceM),
                _buildInviteCodeRow(context, l10n, isExpired),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color? _parseGroupColor() {
    final colorToUse = group.myColor ?? group.defaultColor;
    if (colorToUse != null && colorToUse.isNotEmpty) {
      try {
        return Color(
          int.parse(colorToUse.substring(1), radix: 16) + 0xFF000000,
        );
      } catch (e) {
        return Colors.blue;
      }
    }
    return null;
  }

  void _navigateToDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GroupDetailScreen(groupId: group.id),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    ThemeData theme,
    Color? groupColor,
    bool isDefault,
    WidgetRef ref,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        if (groupColor != null)
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: groupColor,
              shape: BoxShape.circle,
            ),
          ),
        const SizedBox(width: AppSizes.spaceS),
        Expanded(
          child: Row(
            children: [
              Text(
                group.name,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isDefault) ...[
                const SizedBox(width: AppSizes.spaceXS),
                Tooltip(
                  message: l10n.group_defaultGroupTooltip,
                  child: Icon(
                    Icons.star_rounded,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ],
          ),
        ),
        _DefaultGroupButton(group: group, isDefault: isDefault),
      ],
    );
  }

  Widget _buildDescription(ThemeData theme) {
    return Column(
      children: [
        const SizedBox(height: AppSizes.spaceS),
        Text(
          group.description!,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildInviteCodeRow(BuildContext context, AppLocalizations l10n, bool isExpired) {
    return Row(
      children: [
        const Spacer(),
        if (isExpired)
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, size: 14, color: Colors.orange[700]),
              const SizedBox(width: 4),
              Text(
                l10n.group_codeExpiredLabel,
                style: TextStyle(fontSize: 12, color: Colors.orange[700]),
              ),
            ],
          )
        else
          TextButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: group.inviteCode));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.group_codeCopied)),
              );
            },
            icon: const Icon(Icons.copy, size: 16),
            label: Text(group.inviteCode),
          ),
      ],
    );
  }
}

/// 대표 그룹 설정/해제 버튼
class _DefaultGroupButton extends ConsumerWidget {
  final Group group;
  final bool isDefault;

  const _DefaultGroupButton({required this.group, required this.isDefault});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final l10n = AppLocalizations.of(context)!;
    return Tooltip(
      message: isDefault ? l10n.group_unsetDefaultGroupTooltip : l10n.group_setDefaultGroupTooltip,
      child: InkWell(
        onTap: () => _toggle(context, ref),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(
            isDefault ? Icons.star_rounded : Icons.star_outline_rounded,
            size: 22,
            color: isDefault ? theme.colorScheme.primary : theme.colorScheme.outline,
          ),
        ),
      ),
    );
  }

  Future<void> _toggle(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(defaultGroupProvider.notifier);
    final l10n = AppLocalizations.of(context)!;
    if (isDefault) {
      await notifier.clear();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.group_unsetDefaultSuccess)),
        );
      }
    } else {
      await notifier.setDefaultGroup(group.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.group_setDefaultSuccess(group.name))),
        );
      }
    }
  }
}
