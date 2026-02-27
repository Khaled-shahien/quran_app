import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/prayer_times_provider.dart';

/// Prayer Times Screen
///
/// Displays prayer times for the current day with loading and error states
class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
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
        21.4225, // Latitude for Makkah
        39.8262, // Longitude for Makkah
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'أوقات الصلاة',
          style: GoogleFonts.cairo(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.lightPrimary,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<PrayerTimesProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading prayer times',
                    style: GoogleFonts.cairo(fontSize: 16, color: Colors.red),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    provider.errorMessage ?? 'Unknown error',
                    style: GoogleFonts.cairo(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      provider.fetchPrayerTimes(
                        DateTime.now(),
                        21.4225, // Default coordinates
                        39.8262,
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (provider.hasData) {
            return _buildPrayerTimesContent(provider);
          }

          return const Center(child: Text('No data available'));
        },
      ),
    );
  }

  Widget _buildPrayerTimesContent(PrayerTimesProvider provider) {
    final prayerTimes = provider.getMainPrayerTimes();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.lightSecondary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  'Today\'s Prayer Times',
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: AppColors.lightPrimary.withAlpha(
                      (0.7 * 255).round(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: prayerTimes.keys.length,
              itemBuilder: (context, index) {
                final prayerName = prayerTimes.keys.elementAt(index);
                final prayerTime = prayerTimes[prayerName];

                return _prayerTimeTile(
                  prayerName: prayerName,
                  prayerTime: prayerTime ?? 'N/A',
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _prayerTimeTile({
    required String prayerName,
    required String prayerTime,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _getArabicPrayerName(prayerName),
            style: GoogleFonts.cairo(
              fontSize: 16,
              color: AppColors.lightPrimary,
            ),
          ),
          Text(
            prayerTime,
            style: GoogleFonts.cairo(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.lightPrimary,
            ),
          ),
        ],
      ),
    );
  }

  String _getArabicPrayerName(String englishName) {
    switch (englishName) {
      case 'Fajr':
        return 'الفجر';
      case 'Sunrise':
        return 'الشروق';
      case 'Dhuhr':
        return 'الظهر';
      case 'Asr':
        return 'العصر';
      case 'Maghrib':
        return 'المغرب';
      case 'Isha':
        return 'العشاء';
      default:
        return englishName;
    }
  }
}
