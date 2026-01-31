import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';

/// 로딩 상태를 지원하는 버튼 위젯
///
/// 폼 제출, API 호출 등 비동기 작업 중 로딩 상태를 표시합니다.
///
/// ```dart
/// LoadingButton(
///   isLoading: isSubmitting,
///   onPressed: () => handleSubmit(),
///   child: Text('저장'),
/// )
/// ```
class LoadingButton extends StatelessWidget {
  /// 버튼 클릭 콜백 (isLoading이 true면 무시됨)
  final VoidCallback? onPressed;

  /// 로딩 상태
  final bool isLoading;

  /// 버튼 내용
  final Widget child;

  /// 로딩 중 표시할 위젯 (기본: CircularProgressIndicator)
  final Widget? loadingWidget;

  /// 버튼 스타일 (기본: ElevatedButton)
  final ButtonStyle? style;

  /// 버튼 타입
  final LoadingButtonType type;

  /// 전체 너비 사용 여부
  final bool fullWidth;

  /// 버튼 내부 패딩
  final EdgeInsetsGeometry padding;

  const LoadingButton({
    super.key,
    required this.onPressed,
    required this.isLoading,
    required this.child,
    this.loadingWidget,
    this.style,
    this.type = LoadingButtonType.elevated,
    this.fullWidth = true,
    this.padding = const EdgeInsets.all(AppSizes.spaceM),
  });

  /// ElevatedButton 스타일의 로딩 버튼
  const LoadingButton.elevated({
    super.key,
    required this.onPressed,
    required this.isLoading,
    required this.child,
    this.loadingWidget,
    this.style,
    this.fullWidth = true,
    this.padding = const EdgeInsets.all(AppSizes.spaceM),
  }) : type = LoadingButtonType.elevated;

  /// FilledButton 스타일의 로딩 버튼
  const LoadingButton.filled({
    super.key,
    required this.onPressed,
    required this.isLoading,
    required this.child,
    this.loadingWidget,
    this.style,
    this.fullWidth = true,
    this.padding = const EdgeInsets.all(AppSizes.spaceM),
  }) : type = LoadingButtonType.filled;

  /// OutlinedButton 스타일의 로딩 버튼
  const LoadingButton.outlined({
    super.key,
    required this.onPressed,
    required this.isLoading,
    required this.child,
    this.loadingWidget,
    this.style,
    this.fullWidth = true,
    this.padding = const EdgeInsets.all(AppSizes.spaceM),
  }) : type = LoadingButtonType.outlined;

  /// TextButton 스타일의 로딩 버튼
  const LoadingButton.text({
    super.key,
    required this.onPressed,
    required this.isLoading,
    required this.child,
    this.loadingWidget,
    this.style,
    this.fullWidth = false,
    this.padding = const EdgeInsets.symmetric(horizontal: AppSizes.spaceM, vertical: AppSizes.spaceS),
  }) : type = LoadingButtonType.text;

  @override
  Widget build(BuildContext context) {
    final buttonChild = Padding(
      padding: padding,
      child: isLoading
          ? loadingWidget ?? const _DefaultLoadingIndicator()
          : child,
    );

    final effectiveOnPressed = isLoading ? null : onPressed;

    Widget button;
    switch (type) {
      case LoadingButtonType.elevated:
        button = ElevatedButton(
          onPressed: effectiveOnPressed,
          style: style,
          child: buttonChild,
        );
      case LoadingButtonType.filled:
        button = FilledButton(
          onPressed: effectiveOnPressed,
          style: style,
          child: buttonChild,
        );
      case LoadingButtonType.outlined:
        button = OutlinedButton(
          onPressed: effectiveOnPressed,
          style: style,
          child: buttonChild,
        );
      case LoadingButtonType.text:
        button = TextButton(
          onPressed: effectiveOnPressed,
          style: style,
          child: buttonChild,
        );
    }

    if (fullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }
}

enum LoadingButtonType {
  elevated,
  filled,
  outlined,
  text,
}

class _DefaultLoadingIndicator extends StatelessWidget {
  const _DefaultLoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 24,
      height: 24,
      child: CircularProgressIndicator(strokeWidth: 2),
    );
  }
}

/// 아이콘과 함께 사용하는 로딩 버튼
///
/// ```dart
/// LoadingIconButton(
///   isLoading: isSubmitting,
///   onPressed: () => handleSubmit(),
///   icon: Icons.save,
///   label: '저장',
/// )
/// ```
class LoadingIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData icon;
  final String label;
  final ButtonStyle? style;
  final LoadingButtonType type;
  final bool fullWidth;

  const LoadingIconButton({
    super.key,
    required this.onPressed,
    required this.isLoading,
    required this.icon,
    required this.label,
    this.style,
    this.type = LoadingButtonType.elevated,
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final buttonChild = isLoading
        ? const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon),
              const SizedBox(width: AppSizes.spaceS),
              Text(label),
            ],
          );

    final effectiveOnPressed = isLoading ? null : onPressed;

    Widget button;
    switch (type) {
      case LoadingButtonType.elevated:
        button = ElevatedButton(
          onPressed: effectiveOnPressed,
          style: style,
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.spaceM),
            child: buttonChild,
          ),
        );
      case LoadingButtonType.filled:
        button = FilledButton(
          onPressed: effectiveOnPressed,
          style: style,
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.spaceM),
            child: buttonChild,
          ),
        );
      case LoadingButtonType.outlined:
        button = OutlinedButton(
          onPressed: effectiveOnPressed,
          style: style,
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.spaceM),
            child: buttonChild,
          ),
        );
      case LoadingButtonType.text:
        button = TextButton(
          onPressed: effectiveOnPressed,
          style: style,
          child: buttonChild,
        );
    }

    if (fullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }
}
