import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

/// 민감 정보를 안전하게 저장하기 위한 보안 스토리지 래퍼 클래스
///
/// 암호, API 키, 인증 토큰 등의 민감 정보를 저장할 때 사용합니다.
@singleton
class SecureStorage {
  final FlutterSecureStorage _storage;

  SecureStorage()
      : _storage = const FlutterSecureStorage(
          aOptions: AndroidOptions(
            encryptedSharedPreferences: true,
          ),
          iOptions: IOSOptions(
            accessibility: KeychainAccessibility.first_unlock,
          ),
        );

  /// 민감 정보를 안전하게 저장합니다.
  Future<void> saveSecureData(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// 저장된 민감 정보를 조회합니다.
  Future<String?> getSecureData(String key) async {
    return await _storage.read(key: key);
  }

  /// 저장된 민감 정보를 삭제합니다.
  Future<void> deleteSecureData(String key) async {
    await _storage.delete(key: key);
  }

  /// 모든 민감 정보를 삭제합니다.
  Future<void> deleteAllSecureData() async {
    await _storage.deleteAll();
  }
}
