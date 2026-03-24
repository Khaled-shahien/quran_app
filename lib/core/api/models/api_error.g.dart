// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiError _$ApiErrorFromJson(Map<String, dynamic> json) => ApiError(
  code: (json['code'] as num?)?.toInt(),
  message: json['message'] as String?,
  details: json['details'] as String?,
  errors: ApiError._errorsFromJson(json['errors']),
);

Map<String, dynamic> _$ApiErrorToJson(ApiError instance) => <String, dynamic>{
  'code': ?instance.code,
  'message': ?instance.message,
  'details': ?instance.details,
  'errors': ?instance.errors,
};
