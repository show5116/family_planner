import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/widgets/color_picker.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/features/settings/groups/models/group_member.dart';
import 'package:family_planner/features/settings/groups/utils/group_utils.dart';

/// 그룹 설정 탭
class SettingsTab extends StatelessWidget {
  final Group group;
  final AsyncValue<List<GroupMember>> membersAsync;
  final bool canManage;
  final VoidCallback onRegenerateCode;
  final Function(Color color) onColorChange;

  const SettingsTab({
    super.key,
    required this.group,
    required this.membersAsync,
    required this.canManage,
    required this.onRegenerateCode,
    required this.onColorChange,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListView(
      padding: const EdgeInsets.all(AppSizes.spaceM),
      children: [
        _buildGroupInfoCard(context, l10n),
        const SizedBox(height: AppSizes.spaceM),
        _buildInviteCodeCard(context, l10n),
        const SizedBox(height: AppSizes.spaceM),
        _buildColorSettingCard(context, l10n),
      ],
    );
  }

  /// 그룹 정보 카드
  Widget _buildGroupInfoCard(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.group_groupName,
              style: theme.textTheme.titleSmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              group.name,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSizes.spaceM),
            Text(
              l10n.group_groupDescription,
              style: theme.textTheme.titleSmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              group.description ?? '-',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSizes.spaceM),
            Text(
              l10n.group_createdAt,
              style: theme.textTheme.titleSmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              GroupUtils.formatDate(group.createdAt),
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  /// 초대 코드 카드
  Widget _buildInviteCodeCard(BuildContext context, AppLocalizations l10n) {
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

  /// 색상 설정 카드
  Widget _buildColorSettingCard(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);

    // 현재 사용자의 customColor 또는 그룹 defaultColor 가져오기
    final String? displayColorHex = membersAsync.when(
      data: (members) {
        if (members.isEmpty) return group.defaultColor;
        // 첫 번째 멤버를 현재 사용자로 간주
        final currentMember = members.first;
        return currentMember.customColor ?? group.defaultColor;
      },
      loading: () => group.defaultColor,
      error: (_, __) => group.defaultColor,
    );

    final Color displayColor = GroupUtils.parseColor(displayColorHex) ?? Colors.blue;
    final bool hasCustomColor = membersAsync.when(
      data: (members) => members.isNotEmpty && members.first.customColor != null,
      loading: () => false,
      error: (_, __) => false,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.group_customColor,
              style: theme.textTheme.titleSmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: displayColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                ),
                const SizedBox(width: AppSizes.spaceM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hasCustomColor ? '내 개인 색상' : l10n.group_defaultColor,
                        style: theme.textTheme.bodyLarge,
                      ),
                      if (!hasCustomColor)
                        Text(
                          '개인 색상을 설정하지 않았습니다',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => _showColorPicker(context, l10n, displayColor),
                  child: Text(l10n.group_edit),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _copyInviteCode(BuildContext context, AppLocalizations l10n) {
    Clipboard.setData(ClipboardData(text: group.inviteCode));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.group_codeCopied)),
    );
  }

  Future<void> _showColorPicker(
    BuildContext context,
    AppLocalizations l10n,
    Color currentColor,
  ) async {
    final selectedColor = await showColorPickerDialog(
      context: context,
      title: l10n.group_customColor,
      initialColor: currentColor,
      confirmText: l10n.group_save,
      cancelText: l10n.group_cancel,
    );

    if (selectedColor != null) {
      onColorChange(selectedColor);
    }
  }
}
