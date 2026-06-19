import 'package:json_annotation/json_annotation.dart';

part 'azkar_model.g.dart';

// TODO: Verify JSON field casing
@JsonSerializable(explicitToJson: true)
class AzkarCategoryModel {
  final int id;
  final String category;

  @JsonKey(defaultValue: <AzkarItemModel>[])
  final List<AzkarItemModel> items;

  AzkarCategoryModel({
    required this.id,
    required this.category,
    required this.items,
  });

  factory AzkarCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$AzkarCategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$AzkarCategoryModelToJson(this);
}

// TODO: Verify JSON field casing
@JsonSerializable()
class AzkarItemModel {
  final int id;
  final String title;
  final String text;

  @JsonKey(defaultValue: 1)
  final int repeat;

  @JsonKey(defaultValue: '')
  final String reference;

  AzkarItemModel({
    required this.id,
    required this.title,
    required this.text,
    required this.repeat,
    required this.reference,
  });

  factory AzkarItemModel.fromJson(Map<String, dynamic> json) =>
      _$AzkarItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$AzkarItemModelToJson(this);
}
