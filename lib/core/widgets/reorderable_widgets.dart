import 'package:flutter/material.dart';

/// ReorderableListView용 공통 proxyDecorator
/// 드래그 시 elevation 애니메이션과 투명도 효과 제공
Widget buildReorderableProxyDecorator(
  Widget child,
  int index,
  Animation<double> animation,
) {
  return AnimatedBuilder(
    animation: animation,
    builder: (context, child) {
      final double elevation = Tween<double>(
        begin: 0,
        end: 6,
      ).evaluate(animation);

      return Material(
        elevation: elevation,
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: Opacity(
          opacity: 0.85,
          child: child,
        ),
      );
    },
    child: child,
  );
}

/// 드래그 가능한 핸들 아이콘
/// grab 커서와 함께 표시되는 드래그 핸들
class DragHandleIcon extends StatelessWidget {
  const DragHandleIcon({
    super.key,
    this.color = Colors.grey,
    this.size,
  });

  final Color color;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.grab,
      child: Icon(
        Icons.drag_handle,
        color: color,
        size: size,
      ),
    );
  }
}

/// 저장/취소 버튼이 있는 변경사항 알림 바
class ReorderChangesBar extends StatelessWidget {
  const ReorderChangesBar({
    super.key,
    required this.onSave,
    required this.onCancel,
    this.message = '순서가 변경되었습니다',
  });

  final VoidCallback onSave;
  final VoidCallback onCancel;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Row(
        children: [
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
            ),
          ),
          TextButton(
            onPressed: onCancel,
            child: const Text('취소'),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: onSave,
            child: const Text('저장'),
          ),
        ],
      ),
    );
  }
}

/// 순서 변경 취소 확인 다이얼로그
Future<bool> showReorderCancelDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('순서 변경 취소'),
      content: const Text('변경한 순서를 취소하시겠습니까?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('아니오'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('예'),
        ),
      ],
    ),
  );
  return result ?? false;
}

/// 순서 변경 저장 확인 다이얼로그
Future<bool> showReorderSaveDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('순서 저장'),
      content: const Text('변경한 순서를 저장하시겠습니까?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('저장'),
        ),
      ],
    ),
  );
  return result ?? false;
}
