import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/routine/data/models/routine_model.dart';
import 'package:family_planner/features/main/routine/data/repositories/routine_repository.dart';
import 'package:family_planner/features/main/routine/providers/routine_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/shared/widgets/app_error_state.dart';

/// 일일 목표 설정 화면.
///
/// "그날 대상 습관을 전부 체크해야 달성"(ALL)이 기본이지만, 습관이 많은
/// 사용자는 매일 전부를 채우기 어려워 늘 미달성으로 표시된다. 이 화면에서
/// "하루 N개"를 정하면 그 개수만 채워도 그날은 달성으로 잡힌다.
///
/// 목표는 **개수**로 저장한다(비율 아님). 습관을 더 추가해도 목표가 따라
/// 오르지 않아야, 새 습관을 만드는 것이 곧 목표 상향으로 느껴지지 않는다.
class RoutineDailyGoalScreen extends ConsumerStatefulWidget {
  const RoutineDailyGoalScreen({super.key});

  @override
  ConsumerState<RoutineDailyGoalScreen> createState() =>
      _RoutineDailyGoalScreenState();
}

class _RoutineDailyGoalScreenState
    extends ConsumerState<RoutineDailyGoalScreen> {
  /// 화면에서 편집 중인 값. 서버 설정을 처음 읽어올 때 한 번만 초기화하고,
  /// 이후에는 사용자 입력만 반영한다.
  RoutineDailyGoalMode? _mode;
  int? _count;
  bool _saving = false;

  /// 슬라이더 상한. 습관이 늘어날 것을 감안해 현재 습관 수보다 여유를 두되,
  /// 습관이 없을 때도 최소한의 조작 범위를 준다.
  static int _sliderMax(int totalRoutines) =>
      totalRoutines > 0 ? totalRoutines : 10;

  void _initFrom(RoutineSettings settings, int totalRoutines) {
    if (_mode != null) return;
    _mode = settings.dailyGoalMode;
    // COUNT로 전환할 때 기본값은 전체의 80% — 처음부터 100%를 요구하면
    // 부담스럽고, 너무 낮으면 목표로서 의미가 없다.
    _count =
        settings.dailyGoalCount ??
        (totalRoutines > 0 ? (totalRoutines * 0.8).round().clamp(1, 999) : 1);
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _saving = true);
    final result = await ref
        .read(routineManagementProvider.notifier)
        .updateSettings(
          UpdateRoutineSettingsDto(
            dailyGoalMode: _mode,
            // ALL로 바꿀 때도 개수를 함께 보내두면, 나중에 COUNT로 되돌릴 때
            // 직전 목표가 그대로 복원된다.
            dailyGoalCount: _count,
          ),
        );
    if (!mounted) return;
    setState(() => _saving = false);

    if (result == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.routine_error_generic)));
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.routine_daily_goal_saved)));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settingsAsync = ref.watch(routineSettingsProvider);
    // 슬라이더 상한과 안내 문구를 위해 현재 습관 수가 필요하다. 목록이 아직
    // 로딩 중이면 0으로 두고, 로딩이 끝나면 자연스럽게 반영된다.
    final totalRoutines =
        ref.watch(routineListProvider(null)).valueOrNull?.length ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.routine_daily_goal_title),
        actions: [
          TextButton(
            onPressed: _saving || _mode == null ? null : _save,
            child: _saving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(MaterialLocalizations.of(context).saveButtonLabel),
          ),
        ],
      ),
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => AppErrorState(
          error: error,
          title: l10n.routine_error_generic,
          onRetry: () => ref.invalidate(routineSettingsProvider),
        ),
        data: (settings) {
          _initFrom(settings, totalRoutines);
          return _buildForm(context, l10n, totalRoutines);
        },
      ),
    );
  }

  Widget _buildForm(
    BuildContext context,
    AppLocalizations l10n,
    int totalRoutines,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final isCount = _mode == RoutineDailyGoalMode.count;
    final sliderMax = _sliderMax(totalRoutines);
    final count = (_count ?? 1).clamp(1, sliderMax);

    return ListView(
      padding: const EdgeInsets.all(AppSizes.spaceM),
      children: [
        RadioGroup<RoutineDailyGoalMode>(
          groupValue: _mode,
          onChanged: (value) => setState(() => _mode = value),
          child: Column(
            children: [
              Card(
                child: RadioListTile<RoutineDailyGoalMode>(
                  value: RoutineDailyGoalMode.all,
                  title: Text(l10n.routine_daily_goal_mode_all),
                  subtitle: Text(l10n.routine_daily_goal_mode_all_desc),
                ),
              ),
              const SizedBox(height: AppSizes.spaceS),
              Card(
                child: RadioListTile<RoutineDailyGoalMode>(
                  value: RoutineDailyGoalMode.count,
                  title: Text(l10n.routine_daily_goal_mode_count),
                  subtitle: Text(l10n.routine_daily_goal_mode_count_desc),
                ),
              ),
            ],
          ),
        ),
        if (isCount) ...[
          const SizedBox(height: AppSizes.spaceM),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.spaceM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      l10n.routine_daily_goal_count_label(totalRoutines, count),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.spaceS),
                  Slider(
                    value: count.toDouble(),
                    min: 1,
                    max: sliderMax.toDouble(),
                    // 1개 단위로만 움직이게 해서 "몇 개"가 명확히 보이도록.
                    divisions: sliderMax > 1 ? sliderMax - 1 : null,
                    label: '$count',
                    onChanged: (value) =>
                        setState(() => _count = value.round()),
                  ),
                  Center(
                    child: Text(
                      l10n.routine_daily_goal_encourage(count),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (totalRoutines > 0 && count > totalRoutines) ...[
                    const SizedBox(height: AppSizes.spaceS),
                    Text(
                      l10n.routine_daily_goal_exceeds_total,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: colorScheme.error),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
