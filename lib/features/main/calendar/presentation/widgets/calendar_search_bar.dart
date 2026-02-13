import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/task/providers/task_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 캘린더 검색 바 위젯
class CalendarSearchBar extends ConsumerStatefulWidget {
  const CalendarSearchBar({super.key});

  @override
  ConsumerState<CalendarSearchBar> createState() => _CalendarSearchBarState();
}

class _CalendarSearchBarState extends ConsumerState<CalendarSearchBar> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      ref.read(calendarSearchQueryProvider.notifier).state =
          value.trim().isEmpty ? null : value.trim();
    });
  }

  void _clearSearch() {
    _controller.clear();
    ref.read(calendarSearchQueryProvider.notifier).state = null;
    ref.read(calendarSearchActiveProvider.notifier).state = false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceM,
        vertical: AppSizes.spaceS,
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        decoration: InputDecoration(
          hintText: l10n.schedule_searchHint,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            icon: const Icon(Icons.close),
            onPressed: _clearSearch,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          ),
          filled: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spaceM,
            vertical: AppSizes.spaceS,
          ),
        ),
        onChanged: _onSearchChanged,
      ),
    );
  }
}
