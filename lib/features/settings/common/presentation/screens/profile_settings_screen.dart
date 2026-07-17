import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:family_planner/core/utils/network_image_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/widgets/color_picker.dart';
import 'package:family_planner/core/utils/color_utils.dart';
import 'package:family_planner/shared/widgets/scrollable_form_body.dart';
import 'package:family_planner/shared/widgets/form_bottom_bar.dart';
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
    final limitedDigits = digitsOnly.substring(
      0,
      digitsOnly.length > 11 ? 11 : digitsOnly.length,
    );

    // 포맷팅
    String formatted = '';
    if (limitedDigits.length <= 3) {
      // 010
      formatted = limitedDigits;
    } else if (limitedDigits.length <= 7) {
      // 010-1234
      formatted =
          '${limitedDigits.substring(0, 3)}-${limitedDigits.substring(3)}';
    } else {
      // 010-1234-5678
      formatted =
          '${limitedDigits.substring(0, 3)}-${limitedDigits.substring(3, 7)}-${limitedDigits.substring(7)}';
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
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  bool _isPasswordChangeMode = false;
  bool _hasPassword = true; // 사용자가 비밀번호를 가지고 있는지 여부
  bool _isUploadingImage = false;
  Color? _personalColor;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initFromProvider());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _initFromProvider() {
    final userInfo = ref.read(authProvider).user;
    if (userInfo == null || !mounted) return;
    setState(() {
      _nameController.text = userInfo['name'] as String? ?? '';
      _phoneNumberController.text = userInfo['phoneNumber'] as String? ?? '';
      _hasPassword = userInfo['hasPassword'] as bool? ?? true;
      _personalColor = ColorUtils.parseColor(
        userInfo['personalColor'] as String?,
      );
    });
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
      await ref
          .read(authProvider.notifier)
          .updateProfile(
            name: _nameController.text.trim().isEmpty
                ? null
                : _nameController.text.trim(),
            phoneNumber: _phoneNumberController.text.trim().isEmpty
                ? null
                : _phoneNumberController.text.trim(),
            currentPassword: _hasPassword
                ? _currentPasswordController.text
                : null,
            newPassword:
                _isPasswordChangeMode && _newPasswordController.text.isNotEmpty
                ? _newPasswordController.text
                : null,
            personalColor: _personalColor != null
                ? ColorUtils.colorToHex(_personalColor!)
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

  Widget _buildPersonalColorSection(BuildContext context) {
    final displayColor = _personalColor ?? Colors.grey;
    return Row(
      children: [
        Icon(Icons.palette_outlined, color: Colors.grey[600]),
        const SizedBox(width: AppSizes.spaceS),
        Expanded(
          child: Text('개인 색상', style: Theme.of(context).textTheme.bodyMedium),
        ),
        GestureDetector(
          onTap: () async {
            final picked = await showColorPickerDialog(
              context: context,
              title: '개인 색상 선택',
              initialColor: _personalColor,
            );
            if (picked != null) {
              setState(() => _personalColor = picked);
            }
          },
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: displayColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300),
                ),
              ),
              if (_personalColor != null) ...[
                const SizedBox(width: AppSizes.spaceXS),
                GestureDetector(
                  onTap: () => setState(() => _personalColor = null),
                  child: Icon(
                    Icons.close,
                    size: AppSizes.iconSmall,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  /// 프로필 사진 업로드
  Future<void> _uploadProfilePhoto() async {
    final l10n = AppLocalizations.of(context)!;
    final picker = ImagePicker();

    try {
      setState(() => _isUploadingImage = true);

      // 이미지 선택
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image == null) {
        setState(() => _isUploadingImage = false);
        return;
      }

      // 이미지 파일을 바이트로 읽기 (웹과 모바일 모두 지원)
      final bytes = await image.readAsBytes();
      final fileName = image.name;

      // 프로필 사진 업로드
      await ref.read(authProvider.notifier).uploadProfilePhoto(bytes, fileName);

      setState(() => _isUploadingImage = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.profile_uploadSuccess),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() => _isUploadingImage = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.profile_uploadFailed}: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = ref.watch(authProvider).user;
    final profileImageUrl = userInfo?['profileImageUrl'] as String?;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profile_title)),
      body: Column(
        children: [
          Expanded(
            child: ScrollableFormBody(
              maxWidth: 600,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 프로필 이미지 미리보기 및 업로드
                    Center(
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              profileImageUrl != null &&
                                      profileImageUrl.isNotEmpty
                                  ? CircleAvatar(
                                      radius: 60,
                                      backgroundImage: networkImageProvider(
                                        profileImageUrl,
                                      ),
                                    )
                                  : CircleAvatar(
                                      radius: 60,
                                      child: Icon(
                                        Icons.person,
                                        size: 60,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                              if (_isUploadingImage)
                                const Positioned.fill(
                                  child: CircleAvatar(
                                    radius: 60,
                                    backgroundColor: Colors.black54,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.primary,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.camera_alt,
                                      size: 20,
                                    ),
                                    color: Colors.white,
                                    onPressed: _isUploadingImage
                                        ? null
                                        : _uploadProfilePhoto,
                                    padding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSizes.spaceS),
                          Text(
                            userInfo?['email'] as String? ?? '',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.grey[600]),
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
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusMedium,
                          ),
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
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusMedium,
                          ),
                        ),
                        helperText: l10n.profile_phoneNumberHint,
                      ),
                      keyboardType: TextInputType.phone,
                      inputFormatters: [PhoneNumberFormatter()],
                    ),
                    const SizedBox(height: AppSizes.spaceM),

                    // 개인 색상
                    _buildPersonalColorSection(context),
                    const SizedBox(height: AppSizes.spaceL),

                    // 현재 비밀번호 (항상 표시, 필수)
                    if (_hasPassword) ...[
                      Text(
                        l10n.profile_currentPassword,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
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
                                _obscureCurrentPassword =
                                    !_obscureCurrentPassword;
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
                          if (_hasPassword &&
                              (value == null || value.isEmpty)) {
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
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
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
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusMedium,
                            ),
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

                    const SizedBox(height: AppSizes.spaceXL),
                    const Divider(),
                    const SizedBox(height: AppSizes.spaceM),

                    // 계정 관리 섹션
                    Text(
                      l10n.account_management_title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: AppSizes.spaceM),

                    // 데이터 내보내기
                    _buildAccountTile(
                      context,
                      icon: Icons.download_outlined,
                      title: l10n.account_export_data_title,
                      subtitle: l10n.account_export_data_subtitle,
                      onTap: _exportData,
                    ),

                    // 계정 삭제 예약 취소 — scheduledDeleteAt 있을 때만 표시
                    if (ref.watch(authProvider).scheduledDeleteAt != null) ...[
                      const SizedBox(height: AppSizes.spaceS),
                      _buildAccountTile(
                        context,
                        icon: Icons.cancel_outlined,
                        title: l10n.account_cancel_delete_title,
                        subtitle: l10n.account_cancel_delete_subtitle,
                        onTap: _cancelDeleteAccount,
                      ),
                    ],

                    // 계정 삭제 예약 — scheduledDeleteAt 없을 때만 표시 (이미 예약 중이면 숨김)
                    if (ref.watch(authProvider).scheduledDeleteAt == null) ...[
                      const SizedBox(height: AppSizes.spaceS),
                      _buildAccountTile(
                        context,
                        icon: Icons.delete_forever_outlined,
                        title: l10n.account_delete_schedule_title,
                        subtitle: l10n.account_delete_schedule_subtitle,
                        onTap: _scheduleDeleteAccount,
                        isDestructive: true,
                      ),
                    ],
                    const SizedBox(height: AppSizes.spaceXL),
                  ],
                ),
              ),
            ),
          ),
          FormBottomBar(
            label: l10n.profile_save,
            isLoading: _isLoading,
            onPressed: _updateProfile,
          ),
        ],
      ),
    );
  }

  Widget _buildAccountTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? Theme.of(context).colorScheme.error : null;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color)),
      subtitle: Text(subtitle),
      trailing: Icon(Icons.chevron_right, color: color),
      onTap: onTap,
    );
  }

  Future<void> _scheduleDeleteAccount() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Theme.of(ctx).colorScheme.error,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(l10n.account_delete_schedule_confirm_title)),
          ],
        ),
        content: Text(l10n.account_delete_schedule_confirm_body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(MaterialLocalizations.of(ctx).cancelButtonLabel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
              foregroundColor: Theme.of(ctx).colorScheme.onError,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.account_delete_schedule_title),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isLoading = true);
    try {
      final scheduledAt = await ref
          .read(authProvider.notifier)
          .scheduleDeleteAccount();
      if (!mounted) return;
      final dateStr =
          '${scheduledAt.year}-${scheduledAt.month.toString().padLeft(2, '0')}-${scheduledAt.day.toString().padLeft(2, '0')}';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.account_delete_schedule_success(dateStr))),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.account_action_failed(e.toString())),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _cancelDeleteAccount() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.account_cancel_delete_confirm_title),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(MaterialLocalizations.of(ctx).cancelButtonLabel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.account_cancel_delete_title),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isLoading = true);
    try {
      await ref.read(authProvider.notifier).cancelDeleteAccount();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.account_cancel_delete_success),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.account_action_failed(e.toString())),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _exportData() async {
    final l10n = AppLocalizations.of(context)!;

    setState(() => _isLoading = true);
    try {
      await ref.read(authProvider.notifier).exportMyData();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.account_export_data_success),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.account_action_failed(e.toString())),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
