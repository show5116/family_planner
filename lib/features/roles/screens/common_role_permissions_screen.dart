import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/roles/providers/common_role_provider.dart';
import 'package:family_planner/features/settings/providers/permission_management_provider.dart';
import 'package:family_planner/features/settings/models/permission.dart';

/// 공통 역할의 권한 관리 화면
class CommonRolePermissionsScreen extends ConsumerStatefulWidget {
  final String roleId;

  const CommonRolePermissionsScreen({
    super.key,
    required this.roleId,
  });

  @override
  ConsumerState<CommonRolePermissionsScreen> createState() =>
      _CommonRolePermissionsScreenState();
}

class _CommonRolePermissionsScreenState
    extends ConsumerState<CommonRolePermissionsScreen> {
  Set<String> selectedPermissionIds = {};
  bool isModified = false;
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final roleAsync = ref.watch(commonRoleDetailProvider(widget.roleId));
    final permissionsState = ref.watch(permissionManagementProvider);

    return roleAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('권한 관리')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: const Text('권한 관리')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: AppSizes.spaceM),
              const Text('역할 정보를 불러오는데 실패했습니다'),
              const SizedBox(height: AppSizes.spaceS),
              Text(error.toString(), style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: AppSizes.spaceL),
              ElevatedButton.icon(
                onPressed: () {
                  ref.invalidate(commonRoleDetailProvider(widget.roleId));
                },
                icon: const Icon(Icons.refresh),
                label: const Text('다시 시도'),
              ),
            ],
          ),
        ),
      ),
      data: (role) {
        // 초기화: 역할에 할당된 권한 ID를 selectedPermissionIds에 설정
        if (selectedPermissionIds.isEmpty && !isModified) {
          selectedPermissionIds = role.permissionIds.toSet();
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('${role.name} 권한 관리'),
            elevation: 0,
            actions: [
              if (isModified)
                TextButton(
                  onPressed: () => _savePermissions(role.id),
                  child: const Text(
                    '저장',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          body: Column(
            children: [
              // 검색 및 정보 영역
              Container(
                padding: const EdgeInsets.all(AppSizes.spaceM),
                color: Theme.of(context).colorScheme.surface,
                child: Column(
                  children: [
                    // 역할 정보
                    _buildRoleInfo(context, role),
                    const SizedBox(height: AppSizes.spaceM),
                    // 검색 필드
                    _buildSearchField(context),
                  ],
                ),
              ),
              const Divider(height: 1),
              // 권한 목록
              Expanded(
                child: _buildPermissionsList(context, permissionsState),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRoleInfo(BuildContext context, dynamic role) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.spaceM),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      child: Row(
        children: [
          Icon(
            Icons.admin_panel_settings,
            color: Theme.of(context).colorScheme.primary,
            size: 32,
          ),
          const SizedBox(width: AppSizes.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  role.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                if (role.description != null)
                  Text(
                    role.description!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spaceM,
              vertical: AppSizes.spaceS,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
            ),
            child: Text(
              '${selectedPermissionIds.length}개 선택',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: '권한 검색',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
        filled: true,
      ),
      onChanged: (value) {
        setState(() {
          searchQuery = value;
        });
      },
    );
  }

  Widget _buildPermissionsList(
    BuildContext context,
    dynamic permissionsState,
  ) {
    if (permissionsState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (permissionsState.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: AppSizes.spaceM),
            const Text('권한 목록을 불러오는데 실패했습니다'),
            const SizedBox(height: AppSizes.spaceS),
            Text(
              permissionsState.error!,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: AppSizes.spaceL),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(permissionManagementProvider.notifier).loadPermissions();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    // 검색 필터링
    final filteredPermissions = permissionsState.permissions.where((p) {
      if (searchQuery.isEmpty) return true;
      return p.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          p.code.toLowerCase().contains(searchQuery.toLowerCase()) ||
          p.category.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    if (filteredPermissions.isEmpty) {
      return const Center(
        child: Text('검색 결과가 없습니다'),
      );
    }

    // 카테고리별로 그룹화
    final groupedPermissions = <String, List<Permission>>{};
    for (final permission in filteredPermissions) {
      groupedPermissions.putIfAbsent(permission.category, () => []);
      groupedPermissions[permission.category]!.add(permission);
    }

    return ListView(
      padding: const EdgeInsets.all(AppSizes.spaceM),
      children: groupedPermissions.entries.map((entry) {
        final category = entry.key;
        final permissions = entry.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCategoryHeader(context, category, permissions.length),
            ...permissions.map((permission) {
              final isSelected = selectedPermissionIds.contains(permission.id);
              return CheckboxListTile(
                title: Text(permission.name),
                subtitle: Text(
                  '${permission.code}${permission.description != null ? '\n${permission.description}' : ''}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                value: isSelected,
                onChanged: permission.isActive
                    ? (value) {
                        setState(() {
                          if (value == true) {
                            selectedPermissionIds.add(permission.id);
                          } else {
                            selectedPermissionIds.remove(permission.id);
                          }
                          isModified = true;
                        });
                      }
                    : null,
                secondary: Icon(
                  Icons.security,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
                ),
                enabled: permission.isActive,
              );
            }),
            const SizedBox(height: AppSizes.spaceL),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildCategoryHeader(
    BuildContext context,
    String category,
    int count,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.spaceM),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spaceM,
              vertical: AppSizes.spaceS,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
            ),
            child: Text(
              category,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(width: AppSizes.spaceS),
          Text(
            '$count개',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Future<void> _savePermissions(String roleId) async {
    try {
      await ref.read(commonRoleProvider.notifier).updateRolePermissions(
            roleId,
            selectedPermissionIds.toList(),
          );

      if (mounted) {
        setState(() {
          isModified = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('권한이 저장되었습니다')),
        );
        // Provider 새로고침
        ref.invalidate(commonRoleDetailProvider(roleId));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('저장 실패: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
