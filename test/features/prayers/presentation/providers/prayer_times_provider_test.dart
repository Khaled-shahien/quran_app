import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/features/prayers/domain/Entities/prayer_times_entity.dart';
import 'package:quran_app/features/prayers/domain/repositories/prayer_times_repository.dart';
import 'package:quran_app/features/prayers/presentation/providers/prayer_times_provider.dart';

class FakePrayerTimesRepository implements PrayerTimesRepository {
  @override
  Future<PrayerTimesEntity> getPrayerTimes(
    DateTime date,
    double latitude,
    double longitude, {
    int calculationMethod = 3,
  }) async {
    return PrayerTimesEntity(
      fajr: '05:00',
      sunrise: '06:20',
      dhuhr: '12:15',
      asr: '15:40',
      maghrib: '18:30',
      isha: '19:45',
      latitude: latitude,
      longitude: longitude,
      calculationMethod: calculationMethod,
    );
  }
}

void main() {
  test('PrayerTimesProvider fetches and exposes main prayer times', () async {
    final provider = PrayerTimesProvider(
      repository: FakePrayerTimesRepository(),
    );

    await provider.fetchPrayerTimes(DateTime(2026, 3, 23), 30.0444, 31.2357);

    expect(provider.hasData, isTrue);
    expect(provider.hasError, isFalse);
    expect(provider.getMainPrayerTimes()['Fajr'], isNot('N/A'));
    expect(provider.getMainPrayerTimes()['Maghrib'], isNot('N/A'));
  });
}
