import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/core/utils/responsive.dart';
import 'package:family_planner/core/services/api_service_base.dart';
import 'package:family_planner/shared/widgets/app_logo.dart';
import 'package:family_planner/shared/widgets/language_selector_button.dart';
import 'package:family_planner/shared/widgets/theme_toggle_button.dart';
import 'package:family_planner/features/auth/providers/auth_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 로그인 화면
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  // 모바일 웹 환경 체크
  bool get _isMobileWeb {
    return kIsWeb &&
           (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS);
  }

  // 화면 높이 고정을 위한 변수
  double? _initialScreenHeight;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final l10n = AppLocalizations.of(context)!;

    // 폼 유효성 검사
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 로그인 시도
      await ref
          .read(authProvider.notifier)
          .login(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );

      // 로그인 성공 시 홈 화면으로 이동
      if (mounted) {
        context.go(AppRoutes.home);
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
      // 에러 처리
      if (mounted) {
        // ApiException인 경우 상태 코드에 따라 처리
        if (e is ApiException) {
          if (e.statusCode == 403) {
            // 403: 이메일 인증 필요 - 이메일 인증 화면으로 이동
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.message),
                backgroundColor: Colors.orange,
                duration: const Duration(seconds: 3),
              ),
            );

            // 이메일 인증 화면으로 이동 (이메일 전달)
            context.push(
              '${AppRoutes.emailVerification}?email=${Uri.encodeComponent(_emailController.text.trim())}',
            );
            return;
          } else if (e.statusCode == 401) {
            // 401: 비밀번호 오류
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  e.message.isNotEmpty
                      ? e.message
                      : l10n.auth_loginFailedInvalidCredentials,
                ),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }
        }

        // 기타 에러
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.auth_loginFailed}: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 구글 로그인 처리
  ///
  /// 플랫폼에 따라 자동으로 적절한 방식을 사용합니다:
  /// - 웹: OAuth URL 방식 (브라우저 리다이렉트)
  /// - 모바일: SDK 방식 (Google Sign-In)
  Future<void> _handleGoogleLogin() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isLoading = true);

    try {
      await ref.read(authProvider.notifier).loginWithGoogle();
      // 웹: 브라우저가 열리고, OAuth 콜백이 처리되면 자동으로 홈으로 이동
      // 모바일: SDK 로그인 완료 후 자동으로 홈으로 이동
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
      // 에러 처리
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.auth_googleLoginFailed}: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 카카오 로그인 처리
  ///
  /// 플랫폼에 따라 자동으로 적절한 방식을 사용합니다:
  /// - 웹: OAuth URL 방식 (브라우저 리다이렉트)
  /// - 모바일: SDK 방식 (Kakao Flutter SDK)
  Future<void> _handleKakaoLogin() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isLoading = true);

    try {
      await ref.read(authProvider.notifier).loginWithKakao();
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
      // 에러 처리
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.auth_kakaoLoginFailed}: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // 모바일 웹에서 초기 화면 높이 저장
    if (_isMobileWeb && _initialScreenHeight == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _initialScreenHeight = MediaQuery.of(context).size.height;
        });
      });
    }

    // 모바일 웹에서 고정 높이 적용, 그 외에는 화면 높이 사용
    final screenHeight = _isMobileWeb && _initialScreenHeight != null
        ? _initialScreenHeight!
        : MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          ThemeToggleButton(
            key: ValueKey('theme_toggle_$hashCode'),
            isOnPrimaryColor: true,
          ),
          const SizedBox(width: AppSizes.spaceXS),
          Padding(
            padding: const EdgeInsets.only(right: AppSizes.spaceS),
            child: LanguageSelectorButton(
              key: ValueKey('language_selector_$hashCode'),
              isOnPrimaryColor: true,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SizedBox(
          height: screenHeight - MediaQuery.of(context).padding.top - kToolbarHeight,
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsivePadding.getHorizontalPadding(context),
                vertical: AppSizes.spaceM,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: Responsive.isMobile(context) ? double.infinity : 500,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                    // 로고 (반응형 크기)
                    AppLogo(size: Responsive.isMobile(context) ? 400 : 500),
                    SizedBox(
                      height: Responsive.isMobile(context)
                          ? AppSizes.spaceS
                          : AppSizes.spaceL,
                    ),

                    // 이메일 입력
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: l10n.auth_email,
                        hintText: l10n.auth_emailHint,
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusMedium,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.auth_emailHint;
                        }
                        if (!value.contains('@')) {
                          return l10n.auth_emailError;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSizes.spaceM),

                    // 비밀번호 입력
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: l10n.auth_password,
                        hintText: l10n.auth_passwordHint,
                        prefixIcon: const Icon(Icons.lock_outlined),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusMedium,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.auth_passwordHint;
                        }
                        if (value.length < 6) {
                          return l10n.auth_passwordError;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSizes.spaceS),

                    // 비밀번호 찾기 링크
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          animationDuration: Duration.zero,
                        ),
                        onPressed: () {
                          context.push(AppRoutes.forgotPassword);
                        },
                        child: Text(l10n.auth_forgotPassword),
                      ),
                    ),
                    const SizedBox(height: AppSizes.spaceM),

                    // 로그인 버튼
                    SizedBox(
                      width: double.infinity,
                      height: AppSizes.buttonHeightLarge,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          animationDuration: Duration.zero,
                        ),
                        onPressed: _isLoading ? null : _handleLogin,
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(l10n.auth_login),
                      ),
                    ),
                    const SizedBox(height: AppSizes.spaceL),

                    // 구분선
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.spaceM,
                          ),
                          child: Text(
                            l10n.auth_or,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: AppSizes.spaceL),

                    // 소셜 로그인 버튼들
                    _SocialLoginButton(
                      icon: Icons.g_mobiledata,
                      label: l10n.auth_continueWithGoogle,
                      onPressed: _isLoading ? null : _handleGoogleLogin,
                    ),
                    const SizedBox(height: AppSizes.spaceM),
                    _SocialLoginButton(
                      icon: Icons.chat_bubble_outline,
                      label: l10n.auth_continueWithKakao,
                      backgroundColor: const Color(0xFFFEE500),
                      textColor: Colors.black87,
                      onPressed: _isLoading ? null : _handleKakaoLogin,
                    ),
                    const SizedBox(height: AppSizes.spaceM),
                    _SocialLoginButton(
                      icon: Icons.apple,
                      label: l10n.auth_continueWithApple,
                      backgroundColor: Colors.black,
                      onPressed: () {
                        // Apple 로그인은 아직 미구현
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.common_comingSoon)),
                        );
                      },
                    ),
                    const SizedBox(height: AppSizes.spaceXL),

                    // 회원가입 링크
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          l10n.auth_noAccount,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            animationDuration: Duration.zero,
                          ),
                          onPressed: () {
                            context.push(AppRoutes.signup);
                          },
                          child: Text(l10n.auth_signup),
                        ),
                      ],
                    ),
                  ],
                  ),
                ),
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
    this.onPressed,
    this.backgroundColor,
    this.textColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
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
          animationDuration: Duration.zero,
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
