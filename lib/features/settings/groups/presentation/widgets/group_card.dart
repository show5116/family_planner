import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/features/settings/groups/presentation/screens/group_detail_screen.dart';

/// 그룹 카드 위젯
class GroupCard extends ConsumerWidget {
  final Group group;

  const GroupCard({
    super.key,
    required this.group,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final groupColor = _parseGroupColor();

    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.spaceM),
      child: InkWell(
        onTap: () => _navigateToDetail(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(theme, groupColor),
              if (group.description != null && group.description!.isNotEmpty)
                _buildDescription(theme),
              const SizedBox(height: AppSizes.spaceM),
              _buildInviteCodeRow(context, l10n),
            ],
          ),
        ),
      ),
    );
  }

  /// 그룹 색상 파싱
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

  /// 상세 화면으로 이동
  void _navigateToDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GroupDetailScreen(groupId: group.id),
      ),
    );
  }

  /// 헤더 (색상 + 이름)
  Widget _buildHeader(ThemeData theme, Color? groupColor) {
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
          child: Text(
            group.name,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  /// 설명
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

  /// 초대 코드 행
  Widget _buildInviteCodeRow(BuildContext context, AppLocalizations l10n) {
    return Row(
      children: [
        const Spacer(),
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
