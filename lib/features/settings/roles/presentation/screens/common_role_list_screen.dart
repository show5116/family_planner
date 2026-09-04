import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/core/widgets/reorderable_widgets.dart';
import 'package:family_planner/features/settings/roles/models/common_role.dart';
import 'package:family_planner/features/settings/roles/providers/common_role_provider.dart';
import 'package:family_planner/features/settings/roles/presentation/widgets/common_role_dialogs.dart';
import 'package:family_planner/features/settings/roles/presentation/widgets/role_card.dart';
import 'package:family_planner/features/settings/roles/presentation/widgets/role_delete_dialog.dart';
import 'package:family_planner/shared/widgets/app_empty_state.dart';
import 'package:family_planner/shared/widgets/app_error_state.dart';

/// 공통 역할 관리 화면 (운영자 전용)
class CommonRoleListScreen extends ConsumerStatefulWidget {
  const CommonRoleListScreen({super.key});

  @override
  ConsumerState<CommonRoleListScreen> createState() =>
      _CommonRoleListScreenState();
}

class _CommonRoleListScreenState extends ConsumerState<CommonRoleListScreen> {
  List<CommonRole>? _reorderedRoles;
  bool _hasChanges = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(commonRoleProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.role_common_title), elevation: 0),
      body: Column(
        children: [
          if (_hasChanges)
            ReorderChangesBar(onSave: _saveSortOrder, onCancel: _cancelReorder),
          Expanded(child: _buildBody(state)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => CommonRoleCreateDialog.show(context, ref),
        icon: const Icon(Icons.add),
        label: Text(l10n.role_create),
      ),
    );
  }

  Widget _buildBody(CommonRoleState state) {
    final l10n = AppLocalizations.of(context)!;
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return AppErrorState(
        error: state.error ?? l10n.common_unknownError,
        title: l10n.role_list_load_error,
        onRetry: () => ref.read(commonRoleProvider.notifier).loadRoles(),
      );
    }

    final roles = _reorderedRoles ?? state.roles;

    if (roles.isEmpty) {
      return AppEmptyState(
        icon: Icons.admin_panel_settings_outlined,
        message: l10n.role_list_empty,
        subtitle: l10n.role_list_empty_subtitle,
      );
    }

    return ReorderableListView.builder(
      padding: const EdgeInsets.all(AppSizes.spaceM),
      itemCount: roles.length,
      buildDefaultDragHandles: false,
      proxyDecorator: buildReorderableProxyDecorator,
      onReorderItem: _handleReorder,
      itemBuilder: (context, index) {
        final role = roles[index];
        return RoleCard(
          key: ValueKey(role.id),
          role: role,
          index: index,
          onTap: () => _navigateToPermissions(role.id),
          onPermissions: () => _navigateToPermissions(role.id),
          onEdit: () => CommonRoleEditDialog.show(context, ref, role),
          onDelete: () =>
              RoleDeleteDialog.show(context, ref, role.id, role.name),
        );
      },
    );
  }

  void _handleReorder(int oldIndex, int newIndex) {
    final roles = _reorderedRoles ?? ref.read(commonRoleProvider).roles;

    setState(() {
      _reorderedRoles ??= List.from(roles);

      final item = _reorderedRoles!.removeAt(oldIndex);
      _reorderedRoles!.insert(newIndex, item);
      _hasChanges = true;
    });
  }

  void _navigateToPermissions(String roleId) {
    context.push(AppRoutes.commonRolePermissions.replaceFirst(':id', roleId));
  }

  Future<void> _cancelReorder() async {
    final confirmed = await showReorderCancelDialog(context);
    if (confirmed && mounted) {
      setState(() {
        _reorderedRoles = null;
        _hasChanges = false;
      });
    }
  }

  Future<void> _saveSortOrder() async {
    final l10n = AppLocalizations.of(context)!;
    if (_reorderedRoles == null) return;

    final confirm = await showReorderSaveDialog(context);
    if (!confirm) return;

    try {
      final sortOrders = <String, int>{};
      for (var i = 0; i < _reorderedRoles!.length; i++) {
        sortOrders[_reorderedRoles![i].id] = i;
      }

      await ref
          .read(commonRoleProvider.notifier)
          .updateSortOrders(sortOrders, _reorderedRoles!);

      if (mounted) {
        setState(() {
          _reorderedRoles = null;
          _hasChanges = false;
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.common_sortOrderSaved)));
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
