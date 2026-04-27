import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/assets/data/models/account_model.dart';
import 'package:family_planner/features/main/assets/utils/asset_utils.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 자산 통계 - 계좌 필터 바텀시트
class AssetAccountFilterSheet extends StatefulWidget {
  const AssetAccountFilterSheet({
    super.key,
    required this.accounts,
    required this.selectedIds,
    required this.onApply,
  });

  final List<AccountModel> accounts;
  final Set<String> selectedIds; // 빈 Set = 전체
  final void Function(Set<String> selectedIds) onApply;

  @override
  State<AssetAccountFilterSheet> createState() => _AssetAccountFilterSheetState();
}

class _AssetAccountFilterSheetState extends State<AssetAccountFilterSheet> {
  late Set<String> _selectedIds;

  @override
  void initState() {
    super.initState();
    _selectedIds = Set<String>.from(widget.selectedIds);
  }

  bool get _isAll => _selectedIds.isEmpty;

  void _toggleAll() {
    setState(() => _selectedIds = {});
  }

  void _toggle(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
        // 전부 해제되면 전체로 복귀
        if (_selectedIds.isEmpty) _selectedIds = {};
      } else {
        _selectedIds.add(id);
        // 전부 선택되면 전체로 표시
        if (_selectedIds.length == widget.accounts.length) _selectedIds = {};
      }
    });
  }

  bool _isSelected(String id) => _isAll || _selectedIds.contains(id);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.85,
      builder: (_, scrollController) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          children: [
            // 드래그 핸들
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: AppSizes.spaceM),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.spaceL, AppSizes.spaceM, AppSizes.spaceL, AppSizes.spaceS,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(l10n.asset_stat_account_filter,
                    style: Theme.of(context).textTheme.titleLarge),
              ),
            ),
            const Divider(),

            // 스크롤 가능한 계좌 목록
            Flexible(
              child: ListView(
                controller: scrollController,
                shrinkWrap: true,
                children: [
                  // 전체 선택
                  CheckboxListTile(
                    title: Text(l10n.asset_stat_filter_all),
                    value: _isAll,
                    onChanged: (_) => _toggleAll(),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),

                  // 계좌 목록
                  ...widget.accounts.map((account) {
                    final typeLabel = accountTypeLabel(l10n, account.type);
                    return CheckboxListTile(
                      title: Text(account.name),
                      subtitle: Row(
                        children: [
                          Icon(
                            accountTypeIcon(account.type),
                            size: 13,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            typeLabel,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                          ),
                        ],
                      ),
                      value: _isSelected(account.id),
                      onChanged: (_) => _toggle(account.id),
                      controlAffinity: ListTileControlAffinity.leading,
                    );
                  }),
                ],
              ),
            ),

            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.spaceL, AppSizes.spaceS, AppSizes.spaceL, AppSizes.spaceL,
              ),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => widget.onApply(_selectedIds),
                  child: Text(l10n.common_apply),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
