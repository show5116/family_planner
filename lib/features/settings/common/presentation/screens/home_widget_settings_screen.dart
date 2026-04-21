import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/models/dashboard_widget_settings.dart';
import 'package:family_planner/core/providers/dashboard_widget_settings_provider.dart';
import 'package:family_planner/core/widgets/reorderable_widgets.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 홈 위젯 설정 화면
class HomeWidgetSettingsScreen extends ConsumerWidget {
  const HomeWidgetSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(dashboardWidgetSettingsProvider);
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

class _HomeWidgetSettingsBodyState extends ConsumerState<_HomeWidgetSettingsBody> {
  late DashboardWidgetSettings _settings;

  @override
  void initState() {
    super.initState();
    _settings = widget.settings;
  }

  @override
  void didUpdateWidget(_HomeWidgetSettingsBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.settings != widget.settings) {
      _settings = widget.settings;
    }
  }

  /// 설정 저장
  Future<void> _saveSettings() async {
    await ref.read(dashboardWidgetSettingsProvider.notifier).update(_settings);

    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.widgetSettings_saveSuccess),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  /// 일정 뷰 모드 변경
  void _changeScheduleViewMode(ScheduleViewMode mode) {
    setState(() {
      _settings = _settings.copyWith(scheduleViewMode: mode);
    });
    _saveSettings();
  }

  /// 할일 뷰 모드 변경
  void _changeTodoViewMode(ScheduleViewMode mode) {
    setState(() {
      _settings = _settings.copyWith(todoViewMode: mode);
    });
    _saveSettings();
  }

  /// 위젯 표시/숨김 토글
  void _toggleWidget(String widgetName, bool value) {
    setState(() {
      switch (widgetName) {
        case 'todaySchedule':
          _settings = _settings.copyWith(showTodaySchedule: value);
          break;
        case 'investmentSummary':
          _settings = _settings.copyWith(showInvestmentSummary: value);
          break;
        case 'todoSummary':
          _settings = _settings.copyWith(showTodoSummary: value);
          break;
        case 'assetSummary':
          _settings = _settings.copyWith(showAssetSummary: value);
          break;
        case 'memoSummary':
          _settings = _settings.copyWith(showMemoSummary: value);
          break;
        case 'weather':
          _settings = _settings.copyWith(showWeather: value);
          break;
      }
    });
    _saveSettings();
  }

  /// 위젯 순서 변경
  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      // 기존 리스트를 복사하여 가변 리스트로 만듦
      final newOrder = List<String>.from(_settings.widgetOrder);
      // 아이템을 제거하고 새 위치에 삽입
      final item = newOrder.removeAt(oldIndex);
      newOrder.insert(newIndex, item);
      // 새로운 순서로 설정 업데이트
      _settings = _settings.copyWith(widgetOrder: newOrder);
    });
    _saveSettings();
  }

  /// 위젯 정보 가져오기
  Map<String, dynamic> _getWidgetInfo(String widgetName, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    switch (widgetName) {
      case 'todaySchedule':
        return {
          'icon': Icons.calendar_today,
          'title': l10n.widgetSettings_todaySchedule,
          'description': l10n.widgetSettings_todayScheduleDesc,
          'enabled': _settings.showTodaySchedule,
        };
      case 'investmentSummary':
        return {
          'icon': Icons.trending_up,
          'title': l10n.widgetSettings_investmentSummary,
          'description': l10n.widgetSettings_investmentSummaryDesc,
          'enabled': _settings.showInvestmentSummary,
        };
      case 'todoSummary':
        return {
          'icon': Icons.check_box,
          'title': l10n.widgetSettings_todoSummary,
          'description': l10n.widgetSettings_todoSummaryDesc,
          'enabled': _settings.showTodoSummary,
        };
      case 'assetSummary':
        return {
          'icon': Icons.account_balance_wallet,
          'title': l10n.widgetSettings_assetSummary,
          'description': l10n.widgetSettings_assetSummaryDesc,
          'enabled': _settings.showAssetSummary,
        };
      case 'memoSummary':
        return {
          'icon': Icons.note_outlined,
          'title': l10n.widgetSettings_memoSummary,
          'description': l10n.widgetSettings_memoSummaryDesc,
          'enabled': _settings.showMemoSummary,
        };
      case 'weather':
        return {
          'icon': Icons.wb_sunny_outlined,
          'title': l10n.widgetSettings_weather,
          'description': l10n.widgetSettings_weatherDesc,
          'enabled': _settings.showWeather,
        };
      default:
        return {
          'icon': Icons.widgets,
          'title': 'Unknown',
          'description': '',
          'enabled': false,
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings_homeWidgets),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        children: [
          // 안내 텍스트
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.spaceM),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: AppSizes.spaceM),
                  Expanded(
                    child: Text(
                      l10n.widgetSettings_guide,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSizes.spaceL),

          // 위젯 순서 변경 섹션
          Text(
            l10n.widgetSettings_widgetOrder,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppSizes.spaceS),
          Text(
            l10n.widgetSettings_dragToReorder,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: AppSizes.spaceM),

          // 드래그 가능한 위젯 목록
          _buildReorderableWidgetList(),

          const SizedBox(height: AppSizes.spaceL),

          // 모두 표시 버튼
          OutlinedButton.icon(
            onPressed: () {
              setState(() {
                _settings = DashboardWidgetSettings.defaultSettings();
              });
              _saveSettings();
            },
            icon: const Icon(Icons.restore),
            label: Text(l10n.widgetSettings_restoreDefaults),
          ),
        ],
      ),
    );
  }

  /// 드래그 가능한 위젯 목록 빌드
  Widget _buildReorderableWidgetList() {
    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      buildDefaultDragHandles: false,
      itemCount: _settings.widgetOrder.length,
      onReorder: _onReorder,
      proxyDecorator: buildReorderableProxyDecorator,
      itemBuilder: (context, index) {
        final widgetName = _settings.widgetOrder[index];
        final widgetInfo = _getWidgetInfo(widgetName, context);

        return _buildReorderableWidgetTile(
          key: ValueKey(widgetName),
          index: index,
          widgetName: widgetName,
          icon: widgetInfo['icon'] as IconData,
          title: widgetInfo['title'] as String,
          description: widgetInfo['description'] as String,
          enabled: widgetInfo['enabled'] as bool,
        );
      },
    );
  }

  /// 드래그 가능한 위젯 타일 빌드
  Widget _buildReorderableWidgetTile({
    required Key key,
    required int index,
    required String widgetName,
    required IconData icon,
    required String title,
    required String description,
    required bool enabled,
  }) {
    final isSchedule = widgetName == 'todaySchedule';
    final isTodo = widgetName == 'todoSummary';

    return Card(
      key: key,
      margin: const EdgeInsets.only(bottom: AppSizes.spaceM),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spaceM,
          vertical: AppSizes.spaceS,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                // 드래그 핸들
                ReorderableDragStartListener(
                  index: index,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.grab,
                    child: Padding(
                      padding: const EdgeInsets.only(right: AppSizes.spaceM),
                      child: Icon(
                        Icons.drag_handle,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
                // 아이콘
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                  ),
                  child: Icon(
                    icon,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: AppSizes.spaceM),
                // 제목 및 설명
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSizes.spaceL),
                // Switch
                Switch(
                  value: enabled,
                  onChanged: (value) => _toggleWidget(widgetName, value),
                ),
              ],
            ),
            // 일정 위젯 전용: 기간 선택 SegmentedButton
            if (isSchedule && enabled) ...[
              const SizedBox(height: AppSizes.spaceS),
              SegmentedButton<ScheduleViewMode>(
                segments: const [
                  ButtonSegment(value: ScheduleViewMode.today, label: Text('오늘')),
                  ButtonSegment(value: ScheduleViewMode.week, label: Text('금주')),
                  ButtonSegment(value: ScheduleViewMode.month, label: Text('이번달')),
                ],
                selected: {_settings.scheduleViewMode},
                onSelectionChanged: (selected) =>
                    _changeScheduleViewMode(selected.first),
              ),
            ],
            // 할일 위젯 전용: 기간 선택 SegmentedButton
            if (isTodo && enabled) ...[
              const SizedBox(height: AppSizes.spaceS),
              SegmentedButton<ScheduleViewMode>(
                segments: const [
                  ButtonSegment(value: ScheduleViewMode.today, label: Text('오늘')),
                  ButtonSegment(value: ScheduleViewMode.week, label: Text('금주')),
                  ButtonSegment(value: ScheduleViewMode.month, label: Text('이번달')),
                ],
                selected: {_settings.todoViewMode},
                onSelectionChanged: (selected) =>
                    _changeTodoViewMode(selected.first),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
