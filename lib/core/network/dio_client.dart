import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/env_config.dart';
import '../services/token_storage_service.dart';
import '../constants/api_constants.dart';
import 'dart:developer';

final dioClientProvider = Provider<DioClient>((ref) {
  final tokenStorage = ref.watch(tokenStorageServiceProvider);
  return DioClient(tokenStorage);
});

class DioClient {
  late final Dio _dio;
  final TokenStorageService _tokenStorage;
  bool _isRefreshing = false;

  DioClient(this._tokenStorage) {
    _dio = Dio(
      BaseOptions(
        baseUrl: EnvConfig.apiBaseUrl,
        connectTimeout: Duration(seconds: EnvConfig.connectTimeout),
        receiveTimeout: Duration(seconds: EnvConfig.receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Interceptor để tự động thêm token
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Tự động thêm token vào header (trừ các endpoint auth)
          if (!_isAuthEndpoint(options.path)) {
            final token = await _tokenStorage.getToken();
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
              log('🔑 [REQUEST] Added token to header for: ${options.path}');
              log(
                '🔑 [TOKEN] ${token.substring(0, 50)}...',
              ); // Show first 50 chars
            } else {
              log('⚠️ [REQUEST] No token found for: ${options.path}');
            }
          } else {
            log(
              'ℹ️ [REQUEST] Auth endpoint, skip adding token: ${options.path}',
            );
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          // Nếu gặp 401 và không phải endpoint refresh/login
          if (error.response?.statusCode == 401 &&
              !_isAuthEndpoint(error.requestOptions.path) &&
              !_isRefreshing) {
            log(
              '❌ [ERROR 401] Token expired for: ${error.requestOptions.path}',
            );
            log('🔄 [REFRESH] Starting token refresh process...');

            try {
              _isRefreshing = true;

              // Lấy refresh token
              final refreshToken = await _tokenStorage.getRefreshToken();

              if (refreshToken == null) {
                log('❌ [REFRESH] No refresh token available');
                await _tokenStorage.clearTokens();
                return handler.reject(error);
              }

              log(
                '🔑 [REFRESH] Refresh token found: ${refreshToken.substring(0, 50)}...',
              );

              // Gọi API refresh token
              log('📤 [REFRESH] Calling refresh token API...');
              final response = await _dio.post(
                ApiConstants.refreshTokenEndpoint,
                options: Options(
                  headers: {'Authorization': 'Bearer $refreshToken'},
                ),
              );

              log('✅ [REFRESH] Refresh token API success');
              log('📦 [REFRESH] Response data: ${response.data}');

              final responseData = response.data as Map<String, dynamic>;
              final newToken = responseData['token'] as String;
              final newRefreshToken = responseData['refresh_token'] as String?;

              log('🔑 [REFRESH] New token: ${newToken.substring(0, 50)}...');
              if (newRefreshToken != null) {
                log(
                  '🔑 [REFRESH] New refresh token: ${newRefreshToken.substring(0, 50)}...',
                );
              }

              // Lưu token mới
              await _tokenStorage.saveToken(newToken);
              if (newRefreshToken != null) {
                await _tokenStorage.saveRefreshToken(newRefreshToken);
              }

              log('✅ [REFRESH] Tokens saved successfully');

              // Retry request gốc với token mới
              log(
                '🔄 [RETRY] Retrying original request: ${error.requestOptions.path}',
              );
              error.requestOptions.headers['Authorization'] =
                  'Bearer $newToken';

              final opts = Options(
                method: error.requestOptions.method,
                headers: error.requestOptions.headers,
              );

              final cloneReq = await _dio.request(
                error.requestOptions.path,
                options: opts,
                data: error.requestOptions.data,
                queryParameters: error.requestOptions.queryParameters,
              );

              log('✅ [RETRY] Original request success');
              return handler.resolve(cloneReq);
            } catch (e) {
              log('❌ [REFRESH] Refresh token failed: $e');
              // Clear tokens nếu refresh fail
              await _tokenStorage.clearTokens();
              return handler.reject(error);
            } finally {
              _isRefreshing = false;
              log('🏁 [REFRESH] Process completed');
            }
          }

          return handler.next(error);
        },
        onResponse: (response, handler) {
          log(
            '✅ [RESPONSE] ${response.statusCode} - ${response.requestOptions.path}',
          );
          return handler.next(response);
        },
      ),
    );

    // Logging interceptor (optional, có thể tắt trong production)
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        requestHeader: true,
        responseHeader: false,
        logPrint: (obj) => log(obj.toString(), name: 'DIO'),
      ),
    );
  }

  // Kiểm tra xem có phải endpoint auth không
  bool _isAuthEndpoint(String path) {
    return path.contains('/auth/login') ||
        path.contains('/auth/register') ||
        path.contains('/auth/refresh');
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}
