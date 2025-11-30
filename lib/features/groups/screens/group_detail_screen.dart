import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 그룹 상세 화면
class GroupDetailScreen extends ConsumerStatefulWidget {
  final String groupId;

  const GroupDetailScreen({
    super.key,
    required this.groupId,
  });

  @override
  ConsumerState<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends ConsumerState<GroupDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // TODO: 실제 데이터는 Provider에서 가져올 예정
  final Map<String, dynamic> _mockGroup = {
    'id': '1',
    'name': '우리 가족',
    'description': '사랑하는 우리 가족',
    'memberCount': 4,
    'role': 'OWNER',
    'defaultColor': Colors.blue,
    'customColor': null,
    'inviteCode': 'ABC123XY',
    'createdAt': '2024-01-15',
  };

  final List<Map<String, dynamic>> _mockMembers = [
    {
      'id': '1',
      'name': '김철수',
      'email': 'kim@example.com',
      'role': 'OWNER',
      'joinedAt': '2024-01-15',
      'profileImage': null,
    },
    {
      'id': '2',
      'name': '이영희',
      'email': 'lee@example.com',
      'role': 'ADMIN',
      'joinedAt': '2024-01-16',
      'profileImage': null,
    },
    {
      'id': '3',
      'name': '박민수',
      'email': 'park@example.com',
      'role': 'MEMBER',
      'joinedAt': '2024-01-20',
      'profileImage': null,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final Color groupColor = (_mockGroup['customColor'] ?? _mockGroup['defaultColor']) as Color;

    return Scaffold(
      appBar: AppBar(
        title: Text(_mockGroup['name'] as String),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettingsBottomSheet(context, l10n),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: l10n.group_members),
            Tab(text: l10n.group_settings),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMembersTab(context, theme, l10n),
          _buildSettingsTab(context, theme, l10n, groupColor),
        ],
      ),
      floatingActionButton: _mockGroup['role'] == 'OWNER' || _mockGroup['role'] == 'ADMIN'
          ? FloatingActionButton.extended(
              onPressed: () => _showInviteMemberDialog(context, l10n),
              icon: const Icon(Icons.person_add),
              label: Text(l10n.group_inviteMembers),
            )
          : null,
    );
  }

  Widget _buildMembersTab(BuildContext context, ThemeData theme, AppLocalizations l10n) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSizes.spaceM),
      itemCount: _mockMembers.length,
      itemBuilder: (context, index) {
        final member = _mockMembers[index];
        return _buildMemberCard(context, theme, l10n, member);
      },
    );
  }

  Widget _buildMemberCard(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
    Map<String, dynamic> member,
  ) {
    final String roleName = _getRoleName(l10n, member['role'] as String);
    final bool isOwner = member['role'] == 'OWNER';
    final bool canManage = _mockGroup['role'] == 'OWNER' && !isOwner;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.spaceM),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            (member['name'] as String).substring(0, 1),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          member['name'] as String,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(member['email'] as String),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _getRoleColor(member['role'] as String),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    roleName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${l10n.group_joinedAt}: ${member['joinedAt']}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: canManage
            ? PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'remove') {
                    _showRemoveMemberDialog(context, l10n, member);
                  } else if (value == 'changeRole') {
                    _showChangeRoleDialog(context, l10n, member);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'changeRole',
                    child: Text(l10n.group_role),
                  ),
                  PopupMenuItem(
                    value: 'remove',
                    child: Text(l10n.group_delete),
                  ),
                ],
              )
            : null,
      ),
    );
  }

  Widget _buildSettingsTab(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
    Color groupColor,
  ) {
    return ListView(
      padding: const EdgeInsets.all(AppSizes.spaceM),
      children: [
        // 그룹 정보 카드
        Card(
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
                  _mockGroup['name'] as String,
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
                  _mockGroup['description'] as String? ?? '-',
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
                  _mockGroup['createdAt'] as String,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSizes.spaceM),

        // 초대 코드 카드
        Card(
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
                          _mockGroup['inviteCode'] as String,
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
                if (_mockGroup['role'] == 'OWNER' || _mockGroup['role'] == 'ADMIN') ...[
                  const SizedBox(height: AppSizes.spaceS),
                  TextButton.icon(
                    onPressed: () => _regenerateInviteCode(context, l10n),
                    icon: const Icon(Icons.refresh),
                    label: Text(l10n.group_regenerateCode),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSizes.spaceM),

        // 색상 설정 카드
        Card(
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
                        color: groupColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                    ),
                    const SizedBox(width: AppSizes.spaceM),
                    Text(
                      _mockGroup['customColor'] != null
                          ? l10n.group_customColor
                          : l10n.group_defaultColor,
                      style: theme.textTheme.bodyLarge,
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => _showColorPicker(context, l10n),
                      child: Text(l10n.group_edit),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
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

  void _copyInviteCode(BuildContext context, AppLocalizations l10n) {
    Clipboard.setData(ClipboardData(text: _mockGroup['inviteCode'] as String));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.group_codeCopied)),
    );
  }

  void _regenerateInviteCode(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.group_regenerateCode),
        content: const Text('초대 코드를 재생성하시겠습니까?\n기존 초대 코드는 사용할 수 없게 됩니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.group_cancel),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: 실제 초대 코드 재생성 로직
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.group_codeRegenerated)),
              );
            },
            child: Text(l10n.group_confirm),
          ),
        ],
      ),
    );
  }

  void _showColorPicker(BuildContext context, AppLocalizations l10n) {
    Color selectedColor = (_mockGroup['customColor'] ?? _mockGroup['defaultColor']) as Color;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.group_customColor),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                spacing: AppSizes.spaceS,
                runSpacing: AppSizes.spaceS,
                children: [
                  Colors.red,
                  Colors.pink,
                  Colors.purple,
                  Colors.deepPurple,
                  Colors.indigo,
                  Colors.blue,
                  Colors.lightBlue,
                  Colors.cyan,
                  Colors.teal,
                  Colors.green,
                  Colors.lightGreen,
                  Colors.lime,
                  Colors.yellow,
                  Colors.amber,
                  Colors.orange,
                  Colors.deepOrange,
                  Colors.brown,
                  Colors.grey,
                ].map((color) {
                  return InkWell(
                    onTap: () => setState(() => selectedColor = color),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: selectedColor == color
                            ? Border.all(color: Colors.black, width: 3)
                            : Border.all(color: Colors.grey[300]!),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.group_cancel),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: 실제 색상 저장 로직
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.group_updateSuccess)),
                );
              },
              child: Text(l10n.group_save),
            ),
          ],
        ),
      ),
    );
  }

  void _showInviteMemberDialog(BuildContext context, AppLocalizations l10n) {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.group_inviteByEmail),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: l10n.group_email,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.group_cancel),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: 실제 이메일 초대 로직
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.group_inviteSent)),
              );
            },
            child: Text(l10n.group_send),
          ),
        ],
      ),
    );
  }

  void _showRemoveMemberDialog(
    BuildContext context,
    AppLocalizations l10n,
    Map<String, dynamic> member,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.group_delete),
        content: Text('${member['name']} 님을 그룹에서 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.group_cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              // TODO: 실제 멤버 삭제 로직
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('멤버가 삭제되었습니다')),
              );
            },
            child: Text(l10n.group_delete),
          ),
        ],
      ),
    );
  }

  void _showChangeRoleDialog(
    BuildContext context,
    AppLocalizations l10n,
    Map<String, dynamic> member,
  ) {
    String selectedRole = member['role'] as String;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.group_role),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: Text(l10n.group_admin),
                value: 'ADMIN',
                groupValue: selectedRole,
                onChanged: (value) => setState(() => selectedRole = value!),
              ),
              RadioListTile<String>(
                title: Text(l10n.group_member),
                value: 'MEMBER',
                groupValue: selectedRole,
                onChanged: (value) => setState(() => selectedRole = value!),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.group_cancel),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: 실제 역할 변경 로직
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('역할이 변경되었습니다')),
                );
              },
              child: Text(l10n.group_save),
            ),
          ],
        ),
      ),
    );
  }

  void _showSettingsBottomSheet(BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_mockGroup['role'] == 'OWNER' || _mockGroup['role'] == 'ADMIN')
              ListTile(
                leading: const Icon(Icons.edit),
                title: Text(l10n.group_editGroup),
                onTap: () {
                  Navigator.pop(context);
                  _showEditGroupDialog(context, l10n);
                },
              ),
            if (_mockGroup['role'] == 'OWNER')
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: Text(
                  l10n.group_deleteGroup,
                  style: const TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteGroupDialog(context, l10n);
                },
              ),
            if (_mockGroup['role'] != 'OWNER')
              ListTile(
                leading: const Icon(Icons.exit_to_app, color: Colors.orange),
                title: Text(
                  l10n.group_leaveGroup,
                  style: const TextStyle(color: Colors.orange),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showLeaveGroupDialog(context, l10n);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _showEditGroupDialog(BuildContext context, AppLocalizations l10n) {
    final nameController = TextEditingController(text: _mockGroup['name'] as String);
    final descriptionController = TextEditingController(text: _mockGroup['description'] as String?);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.group_editGroup),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: l10n.group_groupName,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppSizes.spaceM),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: l10n.group_groupDescription,
                  border: const OutlineInputBorder(),
                ),
                maxLines: 3,
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
              // TODO: 실제 그룹 정보 수정 로직
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.group_updateSuccess)),
              );
            },
            child: Text(l10n.group_save),
          ),
        ],
      ),
    );
  }

  void _showDeleteGroupDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.group_deleteConfirmTitle),
        content: Text(l10n.group_deleteConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.group_cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              // TODO: 실제 그룹 삭제 로직
              Navigator.pop(context); // 다이얼로그 닫기
              Navigator.pop(context); // 그룹 상세 화면 닫기
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.group_deleteSuccess)),
              );
            },
            child: Text(l10n.group_delete),
          ),
        ],
      ),
    );
  }

  void _showLeaveGroupDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.group_leaveConfirmTitle),
        content: Text(l10n.group_leaveConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.group_cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              // TODO: 실제 그룹 나가기 로직
              Navigator.pop(context); // 다이얼로그 닫기
              Navigator.pop(context); // 그룹 상세 화면 닫기
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.group_leaveSuccess)),
              );
            },
            child: Text(l10n.group_leave),
          ),
        ],
      ),
    );
  }
}
