import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';

/// 기분 선택지
///
/// 이모지를 그대로 저장한다 (서버 `mood`는 VarChar(20) 자유 문자열).
const List<String> kDiaryMoods = ['😊', '🙂', '😐', '😔', '😢', '😡', '🥰', '😴'];

/// 기분 선택 칩
class DiaryMoodSelector extends StatelessWidget {
  const DiaryMoodSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final String? selected;

  /// 같은 항목을 다시 누르면 null(선택 해제)이 전달된다
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSizes.spaceS,
      children: kDiaryMoods.map((mood) {
        final isSelected = selected == mood;
        return ChoiceChip(
          label: Text(mood, style: const TextStyle(fontSize: 18)),
          selected: isSelected,
          showCheckmark: false,
          onSelected: (_) => onChanged(isSelected ? null : mood),
        );
      }).toList(),
    );
  }
}
