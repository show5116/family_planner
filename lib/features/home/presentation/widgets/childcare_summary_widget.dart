import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/providers/dashboard_widget_settings_provider.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/main/child_points/data/models/childcare_model.dart';
import 'package:family_planner/features/main/child_points/providers/childcare_provider.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/shared/widgets/dashboard_card.dart';

const _kChildcareGroupIdKey = 'childcare_selected_group_id';

class ChildcareSummaryWidget extends ConsumerStatefulWidget {
  const ChildcareSummaryWidget({
    super.key,
    this.initialSelectedGroupId,
  });

  final String? initialSelectedGroupId;

  @override
  ConsumerState<ChildcareSummaryWidget> createState() =>
      _ChildcareSummaryWidgetState();
}

class _ChildcareSummaryWidgetState
    extends ConsumerState<ChildcareSummaryWidget> {
  String? _selectedGroupId;

  @override
  void initState() {
    super.initState();
    _selectedGroupId = widget.initialSelectedGroupId;
    WidgetsBinding.instance.addPostFrameCallback((_) => _initGroup());
  }

  Future<void> _initGroup() async {
    if (_selectedGroupId != null) {
      ref.read(childcareSelectedGroupIdProvider.notifier).state =
          _selectedGroupId;
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_kChildcareGroupIdKey);
    if (!mounted) return;
    if (saved != null) {
      setState(() => _selectedGroupId = saved);
      ref.read(childcareSelectedGroupIdProvider.notifier).state = saved;
    } else {
      final groups = await ref
          .read(myGroupsProvider.future)
          .catchError((_) => <Group>[]);
      if (groups.isNotEmpty && mounted) {
        setState(() => _selectedGroupId = groups.first.id);
        ref.read(childcareSelectedGroupIdProvider.notifier).state =
            groups.first.id;
      }
    }
  }

  Future<void> _saveFilter(String groupId) async {
    final current = ref.read(dashboardWidgetSettingsProvider).valueOrNull;
    if (current == null) return;
    await ref.read(dashboardWidgetSettingsProvider.notifier).save(
          current.copyWith(childcareSelectedGroupId: groupId),
        );
  }

  Future<void> _showGroupPicker(List<Group> groups) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusMedium),
        ),
      ),
      builder: (_) => _GroupPickerSheet(
        groups: groups,
        selectedGroupId: _selectedGroupId,
        onApply: (groupId) {
          setState(() => _selectedGroupId = groupId);
          ref.read(childcareSelectedGroupIdProvider.notifier).state = groupId;
          _saveFilter(groupId);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final groups = ref.watch(myGroupsProvider).valueOrNull ?? [];
    final childrenAsync = ref.watch(childcareChildrenProvider);
    final accountsAsync = ref.watch(childcareAccountsProvider);

    final hasFilter = _selectedGroupId != null;
    String title = '육아 포인트';
    if (_selectedGroupId != null && groups.isNotEmpty) {
      final group =
          groups.where((g) => g.id == _selectedGroupId).firstOrNull;
      if (group != null) title = '${group.name} 포인트';
    }

    return DashboardCard(
      title: title,
      icon: Icons.child_care,
      action: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (groups.isNotEmpty)
            IconButton(
              iconSize: 20,
              visualDensity: VisualDensity.compact,
              tooltip: '그룹 선택',
              icon: Badge(
                isLabelVisible: hasFilter,
                smallSize: 7,
                child: Icon(
                  Icons.tune,
                  color: hasFilter
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              onPressed: () => _showGroupPicker(groups),
            ),
        ],
      ),
      onTap: () => context.push(AppRoutes.childPoints),
      child: childrenAsync.when(
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.all(AppSizes.spaceM),
            child: CircularProgressIndicator(),
          ),
        ),
        error: (_, _) => const _EmptyState(),
        data: (children) {
          if (children.isEmpty) return const _EmptyState();
          return accountsAsync.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSizes.spaceM),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (_, _) => _ChildrenList(children: children, accounts: []),
            data: (accounts) =>
                _ChildrenList(children: children, accounts: accounts),
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceM),
      child: Center(
        child: Text(
          '등록된 자녀가 없습니다',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ),
    );
  }
}

class _ChildrenList extends StatelessWidget {
  const _ChildrenList({
    required this.children,
    required this.accounts,
  });

  final List<ChildcareChild> children;
  final List<ChildcareAccount> accounts;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: children.map((child) {
        ChildcareAccount? account;
        try {
          account = accounts.firstWhere((a) => a.childId == child.id);
        } catch (_) {
          account = null;
        }

        final balance = account?.balance ?? 0;
        final savings = account?.savingsBalance ?? 0;

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSizes.spaceS),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor:
                    Theme.of(context).colorScheme.primaryContainer,
                child: Text(
                  child.name.isNotEmpty ? child.name[0] : '?',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.spaceS),
              Expanded(
                child: Text(
                  child.name,
                  style: Theme.of(context).textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${balance.toInt()}P',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                  ),
                  if (savings > 0)
                    Text(
                      '적금 ${savings.toInt()}P',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                    ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _GroupPickerSheet extends StatefulWidget {
  const _GroupPickerSheet({
    required this.groups,
    required this.selectedGroupId,
    required this.onApply,
  });

  final List<Group> groups;
  final String? selectedGroupId;
  final void Function(String groupId) onApply;

  @override
  State<_GroupPickerSheet> createState() => _GroupPickerSheetState();
}

class _GroupPickerSheetState extends State<_GroupPickerSheet> {
  late String _selectedGroupId;

  @override
  void initState() {
    super.initState();
    _selectedGroupId = widget.selectedGroupId ??
        (widget.groups.isNotEmpty ? widget.groups.first.id : '');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: AppSizes.spaceM),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.spaceL,
              AppSizes.spaceM,
              AppSizes.spaceL,
              AppSizes.spaceS,
            ),
            child: Text('그룹 선택',
                style: Theme.of(context).textTheme.titleLarge),
          ),
          const Divider(),
          RadioGroup<String>(
            groupValue: _selectedGroupId,
            onChanged: (v) => setState(() => _selectedGroupId = v!),
            child: Column(
              children: widget.groups
                  .map((g) => RadioListTile<String>(
                        title: Text(g.name),
                        value: g.id,
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: AppSizes.spaceS),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.spaceL,
              0,
              AppSizes.spaceL,
              AppSizes.spaceL,
            ),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _selectedGroupId.isEmpty
                    ? null
                    : () => widget.onApply(_selectedGroupId),
                child: const Text('적용'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
