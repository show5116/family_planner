import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/groups/screens/group_detail_screen.dart';

/// 그룹 목록 화면
class GroupListScreen extends ConsumerStatefulWidget {
  const GroupListScreen({super.key});

  @override
  ConsumerState<GroupListScreen> createState() => _GroupListScreenState();
}

class _GroupListScreenState extends ConsumerState<GroupListScreen> {
  // TODO: 실제 데이터는 Provider에서 가져올 예정
  final List<Map<String, dynamic>> _mockGroups = [
    {
      'id': '1',
      'name': '우리 가족',
      'description': '사랑하는 우리 가족',
      'memberCount': 4,
      'role': 'OWNER',
      'defaultColor': Colors.blue,
      'customColor': null,
      'inviteCode': 'ABC123XY',
    },
    {
      'id': '2',
      'name': '회사 동료',
      'description': '프로젝트 팀',
      'memberCount': 8,
      'role': 'ADMIN',
      'defaultColor': Colors.green,
      'customColor': Colors.teal,
      'inviteCode': 'DEF456ZW',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.group_title),
      ),
      body: _mockGroups.isEmpty
          ? _buildEmptyState(context, l10n)
          : ListView.builder(
              padding: const EdgeInsets.all(AppSizes.spaceM),
              itemCount: _mockGroups.length,
              itemBuilder: (context, index) {
                final group = _mockGroups[index];
                return _buildGroupCard(context, theme, l10n, group);
              },
            ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            onPressed: () => _showJoinGroupDialog(context, l10n),
            icon: const Icon(Icons.login),
            label: Text(l10n.group_joinGroup),
            heroTag: 'join',
          ),
          const SizedBox(height: AppSizes.spaceM),
          FloatingActionButton.extended(
            onPressed: () => _showCreateGroupDialog(context, l10n),
            icon: const Icon(Icons.add),
            label: Text(l10n.group_createGroup),
            heroTag: 'create',
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.groups_outlined,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: AppSizes.spaceL),
          Text(
            l10n.group_noGroups,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[700],
                ),
          ),
          const SizedBox(height: AppSizes.spaceS),
          Text(
            l10n.group_noGroupsDescription,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupCard(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
    Map<String, dynamic> group,
  ) {
    final Color groupColor = (group['customColor'] ?? group['defaultColor']) as Color;
    final String roleName = _getRoleName(l10n, group['role'] as String);

    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.spaceM),
      child: InkWell(
        onTap: () => _navigateToGroupDetail(context, group),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // 그룹 색상 표시
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: groupColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppSizes.spaceS),
                  // 그룹 이름
                  Expanded(
                    child: Text(
                      group['name'] as String,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // 역할 뱃지
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.spaceS,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getRoleColor(group['role'] as String),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      roleName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              if (group['description'] != null && (group['description'] as String).isNotEmpty) ...[
                const SizedBox(height: AppSizes.spaceS),
                Text(
                  group['description'] as String,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
              const SizedBox(height: AppSizes.spaceM),
              Row(
                children: [
                  Icon(Icons.people_outline, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: AppSizes.spaceXS),
                  Text(
                    l10n.group_memberCount(group['memberCount'] as int),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () => _copyInviteCode(context, l10n, group['inviteCode'] as String),
                    icon: const Icon(Icons.copy, size: 16),
                    label: Text(group['inviteCode'] as String),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getRoleName(AppLocalizations l10n, String role) {
    switch (role) {
      case 'OWNER':
        return l10n.group_owner;
      case 'ADMIN':
        return l10n.group_admin;
      case 'MEMBER':
        return l10n.group_member;
      default:
        return role;
    }
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'OWNER':
        return Colors.red;
      case 'ADMIN':
        return Colors.orange;
      case 'MEMBER':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  void _navigateToGroupDetail(BuildContext context, Map<String, dynamic> group) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GroupDetailScreen(groupId: group['id'] as String),
      ),
    );
  }

  void _copyInviteCode(BuildContext context, AppLocalizations l10n, String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.group_codeCopied)),
    );
  }

  void _showCreateGroupDialog(BuildContext context, AppLocalizations l10n) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    Color selectedColor = Colors.blue;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.group_createGroup),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: l10n.group_groupName,
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.group_groupNameRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSizes.spaceM),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: l10n.group_groupDescription,
                      border: const OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: AppSizes.spaceM),
                  // 색상 선택
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      l10n.group_defaultColor,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  const SizedBox(height: AppSizes.spaceS),
                  Wrap(
                    spacing: AppSizes.spaceS,
                    children: [
                      Colors.red,
                      Colors.pink,
                      Colors.purple,
                      Colors.blue,
                      Colors.teal,
                      Colors.green,
                      Colors.orange,
                      Colors.brown,
                    ].map((color) {
                      return InkWell(
                        onTap: () => setState(() => selectedColor = color),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: selectedColor == color
                                ? Border.all(color: Colors.black, width: 3)
                                : null,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.group_cancel),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  // TODO: 실제 그룹 생성 로직
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.group_createSuccess)),
                  );
                }
              },
              child: Text(l10n.group_create),
            ),
          ],
        ),
      ),
    );
  }

  void _showJoinGroupDialog(BuildContext context, AppLocalizations l10n) {
    final formKey = GlobalKey<FormState>();
    final codeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.group_joinGroup),
        content: Form(
          key: formKey,
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
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.group_cancel),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                // TODO: 실제 그룹 참여 로직
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.group_joinSuccess)),
                );
              }
            },
            child: Text(l10n.group_join),
          ),
        ],
      ),
    );
  }
}
