import '../../../../core/api/base_api_service.dart';
import '../../../../core/api/models/base_response.dart';
import '../../../../core/api/api_logger.dart';
import '../../../../core/errors/api_exception.dart';
import '../models/surah_model.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Surah API Service
///
/// Handles all Surah-related API operations for the Quran application.
/// This service fetches the complete list of 114 Surahs from the public API.
class SurahApiService extends BaseApiService {
  static const String _baseUrl = 'https://api.alquran.cloud/v1';
  static const String _surahEndpoint = '/surah';

  // In-memory cache for Surahs to prevent redundant network requests
  // Static to share across instances (Singleton-like behavior for data)
  static List<SurahModel>? _memCache;

  SurahApiService({
    http.Client? httpClient,
    Logger? logger,
    Connectivity? connectivity,
  }) : super(
         httpClient: httpClient,
         logger: logger,
         connectivity: connectivity,
       );

  /// Get complete list of all 114 Surahs
  ///
  /// Fetches all Surahs with their metadata including:
  /// - English and Arabic names
  /// - Translations
  /// - Revelation place (Mecca/Madina)
  /// - Total number of verses
  ///
  /// Returns: Future<BaseResponse<List<SurahModel>>>
  /// Throws: NetworkException, ApiException
  Future<BaseResponse<List<SurahModel>>> getAllSurahs() async {
    // Check in-memory cache first
    if (_memCache != null) {
      ApiLogger.logDebug('Returning ${_memCache!.length} Surahs from in-memory cache');
      return BaseResponse.success(
        data: _memCache,
        message: 'Successfully fetched ${_memCache!.length} Surahs (Cached)',
        code: 200,
      );
    }

    try {
      // Log the API request
      ApiLogger.logRequest(method: 'GET', url: '$_baseUrl$_surahEndpoint');

      // Make the API call
      final response = await get(
        _surahEndpoint,
        headers: {'Accept': 'application/json', 'User-Agent': 'QuranApp/1.0'},
      );

      // Log the successful response
      ApiLogger.logResponse(
        statusCode: 200,
        url: '$_baseUrl$_surahEndpoint',
        body: response,
      );

      // Parse the response
      // The alquran.cloud API returns data wrapped in a 'data' field
      final responseData = response;
      final List<dynamic> surahsJson = responseData['data'] as List;
      final List<SurahModel> surahs = surahsJson
          .map((json) => SurahModel.fromJson(json as Map<String, dynamic>))
          .toList();

      // Validate the response
      if (surahs.length != 114) {
        ApiLogger.logWarning(
          'Expected 114 Surahs but received ${surahs.length}',
        );
      }

      // Update cache
      _memCache = surahs;

      return BaseResponse.success(
        data: surahs,
        message: 'Successfully fetched ${surahs.length} Surahs',
        code: 200,
      );
    } catch (e, stackTrace) {
      // Log the error
      ApiLogger.logError(
        error: e,
        url: '$_baseUrl$_surahEndpoint',
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  /// Get a specific Surah by index (1-114)
  ///
  /// Parameters:
  /// - [index]: Surah number (1-114)
  ///
  /// Returns: Future<BaseResponse<SurahModel>>
  /// Throws: NetworkException, ApiException
  Future<BaseResponse<SurahModel>> getSurahByIndex(int index) async {
    if (index < 1 || index > 114) {
      throw ApiException(
        message: 'Surah index must be between 1 and 114',
        code: 400,
      );
    }

    // Optimization: Check if we have the surah in cache
    if (_memCache != null && _memCache!.length >= index) {
      // Index is 1-based, list is 0-based
      // Ensure index is valid for cache access
      if (index <= _memCache!.length) {
         return BaseResponse.success(
          data: _memCache![index - 1],
          message: 'Successfully fetched Surah ${_memCache![index - 1].surahName} (Cached)',
          code: 200,
        );
      }
    }

    try {
      // Log the API request
      ApiLogger.logRequest(method: 'GET', url: '$_baseUrl/surah/$index');

      // Make the API call to get specific surah
      final response = await get(
        '/surah/$index',
        headers: {'Accept': 'application/json', 'User-Agent': 'QuranApp/1.0'},
      );

      // Log the successful response
      ApiLogger.logResponse(
        statusCode: 200,
        url: '$_baseUrl/surah/$index',
        body: response,
      );

      // Parse the response
      // The alquran.cloud API returns data wrapped in a 'data' field
      final responseData = response;
      final surahData = responseData['data'] as Map<String, dynamic>;
      final surah = SurahModel.fromJson(surahData);

      return BaseResponse.success(
        data: surah,
        message: 'Successfully fetched Surah ${surah.surahName}',
        code: 200,
      );
    } catch (e, stackTrace) {
      // Log the error
      ApiLogger.logError(
        error: e,
        url: '$_baseUrl/surah/$index',
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }

  /// Search Surahs by name (English or Arabic)
  ///
  /// Parameters:
  /// - [query]: Search term (case-insensitive)
  ///
  /// Returns: Future<BaseResponse<List<SurahModel>>>
  /// Throws: NetworkException, ApiException
  Future<BaseResponse<List<SurahModel>>> searchSurahs(String query) async {
    if (query.isEmpty) {
      throw ApiException(message: 'Search query cannot be empty', code: 400);
    }

    try {
      // Get all Surahs first (will use cache if available)
      final allSurahsResponse = await getAllSurahs();

      if (!allSurahsResponse.status || allSurahsResponse.data == null) {
        throw ApiException(
          message: allSurahsResponse.message ?? 'Failed to fetch Surahs',
          code: allSurahsResponse.code ?? 500,
        );
      }

      // Filter Surahs based on search query
      final filteredSurahs = allSurahsResponse.data!.where((surah) {
        final lowerQuery = query.toLowerCase();
        return surah.surahName.toLowerCase().contains(lowerQuery) ||
            surah.surahNameArabic.contains(
              query,
            ) || // Arabic search is case-sensitive
            surah.surahNameTranslation.toLowerCase().contains(lowerQuery) ||
            surah.surahNameArabicLong.contains(query);
      }).toList();

      return BaseResponse.success(
        data: filteredSurahs,
        message: 'Found ${filteredSurahs.length} matching Surahs',
        code: 200,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Get Surahs by revelation place
  ///
  /// Parameters:
  /// - [place]: 'Mecca' or 'Madina'
  ///
  /// Returns: Future<BaseResponse<List<SurahModel>>>
  /// Throws: NetworkException, ApiException
  Future<BaseResponse<List<SurahModel>>> getSurahsByRevelationPlace(
    String place,
  ) async {
    final normalizedPlace = place.toLowerCase();
    if (normalizedPlace != 'mecca' && normalizedPlace != 'madina') {
      throw ApiException(
        message: 'Place must be either "Mecca" or "Madina"',
        code: 400,
      );
    }

    try {
      // Get all Surahs first (will use cache if available)
      final allSurahsResponse = await getAllSurahs();

      if (!allSurahsResponse.status || allSurahsResponse.data == null) {
        throw ApiException(
          message: allSurahsResponse.message ?? 'Failed to fetch Surahs',
          code: allSurahsResponse.code ?? 500,
        );
      }

      // Filter by revelation place - handle both old and new formats
      final filteredSurahs = allSurahsResponse.data!.where((surah) {
        final surahPlace = surah.revelationPlace.toLowerCase();
        // Match both the old format (mecca/madina) and new format (meccan/medinan)
        if (normalizedPlace == 'mecca') {
          return surahPlace == 'mecca' ||
              surahPlace == 'meccan' ||
              surahPlace == 'mc';
        } else {
          // madina
          return surahPlace == 'madina' ||
              surahPlace == 'medinan' ||
              surahPlace == 'md';
        }
      }).toList();

      return BaseResponse.success(
        data: filteredSurahs,
        message: 'Found ${filteredSurahs.length} $place Surahs',
        code: 200,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Get statistics about Surahs
  ///
  /// Returns counts of Meccan vs Median Surahs
  ///
  /// Returns: Future<Map<String, dynamic>>
  /// Throws: NetworkException, ApiException
  Future<Map<String, dynamic>> getSurahStatistics() async {
    try {
      final allSurahsResponse = await getAllSurahs();

      if (!allSurahsResponse.status || allSurahsResponse.data == null) {
        throw ApiException(
          message: allSurahsResponse.message ?? 'Failed to fetch Surahs',
          code: allSurahsResponse.code ?? 500,
        );
      }

      final surahs = allSurahsResponse.data!;
      final meccanCount = surahs.where((surah) {
        final place = surah.revelationPlace.toLowerCase();
        return place == 'mecca' || place == 'meccan' || place == 'mc';
      }).length;
      final medianCount = surahs.where((surah) {
        final place = surah.revelationPlace.toLowerCase();
        return place == 'madina' || place == 'medinan' || place == 'md';
      }).length;
      final totalVerses = surahs.fold<int>(
        0,
        (sum, surah) => sum + surah.totalAyah,
      );

      return {
        'totalSurahs': surahs.length,
        'meccanSurahs': meccanCount,
        'medianSurahs': medianCount,
        'totalVerses': totalVerses,
        'averageVersesPerSurah': totalVerses / surahs.length,
      };
    } catch (e) {
      rethrow;
    }
  }

  /// Clear the in-memory cache
  /// Useful for testing or forcing a refresh
  void clearCache() {
    _memCache = null;
  }
}
