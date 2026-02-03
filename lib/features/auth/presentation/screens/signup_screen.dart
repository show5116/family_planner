import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/core/utils/responsive.dart';
import 'package:family_planner/core/utils/validators.dart';
import 'package:family_planner/core/utils/error_handler.dart';
import 'package:family_planner/shared/widgets/app_logo.dart';
import 'package:family_planner/features/auth/providers/auth_provider.dart';
import 'package:family_planner/features/auth/presentation/widgets/auth_app_bar.dart';
import 'package:family_planner/features/auth/presentation/widgets/auth_link_row.dart';
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

  bool get _isMobileWeb {
    return kIsWeb &&
           (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS);
  }

  double? _initialScreenHeight;

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

    setState(() => _isLoading = true);

    try {
      await ref
          .read(authProvider.notifier)
          .signup(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            name: _nameController.text.trim(),
          );

      if (!mounted) return;

      context.push(
        AppRoutes.emailVerification,
        extra: _emailController.text.trim(),
      );

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
          content: Text(ErrorHandler.getErrorMessage(e)),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isMobileWeb && _initialScreenHeight == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _initialScreenHeight = MediaQuery.of(context).size.height;
        });
      });
    }

    final screenHeight = _isMobileWeb && _initialScreenHeight != null
        ? _initialScreenHeight!
        : MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AuthAppBar(title: l10n.auth_signup, showBackButton: true),
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppLogo(size: Responsive.isMobile(context) ? 120 : 150),
                      SizedBox(
                        height: Responsive.isMobile(context)
                            ? AppSizes.spaceXL
                            : AppSizes.spaceXXL,
                      ),
                      _buildNameField(l10n),
                      const SizedBox(height: AppSizes.spaceM),
                      _buildEmailField(l10n),
                      const SizedBox(height: AppSizes.spaceM),
                      _buildPasswordField(l10n),
                      const SizedBox(height: AppSizes.spaceM),
                      _buildConfirmPasswordField(l10n),
                      const SizedBox(height: AppSizes.spaceXL),
                      _buildSignupButton(l10n),
                      const SizedBox(height: AppSizes.spaceXL),
                      AuthLinkRow(
                        text: '${l10n.auth_haveAccount} ',
                        linkText: l10n.auth_login,
                        onPressed: () => context.pop(),
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

  Widget _buildNameField(AppLocalizations l10n) {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: l10n.auth_signupNameLabel,
        prefixIcon: const Icon(Icons.person_outline),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
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
    );
  }

  Widget _buildEmailField(AppLocalizations l10n) {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: l10n.auth_email,
        prefixIcon: const Icon(Icons.email_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: Validators.email,
    );
  }

  Widget _buildPasswordField(AppLocalizations l10n) {
    return TextFormField(
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
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
        helperText: l10n.auth_signupPasswordHelperText,
      ),
      textInputAction: TextInputAction.next,
      validator: Validators.password,
    );
  }

  Widget _buildConfirmPasswordField(AppLocalizations l10n) {
    return TextFormField(
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
          onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
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
    );
  }

  Widget _buildSignupButton(AppLocalizations l10n) {
    return SizedBox(
      width: double.infinity,
      height: AppSizes.buttonHeightLarge,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(animationDuration: Duration.zero),
        onPressed: _isLoading ? null : _handleSignup,
        child: _isLoading
            ? const SizedBox(
                height: AppSizes.iconMedium,
                width: AppSizes.iconMedium,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(l10n.auth_signupButton),
      ),
    );
  }
}
