import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/core/utils/responsive.dart';
import 'package:family_planner/shared/widgets/app_logo.dart';
import 'package:family_planner/features/auth/providers/auth_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 비밀번호 찾기/설정 화면
///
/// 두 가지 사용 사례를 지원합니다:
/// 1. 비밀번호를 잊어버린 사용자의 비밀번호 재설정
/// 2. 소셜 로그인만 사용한 사용자의 최초 비밀번호 설정
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({
    super.key,
    this.isNewPasswordSetup = false,
    this.email,
  });

  /// 신규 비밀번호 설정 모드 여부
  /// true: 소셜 로그인 사용자가 처음으로 비밀번호를 설정하는 경우
  /// false: 기존 비밀번호를 잊어버려서 재설정하는 경우
  final bool isNewPasswordSetup;

  /// 사용자 이메일 (신규 비밀번호 설정 모드에서 자동 입력용)
  final String? email;

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isCodeSent = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // 신규 비밀번호 설정 모드이고 이메일이 제공된 경우
    if (widget.isNewPasswordSetup && widget.email != null) {
      _emailController.text = widget.email!;
      // 화면 로드 후 자동으로 인증 코드 요청
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _requestCode();
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// 인증 코드 요청
  Future<void> _requestCode() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(authProvider.notifier).requestPasswordReset(
            email: _emailController.text.trim(),
          );

      setState(() {
        _isCodeSent = true;
        _isLoading = false;
      });

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.auth_codeSentMessage),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.auth_codeSentError}: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 안내 문구 가져오기
  String _getGuideText(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_isCodeSent) {
      return widget.isNewPasswordSetup
          ? l10n.auth_setPasswordGuideWithCode
          : l10n.auth_forgotPasswordGuideWithCode;
    } else {
      return widget.isNewPasswordSetup
          ? l10n.auth_setPasswordGuide
          : l10n.auth_forgotPasswordGuide;
    }
  }

  /// 비밀번호 재설정
  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final l10n = AppLocalizations.of(context)!;

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.auth_passwordMismatch),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(authProvider.notifier).resetPassword(
            email: _emailController.text.trim(),
            code: _codeController.text.trim(),
            newPassword: _passwordController.text,
          );

      setState(() => _isLoading = false);

      if (mounted) {
        final successMessage = widget.isNewPasswordSetup
            ? l10n.auth_passwordSetSuccess
            : l10n.auth_resetPasswordSuccess;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(successMessage),
            backgroundColor: Colors.green,
          ),
        );

        // 신규 설정인 경우 뒤로 가기, 재설정인 경우 로그인 화면으로
        if (widget.isNewPasswordSetup) {
          // 사용자 정보 업데이트 (hasPassword가 true로 변경됨)
          try {
            await ref.read(authServiceProvider).getUserInfo();
          } catch (e) {
            debugPrint('Failed to update user info: $e');
          }
          if (mounted) {
            context.pop();
          }
        } else {
          context.go(AppRoutes.login);
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.auth_passwordResetError}: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // 화면 제목 결정
    final screenTitle = widget.isNewPasswordSetup
        ? l10n.auth_setPasswordTitle
        : l10n.auth_forgotPasswordTitle;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(screenTitle),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsivePadding.getHorizontalPadding(context),
              vertical: AppSizes.spaceM,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 500,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 로고
                    Center(
                      child: AppLogo(
                        size: Responsive.isMobile(context) ? 100 : 120,
                      ),
                    ),
                    const SizedBox(height: AppSizes.spaceXL),

                    // 안내 문구
                    Text(
                      _getGuideText(context),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSizes.spaceXXL),

                    // 이메일 입력
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      enabled: !_isCodeSent,
                      decoration: InputDecoration(
                        labelText: l10n.auth_email,
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

                    // 인증 코드가 전송되지 않은 경우
                    if (!_isCodeSent) ...[
                      const SizedBox(height: AppSizes.spaceXL),
                      SizedBox(
                        width: double.infinity,
                        height: AppSizes.buttonHeightLarge,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _requestCode,
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(l10n.auth_sendCode),
                        ),
                      ),
                    ],

                    // 인증 코드가 전송된 경우
                    if (_isCodeSent) ...[
                      const SizedBox(height: AppSizes.spaceM),

                      // 인증 코드 입력
                      TextFormField(
                        controller: _codeController,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        decoration: InputDecoration(
                          labelText: l10n.auth_verificationCodeLabel,
                          prefixIcon: const Icon(Icons.lock_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusMedium,
                            ),
                          ),
                          counterText: '',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.auth_verificationCodeError;
                          }
                          if (value.length != 6) {
                            return l10n.auth_verificationCodeLengthError;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSizes.spaceM),

                      // 새 비밀번호 입력
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: l10n.auth_newPassword,
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
                      const SizedBox(height: AppSizes.spaceM),

                      // 비밀번호 확인
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        decoration: InputDecoration(
                          labelText: l10n.auth_passwordConfirm,
                          prefixIcon: const Icon(Icons.lock_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
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
                            return l10n.auth_signupConfirmPasswordError;
                          }
                          if (value != _passwordController.text) {
                            return l10n.auth_passwordMismatch;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSizes.spaceXL),

                      // 비밀번호 재설정 버튼
                      SizedBox(
                        width: double.infinity,
                        height: AppSizes.buttonHeightLarge,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _resetPassword,
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  widget.isNewPasswordSetup
                                      ? l10n.auth_passwordSetButton
                                      : l10n.auth_passwordResetButton,
                                ),
                        ),
                      ),
                      const SizedBox(height: AppSizes.spaceM),

                      // 인증 코드 재전송 버튼
                      TextButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                setState(() {
                                  _isCodeSent = false;
                                  _codeController.clear();
                                });
                              },
                        child: Text(l10n.auth_resendCodeButton),
                      ),
                    ],

                    const SizedBox(height: AppSizes.spaceL),

                    // 로그인 화면으로 돌아가기
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${l10n.auth_rememberPassword} ',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextButton(
                          onPressed: () {
                            context.go(AppRoutes.login);
                          },
                          child: Text(l10n.auth_login),
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
    );
  }
}
