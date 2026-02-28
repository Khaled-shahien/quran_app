import '../entities/ayah_entity.dart';

/// Ayah Repository Interface
///
/// Abstract interface for Ayah repository operations
abstract class AyahRepository {
  /// Get all Ayahs for a specific Surah
  Future<List<AyahEntity>> getAyahsForSurah(int surahNumber);

  /// Get a specific Ayah by Surah number and Ayah number
  Future<AyahEntity> getAyah(int surahNumber, int ayahNumber);

  /// Get all Ayahs for all Surahs
  Future<Map<int, List<AyahEntity>>> getAllAyahs();

  /// Search Ayahs containing the query text
  Future<List<AyahEntity>> searchAyahs(String query);
}
