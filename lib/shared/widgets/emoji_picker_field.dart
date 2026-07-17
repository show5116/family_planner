import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/shared/widgets/emoji_data/emoji_picker_sheet.dart';

/// 자주 쓰이는 이모지 프리셋 + "전체 이모지" 바텀시트 진입점을 함께 제공하는
/// 공용 이모지 선택 필드. 프리셋을 탭하거나 바텀시트에서 고르면 [onChanged]가
/// 호출된다.
class EmojiPickerField extends StatelessWidget {
  const EmojiPickerField({
    super.key,
    required this.presets,
    required this.selectedEmoji,
    required this.onChanged,
    this.label,
  });

  /// 필드 위에 표시할 라벨. null이면 라벨을 표시하지 않는다.
  final String? label;

  /// 필드 상단에 노출할 자주 쓰이는 이모지 프리셋 목록 (화면/도메인별로 다를 수 있음)
  final List<String> presets;

  /// 현재 선택된 이모지 (없으면 null 또는 빈 문자열)
  final String? selectedEmoji;

  final ValueChanged<String> onChanged;

  Future<void> _openPicker(BuildContext context) async {
    final selected = await showEmojiPickerBottomSheet(context);
    if (selected != null) onChanged(selected);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isCustomSelected = selectedEmoji != null &&
        selectedEmoji!.isNotEmpty &&
        !presets.contains(selectedEmoji);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: AppSizes.spaceS),
        ],
        Wrap(
          spacing: AppSizes.spaceS,
          runSpacing: AppSizes.spaceS,
          children: [
            ...presets.map((emoji) {
              final selected = selectedEmoji == emoji;
              return _EmojiCircle(
                emoji: emoji,
                selected: selected,
                onTap: () => onChanged(emoji),
              );
            }),
            _EmojiCircle(
              emoji: isCustomSelected ? selectedEmoji : null,
              selected: isCustomSelected,
              icon: isCustomSelected ? null : Icons.add,
              tooltip: l10n.emoji_picker_more,
              onTap: () => _openPicker(context),
            ),
          ],
        ),
        if (isCustomSelected) ...[
          const SizedBox(height: AppSizes.spaceXS),
          Text(
            l10n.emoji_picker_custom_selected,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ],
    );
  }
}

class _EmojiCircle extends StatelessWidget {
  const _EmojiCircle({
    required this.selected,
    required this.onTap,
    this.emoji,
    this.icon,
    this.tooltip,
  });

  final String? emoji;
  final IconData? icon;
  final bool selected;
  final VoidCallback onTap;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final child = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: selected
              ? colorScheme.primaryContainer
              : colorScheme.surfaceContainerHighest,
          shape: BoxShape.circle,
          border: selected
              ? Border.all(color: colorScheme.primary, width: 2)
              : null,
        ),
        alignment: Alignment.center,
        child: emoji != null
            ? Text(emoji!, style: const TextStyle(fontSize: 18))
            : Icon(
                icon ?? Icons.add,
                size: 20,
                color: colorScheme.onSurfaceVariant,
              ),
      ),
    );
    return tooltip != null ? Tooltip(message: tooltip!, child: child) : child;
  }
}

/// 전체 이모지를 검색/카테고리 탐색하며 고를 수 있는 바텀시트.
/// 선택된 이모지 문자열을 반환하며, 취소 시 null을 반환한다.
Future<String?> showEmojiPickerBottomSheet(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppSizes.radiusMedium),
      ),
    ),
    builder: (sheetContext) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      minChildSize: 0.4,
      builder: (ctx, scrollController) => SafeArea(
        top: false,
        child: EmojiPickerSheet(
          scrollController: scrollController,
          onSelected: (emoji) => Navigator.of(sheetContext).pop(emoji),
        ),
      ),
    ),
  );
}
