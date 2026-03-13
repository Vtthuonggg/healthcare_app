import '../config/env_config.dart';

class ApiConstants {
  ApiConstants._();

  // Base URLs (from .env)
  static String get baseUrl => EnvConfig.apiBaseUrl;

  // API Endpoints
  // Auth
  static const String loginEndpoint = '/auth/login';
  static const String logoutEndpoint = '/auth/logout';
  static const String registerEndpoint = '/auth/register';
  static const String refreshTokenEndpoint = '/auth/refresh';
  static const String meEndpoint = '/auth/me';
  static const String forgotPasswordEndpoint = '/auth/forgot-password';
  static const String resetPasswordEndpoint = '/auth/reset-password';

  // Home
  static const String realEstatePropertiesEndpoint = '/real-estate-properties';

  // Full URLs (combine base + endpoint)
  static String get loginUrl => '$baseUrl$loginEndpoint';
  static String get logoutUrl => '$baseUrl$logoutEndpoint';

  // Timeouts
  static Duration get connectTimeout =>
      Duration(seconds: EnvConfig.connectTimeout);
  static Duration get receiveTimeout =>
      Duration(seconds: EnvConfig.receiveTimeout);

  // Headers
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'X-API-Key': EnvConfig.apiKey,
  };

  static Map<String, String> authHeaders(String token) => {
    ...defaultHeaders,
    'Authorization': 'Bearer $token',
  };
}
