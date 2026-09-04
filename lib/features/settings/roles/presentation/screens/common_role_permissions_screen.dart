import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
    final rolesState = ref.watch(commonRoleProvider);
    final permissionsState = ref.watch(permissionManagementProvider);

    if (rolesState.isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.role_manage_permissions)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (rolesState.error != null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.role_manage_permissions)),
        body: AppErrorState(
          error: rolesState.error ?? l10n.common_unknownError,
          title: l10n.role_info_load_error,
          onRetry: () => ref.read(commonRoleProvider.notifier).loadRoles(),
        ),
      );
    }

    final role = rolesState.roles.firstWhere(
      (r) => r.id == widget.roleId,
      orElse: () => throw Exception(l10n.role_not_found),
    );

    _initializePermissions(role);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(l10n.role_permissions_title(role.name)),
        elevation: 0,
        actions: [
          if (isModified)
            TextButton(
              onPressed: () => _savePermissions(role.id),
              child: Text(
                l10n.common_save,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildHeader(context, role),
            const Divider(height: 1),
            Expanded(child: _buildPermissionsList(context, permissionsState)),
          ],
        ),
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
    final l10n = AppLocalizations.of(context)!;
    return TextField(
      decoration: InputDecoration(
        hintText: l10n.role_permission_search,
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
    final l10n = AppLocalizations.of(context)!;
    if (permissionsState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (permissionsState.error != null) {
      return AppErrorState(
        error: permissionsState.error ?? l10n.common_unknownError,
        title: l10n.role_permissions_load_error,
        onRetry: () =>
            ref.read(permissionManagementProvider.notifier).loadPermissions(),
      );
    }

    final filteredPermissions = _filterPermissions(
      permissionsState.permissions,
    );

    if (filteredPermissions.isEmpty) {
      return Center(child: Text(l10n.common_noSearchResults));
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
            onChanged: (value) =>
                _handlePermissionChange(permission.code, value),
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
    final l10n = AppLocalizations.of(context)!;
    try {
      await ref
          .read(commonRoleProvider.notifier)
          .updateRolePermissions(roleId, selectedPermissionCodes.toList());

      if (mounted) {
        setState(() => isModified = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.role_permissions_saved)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.common_saveFailed}\n$e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
