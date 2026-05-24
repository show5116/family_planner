import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/features/main/fridge/data/models/fridge_models.dart';
import 'package:family_planner/features/main/fridge/providers/fridge_provider.dart';

// ── 결과 ─────────────────────────────────────────────────────────────────────

class ExpiryReferenceResult {
  final String keyword;
  final StorageType storageType;
  final int days;
  final DateTime suggestedExpiresAt;

  const ExpiryReferenceResult({
    required this.keyword,
    required this.storageType,
    required this.days,
    required this.suggestedExpiresAt,
  });
}

// ── 내부 데이터 클래스 ────────────────────────────────────────────────────────

class _KeywordEntry {
  final String keyword;
  final ExpiryPresetModel preset;

  const _KeywordEntry({required this.keyword, required this.preset});
}

// ── Sheet ────────────────────────────────────────────────────────────────────

class ExpiryReferenceSelectorSheet extends ConsumerStatefulWidget {
  final StorageType currentStorageType;

  const ExpiryReferenceSelectorSheet({
    super.key,
    required this.currentStorageType,
  });

  @override
  ConsumerState<ExpiryReferenceSelectorSheet> createState() =>
      _ExpiryReferenceSelectorSheetState();
}

class _ExpiryReferenceSelectorSheetState
    extends ConsumerState<ExpiryReferenceSelectorSheet> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  String _storageLabel(StorageType type, AppLocalizations l10n) {
    switch (type) {
      case StorageType.fridge:
        return l10n.fridge_storage_type_fridge;
      case StorageType.freezer:
        return l10n.fridge_storage_type_freezer;
      case StorageType.pantry:
        return l10n.fridge_storage_type_pantry;
    }
  }

  // sheetContext: DraggableScrollableSheet builder의 context — 올바른 route를 닫음
  void _selectEntry(BuildContext sheetContext, _KeywordEntry entry) {
    final preset = entry.preset;
    Navigator.pop(
      sheetContext,
      ExpiryReferenceResult(
        keyword: entry.keyword,
        storageType: preset.storageType ?? widget.currentStorageType,
        days: preset.days,
        suggestedExpiresAt: DateTime.now().add(Duration(days: preset.days)),
      ),
    );
  }

  List<_KeywordEntry> _buildEntries(List<ExpiryPresetModel> presets) {
    final entries = <_KeywordEntry>[];
    for (final preset in presets) {
      if (preset.keywords.isEmpty) {
        entries.add(_KeywordEntry(keyword: preset.category, preset: preset));
      } else {
        for (final kw in preset.keywords) {
          entries.add(_KeywordEntry(keyword: kw, preset: preset));
        }
      }
    }
    // storageType 일치 항목 우선, 그 다음 keyword 가나다순
    entries.sort((a, b) {
      final aMatch = a.preset.storageType == widget.currentStorageType;
      final bMatch = b.preset.storageType == widget.currentStorageType;
      if (aMatch && !bMatch) return -1;
      if (!aMatch && bMatch) return 1;
      return a.keyword.compareTo(b.keyword);
    });
    return entries;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final presetsAsync = ref.watch(expiryPresetsProvider);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (sheetContext, scrollController) {
        return Column(
          children: [
            // 핸들
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceS),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // 제목
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spaceM, vertical: AppSizes.spaceXS),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.fridge_expiry_reference_title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(sheetContext);
                      context.push(AppRoutes.fridgeExpiryPresets);
                    },
                    icon: const Icon(Icons.tune, size: 16),
                    label: Text(l10n.fridge_preset_edit_shortcut),
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(sheetContext),
                  ),
                ],
              ),
            ),
            // 검색
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceM),
              child: TextField(
                controller: _searchCtrl,
                decoration: InputDecoration(
                  hintText: l10n.fridge_expiry_reference_search,
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
            const SizedBox(height: AppSizes.spaceS),
            // 목록
            Expanded(
              child: presetsAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (_, _) => const SizedBox.shrink(),
                data: (presets) {
                  final all = _buildEntries(presets);
                  final q = _query.toLowerCase();
                  final filtered = q.isEmpty
                      ? all
                      : all
                          .where((e) =>
                              e.keyword.toLowerCase().contains(q))
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
                    controller: scrollController,
                    padding: EdgeInsets.zero,
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) =>
                        const Divider(height: 1, indent: 16, endIndent: 16),
                    itemBuilder: (_, index) {
                      final entry = filtered[index];
                      final highlighted =
                          entry.preset.storageType == widget.currentStorageType;
                      final storageLabel = entry.preset.storageType != null
                          ? _storageLabel(entry.preset.storageType!, l10n)
                          : null;
                      final subtitle = storageLabel != null
                          ? '$storageLabel · ${l10n.fridge_expiry_reference_days(entry.preset.days)}'
                          : l10n.fridge_expiry_reference_days(entry.preset.days);

                      return ListTile(
                        onTap: () => _selectEntry(sheetContext, entry),
                        title: Text(entry.keyword),
                        subtitle: Text(subtitle),
                        trailing: highlighted
                            ? Icon(Icons.check_circle,
                                color: Theme.of(context).colorScheme.primary,
                                size: 18)
                            : null,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
