import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// 보안 스토리지 서비스
/// flutter_secure_storage를 사용하여 민감한 데이터를 안전하게 저장
class SecureStorageService {
  // Singleton 패턴
  static final SecureStorageService _instance = SecureStorageService._internal();
  factory SecureStorageService() => _instance;
  SecureStorageService._internal();

  // Flutter Secure Storage 인스턴스
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  // 키 상수
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

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
