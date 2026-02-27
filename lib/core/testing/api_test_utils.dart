import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

/// Test Utilities for API Testing
///
/// Provides helper methods for API testing
class ApiTestUtils {
  /// Create a successful JSON response
  static http.Response createSuccessResponse(dynamic data) {
    return http.Response(
      jsonEncode(data),
      200,
      headers: {'content-type': 'application/json'},
    );
  }

  /// Create an error response
  static http.Response createErrorResponse(
    String message, {
    int statusCode = 500,
  }) {
    return http.Response(
      jsonEncode({'error': message, 'message': message}),
      statusCode,
      headers: {'content-type': 'application/json'},
    );
  }

  /// Create a network error response
  static http.Response createNetworkErrorResponse() {
    return http.Response(
      jsonEncode({
        'error': 'Network error',
        'message': 'No internet connection',
      }),
      0,
      headers: {'content-type': 'application/json'},
    );
  }

  /// Sample Quran API response data
  static Map<String, dynamic> get sampleQuranResponse {
    return {
      'code': 200,
      'status': 'OK',
      'data': {
        'number': 1,
        'name': 'الفاتحة',
        'englishName': 'Al-Faatiha',
        'englishNameTranslation': 'The Opening',
        'revelationType': 'Meccan',
        'numberOfAyahs': 7,
        'ayahs': [
          {
            'number': 1,
            'text': 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
            'numberInSurah': 1,
            'juz': 1,
            'manzil': 1,
            'page': 1,
            'ruku': 1,
            'hizbQuarter': 1,
            'sajda': false,
          },
        ],
      },
    };
  }

  /// Sample Prayer Times API response data
  static Map<String, dynamic> get samplePrayerTimesResponse {
    return {
      'code': 200,
      'status': 'OK',
      'data': {
        'timings': {
          'Fajr': '05:30',
          'Sunrise': '07:00',
          'Dhuhr': '12:30',
          'Asr': '16:00',
          'Sunset': '18:30',
          'Maghrib': '18:30',
          'Isha': '20:00',
          'Imsak': '05:20',
          'Midnight': '00:30',
        },
        'date': {
          'readable': '20 Jan 2024',
          'timestamp': '1705708800',
          'hijri': {
            'date': '09-05-1445',
            'format': 'DD-MM-YYYY',
            'day': '09',
            'weekday': {'en': 'Saturday', 'ar': 'السبت'},
            'month': {'number': 5, 'en': 'Jumada al-Awwal', 'ar': 'جمادى أول'},
            'year': '1445',
            'designation': {'abbreviated': 'AH', 'expanded': 'Anno Hegirae'},
          },
          'gregorian': {
            'date': '20-01-2024',
            'format': 'DD-MM-YYYY',
            'day': '20',
            'weekday': {'en': 'Saturday'},
            'month': {'number': 1, 'en': 'January'},
            'year': '2024',
            'designation': {'abbreviated': 'AD', 'expanded': 'Anno Domini'},
          },
        },
        'meta': {
          'latitude': 24.7136,
          'longitude': 46.6753,
          'timezone': 'Asia/Riyadh',
          'method': {
            'id': 4,
            'name': 'Umm Al-Qura University, Makkah',
            'params': {'Fajr': 18, 'Isha': '90 min'},
          },
        },
      },
    };
  }

  /// Verify that an API call was made with expected parameters
  static void verifyApiCall({
    required Mock mock,
    required String method,
    required String url,
    Map<String, dynamic>? queryParams,
    Object? body,
  }) {
    // This would be implemented with specific mock verification
    // based on your testing framework setup
  }
}
