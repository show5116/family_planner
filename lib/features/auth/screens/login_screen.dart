import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/core/utils/responsive.dart';
import 'package:family_planner/shared/widgets/app_logo.dart';

/// 로그인 화면 (로고 사용 예제)
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 반응형 최대 너비 설정
    final maxWidth = Responsive.isMobile(context)
        ? double.infinity
        : Responsive.isTablet(context)
            ? 500.0
            : 450.0;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(
                Responsive.isMobile(context) ? AppSizes.spaceXL : AppSizes.spaceXXL,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                // 로고 (반응형 크기)
                AppLogo(
                  size: Responsive.isMobile(context) ? 150 : 180,
                ),
                SizedBox(
                  height: Responsive.isMobile(context)
                      ? AppSizes.spaceXXL
                      : AppSizes.spaceXXL * 1.5,
                ),

                // 이메일 입력
                TextField(
                  decoration: InputDecoration(
                    labelText: '이메일',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.spaceM),

                // 비밀번호 입력
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: '비밀번호',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.spaceXL),

                // 로그인 버튼
                SizedBox(
                  width: double.infinity,
                  height: AppSizes.buttonHeightLarge,
                  child: ElevatedButton(
                    onPressed: () {
                      // 로그인 성공 후 홈 화면으로 이동 (스택 초기화)
                      context.go(AppRoutes.home);
                    },
                    child: const Text('로그인'),
                  ),
                ),
                const SizedBox(height: AppSizes.spaceL),

                // 구분선
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceM),
                      child: Text(
                        '또는',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: AppSizes.spaceL),

                // 소셜 로그인 버튼들
                _SocialLoginButton(
                  icon: Icons.g_mobiledata,
                  label: 'Google로 계속하기',
                  onPressed: () {},
                ),
                const SizedBox(height: AppSizes.spaceM),
                _SocialLoginButton(
                  icon: Icons.chat_bubble_outline,
                  label: 'Kakao로 계속하기',
                  backgroundColor: const Color(0xFFFEE500),
                  textColor: Colors.black87,
                  onPressed: () {},
                ),
                const SizedBox(height: AppSizes.spaceM),
                _SocialLoginButton(
                  icon: Icons.apple,
                  label: 'Apple로 계속하기',
                  backgroundColor: Colors.black,
                  onPressed: () {},
                ),
                const SizedBox(height: AppSizes.spaceXL),

                // 회원가입 링크
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '계정이 없으신가요? ',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('회원가입'),
                    ),
                  ],
                ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialLoginButton extends StatelessWidget {
  const _SocialLoginButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;

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
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: AppSizes.iconMedium),
            const SizedBox(width: AppSizes.spaceS),
            Text(label),
          ],
        ),
      ),
    );
  }
}
