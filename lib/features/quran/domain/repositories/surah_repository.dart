import '../entities/surah_entity.dart';

/// Surah Repository Interface
///
/// Abstract interface for Surah repository operations
abstract class SurahRepository {
  /// Get all Surahs
  Future<List<SurahEntity>> getAllSurahs();

  /// Get a specific Surah by index
  Future<SurahEntity> getSurahByIndex(int index);

  /// Search Surahs by name
  Future<List<SurahEntity>> searchSurahs(String query);

  /// Get Surahs by revelation place
  Future<List<SurahEntity>> getSurahsByRevelationPlace(String place);

  /// Get Surah statistics
  Future<Map<String, dynamic>> getSurahStatistics();

  /// Clear cached Surah data
  Future<void> clearCache();
}
