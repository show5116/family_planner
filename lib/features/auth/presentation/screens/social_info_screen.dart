import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/auth/providers/auth_provider.dart';

/// 소셜 신규 회원가입 — 이름/이메일 입력 화면
///
/// SocialTermsScreen에서 약관 동의 완료 후
/// needsName 또는 needsEmail이 true인 경우 이 화면으로 이동합니다.
class SocialInfoScreen extends ConsumerStatefulWidget {
  const SocialInfoScreen({super.key});

  @override
  ConsumerState<SocialInfoScreen> createState() => _SocialInfoScreenState();
}

class _SocialInfoScreenState extends ConsumerState<SocialInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(authProvider.notifier).completeSocialSignup(
        name: _nameController.text.trim().isNotEmpty ? _nameController.text.trim() : null,
        email: _emailController.text.trim().isNotEmpty ? _emailController.text.trim() : null,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final needsName = authState.needsName;
    final needsEmail = authState.needsEmail;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) ref.read(authProvider.notifier).cancelSocialSignup();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('정보 입력'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => ref.read(authProvider.notifier).cancelSocialSignup(),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.spaceL),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '서비스 이용에 필요한\n정보를 입력해 주세요',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSizes.spaceXL),
                  if (needsName) ...[
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: '이름 (필수)',
                        hintText: '홍길동',
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: needsEmail ? TextInputAction.next : TextInputAction.done,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return '이름을 입력해 주세요';
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSizes.spaceM),
                  ],
                  if (needsEmail) ...[
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: '이메일 (선택)',
                        hintText: 'example@email.com',
                        helperText: '입력하지 않으면 비공개로 가입됩니다',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return null;
                        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                        if (!emailRegex.hasMatch(v.trim())) return '올바른 이메일 형식을 입력해 주세요';
                        return null;
                      },
                    ),
                  ],
                  const Spacer(),
                  FilledButton(
                    onPressed: _isLoading ? null : _submit,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('시작하기'),
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
