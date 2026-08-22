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
///
/// 또한 습관마다 집계 포함 여부를 정할 수 있다. 주 N회/월 N회 습관은 매일
/// 수행 대상이 아니라 기본 제외되며, 사용자가 원하면 켤 수 있다.
class RoutineDailyGoalScreen extends ConsumerStatefulWidget {
  const RoutineDailyGoalScreen({super.key});

  @override
  ConsumerState<RoutineDailyGoalScreen> createState() =>
      _RoutineDailyGoalScreenState();
}

class _RoutineDailyGoalScreenState
    extends ConsumerState<RoutineDailyGoalScreen> {
  /// 화면에서 편집 중인 목표 개수. 서버 설정을 처음 읽어올 때 한 번만
  /// 초기화하고, 이후에는 사용자 입력만 반영한다.
  ///
  /// 서버에는 ALL/COUNT 두 모드가 있지만 화면에서는 노출하지 않는다.
  /// 목표를 포함 습관 수와 같게 두면 ALL과 결과가 같아서, 모드 선택은
  /// 불필요한 선택지만 늘릴 뿐이다. 항상 COUNT로 저장한다.
  int? _count;
  bool _initialized = false;
  bool _saving = false;

  /// 습관별 포함 여부의 편집 중 상태(routineId → 포함). 서버 목록을 처음
  /// 읽을 때 초기화하고, 저장 시 원본과 비교해 바뀐 것만 전송한다.
  Map<String, bool>? _inclusions;
  Map<String, bool> _originalInclusions = const {};

  void _initFrom(RoutineSettings settings, List<Routine> routines) {
    if (_inclusions == null && routines.isNotEmpty) {
      _originalInclusions = {
        for (final r in routines) r.id: r.includeInDailyGoal,
      };
      _inclusions = Map.of(_originalInclusions);
    }
    if (_initialized) return;
    // 습관 목록이 아직 안 왔으면 기본값 계산이 어긋나므로 초기화를 미룬다.
    if (routines.isEmpty && _inclusions == null) return;
    _initialized = true;
    // ALL 모드로 저장돼 있던 사용자는 "전부 하기"가 목표였던 셈이므로,
    // 포함 습관 수를 그대로 목표로 잡아 기존 의도를 유지한다.
    _count = settings.isCountMode
        ? settings.dailyGoalCount
        : (_includedCount > 0 ? _includedCount : null);
  }

  int get _includedCount => _inclusions?.values.where((v) => v).length ?? 0;

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _saving = true);

    final notifier = ref.read(routineManagementProvider.notifier);

    // 포함 여부가 바뀐 습관만 골라 일괄 전송한다.
    final changed = <DailyGoalInclusionItemDto>[];
    final current = _inclusions ?? const {};
    for (final entry in current.entries) {
      if (_originalInclusions[entry.key] != entry.value) {
        changed.add(
          DailyGoalInclusionItemDto(
            id: entry.key,
            includeInDailyGoal: entry.value,
          ),
        );
      }
    }

    if (changed.isNotEmpty) {
      final ok = await notifier.updateDailyGoalInclusions(changed);
      if (!mounted) return;
      if (!ok) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.routine_error_generic)));
        return;
      }
    }

    final result = await notifier.updateSettings(
      UpdateRoutineSettingsDto(
        // 화면에 모드 선택이 없으므로 항상 COUNT로 저장한다.
        dailyGoalMode: RoutineDailyGoalMode.count,
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
    final routinesAsync = ref.watch(routineListProvider(null));

    // 앱바 액션 버튼은 앱바 전경색을 따라야 한다. TextButton의 기본
    // foregroundColor는 primary인데 라이트 모드 앱바 배경도 primary라서
    // 그대로 두면 파란 배경에 파란 글씨가 되어 보이지 않는다.
    final appBarForeground =
        Theme.of(context).appBarTheme.foregroundColor ??
        Theme.of(context).colorScheme.onPrimary;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.routine_daily_goal_title),
        actions: [
          TextButton(
            onPressed: _saving || !_initialized ? null : _save,
            style: TextButton.styleFrom(foregroundColor: appBarForeground),
            child: _saving
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: appBarForeground,
                    ),
                  )
                : Text(MaterialLocalizations.of(context).saveButtonLabel),
          ),
          const SizedBox(width: AppSizes.spaceS),
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
          final routines = routinesAsync.valueOrNull ?? const <Routine>[];
          _initFrom(settings, routines);
          return _buildForm(context, l10n, routines);
        },
      ),
    );
  }

  Widget _buildForm(
    BuildContext context,
    AppLocalizations l10n,
    List<Routine> routines,
  ) {
    final included = _includedCount;

    return ListView(
      padding: const EdgeInsets.all(AppSizes.spaceM),
      children: [
        _GoalCountCard(
          included: included,
          count: _count ?? included,
          onChanged: (value) => setState(() => _count = value),
        ),
        const SizedBox(height: AppSizes.spaceL),
        _InclusionSection(
          routines: routines,
          inclusions: _inclusions ?? const {},
          includedCount: included,
          onToggle: (routineId, value) => setState(() {
            final map = Map.of(_inclusions ?? const <String, bool>{});
            map[routineId] = value;
            _inclusions = map;
            // 포함 습관이 줄어 목표가 달성 불가능해지면 목표도 함께 낮춘다.
            final newIncluded = map.values.where((v) => v).length;
            if (_count != null && newIncluded > 0 && _count! > newIncluded) {
              _count = newIncluded;
            }
          }),
        ),
      ],
    );
  }
}

/// 목표 개수 슬라이더. 상한은 집계에 포함된 습관 수다 — 포함 습관보다 큰
/// 목표는 영원히 달성할 수 없기 때문이다.
class _GoalCountCard extends StatelessWidget {
  const _GoalCountCard({
    required this.included,
    required this.count,
    required this.onChanged,
  });

  final int included;
  final int count;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    if (included <= 0) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          child: Text(
            l10n.routine_daily_goal_no_included,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: colorScheme.error),
          ),
        ),
      );
    }

    final safeCount = count.clamp(1, included);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                l10n.routine_daily_goal_count_label(included, safeCount),
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: AppSizes.spaceS),
            Slider(
              value: safeCount.toDouble(),
              min: 1,
              max: included.toDouble(),
              // 1개 단위로만 움직이게 해서 "몇 개"가 명확히 보이도록.
              divisions: included > 1 ? included - 1 : null,
              label: '$safeCount',
              onChanged: (value) => onChanged(value.round()),
            ),
            Center(
              child: Text(
                l10n.routine_daily_goal_encourage(safeCount),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 집계 대상 습관 선택 섹션.
///
/// 매일 하는 습관과 주기적으로 하는 습관을 나눠서 보여준다. 사용자가 판단해야
/// 하는 건 주로 후자(주 N회/월 N회)라, 그쪽에 트레이드오프 안내를 붙인다.
class _InclusionSection extends StatelessWidget {
  const _InclusionSection({
    required this.routines,
    required this.inclusions,
    required this.includedCount,
    required this.onToggle,
  });

  final List<Routine> routines;
  final Map<String, bool> inclusions;
  final int includedCount;
  final void Function(String routineId, bool value) onToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    if (routines.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Center(
          child: Text(
            l10n.routine_daily_goal_no_routines,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    final daily = routines
        .where((r) => r.frequencyType == RoutineFrequencyType.daily)
        .toList();
    final periodic = routines
        .where((r) => r.frequencyType != RoutineFrequencyType.daily)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceXS),
          child: Text(
            l10n.routine_daily_goal_included_section,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const SizedBox(height: AppSizes.spaceXS),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceXS),
          child: Text(
            l10n.routine_daily_goal_included_summary(includedCount),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(height: AppSizes.spaceS),
        if (periodic.isNotEmpty) ...[
          _InclusionGroup(
            title: l10n.routine_daily_goal_group_periodic,
            hint: l10n.routine_daily_goal_periodic_hint,
            routines: periodic,
            inclusions: inclusions,
            onToggle: onToggle,
          ),
          const SizedBox(height: AppSizes.spaceM),
        ],
        if (daily.isNotEmpty)
          _InclusionGroup(
            title: l10n.routine_daily_goal_group_daily,
            routines: daily,
            inclusions: inclusions,
            onToggle: onToggle,
          ),
      ],
    );
  }
}

class _InclusionGroup extends StatelessWidget {
  const _InclusionGroup({
    required this.title,
    this.hint,
    required this.routines,
    required this.inclusions,
    required this.onToggle,
  });

  final String title;
  final String? hint;
  final List<Routine> routines;
  final Map<String, bool> inclusions;
  final void Function(String routineId, bool value) onToggle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceS),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.spaceM,
                AppSizes.spaceXS,
                AppSizes.spaceM,
                0,
              ),
              child: Text(title, style: Theme.of(context).textTheme.labelLarge),
            ),
            if (hint != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.spaceM,
                  AppSizes.spaceXS,
                  AppSizes.spaceM,
                  AppSizes.spaceXS,
                ),
                child: Text(
                  hint!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            for (final routine in routines)
              SwitchListTile(
                value: inclusions[routine.id] ?? routine.includeInDailyGoal,
                onChanged: (value) => onToggle(routine.id, value),
                title: Row(
                  children: [
                    if (routine.emoji != null && routine.emoji!.isNotEmpty) ...[
                      Text(
                        routine.emoji!,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: AppSizes.spaceXS),
                    ],
                    Expanded(
                      child: Text(
                        routine.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                subtitle: Text(_frequencyLabel(context, routine)),
                dense: true,
              ),
          ],
        ),
      ),
    );
  }

  /// "매일" / "주 3회" / "월·수·금" / "월 2회" 형태의 주기 설명.
  static String _frequencyLabel(BuildContext context, Routine routine) {
    final l10n = AppLocalizations.of(context)!;
    switch (routine.frequencyType) {
      case RoutineFrequencyType.daily:
        return l10n.routine_daily_goal_freq_daily;
      case RoutineFrequencyType.monthly:
        return l10n.routine_daily_goal_freq_monthly_count(
          routine.targetCount ?? 0,
        );
      case RoutineFrequencyType.weekly:
        if (routine.weeklyMode == RoutineWeeklyMode.fixedDays) {
          final days = routine.targetDays ?? const [];
          if (days.isNotEmpty) {
            final labels = [
              l10n.routine_day_sun,
              l10n.routine_day_mon,
              l10n.routine_day_tue,
              l10n.routine_day_wed,
              l10n.routine_day_thu,
              l10n.routine_day_fri,
              l10n.routine_day_sat,
            ];
            final sorted = [...days]..sort();
            return sorted
                .where((d) => d >= 0 && d < labels.length)
                .map((d) => labels[d])
                .join('·');
          }
        }
        return l10n.routine_daily_goal_freq_weekly_count(
          routine.targetCount ?? 0,
        );
    }
  }
}
