import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/providers/dashboard_widget_settings_provider.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/core/utils/extensions.dart';
import 'package:family_planner/features/home/providers/dashboard_provider.dart';
import 'package:family_planner/features/main/savings/data/models/savings_model.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/shared/widgets/dashboard_card.dart';

class SavingsSummaryWidget extends ConsumerStatefulWidget {
  const SavingsSummaryWidget({
    super.key,
    this.initialSelectedGroupId,
  });

  final String? initialSelectedGroupId;

  @override
  ConsumerState<SavingsSummaryWidget> createState() => _SavingsSummaryWidgetState();
}

class _SavingsSummaryWidgetState extends ConsumerState<SavingsSummaryWidget> {
  String? _selectedGroupId;

  @override
  void initState() {
    super.initState();
    _selectedGroupId = widget.initialSelectedGroupId;
  }

  @override
  void didUpdateWidget(SavingsSummaryWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialSelectedGroupId != oldWidget.initialSelectedGroupId) {
      _selectedGroupId = widget.initialSelectedGroupId;
    }
  }

  Future<void> _saveFilter() async {
    final current = ref.read(dashboardWidgetSettingsProvider).valueOrNull;
    if (current == null) return;
    await ref.read(dashboardWidgetSettingsProvider.notifier).save(
          current.copyWith(savingsSelectedGroupId: _selectedGroupId),
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
      builder: (context) => _SavingsGroupPickerSheet(
        groups: groups,
        selectedGroupId: _selectedGroupId,
        onApply: (String groupId) {
          setState(() => _selectedGroupId = groupId);
          _saveFilter();
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final groups = ref.watch(myGroupsProvider).valueOrNull ?? [];
    final goalsAsync = ref.watch(
      dashboardSavingsProvider(selectedGroupId: _selectedGroupId),
    );

    final hasActiveFilter = _selectedGroupId != null;

    return goalsAsync.when(
      loading: () => DashboardCard(
        title: '저금통',
        icon: Icons.savings,
        onTap: () {},
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(AppSizes.spaceM),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      error: (e, _) => _buildCard(context, groups, [], hasActiveFilter),
      data: (goals) => _buildCard(context, groups, goals, hasActiveFilter),
    );
  }

  Widget _buildCard(
    BuildContext context,
    List<Group> groups,
    List<SavingsGoalModel> goals,
    bool hasActiveFilter,
  ) {
    final activeGoals = goals.where((g) => g.status == SavingsGoalStatus.active).toList();
    final totalCurrent = goals.fold<double>(0, (s, g) => s + g.currentAmount);
    final totalTarget = goals.fold<double>(0, (s, g) => s + (g.targetAmount ?? 0));
    final hasTarget = totalTarget > 0;

    return DashboardCard(
      title: '저금통',
      icon: Icons.savings,
      action: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (groups.isNotEmpty)
            IconButton(
              iconSize: 20,
              visualDensity: VisualDensity.compact,
              tooltip: '그룹 선택',
              icon: Badge(
                isLabelVisible: hasActiveFilter,
                smallSize: 7,
                child: Icon(
                  Icons.tune,
                  color: hasActiveFilter
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              onPressed: () => _showGroupPicker(groups),
            ),
          IconButton(
            onPressed: () => context.push(AppRoutes.savings),
            icon: const Icon(Icons.arrow_forward, size: AppSizes.iconMedium),
          ),
        ],
      ),
      onTap: () => context.push(AppRoutes.savings),
      child: goals.isEmpty
          ? _buildEmpty(context)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 전체 합계
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '총 적립액',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    Text(
                      '${activeGoals.length}개 진행 중',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.spaceS),
                Text(
                  totalCurrent.toCurrency(),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                ),
                if (hasTarget) ...[
                  const SizedBox(height: AppSizes.spaceS),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (totalCurrent / totalTarget).clamp(0.0, 1.0),
                      minHeight: 8,
                      backgroundColor:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.success),
                    ),
                  ),
                  const SizedBox(height: AppSizes.spaceS),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '목표 ${totalTarget.toCurrency()}',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                      Text(
                        '${((totalCurrent / totalTarget) * 100).clamp(0, 100).toInt()}% 달성',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.success,
                            ),
                      ),
                    ],
                  ),
                ],
                if (goals.isNotEmpty) ...[
                  const SizedBox(height: AppSizes.spaceM),
                  const Divider(),
                  const SizedBox(height: AppSizes.spaceS),
                  ...goals.take(3).map((goal) => _GoalRow(goal: goal)),
                  if (goals.length > 3) ...[
                    const SizedBox(height: AppSizes.spaceS),
                    Text(
                      '외 ${goals.length - 3}개',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ],
              ],
            ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceM),
      child: Center(
        child: Text(
          '등록된 저금통이 없습니다',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ),
    );
  }
}

class _GoalRow extends StatelessWidget {
  const _GoalRow({required this.goal});

  final SavingsGoalModel goal;

  @override
  Widget build(BuildContext context) {
    final hasTarget = goal.targetAmount != null && goal.targetAmount! > 0;
    final ratio = hasTarget
        ? (goal.currentAmount / goal.targetAmount!).clamp(0.0, 1.0)
        : null;
    final isPaused = goal.status == SavingsGoalStatus.paused;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.spaceS),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isPaused ? Icons.pause_circle_outline : Icons.savings_outlined,
                size: 14,
                color: isPaused
                    ? Theme.of(context).colorScheme.onSurfaceVariant
                    : AppColors.primary,
              ),
              const SizedBox(width: AppSizes.spaceS),
              Expanded(
                child: Text(
                  goal.name,
                  style: Theme.of(context).textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                goal.currentAmount.toCurrency(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isPaused
                          ? Theme.of(context).colorScheme.onSurfaceVariant
                          : null,
                    ),
              ),
              if (hasTarget) ...[
                Text(
                  ' / ${goal.targetAmount!.toCurrency()}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ],
          ),
          if (ratio != null) ...[
            const SizedBox(height: 3),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: ratio,
                minHeight: 4,
                backgroundColor:
                    Theme.of(context).colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isPaused
                      ? Theme.of(context).colorScheme.onSurfaceVariant
                      : AppColors.success,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SavingsGroupPickerSheet extends StatefulWidget {
  const _SavingsGroupPickerSheet({
    required this.groups,
    required this.selectedGroupId,
    required this.onApply,
  });

  final List<Group> groups;
  final String? selectedGroupId;
  final void Function(String groupId) onApply;

  @override
  State<_SavingsGroupPickerSheet> createState() => _SavingsGroupPickerSheetState();
}

class _SavingsGroupPickerSheetState extends State<_SavingsGroupPickerSheet> {
  late String _selectedGroupId;

  @override
  void initState() {
    super.initState();
    _selectedGroupId = widget.selectedGroupId ?? widget.groups.first.id;
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: mq.viewInsets.bottom + mq.padding.bottom),
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
              AppSizes.spaceL, AppSizes.spaceM, AppSizes.spaceL, AppSizes.spaceS,
            ),
            child: Text('그룹 선택', style: Theme.of(context).textTheme.titleLarge),
          ),
          const Divider(),
          RadioGroup<String>(
            groupValue: _selectedGroupId,
            onChanged: (v) => setState(() => _selectedGroupId = v!),
            child: Column(
              children: widget.groups
                  .map((group) => RadioListTile<String>(
                        title: Text(group.name),
                        value: group.id,
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: AppSizes.spaceS),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.spaceL, 0, AppSizes.spaceL, AppSizes.spaceL,
            ),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => widget.onApply(_selectedGroupId),
                child: const Text('적용'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
