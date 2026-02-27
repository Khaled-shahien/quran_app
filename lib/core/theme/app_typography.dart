import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTypography {
  // Display styles
  static TextStyle displayLarge = GoogleFonts.cairo(
    fontSize: 57,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
  );

  static TextStyle displayMedium = GoogleFonts.cairo(
    fontSize: 45,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  static TextStyle displaySmall = GoogleFonts.cairo(
    fontSize: 36,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  // Headline styles
  static TextStyle headlineLarge = GoogleFonts.cairo(
    fontSize: 32,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  static TextStyle headlineMedium = GoogleFonts.cairo(
    fontSize: 28,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  static TextStyle headlineSmall = GoogleFonts.cairo(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  // Title styles
  static TextStyle titleLarge = GoogleFonts.cairo(
    fontSize: 22,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
  );

  static TextStyle titleMedium = GoogleFonts.cairo(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  static TextStyle titleSmall = GoogleFonts.cairo(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  // Body styles
  static TextStyle bodyLarge = GoogleFonts.cairo(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
  );

  static TextStyle bodyMedium = GoogleFonts.cairo(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
  );

  static TextStyle bodySmall = GoogleFonts.cairo(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
  );

  // Label styles
  static TextStyle labelLarge = GoogleFonts.cairo(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  static TextStyle labelMedium = GoogleFonts.cairo(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  static TextStyle labelSmall = GoogleFonts.cairo(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );
}
