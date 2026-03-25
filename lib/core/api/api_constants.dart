/// API Constants and Configuration
///
/// Contains all API-related constants including base URLs,
/// endpoints, timeouts, and default headers.
class ApiConstants {
  // Prevent instantiation
  ApiConstants._();

  // Base URLs
  static const String baseUrl =
      'https://api.alquran.cloud/v1'; // Default to Quran API
  static const String quranBaseUrl = 'https://api.alquran.cloud/v1';
  static const String prayerTimesBaseUrl = 'https://api.aladhan.com/v1';

  // Timeouts
  static const int connectTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds

  // Default headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // API Keys
  // Securely passed at build time. Example:
  // flutter run --dart-define=QURAN_API_KEY=your_key
  //   --dart-define=PRAYER_API_KEY=your_key
  static const String quranApiKey = String.fromEnvironment(
    'QURAN_API_KEY',
    defaultValue: 'YOUR_QURAN_API_KEY',
  );
  static const String prayerApiKey = String.fromEnvironment(
    'PRAYER_API_KEY',
    defaultValue: 'YOUR_PRAYER_API_KEY',
  );

  // Common query parameters
  static const String languageParam = 'language';
  static const String editionParam = 'edition';
  static const String methodParam = 'method';

  // Response codes
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
