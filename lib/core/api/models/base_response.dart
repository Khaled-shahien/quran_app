import 'package:json_annotation/json_annotation.dart';

part 'base_response.g.dart';

/// Base API Response Model
///
/// Generic response wrapper that can be used for all API responses.
/// Contains common fields like status, message, and data.
@JsonSerializable(genericArgumentFactories: true, includeIfNull: false)
class BaseResponse<T> {
  final bool status;
  final String? message;
  final T? data;
  final int? code;

  BaseResponse({required this.status, this.message, this.data, this.code});

  /// Creates a BaseResponse from JSON
  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic> json) fromJsonT,
  ) => _$BaseResponseFromJson(
    json,
    (Object? value) => fromJsonT(value as Map<String, dynamic>),
  );

  /// Converts BaseResponse to JSON
  Map<String, dynamic> toJson(Map<String, dynamic> Function(T value) toJsonT) =>
      _$BaseResponseToJson(this, (T value) => toJsonT(value));

  /// Creates a success response
  factory BaseResponse.success({T? data, String? message, int? code}) {
    return BaseResponse<T>(
      status: true,
      data: data,
      message: message ?? 'Success',
      code: code ?? 200,
    );
  }

  /// Creates an error response
  factory BaseResponse.error({String? message, int? code}) {
    return BaseResponse<T>(
      status: false,
      message: message ?? 'An error occurred',
      code: code ?? 500,
    );
  }

  @override
  String toString() {
    return 'BaseResponse(status: $status, message: $message, code: $code, data: $data)';
  }
}
