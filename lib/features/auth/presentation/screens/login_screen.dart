import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/core/utils/responsive.dart';
import 'package:family_planner/core/utils/error_handler.dart';
import 'package:family_planner/core/services/api_service_base.dart';
import 'package:family_planner/shared/widgets/app_logo.dart';
import 'package:flutter/gestures.dart';
import 'package:family_planner/features/auth/providers/auth_provider.dart';
import 'package:family_planner/features/auth/presentation/widgets/auth_app_bar.dart';
import 'package:family_planner/features/auth/presentation/widgets/auth_link_row.dart';
import 'package:family_planner/shared/widgets/app_divider.dart';
import 'package:family_planner/features/auth/presentation/widgets/social_login_button.dart';
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
  late final TapGestureRecognizer _termsRecognizer;
  late final TapGestureRecognizer _privacyRecognizer;

  @override
  void initState() {
    super.initState();
    _termsRecognizer = TapGestureRecognizer()..onTap = () => context.push(AppRoutes.termsOfService);
    _privacyRecognizer = TapGestureRecognizer()..onTap = () => context.push(AppRoutes.privacyPolicy);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _termsRecognizer.dispose();
    _privacyRecognizer.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final l10n = AppLocalizations.of(context)!;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref
          .read(authProvider.notifier)
          .login(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );

      if (mounted) {
        context.go(AppRoutes.home);
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
      if (mounted) {
        if (e is ApiException) {
          if (e.statusCode == 403) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.message),
                backgroundColor: Colors.orange,
                duration: const Duration(seconds: 3),
              ),
            );
            context.push(
              '${AppRoutes.emailVerification}?email=${Uri.encodeComponent(_emailController.text.trim())}',
            );
            return;
          } else if (e.statusCode == 401) {
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

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.auth_loginFailed}: ${ErrorHandler.getErrorMessage(e)}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleGoogleLogin() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isLoading = true);

    try {
      await ref.read(authProvider.notifier).loginWithGoogle();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.auth_googleLoginFailed}: ${ErrorHandler.getErrorMessage(e)}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // TODO: 카카오 사업자 동의항목(이메일) 심사 승인 후 활성화
  // Future<void> _handleKakaoLogin() async {
  //   final l10n = AppLocalizations.of(context)!;
  //   setState(() => _isLoading = true);
  //
  //   try {
  //     await ref.read(authProvider.notifier).loginWithKakao();
  //   } catch (e) {
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('${l10n.auth_kakaoLoginFailed}: ${ErrorHandler.getErrorMessage(e)}'),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //     }
  //   } finally {
  //     if (mounted) setState(() => _isLoading = false);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: const AuthAppBar(),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsivePadding.getHorizontalPadding(context),
              vertical: AppSizes.spaceXS,
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
                    AppLogo(size: Responsive.isMobile(context) ? 220 : 260),
                    const SizedBox(height: AppSizes.spaceM),
                    _buildEmailField(l10n),
                    const SizedBox(height: AppSizes.spaceM),
                    _buildPasswordField(l10n),
                    const SizedBox(height: AppSizes.spaceS),
                    _buildForgotPasswordLink(l10n),
                    const SizedBox(height: AppSizes.spaceM),
                    _buildLoginButton(l10n),
                    const SizedBox(height: AppSizes.spaceL),
                    AppDivider(text: l10n.auth_or),
                    const SizedBox(height: AppSizes.spaceL),
                    _buildSocialLoginButtons(l10n),
                    const SizedBox(height: AppSizes.spaceM),
                    _buildSocialLoginConsent(l10n),
                    const SizedBox(height: AppSizes.spaceL),
                    AuthLinkRow(
                      text: l10n.auth_noAccount,
                      linkText: l10n.auth_signup,
                      onPressed: () => context.push(AppRoutes.signup),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField(AppLocalizations l10n) {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: l10n.auth_email,
        hintText: l10n.auth_emailHint,
        prefixIcon: const Icon(Icons.email_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
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
    );
  }

  Widget _buildPasswordField(AppLocalizations l10n) {
    return TextFormField(
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
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
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
    );
  }

  Widget _buildForgotPasswordLink(AppLocalizations l10n) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.primary,
          animationDuration: Duration.zero,
        ),
        onPressed: () => context.push(AppRoutes.forgotPassword),
        child: Text(l10n.auth_forgotPassword),
      ),
    );
  }

  Widget _buildLoginButton(AppLocalizations l10n) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          animationDuration: Duration.zero,
          minimumSize: const Size(double.infinity, AppSizes.buttonHeightLarge),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onPressed: _isLoading ? null : _handleLogin,
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(l10n.auth_login),
      ),
    );
  }

  Widget _buildSocialLoginConsent(AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;
    final baseStyle = Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.outline);
    final linkStyle = baseStyle?.copyWith(color: colorScheme.primary, decoration: TextDecoration.underline);

    // legal_socialLoginConsent("{termsLink}", "{privacyLink}") 형태로 분리하여 RichText 조합
    final raw = l10n.legal_socialLoginConsent(l10n.legal_agreeToTerms, l10n.legal_agreeToPrivacy);
    final termsPart = raw.split(l10n.legal_agreeToTerms);
    final beforeTerms = termsPart.first;
    final afterTerms = raw.substring(beforeTerms.length + l10n.legal_agreeToTerms.length);
    final privacyParts = afterTerms.split(l10n.legal_agreeToPrivacy);
    final betweenLinks = privacyParts.first;
    final afterPrivacy = privacyParts.length > 1 ? privacyParts.last : '';

    return Text.rich(
      TextSpan(
        style: baseStyle,
        children: [
          TextSpan(text: beforeTerms),
          TextSpan(
            text: l10n.legal_agreeToTerms,
            style: linkStyle,
            recognizer: _termsRecognizer,
          ),
          TextSpan(text: betweenLinks),
          TextSpan(
            text: l10n.legal_agreeToPrivacy,
            style: linkStyle,
            recognizer: _privacyRecognizer,
          ),
          TextSpan(text: afterPrivacy),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSocialLoginButtons(AppLocalizations l10n) {
    return Column(
      children: [
        SocialLoginButton(
          icon: Icons.g_mobiledata,
          label: l10n.auth_continueWithGoogle,
          onPressed: _isLoading ? null : _handleGoogleLogin,
        ),
        // TODO: 카카오 사업자 동의항목(이메일) 심사 승인 후 활성화
        // const SizedBox(height: AppSizes.spaceM),
        // SocialLoginButton(
        //   icon: Icons.chat_bubble_outline,
        //   label: l10n.auth_continueWithKakao,
        //   backgroundColor: const Color(0xFFFEE500),
        //   textColor: Colors.black87,
        //   onPressed: _isLoading ? null : _handleKakaoLogin,
        // ),
      ],
    );
  }
}
