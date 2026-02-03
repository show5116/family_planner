import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
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
    final state = ref.watch(commonRoleProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('공통 역할 관리'),
        elevation: 0,
      ),
      body: Column(
        children: [
          if (_hasChanges)
            ReorderChangesBar(
              onSave: _saveSortOrder,
              onCancel: _cancelReorder,
            ),
          Expanded(
            child: _buildBody(state),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => CommonRoleCreateDialog.show(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('역할 생성'),
      ),
    );
  }

  Widget _buildBody(CommonRoleState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return AppErrorState(
        error: state.error ?? '알 수 없는 오류',
        title: '역할 목록을 불러오는데 실패했습니다',
        onRetry: () => ref.read(commonRoleProvider.notifier).loadRoles(),
      );
    }

    final roles = _reorderedRoles ?? state.roles;

    if (roles.isEmpty) {
      return const AppEmptyState(
        icon: Icons.admin_panel_settings_outlined,
        message: '등록된 공통 역할이 없습니다',
        subtitle: '+ 버튼을 눌러 새로운 역할을 생성하세요',
      );
    }

    return ReorderableListView.builder(
      padding: const EdgeInsets.all(AppSizes.spaceM),
      itemCount: roles.length,
      buildDefaultDragHandles: false,
      proxyDecorator: buildReorderableProxyDecorator,
      onReorder: _handleReorder,
      itemBuilder: (context, index) {
        final role = roles[index];
        return RoleCard(
          key: ValueKey(role.id),
          role: role,
          index: index,
          onTap: () => _navigateToPermissions(role.id),
          onPermissions: () => _navigateToPermissions(role.id),
          onEdit: () => CommonRoleEditDialog.show(context, ref, role),
          onDelete: () => RoleDeleteDialog.show(context, ref, role.id, role.name),
        );
      },
    );
  }

  void _handleReorder(int oldIndex, int newIndex) {
    final roles = _reorderedRoles ?? ref.read(commonRoleProvider).roles;

    setState(() {
      _reorderedRoles ??= List.from(roles);

      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = _reorderedRoles!.removeAt(oldIndex);
      _reorderedRoles!.insert(newIndex, item);
      _hasChanges = true;
    });
  }

  void _navigateToPermissions(String roleId) {
    context.push(
      AppRoutes.commonRolePermissions.replaceFirst(':id', roleId),
    );
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
    if (_reorderedRoles == null) return;

    final confirm = await showReorderSaveDialog(context);
    if (!confirm) return;

    try {
      final sortOrders = <String, int>{};
      for (var i = 0; i < _reorderedRoles!.length; i++) {
        sortOrders[_reorderedRoles![i].id] = i;
      }

      await ref.read(commonRoleProvider.notifier).updateSortOrders(
            sortOrders,
            _reorderedRoles!,
          );

      if (mounted) {
        setState(() {
          _reorderedRoles = null;
          _hasChanges = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('정렬 순서가 저장되었습니다')),
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
