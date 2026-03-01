import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../prayers/presentation/providers/prayer_times_performance_provider.dart';

class HeaderCardWidget extends StatelessWidget {
  const HeaderCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PrayerTimesPerformanceProvider>(
      builder: (context, provider, child) {
        final prayerData = provider.getCurrentAndNextPrayer();
        final currentName = prayerData['currentName'] ?? '---';
        final currentTime = prayerData['currentTime'] ?? '--:--';
        final nextName = prayerData['nextName'] ?? '---';
        final nextTime = prayerData['nextTime'] ?? '--:--';

        return Container(
          margin: const EdgeInsets.all(16),
          height: 160,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(25),
            image: const DecorationImage(
              image: NetworkImage(
                'https://i.imgur.com/your_asset.png',
              ), // صورة المصحف والسبحة
              alignment: Alignment.centerLeft,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentName,
                  style: GoogleFonts.cairo(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text(
                  currentTime,
                  style: GoogleFonts.cairo(
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const Spacer(),
                Text(
                  'الصلاة التالية: $nextName',
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text(
                  nextTime,
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
