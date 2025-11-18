import 'package:flutter/material.dart';
import 'package:family_planner/core/constants/app_sizes.dart';

/// 반응형 레이아웃 유틸리티
class Responsive extends StatelessWidget {
  const Responsive({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  /// 현재 화면 너비가 모바일인지 확인
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < AppSizes.breakpointMobile;

  /// 현재 화면 너비가 태블릿인지 확인
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= AppSizes.breakpointMobile &&
      MediaQuery.of(context).size.width < AppSizes.breakpointTablet;

  /// 현재 화면 너비가 데스크톱인지 확인
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= AppSizes.breakpointTablet;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Desktop
    if (size.width >= AppSizes.breakpointTablet) {
      return desktop ?? tablet ?? mobile;
    }
    // Tablet
    else if (size.width >= AppSizes.breakpointMobile) {
      return tablet ?? mobile;
    }
    // Mobile
    else {
      return mobile;
    }
  }
}

/// 반응형 그리드 컬럼 수 계산
class ResponsiveGridDelegate {
  ResponsiveGridDelegate._();

  /// 화면 크기에 따른 그리드 컬럼 수 반환
  static int getColumns(BuildContext context) {
    if (Responsive.isDesktop(context)) {
      return 3; // 데스크톱: 3열
    } else if (Responsive.isTablet(context)) {
      return 2; // 태블릿: 2열
    } else {
      return 1; // 모바일: 1열
    }
  }

  /// 화면 크기에 따른 GridDelegate 반환
  static SliverGridDelegate getDelegate(BuildContext context) {
    final columns = getColumns(context);
    // childAspectRatio를 화면 크기에 따라 조정하여 overflow 방지
    double aspectRatio;
    if (Responsive.isDesktop(context)) {
      aspectRatio = 0.85; // 데스크톱: 더 세로로 긴 카드
    } else if (Responsive.isTablet(context)) {
      aspectRatio = 0.75; // 태블릿: 세로로 더 긴 카드
    } else {
      aspectRatio = 0.95; // 모바일: 거의 정사각형
    }

    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: columns,
      crossAxisSpacing: AppSizes.spaceM,
      mainAxisSpacing: AppSizes.spaceM,
      childAspectRatio: aspectRatio,
    );
  }
}

/// 반응형 패딩 계산
class ResponsivePadding {
  ResponsivePadding._();

  /// 화면 크기에 따른 수평 패딩 반환
  static double getHorizontalPadding(BuildContext context) {
    if (Responsive.isDesktop(context)) {
      return AppSizes.spaceXXL; // 데스크톱: 48px
    } else if (Responsive.isTablet(context)) {
      return AppSizes.spaceXL; // 태블릿: 32px
    } else {
      return AppSizes.spaceM; // 모바일: 16px
    }
  }

  /// 화면 크기에 따른 EdgeInsets 반환
  static EdgeInsets getPagePadding(BuildContext context) {
    final horizontal = getHorizontalPadding(context);
    return EdgeInsets.symmetric(
      horizontal: horizontal,
      vertical: AppSizes.spaceM,
    );
  }
}

/// 반응형 최대 너비 컨테이너
class ResponsiveConstraints extends StatelessWidget {
  const ResponsiveConstraints({
    super.key,
    required this.child,
    this.maxWidth = 1200,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
