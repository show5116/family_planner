import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/shared/widgets/emoji_data/emoji_dataset.dart';
import 'package:family_planner/shared/widgets/emoji_data/emoji_entry.dart';
import 'package:family_planner/shared/widgets/emoji_data/recent_emoji_store.dart';

const _gridColumns = 8;
const _cellExtent = 48.0;
const _headerHeight = 32.0;

/// 최근 사용 섹션을 가리키는 가상 카테고리 인덱스 (EmojiCategory.index와 겹치지 않음)
const _recentSectionIndex = -1;

IconData _categoryIcon(EmojiCategory category) {
  switch (category) {
    case EmojiCategory.smileys:
      return Icons.emoji_emotions_outlined;
    case EmojiCategory.animals:
      return Icons.pets_outlined;
    case EmojiCategory.foods:
      return Icons.restaurant_outlined;
    case EmojiCategory.travel:
      return Icons.flight_outlined;
    case EmojiCategory.activities:
      return Icons.sports_soccer_outlined;
    case EmojiCategory.objects:
      return Icons.lightbulb_outline;
    case EmojiCategory.symbols:
      return Icons.tag_outlined;
    case EmojiCategory.flags:
      return Icons.flag_outlined;
  }
}

String _categoryLabel(AppLocalizations l10n, EmojiCategory category) {
  switch (category) {
    case EmojiCategory.smileys:
      return l10n.emoji_picker_category_smileys;
    case EmojiCategory.animals:
      return l10n.emoji_picker_category_animals;
    case EmojiCategory.foods:
      return l10n.emoji_picker_category_foods;
    case EmojiCategory.travel:
      return l10n.emoji_picker_category_travel;
    case EmojiCategory.activities:
      return l10n.emoji_picker_category_activities;
    case EmojiCategory.objects:
      return l10n.emoji_picker_category_objects;
    case EmojiCategory.symbols:
      return l10n.emoji_picker_category_symbols;
    case EmojiCategory.flags:
      return l10n.emoji_picker_category_flags;
  }
}

class _Section {
  const _Section({
    required this.label,
    required this.categoryIndex,
    required this.chars,
  });

  final String label;
  final int categoryIndex;
  final List<String> chars;
}

/// 검색 + 카테고리 탐색 + 그리드로 전체 이모지를 고르는 시트 본문.
/// 선택 시 [onSelected]가 호출된다.
class EmojiPickerSheet extends StatefulWidget {
  const EmojiPickerSheet({
    super.key,
    required this.onSelected,
    required this.scrollController,
  });

  final ValueChanged<String> onSelected;
  final ScrollController scrollController;

  @override
  State<EmojiPickerSheet> createState() => _EmojiPickerSheetState();
}

class _EmojiPickerSheetState extends State<EmojiPickerSheet> {
  final _searchController = TextEditingController();
  List<String> _recent = const [];
  String _query = '';

  @override
  void initState() {
    super.initState();
    RecentEmojiStore.load().then((value) {
      if (mounted) setState(() => _recent = value);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _select(String emoji) async {
    final updated = await RecentEmojiStore.add(emoji);
    if (mounted) setState(() => _recent = updated);
    widget.onSelected(emoji);
  }

  List<_Section> _buildSections(
    AppLocalizations l10n,
    List<EmojiEntry> entries,
  ) {
    final sections = <_Section>[];
    if (_query.isEmpty && _recent.isNotEmpty) {
      sections.add(
        _Section(
          label: l10n.emoji_picker_category_recent,
          categoryIndex: _recentSectionIndex,
          chars: _recent,
        ),
      );
    }
    for (final category in EmojiCategory.values) {
      final chars = entries
          .where((e) => e.category == category)
          .map((e) => e.char)
          .toList();
      if (chars.isEmpty) continue;
      sections.add(
        _Section(
          label: _categoryLabel(l10n, category),
          categoryIndex: category.index,
          chars: chars,
        ),
      );
    }
    return sections;
  }

  Map<int, double> _computeOffsets(List<_Section> sections) {
    var runningOffset = 0.0;
    final offsets = <int, double>{};
    for (final section in sections) {
      offsets[section.categoryIndex] = runningOffset;
      final rows = (section.chars.length / _gridColumns).ceil();
      runningOffset += _headerHeight + rows * _cellExtent;
    }
    return offsets;
  }

  void _scrollToCategory(int categoryIndex, Map<int, double> offsets) {
    final offset = offsets[categoryIndex];
    if (offset == null) return;
    widget.scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final languageCode = Localizations.localeOf(context).languageCode;

    final filtered = _query.isEmpty
        ? emojiDataset
        : emojiDataset.where((e) => e.matches(_query, languageCode)).toList();
    final sections = _buildSections(l10n, filtered);
    final offsets = _computeOffsets(sections);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.spaceM,
            AppSizes.spaceS,
            AppSizes.spaceM,
            AppSizes.spaceS,
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (value) => setState(() => _query = value),
            decoration: InputDecoration(
              hintText: l10n.emoji_picker_search_hint,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _query.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => setState(() {
                        _searchController.clear();
                        _query = '';
                      }),
                    )
                  : null,
              isDense: true,
            ),
          ),
        ),
        if (_query.isEmpty)
          _CategoryBar(
            hasRecent: _recent.isNotEmpty,
            onCategoryTap: (categoryIndex) =>
                _scrollToCategory(categoryIndex, offsets),
          ),
        Expanded(
          child: sections.isEmpty
              ? Center(child: Text(l10n.emoji_picker_no_result))
              : _EmojiGrid(
                  sections: sections,
                  scrollController: widget.scrollController,
                  onSelected: _select,
                ),
        ),
      ],
    );
  }
}

class _CategoryBar extends StatelessWidget {
  const _CategoryBar({required this.hasRecent, required this.onCategoryTap});

  final bool hasRecent;
  final ValueChanged<int> onCategoryTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceXS),
      child: Row(
        children: [
          if (hasRecent)
            Expanded(
              child: Tooltip(
                message: l10n.emoji_picker_category_recent,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    Icons.history,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  onPressed: () => onCategoryTap(_recentSectionIndex),
                ),
              ),
            ),
          for (final category in EmojiCategory.values)
            Expanded(
              child: Tooltip(
                message: _categoryLabel(l10n, category),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    _categoryIcon(category),
                    color: colorScheme.onSurfaceVariant,
                  ),
                  onPressed: () => onCategoryTap(category.index),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EmojiGrid extends StatelessWidget {
  const _EmojiGrid({
    required this.sections,
    required this.scrollController,
    required this.onSelected,
  });

  final List<_Section> sections;
  final ScrollController scrollController;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return CustomScrollView(
      controller: scrollController,
      slivers: [
        for (final section in sections) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.spaceM,
                AppSizes.spaceS,
                AppSizes.spaceM,
                AppSizes.spaceXS,
              ),
              child: Text(
                section.label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceS),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _gridColumns,
              ),
              delegate: SliverChildBuilderDelegate((context, i) {
                final char = section.chars[i];
                return InkWell(
                  borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                  onTap: () => onSelected(char),
                  child: Center(
                    child: Text(char, style: const TextStyle(fontSize: 24)),
                  ),
                );
              }, childCount: section.chars.length),
            ),
          ),
        ],
      ],
    );
  }
}
