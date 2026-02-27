import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/api_exception.dart';
import '../../../../core/errors/network_exception.dart';
import '../../../../core/api/api_error_handler.dart';
import '../data_sources/surah_api_service.dart';
import '../models/surah_model.dart';
import '../../domain/repositories/surah_repository.dart';
import '../../domain/entities/surah_entity.dart';

/// Surah Repository
///
/// Repository pattern implementation for Surah data access.
/// Handles data fetching, caching, and error management.
class SurahRepositoryImpl implements SurahRepository {
  final SurahApiService _apiService;
  final ApiErrorHandler _errorHandler;
  final SharedPreferences _prefs;

  // Cache keys
  static const String _surahsCacheKey = 'cached_surahs';
  static const String _surahsCacheTimestampKey = 'cached_surahs_timestamp';
  static const int _cacheDurationHours = 24; // Cache for 24 hours

  SurahRepositoryImpl({
    required SurahApiService apiService,
    required SharedPreferences sharedPreferences,
    ApiErrorHandler? errorHandler,
  }) : _apiService = apiService,
       _prefs = sharedPreferences,
       _errorHandler = errorHandler ?? ApiErrorHandler();

  /// Convert SurahModel to SurahEntity
  SurahEntity _modelToEntity(SurahModel model) {
    return SurahEntity(
      name: model.surahName,
      nameArabic: model.surahNameArabic,
      nameArabicLong: model.surahNameArabicLong,
      translation: model.surahNameTranslation,
      revelationPlace: model.revelationPlace,
      totalAyah: model.totalAyah,
    );
  }

  /// Get all Surahs with caching support
  ///
  /// First checks local cache, then fetches from API if cache is expired
  /// or not available.
  ///
  /// Returns: Future<List<SurahEntity>>
  /// Throws: NetworkException, ApiException
  @override
  Future<List<SurahEntity>> getAllSurahs() async {
    try {
      // Try to get from cache first
      final cachedSurahsModels = await _getCachedSurahs();
      if (cachedSurahsModels != null && cachedSurahsModels.isNotEmpty) {
        return cachedSurahsModels.map(_modelToEntity).toList();
      }

      // Fetch from API
      final response = await _apiService.getAllSurahs();

      if (response.status && response.data != null) {
        // Cache the results
        await _cacheSurahs(response.data!);
        return response.data!.map(_modelToEntity).toList();
      } else {
        throw ApiException(
          message: response.message ?? 'Failed to fetch Surahs',
          code: response.code ?? 500,
        );
      }
    } on NetworkException {
      // If network fails, try to return cached data even if expired
      final cachedDataModels = await _getExpiredCachedSurahs();
      if (cachedDataModels != null) {
        return cachedDataModels.map(_modelToEntity).toList();
      }
      rethrow;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: _errorHandler.handleError(e), code: 0);
    }
  }

  /// Get a specific Surah by index
  ///
  /// Parameters:
  /// - [index]: Surah number (1-114)
  ///
  /// Returns: Future<SurahEntity>
  /// Throws: NetworkException, ApiException
  @override
  Future<SurahEntity> getSurahByIndex(int index) async {
    try {
      final surahs = await getAllSurahs();

      if (index < 1 || index > surahs.length) {
        throw ApiException(
          message: 'Surah index $index is out of range (1-${surahs.length})',
          code: 404,
        );
      }

      return surahs[index - 1]; // Convert to 0-based index
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: _errorHandler.handleError(e), code: 0);
    }
  }

  /// Search Surahs by name
  ///
  /// Parameters:
  /// - [query]: Search term
  ///
  /// Returns: Future<List<SurahEntity>>
  /// Throws: NetworkException, ApiException
  @override
  Future<List<SurahEntity>> searchSurahs(String query) async {
    try {
      // For search, we'll fetch fresh data to ensure accuracy
      final response = await _apiService.searchSurahs(query);

      if (response.status && response.data != null) {
        return response.data!.map(_modelToEntity).toList();
      } else {
        throw ApiException(
          message: response.message ?? 'Search failed',
          code: response.code ?? 500,
        );
      }
    } on NetworkException {
      rethrow;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: _errorHandler.handleError(e), code: 0);
    }
  }

  /// Get Surahs by revelation place
  ///
  /// Parameters:
  /// - [place]: 'Mecca' or 'Madina'
  ///
  /// Returns: Future<List<SurahEntity>>
  /// Throws: NetworkException, ApiException
  @override
  Future<List<SurahEntity>> getSurahsByRevelationPlace(String place) async {
    try {
      final response = await _apiService.getSurahsByRevelationPlace(place);

      if (response.status && response.data != null) {
        return response.data!.map(_modelToEntity).toList();
      } else {
        throw ApiException(
          message: response.message ?? 'Failed to fetch Surahs by place',
          code: response.code ?? 500,
        );
      }
    } on NetworkException {
      rethrow;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: _errorHandler.handleError(e), code: 0);
    }
  }

  /// Get Surah statistics
  ///
  /// Returns: Future<Map<String, dynamic>>
  /// Throws: NetworkException, ApiException
  @override
  Future<Map<String, dynamic>> getSurahStatistics() async {
    try {
      return await _apiService.getSurahStatistics();
    } catch (e) {
      throw ApiException(message: _errorHandler.handleError(e), code: 0);
    }
  }

  /// Clear cached Surah data
  @override
  Future<void> clearCache() async {
    await _prefs.remove(_surahsCacheKey);
    await _prefs.remove(_surahsCacheTimestampKey);
  }

  /// Check if cache is valid (within 24 hours)
  Future<bool> isCacheValid() async {
    final timestamp = _prefs.getInt(_surahsCacheTimestampKey);
    if (timestamp == null) return false;

    final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final difference = now.difference(cacheTime);

    return difference.inHours < _cacheDurationHours;
  }

  /// Cache Surahs data
  Future<void> _cacheSurahs(List<SurahModel> surahs) async {
    try {
      final surahsJson = surahs.map((surah) => surah.toJson()).toList();
      final jsonString = jsonEncode(surahsJson);

      await _prefs.setString(_surahsCacheKey, jsonString);
      await _prefs.setInt(
        _surahsCacheTimestampKey,
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      // Silently fail cache operations
      // Don't throw exceptions for cache failures
    }
  }

  /// Get cached Surahs (only if cache is valid)
  Future<List<SurahModel>?> _getCachedSurahs() async {
    try {
      if (!await isCacheValid()) return null;

      final jsonString = _prefs.getString(_surahsCacheKey);
      if (jsonString == null) return null;

      final List<dynamic> jsonList = jsonDecode(jsonString);
      final surahs = jsonList
          .map((json) => SurahModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return surahs;
    } catch (e) {
      // Return null if cache reading fails
      return null;
    }
  }

  /// Get cached Surahs even if expired (fallback for network errors)
  Future<List<SurahModel>?> _getExpiredCachedSurahs() async {
    try {
      final jsonString = _prefs.getString(_surahsCacheKey);
      if (jsonString == null) return null;

      final List<dynamic> jsonList = jsonDecode(jsonString);
      final surahs = jsonList
          .map((json) => SurahModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return surahs;
    } catch (e) {
      return null;
    }
  }
}
