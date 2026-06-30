import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';

/// 소셜 로그인 버튼 위젯.
///
/// icon 또는 iconWidget 중 하나를 지정한다. iconWidget이 있으면 우선 사용된다
/// (Google 로고 SVG처럼 IconData로 표현할 수 없는 브랜드 로고용).
/// 높이/모서리 반경/글자 크기는 Apple 공식 SignInWithAppleButton과 시각적으로 맞춘 값이다.
/// (SignInWithAppleButton은 내부적으로 fontSize = height * 0.43을 고정 사용한다)
class SocialLoginButton extends StatelessWidget {
  final IconData? icon;
  final Widget? iconWidget;
  final String label;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;

  const SocialLoginButton({
    super.key,
    this.icon,
    this.iconWidget,
    required this.label,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
  }) : assert(icon != null || iconWidget != null, 'icon 또는 iconWidget이 필요합니다');

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppSizes.buttonHeightLarge,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          side: borderColor != null ? BorderSide(color: borderColor!) : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          ),
          animationDuration: Duration.zero,
          minimumSize: const Size(double.infinity, AppSizes.buttonHeightLarge),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: AppSizes.iconMedium,
              height: AppSizes.iconMedium,
              child: iconWidget ?? Icon(icon, size: AppSizes.iconMedium),
            ),
            const SizedBox(width: AppSizes.spaceS),
            Text(
              label,
              style: TextStyle(
                fontSize: AppSizes.buttonHeightLarge * 0.43,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.41,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
