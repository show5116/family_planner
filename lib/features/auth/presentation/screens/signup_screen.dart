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
  bool _agreedToTerms = false;
  bool _agreedToPrivacy = false;

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

    final l10n = AppLocalizations.of(context)!;

    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.legal_mustAgreeTerms),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    if (!_agreedToPrivacy) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.legal_mustAgreePrivacy),
          backgroundColor: AppColors.error,
        ),
      );
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

      final email = Uri.encodeComponent(_emailController.text.trim());
      context.push('${AppRoutes.emailVerification}?email=$email');

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

    return Scaffold(
      appBar: AuthAppBar(title: l10n.auth_signup, showBackButton: true),
      body: SafeArea(
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
                    const SizedBox(height: AppSizes.spaceL),
                    _buildTermsAgreement(l10n),
                    const SizedBox(height: AppSizes.spaceM),
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

  Widget _buildTermsAgreement(AppLocalizations l10n) {
    final primary = Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _AgreeAllRow(
          checked: _agreedToTerms && _agreedToPrivacy,
          label: l10n.legal_agreeAll,
          onChanged: (value) {
            setState(() {
              _agreedToTerms = value;
              _agreedToPrivacy = value;
            });
          },
        ),
        const Divider(height: AppSizes.spaceM),
        _TermsCheckRow(
          checked: _agreedToTerms,
          label: l10n.legal_agreeToTerms,
          required: l10n.legal_required,
          onChanged: (value) => setState(() => _agreedToTerms = value),
          onTap: () => context.push(AppRoutes.termsOfService),
          color: primary,
        ),
        const SizedBox(height: AppSizes.spaceS),
        _TermsCheckRow(
          checked: _agreedToPrivacy,
          label: l10n.legal_agreeToPrivacy,
          required: l10n.legal_required,
          onChanged: (value) => setState(() => _agreedToPrivacy = value),
          onTap: () => context.push(AppRoutes.privacyPolicy),
          color: primary,
        ),
      ],
    );
  }

  Widget _buildSignupButton(AppLocalizations l10n) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          animationDuration: Duration.zero,
          minimumSize: const Size(double.infinity, AppSizes.buttonHeightLarge),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
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

class _AgreeAllRow extends StatelessWidget {
  const _AgreeAllRow({required this.checked, required this.label, required this.onChanged});

  final bool checked;
  final String label;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!checked),
      borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceXS),
        child: Row(
          children: [
            Checkbox(
              value: checked,
              onChanged: (v) => onChanged(v ?? false),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class _TermsCheckRow extends StatelessWidget {
  const _TermsCheckRow({
    required this.checked,
    required this.label,
    required this.required,
    required this.onChanged,
    required this.onTap,
    required this.color,
  });

  final bool checked;
  final String label;
  final String required;
  final ValueChanged<bool> onChanged;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: checked,
          onChanged: (v) => onChanged(v ?? false),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => onChanged(!checked),
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ),
        Text(required, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.error)),
        const SizedBox(width: AppSizes.spaceXS),
        GestureDetector(
          onTap: onTap,
          child: Text(
            '>',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
