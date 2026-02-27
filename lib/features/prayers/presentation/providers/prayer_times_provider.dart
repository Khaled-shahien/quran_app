import 'package:flutter/foundation.dart';
import 'package:quran_app/features/prayers/domain/Entities/prayer_times_entity.dart';
import 'package:quran_app/features/prayers/domain/repositories/prayer_times_repository.dart';

/// Prayer Times Provider
///
/// State management provider for Prayer Times functionality.
/// Manages loading states, error handling, and data fetching.
class PrayerTimesProvider extends ChangeNotifier {
  final PrayerTimesRepository _repository;

  PrayerTimesEntity? _prayerTimes;
  bool _isLoading = false;
  String? _errorMessage;

  PrayerTimesProvider({required PrayerTimesRepository repository})
    : _repository = repository;

  /// Get current prayer times
  PrayerTimesEntity? get prayerTimes => _prayerTimes;

  /// Get loading state
  bool get isLoading => _isLoading;

  /// Get error message
  String? get errorMessage => _errorMessage;

  /// Check if data is loaded
  bool get hasData => _prayerTimes != null;

  /// Check if there's an error
  bool get hasError => _errorMessage != null;

  /// Fetch prayer times for given date and location
  ///
  /// Parameters:
  /// - date: Date to fetch prayer times for
  /// - latitude: User's latitude
  /// - longitude: User's longitude
  /// - calculationMethod: Calculation method (default 3 for Muslim World League)
  Future<void> fetchPrayerTimes(
    DateTime date,
    double latitude,
    double longitude, {
    int calculationMethod = 3,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final prayerTimes = await _repository.getPrayerTimes(
        date,
        latitude,
        longitude,
        calculationMethod: calculationMethod,
      );

      _prayerTimes = prayerTimes;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Refresh prayer times with current parameters
  Future<void> refresh() async {
    if (_prayerTimes != null) {
      // For simplicity, we'll refetch today's prayer times
      // In a real app, you'd want to store the last parameters used
      await fetchPrayerTimes(
        DateTime.now(),
        _prayerTimes!.latitude ?? 0.0,
        _prayerTimes!.longitude ?? 0.0,
        calculationMethod: _prayerTimes!.calculationMethod ?? 3,
      );
    }
  }

  /// Clear current data
  void clearData() {
    _prayerTimes = null;
    _errorMessage = null;
    notifyListeners();
  }

  /// Get formatted prayer times for display
  Map<String, String> getFormattedPrayerTimes() {
    if (_prayerTimes != null) {
      return _prayerTimes!.getFormattedPrayerTimes();
    }
    return {};
  }

  /// Get main prayer times (excluding optional ones)
  Map<String, String> getMainPrayerTimes() {
    if (_prayerTimes != null) {
      final times = _prayerTimes!.getMainPrayerTimes();
      return {
        'Fajr': times['Fajr'] ?? 'N/A',
        'Sunrise': times['Sunrise'] ?? 'N/A',
        'Dhuhr': times['Dhuhr'] ?? 'N/A',
        'Asr': times['Asr'] ?? 'N/A',
        'Maghrib': times['Maghrib'] ?? 'N/A',
        'Isha': times['Isha'] ?? 'N/A',
      };
    }
    return {};
  }
}
