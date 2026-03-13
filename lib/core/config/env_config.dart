import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  // Prevent instantiation
  EnvConfig._();

  // Initialize dotenv
  static Future<void> init() async {
    await dotenv.load(fileName: ".env");
  }

  // API URLs
  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? '';
  static String get avatarBaseUrl =>
      dotenv.env['AVATAR_BASE_URL'] ?? 'https://i.pravatar.cc';

  // API Keys
  static String get apiKey => dotenv.env['API_KEY'] ?? '';

  // Timeouts
  static int get connectTimeout =>
      int.tryParse(dotenv.env['CONNECT_TIMEOUT'] ?? '30') ?? 30;
  static int get receiveTimeout =>
      int.tryParse(dotenv.env['RECEIVE_TIMEOUT'] ?? '30') ?? 30;
}
