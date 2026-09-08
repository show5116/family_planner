import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'package:family_planner/core/constants/guide_links.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
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
              title: l10n.minigame_title,
              description: l10n.minigame_coach_desc,
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
              title: l10n.minigame_coach_group,
              description: l10n.minigame_coach_group_desc,
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
              title: l10n.minigame_history,
              description: l10n.minigame_coach_history_desc,
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
      textSkip: l10n.common_skip,
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

  Widget get _skipWidget {
    final l10n = AppLocalizations.of(context)!;
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white30),
        ),
        child: Text(
          l10n.common_skip,
          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final selectedGroupId = ref.watch(minigameSelectedGroupIdProvider);
    final resultsAsync = ref.watch(minigameResultsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.minigame_title),
        actions: [
          AppBarMoreMenu(
            onReplayOnboarding: () {
              OnboardingService.resetCoachMark(CoachMarkKeys.miniGames);
              _showCoachMark();
            },
            guideUrl: GuideLinks.minigame,
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
                    title: l10n.minigame_ladder,
                    color: Colors.indigo,
                    onTap: () => context.push(AppRoutes.ladderGame),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _GameCard(
                    key: _rouletteCardKey,
                    icon: Icons.circle_outlined,
                    title: l10n.minigame_roulette,
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
            personalLabel: l10n.minigame_no_group,
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
                  Text(
                    l10n.minigame_history,
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
                error: (e, _) => Center(child: Text('${l10n.common_error}: $e')),
                data: (results) => results.isEmpty
                    ? Center(child: Text(l10n.minigame_history_empty))
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
                      l10n.minigame_select_group_hint,
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
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.minigame_history_delete),
        content: Text(l10n.minigame_history_delete_message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.common_cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.common_delete,
                style: const TextStyle(color: Colors.red)),
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
        SnackBar(content: Text('${l10n.common_deleteFailed}\n$error')),
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
    final l10n = AppLocalizations.of(context)!;
    final isLadder = result.gameType == MinigameType.ladder;
    final subtitle = isLadder
        ? result.ladderAssignments
            .map((a) => '${a.participant} → ${a.option}')
            .join(', ')
        : l10n.minigame_winner(result.rouletteWinner ?? '-');

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
