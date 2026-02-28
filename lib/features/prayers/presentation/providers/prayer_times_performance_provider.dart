import 'package:flutter/foundation.dart';
import 'package:quran_app/features/prayers/domain/Entities/prayer_times_entity.dart';
import 'package:quran_app/features/prayers/domain/repositories/prayer_times_repository.dart';
import 'package:quran_app/core/utils/value_notifier_mixin.dart';

/// High-performance Prayer Times Provider
///
/// Uses granular state management and selective notifications
/// to minimize unnecessary widget rebuilds.
class PrayerTimesPerformanceProvider extends ChangeNotifier
    with SelectiveNotifyMixin {
  final PrayerTimesRepository _repository;

  // Use separate ValueNotifiers for granular updates
  final _prayerTimesNotifier = ValueNotifier<PrayerTimesEntity?>(null);
  final _isLoadingNotifier = PerformanceValueNotifier<bool>(false);
  final _errorMessageNotifier = ValueNotifier<String?>(null);

  PrayerTimesPerformanceProvider({required PrayerTimesRepository repository})
    : _repository = repository;

  // Getters with direct notifier access for better performance
  PrayerTimesEntity? get prayerTimes => _prayerTimesNotifier.value;
  bool get isLoading => _isLoadingNotifier.value;
  String? get errorMessage => _errorMessageNotifier.value;
  bool get hasData => _prayerTimesNotifier.value != null;
  bool get hasError => _errorMessageNotifier.value != null;

  /// Fetch prayer times with optimized state updates
  Future<void> fetchPrayerTimes(
    DateTime date,
    double latitude,
    double longitude, {
    int calculationMethod = 3,
  }) async {
    // Set loading state first
    _isLoadingNotifier.value = true;
    notifyForField('isLoading');

    // Clear previous error
    if (_errorMessageNotifier.value != null) {
      _errorMessageNotifier.value = null;
      notifyForField('errorMessage');
    }

    try {
      final prayerTimes = await _repository.getPrayerTimes(
        date,
        latitude,
        longitude,
        calculationMethod: calculationMethod,
      );

      // Update data
      _prayerTimesNotifier.value = prayerTimes;
      notifyForField('prayerTimes');
    } catch (e) {
      _errorMessageNotifier.value = e.toString();
      notifyForField('errorMessage');
    } finally {
      // Always update loading state last
      _isLoadingNotifier.value = false;
      notifyForField('isLoading');
    }
  }

  /// Refresh with optimized field updates
  Future<void> refresh() async {
    if (_prayerTimesNotifier.value != null) {
      await fetchPrayerTimes(
        DateTime.now(),
        _prayerTimesNotifier.value!.latitude ?? 0.0,
        _prayerTimesNotifier.value!.longitude ?? 0.0,
        calculationMethod: _prayerTimesNotifier.value!.calculationMethod ?? 3,
      );
    }
  }

  /// Clear data with selective notifications
  void clearData() {
    _prayerTimesNotifier.value = null;
    _errorMessageNotifier.value = null;

    notifyForFields({'prayerTimes', 'errorMessage'});
  }

  /// Get formatted prayer times
  Map<String, String> getFormattedPrayerTimes() {
    return _prayerTimesNotifier.value?.getFormattedPrayerTimes() ?? {};
  }

  /// Get main prayer times with optimized access
  Map<String, String> getMainPrayerTimes() {
    if (_prayerTimesNotifier.value != null) {
      final times = _prayerTimesNotifier.value!.getMainPrayerTimes();
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

  /// Dispose of all notifiers to prevent memory leaks
  @override
  void dispose() {
    _prayerTimesNotifier.dispose();
    _isLoadingNotifier.dispose();
    _errorMessageNotifier.dispose();
    super.dispose();
  }
}
