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
      spacing: AppSizes.spaceXS,
      runSpacing: AppSizes.spaceXS,
      children: tags.map((tag) {
        final color = _parseColor(tag.color);
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spaceS,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
              width: 0.5,
            ),
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

  const MemoTagInput({
    super.key,
    this.initialTags = const [],
    required this.onChanged,
  });

  @override
  State<MemoTagInput> createState() => _MemoTagInputState();
}

class _MemoTagInputState extends State<MemoTagInput> {
  late List<String> _tags;
  final _controller = TextEditingController();
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
      setState(() {
        _tags = List.from(widget.initialTags);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _addTag() {
    final text = _controller.text.trim().replaceAll('#', '');
    if (text.isEmpty) return;
    if (_tags.contains(text)) return;

    setState(() {
      _tags.add(text);
    });
    _controller.clear();
    widget.onChanged(_tags);
    _focusNode.requestFocus();
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
    widget.onChanged(_tags);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: '태그',
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.spaceM,
                    vertical: AppSizes.spaceS,
                  ),
                  isDense: true,
                ),
                onSubmitted: (_) => _addTag(),
              ),
            ),
            const SizedBox(width: AppSizes.spaceS),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _addTag,
              style: IconButton.styleFrom(
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              ),
            ),
          ],
        ),
        if (_tags.isNotEmpty) ...[
          const SizedBox(height: AppSizes.spaceS),
          Wrap(
            spacing: AppSizes.spaceXS,
            runSpacing: AppSizes.spaceXS,
            children: _tags.map((tag) {
              return Chip(
                label: Text(tag),
                labelPadding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceXS),
                deleteIcon: const Icon(Icons.close, size: AppSizes.iconSmall),
                onDeleted: () => _removeTag(tag),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
