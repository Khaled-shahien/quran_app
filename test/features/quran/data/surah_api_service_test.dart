import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:quran_app/features/quran/data/data_sources/surah_api_service.dart';
import 'package:quran_app/features/quran/data/repositories/surah_repository.dart';
import 'package:quran_app/core/testing/mock_http_client.dart';
import 'package:quran_app/core/errors/network_exception.dart';
import 'package:quran_app/core/errors/api_exception.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

// Manual Mock for Connectivity
class MockConnectivity implements Connectivity {
  @override
  Future<ConnectivityResult> checkConnectivity() async {
    return ConnectivityResult.wifi;
  }

  @override
  Stream<ConnectivityResult> get onConnectivityChanged => Stream.value(ConnectivityResult.wifi);
}

// Mock Client that throws SocketException
class ThrowingMockClient extends MockHttpClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    throw const SocketException('Network error');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Surah API Service Tests', () {
    late MockHttpClient mockClient;
    late MockConnectivity mockConnectivity;
    late SurahApiService apiService;

    setUp(() {
      mockClient = MockHttpClient();
      mockConnectivity = MockConnectivity();
      apiService = SurahApiService(
        httpClient: mockClient,
        connectivity: mockConnectivity,
      );
      // Ensure we start with a clean state
      apiService.clearCache();
    });

    tearDown(() {
      mockClient.clearRequests();
    });

    test('should fetch all Surahs successfully', () async {
      // Arrange
      final mockResponse = [
        {
          "englishName": "Al-Faatiha",
          "name": "الفاتحة",
          "surahNameArabicLong": "سُورَةُ ٱلْفَاتِحَةِ",
          "surahNameTranslation": "The Opening",
          "revelationType": "Meccan",
          "numberOfAyahs": 7,
        },
        {
          "englishName": "Al-Baqarah",
          "name": "البقرة",
          "surahNameArabicLong": "سُورَةُ البَقَرَةِ",
          "surahNameTranslation": "The Cow",
          "revelationType": "Medinan",
          "numberOfAyahs": 286,
        },
      ];

      final mockApiResponse = {'data': mockResponse};
      mockClient.addJsonResponse(
        'https://api.alquran.cloud/v1/surah',
        'GET',
        mockApiResponse,
      );

      // Act
      final result = await apiService.getAllSurahs();

      // Assert
      expect(result.status, true);
      expect(result.data, isNotNull);
      expect(result.data!.length, 2);
      expect(result.data![0].surahName, 'Al-Faatiha');
      expect(result.data![0].surahNameArabic, 'الفاتحة');
      expect(result.data![0].totalAyah, 7);
      expect(result.data![1].surahName, 'Al-Baqarah');
      expect(result.data![1].revelationPlace, 'Medinan');

      // Verify request was made
      expect(mockClient.requestCount, 1);
      expect(
        mockClient.verifyRequest('https://api.alquran.cloud/v1/surah', 'GET'),
        true,
      );
    });

    test('should return cached data on subsequent calls', () async {
      // Arrange
      final mockResponse = [
        {
          "englishName": "Al-Faatiha",
          "name": "الفاتحة",
          "surahNameArabicLong": "سُورَةُ ٱلْفَاتِحَةِ",
          "surahNameTranslation": "The Opening",
          "revelationType": "Meccan",
          "numberOfAyahs": 7,
        },
      ];

      final mockApiResponse = {'data': mockResponse};
      mockClient.addJsonResponse(
        'https://api.alquran.cloud/v1/surah',
        'GET',
        mockApiResponse,
      );

      // Act 1: First call (fetches from API)
      final result1 = await apiService.getAllSurahs();

      // Act 2: Second call (should fetch from cache)
      // We clear the mock client responses to ensure no network call can succeed
      mockClient.clearRequests();
      // Also maybe add an error response so if it tries to hit network it fails?
      mockClient.addErrorResponse(
        'https://api.alquran.cloud/v1/surah',
        'GET',
        'Should not be called',
        statusCode: 500
      );

      final result2 = await apiService.getAllSurahs();

      // Assert
      expect(result1.data!.length, 1);
      expect(result2.data!.length, 1);
      expect(result2.data![0].surahName, 'Al-Faatiha');

      // Verification:
      // The mock client should have received 1 request total (from the first call)
      // The second call should not have triggered a request.
      expect(mockClient.requestCount, 0);
    });

    test('should handle network error', () async {
      // Arrange
      final throwingService = SurahApiService(
        httpClient: ThrowingMockClient(),
        connectivity: mockConnectivity,
      );

      // Act & Assert
      expect(
        () => throwingService.getAllSurahs(),
        throwsA(const TypeMatcher<NetworkException>()),
      );
    });

    test('should handle API error response', () async {
      // Arrange
      mockClient.addErrorResponse(
        'https://api.alquran.cloud/v1/surah',
        'GET',
        'Internal Server Error',
        statusCode: 500,
      );

      // Act & Assert
      final future = apiService.getAllSurahs();
      expect(future, throwsA(const TypeMatcher<ApiException>()));

      try {
        await future;
      } catch (e) {
        expect(e, isA<ApiException>());
        expect((e as ApiException).code, 500);
        expect(e.message, 'Internal Server Error');
      }
    });

    test('should get Surah by valid index', () async {
      // Arrange
      final mockResponse = {
        'data': {
          "englishName": "Al-Faatiha",
          "name": "الفاتحة",
          "surahNameArabicLong": "سُورَةُ ٱلْفَاتِحَةِ",
          "surahNameTranslation": "The Opening",
          "revelationType": "Meccan",
          "numberOfAyahs": 7,
        },
      };

      mockClient.addJsonResponse(
        'https://api.alquran.cloud/v1/surah/1',
        'GET',
        mockResponse,
      );

      // Act
      final result = await apiService.getSurahByIndex(1);

      // Assert
      expect(result.status, true);
      expect(result.data, isNotNull);
      expect(result.data!.surahName, 'Al-Faatiha');
      expect(result.data!.totalAyah, 7);
    });

    test('should throw error for invalid Surah index', () async {
      // Act & Assert
      expect(
        () => apiService.getSurahByIndex(0),
        throwsA(const TypeMatcher<ApiException>()),
      );

      expect(
        () => apiService.getSurahByIndex(115),
        throwsA(const TypeMatcher<ApiException>()),
      );
    });

    test('should search Surahs successfully', () async {
      // Arrange
      final mockResponse = [
        {
          "englishName": "Al-Faatiha",
          "name": "الفاتحة",
          "surahNameArabicLong": "سُورَةُ ٱلْفَاتِحَةِ",
          "surahNameTranslation": "The Opening",
          "revelationType": "Meccan",
          "numberOfAyahs": 7,
        },
      ];

      final mockApiResponse = {'data': mockResponse};

      mockClient.addJsonResponse(
        'https://api.alquran.cloud/v1/surah',
        'GET',
        mockApiResponse,
      );

      // Act
      final result = await apiService.searchSurahs('Al-Faatiha');

      // Assert
      expect(result.status, true);
      expect(result.data, isNotNull);
      expect(result.data!.length, 1);
      expect(result.data![0].surahName, 'Al-Faatiha');
    });

    test('should throw error for empty search query', () async {
      // Act & Assert
      expect(
        () => apiService.searchSurahs(''),
        throwsA(const TypeMatcher<ApiException>()),
      );
    });

    test('should get Surahs by revelation place', () async {
      // Arrange
      final mockResponse = [
        {
          "englishName": "Al-Faatiha",
          "name": "الفاتحة",
          "surahNameArabicLong": "سُورَةُ ٱلْفَاتِحَةِ",
          "surahNameTranslation": "The Opening",
          "revelationType": "Meccan",
          "numberOfAyahs": 7,
        },
      ];

      final mockApiResponse = {'data': mockResponse};

      mockClient.addJsonResponse(
        'https://api.alquran.cloud/v1/surah',
        'GET',
        mockApiResponse,
      );

      // Act
      final result = await apiService.getSurahsByRevelationPlace('Mecca');

      // Assert
      expect(result.status, true);
      expect(result.data, isNotNull);
      expect(result.data!.length, 1);
      expect(result.data![0].revelationPlace.toLowerCase(), 'meccan');
    });

    test('should throw error for invalid revelation place', () async {
      // Act & Assert
      expect(
        () => apiService.getSurahsByRevelationPlace('Invalid'),
        throwsA(const TypeMatcher<ApiException>()),
      );
    });

    test('should get Surah statistics', () async {
      // Arrange
      final mockResponse = [
        {
          "englishName": "Al-Faatiha",
          "name": "الفاتحة",
          "surahNameArabicLong": "سُورَةُ ٱلْفَاتِحَةِ",
          "surahNameTranslation": "The Opening",
          "revelationType": "Meccan",
          "numberOfAyahs": 7,
        },
        {
          "englishName": "Al-Baqarah",
          "name": "البقرة",
          "surahNameArabicLong": "سُورَةُ البَقَرَةِ",
          "surahNameTranslation": "The Cow",
          "revelationType": "Medinan",
          "numberOfAyahs": 286,
        },
      ];

      final mockApiResponse = {'data': mockResponse};

      mockClient.addJsonResponse(
        'https://api.alquran.cloud/v1/surah',
        'GET',
        mockApiResponse,
      );

      // Act
      final result = await apiService.getSurahStatistics();

      // Assert
      expect(result['totalSurahs'], 2);
      expect(result['meccanSurahs'], 1);
      expect(result['medianSurahs'], 1);
      expect(result['totalVerses'], 293);
      expect(result['averageVersesPerSurah'], 146.5);
    });
  });

  group('Surah Repository Tests', () {
    late MockHttpClient mockClient;
    late MockConnectivity mockConnectivity;
    late SurahApiService apiService;
    late SurahRepositoryImpl repository;
    late SharedPreferences prefs;

    setUp(() async {
      mockClient = MockHttpClient();
      mockConnectivity = MockConnectivity();
      apiService = SurahApiService(
        httpClient: mockClient,
        connectivity: mockConnectivity,
      );
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();

      // IMPORTANT: Clear cache to prevent test pollution
      apiService.clearCache();

      repository = SurahRepositoryImpl(
        apiService: apiService,
        sharedPreferences: prefs,
      );
    });

    tearDown(() {
      mockClient.clearRequests();
    });

    test('should fetch Surahs from API and cache them', () async {
      // Force clear cache
      apiService.clearCache();

      // Arrange
      final mockResponse = [
        {
          "englishName": "Al-Faatiha",
          "name": "الفاتحة",
          "surahNameArabicLong": "سُورَةُ ٱلْفَاتِحَةِ",
          "surahNameTranslation": "The Opening",
          "revelationType": "Meccan",
          "numberOfAyahs": 7,
        },
      ];

      final mockApiResponse = {'data': mockResponse};

      mockClient.addJsonResponse(
        'https://api.alquran.cloud/v1/surah',
        'GET',
        mockApiResponse,
      );

      // Act
      final result = await repository.getAllSurahs();

      // Assert
      expect(result.length, 1);
      expect(result[0].name, 'Al-Faatiha');

      // Verify cache was set
      final cacheKeyExists = prefs.containsKey('cached_surahs');
      expect(cacheKeyExists, true);
    });

    test('should return cached data when available', () async {
      // Arrange - Set up cache
      final cachedData = [
        {
          "surahName": "Cached Surah",
          "surahNameArabic": "سورة محفوظة",
          "surahNameArabicLong": "سُورَةُ مَحْفُوظَةٍ",
          "surahNameTranslation": "Cached Chapter",
          "revelationPlace": "Mecca",
          "totalAyah": 10,
        },
      ];

      final jsonString = jsonEncode(cachedData);
      await prefs.setString('cached_surahs', jsonString);
      await prefs.setInt(
        'cached_surahs_timestamp',
        DateTime.now().millisecondsSinceEpoch,
      );

      // Act - This should return cached data without API call
      final result = await repository.getAllSurahs();

      // Assert
      expect(result.length, 1);
      expect(result[0].name, 'Cached Surah');
    });

    test('should handle network error with cache fallback', () async {
      // Arrange - Set up expired cache
      final cachedData = [
        {
          "surahName": "Fallback Surah",
          "surahNameArabic": "سورة احتياطية",
          "surahNameArabicLong": "سُورَةُ احْتِيَاطِيَّةٍ",
          "surahNameTranslation": "Fallback Chapter",
          "revelationPlace": "Medina",
          "totalAyah": 15,
        },
      ];

      final jsonString = jsonEncode(cachedData);
      await prefs.setString('cached_surahs', jsonString);
      await prefs.setInt(
        'cached_surahs_timestamp',
        DateTime.now().millisecondsSinceEpoch,
      );

      // Make API fail using ThrowingMockClient
      final failingApiService = SurahApiService(
        httpClient: ThrowingMockClient(),
        connectivity: mockConnectivity,
      );

      // Use this service in repository
      repository = SurahRepositoryImpl(
        apiService: failingApiService,
        sharedPreferences: prefs,
      );

      // Act
      final result = await repository.getAllSurahs();

      // Assert
      expect(result.length, 1);
      expect(result[0].name, 'Fallback Surah');
    });

    test('should get specific Surah by index', () async {
      // Arrange
      final mockResponse = [
        {
          "englishName": "Al-Faatiha",
          "name": "الفاتحة",
          "surahNameArabicLong": "سُورَةُ ٱلْفَاتِحَةِ",
          "surahNameTranslation": "The Opening",
          "revelationType": "Meccan",
          "numberOfAyahs": 7,
        },
      ];

      final mockApiResponse = {'data': mockResponse};

      mockClient.addJsonResponse(
        'https://api.alquran.cloud/v1/surah',
        'GET',
        mockApiResponse,
      );

      // Act
      final result = await repository.getSurahByIndex(1);

      // Assert
      expect(result.name, 'Al-Faatiha');
      expect(result.totalAyah, 7);
    });

    test('should throw error for invalid Surah index', () async {
      // Arrange
      final mockResponse = [
        {
          "englishName": "Al-Faatiha",
          "name": "الفاتحة",
          "surahNameArabicLong": "سُورَةُ ٱلْفَاتِحَةِ",
          "surahNameTranslation": "The Opening",
          "revelationType": "Meccan",
          "numberOfAyahs": 7,
        },
      ];

      final mockApiResponse = {'data': mockResponse};

      mockClient.addJsonResponse(
        'https://api.alquran.cloud/v1/surah',
        'GET',
        mockApiResponse,
      );

      // Act & Assert
      expect(
        () => repository.getSurahByIndex(5),
        throwsA(const TypeMatcher<ApiException>()),
      );
    });

    test('should clear cache successfully', () async {
      // Arrange - Set up cache
      await prefs.setString('cached_surahs', 'test_data');
      await prefs.setInt('cached_surahs_timestamp', 1234567890);

      // Act
      await repository.clearCache();

      // Assert
      expect(prefs.containsKey('cached_surahs'), false);
      expect(prefs.containsKey('cached_surahs_timestamp'), false);
    });
  });
}
