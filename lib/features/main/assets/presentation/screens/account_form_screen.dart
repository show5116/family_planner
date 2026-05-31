import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/assets/data/models/account_model.dart';
import 'package:family_planner/features/main/assets/providers/asset_provider.dart';
import 'package:family_planner/features/main/assets/utils/asset_utils.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/core/mixins/interstitial_ad_mixin.dart';

class AccountFormScreen extends ConsumerStatefulWidget {
  final String? groupId;
  final AccountModel? account;

  const AccountFormScreen({super.key, this.groupId, this.account});

  @override
  ConsumerState<AccountFormScreen> createState() => _AccountFormScreenState();
}

class _AccountFormScreenState extends ConsumerState<AccountFormScreen>
    with InterstitialAdMixin {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _institutionController;
  late final TextEditingController _accountNumberController;
  AccountType _selectedType = AccountType.savings;
  int? _reminderDay;

  bool get _isEdit => widget.account != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.account?.name ?? '');
    _institutionController =
        TextEditingController(text: widget.account?.institution ?? '');
    _accountNumberController =
        TextEditingController(text: widget.account?.accountNumber ?? '');
    _selectedType = widget.account?.type ?? AccountType.savings;
    _reminderDay = widget.account?.recordReminderDay;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _institutionController.dispose();
    _accountNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final managementState = ref.watch(assetManagementProvider);
    final effectiveGroupId = widget.groupId ?? ref.watch(assetSelectedGroupIdProvider);
    final groupName = ref.watch(myGroupsProvider).whenOrNull(
      data: (groups) => groups.where((g) => g.id == effectiveGroupId).firstOrNull?.name,
    );

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_isEdit ? l10n.asset_edit_account : l10n.asset_add_account),
            if (groupName != null)
              Text(
                groupName,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
              ),
          ],
        ),
      ),
      body: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSizes.spaceM),
            children: [
              // 계좌명
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l10n.asset_account_name,
                  hintText: l10n.asset_account_name_hint,
                  border: const OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? l10n.asset_account_name_required : null,
              ),
              const SizedBox(height: AppSizes.spaceM),

              // 금융기관 (선택)
              TextFormField(
                controller: _institutionController,
                decoration: InputDecoration(
                  labelText: '${l10n.asset_institution} (${l10n.common_optional})',
                  hintText: l10n.asset_institution_hint,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppSizes.spaceM),

              // 계좌번호 (선택)
              TextFormField(
                controller: _accountNumberController,
                decoration: InputDecoration(
                  labelText: l10n.asset_account_number,
                  hintText: l10n.asset_account_number_hint,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppSizes.spaceM),

              // 계좌 유형
              DropdownButtonFormField<AccountType>(
                initialValue: _selectedType,
                decoration: InputDecoration(
                  labelText: l10n.asset_account_type,
                  border: const OutlineInputBorder(),
                ),
                items: AccountType.values
                    .map((t) => DropdownMenuItem(
                          value: t,
                          child: Text(accountTypeLabel(l10n, t)),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _selectedType = v ?? AccountType.savings),
              ),
              const SizedBox(height: AppSizes.spaceM),

              // 알림 일자
              _ReminderDayField(
                value: _reminderDay,
                onChanged: (v) => setState(() => _reminderDay = v),
              ),
              const SizedBox(height: AppSizes.spaceL),

              // 저장 버튼
              ElevatedButton(
                onPressed: managementState.isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                child: managementState.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.common_save),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context)!;
    final name = _nameController.text.trim();
    final institutionRaw = _institutionController.text.trim();
    final institution = institutionRaw.isEmpty ? null : institutionRaw;
    final accountNumber = _accountNumberController.text.trim();

    AccountModel? result;

    if (_isEdit) {
      result = await ref.read(assetManagementProvider.notifier).updateAccount(
            widget.account!.id,
            UpdateAccountDto(
              name: name,
              institution: institution,
              accountNumber: accountNumber.isEmpty ? null : accountNumber,
              type: _selectedType,
              recordReminderDay: _reminderDay,
              clearReminderDay: _reminderDay == null,
            ),
          );
    } else {
      final groupId =
          widget.groupId ?? ref.read(assetSelectedGroupIdProvider);
      if (groupId == null) return;

      result = await ref.read(assetManagementProvider.notifier).createAccount(
            CreateAccountDto(
              groupId: groupId,
              name: name,
              institution: institution,
              accountNumber: accountNumber.isEmpty ? null : accountNumber,
              type: _selectedType,
              recordReminderDay: _reminderDay,
            ),
          );
    }

    if (!mounted) return;

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.asset_save_success)),
      );
      showInterstitialThenNavigate(() {
        if (mounted) Navigator.of(context).pop(result);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.common_error)),
      );
    }
  }
}

// ─── 알림 일자 선택 위젯 ──────────────────────────────────────────────────────
class _ReminderDayField extends StatelessWidget {
  final int? value;
  final ValueChanged<int?> onChanged;

  const _ReminderDayField({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final isEnabled = value != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 헤더 + 토글
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '기록 알림',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '매월 지정한 날짜에 자산 기록 입력 알림을 보내드립니다.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                ],
              ),
            ),
            Switch(
              value: isEnabled,
              onChanged: (on) => onChanged(on ? 1 : null),
            ),
          ],
        ),

        // 일자 선택 (활성화 시에만 표시)
        if (isEnabled) ...[
          const SizedBox(height: AppSizes.spaceS),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spaceM,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.outline),
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_month_outlined,
                  size: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: AppSizes.spaceS),
                Text(
                  '알림 날짜',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                ),
                const SizedBox(width: AppSizes.spaceS),
                Expanded(
                  child: DropdownButton<int>(
                    value: value,
                    isExpanded: true,
                    underline: const SizedBox(),
                    items: List.generate(
                      31,
                      (i) => DropdownMenuItem(
                        value: i + 1,
                        child: Text('매월 ${i + 1}일'),
                      ),
                    ),
                    onChanged: onChanged,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.spaceXS),
          Text(
            '29~31일은 해당 월에 없는 경우 말일에 발송됩니다.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
        ],
      ],
    );
  }
}
