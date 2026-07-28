/// API keys supplied at build time.
///
/// Use `--dart-define-from-file=.env` for local development. Never add real
/// credentials to source control.
class ApiKeys {
  ApiKeys._();

  static const String youtubeApiKey = String.fromEnvironment('YOUTUBE_API_KEY');
}
