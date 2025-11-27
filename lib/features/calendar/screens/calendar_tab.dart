import 'package:flutter/material.dart';

/// 일정 관리 탭
class CalendarTab extends StatelessWidget {
  const CalendarTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('일정'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              '일정 관리',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            const Text('일정 관리 기능이 여기에 표시됩니다'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'calendar_fab',
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
