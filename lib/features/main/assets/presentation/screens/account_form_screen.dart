import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/assets/data/models/account_model.dart';
import 'package:family_planner/features/main/assets/providers/asset_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

class AccountFormScreen extends ConsumerStatefulWidget {
  final String? groupId;
  final AccountModel? account;

  const AccountFormScreen({super.key, this.groupId, this.account});

  @override
  ConsumerState<AccountFormScreen> createState() => _AccountFormScreenState();
}

class _AccountFormScreenState extends ConsumerState<AccountFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _institutionController;
  late final TextEditingController _accountNumberController;
  AccountType? _selectedType;

  bool get _isEdit => widget.account != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.account?.name ?? '');
    _institutionController =
        TextEditingController(text: widget.account?.institution ?? '');
    _accountNumberController =
        TextEditingController(text: widget.account?.accountNumber ?? '');
    _selectedType = widget.account?.type;
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

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(_isEdit ? l10n.asset_edit_account : l10n.asset_add_account),
      ),
      body: Form(
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

            // 금융기관
            TextFormField(
              controller: _institutionController,
              decoration: InputDecoration(
                labelText: l10n.asset_institution,
                hintText: l10n.asset_institution_hint,
                border: const OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? l10n.asset_institution_required : null,
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
            DropdownButtonFormField<AccountType?>(
              initialValue: _selectedType,
              decoration: InputDecoration(
                labelText: l10n.asset_account_type,
                border: const OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(
                  value: null,
                  child: Text(l10n.asset_type_other),
                ),
                DropdownMenuItem(
                  value: AccountType.bank,
                  child: Text(l10n.asset_type_bank),
                ),
                DropdownMenuItem(
                  value: AccountType.stock,
                  child: Text(l10n.asset_type_stock),
                ),
                DropdownMenuItem(
                  value: AccountType.fund,
                  child: Text(l10n.asset_type_fund),
                ),
                DropdownMenuItem(
                  value: AccountType.insurance,
                  child: Text(l10n.asset_type_insurance),
                ),
                DropdownMenuItem(
                  value: AccountType.realEstate,
                  child: Text(l10n.asset_type_real_estate),
                ),
                DropdownMenuItem(
                  value: AccountType.cash,
                  child: Text(l10n.asset_type_cash),
                ),
              ],
              onChanged: (v) => setState(() => _selectedType = v),
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
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context)!;
    final name = _nameController.text.trim();
    final institution = _institutionController.text.trim();
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
            ),
          );
    }

    if (!mounted) return;

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.asset_save_success)),
      );
      Navigator.of(context).pop(result);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.common_error)),
      );
    }
  }
}
