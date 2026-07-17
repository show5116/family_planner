import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/shared/widgets/emoji_data/emoji_picker_sheet.dart';

/// 제목 입력 필드 왼쪽에 붙는 작은 이모지 아바타.
/// 탭하면 전체 이모지 바텀시트가 열리고, 고른 이모지가 [onChanged]로 전달된다.
/// [titleField]에 실제 제목 TextFormField를 넘기면 한 Row로 배치된다.
class EmojiPickerField extends StatelessWidget {
  const EmojiPickerField({
    super.key,
    required this.selectedEmoji,
    required this.onChanged,
    required this.titleField,
    this.placeholderIcon = Icons.add,
  });

  /// 현재 선택된 이모지 (없으면 null 또는 빈 문자열)
  final String? selectedEmoji;

  final ValueChanged<String> onChanged;

  /// 아바타 옆에 나란히 배치할 제목 입력 위젯 (보통 Expanded로 감싼 TextFormField)
  final Widget titleField;

  /// 이모지 미선택 시 아바타에 표시할 아이콘
  final IconData placeholderIcon;

  Future<void> _openPicker(BuildContext context) async {
    final selected = await showEmojiPickerBottomSheet(context);
    if (selected != null) onChanged(selected);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasEmoji = selectedEmoji != null && selectedEmoji!.isNotEmpty;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () => _openPicker(context),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: hasEmoji
                ? Text(selectedEmoji!, style: const TextStyle(fontSize: 20))
                : Icon(
                    placeholderIcon,
                    size: 20,
                    color: colorScheme.onSurfaceVariant,
                  ),
          ),
        ),
        const SizedBox(width: AppSizes.spaceS),
        Expanded(child: titleField),
      ],
    );
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
