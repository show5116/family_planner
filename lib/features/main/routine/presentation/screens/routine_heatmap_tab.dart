import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/routine/data/models/routine_model.dart';
import 'package:family_planner/features/main/routine/presentation/widgets/routine_heatmap_calendar.dart';
import 'package:family_planner/features/main/routine/providers/routine_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 루틴 상세 - 히트맵(달력) 탭
class RoutineHeatmapTab extends ConsumerStatefulWidget {
  const RoutineHeatmapTab({super.key, required this.routine});

  final Routine routine;

  @override
  ConsumerState<RoutineHeatmapTab> createState() => _RoutineHeatmapTabState();
}

class _RoutineHeatmapTabState extends ConsumerState<RoutineHeatmapTab> {
  late DateTime _from;
  late DateTime _to;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _setRangeForMonth(DateTime(now.year, now.month));
  }

  void _setRangeForMonth(DateTime month) {
    _from = DateTime(month.year, month.month, 1);
    _to = DateTime(month.year, month.month + 1, 0);
  }

  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Color? _accentColor() {
    if (widget.routine.color == null) return null;
    try {
      final hex = widget.routine.color!.replaceFirst('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final heatmapAsync = ref.watch(
      routineHeatmapProvider(
        widget.routine.id,
        fromDate: _fmt(_from),
        toDate: _fmt(_to),
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(AppSizes.spaceM),
      child: heatmapAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(l10n.routine_error_generic)),
        data: (heatmap) {
          final checkedDates = heatmap.checkedDates
              .map((s) => DateTime.parse(s))
              .toSet();
          return RoutineHeatmapCalendar(
            checkedDates: checkedDates,
            accentColor: _accentColor(),
            onMonthChanged: (month) {
              setState(() => _setRangeForMonth(month));
            },
          );
        },
      ),
    );
  }
}
