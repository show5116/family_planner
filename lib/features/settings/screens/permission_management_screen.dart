import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

/// 사용자 정보 모델
class UserPermission {
  final String id;
  final String email;
  final String name;
  final bool isAdmin;
  final DateTime createdAt;

  UserPermission({
    required this.id,
    required this.email,
    required this.name,
    required this.isAdmin,
    required this.createdAt,
  });

  factory UserPermission.fromJson(Map<String, dynamic> json) {
    return UserPermission(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      isAdmin: json['isAdmin'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  UserPermission copyWith({
    String? id,
    String? email,
    String? name,
    bool? isAdmin,
    DateTime? createdAt,
  }) {
    return UserPermission(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      isAdmin: isAdmin ?? this.isAdmin,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// 권한 관리 상태
class PermissionManagementState {
  final List<UserPermission> users;
  final bool isLoading;
  final String? error;
  final String searchQuery;

  PermissionManagementState({
    this.users = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
  });

  PermissionManagementState copyWith({
    List<UserPermission>? users,
    bool? isLoading,
    String? error,
    String? searchQuery,
  }) {
    return PermissionManagementState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  List<UserPermission> get filteredUsers {
    if (searchQuery.isEmpty) return users;

    final query = searchQuery.toLowerCase();
    return users.where((user) {
      return user.email.toLowerCase().contains(query) ||
          user.name.toLowerCase().contains(query);
    }).toList();
  }
}

/// 권한 관리 Provider
class PermissionManagementNotifier extends StateNotifier<PermissionManagementState> {
  PermissionManagementNotifier() : super(PermissionManagementState()) {
    loadUsers();
  }

  /// 사용자 목록 로드
  Future<void> loadUsers() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: 실제 API 호출로 교체
      // final response = await _apiClient.get('/permissions/users');
      // final users = (response.data as List)
      //     .map((json) => UserPermission.fromJson(json))
      //     .toList();

      // 임시 데모 데이터
      await Future.delayed(const Duration(seconds: 1));
      final users = [
        UserPermission(
          id: '1',
          email: 'admin@example.com',
          name: '관리자',
          isAdmin: true,
          createdAt: DateTime.now().subtract(const Duration(days: 365)),
        ),
        UserPermission(
          id: '2',
          email: 'user1@example.com',
          name: '홍길동',
          isAdmin: false,
          createdAt: DateTime.now().subtract(const Duration(days: 100)),
        ),
        UserPermission(
          id: '3',
          email: 'user2@example.com',
          name: '김철수',
          isAdmin: false,
          createdAt: DateTime.now().subtract(const Duration(days: 50)),
        ),
      ];

      state = state.copyWith(users: users, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// 검색어 설정
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  /// 관리자 권한 토글
  Future<bool> toggleAdminPermission(String userId, bool currentIsAdmin) async {
    try {
      // TODO: 실제 API 호출로 교체
      // await _apiClient.patch('/permissions/users/$userId', {
      //   'isAdmin': !currentIsAdmin,
      // });

      // 임시 처리
      await Future.delayed(const Duration(milliseconds: 500));

      // 로컬 상태 업데이트
      final updatedUsers = state.users.map((user) {
        if (user.id == userId) {
          return user.copyWith(isAdmin: !currentIsAdmin);
        }
        return user;
      }).toList();

      state = state.copyWith(users: updatedUsers);
      return true;
    } catch (e) {
      return false;
    }
  }
}

final permissionManagementProvider =
    StateNotifierProvider<PermissionManagementNotifier, PermissionManagementState>(
  (ref) => PermissionManagementNotifier(),
);

/// 권한 관리 화면
class PermissionManagementScreen extends ConsumerWidget {
  const PermissionManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(permissionManagementProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.permission_title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(permissionManagementProvider.notifier).loadUsers();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 검색 바
          Padding(
            padding: const EdgeInsets.all(AppSizes.spaceM),
            child: TextField(
              decoration: InputDecoration(
                hintText: l10n.permission_searchUser,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                ),
                filled: true,
              ),
              onChanged: (value) {
                ref.read(permissionManagementProvider.notifier)
                    .setSearchQuery(value);
              },
            ),
          ),

          // 사용자 목록
          Expanded(
            child: _buildUserList(context, ref, l10n, state),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    PermissionManagementState state,
  ) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: AppSizes.spaceM),
            Text(
              l10n.permission_loadFailed,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSizes.spaceS),
            Text(
              state.error!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.spaceL),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(permissionManagementProvider.notifier).loadUsers();
              },
              icon: const Icon(Icons.refresh),
              label: Text(l10n.common_retry),
            ),
          ],
        ),
      );
    }

    final filteredUsers = state.filteredUsers;

    if (filteredUsers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: AppSizes.spaceM),
            Text(
              l10n.permission_noUsers,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(permissionManagementProvider.notifier).loadUsers();
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceM),
        itemCount: filteredUsers.length,
        itemBuilder: (context, index) {
          final user = filteredUsers[index];
          return _buildUserCard(context, ref, l10n, user);
        },
      ),
    );
  }

  Widget _buildUserCard(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    UserPermission user,
  ) {
    final dateFormat = DateFormat('yyyy-MM-dd');

    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.spaceM),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 사용자 정보
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: user.isAdmin
                      ? Colors.red[100]
                      : Colors.blue[100],
                  child: Icon(
                    user.isAdmin ? Icons.admin_panel_settings : Icons.person,
                    color: user.isAdmin ? Colors.red[700] : Colors.blue[700],
                  ),
                ),
                const SizedBox(width: AppSizes.spaceM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              user.name,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: AppSizes.spaceS),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.spaceS,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: user.isAdmin ? Colors.red : Colors.grey,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              user.isAdmin
                                  ? l10n.permission_admin
                                  : l10n.permission_user,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSizes.spaceM),
            const Divider(),
            const SizedBox(height: AppSizes.spaceS),

            // 상세 정보
            _buildInfoRow(
              context,
              icon: Icons.badge_outlined,
              label: l10n.permission_userId,
              value: user.id,
            ),
            const SizedBox(height: AppSizes.spaceS),
            _buildInfoRow(
              context,
              icon: Icons.calendar_today_outlined,
              label: l10n.permission_createdAt,
              value: dateFormat.format(user.createdAt),
            ),

            const SizedBox(height: AppSizes.spaceM),

            // 권한 변경 버튼
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showPermissionDialog(
                  context,
                  ref,
                  l10n,
                  user,
                ),
                icon: Icon(
                  user.isAdmin
                      ? Icons.remove_circle_outline
                      : Icons.add_circle_outline,
                ),
                label: Text(
                  user.isAdmin
                      ? l10n.permission_revokeAdmin
                      : l10n.permission_grantAdmin,
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: user.isAdmin ? Colors.orange : Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: AppSizes.spaceS),
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodySmall,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Future<void> _showPermissionDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    UserPermission user,
  ) async {
    final shouldUpdate = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          user.isAdmin
              ? l10n.permission_confirmRevoke
              : l10n.permission_confirmGrant,
        ),
        content: Text(
          user.isAdmin
              ? l10n.permission_revokeMessage(user.name)
              : l10n.permission_grantMessage(user.name),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.common_cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.common_confirm),
          ),
        ],
      ),
    );

    if (shouldUpdate == true && context.mounted) {
      // 권한 업데이트
      final success = await ref
          .read(permissionManagementProvider.notifier)
          .toggleAdminPermission(user.id, user.isAdmin);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? l10n.permission_updateSuccess
                  : l10n.permission_updateFailed,
            ),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
    }
  }
}
