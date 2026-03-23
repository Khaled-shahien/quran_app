import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import '../../../../core/errors/api_exception.dart';
import '../models/ayah_model.dart';

/// Local Quran Data Source
///
/// Handles reading and parsing Quran verses from local assets
class LocalQuranDataSource {
  static const String _assetsPath = 'assets/ayaat';

  /// Reads the Quran verses for a specific Surah from the assets folder
  ///
  /// Parameters:
  /// - [surahNumber]: The Surah number (1-114)
  ///
  /// Returns: Future<List<AyahModel>>
  /// Throws: ApiException if the file cannot be read or parsed
  Future<List<AyahModel>> getAyahsForSurah(int surahNumber) async {
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

  /// Reads all Surahs' verses from the assets folder
  ///
  /// Returns: Future<Map<int, List<AyahModel>>>
  /// Where the key is the Surah number and the value is the list of Ayahs
  Future<Map<int, List<AyahModel>>> getAllAyahs() async {
    try {
      final allAyahs = <int, List<AyahModel>>{};

      // Process all 114 Surahs
      for (int surahNumber = 1; surahNumber <= 114; surahNumber++) {
        try {
          final ayahs = await getAyahsForSurah(surahNumber);
          allAyahs[surahNumber] = ayahs;
        } catch (e) {
          // Continue processing other Surahs even if one fails
          debugPrint('Warning: Could not load verses for Surah $surahNumber: $e');
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
        sajda: false, // Default to false, as this info is not in the text files
      );

      ayahs.add(ayah);
    }

    return ayahs;
  }

  // Helper methods to estimate metadata based on Surah and Ayah numbers
  // These are approximate values, as the actual metadata is not available in the text files

  /// Estimates Juz number for a given Surah and Ayah
  int _getJuzForAyah(int surahNumber, int ayahNumber) {
    // This is a simplified estimation - in a real app, you'd use actual Juz boundaries
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
    return 21; // Remaining Surahs
  }

  /// Estimates Manzil number for a given Surah and Ayah
  int _getManzilForAyah(int surahNumber, int ayahNumber) {
    return ((surahNumber - 1) ~/ 19) + 1;
  }

  /// Estimates Page number for a given Surah and Ayah
  int _getPageForAyah(int surahNumber, int ayahNumber) {
    // Simplified calculation - in reality, this would depend on actual Quran page divisions
    if (surahNumber <= 2) return 1;
    if (surahNumber <= 4) return 2;
    if (surahNumber <= 7) return 3;
    if (surahNumber <= 10) return 4;
    if (surahNumber <= 13) return 5;
    if (surahNumber <= 17) return 6;
    if (surahNumber <= 21) return 7;
    if (surahNumber <= 25) return 8;
    if (surahNumber <= 29) return 9;
    if (surahNumber <= 33) return 10;
    if (surahNumber <= 37) return 11;
    if (surahNumber <= 41) return 12;
    if (surahNumber <= 45) return 13;
    if (surahNumber <= 49) return 14;
    if (surahNumber <= 53) return 15;
    if (surahNumber <= 57) return 16;
    if (surahNumber <= 61) return 17;
    if (surahNumber <= 65) return 18;
    if (surahNumber <= 69) return 19;
    if (surahNumber <= 73) return 20;
    if (surahNumber <= 77) return 21;
    if (surahNumber <= 81) return 22;
    if (surahNumber <= 85) return 23;
    if (surahNumber <= 89) return 24;
    if (surahNumber <= 93) return 25;
    if (surahNumber <= 97) return 26;
    if (surahNumber <= 101) return 27;
    if (surahNumber <= 105) return 28;
    if (surahNumber <= 109) return 29;
    return 30;
  }

  /// Estimates Ruku number for a given Surah and Ayah
  int _getRukuForAyah(int surahNumber, int ayahNumber) {
    // Simplified calculation
    return ((ayahNumber - 1) ~/ 10) + 1;
  }

  /// Estimates Hizb Quarter number for a given Surah and Ayah
  int _getHizbQuarterForAyah(int surahNumber, int ayahNumber) {
    // Simplified calculation
    return ((ayahNumber - 1) ~/ 25) + 1;
  }
}
