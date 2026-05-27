import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/routes/app_routes.dart';
import 'package:family_planner/features/auth/providers/auth_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 소셜 신규 회원가입 약관 동의 화면
///
/// 소셜 로그인 응답에 isNewUser: true + tempToken이 있을 때 표시됩니다.
/// 동의 후 POST /auth/social-signup을 호출하여 가입을 완료합니다.
///
/// [webTempToken]: 웹에서 /auth/terms?tempToken=... URL로 직접 진입한 경우 전달됩니다.
class SocialTermsScreen extends ConsumerStatefulWidget {
  const SocialTermsScreen({super.key, this.webTempToken});

  final String? webTempToken;

  @override
  ConsumerState<SocialTermsScreen> createState() => _SocialTermsScreenState();
}

class _SocialTermsScreenState extends ConsumerState<SocialTermsScreen> {
  bool _agreedToTerms = false;
  bool _agreedToPrivacy = false;
  bool _agreedToAge = false;
  bool _isLoading = false;

  bool get _agreedAll => _agreedToTerms && _agreedToPrivacy && _agreedToAge;
  bool get _canSubmit => _agreedAll;

  @override
  void initState() {
    super.initState();
    final token = widget.webTempToken;
    if (token != null && token.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(authProvider.notifier).setPendingTempToken(token);
      });
    }
  }

  void _toggleAll(bool value) {
    setState(() {
      _agreedToTerms = value;
      _agreedToPrivacy = value;
      _agreedToAge = value;
    });
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;

    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.legal_mustAgreeTerms), backgroundColor: AppColors.error),
      );
      return;
    }
    if (!_agreedToPrivacy) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.legal_mustAgreePrivacy), backgroundColor: AppColors.error),
      );
      return;
    }
    if (!_agreedToAge) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.legal_mustAgreeAgeVerification), backgroundColor: AppColors.error),
      );
      return;
    }

    // tempToken 확인
    final tempToken = ref.read(authProvider).pendingTempToken;
    if (tempToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('오류: 인증 토큰이 없습니다. 다시 로그인해주세요.'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(authProvider.notifier).completeSocialSignup();
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
    final l10n = AppLocalizations.of(context)!;
    final primary = Theme.of(context).colorScheme.primary;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) ref.read(authProvider.notifier).cancelSocialSignup();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('서비스 이용 동의'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => ref.read(authProvider.notifier).cancelSocialSignup(),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.spaceL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '패밀리플래너 서비스 이용을\n위해 약관에 동의해 주세요',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSizes.spaceXL),
                _AgreeAllRow(
                  checked: _agreedAll,
                  label: l10n.legal_agreeAll,
                  onChanged: _toggleAll,
                ),
                const Divider(height: AppSizes.spaceM),
                _TermsCheckRow(
                  checked: _agreedToTerms,
                  label: l10n.legal_agreeToTerms,
                  required: l10n.legal_required,
                  onChanged: (v) => setState(() => _agreedToTerms = v),
                  onTap: () => context.push(AppRoutes.termsOfService),
                  color: primary,
                ),
                const SizedBox(height: AppSizes.spaceS),
                _TermsCheckRow(
                  checked: _agreedToPrivacy,
                  label: l10n.legal_agreeToPrivacy,
                  required: l10n.legal_required,
                  onChanged: (v) => setState(() => _agreedToPrivacy = v),
                  onTap: () => context.push(AppRoutes.privacyPolicy),
                  color: primary,
                ),
                const SizedBox(height: AppSizes.spaceS),
                _AgeCheckRow(
                  checked: _agreedToAge,
                  label: l10n.legal_agreeAgeVerification,
                  onChanged: (v) => setState(() => _agreedToAge = v),
                ),
                const Spacer(),
                FilledButton(
                  onPressed: (_canSubmit && !_isLoading) ? _submit : null,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('동의하고 시작하기'),
                ),
              ],
            ),
          ),
        ),
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
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
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
        Text(
          required,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.error),
        ),
        IconButton(
          onPressed: onTap,
          icon: Icon(Icons.chevron_right, color: color),
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }
}

class _AgeCheckRow extends StatelessWidget {
  const _AgeCheckRow({required this.checked, required this.label, required this.onChanged});

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
            Expanded(
              child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
            ),
            Text(
              AppLocalizations.of(context)!.legal_required,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.error),
            ),
            const SizedBox(width: AppSizes.spaceS),
          ],
        ),
      ),
    );
  }
}
