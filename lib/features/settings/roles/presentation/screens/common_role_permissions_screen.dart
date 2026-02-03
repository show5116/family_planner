import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/settings/roles/models/common_role.dart';
import 'package:family_planner/features/settings/roles/providers/common_role_provider.dart';
import 'package:family_planner/features/settings/roles/presentation/widgets/role_info_header.dart';
import 'package:family_planner/features/settings/roles/presentation/widgets/permission_category_header.dart';
import 'package:family_planner/shared/widgets/app_error_state.dart';
import 'package:family_planner/features/settings/roles/presentation/widgets/permission_checkbox_tile.dart';
import 'package:family_planner/features/settings/permissions/providers/permission_management_provider.dart';
import 'package:family_planner/features/settings/permissions/models/permission.dart';

/// 공통 역할의 권한 관리 화면
class CommonRolePermissionsScreen extends ConsumerStatefulWidget {
  final String roleId;

  const CommonRolePermissionsScreen({super.key, required this.roleId});

  @override
  ConsumerState<CommonRolePermissionsScreen> createState() =>
      _CommonRolePermissionsScreenState();
}

class _CommonRolePermissionsScreenState
    extends ConsumerState<CommonRolePermissionsScreen> {
  Set<String> selectedPermissionCodes = {};
  bool isModified = false;
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final rolesState = ref.watch(commonRoleProvider);
    final permissionsState = ref.watch(permissionManagementProvider);

    if (rolesState.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('권한 관리')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (rolesState.error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('권한 관리')),
        body: AppErrorState(
          error: rolesState.error ?? '알 수 없는 오류',
          title: '역할 정보를 불러오는데 실패했습니다',
          onRetry: () => ref.read(commonRoleProvider.notifier).loadRoles(),
        ),
      );
    }

    final role = rolesState.roles.firstWhere(
      (r) => r.id == widget.roleId,
      orElse: () => throw Exception('역할을 찾을 수 없습니다'),
    );

    _initializePermissions(role);

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
          _buildHeader(context, role),
          const Divider(height: 1),
          Expanded(child: _buildPermissionsList(context, permissionsState)),
        ],
      ),
    );
  }

  void _initializePermissions(CommonRole role) {
    if (selectedPermissionCodes.isEmpty && !isModified) {
      selectedPermissionCodes = role.permissions.toSet();
    }
  }

  Widget _buildHeader(BuildContext context, CommonRole role) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.spaceM),
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          RoleInfoHeader(
            role: role,
            selectedCount: selectedPermissionCodes.length,
          ),
          const SizedBox(height: AppSizes.spaceM),
          _buildSearchField(context),
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
      onChanged: (value) => setState(() => searchQuery = value),
    );
  }

  Widget _buildPermissionsList(
    BuildContext context,
    PermissionManagementState permissionsState,
  ) {
    if (permissionsState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (permissionsState.error != null) {
      return AppErrorState(
        error: permissionsState.error ?? '알 수 없는 오류',
        title: '권한 목록을 불러오는데 실패했습니다',
        onRetry: () =>
            ref.read(permissionManagementProvider.notifier).loadPermissions(),
      );
    }

    final filteredPermissions = _filterPermissions(permissionsState.permissions);

    if (filteredPermissions.isEmpty) {
      return const Center(child: Text('검색 결과가 없습니다'));
    }

    final groupedPermissions = _groupByCategory(filteredPermissions);

    return ListView(
      padding: const EdgeInsets.all(AppSizes.spaceM),
      children: groupedPermissions.entries.map((entry) {
        return _buildCategorySection(context, entry.key, entry.value);
      }).toList(),
    );
  }

  List<Permission> _filterPermissions(List<Permission> permissions) {
    if (searchQuery.isEmpty) return permissions;
    return permissions.where((p) {
      return p.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          p.code.toLowerCase().contains(searchQuery.toLowerCase()) ||
          p.category.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  Map<String, List<Permission>> _groupByCategory(List<Permission> permissions) {
    final grouped = <String, List<Permission>>{};
    for (final permission in permissions) {
      grouped.putIfAbsent(permission.category, () => []);
      grouped[permission.category]!.add(permission);
    }
    return grouped;
  }

  Widget _buildCategorySection(
    BuildContext context,
    String category,
    List<Permission> permissions,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PermissionCategoryHeader(category: category, count: permissions.length),
        ...permissions.map((permission) {
          final isSelected = selectedPermissionCodes.contains(permission.code);
          return PermissionCheckboxTile(
            permission: permission,
            isSelected: isSelected,
            onChanged: (value) => _handlePermissionChange(permission.code, value),
          );
        }),
        const SizedBox(height: AppSizes.spaceL),
      ],
    );
  }

  void _handlePermissionChange(String code, bool? value) {
    setState(() {
      if (value == true) {
        selectedPermissionCodes.add(code);
      } else {
        selectedPermissionCodes.remove(code);
      }
      isModified = true;
    });
  }

  Future<void> _savePermissions(String roleId) async {
    try {
      await ref
          .read(commonRoleProvider.notifier)
          .updateRolePermissions(roleId, selectedPermissionCodes.toList());

      if (mounted) {
        setState(() => isModified = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('권한이 저장되었습니다')),
        );
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
