import 'package:flutter_dotenv/flutter_dotenv.dart';

/// API keys loaded from .env.
/// Never hardcode keys here; always use dotenv.
class ApiKeys {
  ApiKeys._();

  static String get youtubeApiKey {
    final key = dotenv.env['YOUTUBE_API_KEY'] ?? '';
    assert(
      key.isNotEmpty && key != 'REPLACE_ME',
      'YouTube API Key is missing. Add it to your .env file.',
    );
    return key;
  }
}
