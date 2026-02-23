import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/features/main/task/providers/task_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/shared/widgets/app_search_bar.dart';

/// 캘린더 검색 바 위젯
///
/// AppSearchBar 공통 위젯을 사용하며,
/// calendarSearchQueryProvider / calendarSearchActiveProvider 연동
class CalendarSearchBar extends ConsumerWidget {
  const CalendarSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return AppSearchBar(
      hintText: l10n.schedule_searchHint,
      onSearch: (query) {
        ref.read(calendarSearchQueryProvider.notifier).state = query;
      },
      onClose: () {
        ref.read(calendarSearchQueryProvider.notifier).state = null;
        ref.read(calendarSearchActiveProvider.notifier).state = false;
      },
    );
  }
}
