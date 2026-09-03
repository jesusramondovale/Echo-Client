import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

class SecureStore {
  SecureStore({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const _deviceKey = 'echo_device_key';
  static const _tokenKey = 'echo_access_token';
  static const _avatarUrlKey = 'echo_avatar_url';

  final FlutterSecureStorage _storage;
  final _uuid = const Uuid();

  Future<String> getOrCreateDeviceKey() async {
    final existing = await _storage.read(key: _deviceKey);
    if (existing != null && existing.isNotEmpty) return existing;
    final key = _uuid.v4();
    await _storage.write(key: _deviceKey, value: key);
    return key;
  }

  Future<void> saveToken(String token) =>
      _storage.write(key: _tokenKey, value: token);

  Future<String?> readToken() => _storage.read(key: _tokenKey);

  Future<void> saveAvatarUrl(String? url) async {
    if (url == null) {
      await _storage.delete(key: _avatarUrlKey);
    } else {
      await _storage.write(key: _avatarUrlKey, value: url);
    }
  }

  Future<String?> readAvatarUrl() => _storage.read(key: _avatarUrlKey);

  Future<void> resetIdentity() async {
    await _storage.deleteAll();
  }
}
