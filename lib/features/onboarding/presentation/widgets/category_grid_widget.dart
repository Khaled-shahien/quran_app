import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../quran/presentation/screens/tasbeeh_screen.dart';
import '../../../quran/presentation/screens/asma_al_husna_screen.dart';
import '../../../quran/presentation/screens/quran_screen.dart';

class CategoryGridWidget extends StatelessWidget {
  const CategoryGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.8,
        ),
        delegate: SliverChildListDelegate([
          _catCard('الأدعية', 'assets/images/الادعيه.png'),
          _catCard(
            'التسبيح',
            'assets/images/التسبيح_الالكتروني.png',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TasbeehScreen()),
            ),
          ),
          _catCard(
            'الأسماء',
            'assets/images/اسماء_الله_الحسني.png',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AsmaAlHusnaScreen(),
              ),
            ),
          ),
          _catCard(
            'القرآن',
            'assets/images/القران.png',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const QuranScreen()),
            ),
          ),
          _catCard('الأذكار', 'assets/images/الاذكار.png'),
          _catCard('الأحاديث', 'assets/images/الاحاديث.png'),
        ]),
      ),
    );
  }

  Widget _catCard(
    String title,
    String imagePath, {
    VoidCallback? onTap,
  }) => GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        color: AppColors.lightSecondary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, width: 40, height: 40, fit: BoxFit.contain),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  );
}
