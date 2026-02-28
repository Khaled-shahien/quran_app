/// Network Exception for connectivity issues
class NetworkException implements Exception {
  final String message;
  final int? statusCode;
  final Object? originalError;

  NetworkException(this.message, {this.statusCode, this.originalError});

  @override
  String toString() =>
      'NetworkException: $message${statusCode != null ? ' ($statusCode)' : ''}';
}

/// API Exception for HTTP/REST API errors
class ApiException implements Exception {
  final String message;
  final int code;
  final Object? originalError;
  final Map<String, dynamic>? response;

  ApiException({
    required this.message,
    this.code = 0,
    this.originalError,
    this.response,
  });

  @override
  String toString() => 'ApiException: $message (Code: $code)';
}

/// Security Exception for validation and security issues
class SecurityException implements Exception {
  final String message;
  final String? code;
  final Object? originalError;

  SecurityException(this.message, {this.code, this.originalError});

  @override
  String toString() =>
      'SecurityException: $message${code != null ? ' ($code)' : ''}';
}

/// Validation Exception for input validation errors
class ValidationException implements Exception {
  final String message;
  final String field;
  final Object? value;

  ValidationException(this.message, this.field, [this.value]);

  @override
  String toString() => 'ValidationException: $field - $message';
}

/// Data Integrity Exception for data consistency issues
class DataIntegrityException implements Exception {
  final String message;
  final Object? data;

  DataIntegrityException(this.message, [this.data]);

  @override
  String toString() => 'DataIntegrityException: $message';
}
