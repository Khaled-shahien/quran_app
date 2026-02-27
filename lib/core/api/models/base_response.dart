/// Base API Response Model
///
/// Generic response wrapper that can be used for all API responses.
/// Contains common fields like status, message, and data.
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
  ) {
    return BaseResponse<T>(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String?,
      data: json['data'] != null
          ? fromJsonT(json['data'] as Map<String, dynamic>)
          : null,
      code: json['code'] as int?,
    );
  }

  /// Converts BaseResponse to JSON
  Map<String, dynamic> toJson(Map<String, dynamic> Function(T value) toJsonT) {
    return {
      'status': status,
      if (message != null) 'message': message,
      if (data != null) 'data': toJsonT(data as T),
      if (code != null) 'code': code,
    };
  }

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
