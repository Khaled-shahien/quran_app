/// API constants and build-time configuration.
class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://api.alquran.cloud/v1';
  static const String quranBaseUrl = 'https://api.alquran.cloud/v1';
  static const String prayerTimesBaseUrl = 'https://api.aladhan.com/v1';

  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Optional API keys supplied with `--dart-define-from-file=.env`.
  ///
  /// No fallback values are stored in source control.
  static const String quranApiKey = String.fromEnvironment('QURAN_API_KEY');
  static const String prayerApiKey = String.fromEnvironment('PRAYER_API_KEY');

  static const String languageParam = 'language';
  static const String editionParam = 'edition';
  static const String methodParam = 'method';

  static const int successCode = 200;
  static const int createdCode = 201;
  static const int noContentCode = 204;
  static const int badRequestCode = 400;
  static const int unauthorizedCode = 401;
  static const int forbiddenCode = 403;
  static const int notFoundCode = 404;
  static const int methodNotAllowedCode = 405;
  static const int tooManyRequestsCode = 429;
  static const int internalServerErrorCode = 500;
  static const int badGatewayCode = 502;
  static const int serviceUnavailableCode = 503;
  static const int gatewayTimeoutCode = 504;
}
