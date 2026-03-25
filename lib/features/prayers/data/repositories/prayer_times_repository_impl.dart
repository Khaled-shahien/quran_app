import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../core/errors/api_exception.dart';
import '../../../../../core/errors/network_exception.dart';
import '../../../../../core/api/api_error_handler.dart';
import '../data_sources/prayer_times_api_service.dart';
import '../models/prayer_times_response.dart';
import '../../domain/repositories/prayer_times_repository.dart';
import '../../domain/Entities/prayer_times_entity.dart';

/// Prayer Times Repository Implementation
///
/// Repository pattern implementation for Prayer Times data access.
/// Handles data fetching from API and error management.
class PrayerTimesRepositoryImpl implements PrayerTimesRepository {
  final PrayerTimesApiService _apiService;
  final ApiErrorHandler _errorHandler;
  final SharedPreferences _prefs;

  // Cache keys
  static const String _prayerTimesCacheKey = 'cached_prayer_times';
  static const String _prayerTimesCacheTimestampKey =
      'cached_prayer_times_timestamp';
  static const int _cacheDurationHours = 2; // Cache for 2 hours

  PrayerTimesRepositoryImpl({
    required PrayerTimesApiService apiService,
    required SharedPreferences sharedPreferences,
    ApiErrorHandler? errorHandler,
  }) : _apiService = apiService,
       _prefs = sharedPreferences,
       _errorHandler = errorHandler ?? ApiErrorHandler();

  /// Convert PrayerTimesResponse to PrayerTimesEntity
  PrayerTimesEntity _responseToEntity(PrayerTimesResponse response) {
    final data = response.data;
    final timings = data?.timings;
    final meta = data?.meta;
    final gregorianDate = data?.date?.gregorian;

    return PrayerTimesEntity(
      fajr: timings?.fajr,
      sunrise: timings?.sunrise,
      dhuhr: timings?.dhuhr,
      asr: timings?.asr,
      maghrib: timings?.maghrib,
      isha: timings?.isha,
      imsak: timings?.imsak,
      midnight: timings?.midnight,
      latitude: meta?.latitude,
      longitude: meta?.longitude,
      timezone: meta?.timezone,
      calculationMethod: meta?.method?.id,
      lunarSighting: gregorianDate?.lunarSighting,
    );
  }

  /// Get prayer times for a specific date and location
  ///
  /// Parameters:
  /// - [date]: The date to get prayer times for
  /// - [latitude]: User's latitude
  /// - [longitude]: User's longitude
  /// - [calculationMethod]: Calculation method
  ///   (default 3 for Muslim World League)
  ///
  /// Returns: Future<PrayerTimesEntity>
  /// Throws: NetworkException, ApiException
  @override
  Future<PrayerTimesEntity> getPrayerTimes(
    DateTime date,
    double latitude,
    double longitude, {
    int calculationMethod = 3,
  }) async {
    try {
      // Fetch from API
      final response = await _apiService.getPrayerTimes(
        date,
        latitude,
        longitude,
        calculationMethod: calculationMethod,
      );

      if (response.status == 'OK' && response.data != null) {
        return _responseToEntity(response);
      } else {
        throw ApiException(
          message: 'Failed to fetch prayer times: ${response.status}',
          code: response.code,
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

  /// Check if cache is valid (within 2 hours)
  Future<bool> isCacheValid() async {
    final timestamp = _prefs.getInt(_prayerTimesCacheTimestampKey);
    if (timestamp == null) return false;

    final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final difference = now.difference(cacheTime);

    return difference.inHours < _cacheDurationHours;
  }

  /// Clear cached prayer times data
  Future<void> clearCache() async {
    await _prefs.remove(_prayerTimesCacheKey);
    await _prefs.remove(_prayerTimesCacheTimestampKey);
  }
}
