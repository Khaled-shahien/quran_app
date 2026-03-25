import 'package:json_annotation/json_annotation.dart';

part 'api_error.g.dart';

/// API Error Response Model
///
/// Represents structured error responses from the API
@JsonSerializable(includeIfNull: false)
class ApiError {
  final int? code;
  final String? message;
  final String? details;

  @JsonKey(fromJson: _errorsFromJson)
  final List<String>? errors;

  ApiError({this.code, this.message, this.details, this.errors});

  /// Creates an ApiError from JSON
  factory ApiError.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorFromJson(_normalizeJson(json));

  /// Converts ApiError to JSON
  Map<String, dynamic> toJson() => _$ApiErrorToJson(this);

  static Map<String, dynamic> _normalizeJson(Map<String, dynamic> json) {
    final Map<String, dynamic> normalized = Map<String, dynamic>.from(json);
    if (normalized['message'] == null && normalized['error'] != null) {
      normalized['message'] = normalized['error'];
    }
    return normalized;
  }

  static List<String>? _errorsFromJson(Object? raw) {
    if (raw is! List) {
      return null;
    }
    return raw.map((e) => e.toString()).toList();
  }

  @override
  String toString() {
    return 'ApiError('
        'code: $code, '
        'message: $message, '
        'details: $details, '
        'errors: $errors)';
  }
}
