import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class HeaderCardWidget extends StatelessWidget {
  const HeaderCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 160,
      decoration: BoxDecoration(
        color: AppColors.lightSecondary,
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
              'الظهر',
              style: GoogleFonts.cairo(color: AppColors.lightPrimary),
            ),
            Text(
              '11:45 م',
              style: GoogleFonts.cairo(
                fontSize: 34,
                fontWeight: FontWeight.w900,
                color: AppColors.lightPrimary,
              ),
            ),
            const Spacer(),
            Text(
              'الصلاة التالية: العصر',
              style: GoogleFonts.cairo(
                fontSize: 12,
                color: AppColors.lightPrimary,
              ),
            ),
            Text(
              '2:50 مساءً',
              style: GoogleFonts.cairo(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.lightPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
