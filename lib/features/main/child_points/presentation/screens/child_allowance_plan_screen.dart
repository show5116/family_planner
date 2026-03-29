import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/child_points/data/models/childcare_model.dart';
import 'package:family_planner/features/main/child_points/data/repositories/childcare_repository.dart';
import 'package:family_planner/features/main/child_points/providers/childcare_provider.dart';

/// 용돈 플랜 설정 화면 (월 포인트, 지급일, 포인트:원 비율, 다음 협상일)
class ChildAllowancePlanScreen extends ConsumerStatefulWidget {
  const ChildAllowancePlanScreen({super.key, required this.childId});

  final String childId;

  @override
  ConsumerState<ChildAllowancePlanScreen> createState() =>
      _ChildAllowancePlanScreenState();
}

class _ChildAllowancePlanScreenState
    extends ConsumerState<ChildAllowancePlanScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final planAsync = ref.watch(childcareAllowancePlanProvider);
    final childrenAsync = ref.watch(childcareChildrenProvider);

    final childName = childrenAsync.maybeWhen(
      data: (children) {
        try {
          return children.firstWhere((c) => c.id == widget.childId).name;
        } catch (_) {
          return null;
        }
      },
      orElse: () => null,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('${childName ?? '자녀'} 용돈 플랜'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).colorScheme.onPrimary,
          unselectedLabelColor:
              Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.6),
          indicatorColor: Theme.of(context).colorScheme.onPrimary,
          tabs: const [
            Tab(text: '설정'),
            Tab(text: '변경 히스토리'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          planAsync.when(
            data: (plan) => _PlanForm(childId: widget.childId, plan: plan),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => _PlanForm(childId: widget.childId, plan: null),
          ),
          _HistoryTab(childId: widget.childId),
        ],
      ),
    );
  }
}

// ── 플랜 설정 폼 ──────────────────────────────────────────────────────────────

class _PlanForm extends ConsumerStatefulWidget {
  const _PlanForm({required this.childId, required this.plan});

  final String childId;
  final AllowancePlan? plan;

  @override
  ConsumerState<_PlanForm> createState() => _PlanFormState();
}

class _PlanFormState extends ConsumerState<_PlanForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _monthlyPointsController;
  late final TextEditingController _payDayController;
  late final TextEditingController _ratioController;
  DateTime? _nextNegotiationDate;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final plan = widget.plan;
    _monthlyPointsController = TextEditingController(
      text: plan != null ? plan.monthlyPoints.toString() : '',
    );
    _payDayController = TextEditingController(
      text: plan != null ? plan.payDay.toString() : '1',
    );
    _ratioController = TextEditingController(
      text: plan != null ? plan.pointToMoneyRatio.toString() : '10',
    );
    _nextNegotiationDate = plan?.nextNegotiationDate;
  }

  @override
  void dispose() {
    _monthlyPointsController.dispose();
    _payDayController.dispose();
    _ratioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.spaceM),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.plan != null) ...[
              _InfoCard(plan: widget.plan!),
              const SizedBox(height: AppSizes.spaceL),
            ],
            Text(
              widget.plan == null ? '용돈 플랜 설정' : '용돈 플랜 수정',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppSizes.spaceM),
            TextFormField(
              controller: _monthlyPointsController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: '월 지급 포인트',
                hintText: '예: 100',
                prefixIcon: Icon(Icons.monetization_on_outlined),
                suffixText: 'P',
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return '월 지급 포인트를 입력해주세요';
                if (int.tryParse(v.trim()) == null) return '숫자를 입력해주세요';
                return null;
              },
            ),
            const SizedBox(height: AppSizes.spaceM),
            InkWell(
              onTap: _selectPayDay,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: '매달 지급일',
                  prefixIcon: const Icon(Icons.calendar_today_outlined),
                  suffixText: '일',
                  helperText: int.tryParse(_payDayController.text) != null &&
                          int.parse(_payDayController.text) > 28
                      ? '해당 월에 선택한 날짜가 없으면 말일에 지급됩니다'
                      : null,
                  helperMaxLines: 2,
                ),
                child: Text(
                  _payDayController.text.isNotEmpty
                      ? '${_payDayController.text}일'
                      : '날짜를 선택하세요',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            const SizedBox(height: AppSizes.spaceM),
            TextFormField(
              controller: _ratioController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: '1포인트 = N원',
                hintText: '예: 10',
                prefixIcon: Icon(Icons.swap_horiz),
                suffixText: '원',
                helperText: '아이와의 약속을 명확히 하기 위한 표시용입니다',
              ),
              validator: (v) {
                final n = int.tryParse(v?.trim() ?? '');
                if (n == null || n < 1) return '1 이상의 숫자를 입력해주세요';
                return null;
              },
            ),
            const SizedBox(height: AppSizes.spaceM),
            InputDecorator(
              decoration: InputDecoration(
                labelText: '다음 연봉 협상일 (선택)',
                prefixIcon: const Icon(Icons.handshake_outlined),
                suffixIcon: _nextNegotiationDate != null
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        iconSize: AppSizes.iconSmall,
                        onPressed: () =>
                            setState(() => _nextNegotiationDate = null),
                      )
                    : null,
              ),
              child: InkWell(
                onTap: _selectNegotiationDate,
                child: Row(
                  children: [
                    Text(
                      _nextNegotiationDate != null
                          ? DateFormat('yyyy-MM-dd')
                              .format(_nextNegotiationDate!)
                          : '날짜를 선택하세요 (선택)',
                      style: _nextNegotiationDate != null
                          ? Theme.of(context).textTheme.bodyMedium
                          : Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).hintColor,
                              ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSizes.spaceXL),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isSubmitting ? null : _handleSubmit,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(widget.plan == null ? '플랜 설정' : '플랜 수정'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectPayDay() async {
    final current = int.tryParse(_payDayController.text) ?? 1;
    final picked = await showModalBottomSheet<int>(
      context: context,
      builder: (_) => _DayPicker(initial: current),
    );
    if (picked != null) {
      setState(() => _payDayController.text = picked.toString());
    }
  }

  Future<void> _selectNegotiationDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _nextNegotiationDate ?? DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _nextNegotiationDate = picked);
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final dto = UpsertAllowancePlanDto(
      monthlyPoints: int.parse(_monthlyPointsController.text.trim()),
      payDay: int.parse(_payDayController.text.trim()),
      pointToMoneyRatio: int.parse(_ratioController.text.trim()),
      nextNegotiationDate: _nextNegotiationDate != null
          ? DateFormat('yyyy-MM-dd').format(_nextNegotiationDate!)
          : null,
    );

    final result = await ref
        .read(childcareManagementProvider.notifier)
        .upsertAllowancePlan(widget.childId, dto);

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('용돈 플랜이 저장되었습니다')),
      );
    }
  }
}

// ── 현재 플랜 요약 카드 ────────────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.plan});

  final AllowancePlan plan;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '현재 용돈 플랜',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                  ),
            ),
            const SizedBox(height: AppSizes.spaceS),
            _Row(label: '월 지급', value: '${plan.monthlyPoints}P'),
            _Row(label: '지급일', value: '매월 ${plan.payDay}일'),
            _Row(
                label: '1P =',
                value: '${plan.pointToMoneyRatio}원'),
            if (plan.nextNegotiationDate != null)
              _Row(
                label: '다음 협상일',
                value: DateFormat('yyyy.MM.dd')
                    .format(plan.nextNegotiationDate!),
              ),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

// ── 히스토리 탭 ───────────────────────────────────────────────────────────────

class _HistoryTab extends ConsumerWidget {
  const _HistoryTab({required this.childId});

  final String childId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(childcareAllowancePlanHistoryProvider);

    return historyAsync.when(
      data: (history) {
        if (history.isEmpty) {
          return const Center(
            child: Text('변경 히스토리가 없습니다'),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          itemCount: history.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final h = history[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor:
                    Theme.of(context).colorScheme.secondaryContainer,
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    color:
                        Theme.of(context).colorScheme.onSecondaryContainer,
                    fontSize: 12,
                  ),
                ),
              ),
              title: Text('${h.monthlyPoints}P / 매월 ${h.payDay}일'),
              subtitle: Text(
                '1P = ${h.pointToMoneyRatio}원'
                '${h.nextNegotiationDate != null ? ' · 협상일 ${DateFormat('yy.MM.dd').format(h.nextNegotiationDate!)}' : ''}',
              ),
              trailing: Text(
                DateFormat('yy.MM.dd').format(h.changedAt),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => const Center(child: Text('히스토리를 불러올 수 없습니다')),
    );
  }
}

// ── 매달 지급일 드럼 롤 Picker ─────────────────────────────────────────────────

class _DayPicker extends StatefulWidget {
  const _DayPicker({required this.initial});

  final int initial;

  @override
  State<_DayPicker> createState() => _DayPickerState();
}

class _DayPickerState extends State<_DayPicker> {
  late int _day;
  late final FixedExtentScrollController _ctrl;

  @override
  void initState() {
    super.initState();
    _day = widget.initial.clamp(1, 31);
    _ctrl = FixedExtentScrollController(initialItem: _day - 1);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spaceM,
              vertical: AppSizes.spaceS,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('취소'),
                ),
                Text(
                  '매달 $_day일',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(_day),
                  child: const Text('확인'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          SizedBox(
            height: 200,
            child: ListWheelScrollView.useDelegate(
              controller: _ctrl,
              itemExtent: 44,
              diameterRatio: 1.4,
              physics: const FixedExtentScrollPhysics(),
              onSelectedItemChanged: (i) => setState(() => _day = i + 1),
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: 31,
                builder: (context, index) {
                  final isSelected = _day == index + 1;
                  return GestureDetector(
                    onTap: isSelected
                        ? null
                        : () => _ctrl.animateToItem(
                              index,
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeOut,
                            ),
                    child: Center(
                      child: Text(
                        '${index + 1}일',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: isSelected ? colorScheme.primary : null,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
