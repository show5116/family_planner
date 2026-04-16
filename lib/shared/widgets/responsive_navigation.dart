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
    this.bottomNavKey,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<NavigationDestination> destinations;
  final Widget body;
  final GlobalKey? bottomNavKey;

  @override
  Widget build(BuildContext context) {
    // 모바일: Bottom Navigation
    if (Responsive.isMobile(context)) {
      // 내부 Scaffold들이 시스템 네비게이션 바 영역을 중복 처리하지 않도록
      // body 영역의 MediaQuery에서 bottom padding을 제거합니다.
      // (외부 Scaffold의 NavigationBar가 시스템 인셋을 이미 처리함)
      final mediaQuery = MediaQuery.of(context);
      final adjustedBody = MediaQuery(
        data: mediaQuery.copyWith(
          padding: mediaQuery.padding.copyWith(bottom: 0),
          viewPadding: mediaQuery.viewPadding.copyWith(bottom: 0),
        ),
        child: body,
      );

      return Scaffold(
        body: adjustedBody,
        bottomNavigationBar: NavigationBar(
          key: bottomNavKey,
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
