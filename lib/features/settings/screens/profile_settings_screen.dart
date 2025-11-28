import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/services/secure_storage_service.dart';
import 'package:family_planner/features/auth/providers/auth_provider.dart';

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

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  @override
  void dispose() {
    _nameController.dispose();
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
        _profileImageController.text = userInfo['profileImage'] as String? ?? '';
      });
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // 비밀번호 변경 모드인 경우 비밀번호 일치 확인
    if (_isPasswordChangeMode) {
      if (_newPasswordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('새 비밀번호가 일치하지 않습니다'),
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
            profileImage: _profileImageController.text.trim().isEmpty
                ? null
                : _profileImageController.text.trim(),
            currentPassword: _isPasswordChangeMode &&
                    _currentPasswordController.text.isNotEmpty
                ? _currentPasswordController.text
                : null,
            newPassword:
                _isPasswordChangeMode && _newPasswordController.text.isNotEmpty
                    ? _newPasswordController.text
                    : null,
          );

      setState(() => _isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('프로필이 업데이트되었습니다'),
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
      }
    } catch (e) {
      setState(() => _isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('프로필 업데이트 실패: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileImage = _userInfo?['profileImage'] as String?;

    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필 설정'),
        actions: [
          if (!_isLoading)
            TextButton(
              onPressed: _updateProfile,
              child: const Text('저장'),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  labelText: '이름',
                  prefixIcon: const Icon(Icons.person_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '이름을 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSizes.spaceM),

              // 프로필 이미지 URL 입력
              TextFormField(
                controller: _profileImageController,
                decoration: InputDecoration(
                  labelText: '프로필 이미지 URL (선택사항)',
                  prefixIcon: const Icon(Icons.image_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  ),
                  helperText: '이미지 URL을 입력하세요',
                ),
              ),
              const SizedBox(height: AppSizes.spaceL),

              // 비밀번호 변경 섹션
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '비밀번호 변경',
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
                          _currentPasswordController.clear();
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
                // 현재 비밀번호
                TextFormField(
                  controller: _currentPasswordController,
                  obscureText: _obscureCurrentPassword,
                  decoration: InputDecoration(
                    labelText: '현재 비밀번호',
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
                    if (_isPasswordChangeMode &&
                        (value == null || value.isEmpty)) {
                      return '현재 비밀번호를 입력해주세요';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSizes.spaceM),

                // 새 비밀번호
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: _obscureNewPassword,
                  decoration: InputDecoration(
                    labelText: '새 비밀번호',
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
                      return '새 비밀번호를 입력해주세요';
                    }
                    if (_isPasswordChangeMode && value!.length < 6) {
                      return '비밀번호는 6자 이상이어야 합니다';
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
                    labelText: '새 비밀번호 확인',
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
                      return '새 비밀번호 확인을 입력해주세요';
                    }
                    if (_isPasswordChangeMode &&
                        value != _newPasswordController.text) {
                      return '비밀번호가 일치하지 않습니다';
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
                      : const Text('저장'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
