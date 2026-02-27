import '../../domain/entities/onboarding_content_entity.dart';

class OnboardingContentModel extends OnboardingContentEntity {
  const OnboardingContentModel({
    required super.title,
    required super.description,
    required super.imagePath,
    required super.assetPath,
  });

  factory OnboardingContentModel.fromJson(Map<String, dynamic> json) {
    return OnboardingContentModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imagePath: json['imagePath'] ?? '',
      assetPath: json['assetPath'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'imagePath': imagePath,
      'assetPath': assetPath,
    };
  }

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
