import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/child_points/data/models/childcare_model.dart';
import 'package:family_planner/features/main/child_points/data/repositories/childcare_repository.dart';
import 'package:family_planner/features/main/child_points/presentation/widgets/rule_list_item.dart';
import 'package:family_planner/features/main/child_points/providers/childcare_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 규칙 탭
class RulesTab extends ConsumerWidget {
  const RulesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final account = ref.watch(selectedChildAccountProvider);
    final rulesAsync = ref.watch(childcareRulesProvider);

    if (account == null) {
      return Center(child: Text(l10n.childcare_no_child));
    }

    return Scaffold(
      body: rulesAsync.when(
        data: (rules) {
          if (rules.isEmpty) {
            return const RulesGuide(hasRules: false);
          }
          final plusRules =
              rules.where((r) => r.type == ChildcareRuleType.plus).toList();
          final minusRules =
              rules.where((r) => r.type == ChildcareRuleType.minus).toList();
          final infoRules =
              rules.where((r) => r.type == ChildcareRuleType.info).toList();

          return RefreshIndicator(
            onRefresh: () =>
                ref.read(childcareRulesProvider.notifier).refresh(),
            child: ListView(
              children: [
                const RulesGuide(hasRules: true),
                if (plusRules.isNotEmpty)
                  _RuleSection(
                    type: ChildcareRuleType.plus,
                    rules: plusRules,
                    allRules: rules,
                    accountId: account.id,
                    onEdit: (rule) =>
                        _showRuleForm(context, ref, accountId: account.id, rule: rule),
                    onDelete: (rule) =>
                        _confirmDeleteRule(context, ref, account.id, rule),
                    onToggleActive: (rule) => ref
                        .read(childcareManagementProvider.notifier)
                        .updateRule(account.id, rule.id,
                            UpdateRuleDto(isActive: !rule.isActive)),
                    onApplyRule: (rule) =>
                        _applyRule(context, ref, account.id, rule),
                    onReorder: (updated) => ref
                        .read(childcareManagementProvider.notifier)
                        .reorderRules(account.id, _mergeReordered(rules, updated)),
                  ),
                if (minusRules.isNotEmpty)
                  _RuleSection(
                    type: ChildcareRuleType.minus,
                    rules: minusRules,
                    allRules: rules,
                    accountId: account.id,
                    onEdit: (rule) =>
                        _showRuleForm(context, ref, accountId: account.id, rule: rule),
                    onDelete: (rule) =>
                        _confirmDeleteRule(context, ref, account.id, rule),
                    onToggleActive: (rule) => ref
                        .read(childcareManagementProvider.notifier)
                        .updateRule(account.id, rule.id,
                            UpdateRuleDto(isActive: !rule.isActive)),
                    onApplyRule: (rule) =>
                        _applyRule(context, ref, account.id, rule),
                    onReorder: (updated) => ref
                        .read(childcareManagementProvider.notifier)
                        .reorderRules(account.id, _mergeReordered(rules, updated)),
                  ),
                if (infoRules.isNotEmpty)
                  _RuleSection(
                    type: ChildcareRuleType.info,
                    rules: infoRules,
                    allRules: rules,
                    accountId: account.id,
                    onEdit: (rule) =>
                        _showRuleForm(context, ref, accountId: account.id, rule: rule),
                    onDelete: (rule) =>
                        _confirmDeleteRule(context, ref, account.id, rule),
                    onToggleActive: (rule) => ref
                        .read(childcareManagementProvider.notifier)
                        .updateRule(account.id, rule.id,
                            UpdateRuleDto(isActive: !rule.isActive)),
                    onApplyRule: (rule) =>
                        _applyRule(context, ref, account.id, rule),
                    onReorder: (updated) => ref
                        .read(childcareManagementProvider.notifier)
                        .reorderRules(account.id, _mergeReordered(rules, updated)),
                  ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(l10n.childcare_empty_rules)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showRuleForm(context, ref, accountId: account.id),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showRuleForm(
    BuildContext context,
    WidgetRef ref, {
    required String accountId,
    ChildcareRule? rule,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => RuleFormDialog(
        accountId: accountId,
        rule: rule,
        ref: ref,
      ),
    );
  }

  Future<void> _applyRule(
    BuildContext context,
    WidgetRef ref,
    String accountId,
    ChildcareRule rule,
  ) async {
    final isPlus = rule.type == ChildcareRuleType.plus;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isPlus ? '규칙 적용' : '규칙 위반 적용'),
        content: Text(
          isPlus
              ? '"${rule.name}"\n${rule.points}P를 지급합니다.'
              : '"${rule.name}" 위반으로\n${rule.points}P를 차감합니다.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(isPlus ? '지급' : '차감'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    await ref.read(childcareManagementProvider.notifier).addTransaction(
          accountId,
          CreateTransactionDto.byRule(rule.id),
        );

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(isPlus ? '${rule.points}P 지급되었습니다' : '${rule.points}P 차감되었습니다')),
    );
  }

  Future<void> _confirmDeleteRule(
    BuildContext context,
    WidgetRef ref,
    String accountId,
    ChildcareRule rule,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('규칙 삭제'),
        content: Text('"${rule.name}"을(를) 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await ref
        .read(childcareManagementProvider.notifier)
        .deleteRule(accountId, rule.id);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('삭제되었습니다')));
  }
}

// ── 규칙 섹션 (접기/펴기 + 드래그 순서 변경) ────────────────────────────────

class _RuleSection extends StatefulWidget {
  const _RuleSection({
    required this.type,
    required this.rules,
    required this.allRules,
    required this.accountId,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleActive,
    required this.onApplyRule,
    required this.onReorder,
  });

  final ChildcareRuleType type;
  final List<ChildcareRule> rules;
  final List<ChildcareRule> allRules;
  final String accountId;
  final void Function(ChildcareRule) onEdit;
  final void Function(ChildcareRule) onDelete;
  final void Function(ChildcareRule) onToggleActive;
  final void Function(ChildcareRule) onApplyRule;
  final void Function(List<ChildcareRule>) onReorder;

  @override
  State<_RuleSection> createState() => _RuleSectionState();
}

class _RuleSectionState extends State<_RuleSection> {
  bool _expanded = true;

  (String, IconData, Color) get _typeInfo {
    final cs = Theme.of(context).colorScheme;
    switch (widget.type) {
      case ChildcareRuleType.plus:
        return ('+ 포인트 규칙', Icons.add_circle_outline, Colors.green.shade700);
      case ChildcareRuleType.minus:
        return ('- 포인트 규칙', Icons.remove_circle_outline, cs.error);
      case ChildcareRuleType.info:
        return ('일반 규칙', Icons.info_outline, cs.primary);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final (label, icon, color) = _typeInfo;
    final rules = widget.rules;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── 섹션 헤더 ──
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spaceM,
              vertical: AppSizes.spaceS,
            ),
            child: Row(
              children: [
                Icon(icon, size: 18, color: color),
                const SizedBox(width: AppSizes.spaceS),
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${rules.length}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const SizedBox(width: AppSizes.spaceS),
                Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 18,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
        Divider(height: 1, color: colorScheme.outlineVariant),
        // ── 아이템 목록 ──
        if (_expanded)
          ReorderableListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: rules.length,
            onReorder: (oldIndex, newIndex) {
              if (newIndex > oldIndex) newIndex--;
              final updated = [...rules];
              final moved = updated.removeAt(oldIndex);
              updated.insert(newIndex, moved);
              widget.onReorder(updated);
            },
            itemBuilder: (context, index) {
              final rule = rules[index];
              return Column(
                key: ValueKey(rule.id),
                mainAxisSize: MainAxisSize.min,
                children: [
                  RuleListItem(
                    rule: rule,
                    onApplyRule: () => widget.onApplyRule(rule),
                    onEdit: () => widget.onEdit(rule),
                    onDelete: () => widget.onDelete(rule),
                    onToggleActive: () => widget.onToggleActive(rule),
                  ),
                  const Divider(height: 1),
                ],
              );
            },
          ),
        if (!_expanded)
          const SizedBox(height: AppSizes.spaceS),
      ],
    );
  }
}

/// 동일 타입의 규칙 순서를 전체 목록에 반영합니다.
List<ChildcareRule> _mergeReordered(
  List<ChildcareRule> all,
  List<ChildcareRule> updated,
) {
  if (updated.isEmpty) return all;
  final type = updated.first.type;
  // 전체에서 해당 타입 제거 후 재삽입
  final others = all.where((r) => r.type != type).toList();
  final firstIndex = all.indexWhere((r) => r.type == type);

  final result = [...others];
  if (firstIndex == -1) {
    result.addAll(updated);
  } else {
    // 첫 번째 해당 타입 위치에 삽입
    final insertAt = others
        .indexWhere((r) => all.indexOf(r) > firstIndex)
        .let((i) => i == -1 ? others.length : i);
    result.insertAll(insertAt, updated);
  }
  return result;
}

extension<T> on T {
  R let<R>(R Function(T) block) => block(this);
}

// ── 규칙 안내 카드 ────────────────────────────────────────────────────────────

class RulesGuide extends StatefulWidget {
  const RulesGuide({super.key, required this.hasRules});

  final bool hasRules;

  @override
  State<RulesGuide> createState() => _RulesGuideState();
}

class _RulesGuideState extends State<RulesGuide> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = !widget.hasRules;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: Card(
        margin: const EdgeInsets.all(AppSizes.spaceM),
        color: colorScheme.surfaceContainerHighest,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spaceM,
                  vertical: AppSizes.spaceS,
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        size: 18, color: colorScheme.primary),
                    const SizedBox(width: AppSizes.spaceS),
                    Expanded(
                      child: Text(
                        '규칙이란 무엇인가요?',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: colorScheme.primary,
                            ),
                      ),
                    ),
                    Icon(
                      _expanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 18,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
            if (_expanded) ...[
              Divider(height: 1, color: colorScheme.outlineVariant),
              Padding(
                padding: const EdgeInsets.all(AppSizes.spaceM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '규칙은 아이의 행동에 포인트를 연결하는 약속입니다.\n좋은 행동에는 포인트를 주고, 약속을 어겼을 때는 포인트를 차감해요.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: AppSizes.spaceS),
                    Container(
                      padding: const EdgeInsets.all(AppSizes.spaceS),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: colorScheme.primary.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.lightbulb_outline,
                              size: 14, color: colorScheme.primary),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              '규칙은 구체적이고 명확할수록 좋습니다.\n애매한 규칙은 아이와 불필요한 기싸움으로 이어질 수 있어요.\n아이와 함께 규칙을 정하면 신뢰가 쌓입니다.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: colorScheme.primary),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSizes.spaceM),
                    ExampleRow(
                      icon: Icons.add_circle_outline,
                      color: Colors.green.shade700,
                      label: '+ 규칙 예시 (포인트 지급)',
                      examples: const [
                        '학교 숙제를 혼자 힘으로 끝냈을 때  +10P',
                        '저녁 9시 이전에 스스로 잠자리에 들었을 때  +5P',
                        '밥 먹은 후 식기를 싱크대에 가져다 놓았을 때  +3P',
                        '일주일 동안 지각 없이 등교했을 때  +20P',
                      ],
                    ),
                    const SizedBox(height: AppSizes.spaceS),
                    ExampleRow(
                      icon: Icons.remove_circle_outline,
                      color: colorScheme.error,
                      label: '- 규칙 예시 (포인트 차감)',
                      examples: const [
                        '평일에 스마트폰을 1시간 이상 사용했을 때  -10P',
                        '저녁 10시가 넘도록 잠자리에 들지 않았을 때  -5P',
                        '형제·자매에게 욕설을 했을 때  -15P',
                        '약속된 귀가 시간인 오후 6시를 넘겼을 때  -10P',
                      ],
                    ),
                    const SizedBox(height: AppSizes.spaceS),
                    ExampleRow(
                      icon: Icons.info_outline,
                      color: colorScheme.primary,
                      label: '일반 규칙 예시 (포인트 없음)',
                      examples: const [
                        '이달 포인트 현금 전환은 최대 50P까지만 가능',
                        '포인트 상점 아이템은 하루 1개만 사용 가능',
                      ],
                    ),
                    const SizedBox(height: AppSizes.spaceS),
                    Text(
                      '규칙을 적용하면 해당 포인트가 즉시 반영됩니다.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ExampleRow extends StatelessWidget {
  const ExampleRow({
    super.key,
    required this.icon,
    required this.color,
    required this.label,
    required this.examples,
  });

  final IconData icon;
  final Color color;
  final String label;
  final List<String> examples;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ...examples.map(
          (e) => Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 2),
            child: Text(
              '· $e',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── 규칙 폼 다이얼로그 ────────────────────────────────────────────────────────

class RuleFormDialog extends StatefulWidget {
  const RuleFormDialog({
    super.key,
    required this.accountId,
    required this.rule,
    required this.ref,
  });

  final String accountId;
  final ChildcareRule? rule;
  final WidgetRef ref;

  @override
  State<RuleFormDialog> createState() => _RuleFormDialogState();
}

class _RuleFormDialogState extends State<RuleFormDialog> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _pointsCtrl;
  late ChildcareRuleType _type;

  @override
  void initState() {
    super.initState();
    final rule = widget.rule;
    _nameCtrl = TextEditingController(text: rule?.name ?? '');
    _descCtrl = TextEditingController(text: rule?.description ?? '');
    _pointsCtrl = TextEditingController(
        text: rule != null ? rule.points.toString() : '');
    _type = rule?.type ?? ChildcareRuleType.plus;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _pointsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isNew = widget.rule == null;

    Color typeColor() {
      switch (_type) {
        case ChildcareRuleType.plus:
          return Colors.green;
        case ChildcareRuleType.minus:
          return colorScheme.error;
        case ChildcareRuleType.info:
          return colorScheme.primary;
      }
    }

    return AlertDialog(
      title: Text(isNew ? '규칙 추가' : '규칙 수정'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('규칙 유형', style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 6),
            SegmentedButton<ChildcareRuleType>(
              segments: const [
                ButtonSegment(
                  value: ChildcareRuleType.plus,
                  label: Text('+포인트'),
                  icon: Icon(Icons.add_circle_outline, size: 16),
                ),
                ButtonSegment(
                  value: ChildcareRuleType.minus,
                  label: Text('-포인트'),
                  icon: Icon(Icons.remove_circle_outline, size: 16),
                ),
                ButtonSegment(
                  value: ChildcareRuleType.info,
                  label: Text('일반'),
                  icon: Icon(Icons.info_outline, size: 16),
                ),
              ],
              selected: {_type},
              onSelectionChanged: (s) => setState(() => _type = s.first),
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return typeColor();
                  }
                  return null;
                }),
              ),
            ),
            const SizedBox(height: AppSizes.spaceM),
            TextField(
              controller: _nameCtrl,
              decoration: InputDecoration(
                labelText: '규칙 이름',
                hintText: _type == ChildcareRuleType.plus
                    ? '예: 숙제를 스스로 했을 때'
                    : _type == ChildcareRuleType.minus
                        ? '예: 스마트폰을 30분 이상 보았을 때'
                        : '예: 이달 현금 출금 한도',
              ),
              autofocus: true,
            ),
            const SizedBox(height: AppSizes.spaceS),
            TextField(
              controller: _descCtrl,
              decoration: const InputDecoration(labelText: '설명 (선택)'),
            ),
            if (_type != ChildcareRuleType.info) ...[
              const SizedBox(height: AppSizes.spaceS),
              TextField(
                controller: _pointsCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: _type == ChildcareRuleType.plus
                      ? '지급 포인트'
                      : '차감 포인트',
                  suffixText: 'P',
                  helperText: _type == ChildcareRuleType.plus
                      ? '좋은 행동 시 지급할 포인트'
                      : '규칙 위반 시 차감할 포인트',
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: _handleSave,
          child: Text(isNew ? '추가' : '저장'),
        ),
      ],
    );
  }

  Future<void> _handleSave() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;

    int points = 0;
    if (_type != ChildcareRuleType.info) {
      points = int.tryParse(_pointsCtrl.text.trim()) ?? 0;
      if (points < 0) return;
    }

    final desc =
        _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim();
    final notifier = widget.ref.read(childcareManagementProvider.notifier);

    if (widget.rule == null) {
      await notifier.addRule(
        widget.accountId,
        CreateRuleDto(
            name: name, description: desc, type: _type, points: points),
      );
    } else {
      await notifier.updateRule(
        widget.accountId,
        widget.rule!.id,
        UpdateRuleDto(
            name: name, description: desc, type: _type, points: points),
      );
    }

    if (!mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('저장되었습니다')));
  }
}
