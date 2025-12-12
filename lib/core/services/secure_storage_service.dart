import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// 보안 스토리지 서비스
/// flutter_secure_storage를 사용하여 민감한 데이터를 안전하게 저장
class SecureStorageService {
  // Singleton 패턴
  static final SecureStorageService _instance =
      SecureStorageService._internal();
  factory SecureStorageService() => _instance;
  SecureStorageService._internal();

  // Flutter Secure Storage 인스턴스
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  // 키 상수
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';
  static const String _userPhoneNumberKey = 'user_phone_number';
  static const String _userProfileImageUrlKey = 'user_profile_image_url';
  static const String _userIsAdminKey = 'user_is_admin';
  static const String _userHasPasswordKey = 'user_has_password';

  /// Access Token 저장
  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  /// Access Token 가져오기
  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  /// Refresh Token 저장
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  /// Refresh Token 가져오기
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  /// 저장된 토큰이 있는지 확인
  Future<bool> hasTokens() async {
    final accessToken = await getAccessToken();
    return accessToken != null && accessToken.isNotEmpty;
  }

  /// 모든 토큰 삭제
  Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }

  /// 사용자 정보 저장
  Future<void> saveUserInfo({
    String? email,
    String? name,
    String? phoneNumber,
    String? profileImageUrl,
    bool? isAdmin,
    bool? hasPassword,
  }) async {
    debugPrint('=== Saving user info ===');
    debugPrint('Email: $email');
    debugPrint('Name: $name');
    debugPrint('PhoneNumber: $phoneNumber');
    debugPrint('ProfileImageUrl: $profileImageUrl');
    debugPrint('IsAdmin: $isAdmin');
    debugPrint('HasPassword: $hasPassword');

    if (email != null) {
      await _storage.write(key: _userEmailKey, value: email);
      debugPrint('Email saved');
    }
    if (name != null) {
      await _storage.write(key: _userNameKey, value: name);
      debugPrint('Name saved');
    }
    if (phoneNumber != null) {
      await _storage.write(key: _userPhoneNumberKey, value: phoneNumber);
      debugPrint('PhoneNumber saved');
    }
    if (profileImageUrl != null) {
      await _storage.write(key: _userProfileImageUrlKey, value: profileImageUrl);
      debugPrint('ProfileImageUrl saved');
    }
    if (isAdmin != null) {
      await _storage.write(key: _userIsAdminKey, value: isAdmin.toString());
      debugPrint('IsAdmin saved');
    }
    if (hasPassword != null) {
      await _storage.write(key: _userHasPasswordKey, value: hasPassword.toString());
      debugPrint('HasPassword saved');
    }
    debugPrint('=== User info save complete ===');
  }

  /// 사용자 이메일 가져오기
  Future<String?> getUserEmail() async {
    return await _storage.read(key: _userEmailKey);
  }

  /// 사용자 이름 가져오기
  Future<String?> getUserName() async {
    return await _storage.read(key: _userNameKey);
  }

  /// 사용자 전화번호 가져오기
  Future<String?> getUserPhoneNumber() async {
    return await _storage.read(key: _userPhoneNumberKey);
  }

  /// 사용자 프로필 이미지 URL 가져오기
  Future<String?> getUserProfileImageUrl() async {
    return await _storage.read(key: _userProfileImageUrlKey);
  }

  /// 사용자 관리자 여부 가져오기
  Future<bool> getUserIsAdmin() async {
    final value = await _storage.read(key: _userIsAdminKey);
    return value == 'true';
  }

  /// 사용자 비밀번호 보유 여부 가져오기
  Future<bool> getUserHasPassword() async {
    final value = await _storage.read(key: _userHasPasswordKey);
    return value == 'true';
  }

  /// 모든 사용자 정보 가져오기
  Future<Map<String, dynamic>> getUserInfo() async {
    final email = await getUserEmail();
    final name = await getUserName();
    final phoneNumber = await getUserPhoneNumber();
    final profileImageUrl = await getUserProfileImageUrl();
    final isAdmin = await getUserIsAdmin();
    final hasPassword = await getUserHasPassword();

    debugPrint('=== Reading user info ===');
    debugPrint('Email: $email');
    debugPrint('Name: $name');
    debugPrint('PhoneNumber: $phoneNumber');
    debugPrint('ProfileImageUrl: $profileImageUrl');
    debugPrint('IsAdmin: $isAdmin');
    debugPrint('HasPassword: $hasPassword');

    return {
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'isAdmin': isAdmin,
      'hasPassword': hasPassword,
    };
  }

  /// 사용자 정보 삭제
  Future<void> clearUserInfo() async {
    await _storage.delete(key: _userEmailKey);
    await _storage.delete(key: _userNameKey);
    await _storage.delete(key: _userPhoneNumberKey);
    await _storage.delete(key: _userProfileImageUrlKey);
    await _storage.delete(key: _userIsAdminKey);
    await _storage.delete(key: _userHasPasswordKey);
  }

  /// 모든 데이터 삭제
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  /// 특정 키의 값 저장
  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// 특정 키의 값 가져오기
  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  /// 특정 키의 값 삭제
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }
}
