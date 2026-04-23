import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/child_points/data/repositories/childcare_repository.dart';
import 'package:family_planner/features/main/child_points/providers/childcare_provider.dart';

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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('자녀 프로필 등록'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSizes.spaceM),
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: '자녀 이름',
                  hintText: '예: 김민준',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? '자녀 이름을 입력해주세요' : null,
              ),
              const SizedBox(height: AppSizes.spaceM),
              InkWell(
                onTap: _selectBirthDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: '생년월일',
                    prefixIcon: Icon(Icons.cake),
                  ),
                  child: Text(
                    _selectedBirthDate != null
                        ? DateFormat('yyyy-MM-dd').format(_selectedBirthDate!)
                        : '날짜를 선택하세요',
                    style: _selectedBirthDate != null
                        ? Theme.of(context).textTheme.bodyMedium
                        : Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Theme.of(context).hintColor),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.spaceXL),
              FilledButton(
                onPressed: _isSubmitting ? null : _handleSubmit,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('자녀 프로필 등록'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectBirthDate() async {
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
    if (!_formKey.currentState!.validate()) return;
    if (_selectedBirthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('생년월일을 선택해주세요')),
      );
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('자녀 프로필이 등록되었습니다')),
      );
      context.pop(result);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('등록에 실패했습니다. 다시 시도해주세요')),
      );
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

  int _daysInMonth(int year, int month) =>
      DateTime(year, month + 1, 0).day;

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
                  child: const Text('취소'),
                ),
                Text(
                  '$_year년 $_month월 $_day일',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextButton(
                  onPressed: () => Navigator.of(context)
                      .pop(DateTime(_year, _month, _day)),
                  child: const Text('확인'),
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
                    labelBuilder: (i) => '${_firstYear + i}년',
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
                    labelBuilder: (i) => '${i + 1}월',
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
                    labelBuilder: (i) => '${i + 1}일',
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
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
              ),
            ),
          );
        },
      ),
    );
  }
}
