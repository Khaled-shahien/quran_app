/// API Error Response Model
///
/// Represents structured error responses from the API
class ApiError {
  final int? code;
  final String? message;
  final String? details;
  final List<String>? errors;

  ApiError({this.code, this.message, this.details, this.errors});

  /// Creates an ApiError from JSON
  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      code: json['code'] as int?,
      message: json['message'] as String? ?? json['error'] as String?,
      details: json['details'] as String?,
      errors: (json['errors'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }

  /// Converts ApiError to JSON
  Map<String, dynamic> toJson() {
    return {
      if (code != null) 'code': code,
      if (message != null) 'message': message,
      if (details != null) 'details': details,
      if (errors != null) 'errors': errors,
    };
  }

  @override
  String toString() {
    return 'ApiError(code: $code, message: $message, details: $details, errors: $errors)';
  }
}
