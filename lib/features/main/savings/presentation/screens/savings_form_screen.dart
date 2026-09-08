import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/home/providers/dashboard_provider.dart';
import 'package:family_planner/features/main/savings/data/models/savings_model.dart';
import 'package:family_planner/features/main/savings/data/repositories/savings_repository.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/core/mixins/interstitial_ad_mixin.dart';
import 'package:family_planner/shared/widgets/form_bottom_bar.dart';

class SavingsFormScreen extends ConsumerStatefulWidget {
  const SavingsFormScreen({super.key, this.groupId, this.goal});

  /// 생성 시 필수
  final String? groupId;

  /// 수정 시 전달
  final SavingsGoalModel? goal;

  @override
  ConsumerState<SavingsFormScreen> createState() => _SavingsFormScreenState();
}

class _SavingsFormScreenState extends ConsumerState<SavingsFormScreen>
    with InterstitialAdMixin {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _targetCtrl;
  late final TextEditingController _monthlyCtrl;
  late final TextEditingController _depositDayCtrl;
  late bool _autoDeposit;
  late bool _includeInAssets;
  bool _loading = false;

  bool get _isEdit => widget.goal != null;

  @override
  void initState() {
    super.initState();
    final g = widget.goal;
    _nameCtrl = TextEditingController(text: g?.name ?? '');
    _descCtrl = TextEditingController(text: g?.description ?? '');
    _targetCtrl = TextEditingController(
      text: g?.targetAmount != null ? g!.targetAmount!.toInt().toString() : '',
    );
    _monthlyCtrl = TextEditingController(
      text: g?.monthlyAmount != null
          ? g!.monthlyAmount!.toInt().toString()
          : '',
    );
    _autoDeposit = g?.autoDeposit ?? false;
    _depositDayCtrl = TextEditingController(
      text: (g?.depositDay ?? 1).toString(),
    );
    _includeInAssets = g?.includeInAssets ?? false;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _targetCtrl.dispose();
    _monthlyCtrl.dispose();
    _depositDayCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      final repo = ref.read(savingsRepositoryProvider);
      final name = _nameCtrl.text.trim();
      final desc = _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim();
      final target = _targetCtrl.text.trim().isEmpty
          ? null
          : double.tryParse(_targetCtrl.text.trim().replaceAll(',', ''));
      final monthly = _autoDeposit && _monthlyCtrl.text.trim().isNotEmpty
          ? double.tryParse(_monthlyCtrl.text.trim().replaceAll(',', ''))
          : null;
      final depositDay = _autoDeposit
          ? (int.tryParse(_depositDayCtrl.text.trim()) ?? 1).clamp(1, 31)
          : 1;

      SavingsGoalModel result;
      if (_isEdit) {
        result = await repo.updateGoal(
          widget.goal!.id,
          name: name,
          description: desc,
          targetAmount: target,
          autoDeposit: _autoDeposit,
          monthlyAmount: monthly,
          depositDay: depositDay,
          includeInAssets: _includeInAssets,
        );
      } else {
        result = await repo.createGoal(
          groupId: widget.groupId!,
          name: name,
          description: desc,
          targetAmount: target,
          autoDeposit: _autoDeposit,
          monthlyAmount: monthly,
          depositDay: depositDay,
          includeInAssets: _includeInAssets,
        );
      }

      if (mounted) {
        ref.invalidate(dashboardSavingsProvider);
        showInterstitialThenNavigate(() {
          if (mounted) Navigator.pop(context, result);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(
          content: Text('${AppLocalizations.of(context)!.savings_form_save_error}\n$e'),
        ));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final groupName = ref
        .watch(myGroupsProvider)
        .whenOrNull(
          data: (groups) =>
              groups.where((g) => g.id == widget.groupId).firstOrNull?.name,
        );

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_isEdit ? l10n.savings_form_title_edit : l10n.savings_form_title_add),
            if (groupName != null)
              Text(
                groupName,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.white70),
              ),
          ],
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(AppSizes.spaceM),
                  children: [
                    // 이름
                    TextFormField(
                      controller: _nameCtrl,
                      decoration: InputDecoration(
                        labelText: l10n.savings_field_name,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? l10n.savings_field_name_required
                          : null,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: AppSizes.spaceM),

                    // 설명
                    TextFormField(
                      controller: _descCtrl,
                      decoration: InputDecoration(
                        labelText: l10n.savings_field_description,
                        border: const OutlineInputBorder(),
                      ),
                      maxLines: 2,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: AppSizes.spaceM),

                    // 목표 금액
                    TextFormField(
                      controller: _targetCtrl,
                      decoration: InputDecoration(
                        labelText: l10n.savings_field_target,
                        border: const OutlineInputBorder(),
                        hintText: l10n.savings_field_target_hint,
                        helperText: l10n.savings_field_target_helper,
                        helperMaxLines: 2,
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return null;
                        final parsed = double.tryParse(
                          v.trim().replaceAll(',', ''),
                        );
                        if (parsed == null || parsed <= 0)
                          return l10n.savings_field_amount_invalid;
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: AppSizes.spaceM),

                    // 자동 적립 스위치
                    Card(
                      margin: EdgeInsets.zero,
                      child: SwitchListTile(
                        title: Text(l10n.savings_auto_deposit),
                        subtitle: Text(l10n.savings_field_auto_deposit_desc),
                        value: _autoDeposit,
                        activeThumbColor: AppColors.investment,
                        onChanged: (v) => setState(() => _autoDeposit = v),
                      ),
                    ),
                    const SizedBox(height: AppSizes.spaceM),

                    // 월 적립금 + 적립일 (autoDeposit=true 시만 표시)
                    AnimatedCrossFade(
                      firstChild: Padding(
                        padding: const EdgeInsets.only(top: AppSizes.spaceXS),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _monthlyCtrl,
                              decoration: InputDecoration(
                                labelText: l10n.savings_field_monthly_amount,
                                border: const OutlineInputBorder(),
                                hintText: l10n.savings_field_monthly_amount_hint,
                              ),
                              keyboardType: TextInputType.number,
                              validator: (v) {
                                if (!_autoDeposit) return null;
                                if (v == null || v.trim().isEmpty)
                                  return l10n.savings_field_monthly_amount_required;
                                final parsed = double.tryParse(
                                  v.trim().replaceAll(',', ''),
                                );
                                if (parsed == null || parsed <= 0)
                                  return l10n.savings_field_amount_invalid;
                                return null;
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: AppSizes.spaceM),
                            TextFormField(
                              controller: _depositDayCtrl,
                              decoration: InputDecoration(
                                labelText: l10n.savings_field_deposit_day,
                                border: const OutlineInputBorder(),
                                hintText: l10n.savings_field_deposit_day_hint,
                                helperText: l10n.savings_field_deposit_day_helper,
                              ),
                              keyboardType: TextInputType.number,
                              validator: (v) {
                                if (!_autoDeposit) return null;
                                final parsed = int.tryParse(v?.trim() ?? '');
                                if (parsed == null ||
                                    parsed < 1 ||
                                    parsed > 31) {
                                  return l10n.savings_field_deposit_day_invalid;
                                }
                                return null;
                              },
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _submit(),
                            ),
                          ],
                        ),
                      ),
                      secondChild: const SizedBox.shrink(),
                      crossFadeState: _autoDeposit
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      duration: const Duration(milliseconds: 200),
                    ),

                    const SizedBox(height: AppSizes.spaceM),

                    // 자산 통계 연동
                    Card(
                      margin: EdgeInsets.zero,
                      child: SwitchListTile(
                        title: Text(l10n.savings_field_include_assets),
                        subtitle: Text(l10n.savings_field_include_assets_desc),
                        value: _includeInAssets,
                        activeThumbColor: AppColors.investment,
                        onChanged: (v) => setState(() => _includeInAssets = v),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            FormBottomBar(
              label: _isEdit ? l10n.savings_form_submit_edit : l10n.savings_goal_add,
              isLoading: _loading,
              onPressed: _submit,
              backgroundColor: AppColors.investment,
              foregroundColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
