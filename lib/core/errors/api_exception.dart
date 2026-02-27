import 'dart:convert';

/// Base API Exception
///
/// Base class for all API-related exceptions
class ApiException implements Exception {
  final String message;
  final int code;
  final dynamic data;

  ApiException({required this.message, required this.code, this.data});

  /// Creates an ApiException from HTTP response
  factory ApiException.fromResponse({
    required int statusCode,
    required String body,
  }) {
    try {
      final json = body.isNotEmpty ? jsonDecode(body) : {};
      final message =
          json['message'] as String? ??
          json['error'] as String? ??
          _getDefaultMessage(statusCode);

      return ApiException(message: message, code: statusCode, data: json);
    } catch (e) {
      return ApiException(
        message: _getDefaultMessage(statusCode),
        code: statusCode,
      );
    }
  }

  /// Gets default error message based on status code
  static String _getDefaultMessage(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad Request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Not Found';
      case 405:
        return 'Method Not Allowed';
      case 429:
        return 'Too Many Requests';
      case 500:
        return 'Internal Server Error';
      case 502:
        return 'Bad Gateway';
      case 503:
        return 'Service Unavailable';
      case 504:
        return 'Gateway Timeout';
      default:
        return 'An error occurred';
    }
  }

  @override
  String toString() => 'ApiException: $message (Code: $code)';
}
