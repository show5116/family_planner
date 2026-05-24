import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/main/fridge/data/models/fridge_models.dart';
import 'package:family_planner/features/main/fridge/providers/fridge_provider.dart';

// ── 내부 데이터 클래스 ────────────────────────────────────────────────────────
// keyword가 없는 preset은 category 자체를 keyword로 사용하여 행 하나씩 표시

class _PresetEntry {
  final String keyword; // 표시 이름
  final ExpiryPresetModel preset;

  const _PresetEntry({required this.keyword, required this.preset});
}

// ── 화면 ──────────────────────────────────────────────────────────────────────

class ExpiryPresetManagementScreen extends ConsumerStatefulWidget {
  const ExpiryPresetManagementScreen({super.key});

  @override
  ConsumerState<ExpiryPresetManagementScreen> createState() =>
      _ExpiryPresetManagementScreenState();
}

class _ExpiryPresetManagementScreenState
    extends ConsumerState<ExpiryPresetManagementScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  String _storageLabel(StorageType? type, AppLocalizations l10n) {
    switch (type) {
      case StorageType.fridge:
        return l10n.fridge_storage_type_fridge;
      case StorageType.freezer:
        return l10n.fridge_storage_type_freezer;
      case StorageType.pantry:
        return l10n.fridge_storage_type_pantry;
      case null:
        return '—';
    }
  }

  List<_PresetEntry> _buildEntries(List<ExpiryPresetModel> presets) {
    final entries = <_PresetEntry>[];
    for (final p in presets) {
      if (p.keywords.isEmpty) {
        entries.add(_PresetEntry(keyword: p.category, preset: p));
      } else {
        for (final kw in p.keywords) {
          entries.add(_PresetEntry(keyword: kw, preset: p));
        }
      }
    }
    entries.sort((a, b) => a.keyword.compareTo(b.keyword));
    return entries;
  }

  Future<void> _showUpsertDialog(
      BuildContext context, ExpiryPresetModel preset) async {
    final l10n = AppLocalizations.of(context)!;
    final daysCtrl = TextEditingController(text: preset.days.toString());

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.fridge_preset_edit_dialog_title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${preset.category}  ·  ${_storageLabel(preset.storageType, l10n)}',
              style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(ctx).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: AppSizes.spaceM),
            TextField(
              controller: daysCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: l10n.fridge_preset_days_input_label,
                suffixText: '일',
              ),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.common_cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.common_save),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;
    final days = int.tryParse(daysCtrl.text);
    if (days == null || days <= 0) return;

    final groupId = ref.read(fridgeSelectedGroupIdProvider);
    if (groupId == null) return;

    await ref.read(expiryPresetsProvider.notifier).upsert(
          UpsertExpiryPresetDto(
            groupId: groupId,
            category: preset.category,
            storageType: preset.storageType,
            customDays: days,
          ),
        );
  }

  Future<void> _showAddDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final categoryCtrl = TextEditingController();
    final daysCtrl = TextEditingController();
    StorageType? selectedStorage;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setInner) => AlertDialog(
          title: Text(l10n.fridge_preset_add_dialog_title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: categoryCtrl,
                decoration: InputDecoration(
                  labelText: l10n.fridge_preset_category_input_label,
                ),
                autofocus: true,
              ),
              const SizedBox(height: AppSizes.spaceM),
              DropdownButtonFormField<StorageType?>(
                initialValue: selectedStorage,
                decoration: InputDecoration(
                  labelText: l10n.fridge_preset_storage_type_label,
                ),
                items: [
                  DropdownMenuItem(
                    value: null,
                    child: Text('— (${l10n.fridge_storage_type_fridge} / ${l10n.fridge_storage_type_freezer} / ${l10n.fridge_storage_type_pantry})'),
                  ),
                  DropdownMenuItem(
                    value: StorageType.fridge,
                    child: Text(l10n.fridge_storage_type_fridge),
                  ),
                  DropdownMenuItem(
                    value: StorageType.freezer,
                    child: Text(l10n.fridge_storage_type_freezer),
                  ),
                  DropdownMenuItem(
                    value: StorageType.pantry,
                    child: Text(l10n.fridge_storage_type_pantry),
                  ),
                ],
                onChanged: (v) => setInner(() => selectedStorage = v),
              ),
              const SizedBox(height: AppSizes.spaceM),
              TextField(
                controller: daysCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: l10n.fridge_preset_days_input_label,
                  suffixText: '일',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l10n.common_cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(l10n.common_save),
            ),
          ],
        ),
      ),
    );

    if (confirmed != true || !context.mounted) return;
    final category = categoryCtrl.text.trim();
    final days = int.tryParse(daysCtrl.text);
    if (category.isEmpty || days == null || days <= 0) return;

    final groupId = ref.read(fridgeSelectedGroupIdProvider);
    if (groupId == null) return;

    await ref.read(expiryPresetsProvider.notifier).upsert(
          UpsertExpiryPresetDto(
            groupId: groupId,
            category: category,
            storageType: selectedStorage,
            customDays: days,
          ),
        );
  }

  Future<void> _deletePreset(
      BuildContext context, ExpiryPresetModel preset) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text(l10n.fridge_preset_delete_confirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.common_cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.common_delete),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await ref
        .read(expiryPresetsProvider.notifier)
        .delete(preset.customPresetId!);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final presetsAsync = ref.watch(expiryPresetsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.fridge_preset_management_title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // 검색창
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSizes.spaceM, AppSizes.spaceS, AppSizes.spaceM, AppSizes.spaceXS),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: l10n.fridge_preset_search_hint,
                prefixIcon: const Icon(Icons.search),
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.spaceM, vertical: AppSizes.spaceS),
              ),
              onChanged: (v) => setState(() => _query = v.trim()),
            ),
          ),
          // 목록
          Expanded(
            child: presetsAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(e.toString())),
              data: (presets) {
                final all = _buildEntries(presets);
                final q = _query.toLowerCase();
                final filtered = q.isEmpty
                    ? all
                    : all
                        .where((e) =>
                            e.keyword.toLowerCase().contains(q) ||
                            e.preset.category.toLowerCase().contains(q))
                        .toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Text(
                      l10n.fridge_expiry_reference_empty,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.only(bottom: 88),
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) =>
                      const Divider(height: 1, indent: 16, endIndent: 16),
                  itemBuilder: (_, index) {
                    final entry = filtered[index];
                    final preset = entry.preset;
                    final colorScheme = Theme.of(context).colorScheme;

                    return ListTile(
                      onTap: () => _showUpsertDialog(context, preset),
                      title: Row(
                        children: [
                          Text(entry.keyword),
                          if (entry.keyword != preset.category) ...[
                            const SizedBox(width: 4),
                            Text(
                              '(${preset.category})',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: colorScheme.outline,
                                  ),
                            ),
                          ],
                          if (preset.isCustom) ...[
                            const SizedBox(width: AppSizes.spaceXS),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: colorScheme.tertiaryContainer,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                l10n.fridge_preset_custom_badge,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: colorScheme.onTertiaryContainer,
                                    ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      subtitle: Text(
                        '${_storageLabel(preset.storageType, l10n)}  ·  ${l10n.fridge_preset_days_label(preset.days)}',
                      ),
                      trailing: preset.isCustom
                          ? IconButton(
                              icon: Icon(Icons.delete_outline,
                                  size: 20, color: colorScheme.error),
                              onPressed: () => _deletePreset(context, preset),
                              tooltip: l10n.common_delete,
                            )
                          : const Icon(Icons.chevron_right, size: 20),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
