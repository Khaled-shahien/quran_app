import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../quran/presentation/screens/surah_details_screen.dart';
import '../../../quran/domain/entities/surah_entity.dart';
import 'package:provider/provider.dart';
import '../../../khatma/presentation/providers/khatma_provider.dart';
import '../../../khatma/presentation/screens/khatma_location_screen.dart';

class CurrentWirdWidget extends StatelessWidget {
  const CurrentWirdWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Colors from the design
    final Color cardBgColor = isDarkMode
        ? AppColors.darkCardContent
        : Colors.white;
    final Color accentYellow = isDarkMode
        ? AppColors.darkSecondary
        : const Color(0xFFF9D030); // Yellow button
    final Color finishedBtnText = isDarkMode ? Colors.white : Colors.black87;
    final Color textDark = isDarkMode ? Colors.white : const Color(0xFF4A4A4A);
    final Color dividerColor = isDarkMode
        ? AppColors.darkGray
        : const Color(0xFFE5E5E5);
    final Color primaryColor = Theme.of(context).colorScheme.primary;

    return Consumer<KhatmaProvider>(
      builder: (context, khatmaProvider, child) {
        final activeKhatma = khatmaProvider.activeKhatma;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Section Title
              Text(
                'الورد الحالي',
                style: GoogleFonts.cairo(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 12),

              if (activeKhatma != null) ...[
                // Main Card
                Container(
                  decoration: BoxDecoration(
                    color: cardBgColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Top Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'من قوله تعالى',
                              style: GoogleFonts.cairo(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: textDark,
                              ),
                            ),
                            Text(
                              'الجزء ${activeKhatma.currentJuz}',
                              style: GoogleFonts.cairo(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Arabic Verse Text
                        Text(
                          'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                          style: GoogleFonts.amiri(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: textDark,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),

                        // Details Row 1 (Start)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'بدء الختمة: ${activeKhatma.startMode}',
                              style: GoogleFonts.cairo(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                            Text(
                              '${activeKhatma.amountValue} / يوم',
                              style: GoogleFonts.cairo(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Action Buttons
                        Row(
                          children: [
                            // Finished Button (Yellow)
                            Expanded(
                              flex: 1,
                              child: ElevatedButton(
                                onPressed: () {
                                  khatmaProvider.markCurrentWirdAsFinished();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'تم حفظ تقدمك بنجاح. تقبل الله طاعتك!',
                                        style: GoogleFonts.cairo(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      backgroundColor: Colors.green,
                                      behavior: SnackBarBehavior.floating,
                                      duration: const Duration(seconds: 3),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: accentYellow,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 0,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.chevron_left,
                                      color: finishedBtnText,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'أتممت القراءة',
                                      style: GoogleFonts.cairo(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: finishedBtnText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Read Button (Green)
                            Expanded(
                              flex: 1,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Navigation to exact Ayah/Juz
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SurahDetailsScreen(
                                        surah: SurahEntity(
                                          number: 1,
                                          name: 'البقرة',
                                          englishName: 'Al-Baqara',
                                          englishNameTranslation: 'The Cow',
                                          revelationType: 'Medinan',
                                          totalAyah: 286,
                                        ),
                                        surahNumber: 2,
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  'اقرأ الورد',
                                  style: GoogleFonts.cairo(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                Divider(color: dividerColor, thickness: 1),
                const SizedBox(height: 16),

                // Khatma Details (Progress Section)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'الختمة الحالية',
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textDark,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    IconButton(
                      icon: const Icon(Icons.cancel, color: Colors.red),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(
                              'إلغاء الختمة',
                              style: GoogleFonts.cairo(),
                            ),
                            content: Text(
                              'هل أنت متأكد من إلغاء الختمة الحالية؟',
                              style: GoogleFonts.cairo(),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  'تراجع',
                                  style: GoogleFonts.cairo(),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  khatmaProvider.cancelKhatma();
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'نعم، إلغاء',
                                  style: GoogleFonts.cairo(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Progress Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: activeKhatma.durationDays > 0
                        ? (activeKhatma.completedDays /
                                  activeKhatma.durationDays)
                              .clamp(0.0, 1.0)
                        : 0.0,
                    minHeight: 12,
                    backgroundColor: dividerColor,
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  ),
                ),
                const SizedBox(height: 12),

                // Progress Stats
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'الأيام القادمة: ${activeKhatma.durationDays - activeKhatma.completedDays}',
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: textDark,
                      ),
                    ),
                    Text(
                      'الأيام السابقة: ${activeKhatma.completedDays}',
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: textDark,
                      ),
                    ),
                  ],
                ),
              ] else ...[
                // Empty State (No Active Khatma)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: cardBgColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: dividerColor),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.menu_book,
                        size: 48,
                        color: primaryColor.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'لا توجد ختمة نشطة حالياً',
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'ابدأ ختمة جديدة وتابع وردك اليومي بسهولة',
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          color: textDark.withValues(alpha: 0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const KhatmaLocationScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'ابدأ ختمة جديدة',
                          style: GoogleFonts.cairo(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
