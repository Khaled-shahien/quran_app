class AzkarCategoryModel {
  final int id;
  final String category;
  final List<AzkarItemModel> items;

  AzkarCategoryModel({
    required this.id,
    required this.category,
    required this.items,
  });

  factory AzkarCategoryModel.fromJson(Map<String, dynamic> json) {
    return AzkarCategoryModel(
      id: json['id'] as int,
      category: json['category'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => AzkarItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class AzkarItemModel {
  final int id;
  final String title;
  final String text;
  final int repeat;
  final String reference;

  AzkarItemModel({
    required this.id,
    required this.title,
    required this.text,
    required this.repeat,
    required this.reference,
  });

  factory AzkarItemModel.fromJson(Map<String, dynamic> json) {
    return AzkarItemModel(
      id: json['id'] as int,
      title: json['title'] as String,
      text: json['text'] as String,
      repeat: json['repeat'] as int? ?? 1,
      reference: json['reference'] as String? ?? '',
    );
  }
}
