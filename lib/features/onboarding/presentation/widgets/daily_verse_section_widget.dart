import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class DailyVerseSectionWidget extends StatelessWidget {
  const DailyVerseSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الآيات اليومية',
                style: GoogleFonts.cairo(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'سورة الفاتحة',
                style: GoogleFonts.cairo(
                  color: AppColors.lightPrimary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: BorderRadius.circular(20),
            border: const Border(
              right: BorderSide(color: AppColors.accent, width: 6),
            ),
          ),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Icon(Icons.favorite_outline, color: Colors.white70),
              ),
              Text(
                'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
                style: GoogleFonts.amiri(
                  fontSize: 26,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'All praise and thanks be to the Lord of the worlds.',
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(color: Colors.white70),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        _buildDotsIndicator(),
      ],
    );
  }

  Widget _buildDotsIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) => _dot(index == 0)).toList(),
    );
  }

  Widget _dot(bool isActive) => AnimatedContainer(
    duration: const Duration(milliseconds: 300),
    margin: const EdgeInsets.symmetric(horizontal: 4),
    width: isActive ? 10 : 6,
    height: 6,
    decoration: BoxDecoration(
      color: isActive
          ? AppColors.lightPrimary
          : AppColors.lightPrimary.withValues(alpha: 0.4),
      borderRadius: BorderRadius.circular(12),
    ),
  );
}
