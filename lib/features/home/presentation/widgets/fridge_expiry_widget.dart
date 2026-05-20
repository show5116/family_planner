import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/providers/dashboard_widget_settings_provider.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/main/fridge/data/models/fridge_models.dart';
import 'package:family_planner/features/main/fridge/providers/fridge_provider.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/shared/widgets/dashboard_card.dart';

class FridgeExpiryWidget extends ConsumerStatefulWidget {
  const FridgeExpiryWidget({super.key, this.initialSelectedGroupId});

  final String? initialSelectedGroupId;

  @override
  ConsumerState<FridgeExpiryWidget> createState() => _FridgeExpiryWidgetState();
}

class _FridgeExpiryWidgetState extends ConsumerState<FridgeExpiryWidget> {
  String? _selectedGroupId;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _selectedGroupId = widget.initialSelectedGroupId;
  }

  @override
  void didUpdateWidget(FridgeExpiryWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialSelectedGroupId != oldWidget.initialSelectedGroupId) {
      _selectedGroupId = widget.initialSelectedGroupId;
      _initialized = false;
    }
  }

  /// 그룹을 선택하면 fridgeSelectedGroupIdProvider도 함께 업데이트해서
  /// storagesWithItemsProvider가 해당 그룹 데이터를 가져오도록 한다.
  void _selectGroup(String groupId) {
    setState(() => _selectedGroupId = groupId);
    ref.read(fridgeSelectedGroupIdProvider.notifier).state = groupId;
    _saveFilter();
  }

  /// 위젯 최초 빌드 시 그룹이 아직 선택되지 않은 경우 첫 번째 그룹을 자동 선택
  void _ensureGroupSelected(List<Group> groups) {
    if (_initialized || groups.isEmpty) return;
    _initialized = true;
    final currentGroupId = ref.read(fridgeSelectedGroupIdProvider);
    final targetId = _selectedGroupId ?? currentGroupId ?? groups.first.id;
    if (currentGroupId != targetId) {
      // build 중 setState 방지: 다음 프레임에 적용
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref.read(fridgeSelectedGroupIdProvider.notifier).state = targetId;
        }
      });
    }
    _selectedGroupId ??= targetId;
  }

  Future<void> _saveFilter() async {
    final current = ref.read(dashboardWidgetSettingsProvider).valueOrNull;
    if (current == null) return;
    await ref.read(dashboardWidgetSettingsProvider.notifier).save(
          current.copyWith(fridgeExpirySelectedGroupId: _selectedGroupId),
        );
  }

  Future<void> _showGroupPicker(List<Group> groups) async {
    await showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusMedium)),
      ),
      builder: (_) => _GroupPickerSheet(
        groups: groups,
        selectedGroupId: _selectedGroupId,
        onSelect: (id) {
          _selectGroup(id);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final groups = ref.watch(myGroupsProvider).valueOrNull ?? [];
    _ensureGroupSelected(groups);

    // fridgeExpiryItemsProvider는 storagesWithItemsProvider를 watch하므로
    // 냉장고 데이터 변경 즉시 자동 반영된다.
    final itemsAsync = ref.watch(fridgeExpiryItemsProvider);
    final hasFilter = _selectedGroupId != null;

    return itemsAsync.when(
      loading: () => DashboardCard(
        title: AppLocalizations.of(context)!.widgetSettings_fridgeSummary,
        icon: Icons.warning_amber_outlined,
        onTap: () {},
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(AppSizes.spaceM),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      error: (_, _) => _buildCard(context, groups, [], hasFilter),
      data: (items) => _buildCard(context, groups, items, hasFilter),
    );
  }

  Widget _buildCard(
    BuildContext context,
    List<Group> groups,
    List<FridgeItemModel> items,
    bool hasFilter,
  ) {
    return DashboardCard(
      title: AppLocalizations.of(context)!.widgetSettings_fridgeSummary,
      icon: Icons.warning_amber_outlined,
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
          IconButton(
            onPressed: () => context.push(AppRoutes.fridge),
            icon: const Icon(Icons.arrow_forward, size: AppSizes.iconMedium),
          ),
        ],
      ),
      onTap: () => context.push(AppRoutes.fridge),
      child: items.isEmpty
          ? _buildEmpty(context)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items.take(5).map((item) => _ExpiryItemRow(item: item)).toList(),
            ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceM),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline,
              color: Theme.of(context).colorScheme.primary, size: 20),
          const SizedBox(width: AppSizes.spaceS),
          Text(
            AppLocalizations.of(context)!.widgetSettings_fridgeExpiryEmpty,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}

// ── 항목 행 ────────────────────────────────────────────────────────────────────

class _ExpiryItemRow extends StatelessWidget {
  final FridgeItemModel item;
  const _ExpiryItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final days = item.daysUntilExpiry;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    Color chipColor;
    String label;
    if (days == null) {
      chipColor = colorScheme.outline;
      label = '기한 없음';
    } else if (days < 0) {
      chipColor = colorScheme.error;
      label = '${days.abs()}일 초과';
    } else if (days == 0) {
      chipColor = colorScheme.error;
      label = '오늘 만료';
    } else {
      chipColor = days <= 3 ? colorScheme.error : colorScheme.tertiary;
      label = 'D-$days';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: chipColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: AppSizes.spaceS),
          Expanded(
            child: Text(
              item.name,
              style: textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: AppSizes.spaceS),
          if (item.quantity > 0) ...[
            Text(
              '${item.quantity}${item.unit ?? ''}',
              style: textTheme.bodySmall?.copyWith(color: colorScheme.outline),
            ),
            const SizedBox(width: AppSizes.spaceS),
          ],
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: chipColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              label,
              style: textTheme.labelSmall?.copyWith(
                color: chipColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── 그룹 선택 바텀시트 ──────────────────────────────────────────────────────────

class _GroupPickerSheet extends StatelessWidget {
  final List<Group> groups;
  final String? selectedGroupId;
  final void Function(String) onSelect;

  const _GroupPickerSheet({
    required this.groups,
    required this.selectedGroupId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: AppSizes.spaceM),
          Text('그룹 선택', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSizes.spaceS),
          RadioGroup<String>(
            groupValue: selectedGroupId ?? '',
            onChanged: (v) {
              if (v != null) onSelect(v);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: groups
                  .map((g) => RadioListTile<String>(
                        value: g.id,
                        title: Text(g.name),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: AppSizes.spaceM),
        ],
      ),
    );
  }
}
