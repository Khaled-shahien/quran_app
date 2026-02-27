import 'package:logger/logger.dart';

/// API Logger
///
/// Centralized logging for API operations
class ApiLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
    ),
  );

  /// Log API request
  static void logRequest({
    required String method,
    required String url,
    Map<String, String>? headers,
    Object? body,
    Map<String, dynamic>? queryParams,
  }) {
    _logger.i('=== API REQUEST ===');
    _logger.i('Method: $method');
    _logger.i('URL: $url');

    if (queryParams != null && queryParams.isNotEmpty) {
      _logger.d('Query Parameters: $queryParams');
    }

    if (headers != null && headers.isNotEmpty) {
      _logger.d('Headers: $headers');
    }

    if (body != null) {
      _logger.d('Body: $body');
    }

    _logger.i('===================');
  }

  /// Log API response
  static void logResponse({
    required int statusCode,
    required String url,
    Object? body,
  }) {
    _logger.i('=== API RESPONSE ===');
    _logger.i('URL: $url');
    _logger.i('Status Code: $statusCode');

    if (body != null) {
      _logger.d('Response Body: $body');
    }

    _logger.i('====================');
  }

  /// Log API error
  static void logError({
    required Object error,
    required String url,
    StackTrace? stackTrace,
  }) {
    _logger.e('=== API ERROR ===');
    _logger.e('URL: $url');
    _logger.e('Error: $error');

    if (stackTrace != null) {
      _logger.e('Stack Trace: $stackTrace');
    }

    _logger.e('=================');
  }

  /// Log network connectivity issues
  static void logNetworkIssue(String issue) {
    _logger.w('Network Issue: $issue');
  }

  /// Log API success
  static void logSuccess(String message) {
    _logger.i('API Success: $message');
  }

  /// Log debug information
  static void logDebug(String message) {
    _logger.d('API Debug: $message');
  }

  /// Log warning
  static void logWarning(String message) {
    _logger.w('API Warning: $message');
  }
}
