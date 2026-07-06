import '../../domain/entities/article.dart';

class ArticleModel extends Article {
  const ArticleModel({
    required super.title,
    required super.description,
    required super.link,
    required super.pubDate,
    required super.sourceName,
    required super.category,
  });

  factory ArticleModel.fromRssItem({
    required String title,
    required String description,
    required String link,
    required DateTime pubDate,
    required String sourceName,
    required String category,
  }) {
    return ArticleModel(
      title: title,
      description: description,
      link: link,
      pubDate: pubDate,
      sourceName: sourceName,
      category: category,
    );
  }
}
