import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../prayers/presentation/providers/prayer_times_provider.dart';

class PrayerTimesWidget extends StatefulWidget {
  const PrayerTimesWidget({super.key});

  @override
  State<PrayerTimesWidget> createState() => _PrayerTimesWidgetState();
}

class _PrayerTimesWidgetState extends State<PrayerTimesWidget> {
  @override
  void initState() {
    super.initState();
    // Initialize with a default location (Makkah coordinates as example)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final prayerProvider = Provider.of<PrayerTimesProvider>(
        context,
        listen: false,
      );
      prayerProvider.fetchPrayerTimes(
        DateTime.now(),
        30.0444, // Latitude for Cairo
        31.2357, // Longitude for Cairo
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Consumer<PrayerTimesProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.hasError) {
            return Column(
              children: [
                Text(
                  'أوقات الصلاة',
                  style: GoogleFonts.cairo(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                const Icon(Icons.error_outline, size: 32, color: Colors.red),
                const SizedBox(height: 8),
                Text(
                  'Failed to load prayer times',
                  style: GoogleFonts.cairo(fontSize: 14, color: Colors.red),
                ),
              ],
            );
          }

          if (provider.hasData) {
            return Column(
              children: [
                Text(
                  'أوقات الصلاة',
                  style: GoogleFonts.cairo(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                ..._buildPrayerTimesTiles(provider),
              ],
            );
          }

          return Column(
            children: [
              Text(
                'أوقات الصلاة',
                style: GoogleFonts.cairo(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              const Text('No data available'),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildPrayerTimesTiles(PrayerTimesProvider provider) {
    final prayerTimes = provider.getMainPrayerTimes();

    // Define Arabic names in the correct order
    final arabicNames = {
      'Fajr': 'الفجر',
      'Sunrise': 'الشروق',
      'Dhuhr': 'الظهر',
      'Asr': 'العصر',
      'Maghrib': 'المغرب',
      'Isha': 'العشاء',
    };

    return prayerTimes.entries.map((entry) {
      final englishName = entry.key;
      final time = entry.value;
      final arabicName = arabicNames[englishName] ?? englishName;

      return _prayerTimeTile(arabicName, time);
    }).toList();
  }

  Widget _prayerTimeTile(String prayerName, String prayerTime) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.secondary,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          prayerName,
          style: GoogleFonts.cairo(
            fontSize: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Text(
          prayerTime,
          style: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    ),
  );
}
