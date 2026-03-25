import '../Entities/prayer_times_entity.dart';

/// Prayer Times Repository Interface
///
/// Defines the contract for accessing prayer times data
abstract class PrayerTimesRepository {
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
  Future<PrayerTimesEntity> getPrayerTimes(
    DateTime date,
    double latitude,
    double longitude, {
    int calculationMethod = 3,
  });
}
