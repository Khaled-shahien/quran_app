class Article {
  final String title;
  final String description;
  final String link;
  final DateTime pubDate;
  final String sourceName;
  final String category;

  const Article({
    required this.title,
    required this.description,
    required this.link,
    required this.pubDate,
    required this.sourceName,
    required this.category,
  });
}
