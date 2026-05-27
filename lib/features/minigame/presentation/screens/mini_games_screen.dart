import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/minigame/data/models/minigame_model.dart';
import 'package:family_planner/features/minigame/providers/minigame_provider.dart';
import 'package:family_planner/features/onboarding/presentation/widgets/feature_coach_mark.dart';
import 'package:family_planner/features/onboarding/services/onboarding_service.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/features/settings/groups/providers/default_group_provider.dart';
import 'package:family_planner/shared/widgets/app_bar_more_menu.dart';
import 'package:family_planner/shared/widgets/group_filter_bar.dart';

class MiniGamesScreen extends ConsumerStatefulWidget {
  const MiniGamesScreen({super.key});

  @override
  ConsumerState<MiniGamesScreen> createState() => _MiniGamesScreenState();
}

class _MiniGamesScreenState extends ConsumerState<MiniGamesScreen> {
  final _ladderCardKey = GlobalKey();
  final _rouletteCardKey = GlobalKey();
  final _groupDropdownKey = GlobalKey();
  final _historyKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initGroupSelection();
      _maybeStartOnboarding();
    });
  }

  Future<void> _initGroupSelection() async {
    if (ref.read(minigameSelectedGroupIdProvider) != null) return;
    final defaultId = ref.read(defaultGroupProvider);
    final groups = ref.read(myGroupsProvider).valueOrNull ?? [];
    if (groups.isEmpty || !mounted) return;
    final resolved = (defaultId != null && groups.any((g) => g.id == defaultId))
        ? defaultId
        : groups.first.id;
    ref.read(minigameSelectedGroupIdProvider.notifier).state = resolved;
  }

  TargetPosition? _keyToPosition(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return null;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return null;
    final offset = box.localToGlobal(Offset.zero);
    return TargetPosition(box.size, offset);
  }

  Future<void> _maybeStartOnboarding() async {
    final completed =
        await OnboardingService.isCoachMarkCompleted(CoachMarkKeys.miniGames);
    if (!mounted || completed) return;
    _showCoachMark();
  }

  Future<void> _showCoachMark() async {
    if (!mounted) return;

    final ladderPos = _keyToPosition(_ladderCardKey);
    final roulettePos = _keyToPosition(_rouletteCardKey);
    final groupPos = _keyToPosition(_groupDropdownKey);
    final historyPos = _keyToPosition(_historyKey);

    final targets = <TargetFocus>[
      TargetFocus(
        identify: 'game_cards',
        targetPosition: ladderPos != null && roulettePos != null
            ? TargetPosition(
                Size(
                  (roulettePos.offset.dx +
                          roulettePos.size.width) -
                      ladderPos.offset.dx,
                  ladderPos.size.height,
                ),
                ladderPos.offset,
              )
            : null,
        keyTarget: ladderPos == null ? _ladderCardKey : null,
        shape: ShapeLightFocus.RRect,
        radius: 12,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '미니게임',
              description: '사다리타기와 룰렛 게임을 즐길 수 있어요.\n공정한 결정이 필요할 때 활용해보세요!',
              icon: Icons.casino_outlined,
              color: Colors.indigo,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'group_dropdown',
        targetPosition: groupPos,
        keyTarget: groupPos == null ? _groupDropdownKey : null,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '그룹 선택',
              description: '그룹을 선택하면 게임 결과가\n자동으로 저장돼요.\n그룹 멤버 누구나 이력을 확인할 수 있어요.',
              icon: Icons.group_outlined,
              color: Colors.teal,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'history_section',
        targetPosition: historyPos,
        keyTarget: historyPos == null ? _historyKey : null,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '게임 이력',
              description: '지금까지 진행한 게임 결과를\n이곳에서 확인할 수 있어요.\n누가 어떤 결과를 받았는지 투명하게 공개됩니다.',
              icon: Icons.history,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    ];

    await FeatureCoachMark.waitForTargets(targets, context);
    if (!mounted) return;

    TutorialCoachMark(
      targets: FeatureCoachMark.refreshPositions(targets),
      colorShadow: const Color(0xFF212121),
      opacityShadow: 0.85,
      textSkip: '건너뛰기',
      alignSkip: Alignment.topRight,
      skipWidget: _skipWidget,
      onFinish: () => OnboardingService.completeCoachMark(CoachMarkKeys.miniGames),
      onSkip: () {
        OnboardingService.completeCoachMark(CoachMarkKeys.miniGames);
        return true;
      },
      paddingFocus: 8,
      focusAnimationDuration: const Duration(milliseconds: 300),
      pulseAnimationDuration: const Duration(milliseconds: 800),
    ).show(context: context);
  }

  Widget get _skipWidget => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white30),
        ),
        child: const Text(
          '건너뛰기',
          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final selectedGroupId = ref.watch(minigameSelectedGroupIdProvider);
    final resultsAsync = ref.watch(minigameResultsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('미니게임'),
        actions: [
          AppBarMoreMenu(
            onReplayOnboarding: () {
              OnboardingService.resetCoachMark(CoachMarkKeys.miniGames);
              _showCoachMark();
            },
          ),
        ],
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
                    key: _ladderCardKey,
                    icon: Icons.view_week,
                    title: '사다리타기',
                    color: Colors.indigo,
                    onTap: () => context.push(AppRoutes.ladderGame),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _GameCard(
                    key: _rouletteCardKey,
                    icon: Icons.circle_outlined,
                    title: '룰렛',
                    color: Colors.orange,
                    onTap: () => context.push(AppRoutes.rouletteGame),
                  ),
                ),
              ],
            ),
          ),
          // 그룹 선택 (null = 이력 저장 안 함)
          GroupFilterBar(
            key: _groupDropdownKey,
            selectedGroupId: selectedGroupId,
            showPersonal: true,
            personalLabel: '그룹 없음 (이력 저장 안 함)',
            onChanged: (value) {
              ref.read(minigameSelectedGroupIdProvider.notifier).state = value;
            },
          ),
          const SizedBox(height: 8),
          // 이력 섹션 (그룹 선택 시)
          if (selectedGroupId != null) ...[
            Padding(
              key: _historyKey,
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
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.history,
                        size: 48,
                        color: Theme.of(context).colorScheme.outline),
                    const SizedBox(height: 8),
                    Text(
                      '그룹을 선택하면\n게임 이력이 자동 저장됩니다',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.outline),
                    ),
                  ],
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
    super.key,
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
