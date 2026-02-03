import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 비밀번호 변경 섹션 위젯
class PasswordChangeSection extends StatefulWidget {
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final bool isEnabled;
  final ValueChanged<bool> onEnabledChanged;

  const PasswordChangeSection({
    super.key,
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.isEnabled,
    required this.onEnabledChanged,
  });

  @override
  State<PasswordChangeSection> createState() => _PasswordChangeSectionState();
}

class _PasswordChangeSectionState extends State<PasswordChangeSection> {
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 헤더
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.profile_changePassword,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Switch(
              value: widget.isEnabled,
              onChanged: widget.onEnabledChanged,
            ),
          ],
        ),
        const SizedBox(height: AppSizes.spaceS),

        // 비밀번호 입력 필드들
        if (widget.isEnabled) ...[
          // 새 비밀번호
          TextFormField(
            controller: widget.newPasswordController,
            obscureText: _obscureNewPassword,
            decoration: InputDecoration(
              labelText: l10n.profile_newPassword,
              prefixIcon: const Icon(Icons.lock_outlined),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureNewPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () {
                  setState(() {
                    _obscureNewPassword = !_obscureNewPassword;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              ),
            ),
            validator: (value) {
              if (widget.isEnabled && (value == null || value.isEmpty)) {
                return l10n.profile_newPasswordRequired;
              }
              if (widget.isEnabled && value!.length < 6) {
                return l10n.profile_newPasswordMinLength;
              }
              return null;
            },
          ),
          const SizedBox(height: AppSizes.spaceM),

          // 새 비밀번호 확인
          TextFormField(
            controller: widget.confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            decoration: InputDecoration(
              labelText: l10n.profile_confirmNewPassword,
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
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              ),
            ),
            validator: (value) {
              if (widget.isEnabled && (value == null || value.isEmpty)) {
                return l10n.profile_confirmNewPasswordRequired;
              }
              if (widget.isEnabled &&
                  value != widget.newPasswordController.text) {
                return l10n.profile_passwordsDoNotMatch;
              }
              return null;
            },
          ),
          const SizedBox(height: AppSizes.spaceL),
        ],
      ],
    );
  }
}
