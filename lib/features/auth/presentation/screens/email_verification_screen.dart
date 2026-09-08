import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/core/utils/responsive.dart';
import 'package:family_planner/core/utils/error_handler.dart';
import 'package:family_planner/features/auth/providers/auth_provider.dart';
import 'package:family_planner/shared/widgets/scrollable_form_body.dart';

/// 이메일 인증 화면
class EmailVerificationScreen extends ConsumerStatefulWidget {
  const EmailVerificationScreen({super.key, required this.email});

  final String email;

  @override
  ConsumerState<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState
    extends ConsumerState<EmailVerificationScreen> {
  final _codeController = TextEditingController();
  bool _isLoading = false;
  bool _isResending = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _handleVerifyEmail() async {
    final l10n = AppLocalizations.of(context)!;
    if (_codeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.auth_code_required),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await ref
          .read(authProvider.notifier)
          .verifyEmail(email: widget.email, code: _codeController.text.trim());

      if (!mounted) return;

      // 인증 성공 시 로그인 화면으로 이동
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.auth_email_verified),
          backgroundColor: AppColors.success,
        ),
      );

      // 로그인 화면으로 이동 (스택 초기화)
      context.go(AppRoutes.login);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ErrorHandler.getErrorMessage(e)), backgroundColor: AppColors.error),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleResendVerification() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _isResending = true;
    });

    try {
      await ref
          .read(authProvider.notifier)
          .resendVerification(email: widget.email);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.auth_email_resent),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ErrorHandler.getErrorMessage(e)), backgroundColor: AppColors.error),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isResending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.auth_email_verification), centerTitle: true),
      body: ScrollableFormBody(
        maxWidth: 500,
        padding: EdgeInsets.symmetric(
          horizontal: ResponsivePadding.getHorizontalPadding(context),
          vertical: AppSizes.spaceM,
        ),
        child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 아이콘
                  Container(
                    padding: const EdgeInsets.all(AppSizes.spaceXL),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.email_outlined,
                      size: Responsive.isMobile(context) ? 80 : 100,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppSizes.spaceXL),

                  // 제목
                  Text(
                    l10n.auth_check_email,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSizes.spaceM),

                  // 설명
                  Text(
                    l10n.auth_email_sent_to(widget.email),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSizes.spaceXXL),

                  // 인증 코드 입력
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.spaceL),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.auth_enter_code,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: AppSizes.spaceM),
                          Text(
                            l10n.auth_enter_code_desc,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: AppSizes.spaceM),
                          TextField(
                            controller: _codeController,
                            decoration: InputDecoration(
                              labelText: l10n.auth_code_label,
                              hintText: l10n.auth_code_hint,
                              prefixIcon: const Icon(Icons.vpn_key_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  AppSizes.radiusMedium,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => _handleVerifyEmail(),
                          ),
                          const SizedBox(height: AppSizes.spaceM),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, AppSizes.buttonHeightLarge),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              onPressed: _isLoading ? null : _handleVerifyEmail,
                              child: _isLoading
                                  ? const SizedBox(
                                      height: AppSizes.iconMedium,
                                      width: AppSizes.iconMedium,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                  : Text(l10n.auth_verify),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.spaceXL),

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
                  const SizedBox(height: AppSizes.spaceXL),

                  // 재전송 안내
                  Text(
                    l10n.auth_no_email,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSizes.spaceM),

                  // 재전송 버튼
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, AppSizes.buttonHeightLarge),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: _isResending
                          ? null
                          : _handleResendVerification,
                      icon: _isResending
                          ? const SizedBox(
                              height: AppSizes.iconSmall,
                              width: AppSizes.iconSmall,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.refresh),
                      label: Text(l10n.auth_resend_email),
                    ),
                  ),
                  const SizedBox(height: AppSizes.spaceXL),

                  // 로그인 링크
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.auth_verify_later,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () {
                          context.go(AppRoutes.login);
                        },
                        child: Text(l10n.auth_back_to_signin),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
