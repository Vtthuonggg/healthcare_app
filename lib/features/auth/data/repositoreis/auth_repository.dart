import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/services/token_storage_service.dart';
import '../../domain/models/user.dart';
import '../../domain/models/login_request.dart';
import '../../domain/models/login_response.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  final tokenStorage = ref.watch(tokenStorageServiceProvider);
  return AuthRepository(dioClient, tokenStorage);
});

class AuthRepository {
  final DioClient _dioClient;
  final TokenStorageService _tokenStorage;

  AuthRepository(this._dioClient, this._tokenStorage);

  Future<User> login(LoginRequest request) async {
    try {
      log('📤 [LOGIN] Calling login API...', name: 'AuthRepository');

      final response = await _dioClient.post(
        ApiConstants.loginEndpoint,
        data: request.toJson(),
      );

      final responseData = response.data as Map<String, dynamic>;
      log('✅ [LOGIN] Login success', name: 'AuthRepository');

      final loginResponse = LoginResponse.fromJson(responseData);

      // Lưu token vào local storage
      log('💾 [LOGIN] Saving tokens...', name: 'AuthRepository');
      await _tokenStorage.saveToken(loginResponse.token);
      await _tokenStorage.saveRefreshToken(loginResponse.refreshToken);

      log(
        '🔑 [LOGIN] Token saved: ${loginResponse.token.substring(0, 50)}...',
        name: 'AuthRepository',
      );
      log(
        '🔑 [LOGIN] Refresh token saved: ${loginResponse.refreshToken.substring(0, 50)}...',
        name: 'AuthRepository',
      );

      return loginResponse.user;
    } catch (e) {
      log('❌ [LOGIN] Error: $e', name: 'AuthRepository');
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      log('📤 [LOGOUT] Calling logout API...', name: 'AuthRepository');
      await _dioClient.post(ApiConstants.logoutEndpoint);
      await _tokenStorage.clearTokens();
      log('✅ [LOGOUT] Logout successful', name: 'AuthRepository');
    } catch (e) {
      log('❌ [LOGOUT] Error: $e', name: 'AuthRepository');
      await _tokenStorage.clearTokens();
    }
  }

  Future<String?> getToken() async {
    final token = await _tokenStorage.getToken();
    if (token != null) {
      log(
        '🔑 [GET_TOKEN] Token found: ${token.substring(0, 50)}...',
        name: 'AuthRepository',
      );
    } else {
      log('⚠️ [GET_TOKEN] No token found', name: 'AuthRepository');
    }
    return token;
  }

  Future<String?> getRefreshToken() async {
    final token = await _tokenStorage.getRefreshToken();
    if (token != null) {
      log(
        '🔑 [GET_REFRESH_TOKEN] Refresh token found: ${token.substring(0, 50)}...',
        name: 'AuthRepository',
      );
    } else {
      log(
        '⚠️ [GET_REFRESH_TOKEN] No refresh token found',
        name: 'AuthRepository',
      );
    }
    return token;
  }

  Future<bool> hasToken() async {
    final hasToken = await _tokenStorage.hasToken();
    log('🔍 [HAS_TOKEN] Result: $hasToken', name: 'AuthRepository');
    return hasToken;
  }

  Future<User> register({
    required String username,
    required String password,
    required String name,
  }) async {
    try {
      log('📤 [REGISTER] Calling register API...', name: 'AuthRepository');

      final response = await _dioClient.post(
        ApiConstants.registerEndpoint,
        data: {'username': username, 'password': password, 'name': name},
      );

      final responseData = response.data as Map<String, dynamic>;
      log('✅ [REGISTER] Register success', name: 'AuthRepository');

      final loginResponse = LoginResponse.fromJson(responseData);

      // Lưu token
      log('💾 [REGISTER] Saving tokens...', name: 'AuthRepository');
      await _tokenStorage.saveToken(loginResponse.token);
      await _tokenStorage.saveRefreshToken(loginResponse.refreshToken);

      return loginResponse.user;
    } catch (e) {
      log('❌ [REGISTER] Error: $e', name: 'AuthRepository');
      rethrow;
    }
  }

  Future<String> refreshToken() async {
    try {
      log(
        '🔄 [REFRESH_TOKEN] Starting refresh token process...',
        name: 'AuthRepository',
      );

      final refreshToken = await _tokenStorage.getRefreshToken();

      if (refreshToken == null) {
        log('❌ [REFRESH_TOKEN] No refresh token found', name: 'AuthRepository');
        throw Exception('No refresh token found');
      }

      log(
        '🔑 [REFRESH_TOKEN] Refresh token: ${refreshToken.substring(0, 50)}...',
        name: 'AuthRepository',
      );
      log(
        '📤 [REFRESH_TOKEN] Calling refresh token API...',
        name: 'AuthRepository',
      );

      final response = await _dioClient.post(
        ApiConstants.refreshTokenEndpoint,
        options: Options(headers: {'Authorization': 'Bearer $refreshToken'}),
      );

      final responseData = response.data as Map<String, dynamic>;
      final newToken = responseData['token'] as String;
      final newRefreshToken = responseData['refresh_token'] as String?;

      log(
        '✅ [REFRESH_TOKEN] Token refreshed successfully',
        name: 'AuthRepository',
      );
      log(
        '🔑 [REFRESH_TOKEN] New token: ${newToken.substring(0, 50)}...',
        name: 'AuthRepository',
      );

      // Lưu token mới
      log('💾 [REFRESH_TOKEN] Saving new tokens...', name: 'AuthRepository');
      await _tokenStorage.saveToken(newToken);
      if (newRefreshToken != null) {
        await _tokenStorage.saveRefreshToken(newRefreshToken);
        log(
          '🔑 [REFRESH_TOKEN] New refresh token: ${newRefreshToken.substring(0, 50)}...',
          name: 'AuthRepository',
        );
      }

      return newToken;
    } catch (e) {
      log('❌ [REFRESH_TOKEN] Error: $e', name: 'AuthRepository');
      // Clear tokens nếu refresh fail
      await _tokenStorage.clearTokens();
      rethrow;
    }
  }

  Future<User> getCurrentUser() async {
    try {
      log('📤 [GET_USER] Calling /auth/me API...', name: 'AuthRepository');
      log('🔍 [GET_USER] Checking current token...', name: 'AuthRepository');

      final currentToken = await _tokenStorage.getToken();
      if (currentToken != null) {
        log(
          '🔑 [GET_USER] Current token: ${currentToken.substring(0, 50)}...',
          name: 'AuthRepository',
        );
      }

      final response = await _dioClient.get(ApiConstants.meEndpoint);

      final responseData = response.data as Map<String, dynamic>;
      log('✅ [GET_USER] Get user success', name: 'AuthRepository');
      log('👤 [GET_USER] User data: $responseData', name: 'AuthRepository');

      return User.fromJson(responseData);
    } catch (e) {
      log('❌ [GET_USER] Error: $e', name: 'AuthRepository');
      rethrow;
    }
  }
}
