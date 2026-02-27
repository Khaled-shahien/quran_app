import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class AsmaItemCard extends StatelessWidget {
  final String number;
  final String arabicName;
  final String meaning;

  const AsmaItemCard({
    super.key,
    required this.number,
    required this.arabicName,
    required this.meaning,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.lightSecondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: AppColors.lightPrimary, width: 1),
      ),
      elevation: 2,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.lightSecondary,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.lightPrimary, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.lightPrimary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    number,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                arabicName,
                textAlign: TextAlign.center,
                style: GoogleFonts.amiri(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                meaning,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.secondaryText,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
