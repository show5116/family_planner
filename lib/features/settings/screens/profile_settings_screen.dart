import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/services/secure_storage_service.dart';
import 'package:family_planner/features/auth/providers/auth_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 전화번호 자동 포맷팅을 위한 InputFormatter
class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // 숫자만 추출
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // 숫자가 없으면 빈 값 반환
    if (digitsOnly.isEmpty) {
      return const TextEditingValue();
    }

    // 최대 11자리까지만 허용
    final limitedDigits = digitsOnly.substring(0, digitsOnly.length > 11 ? 11 : digitsOnly.length);

    // 포맷팅
    String formatted = '';
    if (limitedDigits.length <= 3) {
      // 010
      formatted = limitedDigits;
    } else if (limitedDigits.length <= 7) {
      // 010-1234
      formatted = '${limitedDigits.substring(0, 3)}-${limitedDigits.substring(3)}';
    } else {
      // 010-1234-5678
      formatted = '${limitedDigits.substring(0, 3)}-${limitedDigits.substring(3, 7)}-${limitedDigits.substring(7)}';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// 프로필 설정 화면
class ProfileSettingsScreen extends ConsumerStatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  ConsumerState<ProfileSettingsScreen> createState() =>
      _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends ConsumerState<ProfileSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _profileImageController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _storage = SecureStorageService();
  Map<String, dynamic>? _userInfo;

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  bool _isPasswordChangeMode = false;
  bool _hasPassword = true; // 사용자가 비밀번호를 가지고 있는지 여부

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _profileImageController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _loadUserInfo() async {
    final userInfo = await _storage.getUserInfo();
    if (mounted) {
      setState(() {
        _userInfo = userInfo;
        _nameController.text = userInfo['name'] as String? ?? '';
        _phoneNumberController.text = userInfo['phoneNumber'] as String? ?? '';
        _profileImageController.text = userInfo['profileImage'] as String? ?? '';
        _hasPassword = userInfo['hasPassword'] as bool? ?? true;
      });
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final l10n = AppLocalizations.of(context)!;

    // 비밀번호 변경 모드인 경우 비밀번호 일치 확인
    if (_isPasswordChangeMode) {
      if (_newPasswordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.profile_passwordsDoNotMatch),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(authProvider.notifier).updateProfile(
            name: _nameController.text.trim().isEmpty
                ? null
                : _nameController.text.trim(),
            phoneNumber: _phoneNumberController.text.trim().isEmpty
                ? null
                : _phoneNumberController.text.trim(),
            profileImage: _profileImageController.text.trim().isEmpty
                ? null
                : _profileImageController.text.trim(),
            currentPassword: _hasPassword ? _currentPasswordController.text : null,
            newPassword:
                _isPasswordChangeMode && _newPasswordController.text.isNotEmpty
                    ? _newPasswordController.text
                    : null,
          );

      setState(() => _isLoading = false);

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.profile_updateSuccess),
            backgroundColor: Colors.green,
          ),
        );

        // 사용자 정보 재로드
        await _loadUserInfo();

        // 비밀번호 변경 모드였다면 필드 초기화
        if (_isPasswordChangeMode) {
          _currentPasswordController.clear();
          _newPasswordController.clear();
          _confirmPasswordController.clear();
          setState(() => _isPasswordChangeMode = false);
        }

        // 설정 화면으로 돌아가기
        if (mounted) {
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.profile_updateFailed}: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileImage = _userInfo?['profileImage'] as String?;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(l10n.profile_title),
        actions: [
          if (!_isLoading)
            TextButton(
              onPressed: _updateProfile,
              child: Text(l10n.profile_save),
            ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.spaceM),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 600,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
              // 프로필 이미지 미리보기
              Center(
                child: Column(
                  children: [
                    profileImage != null && profileImage.isNotEmpty
                        ? CircleAvatar(
                            radius: 60,
                            backgroundImage:
                                CachedNetworkImageProvider(profileImage),
                          )
                        : CircleAvatar(
                            radius: 60,
                            child: Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.grey[400],
                            ),
                          ),
                    const SizedBox(height: AppSizes.spaceS),
                    Text(
                      _userInfo?['email'] as String? ?? '',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.spaceXL),

              // 이름 입력
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l10n.profile_name,
                  prefixIcon: const Icon(Icons.person_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.profile_nameRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSizes.spaceM),

              // 전화번호 입력
              TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  labelText: l10n.profile_phoneNumber,
                  prefixIcon: const Icon(Icons.phone_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  ),
                  helperText: l10n.profile_phoneNumberHint,
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  PhoneNumberFormatter(),
                ],
              ),
              const SizedBox(height: AppSizes.spaceM),

              // 프로필 이미지 URL 입력
              TextFormField(
                controller: _profileImageController,
                decoration: InputDecoration(
                  labelText: l10n.profile_profileImage,
                  prefixIcon: const Icon(Icons.image_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  ),
                  helperText: l10n.profile_profileImageHint,
                ),
              ),
              const SizedBox(height: AppSizes.spaceL),

              // 현재 비밀번호 (항상 표시, 필수)
              if (_hasPassword) ...[
                Text(
                  l10n.profile_currentPassword,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: AppSizes.spaceS),
                TextFormField(
                  controller: _currentPasswordController,
                  obscureText: _obscureCurrentPassword,
                  decoration: InputDecoration(
                    labelText: l10n.profile_currentPassword,
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureCurrentPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureCurrentPassword = !_obscureCurrentPassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppSizes.radiusMedium),
                    ),
                  ),
                  validator: (value) {
                    if (_hasPassword && (value == null || value.isEmpty)) {
                      return l10n.profile_currentPasswordRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSizes.spaceL),
              ],

              // 비밀번호 변경 섹션
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
                    value: _isPasswordChangeMode,
                    onChanged: (value) {
                      setState(() {
                        _isPasswordChangeMode = value;
                        if (!value) {
                          _newPasswordController.clear();
                          _confirmPasswordController.clear();
                        }
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.spaceS),

              if (_isPasswordChangeMode) ...[
                // 새 비밀번호
                TextFormField(
                  controller: _newPasswordController,
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
                      borderRadius:
                          BorderRadius.circular(AppSizes.radiusMedium),
                    ),
                  ),
                  validator: (value) {
                    if (_isPasswordChangeMode &&
                        (value == null || value.isEmpty)) {
                      return l10n.profile_newPasswordRequired;
                    }
                    if (_isPasswordChangeMode && value!.length < 6) {
                      return l10n.profile_newPasswordMinLength;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSizes.spaceM),

                // 새 비밀번호 확인
                TextFormField(
                  controller: _confirmPasswordController,
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
                      borderRadius:
                          BorderRadius.circular(AppSizes.radiusMedium),
                    ),
                  ),
                  validator: (value) {
                    if (_isPasswordChangeMode &&
                        (value == null || value.isEmpty)) {
                      return l10n.profile_confirmNewPasswordRequired;
                    }
                    if (_isPasswordChangeMode &&
                        value != _newPasswordController.text) {
                      return l10n.profile_passwordsDoNotMatch;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSizes.spaceL),
              ],

              // 저장 버튼
              SizedBox(
                width: double.infinity,
                height: AppSizes.buttonHeightLarge,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _updateProfile,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.profile_save),
                ),
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
