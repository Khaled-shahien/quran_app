import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:async';
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
  late Timer _countdownTimer;

  @override
  void initState() {
    super.initState();
    // Initialize with a default location (Makkah coordinates as example)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final prayerProvider = Provider.of<PrayerTimesProvider>(
        context,
        listen: false,
      );
      prayerProvider.fetchTodayForCurrentLocation();
    });

    // Update countdown every second
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _countdownTimer.cancel();
    super.dispose();
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
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Consumer<PrayerTimesProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading prayer times',
                      style: GoogleFonts.cairo(fontSize: 16, color: Colors.red),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'خطأ في تحميل أوقات الصلاة',
                      style: GoogleFonts.cairo(fontSize: 16, color: Colors.red),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      provider.errorMessage ?? 'خطأ غير معروف',
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Semantics(
                      button: true,
                      label: 'إعادة تحميل مواقيت الصلاة',
                      child: ElevatedButton(
                        onPressed: () {
                          provider.fetchTodayForCurrentLocation();
                        },
                        child: Text('Retry', style: GoogleFonts.cairo()),
                      ),
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
      ),
    );
  }

  Widget _buildPrayerTimesContent(PrayerTimesProvider provider) {
    final prayerTimes = provider.getMainPrayerTimes();
    final now = DateTime.now();
    final formattedDate = '${now.day}/${now.month}/${now.year}';

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Next Prayer Card
          _buildNextPrayerCard(prayerTimes),
          const SizedBox(height: 24),
          // All Prayer Times
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Today\'s Prayer Times',
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formattedDate,
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'مواقيت الصلاة',
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 12),
                _buildPrayerTimesList(prayerTimes),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildNextPrayerCard(Map<String, String> prayerTimes) {
    final nextPrayerInfo = _getNextPrayer(prayerTimes);
    final nextPrayerName = nextPrayerInfo['name'] as String;
    final nextPrayerTime = nextPrayerInfo['time'] as String;
    final timeRemaining = nextPrayerInfo['remaining'] as String;

    return Container(
      margin: const EdgeInsets.all(16),
      height: 320,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.brown.shade800,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.amber.shade600.withValues(alpha: 0.8),
              Colors.brown.shade900.withValues(alpha: 0.95),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Next Prayer Label
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'الصلاة القادمة',
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                    letterSpacing: 1,
                  ),
                ),
              ),
              // Prayer Name and Time
              Column(
                children: [
                  Text(
                    'صلاة $nextPrayerName',
                    style: GoogleFonts.cairo(
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        nextPrayerTime,
                        style: GoogleFonts.cairo(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'في',
                            style: GoogleFonts.cairo(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70,
                            ),
                          ),
                          Text(
                            timeRemaining,
                            style: GoogleFonts.cairo(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrayerTimesList(Map<String, String> prayerTimes) {
    const arabicNames = {
      'Fajr': 'الفجر',
      'Sunrise': 'الشروق',
      'Dhuhr': 'الظهر',
      'Asr': 'العصر',
      'Maghrib': 'المغرب',
      'Isha': 'العشاء',
    };

    final nextPrayerInfo = _getNextPrayer(prayerTimes);
    final currentPrayerName = nextPrayerInfo['name'] as String;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: prayerTimes.length,
      itemBuilder: (context, index) {
        final entry = prayerTimes.entries.elementAt(index);
        final arabicName = arabicNames[entry.key] ?? entry.key;
        final isCurrentPrayer = arabicName == currentPrayerName;

        return _prayerTimeTile(
          prayerName: arabicName,
          prayerTime: entry.value,
          isNext: isCurrentPrayer,
        );
      },
    );
  }

  Widget _prayerTimeTile({
    required String prayerName,
    required String prayerTime,
    required bool isNext,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isNext
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
            : Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isNext
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)
              : Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          width: isNext ? 2 : 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            prayerName,
            style: GoogleFonts.cairo(
              fontSize: 16,
              fontWeight: isNext ? FontWeight.bold : FontWeight.w500,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isNext
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              prayerTime,
              style: GoogleFonts.cairo(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isNext
                    ? Colors.white
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Get next prayer information
  Map<String, dynamic> _getNextPrayer(Map<String, String> prayerTimes) {
    const englishOrder = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];
    const arabicNames = {
      'Fajr': 'الفجر',
      'Dhuhr': 'الظهر',
      'Asr': 'العصر',
      'Maghrib': 'المغرب',
      'Isha': 'العشاء',
    };

    final now = DateTime.now();
    DateTime? nextPrayerTime;
    String? nextPrayerNameEng;
    String? nextPrayerName;

    for (int i = 0; i < englishOrder.length; i++) {
      final prayerName = englishOrder[i];
      final timeStr = prayerTimes[prayerName];

      if (timeStr != null && timeStr != 'N/A') {
        final prayerDateTime = _parseTime(timeStr);
        if (prayerDateTime != null && prayerDateTime.isAfter(now)) {
          nextPrayerTime = prayerDateTime;
          nextPrayerNameEng = prayerName;
          nextPrayerName = arabicNames[prayerName];
          break;
        }
      }
    }

    // If no prayer found today, show first prayer of next day
    if (nextPrayerTime == null) {
      nextPrayerNameEng = englishOrder[0];
      nextPrayerName = arabicNames[englishOrder[0]]!;
      if (prayerTimes[nextPrayerNameEng] != null &&
          prayerTimes[nextPrayerNameEng] != 'N/A') {
        nextPrayerTime = _parseTime(
          prayerTimes[nextPrayerNameEng]!,
        )?.add(const Duration(days: 1));
      }
    }

    if (nextPrayerTime == null) {
      return {'name': 'الفجر', 'time': 'N/A', 'remaining': 'N/A'};
    }

    final timeRemaining = nextPrayerTime.difference(now);
    final hoursStr = timeRemaining.inHours.toString();
    final minutesStr = (timeRemaining.inMinutes % 60).toString();

    String remainingText = '';
    if (timeRemaining.inHours > 0) {
      remainingText = '$hoursStr ساعة و$minutesStr دقيقة';
    } else {
      remainingText = '$minutesStr دقيقة';
    }

    return {
      'name': nextPrayerName ?? 'الفجر',
      'time': _formatTimeForDisplay(nextPrayerTime),
      'remaining': remainingText,
    };
  }

  /// Parse time string to DateTime
  DateTime? _parseTime(String timeStr) {
    try {
      // Remove AM/PM markers from the formatted time
      final cleanTime = timeStr.replaceAll('ص', '').replaceAll('م', '').trim();
      final parts = cleanTime.split(':');

      if (parts.length < 2) return null;

      int hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      // Check if it's PM (after 12:00 already converted form)
      // Since the display format already handles AM/PM, we need to preserve the logic
      if (timeStr.contains('م')) {
        if (hour != 12) hour += 12;
      } else {
        if (hour == 12) hour = 0;
      }

      final now = DateTime.now();
      return DateTime(now.year, now.month, now.day, hour, minute);
    } catch (e) {
      return null;
    }
  }

  /// Format time for display
  String _formatTimeForDisplay(DateTime time) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }
}
