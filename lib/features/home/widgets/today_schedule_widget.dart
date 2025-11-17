import 'package:flutter/material.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/shared/widgets/dashboard_card.dart';

/// 오늘의 일정 위젯
class TodayScheduleWidget extends StatelessWidget {
  const TodayScheduleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // 임시 데이터
    final schedules = [
      _Schedule('팀 회의', '10:00', Icons.work, Colors.blue),
      _Schedule('점심 약속', '12:00', Icons.restaurant, Colors.orange),
      _Schedule('운동', '18:00', Icons.fitness_center, Colors.green),
    ];

    return DashboardCard(
      title: '오늘의 일정',
      icon: Icons.calendar_today,
      action: TextButton(
        onPressed: () {},
        child: const Text('전체보기'),
      ),
      onTap: () {},
      child: schedules.isEmpty
          ? const _EmptyState()
          : Column(
              children: schedules
                  .map((schedule) => _ScheduleItem(schedule: schedule))
                  .toList(),
            ),
    );
  }
}

class _ScheduleItem extends StatelessWidget {
  const _ScheduleItem({required this.schedule});

  final _Schedule schedule;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.spaceS),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: schedule.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
            ),
            child: Icon(
              schedule.icon,
              color: schedule.color,
              size: AppSizes.iconMedium,
            ),
          ),
          const SizedBox(width: AppSizes.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  schedule.title,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  schedule.time,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.event_available,
            size: 48,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: AppSizes.spaceS),
          Text(
            '오늘 일정이 없습니다',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}

class _Schedule {
  final String title;
  final String time;
  final IconData icon;
  final Color color;

  _Schedule(this.title, this.time, this.icon, this.color);
}
