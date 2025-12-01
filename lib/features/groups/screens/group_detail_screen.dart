import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/groups/providers/group_provider.dart';
import 'package:family_planner/features/groups/models/group.dart';
import 'package:family_planner/features/groups/models/group_member.dart';

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
    final groupAsync = ref.watch(groupDetailProvider(widget.groupId));
    final membersAsync = ref.watch(groupMembersProvider(widget.groupId));

    return groupAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: Text(l10n.group_groupName)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(error.toString()),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(groupDetailProvider(widget.groupId));
                  ref.invalidate(groupMembersProvider(widget.groupId));
                },
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
      ),
      data: (group) {
        return Scaffold(
          appBar: AppBar(
            title: Text(group.name),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => _showSettingsBottomSheet(context, l10n, group, membersAsync),
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              indicatorColor: Colors.white,
              tabs: [
                Tab(text: l10n.group_members),
                Tab(text: l10n.group_settings),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildMembersTab(context, theme, l10n, membersAsync),
              _buildSettingsTab(context, theme, l10n, group, membersAsync),
            ],
          ),
          floatingActionButton: _canManageGroup(membersAsync)
              ? FloatingActionButton.extended(
                  onPressed: () => _showInviteMemberDialog(context, l10n),
                  icon: const Icon(Icons.person_add),
                  label: Text(l10n.group_inviteMembers),
                )
              : null,
        );
      },
    );
  }

  bool _canManageGroup(AsyncValue<List<GroupMember>> membersAsync) {
    return membersAsync.when(
      data: (members) {
        if (members.isEmpty) return false;
        // 첫 번째 멤버를 현재 사용자로 간주 (실제로는 authProvider에서 가져와야 함)
        final roleName = members.first.role?.name ?? '';
        return roleName == 'OWNER' || roleName == 'ADMIN';
      },
      loading: () => false,
      error: (_, __) => false,
    );
  }

  Widget _buildMembersTab(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
    AsyncValue<List<GroupMember>> membersAsync,
  ) {
    return membersAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(error.toString()),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.invalidate(groupMembersProvider(widget.groupId));
              },
              child: const Text('다시 시도'),
            ),
          ],
        ),
      ),
      data: (members) {
        if (members.isEmpty) {
          return const Center(
            child: Text('멤버가 없습니다'),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          itemCount: members.length,
          itemBuilder: (context, index) {
            final member = members[index];
            return _buildMemberCard(context, theme, l10n, member, members);
          },
        );
      },
    );
  }

  Widget _buildMemberCard(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
    GroupMember member,
    List<GroupMember> allMembers,
  ) {
    final String roleName = _getRoleName(l10n, member.role?.name ?? 'MEMBER');
    final bool isOwner = member.role?.name == 'OWNER';
    // 첫 번째 멤버를 현재 사용자로 간주
    final bool canManage = allMembers.isNotEmpty &&
        allMembers.first.role?.name == 'OWNER' && !isOwner;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.spaceM),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: member.user?.profileImage != null
              ? NetworkImage(member.user!.profileImage!)
              : null,
          child: member.user?.profileImage == null
              ? Text(
                  (member.user?.name ?? 'U').substring(0, 1),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              : null,
        ),
        title: Text(
          member.user?.name ?? 'Unknown',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(member.user?.email ?? ''),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _getRoleColor(member.role?.name ?? 'MEMBER'),
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
                  '${l10n.group_joinedAt}: ${_formatDate(member.joinedAt)}',
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
    Group group,
    AsyncValue<List<GroupMember>> membersAsync,
  ) {
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

    final Color displayColor = _parseColor(displayColorHex) ?? Colors.blue;
    final bool hasCustomColor = membersAsync.when(
      data: (members) => members.isNotEmpty && members.first.customColor != null,
      loading: () => false,
      error: (_, __) => false,
    );

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
                  _formatDate(group.createdAt),
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
                      onPressed: () => _copyInviteCode(context, l10n, group.inviteCode),
                    ),
                  ],
                ),
                if (_canManageGroup(membersAsync)) ...[
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

  Color? _parseColor(String? colorHex) {
    if (colorHex == null) return null;
    try {
      return Color(int.parse(colorHex.substring(1), radix: 16) + 0xFF000000);
    } catch (e) {
      return null;
    }
  }

  String _colorToHex(Color color) {
    final a = (color.a * 255).round();
    final r = (color.r * 255).round();
    final g = (color.g * 255).round();
    final b = (color.b * 255).round();
    final value = a << 24 | r << 16 | g << 8 | b;
    return '#${value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void _copyInviteCode(BuildContext context, AppLocalizations l10n, String inviteCode) {
    Clipboard.setData(ClipboardData(text: inviteCode));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.group_codeCopied)),
    );
  }

  Future<void> _regenerateInviteCode(BuildContext context, AppLocalizations l10n) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.group_regenerateCode),
        content: const Text('초대 코드를 재생성하시겠습니까?\n기존 초대 코드는 사용할 수 없게 됩니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.group_cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.group_confirm),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(groupNotifierProvider.notifier).regenerateInviteCode(widget.groupId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.group_codeRegenerated)),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('오류: $e')),
          );
        }
      }
    }
  }

  Future<void> _showColorPicker(BuildContext context, AppLocalizations l10n, Color currentColor) async {
    Color selectedColor = currentColor;

    final confirmed = await showDialog<bool>(
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
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.group_cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.group_save),
            ),
          ],
        ),
      ),
    );

    if (confirmed == true && mounted) {
      try {
        final colorHex = _colorToHex(selectedColor);
        debugPrint('Updating color to: $colorHex');

        await ref.read(groupNotifierProvider.notifier).updateMyColor(
          widget.groupId,
          colorHex,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.group_updateSuccess)),
          );
        }
      } catch (e, stackTrace) {
        debugPrint('Error updating color: $e');
        debugPrint('Stack trace: $stackTrace');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('색상 변경 실패: ${e.toString()}'),
              duration: const Duration(seconds: 5),
            ),
          );
        }
      }
    }
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
            const SizedBox(height: 8),
            Text(
              '초대 코드를 공유하거나 이메일로 직접 초대할 수 있습니다.',
              style: Theme.of(context).textTheme.bodySmall,
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
              // TODO: 이메일 초대 기능은 백엔드 API 추가 필요
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('이메일 초대 기능은 개발 중입니다. 초대 코드를 공유해주세요.')),
              );
            },
            child: Text(l10n.group_send),
          ),
        ],
      ),
    );
  }

  Future<void> _showRemoveMemberDialog(
    BuildContext context,
    AppLocalizations l10n,
    GroupMember member,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.group_delete),
        content: Text('${member.user?.name ?? 'Unknown'} 님을 그룹에서 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.group_cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.group_delete),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(groupNotifierProvider.notifier).removeMember(
          widget.groupId,
          member.userId,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('멤버가 삭제되었습니다')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('오류: $e')),
          );
        }
      }
    }
  }

  Future<void> _showChangeRoleDialog(
    BuildContext context,
    AppLocalizations l10n,
    GroupMember member,
  ) async {
    final rolesAsync = ref.read(groupRolesProvider(widget.groupId));

    final result = await showDialog<String>(
      context: context,
      builder: (context) => rolesAsync.when(
        loading: () => AlertDialog(
          title: Text(l10n.group_role),
          content: const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(),
            ),
          ),
        ),
        error: (error, stack) => AlertDialog(
          title: Text(l10n.group_role),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('역할 목록을 불러올 수 없습니다:\n$error'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.group_cancel),
            ),
          ],
        ),
        data: (roles) {
          String? selectedRoleId = member.roleId;

          return StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              title: Text(l10n.group_role),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${member.user?.name ?? 'Unknown'}님의 역할을 변경합니다.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  ...roles.map((role) {
                    // OWNER 역할은 양도만 가능하므로 선택지에서 제외
                    if (role.name == 'OWNER') return const SizedBox.shrink();

                    return RadioListTile<String>(
                      title: Text(_getRoleName(l10n, role.name)),
                      subtitle: Text(role.name),
                      value: role.id,
                      groupValue: selectedRoleId,
                      onChanged: (value) {
                        setState(() {
                          selectedRoleId = value;
                        });
                      },
                    );
                  }),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.group_cancel),
                ),
                ElevatedButton(
                  onPressed: selectedRoleId != null && selectedRoleId != member.roleId
                      ? () => Navigator.pop(context, selectedRoleId)
                      : null,
                  child: Text(l10n.group_save),
                ),
              ],
            ),
          );
        },
      ),
    );

    if (result != null && mounted) {
      try {
        await ref.read(groupNotifierProvider.notifier).updateMemberRole(
          widget.groupId,
          member.userId,
          result,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('역할이 변경되었습니다')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('오류: $e')),
          );
        }
      }
    }
  }

  Future<void> _showRoleManagementDialog(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    final rolesAsync = ref.read(groupRolesProvider(widget.groupId));

    showDialog(
      context: context,
      builder: (context) => rolesAsync.when(
        loading: () => AlertDialog(
          title: const Text('역할 관리'),
          content: const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(),
            ),
          ),
        ),
        error: (error, stack) => AlertDialog(
          title: const Text('역할 관리'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('역할 목록을 불러올 수 없습니다:\n$error'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.group_cancel),
            ),
          ],
        ),
        data: (roles) => AlertDialog(
          title: const Text('역할 관리'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '이 그룹의 역할 목록입니다.',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
                if (roles.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text('역할이 없습니다'),
                    ),
                  )
                else
                  ...roles.map((role) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _getRoleColor(role.name),
                        child: Icon(
                          role.name == 'OWNER'
                            ? Icons.star
                            : role.name == 'ADMIN'
                              ? Icons.admin_panel_settings
                              : Icons.person,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        _getRoleName(l10n, role.name),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ID: ${role.name}'),
                          if (role.isDefaultRole)
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.blue[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                '기본 역할',
                                style: TextStyle(fontSize: 11, color: Colors.blue),
                              ),
                            ),
                        ],
                      ),
                      trailing: role.groupId != null
                        ? const Icon(Icons.edit, size: 20)
                        : null,
                    ),
                  )),
                const SizedBox(height: 8),
                const Divider(),
                const SizedBox(height: 8),
                const Text(
                  '💡 공통 역할 (OWNER, ADMIN, MEMBER)은 모든 그룹에 기본으로 제공됩니다.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                const Text(
                  '💡 커스텀 역할 생성 기능은 추후 추가될 예정입니다.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.group_cancel),
            ),
          ],
        ),
      ),
    );
  }

  void _showSettingsBottomSheet(
    BuildContext context,
    AppLocalizations l10n,
    Group group,
    AsyncValue<List<GroupMember>> membersAsync,
  ) {
    final canManage = _canManageGroup(membersAsync);
    final isOwner = membersAsync.when(
      data: (members) => members.isNotEmpty && members.first.role?.name == 'OWNER',
      loading: () => false,
      error: (_, stack) => false,
    );

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (canManage)
              ListTile(
                leading: const Icon(Icons.edit),
                title: Text(l10n.group_editGroup),
                onTap: () {
                  Navigator.pop(context);
                  _showEditGroupDialog(context, l10n, group);
                },
              ),
            if (isOwner)
              ListTile(
                leading: const Icon(Icons.admin_panel_settings),
                title: const Text('역할 관리'),
                onTap: () {
                  Navigator.pop(context);
                  _showRoleManagementDialog(context, l10n);
                },
              ),
            if (isOwner)
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
            if (!isOwner)
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

  Future<void> _showEditGroupDialog(BuildContext context, AppLocalizations l10n, Group group) async {
    final nameController = TextEditingController(text: group.name);
    final descriptionController = TextEditingController(text: group.description);

    final confirmed = await showDialog<bool>(
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
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.group_cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.group_save),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(groupNotifierProvider.notifier).updateGroup(
          widget.groupId,
          name: nameController.text,
          description: descriptionController.text,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.group_updateSuccess)),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('오류: $e')),
          );
        }
      }
    }
  }

  Future<void> _showDeleteGroupDialog(BuildContext context, AppLocalizations l10n) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.group_deleteConfirmTitle),
        content: Text(l10n.group_deleteConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.group_cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.group_delete),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(groupNotifierProvider.notifier).deleteGroup(widget.groupId);
        if (mounted) {
          Navigator.pop(context); // 그룹 상세 화면 닫기
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.group_deleteSuccess)),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('오류: $e')),
          );
        }
      }
    }
  }

  Future<void> _showLeaveGroupDialog(BuildContext context, AppLocalizations l10n) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.group_leaveConfirmTitle),
        content: Text(l10n.group_leaveConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.group_cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.group_leave),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(groupNotifierProvider.notifier).leaveGroup(widget.groupId);
        if (mounted) {
          Navigator.pop(context); // 그룹 상세 화면 닫기
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.group_leaveSuccess)),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('오류: $e')),
          );
        }
      }
    }
  }
}
