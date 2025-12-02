import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/groups/screens/group_detail_screen.dart';
import 'package:family_planner/features/groups/providers/group_provider.dart';
import 'package:family_planner/features/groups/models/group.dart';

/// 그룹 목록 화면 (API 연동)
class GroupListScreen extends ConsumerWidget {
  const GroupListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final groupsAsyncValue = ref.watch(groupNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.group_title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(groupNotifierProvider.notifier).loadGroups();
            },
          ),
        ],
      ),
      body: groupsAsyncValue.when(
        data: (groups) => groups.isEmpty
            ? _buildEmptyState(context, l10n)
            : RefreshIndicator(
                onRefresh: () async {
                  await ref.read(groupNotifierProvider.notifier).loadGroups();
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(AppSizes.spaceM),
                  itemCount: groups.length,
                  itemBuilder: (context, index) {
                    final group = groups[index];
                    return _GroupCard(group: group);
                  },
                ),
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: AppSizes.spaceM),
              Text(
                l10n.error_unknown,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSizes.spaceS),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.spaceM),
              ElevatedButton(
                onPressed: () {
                  ref.read(groupNotifierProvider.notifier).loadGroups();
                },
                child: const Text('재시도'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            onPressed: () => _showJoinGroupDialog(context, ref, l10n),
            icon: const Icon(Icons.login),
            label: Text(l10n.group_joinGroup),
            heroTag: 'join',
          ),
          const SizedBox(height: AppSizes.spaceM),
          FloatingActionButton.extended(
            onPressed: () => _showCreateGroupDialog(context, ref, l10n),
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

  void _showCreateGroupDialog(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedColor = '#6366F1'; // 기본 색상

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.group_createGroup),
          content: SizedBox(
            width: double.maxFinite,
            child: Form(
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
                      '#EF4444', // red
                      '#EC4899', // pink
                      '#A855F7', // purple
                      '#6366F1', // indigo
                      '#14B8A6', // teal
                      '#10B981', // green
                      '#F97316', // orange
                      '#78350F', // brown
                    ].map((color) {
                      return InkWell(
                        onTap: () => setState(() => selectedColor = color),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(int.parse(color.substring(1), radix: 16) + 0xFF000000),
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
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l10n.group_cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  try {
                    await ref.read(groupNotifierProvider.notifier).createGroup(
                          name: nameController.text,
                          description: descriptionController.text.isEmpty
                              ? null
                              : descriptionController.text,
                          defaultColor: selectedColor,
                        );

                    if (dialogContext.mounted) {
                      Navigator.pop(dialogContext);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.group_createSuccess)),
                      );
                    }
                  } catch (e) {
                    if (dialogContext.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('오류: ${e.toString()}')),
                      );
                    }
                  }
                }
              },
              child: Text(l10n.group_create),
            ),
          ],
        ),
      ),
    );
  }

  void _showJoinGroupDialog(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    final formKey = GlobalKey<FormState>();
    final codeController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.group_joinGroup),
        content: SizedBox(
          width: double.maxFinite,
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
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
        ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.group_cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                try {
                  await ref.read(groupNotifierProvider.notifier).joinGroup(
                        codeController.text.trim(),
                      );

                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.group_joinSuccess)),
                    );
                  }
                } catch (e) {
                  if (dialogContext.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('오류: ${e.toString()}')),
                    );
                  }
                }
              }
            },
            child: Text(l10n.group_join),
          ),
        ],
      ),
    );
  }
}

/// 그룹 카드 위젯
class _GroupCard extends ConsumerWidget {
  final Group group;

  const _GroupCard({required this.group});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    // 색상 파싱 (HEX -> Color)
    // myColor가 있으면 myColor를 사용, 없으면 defaultColor 사용
    Color? groupColor;
    final colorToUse = group.myColor ?? group.defaultColor;
    if (colorToUse != null && colorToUse.isNotEmpty) {
      try {
        groupColor = Color(
          int.parse(colorToUse.substring(1), radix: 16) + 0xFF000000,
        );
      } catch (e) {
        groupColor = Colors.blue;
      }
    }

    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.spaceM),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GroupDetailScreen(groupId: group.id),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // 그룹 색상 표시
                  if (groupColor != null)
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
                      group.name,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              if (group.description != null && group.description!.isNotEmpty) ...[
                const SizedBox(height: AppSizes.spaceS),
                Text(
                  group.description!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
              const SizedBox(height: AppSizes.spaceM),
              Row(
                children: [
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: group.inviteCode));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.group_codeCopied)),
                      );
                    },
                    icon: const Icon(Icons.copy, size: 16),
                    label: Text(group.inviteCode),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
