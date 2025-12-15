import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/core/utils/responsive.dart';
import 'package:family_planner/core/utils/error_handler.dart';
import 'package:family_planner/features/auth/providers/auth_provider.dart';

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
    if (_codeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('인증 코드를 입력해주세요'),
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
          .verifyEmail(code: _codeController.text.trim());

      if (!mounted) return;

      // 인증 성공 시 로그인 화면으로 이동
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('이메일 인증이 완료되었습니다. 로그인해주세요.'),
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
    setState(() {
      _isResending = true;
    });

    try {
      await ref
          .read(authProvider.notifier)
          .resendVerification(email: widget.email);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('인증 이메일을 재전송했습니다.'),
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('이메일 인증'), centerTitle: true),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsivePadding.getHorizontalPadding(context),
              vertical: AppSizes.spaceM,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
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
                    '이메일을 확인해주세요',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSizes.spaceM),

                  // 설명
                  Text(
                    '${widget.email}\n으로 인증 이메일을 보냈습니다.',
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
                            '인증 코드 입력',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: AppSizes.spaceM),
                          Text(
                            '이메일에 포함된 6자리 인증 코드를 입력해주세요.',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: AppSizes.spaceM),
                          TextField(
                            controller: _codeController,
                            decoration: InputDecoration(
                              labelText: '인증 코드',
                              hintText: '예: 123456',
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
                            height: AppSizes.buttonHeightLarge,
                            child: ElevatedButton(
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
                                  : const Text('인증하기'),
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
                          '또는',
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
                    '이메일을 받지 못하셨나요?',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSizes.spaceM),

                  // 재전송 버튼
                  SizedBox(
                    width: double.infinity,
                    height: AppSizes.buttonHeightLarge,
                    child: OutlinedButton.icon(
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
                      label: const Text('인증 이메일 재전송'),
                    ),
                  ),
                  const SizedBox(height: AppSizes.spaceXL),

                  // 로그인 링크
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '나중에 인증하기 ',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () {
                          context.go(AppRoutes.login);
                        },
                        child: const Text('로그인으로 돌아가기'),
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
