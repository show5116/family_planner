import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/core/utils/responsive.dart';
import 'package:family_planner/core/utils/validators.dart';
import 'package:family_planner/shared/widgets/app_logo.dart';
import 'package:family_planner/shared/widgets/language_selector_button.dart';
import 'package:family_planner/shared/widgets/theme_toggle_button.dart';
import 'package:family_planner/features/auth/providers/auth_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 회원가입 화면
class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await ref.read(authProvider.notifier).signup(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            name: _nameController.text.trim(),
          );

      if (!mounted) return;

      // 회원가입 성공 시 이메일 인증 화면으로 이동
      context.push(
        AppRoutes.emailVerification,
        extra: _emailController.text.trim(),
      );

      // 성공 메시지
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.auth_signupEmailVerificationMessage,
          ),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.auth_signup),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          ThemeToggleButton(key: ValueKey('theme_toggle_$hashCode'), isOnPrimaryColor: true),
          const SizedBox(width: AppSizes.spaceXS),
          Padding(
            padding: const EdgeInsets.only(right: AppSizes.spaceS),
            child: LanguageSelectorButton(key: ValueKey('language_selector_$hashCode'), isOnPrimaryColor: true),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsivePadding.getHorizontalPadding(context),
                vertical: AppSizes.spaceXL,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - AppSizes.spaceXL * 2,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                // 로고
                AppLogo(size: Responsive.isMobile(context) ? 120 : 150),
                SizedBox(
                  height: Responsive.isMobile(context)
                      ? AppSizes.spaceXL
                      : AppSizes.spaceXXL,
                ),

                // 이름 입력
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: l10n.auth_signupNameLabel,
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppSizes.radiusMedium,
                      ),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.auth_nameError;
                    }
                    if (value.trim().length < 2) {
                      return l10n.auth_signupNameMinLengthError;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSizes.spaceM),

                // 이메일 입력
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: l10n.auth_email,
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppSizes.radiusMedium,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: Validators.email,
                ),
                const SizedBox(height: AppSizes.spaceM),

                // 비밀번호 입력
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: l10n.auth_password,
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
                    helperText: l10n.auth_signupPasswordHelperText,
                  ),
                  textInputAction: TextInputAction.next,
                  validator: Validators.password,
                ),
                const SizedBox(height: AppSizes.spaceM),

                // 비밀번호 확인 입력
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: l10n.auth_signupConfirmPasswordLabel,
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppSizes.radiusMedium,
                      ),
                    ),
                  ),
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.auth_signupConfirmPasswordError;
                    }
                    if (value != _passwordController.text) {
                      return l10n.auth_passwordMismatch;
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) => _handleSignup(),
                ),
                const SizedBox(height: AppSizes.spaceXL),

                // 회원가입 버튼
                SizedBox(
                  width: double.infinity,
                  height: AppSizes.buttonHeightLarge,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      animationDuration: Duration.zero,
                    ),
                    onPressed: _isLoading ? null : _handleSignup,
                    child: _isLoading
                        ? const SizedBox(
                            height: AppSizes.iconMedium,
                            width: AppSizes.iconMedium,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(l10n.auth_signupButton),
                  ),
                ),
                const SizedBox(height: AppSizes.spaceXL),

                // 로그인 링크
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${l10n.auth_haveAccount} ',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        animationDuration: Duration.zero,
                      ),
                      onPressed: () {
                        context.pop();
                      },
                      child: Text(l10n.auth_login),
                    ),
                  ],
                ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}
}
