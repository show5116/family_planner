import 'package:flutter/material.dart';

/// 메뉴 리스트 타일
///
/// 아이콘, 타이틀, chevron 아이콘을 포함하는 표준 메뉴 아이템입니다.
/// [isDestructive]가 true면 빨간색으로 표시됩니다 (예: 로그아웃).
class MenuListTile extends StatelessWidget {
  const MenuListTile({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final errorColor = Theme.of(context).colorScheme.error;

    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? errorColor : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? errorColor : null,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
