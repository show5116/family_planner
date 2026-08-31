import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/shared/widgets/emoji_data/emoji_picker_sheet.dart';

/// 이모지 미리보기가 붙은 제목 입력 필드 + 오른쪽 이모지 선택 박스.
///
/// 제목 필드 앞의 이모지는 현재 선택된 이모지가 실제로 어떻게 보일지 보여주는
/// 미리보기(탭 불가)이고, 오른쪽 박스가 실제 이모지를 바꾸는 선택 버튼이다.
/// 탭하면 전체 이모지 바텀시트가 열리고, 고른 이모지가 [onEmojiChanged]로 전달된다.
class EmojiPickerField extends StatelessWidget {
  const EmojiPickerField({
    super.key,
    required this.selectedEmoji,
    required this.onEmojiChanged,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.maxLength,
    this.validator,
    this.autofocus = false,
    this.textInputAction,
    this.placeholderIcon = Icons.add,
  });

  /// 현재 선택된 이모지 (없으면 null 또는 빈 문자열)
  final String? selectedEmoji;

  final ValueChanged<String> onEmojiChanged;

  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final int? maxLength;
  final String? Function(String?)? validator;
  final bool autofocus;
  final TextInputAction? textInputAction;

  /// 이모지 미선택 시 표시할 아이콘
  final IconData placeholderIcon;

  Future<void> _openPicker(BuildContext context) async {
    final selected = await showEmojiPickerBottomSheet(context);
    if (selected != null) onEmojiChanged(selected);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasEmoji = selectedEmoji != null && selectedEmoji!.isNotEmpty;
    final emojiPreview = hasEmoji ? '$selectedEmoji ' : null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,
            maxLength: maxLength,
            autofocus: autofocus,
            textInputAction: textInputAction,
            decoration: InputDecoration(
              labelText: labelText,
              hintText: hintText,
              prefixText: emojiPreview,
              prefixStyle: const TextStyle(fontSize: 16),
            ),
            validator: validator,
          ),
        ),
        const SizedBox(width: AppSizes.spaceS),
        InkWell(
          onTap: () => _openPicker(context),
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              border: Border.all(color: colorScheme.outline),
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
            ),
            alignment: Alignment.center,
            child: hasEmoji
                ? Text(selectedEmoji!, style: const TextStyle(fontSize: 24))
                : Icon(
                    placeholderIcon,
                    size: 24,
                    color: colorScheme.onSurfaceVariant,
                  ),
          ),
        ),
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
