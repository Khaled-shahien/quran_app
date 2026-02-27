/// Network Exception
///
/// Exception for network-related errors
class NetworkException implements Exception {
  final String message;
  final NetworkErrorType type;

  NetworkException._(this.message, this.type);

  /// Create a custom network exception
  NetworkException.custom(this.message, this.type);

  /// No internet connection
  const NetworkException.noInternet()
    : message = 'No internet connection',
      type = NetworkErrorType.noInternet;

  /// Timeout error
  const NetworkException.timeout()
    : message = 'Request timeout',
      type = NetworkErrorType.timeout;

  /// SSL/TLS error
  const NetworkException.sslError()
    : message = 'SSL certificate error',
      type = NetworkErrorType.sslError;

  /// Server unreachable
  const NetworkException.serverUnreachable()
    : message = 'Server is unreachable',
      type = NetworkErrorType.serverUnreachable;

  /// Unknown network error
  const NetworkException.unknown()
    : message = 'Unknown network error',
      type = NetworkErrorType.unknown;

  @override
  String toString() => 'NetworkException: $message (Type: $type)';
}

/// Types of network errors
enum NetworkErrorType {
  noInternet,
  timeout,
  sslError,
  serverUnreachable,
  unknown,
}
