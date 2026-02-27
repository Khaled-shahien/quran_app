import 'dart:convert';
import 'package:logger/logger.dart';
import '../api/models/api_error.dart';
import '../errors/api_exception.dart';
import '../errors/network_exception.dart';

/// API Error Handler
///
/// Centralized error handling for API responses
class ApiErrorHandler {
  final Logger _logger;

  ApiErrorHandler({Logger? logger}) : _logger = logger ?? Logger();

  /// Handles API exceptions and returns appropriate error messages
  String handleError(Object error) {
    _logger.e('API Error occurred: $error');

    if (error is NetworkException) {
      return _handleNetworkError(error);
    } else if (error is ApiException) {
      return _handleApiError(error);
    } else {
      return 'An unexpected error occurred';
    }
  }

  /// Handles network errors
  String _handleNetworkError(NetworkException error) {
    switch (error.type) {
      case NetworkErrorType.noInternet:
        return 'Please check your internet connection';
      case NetworkErrorType.timeout:
        return 'Request timed out. Please try again';
      case NetworkErrorType.sslError:
        return 'Security certificate error. Please try again';
      case NetworkErrorType.serverUnreachable:
        return 'Server is currently unavailable. Please try again later';
      case NetworkErrorType.unknown:
        return 'Network error occurred. Please try again';
    }
  }

  /// Handles API errors
  String _handleApiError(ApiException error) {
    switch (error.code) {
      case 400:
        return 'Invalid request. Please check your input';
      case 401:
        return 'Authentication required. Please log in';
      case 403:
        return 'Access denied. You don\'t have permission';
      case 404:
        return 'Resource not found';
      case 405:
        return 'Method not allowed';
      case 429:
        return 'Too many requests. Please try again later';
      case 500:
        return 'Server error. Please try again later';
      case 502:
        return 'Bad gateway. Please try again';
      case 503:
        return 'Service unavailable. Please try again later';
      case 504:
        return 'Gateway timeout. Please try again';
      default:
        return error.message;
    }
  }

  /// Parses API error from response body
  ApiError? parseError(String responseBody) {
    try {
      final json = responseBody.isNotEmpty ? jsonDecode(responseBody) : {};
      return ApiError.fromJson(json);
    } catch (e) {
      _logger.w('Failed to parse error response: $e');
      return null;
    }
  }
}
