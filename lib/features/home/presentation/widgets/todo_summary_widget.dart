import 'package:flutter/material.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/shared/widgets/dashboard_card.dart';

/// 할일 요약 위젯
class TodoSummaryWidget extends StatelessWidget {
  const TodoSummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // 임시 데이터
    final todos = [
      _Todo('프로젝트 문서 작성', false, '높음'),
      _Todo('회의 자료 준비', false, '중간'),
      _Todo('이메일 답장', true, '낮음'),
      _Todo('코드 리뷰', false, '높음'),
      _Todo('테스트 작성', false, '중간'),
    ];

    final completedCount = todos.where((t) => t.isCompleted).length;
    final totalCount = todos.length;

    return DashboardCard(
      title: '오늘의 할일',
      icon: Icons.check_box,
      action: Chip(
        label: Text(
          '$completedCount/$totalCount',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.primaryLight,
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
      ),
      onTap: () {},
      child: Column(
        children: todos
            .take(5)
            .map((todo) => _TodoItem(todo: todo))
            .toList(),
      ),
    );
  }
}

class _TodoItem extends StatefulWidget {
  const _TodoItem({required this.todo});

  final _Todo todo;

  @override
  State<_TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<_TodoItem> {
  late bool _isCompleted;

  @override
  void initState() {
    super.initState();
    _isCompleted = widget.todo.isCompleted;
  }

  @override
  Widget build(BuildContext context) {
    final priorityColor = _getPriorityColor(widget.todo.priority);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.spaceS),
      child: Row(
        children: [
          Checkbox(
            value: _isCompleted,
            onChanged: (value) {
              setState(() {
                _isCompleted = value ?? false;
              });
            },
            visualDensity: VisualDensity.compact,
          ),
          Expanded(
            child: Text(
              widget.todo.title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    decoration: _isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: _isCompleted
                        ? Theme.of(context).colorScheme.onSurfaceVariant
                        : null,
                  ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spaceS,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: priorityColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
            ),
            child: Text(
              widget.todo.priority,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: priorityColor,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case '높음':
        return AppColors.error;
      case '중간':
        return AppColors.warning;
      case '낮음':
        return AppColors.success;
      default:
        return Colors.grey;
    }
  }
}

class _Todo {
  final String title;
  final bool isCompleted;
  final String priority;

  _Todo(this.title, this.isCompleted, this.priority);
}
