import 'package:flutter/material.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/models/dashboard_widget_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// 홈 위젯 설정 화면
class HomeWidgetSettingsScreen extends StatefulWidget {
  const HomeWidgetSettingsScreen({super.key});

  @override
  State<HomeWidgetSettingsScreen> createState() => _HomeWidgetSettingsScreenState();
}

class _HomeWidgetSettingsScreenState extends State<HomeWidgetSettingsScreen> {
  late DashboardWidgetSettings _settings;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  /// 설정 불러오기
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = prefs.getString('dashboard_widget_settings');

    setState(() {
      if (settingsJson != null) {
        _settings = DashboardWidgetSettings.fromJson(
          json.decode(settingsJson) as Map<String, dynamic>,
        );
      } else {
        _settings = DashboardWidgetSettings.defaultSettings();
      }
      _isLoading = false;
    });
  }

  /// 설정 저장
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'dashboard_widget_settings',
      json.encode(_settings.toJson()),
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('설정이 저장되었습니다'),
          duration: Duration(seconds: 2),
        ),
      );
    }
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
      }
    });
    _saveSettings();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('홈 위젯 설정'),
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
                      '홈 화면에 표시할 위젯을 선택하세요',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSizes.spaceL),

          // 위젯 목록
          _buildWidgetTile(
            icon: Icons.calendar_today,
            title: '오늘의 일정',
            description: '당일 일정을 표시합니다',
            value: _settings.showTodaySchedule,
            onChanged: (value) => _toggleWidget('todaySchedule', value),
          ),
          _buildWidgetTile(
            icon: Icons.trending_up,
            title: '투자 지표 요약',
            description: '코스피, 나스닥, 환율 정보를 표시합니다',
            value: _settings.showInvestmentSummary,
            onChanged: (value) => _toggleWidget('investmentSummary', value),
          ),
          _buildWidgetTile(
            icon: Icons.check_box,
            title: '오늘의 할일',
            description: '진행 중인 할일을 표시합니다',
            value: _settings.showTodoSummary,
            onChanged: (value) => _toggleWidget('todoSummary', value),
          ),
          _buildWidgetTile(
            icon: Icons.account_balance_wallet,
            title: '자산 현황',
            description: '총 자산과 수익률을 표시합니다',
            value: _settings.showAssetSummary,
            onChanged: (value) => _toggleWidget('assetSummary', value),
          ),

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
            label: const Text('모든 위젯 표시'),
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetTile({
    required IconData icon,
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.spaceM),
      child: SwitchListTile(
        secondary: Container(
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
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          description,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
