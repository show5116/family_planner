import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/features/memo/data/models/memo_model.dart';

/// 메모 태그 칩 표시 위젯
class MemoTagChips extends StatelessWidget {
  final List<MemoTag> tags;

  const MemoTagChips({
    super.key,
    required this.tags,
  });

  Color _parseColor(String? colorHex) {
    if (colorHex == null || colorHex.isEmpty) return AppColors.primary;
    try {
      final hex = colorHex.replaceFirst('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: AppSizes.spaceS,
      runSpacing: AppSizes.spaceS,
      children: tags.map((tag) {
        final color = _parseColor(tag.color);
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spaceS,
            vertical: 3,
          ),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          ),
          child: Text(
            tag.name,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
          ),
        );
      }).toList(),
    );
  }
}

/// 메모 태그 입력 위젯 (폼에서 사용)
class MemoTagInput extends StatefulWidget {
  final List<String> initialTags;
  final ValueChanged<List<String>> onChanged;
  /// 자동완성 후보 태그 목록
  final List<String> suggestedTags;

  const MemoTagInput({
    super.key,
    this.initialTags = const [],
    required this.onChanged,
    this.suggestedTags = const [],
  });

  @override
  State<MemoTagInput> createState() => _MemoTagInputState();
}

class _MemoTagInputState extends State<MemoTagInput> {
  late List<String> _tags;
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _tags = List.from(widget.initialTags);
  }

  @override
  void didUpdateWidget(MemoTagInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialTags != widget.initialTags) {
      setState(() => _tags = List.from(widget.initialTags));
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _addTag(String text) {
    final tag = text.trim().replaceAll('#', '');
    if (tag.isEmpty || _tags.contains(tag)) return;
    setState(() => _tags.add(tag));
    widget.onChanged(_tags);
  }

  void _removeTag(String tag) {
    setState(() => _tags.remove(tag));
    widget.onChanged(_tags);
  }

  @override
  Widget build(BuildContext context) {
    // 이미 추가된 태그는 후보에서 제외
    final candidates = widget.suggestedTags
        .where((t) => !_tags.contains(t))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Autocomplete<String>(
          optionsBuilder: (textEditingValue) {
            final input = textEditingValue.text.trim().replaceAll('#', '');
            if (input.isEmpty) return const [];
            return candidates
                .where((t) => t.toLowerCase().contains(input.toLowerCase()))
                .take(6);
          },
          onSelected: (tag) {
            _addTag(tag);
            _focusNode.requestFocus();
          },
          fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
            return Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      hintText: '태그 입력 후 추가',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppSizes.spaceM,
                        vertical: AppSizes.spaceS,
                      ),
                      isDense: true,
                    ),
                    onSubmitted: (value) {
                      _addTag(value);
                      controller.clear();
                      focusNode.requestFocus();
                    },
                  ),
                ),
                const SizedBox(width: AppSizes.spaceS),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    _addTag(controller.text);
                    controller.clear();
                    focusNode.requestFocus();
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  ),
                ),
              ],
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 280, maxHeight: 200),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (_, index) {
                      final tag = options.elementAt(index);
                      return ListTile(
                        dense: true,
                        leading: const Icon(Icons.label_outline, size: AppSizes.iconSmall),
                        title: Text(tag),
                        onTap: () => onSelected(tag),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
        if (_tags.isNotEmpty) ...[
          const SizedBox(height: AppSizes.spaceS),
          Wrap(
            spacing: AppSizes.spaceXS,
            runSpacing: AppSizes.spaceXS,
            children: _tags.map((tag) {
              return Chip(
                label: Text(tag),
                labelPadding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.spaceXS),
                deleteIcon:
                    const Icon(Icons.close, size: AppSizes.iconSmall),
                onDeleted: () => _removeTag(tag),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity:
                    const VisualDensity(horizontal: 0, vertical: -4),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
