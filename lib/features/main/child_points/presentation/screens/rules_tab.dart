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
  const RulesTab({
    super.key,
    this.demoRules,
    this.demoPlusKey,
    this.demoMinusKey,
    this.demoInfoKey,
  });

  final List<ChildcareRule>? demoRules;
  final GlobalKey? demoPlusKey;
  final GlobalKey? demoMinusKey;
  final GlobalKey? demoInfoKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    // 데모 모드: 샘플 규칙 렌더링
    if (demoRules != null) {
      final plusRules = demoRules!
          .where((r) => r.type == ChildcareRuleType.plus)
          .toList();
      final minusRules = demoRules!
          .where((r) => r.type == ChildcareRuleType.minus)
          .toList();
      final infoRules = demoRules!
          .where((r) => r.type == ChildcareRuleType.info)
          .toList();
      return Scaffold(
        body: ListView(
          children: [
            const RulesGuide(hasRules: true),
            if (plusRules.isNotEmpty)
              KeyedSubtree(
                key: demoPlusKey,
                child: _DemoRuleSection(
                  type: ChildcareRuleType.plus,
                  rules: plusRules,
                ),
              ),
            if (minusRules.isNotEmpty)
              KeyedSubtree(
                key: demoMinusKey,
                child: _DemoRuleSection(
                  type: ChildcareRuleType.minus,
                  rules: minusRules,
                ),
              ),
            if (infoRules.isNotEmpty)
              KeyedSubtree(
                key: demoInfoKey,
                child: _DemoRuleSection(
                  type: ChildcareRuleType.info,
                  rules: infoRules,
                ),
              ),
          ],
        ),
      );
    }

    final account = ref.watch(selectedChildAccountProvider);
    final rulesAsync = ref.watch(childcareRulesProvider);

    if (account == null) {
      final childrenAsync = ref.watch(childcareChildrenProvider);
      return childrenAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(l10n.childcare_no_child)),
        data: (_) => Center(child: Text(l10n.childcare_no_child)),
      );
    }

    return Scaffold(
      body: rulesAsync.when(
        data: (rules) {
          if (rules.isEmpty) {
            return const RulesGuide(hasRules: false);
          }
          final plusRules = rules
              .where((r) => r.type == ChildcareRuleType.plus)
              .toList();
          final minusRules = rules
              .where((r) => r.type == ChildcareRuleType.minus)
              .toList();
          final infoRules = rules
              .where((r) => r.type == ChildcareRuleType.info)
              .toList();

          return RefreshIndicator(
            onRefresh: () =>
                ref.read(childcareRulesProvider.notifier).refresh(),
            child: ListView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.paddingOf(context).bottom + 80,
              ),
              children: [
                const RulesGuide(hasRules: true),
                if (plusRules.isNotEmpty)
                  _RuleSection(
                    type: ChildcareRuleType.plus,
                    rules: plusRules,
                    allRules: rules,
                    accountId: account.id,
                    onEdit: (rule) => _showRuleForm(
                      context,
                      ref,
                      accountId: account.id,
                      rule: rule,
                    ),
                    onDelete: (rule) =>
                        _confirmDeleteRule(context, ref, account.id, rule),
                    onToggleActive: (rule) => ref
                        .read(childcareManagementProvider.notifier)
                        .updateRule(
                          account.id,
                          rule.id,
                          UpdateRuleDto(isActive: !rule.isActive),
                        ),
                    onApplyRule: (rule) =>
                        _applyRule(context, ref, account.id, rule),
                    onReorder: (updated) => ref
                        .read(childcareManagementProvider.notifier)
                        .reorderRules(
                          account.id,
                          _mergeReordered(rules, updated),
                        ),
                  ),
                if (minusRules.isNotEmpty)
                  _RuleSection(
                    type: ChildcareRuleType.minus,
                    rules: minusRules,
                    allRules: rules,
                    accountId: account.id,
                    onEdit: (rule) => _showRuleForm(
                      context,
                      ref,
                      accountId: account.id,
                      rule: rule,
                    ),
                    onDelete: (rule) =>
                        _confirmDeleteRule(context, ref, account.id, rule),
                    onToggleActive: (rule) => ref
                        .read(childcareManagementProvider.notifier)
                        .updateRule(
                          account.id,
                          rule.id,
                          UpdateRuleDto(isActive: !rule.isActive),
                        ),
                    onApplyRule: (rule) =>
                        _applyRule(context, ref, account.id, rule),
                    onReorder: (updated) => ref
                        .read(childcareManagementProvider.notifier)
                        .reorderRules(
                          account.id,
                          _mergeReordered(rules, updated),
                        ),
                  ),
                if (infoRules.isNotEmpty)
                  _RuleSection(
                    type: ChildcareRuleType.info,
                    rules: infoRules,
                    allRules: rules,
                    accountId: account.id,
                    onEdit: (rule) => _showRuleForm(
                      context,
                      ref,
                      accountId: account.id,
                      rule: rule,
                    ),
                    onDelete: (rule) =>
                        _confirmDeleteRule(context, ref, account.id, rule),
                    onToggleActive: (rule) => ref
                        .read(childcareManagementProvider.notifier)
                        .updateRule(
                          account.id,
                          rule.id,
                          UpdateRuleDto(isActive: !rule.isActive),
                        ),
                    onApplyRule: (rule) =>
                        _applyRule(context, ref, account.id, rule),
                    onReorder: (updated) => ref
                        .read(childcareManagementProvider.notifier)
                        .reorderRules(
                          account.id,
                          _mergeReordered(rules, updated),
                        ),
                  ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(l10n.childcare_empty_rules)),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: l10n.childcare_add_rule,
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
      builder: (ctx) =>
          RuleFormDialog(accountId: accountId, rule: rule, ref: ref),
    );
  }

  Future<void> _applyRule(
    BuildContext context,
    WidgetRef ref,
    String accountId,
    ChildcareRule rule,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final isPlus = rule.type == ChildcareRuleType.plus;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isPlus
            ? l10n.childcare_rule_apply
            : l10n.childcare_rule_apply_penalty),
        content: Text(
          isPlus
              ? l10n.childcare_rule_apply_plus_message(
                  rule.name, '${rule.points}')
              : l10n.childcare_rule_apply_minus_message(
                  rule.name, '${rule.points}'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.common_cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(isPlus
                ? l10n.childcare_rule_give
                : l10n.childcare_rule_deduct),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    await ref
        .read(childcareManagementProvider.notifier)
        .addTransaction(accountId, CreateTransactionDto.byRule(rule.id));

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isPlus
              ? l10n.childcare_points_given('${rule.points}')
              : l10n.childcare_points_deducted('${rule.points}'),
        ),
      ),
    );
  }

  Future<void> _confirmDeleteRule(
    BuildContext context,
    WidgetRef ref,
    String accountId,
    ChildcareRule rule,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.childcare_rule_delete),
        content: Text(l10n.childcare_rule_delete_message(rule.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.common_cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.common_delete),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await ref
        .read(childcareManagementProvider.notifier)
        .deleteRule(accountId, rule.id);
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.common_deleted)));
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
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    switch (widget.type) {
      case ChildcareRuleType.plus:
        return (l10n.childcare_rule_type_plus, Icons.add_circle_outline,
            Colors.green.shade700);
      case ChildcareRuleType.minus:
        return (l10n.childcare_rule_type_minus, Icons.remove_circle_outline,
            cs.error);
      case ChildcareRuleType.info:
        return (l10n.childcare_rule_type_info, Icons.info_outline, cs.primary);
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
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
            onReorderItem: (oldIndex, newIndex) {
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
        if (!_expanded) const SizedBox(height: AppSizes.spaceS),
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

// ── 데모용 규칙 섹션 ──────────────────────────────────────────────────────────

class _DemoRuleSection extends StatelessWidget {
  const _DemoRuleSection({required this.type, required this.rules});

  final ChildcareRuleType type;
  final List<ChildcareRule> rules;

  (String, IconData, Color) _typeInfo(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    switch (type) {
      case ChildcareRuleType.plus:
        return (l10n.childcare_rule_type_plus, Icons.add_circle_outline,
            Colors.green.shade700);
      case ChildcareRuleType.minus:
        return (l10n.childcare_rule_type_minus, Icons.remove_circle_outline,
            cs.error);
      case ChildcareRuleType.info:
        return (l10n.childcare_rule_type_info, Icons.info_outline, cs.primary);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final (label, icon, color) = _typeInfo(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
            ],
          ),
        ),
        Divider(height: 1, color: colorScheme.outlineVariant),
        ...rules.map(
          (rule) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RuleListItem(rule: rule),
              const Divider(height: 1),
            ],
          ),
        ),
      ],
    );
  }
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
    final l10n = AppLocalizations.of(context)!;
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
                    Icon(
                      Icons.info_outline,
                      size: 18,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: AppSizes.spaceS),
                    Expanded(
                      child: Text(
                        l10n.childcare_rule_help_title,
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
                      l10n.childcare_rule_help_body,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSizes.spaceS),
                    Container(
                      padding: const EdgeInsets.all(AppSizes.spaceS),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer.withValues(
                          alpha: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: colorScheme.primary.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            size: 14,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              l10n.childcare_rule_help_tip,
                              style: Theme.of(context).textTheme.bodySmall
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
                      label: l10n.childcare_rule_examples_plus,
                      examples: [
                        l10n.childcare_rule_example_plus1,
                        l10n.childcare_rule_example_plus2,
                        l10n.childcare_rule_example_plus3,
                        l10n.childcare_rule_example_plus4,
                      ],
                    ),
                    const SizedBox(height: AppSizes.spaceS),
                    ExampleRow(
                      icon: Icons.remove_circle_outline,
                      color: colorScheme.error,
                      label: l10n.childcare_rule_examples_minus,
                      examples: [
                        l10n.childcare_rule_example_minus1,
                        l10n.childcare_rule_example_minus2,
                        l10n.childcare_rule_example_minus3,
                        l10n.childcare_rule_example_minus4,
                      ],
                    ),
                    const SizedBox(height: AppSizes.spaceS),
                    ExampleRow(
                      icon: Icons.info_outline,
                      color: colorScheme.primary,
                      label: l10n.childcare_rule_examples_info,
                      examples: [
                        l10n.childcare_rule_example_info1,
                        l10n.childcare_rule_example_info2,
                      ],
                    ),
                    const SizedBox(height: AppSizes.spaceS),
                    Text(
                      l10n.childcare_rule_apply_note,
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
  bool _isSaving = false;
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    final rule = widget.rule;
    _nameCtrl = TextEditingController(text: rule?.name ?? '');
    _descCtrl = TextEditingController(text: rule?.description ?? '');
    _pointsCtrl = TextEditingController(
      text: rule != null ? rule.points.toString() : '',
    );
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
    final l10n = AppLocalizations.of(context)!;
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
      title: Text(isNew ? l10n.childcare_rule_add : l10n.childcare_rule_edit),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.childcare_rule_type,
                style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 6),
            SegmentedButton<ChildcareRuleType>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(
                  value: ChildcareRuleType.plus,
                  label: Text(l10n.childcare_rule_type_plus_short),
                  icon: Icon(Icons.add_circle_outline, size: 16),
                ),
                ButtonSegment(
                  value: ChildcareRuleType.minus,
                  label: Text(l10n.childcare_rule_type_minus_short),
                  icon: Icon(Icons.remove_circle_outline, size: 16),
                ),
                ButtonSegment(
                  value: ChildcareRuleType.info,
                  label: Text(l10n.childcare_rule_type_info_short),
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
                labelText: l10n.childcare_rule_name,
                hintText: _type == ChildcareRuleType.plus
                    ? l10n.childcare_rule_name_hint_plus
                    : _type == ChildcareRuleType.minus
                    ? l10n.childcare_rule_name_hint_minus
                    : l10n.childcare_rule_name_hint_info,
              ),
              autofocus: true,
            ),
            const SizedBox(height: AppSizes.spaceS),
            TextField(
              controller: _descCtrl,
              decoration:
                  InputDecoration(labelText: l10n.childcare_rule_description),
            ),
            if (_type != ChildcareRuleType.info) ...[
              const SizedBox(height: AppSizes.spaceS),
              TextField(
                controller: _pointsCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: _type == ChildcareRuleType.plus
                      ? l10n.childcare_rule_points_give
                      : l10n.childcare_rule_points_deduct,
                  suffixText: 'P',
                  helperText: _type == ChildcareRuleType.plus
                      ? l10n.childcare_rule_points_give_hint
                      : l10n.childcare_rule_points_deduct_hint,
                ),
              ),
            ],
            if (_errorMsg != null) ...[
              const SizedBox(height: AppSizes.spaceS),
              Text(
                _errorMsg!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.common_cancel),
        ),
        FilledButton(
          onPressed: _isSaving ? null : _handleSave,
          child: Text(isNew ? l10n.common_add : l10n.common_save),
        ),
      ],
    );
  }

  Future<void> _handleSave() async {
    final l10n = AppLocalizations.of(context)!;
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;

    int points = 0;
    if (_type != ChildcareRuleType.info) {
      points = int.tryParse(_pointsCtrl.text.trim()) ?? 0;
      if (points < 0) return;
    }

    setState(() => _isSaving = true);

    final desc = _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim();
    final notifier = widget.ref.read(childcareManagementProvider.notifier);

    final Object? result;
    if (widget.rule == null) {
      result = await notifier.addRule(
        widget.accountId,
        CreateRuleDto(
          name: name,
          description: desc,
          type: _type,
          points: points,
        ),
      );
    } else {
      result = await notifier.updateRule(
        widget.accountId,
        widget.rule!.id,
        UpdateRuleDto(
          name: name,
          description: desc,
          type: _type,
          points: points,
        ),
      );
    }

    if (!mounted) return;

    if (result == null) {
      setState(() {
        _isSaving = false;
        _errorMsg = l10n.childcare_save_failed;
      });
      return;
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.common_saved)));
  }
}
