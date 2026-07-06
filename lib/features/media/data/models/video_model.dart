import '../../domain/entities/video.dart';

class VideoModel extends Video {
  const VideoModel({
    required super.videoId,
    required super.title,
    required super.description,
    required super.thumbnailUrl,
    required super.channelTitle,
    required super.publishedAt,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as Map<String, dynamic>? ?? const {};
    final snippet = json['snippet'] as Map<String, dynamic>? ?? const {};
    final thumbnails =
        snippet['thumbnails'] as Map<String, dynamic>? ?? const {};
    final thumbnail =
        thumbnails['high'] as Map<String, dynamic>? ??
        thumbnails['medium'] as Map<String, dynamic>? ??
        thumbnails['default'] as Map<String, dynamic>? ??
        const {};

    return VideoModel(
      videoId: id['videoId'] as String? ?? '',
      title: _decodeHtml(snippet['title'] as String? ?? ''),
      description: _decodeHtml(snippet['description'] as String? ?? ''),
      thumbnailUrl: thumbnail['url'] as String? ?? '',
      channelTitle: snippet['channelTitle'] as String? ?? '',
      publishedAt: DateTime.tryParse(snippet['publishedAt'] as String? ?? ''),
    );
  }
}

String _decodeHtml(String value) {
  return value
      .replaceAll('&quot;', '"')
      .replaceAll('&#39;', "'")
      .replaceAll('&amp;', '&')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .trim();
}
