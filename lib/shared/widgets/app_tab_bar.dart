import 'package:flutter/material.dart';

/// 앱 전체에서 사용하는 공통 TabBar 위젯
///
/// 그룹 상세, Q&A 등 여러 화면에서 일관된 탭 디자인을 제공합니다.
class AppTabBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController controller;
  final List<String> tabs;
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final Color? indicatorColor;

  const AppTabBar({
    super.key,
    required this.controller,
    required this.tabs,
    this.labelColor,
    this.unselectedLabelColor,
    this.indicatorColor,
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      labelColor: labelColor ?? Colors.white,
      unselectedLabelColor: unselectedLabelColor ?? Colors.white70,
      indicatorColor: indicatorColor ?? Colors.white,
      tabs: tabs.map((label) => Tab(text: label)).toList(),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
