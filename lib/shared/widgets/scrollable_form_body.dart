import 'package:flutter/material.dart';
import 'package:family_planner/core/constants/app_sizes.dart';

/// 모바일 웹에서 키보드 dismiss 후 흰 화면 문제를 방지하는 폼 레이아웃 위젯.
///
/// 사용 패턴:
/// ```dart
/// Scaffold(
///   resizeToAvoidBottomInset: false,
///   body: ScrollableFormBody(
///     child: Form(...),
///   ),
/// )
/// ```
///
/// - [maxWidth]: 콘텐츠 최대 너비 (기본값 600)
/// - [padding]: 내부 패딩 (기본값 spaceM)
/// - [child]: 폼 콘텐츠
class ScrollableFormBody extends StatelessWidget {
  const ScrollableFormBody({
    super.key,
    required this.child,
    this.maxWidth = 600,
    this.padding,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: padding ?? const EdgeInsets.all(AppSizes.spaceM),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: child,
          ),
        ),
      ),
    );
  }
}
