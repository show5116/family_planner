import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/home/providers/dashboard_provider.dart';
import 'package:family_planner/features/main/savings/data/models/savings_model.dart';
import 'package:family_planner/features/main/savings/data/repositories/savings_repository.dart';
import 'package:family_planner/features/main/savings/presentation/screens/savings_form_screen.dart';
import 'package:family_planner/features/main/savings/presentation/screens/savings_transactions_screen.dart';
import 'package:family_planner/features/main/savings/providers/savings_provider.dart';
import 'package:family_planner/features/onboarding/presentation/widgets/feature_coach_mark.dart';
import 'package:family_planner/features/onboarding/services/onboarding_service.dart';


class SavingsDetailScreen extends ConsumerStatefulWidget {
  /// 실제 저금통 상세 — goalId로 API 조회
  const SavingsDetailScreen({super.key, required this.goalId})
      : demoGoal = null;

  /// 온보딩 전용 — API 없이 demoGoal을 직접 렌더링
  const SavingsDetailScreen.demo({super.key, required SavingsGoalModel this.demoGoal})
      : goalId = '__demo__';

  final String goalId;
  final SavingsGoalModel? demoGoal;

  bool get isDemo => demoGoal != null;

  @override
  ConsumerState<SavingsDetailScreen> createState() =>
      _SavingsDetailScreenState();
}

class _SavingsDetailScreenState extends ConsumerState<SavingsDetailScreen> {
  bool _actionLoading = false;

  // 온보딩 코치마크용 키
  final _headerCardKey = GlobalKey();
  final _depositButtonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (widget.isDemo) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showDemoCoachMark());
    }
  }

  TargetPosition? _keyToPosition(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return null;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return null;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final offset = box.localToGlobal(Offset.zero, ancestor: overlay);
    return TargetPosition(box.size, offset);
  }

  Future<void> _showDemoCoachMark() async {
    if (!mounted) return;
    final headerPos = _keyToPosition(_headerCardKey);
    final depositPos = _keyToPosition(_depositButtonKey);
    final targets = <TargetFocus>[
      TargetFocus(
        identify: 'detail_header',
        targetPosition: headerPos,
        keyTarget: headerPos == null ? _headerCardKey : null,
        shape: ShapeLightFocus.RRect,
        radius: 12,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '적립 현황',
              description: '현재 적립금과 목표 금액,\n달성률을 상세하게 확인할 수 있어요.\n자동 적립 중일 때는 적립 상태도 표시돼요.',
              icon: Icons.savings_outlined,
              color: AppColors.investment,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'detail_deposit',
        targetPosition: depositPos,
        keyTarget: depositPos == null ? _depositButtonKey : null,
        shape: ShapeLightFocus.RRect,
        radius: 12,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '입금 / 출금',
              description: '언제든지 직접 입금하거나 출금할 수 있어요.\n자동 적립과 함께 활용하면 더욱 편리해요.',
              icon: Icons.swap_vert,
              color: Colors.green,
            ),
          ),
        ],
      ),
    ];
    await FeatureCoachMark.waitForTargets(targets, context);
    if (!mounted) return;
    TutorialCoachMark(
      targets: targets,
      colorShadow: AppColors.textPrimary,
      opacityShadow: 0.85,
      textSkip: '건너뛰기',
      alignSkip: Alignment.topRight,
      skipWidget: Container(
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
      ),
      onFinish: _completeDemoOnboarding,
      onSkip: () {
        _completeDemoOnboarding();
        return true;
      },
      paddingFocus: 8,
      focusAnimationDuration: const Duration(milliseconds: 300),
      pulseAnimationDuration: const Duration(milliseconds: 800),
    ).show(context: context);
  }

  void _completeDemoOnboarding() {
    OnboardingService.completeCoachMark(CoachMarkKeys.savings);
    if (mounted) Navigator.pop(context);
  }

  Future<void> _runAction(Future<void> Function() action) async {
    setState(() => _actionLoading = true);
    try {
      await action();
      if (mounted) {
        ref.read(savingsGoalDetailProvider(widget.goalId).notifier).refresh();
        ref.invalidate(dashboardSavingsProvider);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('오류: $e')));
      }
    } finally {
      if (mounted) setState(() => _actionLoading = false);
    }
  }

  Future<void> _showDepositDialog(SavingsGoalModel goal) async {
    final amountCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('입금'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: '금액 (원)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: AppSizes.spaceM),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: '메모 (선택)', border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('취소')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('입금'),
          ),
        ],
      ),
    );
    if (confirmed == true && amountCtrl.text.isNotEmpty) {
      final amount = double.tryParse(amountCtrl.text.replaceAll(',', ''));
      if (amount != null && amount > 0) {
        await _runAction(() => ref
            .read(savingsRepositoryProvider)
            .deposit(goal.id, amount: amount, description: descCtrl.text.isEmpty ? null : descCtrl.text));
      }
    }
  }

  Future<void> _showWithdrawDialog(SavingsGoalModel goal) async {
    final amountCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('출금'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: '금액 (원)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: AppSizes.spaceM),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: '출금 사유 (필수)', border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('취소')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('출금'),
          ),
        ],
      ),
    );
    if (confirmed == true && amountCtrl.text.isNotEmpty && descCtrl.text.isNotEmpty) {
      final amount = double.tryParse(amountCtrl.text.replaceAll(',', ''));
      if (amount != null && amount > 0) {
        await _runAction(() => ref
            .read(savingsRepositoryProvider)
            .withdraw(goal.id, amount: amount, description: descCtrl.text));
      }
    }
  }

  Future<void> _confirmDelete(SavingsGoalModel goal) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('목표 삭제'),
        content: Text('\'${goal.name}\'을(를) 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('취소')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await _runAction(() => ref.read(savingsRepositoryProvider).deleteGoal(goal.id));
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 온보딩 demo 모드: API 없이 가짜 데이터로 렌더링
    if (widget.isDemo) {
      final goal = widget.demoGoal!;
      return Scaffold(
        appBar: AppBar(title: Text(goal.name)),
        body: _DetailBody(
          goal: goal,
          actionLoading: false,
          headerCardKey: _headerCardKey,
          depositButtonKey: _depositButtonKey,
          isDemo: true,
          onDeposit: () {},
          onWithdraw: () {},
          onPause: () {},
          onResume: () {},
        ),
      );
    }

    // 일반 모드: API 조회
    final goalAsync = ref.watch(savingsGoalDetailProvider(widget.goalId));

    return Scaffold(
      appBar: AppBar(
        title: goalAsync.maybeWhen(
          data: (g) => Text(g.name),
          orElse: () => const Text('적립 목표'),
        ),
        actions: [
          if (goalAsync.hasValue)
            PopupMenuButton<String>(
              onSelected: (value) async {
                final goal = goalAsync.value!;
                switch (value) {
                  case 'edit':
                    final updated = await Navigator.push<SavingsGoalModel>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SavingsFormScreen(goal: goal),
                      ),
                    );
                    if (updated != null && mounted) {
                      ref
                          .read(savingsGoalDetailProvider(widget.goalId).notifier)
                          .refresh();
                    }
                  case 'delete':
                    await _confirmDelete(goal);
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'edit', child: Text('수정')),
                PopupMenuItem(
                  value: 'delete',
                  child: Text('삭제', style: TextStyle(color: AppColors.error)),
                ),
              ],
            ),
        ],
      ),
      body: goalAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline,
                  size: AppSizes.iconXLarge, color: AppColors.error),
              const SizedBox(height: AppSizes.spaceM),
              Text('오류: $e', textAlign: TextAlign.center),
              const SizedBox(height: AppSizes.spaceM),
              TextButton(
                onPressed: () => ref
                    .read(savingsGoalDetailProvider(widget.goalId).notifier)
                    .refresh(),
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
        data: (goal) => _DetailBody(
          goal: goal,
          actionLoading: _actionLoading,
          onDeposit: () => _showDepositDialog(goal),
          onWithdraw: () => _showWithdrawDialog(goal),
          onPause: () => _runAction(
              () => ref.read(savingsRepositoryProvider).pauseGoal(goal.id)),
          onResume: () => _runAction(
              () => ref.read(savingsRepositoryProvider).resumeGoal(goal.id)),
        ),
      ),
    );
  }
}

// ── 상세 본문 ─────────────────────────────────────────────────────────────────

class _DetailBody extends StatelessWidget {
  const _DetailBody({
    required this.goal,
    required this.actionLoading,
    required this.onDeposit,
    required this.onWithdraw,
    required this.onPause,
    required this.onResume,
    this.headerCardKey,
    this.depositButtonKey,
    this.isDemo = false,
  });

  final SavingsGoalModel goal;
  final bool actionLoading;
  final VoidCallback onDeposit;
  final VoidCallback onWithdraw;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final GlobalKey? headerCardKey;
  final GlobalKey? depositButtonKey;
  final bool isDemo;

  String _formatAmount(double amount) {
    final intAmount = amount.toInt();
    final formatted = intAmount
        .toString()
        .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},');
    return '$formatted원';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 헤더 카드
          Card(
            key: headerCardKey,
            elevation: AppSizes.elevation1,
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.spaceL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _formatAmount(goal.currentAmount),
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.investment,
                          ),
                        ),
                      ),
                      _StatusBadge(status: goal.status),
                    ],
                  ),
                  if (goal.isGoalReached == true) ...[
                    const SizedBox(height: AppSizes.spaceS),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.spaceS,
                        vertical: AppSizes.spaceXS,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.investment.withAlpha(20),
                        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                        border: Border.all(color: AppColors.investment.withAlpha(80)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle, size: 14, color: AppColors.investment),
                          const SizedBox(width: AppSizes.spaceXS),
                          Text(
                            '목표 금액 달성!',
                            style: TextStyle(
                              color: AppColors.investment,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (goal.targetAmount != null) ...[
                    const SizedBox(height: AppSizes.spaceXS),
                    Text(
                      '목표: ${_formatAmount(goal.targetAmount!)}',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: AppSizes.spaceM),
                    LinearProgressIndicator(
                      value: (goal.achievementRate / 100).clamp(0.0, 1.0),
                      backgroundColor: AppColors.primaryLight,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.investment),
                      borderRadius:
                          BorderRadius.circular(AppSizes.radiusSmall),
                      minHeight: 8,
                    ),
                    const SizedBox(height: AppSizes.spaceXS),
                    Text(
                      '${goal.achievementRate.toStringAsFixed(1)}% 달성',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                  if (goal.autoDeposit) ...[
                    const SizedBox(height: AppSizes.spaceM),
                    const Divider(),
                    const SizedBox(height: AppSizes.spaceS),
                    Row(
                      children: [
                        const Icon(Icons.autorenew,
                            size: AppSizes.iconSmall,
                            color: AppColors.textSecondary),
                        const SizedBox(width: AppSizes.spaceXS),
                        Text(
                          '자동 적립',
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                        if (goal.monthlyAmount != null) ...[
                          const SizedBox(width: AppSizes.spaceS),
                          Text(
                            '월 ${_formatAmount(goal.monthlyAmount!)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.investment,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                        const SizedBox(width: AppSizes.spaceS),
                        _StatusBadge(
                          status: goal.status == SavingsGoalStatus.paused
                              ? SavingsGoalStatus.paused
                              : SavingsGoalStatus.active,
                          small: true,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSizes.spaceM),

          // 액션 버튼 행
          if (actionLoading)
            const Center(child: CircularProgressIndicator())
          else ...[
            // pause / resume / complete
            Row(
              children: [
                if (goal.status == SavingsGoalStatus.active && goal.autoDeposit)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onPause,
                      icon: const Icon(Icons.pause),
                      label: const Text('자동 적립 중지'),
                    ),
                  ),
                if (goal.status == SavingsGoalStatus.paused) ...[
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onResume,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('자동 적립 재개'),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: AppSizes.spaceS),
            // 입금 / 출금
            Row(
              key: depositButtonKey,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onDeposit,
                    icon: const Icon(Icons.add),
                    label: const Text('입금'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.spaceS),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onWithdraw,
                    icon: const Icon(Icons.remove),
                    label: const Text('출금'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],

          if (!isDemo) ...[
            const SizedBox(height: AppSizes.spaceL),
            _RecentTransactions(goalId: goal.id, goalName: goal.name),
          ],
        ],
      ),
    );
  }
}

// ── 최근 내역 섹션 ────────────────────────────────────────────────────────────

class _RecentTransactions extends ConsumerWidget {
  const _RecentTransactions({
    required this.goalId,
    required this.goalName,
  });

  final String goalId;
  final String goalName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txAsync = ref.watch(savingsTransactionsProvider(goalId));
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('최근 내역',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SavingsTransactionsScreen(
                        goalId: goalId, goalName: goalName),
                  ),
                );
              },
              child: const Text('전체 보기'),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.spaceS),
        txAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('내역 로드 실패: $e',
              style: const TextStyle(color: AppColors.error)),
          data: (result) {
            if (result.items.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSizes.spaceM),
                  child: Text('거래 내역이 없습니다.',
                      style: TextStyle(color: AppColors.textSecondary)),
                ),
              );
            }
            final recent = result.items.take(10).toList();
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recent.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) =>
                  _TransactionTile(tx: recent[index]),
            );
          },
        ),
      ],
    );
  }
}

// ── 거래 내역 타일 ────────────────────────────────────────────────────────────

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({required this.tx});

  final SavingsTransactionModel tx;

  String _formatAmount(double amount) {
    final intAmount = amount.toInt();
    final formatted = intAmount
        .toString()
        .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},');
    return '$formatted원';
  }

  @override
  Widget build(BuildContext context) {
    final isDeposit = tx.type == SavingsType.deposit ||
        tx.type == SavingsType.autoDeposit;
    final amountColor = isDeposit ? AppColors.success : AppColors.error;
    final amountPrefix = isDeposit ? '+' : '-';
    final icon = switch (tx.type) {
      SavingsType.deposit => Icons.arrow_downward,
      SavingsType.withdraw => Icons.arrow_upward,
      SavingsType.autoDeposit => Icons.autorenew,
    };

    return ListTile(
      dense: true,
      leading: CircleAvatar(
        radius: 16,
        backgroundColor: amountColor.withAlpha(30),
        child: Icon(icon, size: AppSizes.iconSmall, color: amountColor),
      ),
      title: Text(
        tx.type.toDisplayString(),
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: tx.description != null && tx.description!.isNotEmpty
          ? Text(tx.description!,
              style: const TextStyle(color: AppColors.textSecondary))
          : Text(
              _formatDate(tx.createdAt),
              style:
                  const TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '$amountPrefix${_formatAmount(tx.amount)}',
            style: TextStyle(
                color: amountColor, fontWeight: FontWeight.w600),
          ),
          Text(
            _formatDate(tx.createdAt),
            style:
                const TextStyle(color: AppColors.textSecondary, fontSize: 11),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.year}.${dt.month.toString().padLeft(2, '0')}.${dt.day.toString().padLeft(2, '0')}';
  }
}

// ── 상태 뱃지 ─────────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status, this.small = false});

  final SavingsGoalStatus status;
  final bool small;

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case SavingsGoalStatus.active:
        color = AppColors.success;
      case SavingsGoalStatus.paused:
        color = AppColors.warning;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? AppSizes.spaceXS : AppSizes.spaceS,
        vertical: AppSizes.spaceXS,
      ),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
        border: Border.all(color: color.withAlpha(100)),
      ),
      child: Text(
        status.toDisplayString(),
        style: TextStyle(
          color: color,
          fontSize: small ? 10 : 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
