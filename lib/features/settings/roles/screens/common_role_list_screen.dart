import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/core/widgets/reorderable_widgets.dart';
import 'package:family_planner/features/settings/roles/providers/common_role_provider.dart';
import 'package:family_planner/features/settings/roles/widgets/common_role_dialogs.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 공통 역할 관리 화면 (운영자 전용)
/// groupId = null인 공통 역할 CRUD
class CommonRoleListScreen extends ConsumerStatefulWidget {
  const CommonRoleListScreen({super.key});

  @override
  ConsumerState<CommonRoleListScreen> createState() =>
      _CommonRoleListScreenState();
}

class _CommonRoleListScreenState extends ConsumerState<CommonRoleListScreen> {
  List<dynamic>? _reorderedRoles;
  bool _hasChanges = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(commonRoleProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('공통 역할 관리'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // 저장 버튼 (변경사항이 있을 때만 표시)
          if (_hasChanges)
            ReorderChangesBar(
              onSave: _saveSortOrder,
              onCancel: _cancelReorder,
            ),
          // 역할 목록
          Expanded(
            child: _buildBody(context, ref, l10n, state),
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

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    CommonRoleState state,
  ) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return _buildErrorView(context, ref, state);
    }

    final roles = _reorderedRoles ?? state.roles;

    if (roles.isEmpty) {
      return _buildEmptyView(context);
    }

    // 항상 ReorderableListView 사용 (드래그 앤 드롭 항상 가능)
    return ReorderableListView.builder(
      padding: const EdgeInsets.all(AppSizes.spaceM),
      itemCount: roles.length,
      buildDefaultDragHandles: false, // 기본 드래그 핸들 비활성화
      proxyDecorator: buildReorderableProxyDecorator,
      onReorder: (oldIndex, newIndex) {
        setState(() {
          // 처음 변경 시 복사본 생성
          _reorderedRoles ??= List.from(roles);

          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          final item = _reorderedRoles!.removeAt(oldIndex);
          _reorderedRoles!.insert(newIndex, item);

          // 변경사항 표시
          _hasChanges = true;
        });
      },
      itemBuilder: (context, index) {
        final role = roles[index];
        return ReorderableDragStartListener(
          key: ValueKey(role.id),
          index: index,
          child: Card(
            margin: const EdgeInsets.only(bottom: AppSizes.spaceM),
            child: ListTile(
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const DragHandleIcon(),
                  const SizedBox(width: AppSizes.spaceS),
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: role.color != null
                        ? Color(int.parse(role.color!.substring(1), radix: 16) + 0xFF000000)
                        : Colors.blue,
                    child: Text(
                      role.name.substring(0, 1),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              title: Row(
                children: [
                  Text(
                    role.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (role.isDefaultRole) ...[
                    const SizedBox(width: AppSizes.spaceS),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.spaceS,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                      ),
                      child: Text(
                        '기본',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.blue.shade900,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ],
              ),
              subtitle: role.description != null
                  ? Text(
                      role.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )
                  : null,
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'permissions':
                      context.push(
                        AppRoutes.commonRolePermissions.replaceFirst(':id', role.id),
                      );
                      break;
                    case 'edit':
                      CommonRoleEditDialog.show(context, ref, role);
                      break;
                    case 'delete':
                      _showDeleteConfirmation(context, ref, role.id, role.name);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'permissions',
                    child: Row(
                      children: [
                        Icon(Icons.security),
                        SizedBox(width: AppSizes.spaceS),
                        Text('권한 관리'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit),
                        SizedBox(width: AppSizes.spaceS),
                        Text('수정'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: AppSizes.spaceS),
                        Text('삭제', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
              onTap: () {
                context.push(
                  AppRoutes.commonRolePermissions.replaceFirst(':id', role.id),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorView(
    BuildContext context,
    WidgetRef ref,
    CommonRoleState state,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          const SizedBox(height: AppSizes.spaceM),
          const Text(
            '역할 목록을 불러오는데 실패했습니다',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSizes.spaceS),
          Text(
            state.error!,
            style: const TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.spaceL),
          ElevatedButton.icon(
            onPressed: () {
              ref.read(commonRoleProvider.notifier).loadRoles();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('다시 시도'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.admin_panel_settings_outlined,
              size: 64, color: Colors.grey[400]),
          const SizedBox(height: AppSizes.spaceM),
          Text(
            '등록된 공통 역할이 없습니다',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: AppSizes.spaceS),
          Text(
            '+ 버튼을 눌러 새로운 역할을 생성하세요',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    WidgetRef ref,
    String roleId,
    String roleName,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('역할 삭제'),
        content: Text('$roleName 역할을 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ref.read(commonRoleProvider.notifier).deleteRole(roleId);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('역할이 삭제되었습니다')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('삭제 실패: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('삭제', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  /// 순서 변경 취소
  Future<void> _cancelReorder() async {
    final confirmed = await showReorderCancelDialog(context);
    if (confirmed && mounted) {
      setState(() {
        _reorderedRoles = null;
        _hasChanges = false;
      });
    }
  }

  /// 정렬 순서 저장
  Future<void> _saveSortOrder() async {
    if (_reorderedRoles == null) return;

    // 확인 다이얼로그
    final confirm = await showReorderSaveDialog(context);
    if (!confirm) return;

    try {
      final sortOrders = <String, int>{};
      for (var i = 0; i < _reorderedRoles!.length; i++) {
        sortOrders[_reorderedRoles![i].id] = i;
      }

      // 재정렬된 역할 목록과 함께 전달
      await ref.read(commonRoleProvider.notifier).updateSortOrders(
            sortOrders,
            _reorderedRoles!.cast(),
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
