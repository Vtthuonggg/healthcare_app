import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class Logger {
  static const String _defaultTag = 'HotelBooking';

  static void debug(String message, {String? tag}) {
    if (kDebugMode) {
      developer.log(message, name: tag ?? _defaultTag, level: 500);
    }
  }

  static void info(String message, {String? tag}) {
    developer.log(message, name: tag ?? _defaultTag, level: 800);
  }

  static void warning(String message, {String? tag}) {
    developer.log(message, name: tag ?? _defaultTag, level: 900);
  }

  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      message,
      name: tag ?? _defaultTag,
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void api(String endpoint, {String method = 'GET', dynamic data}) {
    if (kDebugMode) {
      debug(
        '[$method] $endpoint ${data != null ? '\nData: $data' : ''}',
        tag: 'API',
      );
    }
  }
}
