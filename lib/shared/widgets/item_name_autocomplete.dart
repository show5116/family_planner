import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/features/main/fridge/providers/fridge_provider.dart';

/// 냉장고/장보기 항목 이름 입력 자동완성 위젯.
///
/// itemNamesProvider (전체 목록 캐시)를 로컬 필터링하여 후보를 표시한다.
class ItemNameAutocomplete extends ConsumerStatefulWidget {
  const ItemNameAutocomplete({
    super.key,
    required this.controller,
    required this.decoration,
    this.textCapitalization = TextCapitalization.sentences,
    this.onChanged,
    this.onSubmitted,
    this.onSelected,
  });

  final TextEditingController controller;
  final InputDecoration decoration;
  final TextCapitalization textCapitalization;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onSelected;

  @override
  ConsumerState<ItemNameAutocomplete> createState() =>
      _ItemNameAutocompleteState();
}

class _ItemNameAutocompleteState extends ConsumerState<ItemNameAutocomplete> {
  // optionsBuilder 클로저가 항상 최신 목록을 참조하도록 인스턴스 필드로 관리.
  // Autocomplete 위젯을 재생성하지 않고 이 필드만 갱신한다.
  List<String> _allNames = [];

  @override
  Widget build(BuildContext context) {
    // provider 값이 바뀌면 _allNames를 갱신하고 rebuild — optionsBuilder가 새 목록 사용
    ref.listen<AsyncValue<List<String>>>(itemNamesProvider, (prev, next) {
      final names = next.valueOrNull;
      if (names != null && names != _allNames) {
        setState(() => _allNames = names);
      }
    });

    // 초기값: provider가 이미 로드된 상태라면 즉시 반영
    final current = ref.read(itemNamesProvider).valueOrNull;
    if (current != null && current != _allNames) {
      _allNames = current;
    }

    return Autocomplete<String>(
      optionsBuilder: (textEditingValue) {
        final query = textEditingValue.text.trim();
        if (query.isEmpty) return const [];
        final q = query.toLowerCase();
        return _allNames
            .where((name) => name.toLowerCase().contains(q))
            .take(10)
            .toList();
      },
      fieldViewBuilder:
          (context, fieldController, focusNode, onFieldSubmitted) {
        if (fieldController.text != widget.controller.text) {
          fieldController.text = widget.controller.text;
          fieldController.selection = TextSelection.collapsed(
            offset: widget.controller.text.length,
          );
        }
        fieldController.addListener(() {
          if (widget.controller.text != fieldController.text) {
            widget.controller.text = fieldController.text;
          }
        });

        return TextField(
          controller: fieldController,
          focusNode: focusNode,
          decoration: widget.decoration,
          textCapitalization: widget.textCapitalization,
          onChanged: widget.onChanged,
          onSubmitted: (v) {
            onFieldSubmitted();
            widget.onSubmitted?.call(v);
          },
        );
      },
      optionsViewBuilder: (context, onOptionSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options.elementAt(index);
                  return InkWell(
                    onTap: () => onOptionSelected(option),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Text(option),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
      onSelected: (selected) {
        widget.controller.text = selected;
        widget.controller.selection =
            TextSelection.collapsed(offset: selected.length);
        widget.onChanged?.call(selected);
        widget.onSelected?.call(selected);
      },
    );
  }
}
