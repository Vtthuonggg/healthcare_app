import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../data/repositoreis/auth_repository.dart';
import '../../domain/models/login_request.dart';
import 'auth_state.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthNotifier(this._authRepository) : super(const AuthState.checking()) {
    checkAuthStatus();
  }
  // Kiểm tra trạng thái đăng nhập
  Future<void> checkAuthStatus() async {
    try {
      state = const AuthState.checking();

      // Kiểm tra xem có token không
      final hasToken = await _authRepository.hasToken();

      if (!hasToken) {
        log('No token found');
        state = const AuthState.unauthenticated();
        return;
      }

      // Có token, gọi API /auth/me
      log('Token found, fetching user info...');
      final user = await _authRepository.getCurrentUser();

      state = AuthState.authenticated(user);
    } catch (e) {
      log('Check auth failed: $e');
      // Nếu có lỗi (kể cả refresh token fail), chuyển về unauthenticated
      await _authRepository.logout(); // Clear tokens
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> login(String username, String password) async {
    state = const AuthState.loading();
    try {
      final request = LoginRequest(username: username, password: password);
      final user = await _authRepository.login(request);
      state = AuthState.authenticated(user);
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        state = const AuthState.error('Tài khoản hoặc mật khẩu không đúng');
      } else if (e.response?.statusCode == 401) {
        state = const AuthState.error('Tài khoản hoặc mật khẩu không đúng');
      } else {
        state = AuthState.error(
          e.response?.data['message'] ?? 'Đã có lỗi xảy ra. Vui lòng thử lại',
        );
      }
    } catch (e) {
      state = const AuthState.error('Đã có lỗi xảy ra. Vui lòng thử lại');
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    state = const AuthState.unauthenticated();
  }
}
