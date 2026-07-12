import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/models/dashboard_widget_settings.dart';
import 'package:family_planner/core/providers/dashboard_widget_settings_provider.dart';
import 'package:family_planner/core/widgets/reorderable_widgets.dart';
import 'package:family_planner/features/main/task/providers/anniversary_provider.dart';
import 'package:family_planner/features/settings/groups/models/group.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 홈 위젯 설정 화면
class HomeWidgetSettingsScreen extends ConsumerWidget {
  const HomeWidgetSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(dashboardWidgetSettingsProvider).valueOrNull;
    if (settings == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return _HomeWidgetSettingsBody(settings: settings);
  }
}

class _HomeWidgetSettingsBody extends ConsumerStatefulWidget {
  const _HomeWidgetSettingsBody({required this.settings});
  final DashboardWidgetSettings settings;

  @override
  ConsumerState<_HomeWidgetSettingsBody> createState() =>
      _HomeWidgetSettingsBodyState();
}

class _HomeWidgetSettingsBodyState
    extends ConsumerState<_HomeWidgetSettingsBody> {
  late List<String> _order;

  @override
  void initState() {
    super.initState();
    _order = List<String>.from(widget.settings.widgetOrder);
  }

  @override
  void didUpdateWidget(_HomeWidgetSettingsBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 저장 후 provider가 업데이트되면 didUpdateWidget이 호출되는데,
    // 이미 로컬 _order가 최신이므로 덮어쓰지 않습니다.
    // 외부(다른 화면)에서 settings가 바뀐 경우만 초기화가 필요하지만
    // 이 화면은 단독으로 열리므로 무시합니다.
  }

  Future<void> _saveOrder() async {
    final notifier = ref.read(dashboardWidgetSettingsProvider.notifier);
    final current = ref.read(dashboardWidgetSettingsProvider).valueOrNull;
    if (current == null) return;
    final updated = current.copyWith(widgetOrder: _order);
    await notifier.save(updated);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.widgetSettings_saveSuccess),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _saveAnniversaryIds(List<String> ids) async {
    final notifier = ref.read(dashboardWidgetSettingsProvider.notifier);
    final current = ref.read(dashboardWidgetSettingsProvider).valueOrNull;
    if (current == null) return;
    final updated = current.copyWith(
      widgetOrder: _order,
      anniversaryIds: ids,
    );
    await notifier.save(updated);
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      final item = _order.removeAt(oldIndex);
      _order.insert(newIndex, item);
    });
    _saveOrder();
  }

  void _removeWidget(String key) {
    setState(() => _order.remove(key));
    _saveOrder();
  }

  void _addWidget(String key) {
    Navigator.pop(context);
    setState(() => _order.add(key));
    _saveOrder();
  }

  Future<void> _showAddSheet() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusMedium),
        ),
      ),
      builder: (ctx) => _AddWidgetSheet(
        currentOrder: _order,
        onAdd: _addWidget,
      ),
    );
  }

  static String _labelOf(String key, AppLocalizations l10n) {
    switch (key) {
      case 'weather':
        return l10n.widgetSettings_weather;
      case 'fridgeSummary':
        return l10n.widgetSettings_fridgeSummary;
      case 'todaySchedule':
        return l10n.widgetSettings_todaySchedule;
      case 'investmentSummary':
        return l10n.widgetSettings_investmentSummary;
      case 'todoSummary':
        return l10n.widgetSettings_todoSummary;
      case 'assetSummary':
        return l10n.widgetSettings_assetSummary;
      case 'memoSummary':
        return l10n.widgetSettings_memoSummary;
      case 'householdSummary':
        return l10n.widgetSettings_householdSummary;
      case 'childcareSummary':
        return l10n.widgetSettings_childcareSummary;
      case 'savingsSummary':
        return l10n.widgetSettings_savingsSummary;
      case 'anniversary':
        return '기념일';
      case 'routineSummary':
        return l10n.widgetSettings_routineSummary;
      default:
        return key;
    }
  }

  static IconData _iconOf(String key) {
    switch (key) {
      case 'weather':
        return Icons.wb_sunny_outlined;
      case 'fridgeSummary':
        return Icons.warning_amber_outlined;
      case 'todaySchedule':
        return Icons.calendar_today;
      case 'investmentSummary':
        return Icons.trending_up;
      case 'todoSummary':
        return Icons.check_box;
      case 'assetSummary':
        return Icons.account_balance_wallet;
      case 'memoSummary':
        return Icons.note_outlined;
      case 'householdSummary':
        return Icons.account_balance;
      case 'childcareSummary':
        return Icons.child_care;
      case 'savingsSummary':
        return Icons.savings;
      case 'anniversary':
        return Icons.celebration_outlined;
      case 'routineSummary':
        return Icons.check_circle_outline;
      default:
        return Icons.widgets_outlined;
    }
  }

  Widget _buildInfoHeader(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: AppSizes.spaceS),
              Expanded(
                child: Text(
                  '드래그해서 순서를 변경하고, X 버튼으로 위젯을 제거할 수 있습니다.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings_homeWidgets)),
      body: Column(
        children: [
          Expanded(
            child: _order.isEmpty
                ? Column(
                    children: [
                      _buildInfoHeader(context),
                      Expanded(
                        child: Center(
                          child: Text(
                            '표시 중인 위젯이 없습니다\n아래 버튼으로 위젯을 추가해보세요',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                          ),
                        ),
                      ),
                    ],
                  )
                : ReorderableListView.builder(
                    padding: EdgeInsets.only(
                      left: AppSizes.spaceM,
                      right: AppSizes.spaceM,
                      top: AppSizes.spaceS,
                      bottom: AppSizes.spaceM +
                          MediaQuery.paddingOf(context).bottom,
                    ),
                    buildDefaultDragHandles: false,
                    proxyDecorator: buildReorderableProxyDecorator,
                    itemCount: _order.length,
                    onReorderItem: _onReorder,
                    header: Column(
                      children: [
                        _buildInfoHeader(context),
                        const SizedBox(height: AppSizes.spaceM),
                      ],
                    ),
                    itemBuilder: (context, index) {
                      final key = _order[index];
                      // 기념일 위젯은 확장 카드로 표시
                      if (key == 'anniversary') {
                        return _AnniversaryWidgetCard(
                          key: const ValueKey('anniversary'),
                          index: index,
                          anniversaryIds: widget.settings.anniversaryIds,
                          onRemoveWidget: () => _removeWidget('anniversary'),
                          onAnniversaryIdsChanged: _saveAnniversaryIds,
                        );
                      }
                      return Card(
                        key: ValueKey(key),
                        margin:
                            const EdgeInsets.only(bottom: AppSizes.spaceM),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.spaceM,
                            vertical: AppSizes.spaceS,
                          ),
                          child: Row(
                            children: [
                              ReorderableDragStartListener(
                                index: index,
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.grab,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: AppSizes.spaceM),
                                    child: Icon(
                                      Icons.drag_handle,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  borderRadius: BorderRadius.circular(
                                      AppSizes.radiusSmall),
                                ),
                                child: Icon(
                                  _iconOf(key),
                                  color:
                                      Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: AppSizes.spaceM),
                              Expanded(
                                child: Text(
                                  _labelOf(key, l10n),
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close),
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                                onPressed: () => _removeWidget(key),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.spaceM,
                AppSizes.spaceS,
                AppSizes.spaceM,
                AppSizes.spaceM,
              ),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _showAddSheet,
                  icon: const Icon(Icons.add),
                  label: const Text('위젯 추가하기'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── 기념일 위젯 설정 카드 (인라인 기념일 관리) ────────────────────────────────

class _AnniversaryWidgetCard extends ConsumerStatefulWidget {
  const _AnniversaryWidgetCard({
    super.key,
    required this.index,
    required this.anniversaryIds,
    required this.onRemoveWidget,
    required this.onAnniversaryIdsChanged,
  });

  final int index;
  final List<String> anniversaryIds;
  final VoidCallback onRemoveWidget;
  final void Function(List<String> ids) onAnniversaryIdsChanged;

  @override
  ConsumerState<_AnniversaryWidgetCard> createState() =>
      _AnniversaryWidgetCardState();
}

class _AnniversaryWidgetCardState
    extends ConsumerState<_AnniversaryWidgetCard> {
  bool _showPicker = false;
  Group? _selectedGroup;

  void _removeAnniversary(String id) {
    final updated =
        widget.anniversaryIds.where((i) => i != id).toList();
    widget.onAnniversaryIdsChanged(updated);
  }

  void _addAnniversary(String id) {
    if (widget.anniversaryIds.contains(id)) return;
    final updated = [...widget.anniversaryIds, id];
    widget.onAnniversaryIdsChanged(updated);
    setState(() {
      _showPicker = false;
      _selectedGroup = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final allAsync = ref.watch(allGroupsAnniversariesProvider);
    final groups = ref.watch(myGroupsProvider).valueOrNull ?? [];

    return Card(
      key: const ValueKey('anniversary'),
      margin: const EdgeInsets.only(bottom: AppSizes.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더 행
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spaceM,
              vertical: AppSizes.spaceS,
            ),
            child: Row(
              children: [
                ReorderableDragStartListener(
                  index: widget.index,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.grab,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(right: AppSizes.spaceM),
                      child: Icon(
                        Icons.drag_handle,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius:
                        BorderRadius.circular(AppSizes.radiusSmall),
                  ),
                  child: Icon(
                    Icons.celebration_outlined,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: AppSizes.spaceM),
                Expanded(
                  child: Text(
                    '기념일',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  color: colorScheme.onSurfaceVariant,
                  onPressed: widget.onRemoveWidget,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // 선택된 기념일 목록
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.spaceM,
              AppSizes.spaceS,
              AppSizes.spaceM,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.anniversaryIds.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: AppSizes.spaceS),
                    child: Text(
                      '기념일을 추가해보세요',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                    ),
                  )
                else
                  ...widget.anniversaryIds.map((id) {
                    final ann = allAsync.valueOrNull
                        ?.where((a) => a.id == id)
                        .firstOrNull;
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Text(
                        ann?.emoji ?? '🎂',
                        style: const TextStyle(fontSize: 20),
                      ),
                      title: Text(
                        ann?.title ?? id,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        color: colorScheme.error,
                        onPressed: () => _removeAnniversary(id),
                      ),
                      visualDensity: VisualDensity.compact,
                    );
                  }),
                // 기념일 추가 피커 (인라인)
                if (_showPicker) ...[
                  const Divider(height: AppSizes.spaceM),
                  if (_selectedGroup == null)
                    _InlineGroupList(
                      groups: groups,
                      onSelect: (g) =>
                          setState(() => _selectedGroup = g),
                    )
                  else
                    _InlineAnniversaryList(
                      group: _selectedGroup!,
                      selectedIds: widget.anniversaryIds,
                      onAdd: _addAnniversary,
                      onBack: () =>
                          setState(() => _selectedGroup = null),
                    ),
                ],
                // 기념일 추가 버튼
                if (!_showPicker)
                  TextButton.icon(
                    onPressed: () =>
                        setState(() => _showPicker = true),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('기념일 추가'),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                const SizedBox(height: AppSizes.spaceS),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── 인라인 그룹 선택 ──────────────────────────────────────────────────────────

class _InlineGroupList extends StatelessWidget {
  const _InlineGroupList({
    required this.groups,
    required this.onSelect,
  });
  final List<Group> groups;
  final void Function(Group) onSelect;

  @override
  Widget build(BuildContext context) {
    if (groups.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceS),
        child: Text(
          '속한 그룹이 없습니다',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '그룹 선택',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        ...groups.map((g) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.group_outlined),
              title: Text(g.name),
              trailing: const Icon(Icons.chevron_right),
              visualDensity: VisualDensity.compact,
              onTap: () => onSelect(g),
            )),
      ],
    );
  }
}

// ── 인라인 기념일 선택 ────────────────────────────────────────────────────────

class _InlineAnniversaryList extends ConsumerWidget {
  const _InlineAnniversaryList({
    required this.group,
    required this.selectedIds,
    required this.onAdd,
    required this.onBack,
  });
  final Group group;
  final List<String> selectedIds;
  final void Function(String id) onAdd;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(anniversariesProvider(group.id));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            InkWell(
              onTap: onBack,
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              child: const Icon(Icons.arrow_back, size: 18),
            ),
            const SizedBox(width: AppSizes.spaceS),
            Text(
              group.name,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
        async.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(AppSizes.spaceM),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (_, _) => Text(
            '기념일을 불러오지 못했습니다',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          data: (anniversaries) {
            if (anniversaries.isEmpty) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: AppSizes.spaceS),
                child: Text(
                  '${group.name}에 기념일이 없습니다',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurfaceVariant,
                      ),
                ),
              );
            }
            return Column(
              children: anniversaries.map((a) {
                final alreadyAdded = selectedIds.contains(a.id);
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Text(
                    a.emoji ?? '🎂',
                    style: const TextStyle(fontSize: 20),
                  ),
                  title: Text(a.title),
                  subtitle: Text(
                    '${a.date.month}/${a.date.day} · D+${a.daysSince}',
                  ),
                  trailing: alreadyAdded
                      ? Text(
                          '추가됨',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                        )
                      : const Icon(Icons.add),
                  visualDensity: VisualDensity.compact,
                  onTap: alreadyAdded ? null : () => onAdd(a.id),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}

// ── 위젯 추가 바텀시트 ────────────────────────────────────────────────────────

class _AddWidgetSheet extends ConsumerWidget {
  const _AddWidgetSheet({
    required this.currentOrder,
    required this.onAdd,
  });
  final List<String> currentOrder;
  final void Function(String key) onAdd;

  static const _defs = [
    ('weather', Icons.wb_sunny_outlined, '날씨'),
    ('fridgeSummary', Icons.warning_amber_outlined, '냉장고 유통기한'),
    ('todaySchedule', Icons.calendar_today, '오늘 일정'),
    ('investmentSummary', Icons.trending_up, '투자 현황'),
    ('todoSummary', Icons.check_box, '할일'),
    ('assetSummary', Icons.account_balance_wallet, '자산'),
    ('memoSummary', Icons.note_outlined, '메모'),
    ('householdSummary', Icons.account_balance, '가계관리'),
    ('childcareSummary', Icons.child_care, '육아포인트'),
    ('savingsSummary', Icons.savings, '저금통'),
    ('anniversary', Icons.celebration_outlined, '기념일'),
    ('routineSummary', Icons.check_circle_outline, '루틴'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final available =
        _defs.where((d) => !currentOrder.contains(d.$1)).toList();

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.92,
      builder: (ctx, scrollController) => Column(
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
              AppSizes.spaceS,
              AppSizes.spaceS,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '위젯 추가하기',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: available.isEmpty
                ? Center(
                    child: Text(
                      '추가할 수 있는 위젯이 없습니다',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                    ),
                  )
                : ListView(
                    controller: scrollController,
                    children: available.map((def) {
                      final (key, icon, label) = def;
                      return ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primaryContainer,
                            borderRadius:
                                BorderRadius.circular(AppSizes.radiusSmall),
                          ),
                          child: Icon(
                            icon,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        title: Text(label),
                        trailing: const Icon(Icons.add),
                        onTap: () => onAdd(key),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
