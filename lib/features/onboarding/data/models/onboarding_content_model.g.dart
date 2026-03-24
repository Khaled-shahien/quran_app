// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_content_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OnboardingContentModel _$OnboardingContentModelFromJson(
  Map<String, dynamic> json,
) => OnboardingContentModel(
  title: json['title'] as String? ?? '',
  description: json['description'] as String? ?? '',
  imagePath: json['imagePath'] as String? ?? '',
  assetPath: json['assetPath'] as String? ?? '',
);

Map<String, dynamic> _$OnboardingContentModelToJson(
  OnboardingContentModel instance,
) => <String, dynamic>{
  'title': instance.title,
  'description': instance.description,
  'imagePath': instance.imagePath,
  'assetPath': instance.assetPath,
};
