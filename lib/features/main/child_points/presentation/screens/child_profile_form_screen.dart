import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/main/child_points/data/repositories/childcare_repository.dart';
import 'package:family_planner/features/main/child_points/providers/childcare_provider.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/shared/widgets/form_bottom_bar.dart';

/// 자녀 프로필 등록 화면 (앱 계정 없이 이름+생년월일만)
class ChildProfileFormScreen extends ConsumerStatefulWidget {
  const ChildProfileFormScreen({super.key, required this.groupId});

  final String groupId;

  @override
  ConsumerState<ChildProfileFormScreen> createState() =>
      _ChildProfileFormScreenState();
}

class _ChildProfileFormScreenState
    extends ConsumerState<ChildProfileFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  DateTime? _selectedBirthDate;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final groupName = ref
        .watch(myGroupsProvider)
        .whenOrNull(
          data: (groups) =>
              groups.where((g) => g.id == widget.groupId).firstOrNull?.name,
        );

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.childcare_profile_add),
            if (groupName != null)
              Text(
                groupName,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.white70),
              ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(AppSizes.spaceM),
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: l10n.childcare_child_name,
                        hintText: l10n.childcare_child_name_hint,
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (v) => v == null || v.trim().isEmpty
                          ? l10n.childcare_child_name_required
                          : null,
                    ),
                    const SizedBox(height: AppSizes.spaceM),
                    InkWell(
                      onTap: _selectBirthDate,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: l10n.childcare_birthdate,
                          prefixIcon: Icon(Icons.cake),
                        ),
                        child: Text(
                          _selectedBirthDate != null
                              ? DateFormat(
                                  'yyyy-MM-dd',
                                ).format(_selectedBirthDate!)
                              : l10n.childcare_select_date,
                          style: _selectedBirthDate != null
                              ? Theme.of(context).textTheme.bodyMedium
                              : Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).hintColor,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            FormBottomBar(
              label: l10n.childcare_profile_add,
              isLoading: _isSubmitting,
              onPressed: _handleSubmit,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectBirthDate() async {
    FocusScope.of(context).unfocus();
    final initial = _selectedBirthDate ?? DateTime(2015);
    final picked = await showModalBottomSheet<DateTime>(
      context: context,
      builder: (_) => _BirthDatePicker(initial: initial),
    );
    if (picked != null) {
      setState(() => _selectedBirthDate = picked);
    }
  }

  Future<void> _handleSubmit() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;
    if (_selectedBirthDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.childcare_birthdate_required)));
      return;
    }

    setState(() => _isSubmitting = true);

    final dto = CreateChildProfileDto(
      groupId: widget.groupId,
      name: _nameController.text.trim(),
      birthDate: DateFormat('yyyy-MM-dd').format(_selectedBirthDate!),
    );

    final result = await ref
        .read(childcareManagementProvider.notifier)
        .createChild(dto);

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (result != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.childcare_profile_added)));
      context.pop(result);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.childcare_profile_add_failed)));
    }
  }
}

// ── 생년월일 드럼 롤 Picker ────────────────────────────────────────────────────

class _BirthDatePicker extends StatefulWidget {
  const _BirthDatePicker({required this.initial});

  final DateTime initial;

  @override
  State<_BirthDatePicker> createState() => _BirthDatePickerState();
}

class _BirthDatePickerState extends State<_BirthDatePicker> {
  static const int _firstYear = 2000;
  static final int _lastYear = DateTime.now().year;

  late int _year;
  late int _month;
  late int _day;

  late FixedExtentScrollController _yearCtrl;
  late FixedExtentScrollController _monthCtrl;
  late FixedExtentScrollController _dayCtrl;

  @override
  void initState() {
    super.initState();
    _year = widget.initial.year.clamp(_firstYear, _lastYear);
    _month = widget.initial.month;
    _day = widget.initial.day.clamp(1, _daysInMonth(_year, _month));

    _yearCtrl = FixedExtentScrollController(initialItem: _year - _firstYear);
    _monthCtrl = FixedExtentScrollController(initialItem: _month - 1);
    _dayCtrl = FixedExtentScrollController(initialItem: _day - 1);
  }

  @override
  void dispose() {
    _yearCtrl.dispose();
    _monthCtrl.dispose();
    _dayCtrl.dispose();
    super.dispose();
  }

  int _daysInMonth(int year, int month) => DateTime(year, month + 1, 0).day;

  void _onYearChanged(int index) {
    final newYear = _firstYear + index;
    final maxDay = _daysInMonth(newYear, _month);
    setState(() {
      _year = newYear;
      if (_day > maxDay) {
        _day = maxDay;
        _dayCtrl.jumpToItem(_day - 1);
      }
    });
  }

  void _onMonthChanged(int index) {
    final newMonth = index + 1;
    final maxDay = _daysInMonth(_year, newMonth);
    setState(() {
      _month = newMonth;
      if (_day > maxDay) {
        _day = maxDay;
        _dayCtrl.jumpToItem(_day - 1);
      }
    });
  }

  void _onDayChanged(int index) {
    setState(() => _day = index + 1);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final maxDay = _daysInMonth(_year, _month);

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 헤더
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spaceM,
              vertical: AppSizes.spaceS,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.common_cancel),
                ),
                Text(
                  l10n.childcare_date_full('$_year', '$_month', '$_day'),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).pop(DateTime(_year, _month, _day)),
                  child: Text(l10n.common_confirm),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // 드럼 롤
          SizedBox(
            height: 200,
            child: Row(
              children: [
                // 년도
                Expanded(
                  flex: 3,
                  child: _buildPicker(
                    controller: _yearCtrl,
                    itemCount: _lastYear - _firstYear + 1,
                    selectedIndex: _year - _firstYear,
                    onSelectedItemChanged: _onYearChanged,
                    labelBuilder: (i) =>
                        l10n.childcare_year_unit('${_firstYear + i}'),
                    selectedColor: colorScheme.primary,
                  ),
                ),
                // 월
                Expanded(
                  flex: 2,
                  child: _buildPicker(
                    controller: _monthCtrl,
                    itemCount: 12,
                    selectedIndex: _month - 1,
                    onSelectedItemChanged: _onMonthChanged,
                    labelBuilder: (i) => l10n.childcare_month_unit('${i + 1}'),
                    selectedColor: colorScheme.primary,
                  ),
                ),
                // 일
                Expanded(
                  flex: 2,
                  child: _buildPicker(
                    controller: _dayCtrl,
                    itemCount: maxDay,
                    selectedIndex: _day - 1,
                    onSelectedItemChanged: _onDayChanged,
                    labelBuilder: (i) => l10n.childcare_day_value('${i + 1}'),
                    selectedColor: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPicker({
    required FixedExtentScrollController controller,
    required int itemCount,
    required int selectedIndex,
    required void Function(int) onSelectedItemChanged,
    required String Function(int) labelBuilder,
    required Color selectedColor,
  }) {
    return ListWheelScrollView.useDelegate(
      controller: controller,
      itemExtent: 44,
      diameterRatio: 1.4,
      physics: const FixedExtentScrollPhysics(),
      onSelectedItemChanged: onSelectedItemChanged,
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: itemCount,
        builder: (context, index) {
          final isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: isSelected
                ? null
                : () => controller.animateToItem(
                    index,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                  ),
            child: Center(
              child: Text(
                labelBuilder(index),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isSelected ? selectedColor : null,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
