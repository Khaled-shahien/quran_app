import 'dart:convert';
import 'dart:developer' as developer;

import 'package:logger/logger.dart';

/// Configuration for security settingsd Error Handling Utilities
///
/// Provides comprehensive security features including:
/// - Input validation and sanitization
/// - Secure logging
/// - Exception handling with context
/// - Data validation
/// - Security audit trails

class SecurityUtils {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 50,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  /// Validate and sanitize user input
  static String sanitizeInput(String input, {int maxLength = 1000}) {
    // Remove potentially dangerous characters
    String sanitized = input
        .replaceAll(RegExp(r'<[^>]*>'), '') // Remove HTML tags
        .replaceAll(RegExp(r'&[^;]*;'), '') // Remove HTML entities
        .replaceAll(RegExp(r'javascript:'), '') // Remove javascript
        .replaceAll(RegExp(r'vbscript:'), '') // Remove vbscript
        .replaceAll(RegExp(r'data:'), '') // Remove data URLs
        .replaceAll(
          RegExp(r'[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]'),
          '',
        ) // Remove control characters
        .trim();

    // Limit length
    if (sanitized.length > maxLength) {
      sanitized = sanitized.substring(0, maxLength);
    }

    // Log suspicious input
    if (input != sanitized) {
      _logSecurityEvent(
        'InputSanitization',
        'Potentially unsafe input detected and sanitized',
        data: {'original': input, 'sanitized': sanitized},
        level: Level.warning,
      );
    }

    return sanitized;
  }

  /// Validate coordinates for prayer times
  static bool isValidCoordinates(double latitude, double longitude) {
    return latitude >= -90 &&
        latitude <= 90 &&
        longitude >= -180 &&
        longitude <= 180;
  }

  /// Validate date range
  static bool isValidDateRange(DateTime date, {int maxDaysFuture = 365}) {
    final now = DateTime.now();
    final maxFuture = now.add(Duration(days: maxDaysFuture));
    return date.isAfter(now.subtract(const Duration(days: 365))) &&
        date.isBefore(maxFuture);
  }

  /// Validate Surah number (1-114)
  static bool isValidSurahNumber(int surahNumber) {
    return surahNumber >= 1 && surahNumber <= 114;
  }

  /// Validate Ayah number within Surah bounds
  static bool isValidAyahNumber(int ayahNumber, int surahNumber) {
    // Approximate Ayah counts for each Surah
    final ayahCounts = {
      1: 7,
      2: 286,
      3: 200,
      4: 176,
      5: 120,
      6: 165,
      7: 206,
      8: 75,
      9: 129,
      10: 109,
      11: 123,
      12: 111,
      13: 43,
      14: 52,
      15: 99,
      16: 128,
      17: 111,
      18: 110,
      19: 98,
      20: 135,
      21: 112,
      22: 78,
      23: 118,
      24: 64,
      25: 77,
      26: 227,
      27: 93,
      28: 88,
      29: 69,
      30: 60,
      31: 34,
      32: 30,
      33: 73,
      34: 54,
      35: 45,
      36: 83,
      37: 182,
      38: 88,
      39: 75,
      40: 85,
      41: 54,
      42: 53,
      43: 89,
      44: 59,
      45: 37,
      46: 35,
      47: 38,
      48: 29,
      49: 18,
      50: 45,
      51: 60,
      52: 49,
      53: 62,
      54: 55,
      55: 78,
      56: 96,
      57: 29,
      58: 22,
      59: 24,
      60: 13,
      61: 14,
      62: 11,
      63: 11,
      64: 18,
      65: 12,
      66: 12,
      67: 30,
      68: 52,
      69: 52,
      70: 44,
      71: 28,
      72: 28,
      73: 20,
      74: 56,
      75: 40,
      76: 31,
      77: 50,
      78: 40,
      79: 46,
      80: 42,
      81: 29,
      82: 19,
      83: 36,
      84: 25,
      85: 22,
      86: 17,
      87: 19,
      88: 26,
      89: 30,
      90: 20,
      91: 15,
      92: 21,
      93: 11,
      94: 8,
      95: 8,
      96: 19,
      97: 5,
      98: 8,
      99: 8,
      100: 11,
      101: 11,
      102: 8,
      103: 3,
      104: 9,
      105: 5,
      106: 4,
      107: 7,
      108: 3,
      109: 6,
      110: 3,
      111: 5,
      112: 4,
      113: 5,
      114: 6,
    };

    final maxAyahs = ayahCounts[surahNumber] ?? 200;
    return ayahNumber >= 1 && ayahNumber <= maxAyahs;
  }

  /// Secure logging with sensitive data filtering
  static void logSecure(
    String message, {
    Object? data,
    Level level = Level.info,
    bool maskSensitive = true,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!SecurityConfig.enableSecureLogging) return;

    // Filter sensitive data
    Object? filteredData = data;
    if (maskSensitive && data != null) {
      filteredData = _maskSensitiveData(data);
    }

    try {
      switch (level) {
        case Level.trace:
          _logger.t(
            message,
            error: error ?? filteredData,
            stackTrace: stackTrace,
          );
          break;
        case Level.debug:
          _logger.d(
            message,
            error: error ?? filteredData,
            stackTrace: stackTrace,
          );
          break;
        case Level.info:
          _logger.i(
            message,
            error: error ?? filteredData,
            stackTrace: stackTrace,
          );
          break;
        case Level.warning:
          _logger.w(
            message,
            error: error ?? filteredData,
            stackTrace: stackTrace,
          );
          break;
        case Level.error:
          _logger.e(
            message,
            error: error ?? filteredData,
            stackTrace: stackTrace,
          );
          break;
        case Level.fatal:
          _logger.f(
            message,
            error: error ?? filteredData,
            stackTrace: stackTrace,
          );
          break;
        default:
          _logger.i(
            message,
            error: error ?? filteredData,
            stackTrace: stackTrace,
          );
          break;
      }
    } catch (e) {
      // Fallback for logging errors within the logger itself
      developer.log(
        'Error writing to secure log',
        name: 'security_utils',
        level: 1000,
        error: e,
      );
    }
  }

  /// Log security events
  static void _logSecurityEvent(
    String eventType,
    String description, {
    Map<String, dynamic>? data,
    Level level = Level.warning, // Security events are often warnings or errors
    bool maskSensitive = true,
  }) {
    if (!SecurityConfig.enableSecureLogging) return;

    final eventDetails = {
      'timestamp': DateTime.now().toIso8601String(),
      'eventType': eventType,
      'description': description,
      if (data != null) 'data': data,
      'sessionId': _generateSessionId(),
    };

    logSecure(
      'Security Event: $eventType',
      data: eventDetails,
      level: level,
      maskSensitive: maskSensitive,
    );
  }

  /// Generate secure session ID
  static String _generateSessionId() {
    return DateTime.now().microsecondsSinceEpoch.toString();
  }

  /// Mask sensitive data in logs
  static Object _maskSensitiveData(Object data) {
    if (data is Map<String, dynamic>) {
      final masked = Map<String, dynamic>.from(data);
      for (final key in masked.keys) {
        if (_isSensitiveKey(key)) {
          masked[key] = '***MASKED***';
        } else if (masked[key] is Map || masked[key] is List) {
          masked[key] = _maskSensitiveData(masked[key]!);
        }
      }
      return masked;
    } else if (data is List) {
      return data.map((item) => _maskSensitiveData(item)).toList();
    }
    return data;
  }

  /// Check if a key contains sensitive information
  static bool _isSensitiveKey(String key) {
    final lowerKey = key.toLowerCase();
    final sensitivePatterns = [
      'password',
      'token',
      'secret',
      'key',
      'auth',
      'credential',
      'pin',
      'cvv',
    ];
    return sensitivePatterns.any((pattern) => lowerKey.contains(pattern));
  }

  /// Validate network response safety
  static bool isSafeHttpResponse(int statusCode, Map<String, String> headers) {
    // Check for potentially dangerous status codes
    if (statusCode >= 500) {
      _logSecurityEvent(
        'DangerousHttpResponse',
        'Server error response received',
        data: {'statusCode': statusCode, 'headers': headers},
      );
      return false;
    }

    // Check for potentially dangerous content types
    final contentType = headers['content-type']?.toLowerCase();
    if (contentType != null &&
        (contentType.contains('javascript') ||
            contentType.contains('vbscript'))) {
      _logSecurityEvent(
        'DangerousContentType',
        'Potentially dangerous content type detected',
        data: {'contentType': contentType},
      );
      return false;
    }

    return true;
  }

  /// Safe JSON parsing with error handling
  static Map<String, dynamic>? safeJsonParse(String jsonString) {
    if (jsonString.trim().isEmpty) return null;

    try {
      final parsed = jsonDecode(jsonString);
      if (parsed is Map<String, dynamic>) {
        return parsed;
      }
      return {'data': parsed};
    } catch (e) {
      logSecure(
        'Failed to parse JSON string',
        level: Level.error,
        data: {'error': e.toString()},
      );
      return null;
    }
  }

  /// Validate API response structure
  static bool isValidApiResponse(Map<String, dynamic> response) {
    // Check required fields
    if (!response.containsKey('code') || !response.containsKey('status')) {
      _logSecurityEvent(
        'InvalidApiResponse',
        'Missing required response fields',
        data: {'response_keys': response.keys.toList()},
      );
      return false;
    }

    // Validate status codes
    final code = response['code'];
    if (code is! int || code < 100 || code > 599) {
      _logSecurityEvent(
        'InvalidApiResponse',
        'Invalid response code',
        data: {'code': code},
      );
      return false;
    }

    return true;
  }
}

/// Enhanced Exception Types moved to app_exceptions.dart
// SecurityException, ValidationException, and DataIntegrityException
// are now defined in lib/core/errors/app_exceptions.dart

/// Security Configuration
class SecurityConfig {
  static const bool enableInputValidation = true;
  static const bool enableSecureLogging = true;
  static const int maxInputLength = 1000;
  static const int maxApiRetries = 3;
  static const Duration apiTimeout = Duration(seconds: 30);
  static const bool enableRateLimiting = true;
  static const int maxRequestsPerMinute = 60;
}
