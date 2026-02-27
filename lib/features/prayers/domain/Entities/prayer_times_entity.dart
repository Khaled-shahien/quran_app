/// Prayer Times Entity
///
/// Domain entity representing prayer times for a specific date and location
class PrayerTimesEntity {
  final String? fajr;
  final String? sunrise;
  final String? dhuhr;
  final String? asr;
  final String? maghrib;
  final String? isha;
  final String? imsak;
  final String? midnight;
  final double? latitude;
  final double? longitude;
  final String? timezone;
  final int? calculationMethod;
  final bool? lunarSighting;

  PrayerTimesEntity({
    this.fajr,
    this.sunrise,
    this.dhuhr,
    this.asr,
    this.maghrib,
    this.isha,
    this.imsak,
    this.midnight,
    this.latitude,
    this.longitude,
    this.timezone,
    this.calculationMethod,
    this.lunarSighting,
  });

  /// Get all main prayer times as a map
  Map<String, String?> getMainPrayerTimes() {
    return {
      'Fajr': fajr,
      'Sunrise': sunrise,
      'Dhuhr': dhuhr,
      'Asr': asr,
      'Maghrib': maghrib,
      'Isha': isha,
    };
  }

  /// Check if all main prayer times are available
  bool get hasCompleteData {
    return fajr != null &&
        sunrise != null &&
        dhuhr != null &&
        asr != null &&
        maghrib != null &&
        isha != null;
  }

  /// Get formatted prayer times for display
  Map<String, String> getFormattedPrayerTimes() {
    return {
      'Fajr': fajr ?? 'N/A',
      'Sunrise': sunrise ?? 'N/A',
      'Dhuhr': dhuhr ?? 'N/A',
      'Asr': asr ?? 'N/A',
      'Maghrib': maghrib ?? 'N/A',
      'Isha': isha ?? 'N/A',
    };
  }

  @override
  String toString() {
    return 'PrayerTimesEntity(fajr: $fajr, sunrise: $sunrise, dhuhr: $dhuhr, asr: $asr, maghrib: $maghrib, isha: $isha)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PrayerTimesEntity &&
        other.fajr == fajr &&
        other.sunrise == sunrise &&
        other.dhuhr == dhuhr &&
        other.asr == asr &&
        other.maghrib == maghrib &&
        other.isha == isha;
  }

  @override
  int get hashCode {
    return Object.hash(fajr, sunrise, dhuhr, asr, maghrib, isha);
  }
}
