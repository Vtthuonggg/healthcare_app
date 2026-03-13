import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tokenStorageServiceProvider = Provider<TokenStorageService>((ref) {
  return TokenStorageService();
});

class TokenStorageService {
  final _storage = const FlutterSecureStorage();

  static const String _tokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  // Save token
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // Save refresh token
  Future<void> saveRefreshToken(String refreshToken) async {
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  // Get token
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // Get refresh token
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  // Check if token exists
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Clear all tokens
  Future<void> clearTokens() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }

  // Clear all storage
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
