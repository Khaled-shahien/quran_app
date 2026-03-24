import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/onboarding_content_entity.dart';

part 'onboarding_content_model.g.dart';

@JsonSerializable()
class OnboardingContentModel implements OnboardingContentEntity {
  @override
  @JsonKey(defaultValue: '')
  final String title;

  @override
  @JsonKey(defaultValue: '')
  final String description;

  @override
  @JsonKey(defaultValue: '')
  final String imagePath;

  @override
  @JsonKey(defaultValue: '')
  final String assetPath;

  const OnboardingContentModel({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.assetPath,
  });

  factory OnboardingContentModel.fromJson(Map<String, dynamic> json) =>
      _$OnboardingContentModelFromJson(json);

  Map<String, dynamic> toJson() => _$OnboardingContentModelToJson(this);

  OnboardingContentEntity toEntity() {
    return OnboardingContentEntity(
      title: title,
      description: description,
      imagePath: imagePath,
      assetPath: assetPath,
    );
  }

  factory OnboardingContentModel.fromEntity(OnboardingContentEntity entity) {
    return OnboardingContentModel(
      title: entity.title,
      description: entity.description,
      imagePath: entity.imagePath,
      assetPath: entity.assetPath,
    );
  }
}
