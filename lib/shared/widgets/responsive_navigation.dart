import 'package:flutter/material.dart';
import 'package:family_planner/core/utils/responsive.dart';

/// 반응형 네비게이션 레이아웃
/// 모바일: Bottom Navigation
/// 태블릿/데스크톱: Navigation Rail
class ResponsiveNavigation extends StatelessWidget {
  const ResponsiveNavigation({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    required this.body,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<NavigationDestination> destinations;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    // 모바일: Bottom Navigation
    if (Responsive.isMobile(context)) {
      return Scaffold(
        body: body,
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
          destinations: destinations,
        ),
      );
    }
    // 태블릿/데스크톱: Navigation Rail + Body
    else {
      final isDesktop = Responsive.isDesktop(context);

      return Scaffold(
        body: Row(
          children: [
            // Navigation Rail
            NavigationRail(
              selectedIndex: selectedIndex,
              onDestinationSelected: onDestinationSelected,
              // extended가 true일 때는 labelType을 null로 설정해야 함
              labelType: isDesktop
                  ? null
                  : NavigationRailLabelType.selected,
              extended: isDesktop,
              destinations: destinations
                  .map(
                    (dest) => NavigationRailDestination(
                      icon: dest.icon,
                      selectedIcon: dest.selectedIcon,
                      label: Text(dest.label),
                    ),
                  )
                  .toList(),
            ),
            const VerticalDivider(thickness: 1, width: 1),
            // Body
            Expanded(child: body),
          ],
        ),
      );
    }
  }
}
