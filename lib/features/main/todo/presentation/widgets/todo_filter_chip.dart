import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/task/data/models/task_model.dart';

/// 필터 아이템 모델
class TodoFilterItem {
  final TaskPriority? value;
  final String label;
  final Color? color;

  const TodoFilterItem({
    required this.value,
    required this.label,
    this.color,
  });
}

/// 우선순위 필터 칩 위젯
class TodoFilterChip extends StatelessWidget {
  final String label;
  final TaskPriority? value;
  final List<TodoFilterItem> items;
  final ValueChanged<TaskPriority?> onChanged;

  const TodoFilterChip({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selectedItem = items.firstWhere(
      (item) => item.value == value,
      orElse: () => items.first,
    );

    return PopupMenuButton<TaskPriority?>(
      onSelected: onChanged,
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      itemBuilder: (context) => items.map((item) {
        final isSelected = item.value == value;
        return PopupMenuItem<TaskPriority?>(
          value: item.value,
          child: Row(
            children: [
              if (item.color != null) ...[
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: item.color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppSizes.spaceS),
              ],
              Expanded(
                child: Text(
                  item.label,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
              if (isSelected)
                const Icon(Icons.check, size: 18),
            ],
          ),
        );
      }).toList(),
      child: Chip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label),
            const SizedBox(width: AppSizes.spaceXS),
            if (selectedItem.color != null) ...[
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: selectedItem.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSizes.spaceXS),
            ],
            Text(
              selectedItem.label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Icon(Icons.arrow_drop_down, size: 18),
          ],
        ),
        backgroundColor: value != null
            ? Theme.of(context).colorScheme.primaryContainer
            : null,
      ),
    );
  }
}
