import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/minigame/data/models/minigame_model.dart';
import 'package:family_planner/features/minigame/providers/minigame_provider.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';

class MiniGamesScreen extends ConsumerStatefulWidget {
  const MiniGamesScreen({super.key});

  @override
  ConsumerState<MiniGamesScreen> createState() => _MiniGamesScreenState();
}

class _MiniGamesScreenState extends ConsumerState<MiniGamesScreen> {
  // 그룹을 자동 선택하지 않음 — 사용자가 직접 선택


  @override
  Widget build(BuildContext context) {
    final groups = ref.watch(myGroupsProvider).valueOrNull ?? [];
    final selectedGroupId = ref.watch(minigameSelectedGroupIdProvider);
    final resultsAsync = ref.watch(minigameResultsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('미니게임'),
      ),
      body: Column(
        children: [
          // 게임 선택 카드
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _GameCard(
                    icon: Icons.view_week,
                    title: '사다리타기',
                    color: Colors.indigo,
                    onTap: () => context.push(AppRoutes.ladderGame),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _GameCard(
                    icon: Icons.circle_outlined,
                    title: '룰렛',
                    color: Colors.orange,
                    onTap: () => context.push(AppRoutes.rouletteGame),
                  ),
                ),
              ],
            ),
          ),
          // 그룹 선택 (없음 포함)
          if (groups.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DropdownButtonFormField<String?>(
                key: ValueKey(selectedGroupId),
                initialValue: selectedGroupId,
                decoration: const InputDecoration(
                  labelText: '그룹 선택 (이력 저장 시 필요)',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text('그룹 없음 (이력 저장 안 함)',
                        style: TextStyle(color: Colors.grey)),
                  ),
                  ...groups.map((g) =>
                      DropdownMenuItem(value: g.id, child: Text(g.name))),
                ],
                onChanged: (value) {
                  ref.read(minigameSelectedGroupIdProvider.notifier).state =
                      value;
                },
              ),
            ),
          const SizedBox(height: 8),
          // 이력 섹션 (그룹 선택 시에만)
          if (selectedGroupId != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '게임 이력',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, size: 20),
                    onPressed: () =>
                        ref.read(minigameResultsProvider.notifier).refresh(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: resultsAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('오류: $e')),
                data: (results) => results.isEmpty
                    ? const Center(child: Text('게임 이력이 없습니다'))
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: results.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          return _HistoryTile(
                            result: results[index],
                            onDelete: () => _deleteResult(results[index].id),
                          );
                        },
                      ),
              ),
            ),
          ] else
            const Expanded(
              child: Center(
                child: Text(
                  '그룹을 선택하면\n게임 이력이 자동 저장됩니다',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _deleteResult(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('이력 삭제'),
        content: const Text('이 게임 이력을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('삭제', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final success = await ref
        .read(minigameManagementProvider.notifier)
        .deleteResult(id);
    if (!success && mounted) {
      final error = ref.read(minigameManagementProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('삭제 실패: $error')),
      );
    }
  }
}

class _GameCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _GameCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final MinigameResult result;
  final VoidCallback onDelete;

  const _HistoryTile({required this.result, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final isLadder = result.gameType == MinigameType.ladder;
    final subtitle = isLadder
        ? result.ladderAssignments
            .map((a) => '${a.participant} → ${a.option}')
            .join(', ')
        : '당첨: ${result.rouletteWinner ?? '-'}';

    return ListTile(
      leading: Icon(
        isLadder ? Icons.view_week : Icons.circle_outlined,
        color: isLadder ? Colors.indigo : Colors.orange,
      ),
      title: Text(result.title),
      subtitle: Text(
        subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _formatDate(result.createdAt),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 20),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.month}/${dt.day} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
