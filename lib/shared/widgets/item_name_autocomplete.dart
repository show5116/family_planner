import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/features/main/fridge/data/repositories/fridge_repository.dart';
import 'package:family_planner/features/main/fridge/providers/fridge_provider.dart';

/// 냉장고/장보기 항목 이름 입력 자동완성 위젯.
///
/// GET /fridge/item-names API를 debounce(350ms) 후 호출하여 후보 목록을 표시한다.
/// [controller]를 그대로 받아 호출부의 TextEditingController와 연동된다.
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
  Timer? _debounce;
  List<String> _options = [];

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    widget.onChanged?.call(query);
    _debounce?.cancel();
    if (query.trim().isEmpty) {
      setState(() => _options = []);
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 350), () async {
      final groupId = ref.read(fridgeSelectedGroupIdProvider);
      if (groupId == null) return;
      final results = await ref
          .read(fridgeRepositoryProvider)
          .getItemNameSuggestions(groupId: groupId, q: query.trim());
      if (mounted) setState(() => _options = results);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (_) => _options,
      fieldViewBuilder: (context, fieldController, focusNode, onFieldSubmitted) {
        // 외부 controller 값으로 내부 controller 초기화 (첫 빌드 시)
        if (fieldController.text != widget.controller.text) {
          fieldController.text = widget.controller.text;
          fieldController.selection = TextSelection.collapsed(
            offset: widget.controller.text.length,
          );
        }
        // 내부 controller 변경 → 외부 controller 동기화
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
          onChanged: _onQueryChanged,
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
