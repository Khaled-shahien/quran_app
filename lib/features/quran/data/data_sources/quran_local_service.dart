import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import '../../../../core/errors/api_exception.dart';
import '../models/ayah_model.dart';

/// Quran Local Service
///
/// Integrates local Quran verses from assets with the existing Surah data structure
class QuranLocalService {
  static const String _assetsPath = 'assets/ayaat';

  /// Loads the Quran verses for a specific Surah from the assets folder
  ///
  /// Parameters:
  /// - [surahNumber]: The Surah number (1-114)
  ///
  /// Returns: Future<List<AyahModel>>
  /// Throws: ApiException if the file cannot be read or parsed
  Future<List<AyahModel>> loadAyahsForSurah(int surahNumber) async {
    try {
      if (surahNumber < 1 || surahNumber > 114) {
        throw ApiException(
          message: 'Invalid Surah number: $surahNumber',
          code: 400,
        );
      }

      // Build the file path
      final fileName = '$surahNumber.txt';
      final filePath = path.join(_assetsPath, fileName);

      // Read the file content
      String content;
      try {
        content = await rootBundle.loadString(filePath);
      } catch (e) {
        throw ApiException(
          message:
              'Could not find verses file for Surah $surahNumber at $filePath',
          code: 404,
        );
      }

      // Parse the content into Ayah models
      final ayahs = _parseAyahs(content, surahNumber);

      return ayahs;
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Error reading verses for Surah $surahNumber: ${e.toString()}',
        code: 500,
      );
    }
  }

  /// Loads all Surahs' verses from the assets folder
  ///
  /// Returns: Future<Map<int, List<AyahModel>>>
  /// Where the key is the Surah number and the value is the list of Ayahs
  Future<Map<int, List<AyahModel>>> loadAllAyahs() async {
    try {
      final allAyahs = <int, List<AyahModel>>{};

      // Process all 114 Surahs
      for (int surahNumber = 1; surahNumber <= 114; surahNumber++) {
        try {
          final ayahs = await loadAyahsForSurah(surahNumber);
          allAyahs[surahNumber] = ayahs;
        } catch (e) {
          // Continue processing other Surahs even if one fails
          print('Warning: Could not load verses for Surah $surahNumber: $e');
        }
      }

      return allAyahs;
    } catch (e) {
      throw ApiException(
        message: 'Error reading all Quran verses: ${e.toString()}',
        code: 500,
      );
    }
  }

  /// Parses the content of a Surah file into Ayah models
  ///
  /// Parameters:
  /// - [content]: The raw text content of the Surah file
  /// - [surahNumber]: The Surah number this content belongs to
  ///
  /// Returns: List<AyahModel>
  List<AyahModel> _parseAyahs(String content, int surahNumber) {
    final lines = LineSplitter.split(content).toList();
    final ayahs = <AyahModel>[];

    for (int i = 0; i < lines.length; i++) {
      final trimmedLine = lines[i].trim();
      if (trimmedLine.isEmpty) continue;

      // Create an Ayah model for each line
      // We'll assign default values for metadata that's not available in the text files
      final ayah = AyahModel(
        number: i + 1, // Sequential numbering based on line position
        text: trimmedLine,
        numberInSurah: i + 1,
        juz: _getJuzForAyah(surahNumber, i + 1),
        manzil: _getManzilForAyah(surahNumber, i + 1),
        page: _getPageForAyah(surahNumber, i + 1),
        ruku: _getRukuForAyah(surahNumber, i + 1),
        hizbQuarter: _getHizbQuarterForAyah(surahNumber, i + 1),
        sajda: _getSajdaForAyah(surahNumber, i + 1),
      );

      ayahs.add(ayah);
    }

    return ayahs;
  }

  // Helper methods to estimate metadata based on Surah and Ayah numbers
  // These are approximate values, as the actual metadata is not available in the text files

  /// Estimates Juz number for a given Surah and Ayah
  int _getJuzForAyah(int surahNumber, int ayahNumber) {
    // Standard Juz division in the Quran
    if (surahNumber == 2 && ayahNumber >= 142) return 3;
    if (surahNumber == 2 && ayahNumber >= 178) return 4;
    if (surahNumber == 2 && ayahNumber >= 253) return 5;
    if (surahNumber == 3 && ayahNumber >= 93) return 6;
    if (surahNumber == 4 && ayahNumber >= 24) return 7;
    if (surahNumber == 4 && ayahNumber >= 148) return 8;
    if (surahNumber == 6 && ayahNumber >= 111) return 9;
    if (surahNumber == 7 && ayahNumber >= 88) return 10;
    if (surahNumber == 9 && ayahNumber >= 93) return 11;
    if (surahNumber == 11 && ayahNumber >= 6) return 12;
    if (surahNumber == 12 && ayahNumber >= 53) return 13;
    if (surahNumber == 14 && ayahNumber >= 53) return 14;
    if (surahNumber == 16 && ayahNumber >= 129) return 15;
    if (surahNumber == 18 && ayahNumber >= 75) return 16;
    if (surahNumber == 20 && ayahNumber >= 135) return 17;
    if (surahNumber == 22 && ayahNumber >= 79) return 18;
    if (surahNumber == 25 && ayahNumber >= 21) return 19;
    if (surahNumber == 27 && ayahNumber >= 56) return 20;
    if (surahNumber == 29 && ayahNumber >= 46) return 21;
    if (surahNumber == 33 && ayahNumber >= 31) return 22;
    if (surahNumber == 36 && ayahNumber >= 28) return 23;
    if (surahNumber == 39 && ayahNumber >= 32) return 24;
    if (surahNumber == 41 && ayahNumber >= 47) return 25;
    if (surahNumber == 45 && ayahNumber >= 40) return 26;
    if (surahNumber == 48 && ayahNumber >= 29) return 27;
    if (surahNumber == 57 && ayahNumber >= 29) return 28;
    if (surahNumber == 67 && ayahNumber >= 13) return 29;
    if (surahNumber >= 78) return 30;

    // Default Juz assignments based on Surah numbers
    if (surahNumber <= 2) return 1;
    if (surahNumber <= 4) return 2;
    if (surahNumber <= 6) return 3;
    if (surahNumber <= 9) return 4;
    if (surahNumber <= 12) return 5;
    if (surahNumber <= 16) return 6;
    if (surahNumber <= 21) return 7;
    if (surahNumber <= 26) return 8;
    if (surahNumber <= 33) return 9;
    if (surahNumber <= 40) return 10;
    if (surahNumber <= 47) return 11;
    if (surahNumber <= 54) return 12;
    if (surahNumber <= 61) return 13;
    if (surahNumber <= 68) return 14;
    if (surahNumber <= 77) return 15;
    if (surahNumber <= 84) return 16;
    if (surahNumber <= 90) return 17;
    if (surahNumber <= 97) return 18;
    if (surahNumber <= 104) return 19;
    if (surahNumber <= 110) return 20;
    if (surahNumber <= 114) return 30;

    return 1; // Default fallback
  }

  /// Estimates Manzil number for a given Surah and Ayah
  int _getManzilForAyah(int surahNumber, int ayahNumber) {
    return ((surahNumber - 1) ~/ 19) + 1;
  }

  /// Estimates Page number for a given Surah and Ayah
  int _getPageForAyah(int surahNumber, int ayahNumber) {
    // Standard Quran page numbers (based on Madani Mushaf)
    if (surahNumber == 1) return 1;
    if (surahNumber == 2) {
      if (ayahNumber <= 141) return 2;
      if (ayahNumber <= 252) return 25;
      return 37;
    }
    if (surahNumber == 3) return 49;
    if (surahNumber == 4) return 60;
    if (surahNumber == 5) return 77;
    if (surahNumber == 6) return 92;
    if (surahNumber == 7) return 106;
    if (surahNumber == 8) return 121;
    if (surahNumber == 9) return 127;
    if (surahNumber == 10) return 143;
    if (surahNumber == 11) return 151;
    if (surahNumber == 12) return 163;
    if (surahNumber == 13) return 170;
    if (surahNumber == 14) return 177;
    if (surahNumber == 15) return 182;
    if (surahNumber == 16) return 187;
    if (surahNumber == 17) return 195;
    if (surahNumber == 18) return 207;
    if (surahNumber == 19) return 215;
    if (surahNumber == 20) return 221;
    if (surahNumber == 21) return 230;
    if (surahNumber == 22) return 235;
    if (surahNumber == 23) return 240;
    if (surahNumber == 24) return 245;
    if (surahNumber == 25) return 250;
    if (surahNumber == 26) return 255;
    if (surahNumber == 27) return 262;
    if (surahNumber == 28) return 267;
    if (surahNumber == 29) return 273;
    if (surahNumber == 30) return 278;
    if (surahNumber == 31) return 282;
    if (surahNumber == 32) return 284;
    if (surahNumber == 33) return 287;
    if (surahNumber == 34) return 293;
    if (surahNumber == 35) return 297;
    if (surahNumber == 36) return 302;
    if (surahNumber == 37) return 307;
    if (surahNumber == 38) return 312;
    if (surahNumber == 39) return 316;
    if (surahNumber == 40) return 322;
    if (surahNumber == 41) return 328;
    if (surahNumber == 42) return 334;
    if (surahNumber == 43) return 340;
    if (surahNumber == 44) return 346;
    if (surahNumber == 45) return 350;
    if (surahNumber == 46) return 354;
    if (surahNumber == 47) return 359;
    if (surahNumber == 48) return 363;
    if (surahNumber == 49) return 367;
    if (surahNumber == 50) return 371;
    if (surahNumber == 51) return 374;
    if (surahNumber == 52) return 376;
    if (surahNumber == 53) return 378;
    if (surahNumber == 54) return 382;
    if (surahNumber == 55) return 384;
    if (surahNumber == 56) return 386;
    if (surahNumber == 57) return 389;
    if (surahNumber == 58) return 394;
    if (surahNumber == 59) return 397;
    if (surahNumber == 60) return 400;
    if (surahNumber == 61) return 403;
    if (surahNumber == 62) return 405;
    if (surahNumber == 63) return 407;
    if (surahNumber == 64) return 409;
    if (surahNumber == 65) return 411;
    if (surahNumber == 66) return 413;
    if (surahNumber == 67) return 415;
    if (surahNumber == 68) return 417;
    if (surahNumber == 69) return 420;
    if (surahNumber == 70) return 422;
    if (surahNumber == 71) return 424;
    if (surahNumber == 72) return 426;
    if (surahNumber == 73) return 428;
    if (surahNumber == 74) return 430;
    if (surahNumber == 75) return 432;
    if (surahNumber == 76) return 434;
    if (surahNumber == 77) return 436;
    if (surahNumber == 78) return 438;
    if (surahNumber == 79) return 440;
    if (surahNumber == 80) return 441;
    if (surahNumber == 81) return 443;
    if (surahNumber == 82) return 444;
    if (surahNumber == 83) return 445;
    if (surahNumber == 84) return 446;
    if (surahNumber == 85) return 447;
    if (surahNumber == 86) return 448;
    if (surahNumber == 87) return 449;
    if (surahNumber == 88) return 450;
    if (surahNumber == 89) return 451;
    if (surahNumber == 90) return 452;
    if (surahNumber == 91) return 453;
    if (surahNumber == 92) return 454;
    if (surahNumber == 93) return 455;
    if (surahNumber == 94) return 456;
    if (surahNumber == 95) return 456;
    if (surahNumber == 96) return 457;
    if (surahNumber == 97) return 458;
    if (surahNumber == 98) return 459;
    if (surahNumber == 99) return 460;
    if (surahNumber == 100) return 461;
    if (surahNumber == 101) return 462;
    if (surahNumber == 102) return 462;
    if (surahNumber == 103) return 463;
    if (surahNumber == 104) return 463;
    if (surahNumber == 105) return 464;
    if (surahNumber == 106) return 464;
    if (surahNumber == 107) return 465;
    if (surahNumber == 108) return 465;
    if (surahNumber == 109) return 466;
    if (surahNumber == 110) return 466;
    if (surahNumber == 111) return 467;
    if (surahNumber == 112) return 467;
    if (surahNumber == 113) return 468;
    if (surahNumber == 114) return 468;

    return 1; // Default fallback
  }

  /// Estimates Ruku number for a given Surah and Ayah
  int _getRukuForAyah(int surahNumber, int ayahNumber) {
    // Simplified calculation - actual Ruku divisions vary by Surah
    return ((ayahNumber - 1) ~/ 10) + 1;
  }

  /// Estimates Hizb Quarter number for a given Surah and Ayah
  int _getHizbQuarterForAyah(int surahNumber, int ayahNumber) {
    // Simplified calculation - actual Hizb quarters are fixed points in the Quran
    return ((ayahNumber - 1) ~/ 25) + 1;
  }

  /// Determines if an Ayah has Sajda (prostration) - simplified
  bool _getSajdaForAyah(int surahNumber, int ayahNumber) {
    // Known Ayahs of Sajda in the Quran
    final sajdaAyahs = {
      7: 206, // Al-A'raf
      13: 15, // Ar-Ra'd
      16: 50, // An-Nahl
      17: 109, // Al-Isra'
      19: 58, // Maryam
      22: 18, // Al-Hajj
      22: 77, // Al-Hajj
      25: 60, // Al-Furqan
      27: 25, // An-Naml
      32: 15, // As-Sajdah
      38: 24, // Sad
      41: 38, // Fussilat
      53: 62, // An-Najm
      84: 21, // Al-Inshiqaq
      96: 19, // Al-'Alaq
    };

    return sajdaAyahs[surahNumber] == ayahNumber;
  }
}
